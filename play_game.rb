require 'httparty'
require 'rest-client'
require 'colorize'

def print_challs
	ch = JSON.parse(HTTParty.get "#{@host}/api/tasks?key=#{@apikey}")
	ch.each{|chall|
		if chall["solved"] == true
			str = "[#{chall['id'].to_s.green}] : #{chall['title']} - #{chall['points']} - #{chall['solves']} solves : #{chall['description']}"
		else
			str = "[#{chall['id'].to_s.red}] : #{chall['title']} - #{chall['points']} - #{chall['solves']} solves : #{chall['description']}"
		end
		puts str
	}
end

def get_scoreboard
	ch = JSON.parse(HTTParty.get "#{@host}/api/teams?key=#{@apikey}")
	count = 1
	your_name = HTTParty.get("#{@host}/api/team?key=#{@apikey}").body
	your_scores = JSON.parse(HTTParty.get "#{@host}/api/solves?key=#{@apikey}")
	myscore = 0
	your_scores.each{|score|
		myscore = myscore + score["points"]
	}
	gotit = false
	ch.each{|team|
		teamname = team['team']
		str = "#{count} - #{team['team']} - #{team['points']}"
		if count == 1
			str = str.light_yellow
		elsif count == 2
			str = str.light_white
		elsif count == 3
			str = str.light_red
		end
		count = count + 1
		if count > @max_teams and teamname != your_name
			next
		end
		puts str
	}
end


puts "gimme your api key"
@host = "http://localhost:8181"
@apikey = gets.chomp!
@max_teams = 25

loop do
	puts "1 - list challs"
	puts "2 - scoreboard"
	puts "3 - give key"
	select = gets.chomp!.to_i

	case select
	when 1
		print_challs
	when 2
		get_scoreboard
	when 3
		puts "which chall?"
		id = gets.chomp!.to_i
		puts "what flag?"
		flag = gets.chomp!
		resp = HTTParty.post "#{@host}/api/response?key=#{@apikey}&flag=#{flag}&id=#{id}"
	else
		puts "idk"
	end
end
