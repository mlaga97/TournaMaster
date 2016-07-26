local Round = {}
Round.__index = Round

local Match = require "Match"

math.randomseed( os.time() )


local function first_round( players, round_number )
	local round = {}
	SortByMember( players, "rating" )
	
	-- Coin Toss of ENTROPY!!!!!
	round.coin_toss = true
	if math.random( 0, 1 ) == 0 then round.coin_toss = false end
	
	-- Helpful variables
	local odd_count = #players % 2
	local first_high = 1
	local last_low = #players - odd_count
	local last_high = last_low/2
	local first_low = last_high + 1
	local high_color = round.coin_toss
	
	-- Generate the round
	for x = first_high,last_high do
		-- Fill board
		if high_color then
			round[ x ] = Match.New( players[ x ], players[ x + last_high ], round_number )
		else
			round[ x ] = Match.New( players[ x + last_high ], players[ x ], round_number )
		end
		
		-- Flip coin
		high_color = not high_color
	end
	
	return round, round_number + 1
end

local function extra_round( players, round_number )
	local round = {}
	local colors = {
		[ true ] = {},
		[ false ] = {},
	}
	
	SortByMember( players, "score" )
	
	-- Sort players based on color
	for rank,player in ipairs( players ) do
		-- What color?
		player.rounds[ round_number ] = {
			[ "color" ] = not player.rounds[ round_number - 1 ].color,
		}
		
		-- Insert the player into the proper tier and color
		table.insert( colors[ player.rounds[ round_number ].color ], player )
	end
	
	-- Make round
	for x = 1,#colors[ true ] do
		round[ x ] = Match.New( colors[ true ][ x ], colors[ false ][ x ], round_number )
	end
	
	return round, round_number + 1
end

function Round.New( players, round_number )
	local round = {}
	
	if round_number == 1 then
		round, round_number = first_round( players, round_number )
	else
		round, round_number = extra_round( players, round_number )
	end
	
	setmetatable( round, Round )
	return round, round_number
end

function Round:schedule( metric )
	schedule = "\tBoard\t\tWhite\t\t\tBlack\n"
	
	for board,match in ipairs( self ) do
		schedule = schedule .. "\t" .. board .. "\t\t" .. match:schedule( metric ) .. "\n"
	end
	
	return schedule .. "\n"
end

return Round
