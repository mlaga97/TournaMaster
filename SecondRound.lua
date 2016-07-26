require "SortByMember"
local Player = require 'Player'
local Round = require 'Round'
local Match = require 'Match'
local Shell = require 'Shell'

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

players = {
	Player.New( "Cup", 1540 ),
	Player.New( "Phone", 2014 ),
	Player.New( "Pizza", 957 ),
	Player.New( "Mountain Dew", 1348 ),
	Player.New( "Taco Bell", 123 ),
	Player.New( "Dog", 1739 ),
	Player.New( "Cat", 1423 ),
	Player.New( "Fish", 2356 ),
	Player.New( "Herp", 2014 ),
	Player.New( "Derp", 1739 ),
}

rounds = {}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Setup Round
rounds[1] = Round.New( players, 1 )

-- Random Results
for board,match in ipairs( rounds[ 1 ] ) do
	local result = math.random( 1, 3 )
	
	if result == 1 then
		match[ true ].score = match[ true ].score + 1
		match[ false ].score = match[ false ].score + 0
	elseif result == 2 then
		match[ true ].score = match[ true ].score + 0.5
		match[ false ].score = match[ false ].score + 0.5
	elseif result == 3 then
		match[ true ].score = match[ true ].score + 0
		match[ false ].score = match[ false ].score + 1
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--[[

Exactly how strict are the rules for rounds 2 and up? I was able to take the
rules given, and create a very simple to implement, but non-perfect version of
the given specification that will work correctly for a large number of cases but
not all of them. It only trades down and respects due color unconditionally.

* Divide into point groups
* If point group has odd number, trade down the player with the 'wrong' color
	of the lowest rating within that point group to the next highest point
	group
* If lowest point group has an odd number, trade down the player with the
	'wrong' color of the lowest rating who has not previously recieved a 1
	point bye or requested a 0.5 point bye for that match to a 1 point bye
	and exclude them from the schedule
* For each evened-out point group, pair the highest white with the highest
	black, 2nd highest white with 2nd highest black, etc. Until the schedule
	is complete.

]]
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--[[
local tiers = {}

-- Sort players based on tier
for rank,player in ipairs( players ) do
	if tiers[ player.score ] == nil then
		tiers[ player.score ] = {
			[ "score" ] = player.score,
		}
	end
	table.insert( tiers[ player.score ], player )
end

SortByMember( tiers, "score" )

io.write( "\nLeaderboards for points:\n" )
for score,tier in pairs( tiers ) do
	SortByMember( tier, "rating" )
	
	io.write( "\tScore Tier " .. score .. ":\n" )
	for rank,player in ipairs( tier ) do
		io.write( "\t" .. rank .. ": " .. player:leaderboard( "rating" ) .. "( " )
		
		if player.rounds[ round - 1 ].color then
			io.write( "Black" )
		else
			io.write( "White" )
		end
		
		io.write( " this round )\n" )
	end
	io.write( "\n" )
end]]

local function extra_round( players, round_number )
	local round = {}
	local groups = {}
	local extras = {
		[ true ] = {},
		[ false ] = {},
	}
	
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	-- Divide into point groups
	
	-- Sort players based on tier and color
	for rank,player in ipairs( players ) do
		-- If the tier doesn't exist, create it.
		if groups[ player.score ] == nil then
			groups[ player.score ] = {
				[ "score" ] = player.score,
				[ true ] = {},
				[ false ] = {},
			}
		end
		
		-- What color?
		player.rounds[ round_number ] = {
			[ "color" ] = not player.rounds[ round_number - 1 ].color,
		}
		
		-- Insert the player into the proper tier and color
		table.insert( groups[ player.score ][ player.rounds[ round_number ].color ], player )
	end
	
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	-- Start trading down
	
	-- Sort the groups by score first
	SortByMember( groups, "score" )
	
	-- Then sort each color by rating
	for score = 0,#groups,0.5 do
		local group = groups[ score ]
		
		if group ~= nil then
			print(  #group[ true ] + #group[ false ] .. " players have " .. score .. " points. ( " .. #group[ true ] .. " white, " .. #group[ false ] .. " black )" )
		else
			print( "No players have " .. score .. " points." )
		end
	end
	
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	
	return groups
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

round_2 = extra_round( players, 2 )
--[[
for score = 0,#round_2,0.5 do
	local group = round_2[ score ]
	
	print( score .. ": " .. group.score )
end]]
