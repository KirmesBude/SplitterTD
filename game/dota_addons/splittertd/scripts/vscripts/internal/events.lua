-- The overall game state has changed
function SplitterTD:_OnGameRulesStateChange(keys)
  local newState = GameRules:State_Get()
  if newState == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
    self.bSeenWaitForPlayers = true
  elseif newState == DOTA_GAMERULES_STATE_INIT then
    Timers:RemoveTimer("alljointimer")
  elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
    local et = 6
    if self.bSeenWaitForPlayers then
      et = .01
    end
    Timers:CreateTimer("alljointimer", {
      useGameTime = true,
      endTime = et,
      callback = function()
        if PlayerResource:HaveAllPlayersJoined() then
          SplitterTD:PostLoadPrecache()
          SplitterTD:OnAllPlayersLoaded()

           if USE_CUSTOM_TEAM_COLORS_FOR_PLAYERS then
            for i=0,9 do
              if PlayerResource:IsValidPlayer(i) then
                local color = TEAM_COLORS[PlayerResource:GetTeam(i)]
                PlayerResource:SetCustomPlayerColor(i, color[1], color[2], color[3])
              end
            end
          end
          return 
        end
        return 1
      end
      })
  elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    SplitterTD:OnGameInProgress()
  end
end

-- An NPC has spawned somewhere in game.  This includes heroes
function SplitterTD:_OnNPCSpawned(keys)
  local npc = EntIndexToHScript(keys.entindex)

  if npc:IsRealHero() and npc.bFirstSpawned == nil then
    npc.bFirstSpawned = true
    SplitterTD:OnHeroInGame(npc)
  end
end

-- An entity died
function SplitterTD:_OnEntityKilled( keys )
  -- The Unit that was Killed
  local killedUnit = EntIndexToHScript( keys.entindex_killed )
  -- The Killing entity
  local killerEntity = nil

  if keys.entindex_attacker ~= nil then
    killerEntity = EntIndexToHScript( keys.entindex_attacker )
  end

  if killedUnit:IsRealHero() then 
    DebugPrint("KILLED, KILLER: " .. killedUnit:GetName() .. " -- " .. killerEntity:GetName())
    if END_GAME_ON_KILLS and GetTeamHeroKills(killerEntity:GetTeam()) >= KILLS_TO_END_GAME_FOR_TEAM then
      GameRules:SetSafeToLeave( true )
      GameRules:SetGameWinner( killerEntity:GetTeam() )
    end

    --PlayerResource:GetTeamKills
    if SHOW_KILLS_ON_TOPBAR then
      GameRules:GetGameModeEntity():SetTopBarTeamValue ( DOTA_TEAM_BADGUYS, GetTeamHeroKills(DOTA_TEAM_BADGUYS) )
      GameRules:GetGameModeEntity():SetTopBarTeamValue ( DOTA_TEAM_GOODGUYS, GetTeamHeroKills(DOTA_TEAM_GOODGUYS) )
    end
  end
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function SplitterTD:_OnConnectFull(keys)
  SplitterTD:_CaptureSplitterTD()
end

--BH
-- An entity died
function SplitterTD:_BH_OnEntityKilled( event )

  -- The Unit that was Killed
  local killedUnit = EntIndexToHScript(event.entindex_killed)
  -- The Killing entity
  local killerEntity
  if event.entindex_attacker then
    killerEntity = EntIndexToHScript(event.entindex_attacker)
  end

  -- Player owner of the unit
  local player = killedUnit:GetPlayerOwner()

  -- Building Killed
  if IsCustomBuilding(killedUnit) then

     -- Building Helper grid cleanup
    BuildingHelper:RemoveBuilding(killedUnit, true)

    -- Check units for downgrades
    local building_name = killedUnit:GetUnitName()
        
    -- Substract 1 to the player building tracking table for that name
    if player.buildings[building_name] then
      player.buildings[building_name] = player.buildings[building_name] - 1
    end

    -- possible unit downgrades
    for k,units in pairs(player.units) do
        CheckAbilityRequirements( units, player )
    end

    -- possible structure downgrades
    for k,structure in pairs(player.structures) do
      CheckAbilityRequirements( structure, player )
    end
  end

  -- Cancel queue of a builder when killed
  if IsBuilder(killedUnit) then
    BuildingHelper:ClearQueue(killedUnit)
  end

  -- Table cleanup
  if player then
    -- Remake the tables
    local table_structures = {}
    for _,building in pairs(player.structures) do
      if building and IsValidEntity(building) and building:IsAlive() then
        --print("Valid building: "..building:GetUnitName())
        table.insert(table_structures, building)
      end
    end
    player.structures = table_structures
    
    local table_units = {}
    for _,unit in pairs(player.units) do
      if unit and IsValidEntity(unit) then
        table.insert(table_units, unit)
      end
    end
    player.units = table_units    
  end
end