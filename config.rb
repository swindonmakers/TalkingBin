require 'singleton'

module TalkingBin
	class Config
		include Singleton

		def load
 			@data = YAML.load(File.read(File.join(File.dirname(__FILE__), "config.yml")))
		end

		def get(key)
			return @data[key]
		end
	end
end
