require 'yaml'
require 'cache'
require 'phrase_manager'
require 'config'

module TalkingBin
  class App < WEBrick::HTTPServlet::AbstractServlet
	  def do_GET request, response

			if good_token?(request.query["token"])
  		  begin
     			@cache = Cache.instance	
  
          saying = PhraseManager.instance.get_random
   			  filename = @cache.get(saying)
   
  	 			pid = spawn("/usr/bin/mplayer -ao alsa -really-quiet -noconsolecontrols #{filename}")
  				Process.detach(pid)
   			
  				response.status = 200
  	 			response['Content-Type'] = 'text/plain'
  	 			response.body = saying
   			rescue Exception => e
  				response.status = 500
  	 			response['Content-Type'] = 'text/plain'
  				response.body = "Exception: #{e.message}"
  			end
			else
  				response.status = 401
  	 			response['Content-Type'] = 'text/plain'
  	 			response.body = "Access denied"
			end
		end

		private
		
		def good_token?(token)
			return (token == Config.instance.get("auth_token"))
		end
	end
end
