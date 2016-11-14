require 'yaml'
require 'cache'

module TalkingBin
  class App < WEBrick::HTTPServlet::AbstractServlet
	  def do_GET request, response
			@lines = YAML.load(File.read("lines.yml"))
			@cache = TalkingBin::Cache.instance
			
			saying = @lines[rand(@lines.count-1)]

			response.status = 200
			response['Content-Type'] = 'text/plain'
			response.body = saying

			filename = @cache.get(saying)

			system("/usr/bin/mplayer -ao alsa -really-quiet -noconsolecontrols #{filename}")
		end
	end
end
