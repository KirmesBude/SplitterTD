
--I dont think this works quite right lol
--[[

function FindNearestWayPoint(thisEntity)
	--still at origin here
	local loc = thisEntity:GetAbsOrigin()

	local waypoint1 = Entities:FindByNameNearest( "*wp*", loc, 0 )
	local way = waypoint1:GetAbsOrigin()-loc
	local waypoint2 = Entities:FindByNameWithin(waypoint1, "*wp*", loc, 2*way:__len())

	local bGood = string.find(waypoint1:GetName(), "good")
	local startP

	if bGood then
		startP = 30
	else
		startP = 29
	end

	local wayp1name = string.sub(waypoint1:GetName(), 30)
	local num1
	if wayp1name ~= 'end' then
		num1 = tonumber(wayp1name)
	else
		return waypoint1	
	end

	local wayp2name = string.sub(waypoint2:GetName(), 30)
	local num2
	if wayp2name ~= 'end' then
		num2 = tonumber(wayp2name)
	else
		return waypoint2
	end

	if mum2 > num1 then
		return waypoint2
	else
		return waypoint1
	end

	return nil
end


function Spawn( entityKeyValues )
	order = {}
	order.UnitIndex = thisEntity:entindex()
	order.OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION
	order.Queue = false

	-- Find the closest waypoint, use it as a goal entity if we can
	local waypoint = FindNearestWayPoint(thisEntity)
	
	
	--local waypoint = Entities:FindByNameNearest('*wp*', thisEntity:GetAbsOrigin(), 0)

	if waypoint then
		DebugPrint(waypoint:GetName())

		thisEntity:SetInitialGoalEntity( waypoint )
		--thisEntity:SetMustReachEachGoalEntity(false)

		order.Position = waypoint:GetAbsOrigin()
	else
		DebugPrint("Could not find waypoint")
		local fallback = Entities:FindNearestByName( nil, "*end" )
		DebugPrint("Moving right to the end")

		thisEntity:SetInitialGoalEntity( fallback )
		--thisEntity:SetMustReachEachGoalEntity(false)

		order.Position = fallback:GetAbsOrigin()
	end

	ExecuteOrderFromTable(order)

end

--AI Think
--GridNav:CanFindPath(unitpos, nextwaypoint)
--nextwaypoint via GetInitalGoalEntity?
--print the initalgoalentity, probably has every other goal ?
--
--go aggressive
]]--