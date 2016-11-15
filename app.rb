require 'yaml'
require 'cache'
require 'phrase_manager'
require 'config'

module TalkingBin
  class App < WEBrick::HTTPServlet::AbstractServlet
	  def do_GET request, response
 			@cache = Cache.instance
 			
 			saying = PhraseManager.instance.get_random
 
 			response.status = 200
 			response['Content-Type'] = 'text/plain'
 			response.body = saying
 
 			filename = @cache.get(saying)
 
 			pid = spawn("/usr/bin/mplayer -ao alsa -really-quiet -noconsolecontrols #{filename}")
			Process.detach(pid)
		end
	end
end
