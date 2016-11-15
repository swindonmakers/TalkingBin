#!/usr/bin/env ruby

require 'webrick'

$:.unshift File.dirname(__FILE__)
require 'app'

root = File.join(File.expand_path(File.dirname(__FILE__)), "wwwroot")
server = WEBrick::HTTPServer.new :Port => 8000, :DocumentRoot => root

trap 'INT' do server.shutdown end

server.mount '/', TalkingBin::App

TalkingBin::PhraseManager.instance.load

server.start
