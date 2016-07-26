local Shell = require 'Shell'
local TournaMaster = require "TournaMaster"

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

io.write( "How many players? " )

for x = 1,tonumber( io.read() ) do
	TournaMaster.addplayer()
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

io.write( "\nHow many rounds? " )

for x = 1,tonumber( io.read() ) do
	TournaMaster.newround()
	TournaMaster.schedule()
	io.write( "\nPress enter to continue.\n" )
	TournaMaster.scoreround()
	TournaMaster.leaderboard()
	io.write( "\nPress enter to continue.\n" )
end
