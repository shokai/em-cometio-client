require 'rubygems'
require 'bundler/setup'
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'minitest/autorun'
require 'em-cometio-client'
require File.expand_path 'app', File.dirname(__FILE__)

['SIGHUP', 'SIGINT', 'SIGKILL', 'SIGTERM'].each do |sig|
  Kernel.trap sig do
    App.stop
    EM::add_timer do
      EM::stop
    end
  end
end
