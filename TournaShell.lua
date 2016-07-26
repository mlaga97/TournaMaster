local Shell = require 'Shell'
local TournaMaster = require "TournaMaster"

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function TournaMaster.help()
	io.write( [[
TournaMaster Lua 5.2 CLI Edition, version 0.1
Command				Description
addplayer NAME RATING		add a player with NAME and RATING to database
leaderboard [ METRIC ]		generate a leaderboard for METRIC, defaulting
				to score. Available values for METRIC are:
					* score
					* rating
newround			generate the next round of the tournament. you
				may need to run scoreround before generating the
				next round
scoreround			score the next unscored match of the tournament
schedule [ ROUND ]		print the match schedule for round ROUND.
				defaults to the last generated round.
exit				exit the program
]] )
end

-- Exit the program
function TournaMaster.exit()
	os.exit()
end

-- Fall back to a lua shell
function TournaMaster.debug()
	io.write( 'You are now in the lua shell. To return to the application shell, type "main()"\n' )
	loop = false
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function main()
	-- Awesome ascii-art generator: http://patorjk.com/software/taag/#p=display&f=Big
	io.write( [[###############################################################################]] .. '\n' )
	io.write( [[#     _______                           __  __           _                    #]] .. '\n' )
	io.write( [[#    |__   __|   Lua 5.2 CLI Edition   |  \/  | Written | | by mlaga97        #]] .. '\n' )
	io.write( [[#       | | ___  _   _ _ __ _ __   __ _| \  / | __ _ ___| |_ ___ _ __         #]] .. '\n' )
	io.write( [[#       | |/ _ \| | | | '__| '_ \ / _` | |\/| |/ _` / __| __/ _ \ '__|        #]] .. '\n' )
	io.write( [[#       | | (_) | |_| | |  | | | | (_| | |  | | (_| \__ \ ||  __/ |           #]] .. '\n' )
	io.write( [[#       |_|\___/ \__,_|_|  |_| |_|\__,_|_|  |_|\__,_|___/\__\___|_|           #]] .. '\n' )
	io.write( [[#                                                                             #]] .. '\n' )
	io.write( [[###############################################################################]] .. '\n' )
	io.write( [[# Version 0.1                                                                 #]] .. '\n' )
	io.write( [[###############################################################################]] .. '\n' )
	io.write( '\n' )
	io.write( 'Type "help" for a list of commands.\n' )
	loop = true
	while loop do
		command, options = Shell.get_command( "> " )
		if command ~= nil then
			if TournaMaster[ command ] ~= nil then
				TournaMaster[ command ] ( unpack( options ) )
			else
				io.write( "Unknown command: '" .. command .. "'\n" )
			end
		end
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

main()
