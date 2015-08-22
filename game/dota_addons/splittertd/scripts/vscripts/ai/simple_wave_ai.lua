

function Spawn( entityKeyValues )
	order = {}
	order.UnitIndex = thisEntity:entindex()
	order.OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION
	order.Queue = false

	-- Find the closest waypoint, use it as a goal entity if we can
	local waypoint = Entities:FindByNameNearest( "*wp*", thisEntity:GetOrigin(), 0 )

	if waypoint then
		thisEntity:SetInitialGoalEntity( waypoint )

		order.Position = waypoint:GetAbsOrigin
	else
		print("Could not find waypoint")
		local fallback = Entities:FindByName( nil, "the_end" )
		print("Moving right to the end")

		thisEntity:SetInitialGoalEntity( fallback )

		order.Position = fallback:GetAbsOrigin
	end

	ExecuteOrderFromTable(order)
	
end