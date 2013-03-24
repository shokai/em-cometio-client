#!/usr/bin/env ruby
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'rubygems'
require 'em-cometio-client'

name = `whoami`.strip || 'shokai'
url = ARGV.shift || 'http://localhost:5000/cometio/io'

EM::run do
  client = EM::CometIO::Client.new(url).connect

  client.on :connect do |session|
    puts "connect!! (sessin_id:#{session})"
  end

  client.on :chat do |data|
    puts "<#{data['name']}> #{data['message']}"
  end

  client.on :error do |err|
    STDERR.puts err
  end

  EM::defer do
    loop do
      line = STDIN.gets.strip
      next if line.empty?
      client.push :chat, {:message => line, :name => name}
    end
  end
end
