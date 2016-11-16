#!/usr/bin/env ruby

require 'webrick'

$:.unshift File.dirname(__FILE__)
require 'app'

config = TalkingBin::Config.instance
config.load

root = File.join(File.expand_path(File.dirname(__FILE__)), "wwwroot")
server = WEBrick::HTTPServer.new :Port => config.get('listen_port'), :BindAddress => config.get('bind_address'), :DocumentRoot => root

trap 'INT' do server.shutdown end

server.mount '/', TalkingBin::App

server.start
