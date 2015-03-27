

------------------------
-- initialization
------------------------
-- only players with this priv are able to expand the platform with the expander
minetest.register_privilege("skyplatform", { description = "allows to expand the skyplatform", give_to_singleplayer = true});

skyplatform = {}

dofile(minetest.get_modpath( 'skyplatform' ).."/config.lua")


-- override mapgen and set it to singlenode/air
minetest.set_mapgen_params( { mgname = 'singlenode', seed = 1, water_level = 0, flags = air});


for k,v in pairs( skyplatform.replacements ) do
	-- make sure the chests are replaced with expanders
	table.insert( skyplatform.replacements[ k ], {'default:chest', 'skyplatform:expand' } );
end


------------------------
-- functions
------------------------
skyplatform.update_formspec = function( pos )
	if( not( pos )) then
		return;
	end

	-- create the formspec once
	if( not( skyplatform.formspec )) then

		skyplatform.formspec = "size[12,10]"..
                            "label[3.3,0.0;Land expander for skyplatform]"..
                            "textarea[1.0,1.6;10,0.8;info;info;Click on one of the options in order to expand the platform.]";
		local x = 0;
		local y = 0;
		local i = 0;
		for k,v in pairs( skyplatform.replacements ) do
			i = i+1;

			-- new column
			if( y==8 ) then
				x = x+4;
				y = 0;
			end
			skyplatform.formspec = skyplatform.formspec .."button_exit["..(x)..","..(y+2.5)..";4,0.5;replace;"..k.."]";
			y = y+1;
		end
	end

	local meta = minetest.get_meta( pos );
	meta:set_string( 'formspec', skyplatform.formspec );
end


-- TODO: expand the platform if the player pays i.e. a mese block
skyplatform.on_receive_fields = function(pos, formname, fields, player)

	local pname = player:get_player_name();

	if( not( fields[ 'replace' ] ) or not( skyplatform.replacements[ fields[ 'replace' ]]  )) then
		return;
	end

	if( not( minetest.check_player_privs(player:get_player_name(), {skyplatform=true}))) then
		minetest.chat_send_player( pname, 'You need the skyplatform priv in order to expand this platform.');
		return;
	end

	local p = {x=pos.x, y=pos.y, z=pos.z};
	-- determine the right position for the schematic that contains the platform
	local node = minetest.get_node( pos );

	local param2 = node.param2;
	if(     param2 == 1 ) then
		p = { x=(pos.x),                                    y=(pos.y-skyplatform.HEIGHT), z=(pos.z-math.floor(skyplatform.SIZE/2)+1)};

	elseif( param2 == 3 ) then
		p = { x=(pos.x - skyplatform.SIZE+1),               y=(pos.y-skyplatform.HEIGHT), z=(pos.z-math.floor(skyplatform.SIZE/2))};

	elseif( param2 == 2 ) then
		p = { x=(pos.x - math.floor(skyplatform.SIZE/2)+1), y=(pos.y-skyplatform.HEIGHT), z=(pos.z-           skyplatform.SIZE+1) };

	elseif( param2 == 0 ) then
		p = { x=(pos.x - math.floor(skyplatform.SIZE/2)),   y=(pos.y-skyplatform.HEIGHT), z=(pos.z)                             };

	end


	-- build walls around the new platform so that water stays inside and players do not fall from the platform
	local pc = {x=p.x, y=p.y, z=(p.z-1)}; -- corner 1
	node = minetest.get_node( {x=math.floor(pc.x+skyplatform.SIZE/2), y=pc.y, z=pc.z });
	if( param2 ~= 0 and node and node.name and node.name == 'air' ) then
		minetest.place_schematic( pc, skyplatform.WALL, "180", {}, true );
	end

	pc = {x=p.x, y=p.y, z=(p.z+skyplatform.SIZE)};
	node = minetest.get_node( {x=math.floor(pc.x+skyplatform.SIZE/2), y=pc.y, z=pc.z });
	if( param2 ~= 2 and node and node.name and node.name == 'air' ) then
		minetest.place_schematic( pc, skyplatform.WALL, "0",   {}, true );
	end

	pc = {x=(p.x-1), y=p.y, z=p.z};
	node = minetest.get_node( {x=pc.x, y=pc.y, z=math.floor(pc.z+skyplatform.SIZE/2) });
	if( param2 ~= 1 and node and node.name and node.name == 'air' ) then
		minetest.place_schematic( pc, skyplatform.WALL, "270", {}, true );
	end

	pc = {x=(p.x+skyplatform.SIZE), y=p.y, z=p.z};
	node = minetest.get_node( {x=pc.x, y=pc.y, z=math.floor(pc.z+skyplatform.SIZE/2) });
	if( param2 ~= 3 and node and node.name and node.name == 'air' ) then
		minetest.place_schematic( pc, skyplatform.WALL, "90", {}, true );
	end


	-- remove the wall in front of the player
	repl = { { 'default:cloud', 'air'}, { 'skyblock:horizon', 'air' }, { 'skyblock:expand', 'air' } };
	-- place the schematic while not replacing existing nodes
	minetest.place_schematic( p, skyplatform.SCHEMATIC, "0", skyplatform.replacements[ fields[ 'replace' ]], true );

	-- TODO: update and initialize skyplatform:expand
end


-- create a new platform
skyplatform.new_platform = function( player, height, loopcount )

	if( not( player ) or not( height ) or height<-30000 or height >30000 or height%100>0 ) then
		return;
	end
	local p = {x=math.floor(0-skyplatform.SIZE/2), y=math.floor(height-skyplatform.HEIGHT+1), z=math.floor(0-skyplatform.SIZE/2)};
	player:setpos( {x=0,y=height+3,z=0} );

	if( not( loopcount )) then
		loopcount = 0;
	end
	local node = minetest.get_node( {x=0,y=height-2,z=0}  );
	--if( height ~= 0 ) then
		if( not( node ) or not( node.name ) or node.name == 'ignore' ) then
			-- abort if there's no success after some time
			if( loopcount > 5 ) then
				minetest.chat_send_player( player:get_player_name(),
						'The place where the skyplatform is supposed to spawn is still '..
					'unloaded. Giving up. Try again later!');
				return;
			end
			minetest.after( 1, skyplatform.new_platform, player, height, loopcount+1 );
			return;
		end

		if( node and node.name and node.name~='air') then
			if( height ~= 0 ) then
				minetest.chat_send_player( player:get_player_name(),
					'Cannot create a new sky platform at height '..tostring( height)..
					'. Please remove the nodes there first!');
				player:setpos( {x=0, y=height, z=0} );
			end
			return;
		end
	--end

	-- place the initial sky platform
	minetest.place_schematic( p, skyplatform.SCHEMATIC, "0", skyplatform.replacements[ skyplatform.start_platform_type ], true );

	-- build walls around the new platform so that water stays inside and players do not fall from the platform
	local pc = {x=p.x, y=p.y, z=(p.z-1)}; -- corner 1
	minetest.place_schematic( pc, skyplatform.WALL, "180", {}, true );

	pc = {x=p.x, y=p.y, z=(p.z+skyplatform.SIZE)};
	minetest.place_schematic( pc, skyplatform.WALL, "0",   {}, true );

	pc = {x=(p.x-1), y=p.y, z=p.z};
	minetest.place_schematic( pc, skyplatform.WALL, "270", {}, true );

	pc = {x=(p.x+skyplatform.SIZE), y=p.y, z=p.z};
	minetest.place_schematic( pc, skyplatform.WALL, "90",  {}, true );

	p.y = p.y + 1;
	player:setpos( {x=0, y=height+3, z=0 });

	minetest.chat_send_player( player:get_player_name(),
			'Successfully created a new sky platform at height '..tostring( height )..'.');
end


------------------------
-- node definitions
------------------------
-- the chest that offers a formspec and allows to expand the sky platform
minetest.register_node("skyplatform:expand", {
	description = "Land expander for the skyplatform",
	tiles = {"default_chest_top.png", "default_chest_top.png", "default_chest_side.png",
		"default_chest_side.png", "default_chest_side.png", "default_chest_lock.png"},
	paramtype2 = "facedir",
	groups = {choppy=2,oddly_breakable_by_hand=2, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	is_ground_content = false,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Land expander for skyplatform. Right-click in order to add more land.");
		skyplatform.update_formspec( pos );
	end,

	-- normal digging is not possible; trying to do so can be used to update the formspec
	can_dig = function(pos,player)
		minetest.chat_send_player( player:get_player_name(),
			'This expander can only be removed by expanding the area. Right-click it in order to do so.');
		skyplatform.update_formspec( pos );
		return false;	
	end,

	on_receive_fields = function( pos, formname, fields, player )
		return skyplatform.on_receive_fields(pos, formname, fields, player);
	end,

--[[
	on_rightclick = function(pos, node, clicker)

		skyplatform.update_formspec( pos );
		minetest.show_formspec(
				clicker:get_player_name(),
				"default:chest_locked",
                                get_locked_chest_formspec(pos)
		)
        end,
--]]
})



-- forms the wall around the platform; similar color as the sky
minetest.register_node("skyplatform:horizon", {
        description = "Horizon",
        tiles = {"default_cloud.png^[colorize:#0099FF:90"},
        groups = {not_in_creative_inventory=1, immortal=1},
})



-----------------------------
-- handle spawning of players
-----------------------------
local function spawnplayer(player)
	if( minetest.setting_get("static_spawnpoint")) then
		return;
	end

	minetest.set_node( skyplatform.spawn_pos, {name='default:brick'});
	player:setpos( skyplatform.spawn_pos );
	skyplatform.new_platform( player, 0, 0 );
end

minetest.register_on_newplayer(function(player)
        spawnplayer(player)
end)

minetest.register_on_respawnplayer(function(player)
        spawnplayer(player)
        return true
end)



----------------------------
-- chat commands
----------------------------
-- create a new sky platform at a new height
minetest.register_chatcommand( 'newskyplatform', {
	description = "Creates a new sky platform at the given height. Requires the skyplatform priv.",
	params = '<height>',
        privs = {skyplatform=true},
	func = function(name, param)

		if( not( minetest.check_player_privs( name, {skyplatform=true}))) then
			minetest.chat_send_player( name, 'You need the skyplatform priv in order to create a new platform.');
			return;
		end

		if( not(param) or param=="") then
			minetest.chat_send_player( name, 'At which height do you want your new skyplatform to be? Usage: /skyplatform <height>');
			return;
		end

		local height = tonumber( param );
		if( height<-30000 or height>30000 or height%100>0 ) then
			minetest.chat_send_player( name, 'Height \''..tostring(height)..
				'\' not supported. Use a value between -30000..30000 that can be divided by 100.');
			return;
		end
		local player = minetest.get_player_by_name( name );
		if( player ) then
			skyplatform.new_platform( player, height, 0 );
		end
	end
});

-- a /spawn command is always useful
minetest.register_chatcommand( 'spawn', {
	description = "Teleport back to spawn.",
        privs = {},
	func = function(name, param)
		spawnplayer( minetest.get_player_by_name( name ));
	end
});

