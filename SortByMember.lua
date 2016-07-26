--[[---------------------------------------------------------
Name: table.SortByMember( table )
Desc: Sorts table by named member
-----------------------------------------------------------]]
function SortByMember( Table, MemberName, bAsc )
	local TableMemberSort = function( a, b, MemberName, bReverse )
		if ( type( a[MemberName] ) == "string" ) then
			if ( bReverse ) then
				return a[MemberName]:lower() < b[MemberName]:lower()
			else
				return a[MemberName]:lower() > b[MemberName]:lower()
			end
		end

		if ( bReverse ) then
			return a[MemberName] < b[MemberName]
		else
			return a[MemberName] > b[MemberName]
		end
	end

	table.sort( Table, function(a, b) return TableMemberSort( a, b, MemberName, bAsc or false ) end )
end
