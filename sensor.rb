require 'rubygems'
#require 'bundler'
require 'em-websocket'
require 'json'

MAX_LOG = 100
PORT = (ARGV.shift || 8000).to_i

EM::run do

	puts "start websocket server - port:#{PORT}"
	@channel = EM::Channel.new
	#@logs = Array.new
	#@channel.subscribe{|mes|
	#@logs.push mes
	#@logs.shift if @logs.size > MAX_LOG
	#}

	EM::WebSocket.start(:host => "0.0.0.0", :port => PORT) do |ws|
		ws.onopen{
			sid = @channel.subscribe{|mes|
				ws.send(mes)
			}
			puts "<#{sid}> connected!!"
			#@logs.each{|mes|
			#ws.send(mes)
			#}
			#@channel.push("hello <#{sid}>")

			ws.onmessage{|mes|
				puts "<#{sid}> #{mes}"
				#@channel.push("<#{sid}> #{mes}")
			}

			ws.onclose{
				puts "<#{sid}> disconnected"
				#@channel.unsubscribe(sid)
				#@channel.push("<#{sid}> disconnected")
			}
		}
	end

	EM::defer do
		loop do
			t = Time.now.to_i
			@channel.push (([{ "time": t,"y":rand(1000)},
				{ "time": t,"y":rand(1000)}]).to_json)
			sleep 1
		end
	end

end
