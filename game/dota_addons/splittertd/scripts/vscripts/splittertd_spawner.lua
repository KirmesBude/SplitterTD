if SplitterTD_Spawner == nil then
  	DebugPrint( '[SPLITTERTD] Creating Spawner Class' )
	_G.SplitterTD_Spawner = class({})
end

local SPLITTERTD_SPAWNER_WAVES = 42
local SPLITTERTD_SPAWNER_CURRENT

--[[ Author: Bude
	 Date: 20.10.2015
	 Initializes Waves from kv]]
function SplitterTD_Spawner:Init()
	DebugPrint('[SPLITTERSPAWNER] INIT')
	
	-- Alt+RightClick moving
	SendToServerConsole("dota_unit_allow_moveto_direction 1")
	self.waves = LoadKeyValues("scripts/kv/splitter_waves.kv")
	SPLITTERTD_SPAWNER_CURRENT = 0
end

--[[ Author: Bude
	 Date: 20.10.2015
	 Spawns current wave]]
function SplitterTD_Spawner:SpawnWave()
	DebugPrint('[SPLITTERTD] Spawn Wave')	
	DebugPrintTable(self.waves)

	local current_wave = self.waves["1"]
	DebugPrintTable(current_wave)
	if current_wave ~= nil then
		print("HALLO")
		--local name = table.remove(waves, 1)
		local wave_name = current_wave.name
		local wave_unit_name = current_wave.unit_name
		local wave_unit_amount = current_wave.unit_amount
		local wave_unit_type = current_wave.unit_type
		DebugPrint('[SPLITTERTD] ' .. wave_unit_name)
		local spawner_goodguys = Entities:FindByName(nil, 'splitter_spawner_goodguys')
		local spawner_badguys = Entities:FindByName(nil, 'splitter_spawner_badguys')

		local loc_spawner_goodguys = spawner_goodguys:GetOrigin()
		local loc_spawner_badguys = spawner_badguys:GetOrigin()

		local tLocations = {}
		tLocations.goodguys = loc_spawner_goodguys
		tLocations.badguys = loc_spawner_badguys

		SplitterTD_Spawner:Spawn(wave_unit_name, tLocations, wave_unit_amount)

		--SPLITTERTD_SPAWNER_CURRENT = SPLITTERTD_SPAWNER_CURRENT + 1
		return SPLITTERTD_SPAWNER_CURRENT
	end

	--DebugPrint('[SPLITTERTD] Failed to spawn wave ' .. SPLITTERTD_SPAWNER_CURRENT+1)
	return 0
end

--[[ Author: Bude
	 Date: 20.10.2015
	 Spawns Splitter Creeps]]
function SplitterTD_Spawner:Spawn(sUnit_name, tLocations, nAmount)
	local loc_spawner_goodguys = tLocations.goodguys
	local loc_spawner_badguys = tLocations.badguys

	print("Spawning units with name:"..sUnit_name)
	local unit_goodguys = CreateUnitByName(sUnit_name, loc_spawner_goodguys, true, nil, nil, DOTA_TEAM_NEUTRALS)
	--unit_goodguys:AddNewModifier(newUnit, nil, "modifier_phased", nil)
	SplitterTD_Spawner:InitLogic(unit_goodguys, loc_spawner_goodguys)

	local unit_badguys = CreateUnitByName(sUnit_name, loc_spawner_badguys, true, nil, nil, DOTA_TEAM_NEUTRALS)
	--unit_badguys:AddNewModifier(newUnit, nil, "modifier_phased", nil)
	SplitterTD_Spawner:InitLogic(unit_badguys, loc_spawner_badguys)
end

--[[ Author: Bude
	 Date: 20.10.2015
	 See scripts/events.lua --function OnNPCGoalReached
	 Returns nearest and next in order waypoint for split units]]
function SplitterTD_Spawner:FindNextWayPoint(unit, location)
	
	return unit.nextGoalEntity or Entities:FindByNameNearest('*wp*', location, 0)
end

--[[ Author: Bude
	 Date: 20.10.2015
	 Initializes the first waypoint for the given unit to the given waypoint]]
function SplitterTD_Spawner:InitWaypoint(unit, waypoint)
	order = {}
	order.UnitIndex = unit:entindex()
	order.OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION
	order.Queue = true

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

--[[ Author: Bude
	 Date: 20.10.2015
	 Sets the AI for splitter creeps]]
function SplitterTD_Spawner:InitLogic(unit, location)
	-- Find the closest waypoint, use it as a goal entity if we can
	local waypoint = SplitterTD_Spawner:FindNextWayPoint(unit, location)
	
	SplitterTD_Spawner:InitWaypoint(unit, waypoint)
end

--[[ Author: Bude
	 Date: 20.10.2015
	 Splits Unit in 2]]
function SplitterTD_Spawner:Split(killedUnit)
	local location = killedUnit:GetAbsOrigin()
	local waypoint = killedUnit.nextGoalEntity
	local name = killedUnit:GetUnitName()

	DebugPrint(name)

	for i=1, 2 do
		local newUnit = CreateUnitByName(name, location, true, nil, nil, DOTA_TEAM_NEUTRALS)
		--new_unit:FindClearSpaceForUnit(handle handle_1, Vector Vector_2, bool bool_3)

		--Phase them for 1 frame
		--newUnit:AddNewModifier(newUnit, nil, "modifier_phased", nil)

		--Visually
		--Pop particle

		--reduce size slightly
		newUnit:SetModelScale(killedUnit:GetModelScale()*0.9)
		
		--Pathing
		newUnit.nextGoalEntity = waypoint
		SplitterTD_Spawner:InitLogic(newUnit, location)

	end
end