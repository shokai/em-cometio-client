module EventMachine
  module CometIO
    class Client
      include EventEmitter
      attr_reader :url, :session

      def initialize(url)
        raise ArgumentError, "invalid URL (#{url})" unless url.kind_of? String and url =~ /^https?:\/\/.+/
        @url = url
        @session = nil
        @running = false
      end

      def push(type, data)
        that = self
        http = EM::HttpRequest.new(@url, :connect_timeout => 60000).
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
        http = EM::HttpRequest.new("#{@url}?session=#{@session}", :connect_timeout => 60000).get
        http.callback do |res|
          begin
            data = JSON.parse res.response
            self.emit data['type'], data['data']
          rescue
            self.emit :error, "CometIO get error"
            sleep 10
          end
          get
        end
        http.errback do |err|
          self.emit :error, "CometIO get error"
          sleep 10
          get
        end
      end

    end
  end
end
