require 'rubygems'
require 'bundler'
Bundler.require
$stdout.sync = true
require 'sinatra'
require 'sinatra/cometio'
require File.dirname(__FILE__)+'/main'

run TestApp
