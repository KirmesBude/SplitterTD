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
		--local name = table.remove(waves, 1)
		local name = waves[1]
		DebugPrint('[SPLITTERTD] ' .. name)
		local spawner_goodguys = Entities:FindByName(nil, 'splitter_spawner_goodguys')
		local spawner_badguys = Entities:FindByName(nil, 'splitter_spawner_badguys')

		local loc_spawner_goodguys = spawner_goodguys:GetOrigin()
		local loc_spawner_badguys = spawner_badguys:GetOrigin()

		local unit_goodguys = CreateUnitByName(name, loc_spawner_goodguys, true, nil, nil, DOTA_TEAM_NEUTRALS)
		unit_goodguys:AddNewModifier(newUnit, nil, "modifier_phased", nil)
		SplitterTD_Spawner:InitLogic(unit_goodguys, loc_spawner_goodguys)

		local unit_badguys = CreateUnitByName(name, loc_spawner_badguys, true, nil, nil, DOTA_TEAM_NEUTRALS)
		unit_badguys:AddNewModifier(newUnit, nil, "modifier_phased", nil)
		SplitterTD_Spawner:InitLogic(unit_badguys, loc_spawner_badguys)

		--SPLITTERTD_SPAWNER_CURRENT = SPLITTERTD_SPAWNER_CURRENT + 1
		return SPLITTERTD_SPAWNER_CURRENT
	end

	--DebugPrint('[SPLITTERTD] Failed to spawn wave ' .. SPLITTERTD_SPAWNER_CURRENT+1)
	return 0
end

--better use OnNPCGoalReached!!
function SplitterTD_Spawner:FindNextWayPoint(unit, location)
	
	return unit.nextGoalEntity or Entities:FindByNameNearest('*wp*', location, 0)
end

function SplitterTD_Spawner:InitWaypoint(unit, waypoint)
	order = {}
	order.UnitIndex = unit:entindex()
	order.OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION
	order.Queue = false

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

function SplitterTD_Spawner:InitLogic(unit, location)
	-- Find the closest waypoint, use it as a goal entity if we can
	local waypoint = SplitterTD_Spawner:FindNextWayPoint(unit, location)
	
	SplitterTD_Spawner:InitWaypoint(unit, waypoint)
end

function SplitterTD_Spawner:Split(killedUnit)
	local location = killedUnit:GetAbsOrigin()
	local waypoint = killedUnit.nextGoalEntity
	local name = killedUnit:GetUnitName()

	DebugPrint(name)

	for i=1, 2 do
		local newUnit = CreateUnitByName(name, location, true, nil, nil, DOTA_TEAM_NEUTRALS)
		--new_unit:FindClearSpaceForUnit(handle handle_1, Vector Vector_2, bool bool_3)

		--Phase them for 1 frame
		newUnit:AddNewModifier(newUnit, nil, "modifier_phased", nil)

		--Visually
		--Pop particle

		--reduce size slightly
		newUnit:SetModelScale(killedUnit:GetModelScale()*0.9)
		
		--Pathing
		newUnit.nextGoalEntity = waypoint
		SplitterTD_Spawner:InitLogic(newUnit, location)

	end
end