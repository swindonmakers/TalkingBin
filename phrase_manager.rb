require 'singleton'

module TalkingBin
	class PhraseManager
		include Singleton

		def load
 			@lines = YAML.load(File.read(File.join(File.dirname(__FILE__), "lines.yml")))
		end

		def get_random
 			return @lines[rand(@lines.count-1)]
		end
	end
end
