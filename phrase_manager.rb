require 'singleton'

module TalkingBin
	class PhraseManager
		include Singleton

		def get_random
			lines = Config.instance.get("phrases")
 			return lines[rand(lines.count-1)]
		end
	end
end
