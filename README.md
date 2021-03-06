em-cometio-client
=================
[Sinatra CometIO](https://github.com/shokai/sinatra-cometio) Client for eventmachine

* https://github.com/shokai/em-cometio-client


Installation
------------

    % gem install em-cometio-client


Usage
-----

```ruby
require 'eventmachine'
require 'em-cometio-client'

EM::run do
  client = EM::CometIO::Client.new('http://localhost:5000/cometio/io').connect

  client.timeout = 120  # comet-get timeout

  client.on :connect do |session|
    puts "connect!! (sessin_id:#{session})"
  end

  client.on :error do |err|
    STDERR.puts err
  end

  ## regist receive "chat" event
  client.on :chat do |data|
    puts "#{data['name']} - #{data['message']}"
  end

  ## push "chat" event to Server
  EM::add_periodic_timer 10 do
    client.push :chat, {:message => Time.now.to_s, :name => 'clock'}
  end
end
```

Sample
------

start [chat server](https://github.com/shokai/cometio-chat-sample)

    % git clone git://github.com/shokai/cometio-chat-sample.git
    % cd cometio-chat-sample
    % bundle install
    % foreman start

=> http://localhost:5000


sample chat client

    % ruby sample/cui_chat_client.rb


Test
----

    % gem install bundler
    % bundle install

start server

    % bundle exec rake test_server

test

    % bundle exec rake test


Contributing
------------
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
