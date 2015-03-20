-- the first skyplatform will appear here
skyplatform.spawn_pos = {x=0,y=0,z=0}

-- path to the schematic
skyplatform.SCHEMATIC = minetest.get_modpath("skyplatform")..'/schems/platform.mts';
skyplatform.WALL      = minetest.get_modpath("skyplatform")..'/schems/skyplatform_wall.mts';

-- the size of the platform; important for calculating offsets;
-- Note: the value depends on the schematic you're using
skyplatform.SIZE   =  100; 
-- how far do we have to go down from the expanders position in
-- order to place the new platform?
skyplatform.HEIGHT =   11;

-- the spawn skyplatform and each following one created with the
-- /newskyplatform command will have this type
skyplatform.start_platform_type = 'no_road';

-- All those diffrent types of skyplatforms araise from the same
-- basic schematic - where diffrent materials get replaced by
-- others. You can add your own type here!
skyplatform.replacements = { plain = {},
--[[
		{
		-- layers of 100x100 blocks, each 1 block high
		{'default:sandstonebrick',   '' ),
		{'default:stone_with_coal',  '' },
		{'default:stone_with_iron',  '' },
		{'default:diamondblock',     '' },
		{'default:clay',             '' },
		{'default:brick',            '' },
		{'default:desert_stonebrick','' },
		{'default:desert_stone',     '' },
		{'default:stonebrick',       '' },
		{'default:cobble',           '' },
		{'default:stone',            '' },
		-- ground and borders
		{'default:cloud',            '' },

		{'default:fence_wood',       '' },

		-- north-south-road
		{'default:coalblock',        '' },
		{'wool:white',               '' },
		{'default:gravel',           '' },
		{'stairs:slab_cobble',       '' },
		
		-- east-west-road
		{'default:obsidian',         '' },
		{'wool:grey',                '' },
		{'default:obsidian_glass',   '' },
		{'stairs:slab_sandstone',    '' },
		},
--]]
	normal = { 
		{'default:sandstonebrick',   'air' },
		{'default:stone_with_coal',  'default:dirt_with_grass' },
		{'default:stone_with_iron',  'default:dirt' },
		{'default:diamondblock',     'default:dirt' },
		{'default:clay',             'default:stone' },
		{'default:brick',            'default:stone' },
		{'default:desert_stonebrick','default:stone' },
		{'default:desert_stone',     'default:stone' },
		{'default:stonebrick',       'default:stone' },
		{'default:cobble',           'default:stone' },
		{'default:stone',            'default:stone' },

		-- north-south-road
		{'default:coalblock',        'default:obsidian' },
--		{'wool:white',               '' },
		{'default:gravel',           'default:obsidian' },
		{'stairs:slab_cobble',       'stairs:slab_stone' },
		
		-- east-west-road
--		{'default:obsidian',         '' },
		{'wool:grey',                'wool:white' },
		{'default:obsidian_glass',   'default:obsidian' },
		{'stairs:slab_sandstone',    'stairs:slab_stone' },
		},

	lake = { 
		{'default:sandstonebrick',   'air' },
		{'default:stone_with_coal',  'default:water_source' },
		{'default:stone_with_iron',  'default:dirt' },
		{'default:diamondblock',     'default:clay' },
		{'default:clay',             'default:stone' },
		{'default:brick',            'default:stone' },
		{'default:desert_stonebrick','default:stone' },
		{'default:desert_stone',     'default:stone' },
		{'default:stonebrick',       'default:stone' },
		{'default:cobble',           'default:stone' },
		{'default:stone',            'default:stone' },

		-- north-south-road
		{'default:coalblock',        'default:obsidian' },
--		{'wool:white',               '' },
		{'default:gravel',           'default:obsidian' },
		{'stairs:slab_cobble',       'stairs:slab_stone' },
		
		-- east-west-road
--		{'default:obsidian',         '' },
		{'wool:grey',                'wool:white' },
		{'default:obsidian_glass',   'default:obsidian' },
		{'stairs:slab_sandstone',    'stairs:slab_stone' },
		},

	ocean = { 
		{'default:sandstonebrick',   'air' },
		{'default:stone_with_coal',  'default:water_source' },
		{'default:stone_with_iron',  'default:water_source' },
		{'default:diamondblock',     'default:water_source' },
		{'default:clay',             'default:water_source' },
		{'default:brick',            'default:water_source' },
		{'default:desert_stonebrick','default:water_source' },
		{'default:desert_stone',     'default:water_source' },
		{'default:stonebrick',       'default:water_source' },
		{'default:cobble',           'default:water_source' },
		{'default:stone',            'default:sand' },

		-- north-south-road
		{'default:coalblock',        'default:obsidian' },
--		{'wool:white',               '' },
		{'default:gravel',           'default:obsidian' },
		{'stairs:slab_cobble',       'stairs:slab_stone' },
		
		-- east-west-road
--		{'default:obsidian',         '' },
		{'wool:grey',                'wool:white' },
		{'default:obsidian_glass',   'default:obsidian' },
		{'stairs:slab_sandstone',    'stairs:slab_stone' },
		},

	no_road = { 
		{'default:sandstonebrick',   'air' },
		{'default:stone_with_coal',  'default:dirt_with_grass' },
		{'default:stone_with_iron',  'default:dirt' },
		{'default:diamondblock',     'default:dirt' },
		{'default:clay',             'default:stone' },
		{'default:brick',            'default:stone' },
		{'default:desert_stonebrick','default:stone' },
		{'default:desert_stone',     'default:stone' },
		{'default:stonebrick',       'default:stone' },
		{'default:cobble',           'default:stone' },
--		{'default:stone',            'default:stone' },

		-- north-south-road
		{'default:coalblock',        'default:dirt_with_grass' },
		{'wool:white',               'default:dirt_with_grass' },
		{'default:gravel',           'default:dirt_with_grass' },
		{'stairs:slab_cobble',       'air' },
		
		-- east-west-road
		{'default:obsidian',         'default:dirt_with_grass' },
		{'wool:grey',                'default:dirt_with_grass' },
		{'default:obsidian_glass',   'default:dirt_with_grass' },
		{'stairs:slab_sandstone',    'air' },
		},

	desert = { 
		{'default:sandstonebrick',   'air' },
		{'default:stone_with_coal',  'default:desert_sand' },
		{'default:stone_with_iron',  'default:desert_sand' },
		{'default:diamondblock',     'default:desert_sand' },
		{'default:clay',             'default:desert_sand' },
		{'default:brick',            'default:desert_sand' },
		{'default:desert_stonebrick','default:desert_stone' },
--		{'default:desert_stone',     'default:desert_stone' },
		{'default:stonebrick',       'default:desert_stone' },
		{'default:cobble',           'default:desert_stone' },
		{'default:stone',            'default:desert_stone' },

		-- north-south-road
		{'default:coalblock',        'default:obsidian' },
--		{'wool:white',               '' },
		{'default:gravel',           'default:obsidian' },
		{'stairs:slab_cobble',       'stairs:slab_stone' },
		
		-- east-west-road
--		{'default:obsidian',         '' },
		{'wool:grey',                'wool:white' },
		{'default:obsidian_glass',   'default:obsidian' },
		{'stairs:slab_sandstone',    'stairs:slab_stone' },
		},

	beach  = { 
		{'default:sandstonebrick',   'air' },
		{'default:stone_with_coal',  'default:sand' },
		{'default:stone_with_iron',  'default:sand' },
		{'default:diamondblock',     'default:sand' },
		{'default:clay',             'default:sand' },
		{'default:brick',            'default:sand' },
		{'default:desert_stonebrick','default:sandstone' },
		{'default:desert_stone',     'default:sandstone' },
		{'default:stonebrick',       'default:sandstone' },
		{'default:cobble',           'default:sandstone' },
		{'default:stone',            'default:sandstone' },

		-- north-south-road
		{'default:coalblock',        'default:obsidian' },
--		{'wool:white',               '' },
		{'default:gravel',           'default:obsidian' },
		{'stairs:slab_cobble',       'stairs:slab_stone' },
		
		-- east-west-road
--		{'default:obsidian',         '' },
		{'wool:grey',                'wool:white' },
		{'default:obsidian_glass',   'default:obsidian' },
		{'stairs:slab_sandstone',    'stairs:slab_stone' },
		},

	cave   = { 
		{'default:sandstonebrick',   'air' },
		{'default:stone_with_coal',  'default:stone' },
		{'default:stone_with_iron',  'air' },
		{'default:diamondblock',     'air' },
		{'default:clay',             'air' },
		{'default:brick',            'air' },
		{'default:desert_stonebrick','air' },
		{'default:desert_stone',     'air' },
		{'default:stonebrick',       'air' },
		{'default:cobble',           'air' },
		{'default:stone',            'default:stone' },

		-- north-south-road
		{'default:coalblock',        'default:obsidian' },
--		{'wool:white',               '' },
		{'default:gravel',           'default:obsidian' },
		{'stairs:slab_cobble',       'stairs:slab_stone' },
		
		-- east-west-road
--		{'default:obsidian',         '' },
		{'wool:grey',                'wool:white' },
		{'default:obsidian_glass',   'default:obsidian' },
		{'stairs:slab_sandstone',    'stairs:slab_stone' },
		},

	road_north_south = { 
		{'default:sandstonebrick',   'air' },
		{'default:stone_with_coal',  'default:dirt_with_grass' },
		{'default:stone_with_iron',  'default:dirt' },
		{'default:diamondblock',     'default:dirt' },
		{'default:clay',             'default:stone' },
		{'default:brick',            'default:stone' },
		{'default:desert_stonebrick','default:stone' },
		{'default:desert_stone',     'default:stone' },
		{'default:stonebrick',       'default:stone' },
		{'default:cobble',           'default:stone' },
		{'default:stone',            'default:stone' },

		-- north-south-road
		{'default:coalblock',        'default:obsidian' },
--		{'wool:white',               '' },
		{'default:gravel',           'default:obsidian' },
		{'stairs:slab_cobble',       'stairs:slab_stone' },
		
		-- east-west-road
		{'default:obsidian',         'default:dirt_with_grass' },
		{'wool:grey',                'default:dirt_with_grass' },
		{'default:obsidian_glass',   'default:dirt_with_grass' },
		{'stairs:slab_sandstone',    'air' },
		},

	road_east_west = { 
		{'default:sandstonebrick',   'air' },
		{'default:stone_with_coal',  'default:dirt_with_grass' },
		{'default:stone_with_iron',  'default:dirt' },
		{'default:diamondblock',     'default:dirt' },
		{'default:clay',             'default:stone' },
		{'default:brick',            'default:stone' },
		{'default:desert_stonebrick','default:stone' },
		{'default:desert_stone',     'default:stone' },
		{'default:stonebrick',       'default:stone' },
		{'default:cobble',           'default:stone' },
		{'default:stone',            'default:stone' },

		-- north-south-road
		{'default:coalblock',        'default:dirt_with_grass' },
		{'wool:white',               'default:dirt_with_grass' },
		{'default:gravel',           'default:dirt_with_grass' },
		{'stairs:slab_cobble',       'air' },
		
		-- east-west-road
--		{'default:obsidian',         '' },
		{'wool:grey',                'wool:white' },
		{'default:obsidian_glass',   'default:obsidian' },
		{'stairs:slab_sandstone',    'stairs:slab_stone' },
		},

	wheatfarm = { 
		{'default:sandstonebrick',   'farming:wheat_8' },
		{'default:stone_with_coal',  'farming:soil' },
		{'default:stone_with_iron',  'default:water_source' },
		{'default:diamondblock',     'default:clay' },
		{'default:clay',             'default:dirt' },
		{'default:brick',            'default:dirt' },
		{'default:desert_stonebrick','default:dirt' },
		{'default:desert_stone',     'default:stone' },
		{'default:stonebrick',       'default:stone' },
		{'default:cobble',           'default:stone' },
--		{'default:stone',            'default:stone' },

		-- north-south-road
		{'default:coalblock',        'default:dirt_with_grass' },
		{'wool:white',               'default:dirt_with_grass' },
		{'default:gravel',           'default:dirt_with_grass' },
		{'stairs:slab_cobble',       'air' },
		
		-- east-west-road
		{'default:obsidian',         'default:dirt_with_grass' },
		{'wool:grey',                'default:dirt_with_grass' },
		{'default:obsidian_glass',   'default:dirt_with_grass' },
		{'stairs:slab_sandstone',    'air' },
		},
	 };
