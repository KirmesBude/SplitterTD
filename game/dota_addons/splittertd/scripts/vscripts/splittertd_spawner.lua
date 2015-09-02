if SplitterTD_Spawner == nil then
  	DebugPrint( '[SPLITTERTD] Creating Spawner Class' )
	_G.SplitterTD_Spawner = class({})
end

local SPLITTERTD_SPAWNER_WAVES = 42
local SPLITTERTD_SPAWNER_CURRENT

local waves = {}

--use loadkv instead
function SplitterTD_Spawner:Init()
	for i=1, SPLITTERTD_SPAWNER_WAVES, 1 do
		table.insert(waves, 'wave'..i)
	end

	SPLITTERTD_SPAWNER_CURRENT = 0
end

function SplitterTD_Spawner:SpawnWave()
	DebugPrint('[SPLITTERTD] Spawn Wave')
	if waves and #waves ~= 0 then
		DebugPrint('[SPLITTERTD] 2')
		--local name = table.remove(waves, 1)
		local name = waves[1]
		DebugPrint('[SPLITTERTD] ' .. name)
		local spawner_goodguys = Entities:FindByName(nil, 'splitter_spawner_goodguys')
		local spawner_badguys = Entities:FindByName(nil, 'splitter_spawner_badguys')
		local loc_spawner_goodguys = spawner_goodguys:GetOrigin()
		local loc_spawner_badguys = spawner_badguys:GetOrigin()
		local unit_goodguys = CreateUnitByName(name, loc_spawner_goodguys, true, nil, nil, DOTA_TEAM_NEUTRALS)
		SplitterTD_Spawner:InitLogic(unit_goodguys, loc_spawner_goodguys)
		local unit_badguys = CreateUnitByName(name, loc_spawner_badguys, true, nil, nil, DOTA_TEAM_NEUTRALS)
		SplitterTD_Spawner:InitLogic(unit_badguys, loc_spawner_badguys)

		--SPLITTERTD_SPAWNER_CURRENT = SPLITTERTD_SPAWNER_CURRENT + 1
		return SPLITTERTD_SPAWNER_CURRENT
	end

	--DebugPrint('[SPLITTERTD] Failed to spawn wave ' .. SPLITTERTD_SPAWNER_CURRENT+1)
	return 0
end

--better use OnNPCGoalReached!!
function SplitterTD_Spawner:FindNearestWayPoint(location)

	local waypoint1 = Entities:FindByNameNearest( "*wp*", location, 0 )
	local way = waypoint1:GetAbsOrigin()-location
	local waypoint2 = Entities:FindByNameWithin(waypoint1, "*wp*", location, 2*way:__len())

	if waypoint2 == nil then
		return waypoint1
	end

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


function SplitterTD_Spawner:InitLogic(unit, location)
	order = {}
	order.UnitIndex = unit:entindex()
	order.OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION
	order.Queue = false

	-- Find the closest waypoint, use it as a goal entity if we can
	local waypoint = SplitterTD_Spawner:FindNearestWayPoint(location)
	
	--local waypoint = Entities:FindByNameNearest('*wp*', thisEntity:GetAbsOrigin(), 0)

	if waypoint then
		DebugPrint(waypoint:GetName())

		unit:SetInitialGoalEntity( waypoint )
		unit:SetMustReachEachGoalEntity(false)

		order.Position = waypoint:GetAbsOrigin()
	else
		DebugPrint("Could not find waypoint")
		local fallback = Entities:FindNearestByName( nil, "*end" )
		DebugPrint("Moving right to the end")

		unit:SetInitialGoalEntity( fallback )
		unit:SetMustReachEachGoalEntity(false)

		order.Position = fallback:GetAbsOrigin()
	end

	ExecuteOrderFromTable(order)

end