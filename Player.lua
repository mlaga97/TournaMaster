local Player = {}
Player.__index = Player

function Player.New( name, rating )
	local player = {
		[ "name" ] = name,
		[ "rating" ] = tonumber( rating ),
		[ "score" ] = 0,
		[ "rounds" ] = {},
	}
	setmetatable( player, Player )
	return player
end

function Player:leaderboard( metric )
	-- return "NAME (METRIC_SCORE)"
	return self.name .. " ( " .. self[ metric ] .. " )"
end

return Player

