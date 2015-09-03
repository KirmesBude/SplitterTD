---------------------------------------------------------------------------

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')
--This library can be used ...
require('libraries/popups')
--Utility
require('internal/util')

if SplitterTD == nil then
  	DebugPrint( '[SPLITTERTD] creating splittertd game mode' )
	_G.SplitterTD = class({})
end

-- settings.lua is where you can specify many different properties for your game mode and is one of the core splittertd files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core splittertd files.
require('events')


-- These internal libraries set up splittertd's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/splittertd')
require('internal/events')


require('gamemode')
require('splittertd_spawner')


--Buildinghelper library
require('internal/buildinghelper/upgrades')
require('internal/buildinghelper/mechanics')
require('internal/buildinghelper/orders')
require('internal/buildinghelper/builder')
require('internal/buildinghelper/buildinghelper')

--Buildinghelper splittertd extension
require('internal/buildinghelper/buildinghelper_splittertd')
require('internal/buildinghelper/builder_splittertd')


function Precache( context )
	--[[
  This function is used to precache resources/units/items/abilities that will be needed
  for sure in your game and that will not be precached by hero selection.  When a hero
  is selected from the hero selection screen, the game will precache that hero's assets,
  any equipped cosmetics, and perform the data-driven precaching defined in that hero's
  precache{} block, as well as the precache{} block for any equipped abilities.

  See SplitterTD:PostLoadPrecache() in gamemode.lua for more information
  ]]

  DebugPrint("[SPLITTERTD] Performing pre-load precache")

  -- Particles can be precached individually or by folder
  -- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
  PrecacheResource("particle", "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", context)
  PrecacheResource("particle_folder", "particles/test_particle", context)

  -- Models can also be precached by folder or individually
  -- PrecacheModel should generally used over PrecacheResource for individual models
  PrecacheResource("model_folder", "particles/heroes/antimage", context)
  PrecacheResource("model", "particles/heroes/viper/viper.vmdl", context)
  PrecacheModel("models/heroes/viper/viper.vmdl", context)

  -- Sounds can precached here like anything else
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context)

  -- Entire items can be precached by name
  -- Abilities can also be precached in this way despite the name
  PrecacheItemByNameSync("example_ability", context)
  PrecacheItemByNameSync("item_example_item", context)

  -- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
  -- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
  PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
  PrecacheUnitByNameSync("npc_dota_hero_enigma", context)
  
	-- Model ghost and grid particles
	PrecacheResource("particle_folder", "particles/buildinghelper", context)
	PrecacheResource("particle_folder", "particles/econ/items/earthshaker/earthshaker_gravelmaw/", context)

	-- Resources used
	PrecacheUnitByNameSync("peasant", context)
	PrecacheUnitByNameSync("tower", context)
	PrecacheUnitByNameSync("tower_tier2", context)
	PrecacheUnitByNameSync("city_center", context)
	PrecacheUnitByNameSync("city_center_tier2", context)
	PrecacheUnitByNameSync("tech_center", context)
	PrecacheUnitByNameSync("dragon_tower", context)
	PrecacheUnitByNameSync("dark_tower", context)
	PrecacheUnitByNameSync("wall", context)

	PrecacheItemByNameSync("item_apply_modifiers", context)

end

-- Create our game mode and initialize it
function Activate()
	SplitterTD:InitGameMode()
  SplitterTD_Spawner:Init()
end

---------------------------------------------------------------------------




--[[
	OUT OF VECTOR IS CAUSING ISSUES? CNetworkOriginCellCoordQuantizedVector m_cellZ cell 155 is outside of cell bounds (0->128) @(-15714.285156 -15714.285156 23405.712891)
	NEED TO ADD ABILITY_BUILDING AND QUEUE MANUALLY, NECESSARY?
	COLLISION SIZE?
]]--