require "SortByMember"
local Player = require 'Player'
local Round = require 'Round'
local Match = require 'Match'

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local TournaMaster = {}
local rounds = {}
local named_players = {}
local players = {}
local round = 1

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function TournaMaster.addplayer( ... )
	local args = { ... }
	local player = {}
	
	-- If we have 2 arguments, then we don't need to prompt the user
	-- otherwise, ask for the name and rating at the terminal
	if #args == 2 then
		-- Create new player object
		player = Player.New( args[1], tonumber( args[2] ) )
	elseif #args == 1 then
		-- Prompt user for rating
		io.write( "rating: " )
		local rating = tonumber( io.read() )
		
		-- Create new player object
		player = Player.New( args[1], rating )
	else
		-- Prompt user for name
		io.write( "name: " )
		local name = io.read()
		
		-- Prompt user for rating
		io.write( "rating: " )
		local rating = tonumber( io.read() )
		
		-- Create new player object
		player = Player.New( name, rating )
	end
	
	-- Add it to the 'players' and 'named_players' tables
	table.insert( players, player )
	named_players[ player.name ] = player
end

function TournaMaster.leaderboard( metric )
	-- Default to score
	metric = metric or "score"
	
	-- Parameter checking
	if not ( metric == "score" or metric == "rating" ) then
		io.write( "Metric '" .. metric .. "' is not unsupported.\n" )
		return nil
	end
	
	-- Sort players in place by the requested metric
	SortByMember( players, metric )
	
	-- Print header
	io.write( "\nLeaderboard for " .. metric .. ":\n" )
	
	-- Print rank and data for each player
	for rank,player in ipairs( players ) do
		io.write( "\t" .. rank .. ": " .. player:leaderboard( metric ) .. "\n" )
	end
	
	-- Trailing newline
	io.write( "\n" )
end
TournaMaster.sort = TournaMaster.leaderboard
TournaMaster.list = TournaMaster.leaderboard

function TournaMaster.newround()
	last_round = round

	-- Print status
	io.write( "Generating Round " .. round .. "..." )
	
	-- Call the Round constructor and also modify the round counter
	rounds[ round ], round = Round.New( players, round )
	
	-- Print more status
	if round > last_round then
		io.write( "done!\nTo view this round's schedule use 'schedule'\n" )
	end
end

function TournaMaster.schedule( round_number )
	-- Default to the last calculated round
	round_number = round_number or round - 1
	
	-- Automagically!
	if round_number == 1 then local metric = "rating" end
	
	-- Kleen teh imputes!
	round_number = tonumber( round_number )
	
	-- Print header
	io.write( "\nMatch schedule for round " .. round_number .. ":\n" )
	
	-- Print schedule data
	io.write( rounds[ round_number ]:schedule( metric ) )
end

function TournaMaster.scoreround()
	-- Get last calculated round
	local round_number = round - 1
	
	if rounds[ round_number ].scored then
		io.write( "Already scored. To modify previous scores, use 'editround " .. round_number .. " score'." )
		return
	end
	
	-- Print header
	io.write( "\nScoring for round " .. round_number .. ":\n" )
	
	-- Iterate
	for board,match in ipairs( rounds[ round_number ] ) do
		io.write( "Match " .. board .. ": '" .. match[ true ].name .. "' vs. '" .. match[ false ].name .. "'\n" .. match[ true ].name .. " (w/t/l)? "  )
		local result = io.read()
		if result == "w" then
			match[ true ].score = match[ true ].score + 1
			match[ false ].score = match[ false ].score + 0
		elseif result == "t" then
			match[ true ].score = match[ true ].score + 0.5
			match[ false ].score = match[ false ].score + 0.5
		elseif result == "l" then
			match[ true ].score = match[ true ].score + 0
			match[ false ].score = match[ false ].score + 1
		end
		io.write( "\n" )
	end
end

return TournaMaster
