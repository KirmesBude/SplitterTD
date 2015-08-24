-- This file contains all splittertd-registered events and has already set up the passed-in parameters for your use.
-- Do not remove the SplitterTD:_Function calls in these events as it will mess with the internal splittertd systems.

-- Cleanup a player when they leave
function SplitterTD:OnDisconnect(keys)
  DebugPrint('[SPLITTERTD] Player Disconnected ' .. tostring(keys.userid))
  DebugPrintTable(keys)

  local name = keys.name
  local networkid = keys.networkid
  local reason = keys.reason
  local userid = keys.userid

end
-- The overall game state has changed
function SplitterTD:OnGameRulesStateChange(keys)
  DebugPrint("[SPLITTERTD] GameRules State Changed")
  DebugPrintTable(keys)

  -- This internal handling is used to set up main splittertd functions
  SplitterTD:_OnGameRulesStateChange(keys)

  local newState = GameRules:State_Get()
end

-- An NPC has spawned somewhere in game.  This includes heroes
function SplitterTD:OnNPCSpawned(keys)
  DebugPrint("[SPLITTERTD] NPC Spawned")
  DebugPrintTable(keys)

  -- This internal handling is used to set up main splittertd functions
  SplitterTD:_OnNPCSpawned(keys)

  local npc = EntIndexToHScript(keys.entindex)
end

-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function SplitterTD:OnEntityHurt(keys)
  --DebugPrint("[SPLITTERTD] Entity Hurt")
  --DebugPrintTable(keys)

  local damagebits = keys.damagebits -- This might always be 0 and therefore useless
  if keys.entindex_attacker ~= nil and keys.entindex_killed ~= nil then
    local entCause = EntIndexToHScript(keys.entindex_attacker)
    local entVictim = EntIndexToHScript(keys.entindex_killed)

    -- The ability/item used to damage, or nil if not damaged by an item/ability
    local damagingAbility = nil

    if keys.entindex_inflictor ~= nil then
      damagingAbility = EntIndexToHScript( keys.entindex_inflictor )
    end
  end
end

-- An item was picked up off the ground
function SplitterTD:OnItemPickedUp(keys)
  DebugPrint( '[SPLITTERTD] OnItemPickedUp' )
  DebugPrintTable(keys)

  local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
  local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local itemname = keys.itemname
end

-- A player has reconnected to the game.  This function can be used to repaint Player-based particles or change
-- state as necessary
function SplitterTD:OnPlayerReconnect(keys)
  DebugPrint( '[SPLITTERTD] OnPlayerReconnect' )
  DebugPrintTable(keys) 
end

-- An item was purchased by a player
function SplitterTD:OnItemPurchased( keys )
  DebugPrint( '[SPLITTERTD] OnItemPurchased' )
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
  
end

-- An ability was used by a player
function SplitterTD:OnAbilityUsed(keys)
  DebugPrint('[SPLITTERTD] AbilityUsed')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityname = keys.abilityname
end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function SplitterTD:OnNonPlayerUsedAbility(keys)
  DebugPrint('[SPLITTERTD] OnNonPlayerUsedAbility')
  DebugPrintTable(keys)

  local abilityname=  keys.abilityname
end

-- A player changed their name
function SplitterTD:OnPlayerChangedName(keys)
  DebugPrint('[SPLITTERTD] OnPlayerChangedName')
  DebugPrintTable(keys)

  local newName = keys.newname
  local oldName = keys.oldName
end

-- A player leveled up an ability
function SplitterTD:OnPlayerLearnedAbility( keys)
  DebugPrint('[SPLITTERTD] OnPlayerLearnedAbility')
  DebugPrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local abilityname = keys.abilityname
end

-- A channelled ability finished by either completing or being interrupted
function SplitterTD:OnAbilityChannelFinished(keys)
  DebugPrint('[SPLITTERTD] OnAbilityChannelFinished')
  DebugPrintTable(keys)

  local abilityname = keys.abilityname
  local interrupted = keys.interrupted == 1
end

-- A player leveled up
function SplitterTD:OnPlayerLevelUp(keys)
  DebugPrint('[SPLITTERTD] OnPlayerLevelUp')
  DebugPrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local level = keys.level
end

-- A player last hit a creep, a tower, or a hero
function SplitterTD:OnLastHit(keys)
  DebugPrint('[SPLITTERTD] OnLastHit')
  DebugPrintTable(keys)

  local isFirstBlood = keys.FirstBlood == 1
  local isHeroKill = keys.HeroKill == 1
  local isTowerKill = keys.TowerKill == 1
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local killedEnt = EntIndexToHScript(keys.EntKilled)
end

-- A tree was cut down by tango, quelling blade, etc
function SplitterTD:OnTreeCut(keys)
  DebugPrint('[SPLITTERTD] OnTreeCut')
  DebugPrintTable(keys)

  local treeX = keys.tree_x
  local treeY = keys.tree_y
end

-- A rune was activated by a player
function SplitterTD:OnRuneActivated (keys)
  DebugPrint('[SPLITTERTD] OnRuneActivated')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local rune = keys.rune

  --[[ Rune Can be one of the following types
  DOTA_RUNE_DOUBLEDAMAGE
  DOTA_RUNE_HASTE
  DOTA_RUNE_HAUNTED
  DOTA_RUNE_ILLUSION
  DOTA_RUNE_INVISIBILITY
  DOTA_RUNE_BOUNTY
  DOTA_RUNE_MYSTERY
  DOTA_RUNE_RAPIER
  DOTA_RUNE_REGENERATION
  DOTA_RUNE_SPOOKY
  DOTA_RUNE_TURBO
  ]]
end

-- A player took damage from a tower
function SplitterTD:OnPlayerTakeTowerDamage(keys)
  DebugPrint('[SPLITTERTD] OnPlayerTakeTowerDamage')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local damage = keys.damage
end

-- A player picked a hero
function SplitterTD:OnPlayerPickHero(keys)
  DebugPrint('[SPLITTERTD] OnPlayerPickHero')
  DebugPrintTable(keys)

  local heroClass = keys.hero
  local heroEntity = EntIndexToHScript(keys.heroindex)
  local player = EntIndexToHScript(keys.player)
end

-- A player killed another player in a multi-team context
function SplitterTD:OnTeamKillCredit(keys)
  DebugPrint('[SPLITTERTD] OnTeamKillCredit')
  DebugPrintTable(keys)

  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
  local numKills = keys.herokills
  local killerTeamNumber = keys.teamnumber
end

-- An entity died
function SplitterTD:OnEntityKilled( keys )
  DebugPrint( '[SPLITTERTD] OnEntityKilled Called' )
  DebugPrintTable( keys )

  SplitterTD:_OnEntityKilled( keys )
  SplitterTD:_BH_OnEntityKilled( keys )
  

  -- The Unit that was Killed
  local killedUnit = EntIndexToHScript( keys.entindex_killed )
  -- The Killing entity
  local killerEntity = nil

  if keys.entindex_attacker ~= nil then
    killerEntity = EntIndexToHScript( keys.entindex_attacker )
  end

  -- The ability/item used to kill, or nil if not killed by an item/ability
  local killerAbility = nil

  if keys.entindex_inflictor ~= nil then
    killerAbility = EntIndexToHScript( keys.entindex_inflictor )
  end

  local damagebits = keys.damagebits -- This might always be 0 and therefore useless

  -- Put code here to handle when an entity gets killed
end

-- This function is called 1 to 2 times as the player connects initially but before they 
-- have completely connected
function SplitterTD:PlayerConnect(keys)
  DebugPrint('[SPLITTERTD] PlayerConnect')
  DebugPrintTable(keys)
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function SplitterTD:OnConnectFull(keys)
  DebugPrint('[SPLITTERTD] OnConnectFull')
  DebugPrintTable(keys)

  SplitterTD:_OnConnectFull(keys)
  
  local entIndex = keys.index+1
  -- The Player entity of the joining user
  local ply = EntIndexToHScript(entIndex)
  
  -- The Player ID of the joining player
  local playerID = ply:GetPlayerID()
end

-- This function is called whenever illusions are created and tells you which was/is the original entity
function SplitterTD:OnIllusionsCreated(keys)
  DebugPrint('[SPLITTERTD] OnIllusionsCreated')
  DebugPrintTable(keys)

  local originalEntity = EntIndexToHScript(keys.original_entindex)
end

-- This function is called whenever an item is combined to create a new item
function SplitterTD:OnItemCombined(keys)
  DebugPrint('[SPLITTERTD] OnItemCombined')
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end
  local player = PlayerResource:GetPlayer(plyID)

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
end

-- This function is called whenever an ability begins its PhaseStart phase (but before it is actually cast)
function SplitterTD:OnAbilityCastBegins(keys)
  DebugPrint('[SPLITTERTD] OnAbilityCastBegins')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityName = keys.abilityname
end

-- This function is called whenever a tower is killed
function SplitterTD:OnTowerKill(keys)
  DebugPrint('[SPLITTERTD] OnTowerKill')
  DebugPrintTable(keys)

  local gold = keys.gold
  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local team = keys.teamnumber
end

-- This function is called whenever a player changes there custom team selection during Game Setup 
function SplitterTD:OnPlayerSelectedCustomTeam(keys)
  DebugPrint('[SPLITTERTD] OnPlayerSelectedCustomTeam')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.player_id)
  local success = (keys.success == 1)
  local team = keys.team_id
end

-- This function is called whenever an NPC reaches its goal position/target
function SplitterTD:OnNPCGoalReached(keys)
  DebugPrint('[SPLITTERTD] OnNPCGoalReached')
  DebugPrintTable(keys)

  local goalEntity = EntIndexToHScript(keys.goal_entindex)
  local nextGoalEntity = EntIndexToHScript(keys.next_goal_entindex)
  local npc = EntIndexToHScript(keys.npc_entindex)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitSplitterTD() but needs to be done before everyone loads in.
]]
function SplitterTD:OnFirstPlayerLoaded()
  DebugPrint("[SPLITTERTD] First Player has loaded")
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function SplitterTD:OnAllPlayersLoaded()
  DebugPrint("[SPLITTERTD] All Players have loaded into the game")
end

-- A player picked a hero
function SplitterTD:OnPlayerPickHero(keys)

  local hero = EntIndexToHScript(keys.heroindex)
  local player = EntIndexToHScript(keys.player)
  local playerID = hero:GetPlayerID()

  -- Initialize Variables for Tracking
  player.units = {} -- This keeps the handle of all the units of the player, to iterate for unlocking upgrades
  player.structures = {} -- This keeps the handle of the constructed units, to iterate for unlocking upgrades
  player.buildings = {} -- This keeps the name and quantity of each building
  player.upgrades = {} -- This kees the name of all the upgrades researched
  player.lumber = 0 -- Secondary resource of the player

    -- Create city center in front of the hero
    local position = hero:GetAbsOrigin() + hero:GetForwardVector() * 300
    local city_center_name = "city_center"
  local building = BuildingHelper:PlaceBuilding(player, city_center_name, position, true, 5) 

  -- Set health to test repair
  building:SetHealth(building:GetMaxHealth()/3)

  -- These are required for repair to know how many resources the building takes
  building.GoldCost = 100
  building.LumberCost = 100
  building.BuildTime = 15

  -- Add the building to the player structures list
  player.buildings[city_center_name] = 1
  table.insert(player.structures, building)

  CheckAbilityRequirements( hero, player )
  CheckAbilityRequirements( building, player )

  -- Add the hero to the player units list
  table.insert(player.units, hero)
  hero.state = "idle" --Builder state

  -- Spawn some peasants around the hero
  local position = hero:GetAbsOrigin()
  local numBuilders = 5
  local angle = 360/numBuilders
  for i=1,5 do
    local rotate_pos = position + Vector(1,0,0) * 100
    local builder_pos = RotatePosition(position, QAngle(0, angle*i, 0), rotate_pos)

    local builder = CreateUnitByName("peasant", builder_pos, true, hero, hero, hero:GetTeamNumber())
    builder:SetOwner(hero)
    builder:SetControllableByPlayer(playerID, true)
    table.insert(player.units, builder)
    builder.state = "idle"

    -- Go through the abilities and upgrade
    CheckAbilityRequirements( builder, player )
  end

  -- Give Initial Resources
  hero:SetGold(5000, false)
  ModifyLumber(player, 5000)

  -- Lumber tick
  Timers:CreateTimer(1, function()
    ModifyLumber(player, 10)
    return 10
  end)

  -- Give a building ability
  local item = CreateItem("item_build_wall", hero, hero)
  hero:AddItem(item)

  -- Learn all abilities (this isn't necessary on creatures)
  for i=0,15 do
    local ability = hero:GetAbilityByIndex(i)
    if ability then ability:SetLevel(ability:GetMaxLevel()) end
  end
  hero:SetAbilityPoints(0)

end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]
function SplitterTD:OnHeroInGame(hero)
  DebugPrint("[SPLITTERTD] Hero spawned in game for first time -- " .. hero:GetUnitName())

  -- This line for example will set the starting gold of every hero to 500 unreliable gold
  --hero:SetGold(500, false)

  -- These lines will create an item and add it to the player, effectively ensuring they start with the item
  --local item = CreateItem("item_example_item", hero, hero)
  --hero:AddItem(item)

  --[[ --These lines if uncommented will replace the W ability of any hero that loads into the game
    --with the "example_ability" ability

  local abil = hero:GetAbilityByIndex(1)
  hero:RemoveAbility(abil:GetAbilityName())
  hero:AddAbility("example_ability")]]
end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function SplitterTD:OnGameInProgress()
  DebugPrint("[SPLITTERTD] The game has officially begun")

  SpawnWave()
  
  Timers:CreateTimer(30, -- Start this timer 30 game-time seconds later
    function()
      DebugPrint("This function is called 30 seconds after the game begins, and every 30 seconds thereafter")
      return 30.0 -- Rerun this timer every 30 game-time seconds 
    end)
end

function SpawnWave()
  local name = 'wave1'
  local spawner = Entities:FindByName(nil, 'splitter_spawner_goodguys')
  local vec = spawner:GetOrigin()
  local unit = CreateUnitByName(name, vec, true, nil, nil, DOTA_TEAM_NEUTRALS)
end

-- Called whenever a player changes its current selection, it keeps a list of entity indexes
function SplitterTD:OnPlayerSelectedEntities( event )
  local pID = event.pID

  GameRules.SELECTED_UNITS[pID] = event.selected_entities

  -- This is for Building Helper to know which is the currently active builder
  local mainSelected = GetMainSelectedEntity(pID)
  if IsValidEntity(mainSelected) and IsBuilder(mainSelected) then
    local player = PlayerResource:GetPlayer(pID)
    player.activeBuilder = mainSelected
  end
end