DEBUG_SPEW = 1

function SplitterTD:InitGameMode()
	SplitterTD = self
	DebugPrint('[SPLITTERTD] Starting to load SplitterTD gamemode...')

	-- Call the internal function to set up the rules/behaviors specified in constants.lua
	-- This also sets up event hooks for all event handlers in events.lua
	-- Check out internals/gamemode to see/modify the exact code
	SplitterTD:_InitSplitterTD()

	-- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
	--Convars:RegisterCommand( "command_example", Dynamic_Wrap(SplitterTD, 'ExampleConsoleCommand'), "A console command example", FCVAR_CHEAT )

	DebugPrint('[SPLITTERTD] Done loading SplitterTD gamemode!\n\n')


	-- Get Rid of Shop button - Change the UI Layout if you want a shop button
	GameRules:GetGameModeEntity():SetHUDVisible(6, false)
	GameRules:GetGameModeEntity():SetCameraDistanceOverride(1300)

	-- DebugPrint
	Convars:RegisterConvar('debug_spew', tostring(DEBUG_SPEW), 'Set to 1 to start spewing debug info. Set to 0 to disable.', 0)
	
	-- Full units file to get the custom values
	GameRules.AbilityKV = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
  	GameRules.UnitKV = LoadKeyValues("scripts/npc/npc_units_custom.txt")
  	GameRules.HeroKV = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")
  	GameRules.ItemKV = LoadKeyValues("scripts/npc/npc_items_custom.txt")
  	GameRules.Requirements = LoadKeyValues("scripts/kv/tech_tree.kv")
  	GameRules.Waves = LoadKeyValues("scripts/kv/splitter_waves.kv")

  	-- Store and update selected units of each pID
	GameRules.SELECTED_UNITS = {}

	-- Keeps the blighted gridnav positions
	GameRules.Blight = {}
end

--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function SplitterTD:PostLoadPrecache()
  DebugPrint("[SPLITTERTD] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

