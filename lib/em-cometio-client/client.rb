module EventMachine
  module CometIO
    class Client
      include EventEmitter
      attr_reader :url, :session
      attr_accessor :timeout

      def initialize(url)
        raise ArgumentError, "invalid URL (#{url})" unless url.kind_of? String and url =~ /^https?:\/\/.+/
        @url = url
        @session = nil
        @running = false
        @timeout = 120
        @post_queue = []
        EM::add_periodic_timer 1 do
          flush
        end
      end

      private
      def flush
        return if !@running or @post_queue.size < 1
        post_data = {:session => @session, :events => @post_queue}
        that = self
        http = EM::HttpRequest.new(@url, :connect_timeout => 10).
          post(:body => post_data)
        @post_queue = []
        http.callback do |res|
        end
        http.errback do |err|
          self.emit :error, "CometIO push error"
        end
      end

      public
      def push(type, data)
        if !@running or !@session
          emit :error, "CometIO not connected"
          return
        end
        @post_queue.push :type => type, :data => data
      end

      def connect
        return self if @running
        self.on :__session_id do |session|
          @session = session
          self.emit :connect, @session
        end
        @running = true
        get
        return self
      end

      def close
        @running = false
        self.remove_listener :__session_id
      end

      private
      def get
        http = EM::HttpRequest.new("#{@url}?session=#{@session}", :connect_timeout => @timeout).get
        http.callback do |res|
          begin
            data_arr = JSON.parse res.response
            data_arr = [data_arr] unless data_arr.kind_of? Array
            data_arr.each do |data|
              self.emit data['type'], data['data']
            end
          rescue JSON::ParserError
          rescue StandardError
            self.emit :error, "CometIO get error"
            sleep 10
          end
          get
        end
        http.errback do |err|
          get
        end
      end

    end
  end
end
