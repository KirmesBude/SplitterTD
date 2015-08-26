if not BuildingHelper_SplitterTD then
	BuildingHelper_SplitterTD = class({})
end

function BuildingHelper_SplitterTD:ValidPosition(size, location, callback)
	local goodguys_loc = Entities:FindByName(nil, 'splitter_spawner_goodguys'):GetAbsOrigin()
	local badguys_loc = Entities:FindByName(nil, 'splitter_spawner_badguys'):GetAbsOrigin()

	-- Spawn point obstructions before placing the building
	local gridNavBlockers = BuildingHelper:BlockGridNavSquare(size, location)

	--Path still free?
	local bBlocksPath = not GridNav:CanFindPath(goodguys_loc, badguys_loc)

	if bBlocksPath then

		--remove gridNavBlockers
		for _, v in pairs(gridNavBlockers) do
			DoEntFireByInstanceHandle(v, "Disable", "1", 0, nil, nil)
			DoEntFireByInstanceHandle(v, "Kill", "1", 1, nil, nil)
		end

		--Throw Error
		DebugPrint("[BH] Error: Blocking Unit Path is not allowed!")

		if callbacks.onConstructionFailed then
			callbacks.onConstructionFailed(bBlocksPath)
		end

		return false
	end

	return true
end