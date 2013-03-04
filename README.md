em-cometio-client
=================
[Sinatra CometIO](https://github.com/shokai/em-cometio-client) client for eventmachine

* https://github.com/shokai/em-cometio-client


Installation
------------

    % gem install em-cometio-client


Usage
-----

EM::CometIO::Client usage
```ruby
require 'eventmachine'
require 'em-cometio-client'

EM::run do
  client = EM::CometIO::Client.new('http://localhost:5000/cometio/io').connect

  client.on :connect do |session|
    puts "connect!! (sessin_id:#{session})"
  end

  client.on :foo do |data|
    puts data['message']  # => foobar
  end

  client.on :error do |err|
    STDERR.puts err
  end
end
```

Sinatra Side
```ruby
CometIO.push :foo {:message => 'foobar'}
```


Sample
------

start [chat server](https://github.com/shokai/em-cometio-client)

    % git clone git://github.com/shokai/cometio-chat-sample.git
    % cd cometio-chat-sample
    % bundle install
    % foreman start

=> http://localhost:5000


sample chat client

    % ruby sample/em_cui_chat_client.rb


Contributing
------------
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
