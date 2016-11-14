require 'net/http'
require 'digest'
require 'uri'
require 'singleton'

module TalkingBin
	class Cache
		include Singleton

		GT_URL="http://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=$1&tl=En-us"
		CACHE_PATH=File.join(File.expand_path(File.dirname(__FILE__)), "cache")

		def get(text)
			key = Digest::SHA256.hexdigest(text)

			if cached?(key)
				return get_file_path(key)
			else
				fill_cache(text, key)
				return get_file_path(key)
			end
		end
		
		private
		def get_file_path(key)
			return File.join(CACHE_PATH, "#{key}.wav")
		end

		def cached?(key)
			if File.size?(get_file_path(key)).nil?
				return nil
			else
				return true
			end
		end

		def fill_cache(text, key)
			url = GT_URL.gsub(/\$1/, text)
			data = Net::HTTP.get(URI(URI.escape(url)))

			File.open(get_wav_path(key), 'w') do |f|
				f.write(data)
			end
		end
	end
end
