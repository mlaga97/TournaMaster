local Match = {}
Match.__index = Match

function Match.New( white, black, round )
	local match = {
		[ true ] = white,
		[ false ] = black,
	}
	
	match[ true ][ "rounds" ][ round ] = {
		[ "color" ] = true,
	}
	
	match[ false ][ "rounds" ][ round ] = {
		[ "color" ] = false,
	}
	
	setmetatable( match, Match )
	return match
end

function Match:schedule( metric )
	metric = metric or "score"
	
	white = self[ true ].name .. " ( " .. self[ true ][ metric] .. " )"
	
	while #white < 24 do
		white = white .. " "
	end
	
	return white .. self[ false ].name .. " ( " .. self[ false ][ metric] .. " )"
end

return Match
