require 'em-websocket'
require 'json'
require 'pp'

connnections = []
Signal.trap(:INT){
	puts "SIGINT"
		loop = false
}

loop = true
#random = Random.new

EM::WebSocket.start({:host => "0.0.0.0", :port => 8000}) do |ws_conn|
	ws_conn.onopen do
		connnections << ws_conn
	end
	while(loop) do
		t = Time.now
		message = [ {"time":t, "y":rand(1000)},
					{"time":t, "y":rand(1000)}]
		p message
		ws_conn.onmessage do |message|
		#pp message
			connnections.each{|conn| conn.send(message) }
		end
		sleep(1)

	end
end


