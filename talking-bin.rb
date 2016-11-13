#!/usr/bin/env ruby

require 'yaml'
require 'random/online'
require 'net/http'
require 'digest'
require 'uri'

GT_URL="http://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=$1&tl=En-us"

lines = YAML.load(File.read("lines.yml"))
generator = RealRand::RandomOrg.new
rand_data = generator.randnum(1000, 0, lines.count - 1)
rand_data_pos = 0

def refresh_rand_data
	rand_data = generator.randnum(1000, 0, lines.count - 1)
	rand_data_pos = 0
end

def cached?(key)
	return File.file?("cache/#{key}.wav")
end

def fill_cache(text)
	url = GT_URL.gsub(/\$1/, text)
	data = Net::HTTP.get(URI(URI.escape(url)))
	key = Digest::SHA256.hexdigest(text)

	File.open("cache/#{key}.wav", 'w') do |f|
		f.write(data)
	end
end

loop do
	puts lines[rand_data[rand_data_pos]]
	key = Digest::SHA256.hexdigest(lines[rand_data[rand_data_pos]])

	if !cached?(key)
		fill_cache(lines[rand_data[rand_data_pos]])
	end

	system("/usr/bin/mplayer -ao alsa -really-quiet -noconsolecontrols cache/#{key}.wav")

	rand_data_pos = rand_data_pos + 1
	if rand_data_pos > rand_data.size
		refresh_rand_data
	end

	sleep 10
end
