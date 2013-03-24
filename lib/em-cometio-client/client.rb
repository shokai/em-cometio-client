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
      end

      def push(type, data)
        that = self
        http = EM::HttpRequest.new(@url, :connect_timeout => 10).
          post(:body => {:type => type, :data => data, :session => @session})
        http.callback do |res|
        end
        http.errback do |err|
          self.emit :error, "CometIO push error"
        end
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
