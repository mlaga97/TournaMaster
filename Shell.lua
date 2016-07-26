local Shell = {}

function Shell.get_command( query_string )
	io.write( query_string )
	local command = io.read()
	if command == "" then
		return nil
	end
	local parsed = {}
	for i in command:gmatch( "%S+" ) do
		table.insert( parsed, i )
	end
	local options = {}
	for i = 2,#parsed do
		table.insert( options, parsed[ i ] )
	end
	return parsed[1], options
end

return Shell
