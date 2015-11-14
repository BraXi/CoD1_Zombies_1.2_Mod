///////////////////////////////////////////////////////////////
////|         |///|        |///|       |/\  \/////  ///|  |////
////|  |////  |///|  |//|  |///|  |/|  |//\  \///  ////|__|////
////|  |////  |///|  |//|  |///|  |/|  |///\  \/  /////////////
////|          |//|  |//|  |///|       |////\    //////|  |////
////|  |////|  |//|         |//|  |/|  |/////    \/////|  |////
////|  |////|  |//|  |///|  |//|  |/|  |////  /\  \////|  |////
////|  |////|  |//|  | //|  |//|  |/|  |///  ///\  \///|  |////
////|__________|//|__|///|__|//|__|/|__|//__/////\__\//|__|////
///////////////////////////////////////////////////////////////
//
//	Zombie Mod by BraXi v1.2
//	Original source code from https://github.com/BraXi/CoD1_Zombies_1.2_Mod
//
//	Web: www.braxi.net
//
//
/*
	TO DO LIST:
		- heads and helmets should be in array
*/

main()
{
	cvars();
	precache();

	level.gameStarted = false;
	level.pickZombie = true;
	level.hunters = 0;
	level.zombies = 0;
	level.spectators = undefined;
	level.lastMan = false;
	level.lastManPlayer = undefined;
	level.lastManKiller = undefined;
	level.lastManPicked = false;
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	
	level.spawns = getEntArray( "mp_teamdeathmatch_spawn", "classname" );
	level.map = getCvar( "mapname" );
	level.zombieSpawns = getentarray( "mp_BraXi_zombie_spawn", "classname" );
	level.hunterSpawns = getentarray( "mp_BraXi_hunter_spawn", "classname" );
	level.messages = explode( level.zom["messages"], ";" );
	level.tombstone = [];
	level.tombs = 0;

	level.tombstone_model = [];
	level.tombstone_model[level.tombstone_model.size] = "xmodel/tombstone1";
	level.tombstone_model[level.tombstone_model.size] = "xmodel/tombstone2";
	level.tombstone_model[level.tombstone_model.size] = "xmodel/tombstone3";
	level.tombstone_model[level.tombstone_model.size] = "xmodel/tombstone4";
	level.tombstone_model[level.tombstone_model.size] = "xmodel/tombstone5";
	level.tombstone_model[level.tombstone_model.size] = "xmodel/tombstone6";
	level.tombstone_model[level.tombstone_model.size] = "xmodel/tombstone7";
	level.tombstone_model[level.tombstone_model.size] = "xmodel/tombstone8";
	for( i = 0; i < level.tombstone_model.size; i++ )
		precacheModel( level.tombstone_model[i] );

	thread removeBuggyItems();
	thread startGame();
	thread getBoxCenter();
	thread messages();
	thread gameMonitor();
	maps\mp\gametypes\_vehicles::main();

	if( level.zom["map_vote"] )
		thread maps\mp\gametypes\_mapvote::Init();
	if( level.zom["thunders"] )
		thread thunders();
	if( level.zom["mystery_box"] )
		thread maps\mp\gametypes\_mystery_box::main();

	level.ambPlayer = spawn( "script_model", (100,100,100) );
	level.ambPlayer playLoopSound( "amb_zombie" );	

	if( level.fog["amount"] == 0 )
		level.fog["amount"] = 0.000000000001;

	if( level.map != "bx_pipe" && level.map != "bx_zombox" )
	{
		if( level.zom["dark_sky"] )
			thread darkSky();

		setExpFog(level.fog["amount"], level.fog["red"], level.fog["green"], level.fog["blue"], 0);
	}

	for(i = 0; i < level.zombieSpawns.size; i++)
		level.zombieSpawns[i] placeSpawnpoint();
	for(i = 0; i < level.hunterSpawns.size; i++)
		level.hunterSpawns[i] placeSpawnpoint();

	thread addBotClients();
}

cvars()
{
	level.zom["warmup_time"] = addCvar( "scr_warmuptime", 90, 10, 240, "float" );
	level.zom["dark_sky"] = addCvar( "scr_darksky", 1, 0, 1, "int" );
	level.zom["game_cam"] = addCvar( "scr_game_cam", 1, 0, 1, "int" );
	level.zom["lastzombie"] = addCvar( "scr_last_zombie", 1, 0, 2, "int" );
	level.zom["map_vote"] = addCvar( "scr_map_vote", 1, 0, 1, "int" );
	level.zom["map_vote_time"] = addCvar( "scr_map_vote_time", 15, 10, 60, "float" );
	level.zom["map_vote_replay"] = addCvar( "scr_map_vote_replay", 1, 0, 1, "int" );
	level.zom["lm"] = addCvar( "scr_lastman", 2, 0, 2, "int" );
	level.zom["lm_zoms"] = addCvar( "scr_lastman_zombies", 8, 1, 64, "int" );
	level.zom["draw_best_stats"] = addCvar( "scr_show_best_players", 1, 0, 1, "int" );
	level.zom["thunders"] = addCvar( "scr_thunders", 1, 0, 1, "int" );
	level.zom["blood"] = addCvar( "scr_blood_screen", 1, 0, 1, "int" );
	level.zom["zombie_vision"] = addCvar( "scr_zombie_vision", 1, 0, 1, "int" );
	level.zom["knock_out"] = addCvar( "scr_knockout", 1, 0, 1, "int" );
	level.zom["spawn_up"] = addCvar( "scr_zombie_spawn_from_ground", 1, 0, 1, "int" );
	level.zom["sprint"] = addCvar( "scr_sprint", 8, 2, 60, "float" );
	level.zom["dropAllItems"] = addCvar( "scr_drop_all_items_on_death", 1, 0, 1, "int" );
	level.zom["searchable_bodies"] = addCvar( "scr_searchable_bodies", 1, 0, 1, "int" );
	level.zom["dmginfo"] = addCvar( "scr_hit_info", 1, 0, 1, "int" );
	level.zom["messages"] = addCvar( "scr_messages", "^1Zombie Mod ^4by ^2BraXi;^1Website ^7: ^2www.braxi.net", "", "", "string" );
	level.zom["messages_delay"] = addCvar( "scr_messages_delay", 20, 2, 999, "float" );
	level.zom["spree"] = addCvar( "scr_kill_streaks", 1, 0, 1, "int" );
	level.zom["dmg_for_pack"] = addCvar( "scr_pack_dmg", 450, 10, 9999, "int" );
	level.zom["packs"] = addCvar( "scr_money_packs", 7, 0, 9999, "int" );
	level.zom["packs_for_kill"] = addCvar( "scr_zombie_packs_for_kill", 4, 0, 9999, "int" );
	level.zom["tombstones"] = addCvar( "scr_tombstones", 1, 0, 1, "int" );
	level.zom["pop_head"] = addCvar( "scr_pophead", 1, 0, 1, "int" );
	level.zom["vehicles"] = addCvar( "scr_vehicles", 1, 0, 1, "int" );

	level.zom["mystery_box"] = addCvar( "scr_mysterybox", 1, 0, 1, "int" );
	level.zom["mystery_box_time"] = addCvar( "scr_mysterybox_time", 45, 10, 240, "float" );
	level.zom["mystery_box_delay"] = addCvar( "scr_mysterybox_delay", 35, 10, 240, "float" );
	level.zom["crate_time"] = addCvar( "scr_zombiecrate_time", 20, 10, 300, "float" );
	level.zom["mines"] = addCvar( "scr_mines", 1, 0, 5, "int" );
	level.zom["mine_delay"] = addCvar( "scr_mine_delay", 4, 0, 20, "float" );
	level.zom["mine_speed"] = addCvar( "scr_mine_speed", 256, 1, 9999, "float" );
	level.zom["explodes"] = addCvar( "scr_explode", 5, 0, 20, "int" );
	level.zom["teleporters"] = addCvar( "scr_teleporters", 1, 0, 20, "int" );
//	level.zom["medkits"] = addCvar( "scr_medkits", 2, 0, 20, "int" );
	level.zom["flash_light"] = addCvar( "scr_flashlight", 1, 0, 1, "int" );
	level.zom["defence_bubble"]  = addCvar( "scr_defence_bubble", 1, 0, 1, "int" );
	level.zom["jumps"] = addCvar( "scr_zombie_jumps", 5, 0, 100, "int" );
	level.zom["superzombie"] = addCvar( "scr_super_zombie", 1, 0, 1, "int" );

	level.zom["hunter_health"] = addCvar( "scr_hunter_health", 100, 100, 2000, "int" );
	level.zom["zombie_health"] = addCvar( "scr_zombie_health", 700, 100, 2000, "int" );
	level.zom["hud_hp"] = addCvar( "scr_draw_health", 1, 0, 1, "int" );

	level.zom["zombie_fov"] = addCvar( "scr_zombie_fov", 86, 80, 125, "int" );
	level.zom["body_throws"] = addCvar( "scr_body_throws", 2, 0, 3, "int" );

	level.fog["amount"] = addCvar( "scr_fogamount", 0.0028, 0, 1, "float" );
	level.fog["red"] = addCvar( "scr_fogred", 0, 0, 1, "float" );
	level.fog["green"] = addCvar( "scr_foggreen", 0, 0, 1, "float" );
	level.fog["blue"] = addCvar( "scr_fogblue", 0.001, 0, 1, "float" );

	if( getCvar( "lastzom" ) == "" )
		setCvar( "lastzom", -1 );
}

precache()
{
	precacheShader( "white" );
	precacheShader( "black" );
	precacheShader( "hudStopwatch" );
	precacheShader( "hudStopwatchNeedle" );
	precacheShader( "gfx/hud/death_headshot.dds" );
	precacheShader( "gfx/hud/death_melee.dds" );
	precacheShader( "gfx/hud/death_suicide.dds" );
	precacheShader( "gfx/hud/death_died.dds" );
	precacheShader( "gfx/hud/death_crush.dds" );
	precacheShader( "gfx/hud/hud@blood_01.tga" );
	precacheShader( "gfx/hud/hud@blood_02.tga" );
	precacheShader( "gfx/hud/hud@blood_03.tga" );
	precacheShader( "gfx/hud/hud@objectiveA.tga" );
	precacheShader( "gfx/hud/hud@objectiveA_up.tga" );
	precacheShader( "gfx/hud/hud@objectiveA_down.tga" );
	precacheShader( "gfx/hud/hud@objectiveB.tga" );
	precacheShader( "gfx/hud/hud@objectiveB_up.tga" );
	precacheShader( "gfx/hud/hud@objectiveB_down.tga" );
	precacheShader( "gfx/hud/hud@objectivegoal.tga" );
	precacheShader( "gfx/hud/hud@objectivegoal_up.tga" );
	precacheShader( "gfx/hud/hud@objectivegoal_down.tga" );
	precacheShader( "gfx/hud/objective.tga" );
	precacheShader( "gfx/hud/objective_up.tga" );
	precacheShader( "gfx/hud/objective_down.tga" );
	precacheShader( "gfx/zombie_vision.dds" );
	precacheShader( "gfx/hud/hud@infection.dds" );
	precacheShader( "gfx/hud/hud@hunter.dds" );
	precacheShader( "gfx/hud/hud@zombie.dds" );
	precacheStatusIcon( "gfx/hud/death_headshot.dds" );
	precacheStatusIcon( "gfx/hud/death_melee.dds" );
	precacheStatusIcon( "gfx/hud/death_suicide.dds" );
	precacheStatusIcon( "gfx/hud/death_falling.dds" );
	precacheStatusIcon( "gfx/hud/hud@hunter.dds" );
	precacheStatusIcon( "gfx/hud/hud@zombie.dds" );

	precacheString( &"^2Hunters: " );
	precacheString( &"^1Zombies: " );
	precacheString( &"^2Score as Hunter:^3 " );
	precacheString( &"^2Score as Zombie:^3 " );
	precacheString( &"^1Total Kills:^3 " );
	precacheString( &"^1Bash Kills:^3 " );
	precacheString( &"^1Head Shot Kills:^3 " );
	precacheString( &"^1Deaths:^3 " );
	precacheString( &"Mines:^3 " );
	precacheString( &"Mega jumps:^3 " );
//	precacheString( &"Health:^2 " );
	precacheString( &"^2" );
	precacheString( &"^3Money packs:^3 " );
	precacheString( &"^2Look how ^1Last Man^2 died..." );
	precacheString( &"^1You are dying due to infection..." );
	level.body_search_tip = &"^7Hold MELEE [{+melee}] to search body";
	level.body_searching_message = &"^7Searching...";
	precacheString( level.body_search_tip );
	precacheString( level.body_searching_message );

	precacheItem( "fg42_mp" );
	precacheItem( "knife_mp" );
	precacheItem( "parabolic_knife_mp" );
	precacheItem( "wood_mp" );
	precacheItem( "bottle_mp" );
//	precacheItem( "axe_mp" );
	precacheItem( "body_part_mp" );
	precacheItem( "super_machinegun_mp" );
	precacheItem( "super_plasmagun_mp" );
	precacheItem( "super_railgun_mp" );
	precacheItem( "super_rocketlauncher_mp" );
	precacheItem( "super_shotgun_mp" );
	precacheItem( "panzerfaust_mp" );
	precacheItem( "tnt_mp" );
	precacheItem( "flare_mp" );
	precacheItem( "infection_bomb_mp" );
	precacheItem( "punch_mp" );

	precacheMenu( "stuff" );
	precacheMenu( "voice_chat" );
	precacheMenu( "clientcmd" );
	precacheMenu( "zombie_options" );
	precacheMenu( "credits" );

	precacheShellShock( "knockout" );

	precacheModel( "xmodel/zom_teleporter" );
	precacheModel( "xmodel/zombiemine" );
	precacheModel( "xmodel/crate_misc1_stalingrad" );
	precacheModel( "xmodel/bx_dbubble" );
	precacheModel( "xmodel/crate_ger_rola" );
	precacheModel( "xmodel/weapon_MK2FragGrenade" );
	precacheModel( "xmodel/weapon_colt45" );
	precacheModel( "xmodel/weapon_m1carbine" );
	precacheModel( "xmodel/weapon_thompson" );
	precacheModel( "xmodel/weapon_bar" );
	precacheModel( "xmodel/weapon_springfield" );
	precacheModel( "xmodel/weapon_m1garand" );
	precacheModel( "xmodel/weapon_enfield" );
	precacheModel( "xmodel/weapon_sten" );
	precacheModel( "xmodel/weapon_bren" );
	precacheModel( "xmodel/weapon_mosinnagant" );
	precacheModel( "xmodel/weapon_ppsh" );
	precacheModel( "xmodel/weapon_mosinnagantscoped" );
	precacheModel( "xmodel/weapon_kar98" );
	precacheModel( "xmodel/weapon_mp40" );
	precacheModel( "xmodel/weapon_mp44" );
	precacheModel( "xmodel/weapon_kar98scoped" );
	precacheModel( "xmodel/weapon_panzerfaust" );
	precacheModel( "xmodel/weapon_fg42" );
	precacheModel( "xmodel/mp_bomb1" );
	precacheModel( "xmodel/bx_parachute" );

	level.fx["mine_explode"] = loadFx( "fx/explosions/pathfinder_explosion.efx" );
	level.fx["mine_move"] = loadFx( "fx/misc/sparker.efx" );
	level.fx["gibs"] = loadFx( "fx/quake/gibber.efx" ); 
	level.fx["teleporter"] = loadFx( "fx/atmosphere/overhill_flash.efx" );
	level.fx["flashlight"] = loadFx( "fx/zombie/flash_light.efx" );
	level.fx["dbubble_deploy"] = loadFx( "fx/zombie/bubble_create.efx" );
	level.fx["dbubble_powerdown"] = loadFx( "fx/zombie/bubble_powerdown.efx" );
	level.fx["lighting"] = loadFx( "fx/zombie/lighting.efx" );
	level.fx["zombie_spawn"] = loadFx( "fx/zombie/zombie_spawn.efx" );
	level.fx["green_light_128"] = loadFx( "fx/zombie/green_light_128.efx" );
	level.fx["bubble_hit"] = loadFx( "fx/zombie/bubble_hit.efx" );
	level.fx["blood"][0] = loadFx( "fx/impacts/flesh_hit.efx" );
	level.fx["blood"][1] = loadFx( "fx/impacts/flesh_hit5g.efx" );
	level.fx["blood"][2] = loadFx( "fx/impacts/flesh_hit_noblood.efx" );
}

playerConnect()
{
	self setClientCvar( "r_fastsky", 0 );
	self setClientCvar( "cg_drawstatus", 1 );

	self.boom = level.zom["explodes"];
	self.box_bounds = [];
	self.hud_BloodScreen = [];
	self.packs = level.zom["packs"];
	self.damageAmount = 0;
	self.fastspeed_lives = 0;
	self.shadows = false;
	self.draw_hud = true;
	self.isParachuting = false;
	self.isInVehicle = undefined;
	self.pers["hunter_score"] = 0;
	self.pers["zombie_score"] = 0;
	self.pers["kills"] = 0;
	self.pers["bashes"] = 0;
	self.pers["heads"] = 0;
	self.pers["deaths"] = 0;
	self.kill_spree = 0;
	self.helmetpoped = false;
	self.jumps = level.zom["jumps"];
	self.canUseVSAY = true;
	self.bubble = level.zom["defence_bubble"];
	self.flashLight = false;
	self.thirdPerson = false;
	self.teleporter = level.zom["teleporters"];
//	self.medkits = level.zom["medkits"];
	self.minetimer = undefined;
	self.mines = level.zom["mines"];
	self.isinDBubble = false;
	self.god = false;
	self.goingup = false;
	self.bloodyed = false;
	self.trigmine = false;
	self.sprinttime = 0;
	self.sprinting = false;
	self.sprintpower = level.zom["sprint"] * 10;
	self.sprint_regeneration = false;
	self.maxspeed = 190;
	self.knockout = false;
	self.knocktime = 0;
	self.searching_body = undefined;
	self.pickedMysteryWeapon = false;
	self.infected = false;
	self.isParachuting = false;

	player = self;
	player setClientCvar( "ui_warmuptime", level.zom["warmup_time"] );
	player setClientCvar( "ui_lastman", level.zom["lm"] );
	player setClientCvar( "ui_szombie", level.zom["superzombie"] );
	player setClientCvar( "ui_votemap", level.zom["map_vote"] );
	player setClientCvar( "ui_hhealth", level.zom["hunter_health"] );
	player setClientCvar( "ui_zhealth", level.zom["zombie_health"] );
	player setClientCvar( "ui_mysterybox", level.zom["mystery_box"] );
	player setClientCvar( "ui_sbodies", level.zom["searchable_bodies"] );
	player setClientCvar( "ui_darksky", level.zom["dark_sky"] );
	player setClientCvar( "ui_packs", level.zom["packs"] );

	self thread doHud();
//	self thread binds();
//	self cleanUp();
//	self dynamicShadows();
}

playerDisonnect()
{
	self cleanUp();

	if( isDefined( self.deadlyCrate ) )
	{		
		for ( i = 0; i < self.box_bounds.size; i++ )
		{
			self.box_bounds[i] setContents(0);
			self.box_bounds[i] delete();
		}
		self.deadlyCrate delete();
	}

	if( level.lastMan && isDefined( level.lastManPlayer ) && level.lastManPlayer == self )
		level.lastMan = false;
}

playerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc)
{
	self endon("disconnect");
	self endon("spawned");

	if( self.god || self.goingup )
		return;

	if( !self.helmetpoped && sHitLoc == "helmet" || !self.helmetpoped && sHitLoc == "head" )
	{
		self.helmetpoped = true;
		self popHelmet( vDir, iDamage );
	}

	if( isPlayer( eAttacker ) && eAttacker.pers["team"] == "axis" && self.pers["team"] == "allies" && sWeapon == "infection_bomb_mp" && sMeansOfDeath != "MOD_MELEE" )
	{
		self infection( eAttacker );
	}

	if( isExplosiveDamage( sMeansOfDeath ) && sWeapon != "body_part_mp" && isPlayer( eAttacker ) && self.pers["team"] == "allies" && eAttacker != self )
		return; // no more throwing grenade and going to spec to kill hunters

	if( level.lastMan && isPlayer( eAttacker ) && eAttacker.pers["team"] == "allies" && eAttacker == self && isExplosiveDamage( sMeansOfDeath ) && !isWorldDamage( sMeansOfDeath ) )
		return; // do not blow up self if you're last man

	if( isPlayer( eAttacker ) && eAttacker.pers["team"] == "axis" && self.pers["team"] == "allies" && self.isinDBubble && sMeansOfDeath == "MOD_MELEE" && eAttacker getStance() == "prone" )
		return; // no more bash kills in defence bubble

	if( level.lastMan && sMeansOfDeath != "MOD_MELEE" && isPlayer(eAttacker) && eAttacker.pers["team"] == "allies" )
	{
		if( sWeapon == "super_machinegun_mp" )
			iDamage = 100;
		else if( sWeapon == "super_plasmagun_mp" )
			iDamage = 220;
		else if( sWeapon == "super_shotgun_mp" )
			iDamage = 94;
		else if( sWeapon == "super_railgun_mp" )
			iDamage = self.health + 10;
		else if( sWeapon == "super_rocketlauncher_mp" )
			iDamage = iDamage * 1.15;
	}

	if( sWeapon == "bottle_mp" )
			iDamage = 30;
	else if( sWeapon == "knife_mp" )
		iDamage = 55;
	else if( sWeapon == "parabolic_knife_mp" )
		iDamage = 43;
	else if( sWeapon == "wood_mp" )
		iDamage = self.health + 1;

	if( sWeapon == "tnt_mp" && sMeansOfDeath != "MOD_MELEE" )
		iDamage = iDamage * 0.25;

	if( sMeansOfDeath == "MOD_MELEE" && isDefined(eattacker) && isPlayer(eattacker) && eattacker.pers["team"] != self.pers["team"] )
	{
		self playSound( "zom_bash" );
		playFx( level.fx["blood"][randomInt(3)], self getEye() );
	}

	if( isPlayer( eAttacker ) && isRifle( sWeapon ) && self.pers["team"] == "axis" && sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE" )
		iDamage = self.health + 10;
	else if( isPlayer( eAttacker ) && isRifle( sWeapon ) && self.pers["team"] == "axis" && sHitLoc != "head" && sMeansOfDeath != "MOD_MELEE" )
		iDamage = iDamage * 1.2;

	if( !level.lastMan && isPlayer( eAttacker ) && eAttacker.pers["team"] == "allies" && eAttacker == self && !isWorldDamage( sMeansOfDeath ) )
		iDamage = iDamage * 1.2;

	if( isPlayer( eAttacker ) && level.zom["superzombie"] && level.zombies == 1 && eAttacker.pers["team"] == "axis" && eAttacker != self && sMeansOfDeath == "MOD_MELEE" )
		iDamage = self.health + 10;

	if( level.zom["dmginfo"] && isPlayer( eAttacker ) && eAttacker.pers["team"] != self.pers["team"] )
	{
		eAttacker iPrintln("You hit " + self.name + getHitLoc(sHitLoc) + " ^7for ^4" + iDamage + " ^1damage^7.");
		self iPrintln(eAttacker.name + " ^7hit you" + getHitLoc(sHitLoc) + " ^7for ^4" + iDamage + " ^1damage^7.");
	}

	if( level.zom["blood"] )
	{
		if( isExplosiveDamage( sMeansOfDeath ) && isPlayer(eAttacker) && eAttacker.pers["team"] != self.pers["team"] || sMeansOfDeath == "MOD_MELEE" && eAttacker.pers["team"] != self.pers["team"] )
		{
			if( sMeansOfDeath == "MOD_MELEE" )
			{
				eAttacker thread doBloodScreen();
				self thread doBloodScreen();
			}
			else if( sWeapon != "body_part_mp" && sMeansOfDeath != "MOD_MELEE" )
			{
				players = getEntArray( "player", "classname" );
				for( i = 0; i < players.size; i++ )
				if( distance( players[i].origin, self.origin ) <= 196 )
					players[i] thread doBloodScreen();
			}
		}
	}

	if( isPlayer(eAttacker) && self.pers["team"] == "allies" && eAttacker.pers["team"] == "axis" && sMeansOfDeath == "MOD_MELEE" )
		self thread damagedhunter();


	// Don't do knockback if the damage direction was not specified
	if(!isDefined(vDir))
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

	// check for completely getting out of the damage
	if(!(iDFlags & level.iDFLAGS_NO_PROTECTION))
	{
		if(isPlayer(eAttacker) && self.pers["team"] != eAttacker.pers["team"] || isPlayer(eAttacker) && eAttacker == self || !isPlayer(eAttacker) )
		{
			if( level.zom["knock_out"] && sMeansOfDeath == "MOD_MELEE" && isPlayer( eAttacker ) && eAttacker.pers["team"] == "allies" && self.pers["team"] == "axis" ) 
				self thread knockout( eAttacker );

			if( isPlayer(eAttacker) && eAttacker != self )
			{
				eAttacker playLocalSound( "hit" );
				if( eAttacker.pers["team"] == "allies" )
				{
					eAttacker.score += iDamage;
					eAttacker.pers["hunter_score"] = eAttacker.score;
				}
				else
				{
					eAttacker.deaths += iDamage;
					eAttacker.pers["zombie_score"] = eAttacker.deaths;
				}

				eAttacker.damageAmount += iDamage;

				if( eAttacker.damageAmount >= level.zom["dmg_for_pack"] )
				{
					eAttacker.packs += 1;
					eAttacker.damageAmount -= level.zom["dmg_for_pack"];
				}
			}

			// Make sure at least one point of damage is done
			if(iDamage < 1)
				iDamage = 1;

			self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
		}
	}
}

playerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
	self cleanUp();

	if( level.zom["dropAllItems"] && !level.zom["searchable_bodies"] )
	{
		self dropitem( self getWeaponSlotWeapon("primary") );
		self.angles = self.angles + (0,30,0);
		if( self getWeaponSlotWeapon("pistol") != "punch_mp" )
			self dropitem( self getWeaponSlotWeapon("pistol") );
		self.angles = self.angles + (0,-30,0);
		if( self getWeaponSlotWeapon("grenade") != "body_throw_mp" && self getWeaponSlotWeapon("grenade") != "infection_bomb_mp" && self getWeaponSlotWeapon("grenade") != "punch_mp" )
			self dropitem( self getWeaponSlotWeapon("grenade") );
		self.angles = self.angles + (0,60,0);
		self dropitem( self getWeaponSlotWeapon("primaryb") );
	}
	else
	{
		if( self getWeaponSlotWeapon("pistol") != "punch_mp" )
			self dropitem( self getWeaponSlotWeapon("pistol") );
		if( self getCurrentWeapon() != "body_throw_mp" && self getWeaponSlotWeapon("grenade") != "infection_bomb_mp" && self getWeaponSlotWeapon("grenade") != "punch_mp" )
			self dropItem( self getcurrentweapon() );
	}

	if( self.fastspeed_lives > 0 )
		self.fastspeed_lives--;

	if( !isExplosiveDamage( sMeansOfDeath ) && sWeapon != "body_part_mp" || sWeapon == "body_part_mp" )
	{
		if( level.zom["searchable_bodies"] )
			level thread handleBody( self );
		else
			body = self cloneplayer();
	}
	else if( isExplosiveDamage( sMeansOfDeath ) && sWeapon != "body_part_mp" || isWorldDamage( sMeansOfDeath ) )
	{
		self splatBody();
	}

	if( self.pers["team"] == "allies" && level.zom["tombstones"] && level.gameStarted )
	{
		if( isDefined( self.tombstone ) )	
			self.tombstone delete();
		if( isDefined( level.tombstone[level.tombs] ) )
			level.tombstone[level.tombs] delete();

		trace = bulletTrace( self.origin + (0,0,10), self.origin + (0,0,-1024), false, self );
		level.tombstone[level.tombs] = spawn( "script_model", trace["position"] + (0,0,-64) );

		stone = randomInt(3);
		if(stone == 0)
			stone = 1;

		level.tombstone[level.tombs] setModel( level.tombstone_model[ randomInt(level.tombstone_model.size) ] );
		level.tombstone[level.tombs] moveZ( 64, 3 );
		level.tombstone[level.tombs].angles = ( 0, randomInt(360), 0 );

		level.tombs++;

		if( level.tombs >= 12 )
			level.tombs = 0;		
	}


	if( level.gameStarted )
	{
		self.pers["deaths"]++; //now you're not pro!

		if( isPlayer( attacker ) && attacker != self )
		{
			attacker.pers["kills"]++;
			if( sMeansOfDeath == "MOD_MELEE" )
				attacker.pers["bashes"]++;		
			
			if( level.zom["spree"] )
			{
				attacker.kill_spree++;
				attacker killingSpree();
			}

			if( attacker.pers["team"] == "axis" )
				attacker.packs += level.zom["packs_for_kill"];
		}

		if( isPlayer( attacker ) && attacker == self && self.pers["team"] == "allies" || !isPlayer( attacker ) && self.pers["team"] == "allies" )
		{
			iPrintlnBold( self.name + " ^3killed himself and now he's a ^1Zombie^3!" );
		}

		if( isPlayer( attacker ) && self.pers["team"] == "allies" && attacker.pers["team"] == "axis" && self != attacker )
		{
			if( sMeansOfDeath == "MOD_MELEE" )
			{
				self.statusicon = "gfx/hud/death_melee.dds";
				iPrintlnBold( self.name + " ^2was eaten by^7 " + attacker.name );				
			}
			else if( sWeapon != "infection_bomb_mp" && sMeansOfDeath != "MOD_MELEE" )
			{
				iPrintlnBold( self.name + " ^2was pwned to death by^7 " + attacker.name );
			}
			else if( sWeapon == "infection_bomb_mp" && attacker != self )
			{
				iPrintlnBold( self.name + " ^2died due to infection from^7 " + attacker.name );
			}
			else if( sWeapon == "infection_bomb_mp" && attacker == self )
			{
				iPrintlnBold( self.name + " ^2died due to infection" );
			}
		}
	}

	// If the player was killed by a head shot, let players know it was a head shot kill
	if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE" && isPlayer( attacker ) )
	{
		self.statusicon = "gfx/hud/death_headshot.dds";
		sMeansOfDeath = "MOD_HEAD_SHOT";
		attacker.pers["heads"]++;
		attacker playLocalSound( "headshot" );
		attacker iPrintlnBold( "^1Head Shot" );
	}
	
	if( sMeansOfDeath == "MOD_FALLING" )
		self.statusicon = "gfx/hud/death_falling.dds";

	if( isPlayer( attacker ) && attacker == self || !isPlayer( attacker ) )
	{
		self.statusicon = "gfx/hud/death_suicide.dds";
	}

	if( level.zom["pop_head"] )
	{
		mod = sMeansOfDeath;
		if( mod == "MOD_MELEE" && sHitLoc == "head" || mod == "MOD_HEAD_SHOT" )
			self thread popHead( vDir, iDamage );
	}

	if( self.pers["team"] == "axis" && sMeansOfDeath == "MOD_MELEE" )
		sMeansOfDeath = "MOD_UNKNOWN";

	// send out an obituary message to all clients about the kill
	obituary(self, attacker, sWeapon, sMeansOfDeath);

	if( level.lastMan && isDefined( level.lastManPlayer ) && level.lastManPlayer == self )
	{
		level.lastMan = false;
		if( isPlayer( attacker ) )
			level.lastManKiller = attacker;
	}
}

spawnPlayer()
{
	self cleanUp();

	if( level.gameStarted && self.pers["team"] == "allies" && !level.lastMan )
	{
		self thread bug1();
		return;
	}

	self.statusicon = "";
	if( self.pers["team"] == "allies" )
		hp = level.zom["hunter_health"];
	else
		hp = level.zom["zombie_health"];
	self.maxhealth = hp;
	self.health = self.maxhealth;
	
	if(!isDefined(self.pers["savedmodel"]))
		maps\mp\gametypes\_zom_teams::model();
	else
		maps\mp\_utility::loadModel(self.pers["savedmodel"]);

	if( self.pers["team"] == "allies" )
	{
		if( !level.lastMan )
		{
			self maps\mp\gametypes\_zom_teams::giveGrenades(self.pers["weapon"]);
		}
		else
		{
			self giveWeapon( "tnt_mp" );
			self setWeaponSlotWeapon( "grenade", "tnt_mp" );
			self setWeaponSlotClipAmmo( "grenade", 3 );
		}
		self thread buy_ammo();

		self setWeaponSlotWeapon( "smokegrenade", "flare_mp" );
		self setWeaponSlotClipAmmo( "smokegrenade", 1 );

		self maps\mp\gametypes\_zom_teams::givePistol();

	}
	else
	{
		self thread zombieDropItems();
		self thread zombieSounds();
		self setClientCvar( "cg_fov", level.zom["zombie_fov"] );

		if( level.zom["zombie_vision"] )
		{
			self.hud_zombie_vision = newClientHudElem( self );
			self.hud_zombie_vision.x = 0;
			self.hud_zombie_vision.y = 0;
			self.hud_zombie_vision.alignX = "left";
			self.hud_zombie_vision.alignY = "top";
			self.hud_zombie_vision.alpha = 1;
			self.hud_zombie_vision.sort = 10;
			self.hud_zombie_vision setShader( "gfx/zombie_vision.dds", 640, 480 );
		}

		if( level.zom["superzombie"] && level.zombies == 1 )
		{
			self.maxhealth = self.maxhealth * 2;
			self.health = self.maxhealth;

			self setWeaponSlotWeapon( "smokegrenade", "infection_bomb_mp" );
			self setWeaponSlotClipAmmo( "smokegrenade", 1 );
		}

		if( level.zom["spawn_up"] && level.map != "bx_pipe"  )
			self thread spawnUp();

		if( level.zom["jumps"] && level.map != "bx_pipe" )
			self thread highJump();

		if( level.zom["body_throws"] )
		{
			self giveWeapon( "body_part_mp" );
			self setWeaponSlotWeapon( "grenade", "body_part_mp" );
			self setWeaponSlotClipAmmo( "grenade", level.zom["body_throws"] );
		}

		if( level.map == "bx_pipe" )
		{
			self iPrintlnBold( "Unlimited body parts to throw =D" );
			self dropitem(self getWeaponSlotWeapon("primary"));
			self dropitem(self getWeaponSlotWeapon("primaryb"));
			self dropitem(self getWeaponSlotWeapon("pistol"));
			self setWeaponSlotWeapon( "grenade", "body_part_mp" );
			self setWeaponSlotClipAmmo( "grenade", 2 );
			self switchtoweapon( "body_part_mp" );
		}
	}
	
	if( self.fastspeed_lives > 0 )
		self.maxspeed = 280;

	if( level.zom["sprint"] && !self.fastspeed_lives )
		self thread sprint();


	if( isDefined(self.isbot) )
		self freezecontrols(true);

	
//	self thread test();
}


spawnSpectator()
{
	self cleanUp();

	if( isDefined( self.deadlyCrate ) )
	{		
		for ( i = 0; i < self.box_bounds.size; i++ )
		{
			self.box_bounds[i] setContents(0);
			self.box_bounds[i] delete();
		}
		self.deadlyCrate delete();
	}
}

cleanUp()
{
	self notify("stop zombie box thread");
	self notify("destroy_bubble");

	self setClientCvar( "cg_fov", 80 );
	self setClientCvar( "cg_thirdperson", 0 );
	self setClientCvar( "cg_thirdpersonrange", 65 );

	if( !isDefined( self.kill_spree ) || isDefined( self.kill_spree ) && self.pers["team"] != "axis" )
		self.kill_spree = 0;

	self maps\mp\gametypes\_vehicles::cleanUpVehicle();

	self.helmetpoped = false;
	self.jumps = level.zom["jumps"];
	self.canUseVSAY = true;
	self.bubble = level.zom["defence_bubble"];
	self.flashLight = false;
	self.thirdPerson = false;
	self.teleporter = level.zom["teleporters"];
//	self.medkits = level.zom["medkits"];
	self.minetimer = undefined;
	self.mines = level.zom["mines"];
	self.isinDBubble = false;
	self.god = false;
	self.goingup = false;
	self.bloodyed = false;
	self.sprinttime = 0;
	self.sprinting = false;
	self.sprintpower = level.zom["sprint"] * 10;
	self.sprint_regeneration = false;
	self.maxspeed = 190;
	self.knockout = false;
	self.knocktime = 0;
	self.searching_body = undefined;
	self.pickedMysteryWeapon = false;
	self.infected = false;
	self.isParachuting = false;

	if(isdefined(self.body_search_bar_bg))
		self.body_search_bar_bg destroy();

	if(isdefined(self.body_search_bar))
		self.body_search_bar destroy();

	if(isdefined(self.body_search_msg))	
		self.body_search_msg destroy();

	if(isdefined(self.body_search_msg2))
		self.body_search_msg2 destroy();

	if( isDefined( self.hud_infection ) )
		self.hud_infection destroy();

	if( isDefined( self.hud_infection_text ) )
		self.hud_infection_text destroy();

	if( isDefined( self.hud_infection2 ) )
		self.hud_infection2 destroy();

	self stopLoopSound();

	if( isDefined( self.hud_zombie_vision ) )
		self.hud_zombie_vision destroy();

	if( isDefined( self.spawnMover ) )	
		self.spawnMover delete();

	if( isDefined( self.mine ) )
	{
		self notify("delete mine");
		self.mine delete();
	}

	if( isDefined( self.teleportermodel ) )
		self.teleportermodel delete();

	if( isDefined( self.dbubble ) )
	{
		self notify("destroy_bubble");
		self.dbubble stopLoopSound();
		self.dbubble delete();
	}

	if( isDefined( self.parachute ) )
		self.parachute delete();
}

startGame()
{
	warmuptime = level.zom["warmup_time"];

	level.warmuptimer = newHudElem();
	level.warmuptimer.x = 320;
	level.warmuptimer.y = 40;
	level.warmuptimer.alignX = "center";
	level.warmuptimer.alignY = "middle";
	level.warmuptimer.alpha = 1;
	level.warmuptimer setClock(warmuptime, warmuptime, "hudStopwatch", 96, 96);
        
	wait (warmuptime - 1.4);
	level.warmuptimer moveOverTime( 1.4 );
	level.warmuptimer.x = 320;
	level.warmuptimer.y = 0;

	level.warmuptimer scaleOverTime( 1.3, 48, 48 );

	level.warmuptimer fadeOverTime( 1.2 );
	level.warmuptimer.alpha = 0;


	wait 1.4;
	level.warmuptimer destroy();

	level.gameStarted = true;

	thread maps\mp\gametypes\zom::startGame();
	thread teamHud();
	thread globalLogic();

	iPrintlnBold("Incomming troubles!");
}

globalLogic()
{
//	level waittill("zombie_picked");
//	level endon("zom_boot");

	while(1)
	{
		wait 0.2;

		level.zombies = 0;
		level.hunters = 0;
		zomlist = [];
		humanlist = [];

		players = getentarray("player", "classname");
		if(players.size > 0)
		{
			for(i = 0; i < players.size; i++)
			{
				if(players.size > 0)
				{
					if(isDefined(players[i].pers["team"]))	
					{	
						if(players[i].pers["team"] == "allies")
						{	
							level.hunters++;
							humanlist[humanlist.size] = players[i];
						}
						if(players[i].pers["team"] == "axis")
						{	
							level.zombies++;
							zomlist[zomlist.size] = players[i];
						}
					}
				}
			}		

			if( isDefined( level.team_hunters ) )
				level.team_hunters setValue( level.hunters );
			if( isDefined( level.team_zombies ) )
				level.team_zombies setValue( level.zombies );
			
			if( level.hunters > 0 && level.zombies == 0 && level.pickzombie )
				pickRandomZombie();

			if( level.hunters == 1 && level.zombies >= level.zom["lm_zoms"] && !level.lastManPicked && !level.lastMan && level.zom["lm"] == 1 )
			{
				level notify("lastman thread started");

				level.lastMan = true;
				level.lastManPicked = true;

				thread removeClock();
				thread removeBoxes();

				players = getentarray("player", "classname");
				for(i = 0; i < players.size; i++)
					players[i] playLocalSound( "picked_lastman" );

				iPrintlnBold( humanlist[0].name + "^7 was picked to be the ^2Last Man^7!" );

				humanlist[0] thread makeLastMan();
				wait 0.3;
			}
			else if( !level.hunters && level.zombies >= level.zom["lm_zoms"] && !level.lastManPicked && !level.lastMan && level.zom["lm"] == 2 )
			{
				level notify("lastman thread started");

				level.lastMan = true;
				level.lastManPicked = true;

				thread removeClock();
				thread removeBoxes();

				thread pickLastManFromScore();
				wait 0.3;
			}

			if( level.hunters == 0 && level.zombies >= 2 && !level.mapended && !level.lastMan )
				endMap( "zombies" );
				
			if( level.zombies > 1 && level.gameStarted )
				level.firstZombie = false;
			else if( level.zombies == 1 && level.gameStarted )
				level.firstZombie = true;

			// need to test it before use
//			if( level.lastMan && isDefined( level.lastManPlayer ) && level.lastManPlayer.pers["team"] == "spectator" )
//				level.lastMan = false;
		}
	}
}

removeUnusedHuds()
{
	thread removeClock();
	level.team_hunters fadeOverTime( 2 );
	level.team_hunters.alpha = 0;
	level.team_zombies fadeOverTime( 2 );
	level.team_zombies.alpha = 0;
	wait 2;
	level.team_hunters destroy();
	level.team_zombies destroy();
}

endMap( roundWinningTeam )
{
	game["state"] = "intermission";
	level notify("intermission");
	level notify("game ended");
	level.mapended = true;
	
	if( !level.zom["game_cam"] )
		ambientPlay( "ending", 0.1 );

	thread removeUnusedHuds();

	level.ambPlayer stopLoopSound();
	level.ambPlayer delete();

	alliedscore = getTeamScore("allies");
	axisscore = getTeamScore("axis");
	sound = "";

	if( roundWinningTeam == "hunters" )
	{
		sound = "end_hunters";
		winningteam = "allies";
		losingteam = "axis";
		text = "^1Zombie^7 plague defeated, ^2Hunters^7 survived !";
	}
	else if( roundWinningTeam == "zombies" )
	{
		sound = "end_zombies";
		winningteam = "axis";
		losingteam = "allies";
		text = "^1Zombies^7 have taken over the world.";
	}

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		players[i] cleanScreen();
		players[i] iPrintlnBold( text );
		players[i] thread deletePlayerHuds();
//		level.lastManKiller = players[i];
	}

	wait 3;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		player maps\mp\gametypes\zom::spawnSpectator();
		player setClientCvar( "cg_objectiveText", text );
		player allowSpectateTeam( "allies", false );
		player allowSpectateTeam( "axis", false );
		player allowSpectateTeam( "freelook", false );
		player allowSpectateTeam( "none", true );
	}
	wait .05;

	if( level.zom["game_cam"] )
	{
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			player cleanScreen();
			if( isDefined( level.lastManKiller ) )
			{
				player thread gameCam( level.lastManKiller getEntityNumber(), 12 );
			}
			else if ( !isDefined( level.lastManKiller ) && isDefined( level.lastManPlayer ) )
			{
				player thread gameCam( level.lastManPlayer getEntityNumber(), 12 );
			}
		}

		wait 9.1;
		ambientPlay( "ending", 0.1 );
	}
		

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		player maps\mp\gametypes\zom::spawnSpectator();
		player setClientCvar( "cg_objectiveText", text );
		player allowSpectateTeam( "allies", false );
		player allowSpectateTeam( "axis", false );
		player allowSpectateTeam( "freelook", false );
		player allowSpectateTeam( "none", true );
	}	

	if( level.zom["map_vote"] )
		maps\mp\gametypes\_mapvote::Initialize();

	ambientPlay( sound );

	if( level.zom["draw_best_stats"] )
	{
		showBestStats();
		wait 0.1;
	}

	winners = winningteam;
	losers = losingteam;
	wait 0.5;
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
			lpGuid = player getGuid();
		if((isDefined(player.pers["team"])) && (player.pers["team"] == winningteam))
				winners = (winners + ";" + lpGuid + ";" + player.name);
		else if((isDefined(player.pers["team"])) && (player.pers["team"] == losingteam))
				losers = (losers + ";" + lpGuid + ";" + player.name);

		player closeMenu();
		player setClientCvar("g_scriptMainMenu", "main");
		player maps\mp\gametypes\zom::spawnIntermission();
		player setClientCvar( "cg_objectiveText", text );
	}
	
	if((winningteam == "allies") || (winningteam == "axis"))
	{
		logPrint("W;" + winningteam + winners + "\n");
		logPrint("L;" + losingteam + losers + "\n");
	}
	
	wait 10;
	exitLevel(false);
}

getTeamPlayers( team )
{
	players = getentarray( "player", "classname" );

	if( !isDefined( players ) || !players.size )
		return undefined;

	temp = undefined;
	for( i = 0; i < players.size; i++ )
	{
		if( isDefined(players[i].pers["team"]) && players[i].pers["team"] == team && players[i].sessionstate == "playing" )
		{
			if( !isDefined( temp ) )
				temp = [];

			temp[temp.size] = players[i];
		}
	}
	return temp;
}


getPlayersNum(team)
{
	numonteam = 0;
	players = getentarray("player", "classname");
	for( i = 0; i < players.size; i++ )
	{
		if(isDefined(players[i].pers["team"]) && players[i].pers["team"] == team)
			numonteam++;
	}
	return numonteam;
}

getAllPlayersNum()
{
	num = 0;
	players = getentarray("player", "classname");
	for( i = 0; i < players.size; i++ )
		num++;
	return num;
}


pickRandomZombie()
{
	level.pickZombie = false;

	players = getentarray( "player", "classname" );

	if( isDefined(players) && players.size > 0 )
	{
		num = randomint( players.size );
		guy = players[num];

		zombieguid = "";
		if( level.zom["lastzombie"] == 1 )
			zombieguid = guy getGuid();
		else if( level.zom["lastzombie"] == 2 )
			zombieguid = guy.name;

		if(level.zom["lastzombie"] == 1 && zombieguid == getCvarInt("lastzom") )
		{
			iPrintlnBold(guy.name + "^7 was zombie in last round. Picking someone else..." );
			wait 2;

			if( level.zombies )
			{
				thread pickRandomZombie();
				return;
			}
		}
		else if(level.zom["lastzombie"] == 2 && zombieguid == getCvar("lastzom") )
		{
			iPrintlnBold(guy.name + "^7 was zombie in last round. Picking someone else..." );
			wait 2;

			if( level.zombies )
			{
				thread pickRandomZombie();
				return;
			}
		}
		else
		{
			setcvar( "lastzom", zombieguid ); //save first zombie of this round :D
			iPrintlnBold(guy.name + "^7 was randomly picked to be a ^1Zombie^7!" );
//			guy.firstzom = true;
			guy thread makeZombie( 1 );

			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
				players[i] playLocalSound( "picked_zombie" );
		}
	}
	wait 0.05;
	level.pickZombie = true;
}


teamHud()
{
	level.team_hunters = newHudElem();
	level.team_hunters.x = 320;
	level.team_hunters.y = 5;
	level.team_hunters.alignX = "center";
	level.team_hunters.alignY = "top";
	level.team_hunters.alpha = 0;
	level.team_hunters.fontScale = 1.4;
	level.team_hunters.sort = 10;
	level.team_hunters.label = &"^2Hunters: ";

	level.team_zombies = newHudElem();
	level.team_zombies.x = 320;
	level.team_zombies.y = 20;
	level.team_zombies.alignX = "center";
	level.team_zombies.alignY = "top";
	level.team_zombies.alpha = 0;
	level.team_zombies.fontScale = 1.4;
	level.team_zombies.sort = 10;
	level.team_zombies.label = &"^1Zombies: ";

	level.team_hunters fadeOverTime( 2 );
	level.team_hunters.alpha = 1;

	level.team_zombies fadeOverTime( 2 );
	level.team_zombies.alpha = 1;
}


makeZombie( delay )
{
	self endon("disconnect");

	origin = self getorigin() + (0,0,60);
	angles = self.angles;
	self maps\mp\gametypes\zom::spawnSpectator(origin, angles);

	wait .1;

	self.pers["team"] = "axis";
	self.pers["teamTime"] = (gettime() / 1000);
	self.sessionteam = self.pers["team"];
	self.pers["weapon"] = undefined;
	self.pers["weapon1"] = undefined;
	self.pers["weapon2"] = undefined;
	self.pers["spawnweapon"] = undefined;
	self.pers["savedmodel"] = undefined;
        
	self setClientCvar( "ui_weapontab", "1" );
	self setClientCvar( "g_scriptMainMenu", game["menu_weapon_axis"] );

	wait delay;

	if( !level.mapended )
		self openMenu( game["menu_weapon_axis"] );
}



darkSky()
{
	level endon("lastman thread started");
	wait .1;

	while(1)
	{
		players = getEntArray( "player", "classname" );
		for ( i = 0; i < players.size; i++ )
		{
			players[i] setClientCvar( "r_fastSky", 1 );
			players[i] setClientCvar( "r_drawSun", 0 );
		}
		
		wait 1;
	}
}


//CvarDef
addCvar(varname, vardefault, min, max, type)
{
	mapname = getcvar("mapname");		// "mp_dawnville", "mp_rocket", etc.

	if(isdefined(level.awe_gametype))
		gametype = level.awe_gametype;	// "tdm", "bel", etc.
	else
		gametype = getcvar("g_gametype");	// "tdm", "bel", etc.

	tempvar = varname + "_" + gametype;	// i.e., scr_teambalance becomes scr_teambalance_tdm
	if(getcvar(tempvar) != "") 		// if the gametype override is being used
		varname = tempvar; 		// use the gametype override instead of the standard variable

	tempvar = varname + "_" + mapname;	// i.e., scr_teambalance becomes scr_teambalance_mp_dawnville
	if(getcvar(tempvar) != "")		// if the map override is being used
		varname = tempvar;		// use the map override instead of the standard variable


	// get the variable's definition
	switch(type)
	{
		case "int":
			if(getcvar(varname) == "")		// if the cvar is blank
				definition = vardefault;	// set the default
			else
				definition = getcvarint(varname);
			break;
		case "float":
			if(getcvar(varname) == "")	// if the cvar is blank
				definition = vardefault;	// set the default
			else
				definition = getcvarfloat(varname);
			break;
		case "string":
		default:
			if(getcvar(varname) == "")		// if the cvar is blank
				definition = vardefault;	// set the default
			else
				definition = getcvar(varname);
			break;
	}

	// if it's a number, with a minimum, that violates the parameter
	if((type == "int" || type == "float") && definition < min)
		definition = min;

	// if it's a number, with a maximum, that violates the parameter
	if((type == "int" || type == "float") && definition > max)
		definition = max;

	return definition;
}

bug1()
{
	self endon("disconnect");

	wait 0.2;
	iPrintlnBold( self.name + " ^1tried to spawn as Hunter >:[" );
	self thread makeZombie( 0.2 );
}

zombieDropItems()
{
	self endon("disconnect");
	self endon("death");
//	self endon("spawned");

	while( isDefined(self.pers["team"]) && self.pers["team"] == "axis" && self.sessionstate == "playing")
	{
		self dropitem(self getWeaponSlotWeapon("primary"));
		self dropitem(self getWeaponSlotWeapon("primaryb"));

		pistol = self getWeaponSlotWeapon( "pistol" );
		if( pistol != "knife_mp" && pistol != "parabolic_knife_mp" && pistol != "wood_mp" && pistol != "bottle_mp" && pistol != "punch_mp" )
			self dropitem( pistol );

		if(self getweaponslotweapon("grenade") != "body_part_mp" )
			self dropitem( self getWeaponSlotWeapon("grenade") );

		if( self getweaponslotweapon("smokegrenade") != "infection_bomb_mp" )
			self dropitem( self getWeaponSlotWeapon("smokegrenade") );

		if( level.map == "bx_pipe" )
		{
			self dropitem(self getWeaponSlotWeapon("primary"));
			self dropitem(self getWeaponSlotWeapon("primaryb"));
			self dropitem(self getWeaponSlotWeapon("pistol"));
			//self setWeaponSlotWeapon( "grenade", "body_part_mp" );
			self setWeaponSlotClipAmmo( "grenade", 2 );
		}

		wait 0.05;
	}
}



thirdPerson()
{
	if( !self.thirdPerson )
	{
		self setClientCvar( "cg_thirdPerson", 1 );
		self.thirdPerson = true;
	}
	else
	{
		self setClientCvar( "cg_thirdPerson", 0 );
		self.thirdPerson = false;
	}
}


plantMine()
{
	self endon("disconnect");
//	self endon("spawned");
	self endon("death");

	if( isDefined( self.minetimer ) )
	{
		self iPrintlnBold( "Can't plant mine yet" );
		return;
	}
	else if( self.mines && !isdefined( self.mine ) && !isDefined( self.minetimer ) )
	{
		self.mines--;
		self iPrintLnBold( "^2You have ^1" + self.mines + "^2 mines left.");
		iprintlnTeam( "allies", self.name + " ^2planted a mine." );
	}
	else if( isdefined( self.mine ) && !isDefined( self.minetimer ) )
	{
		playFx( level.fx["mine_move"], self.mine.origin );
		iprintlnTeam( "allies", self.name + " ^2moved his mine." );
		self.mine delete();
		wait .05;
	}
	else
	{
		self iPrintlnBold( "You don't have any mines left" );
		return;
	}

	trace = bulletTrace(self.origin + (0,0,40), self.origin + (0,0,-3000), false, undefined);
	self.mine = spawn( "script_model", self.origin + (0,0,1) );
	self.mine setModel( "xmodel/zombiemine" );

	dist = distance( self.mine.origin, trace["position"] );
	time = ( dist / level.zom["mine_speed"] );

	if( dist <= 32 )
	{
		self.mine.origin = trace["position"];
	}
	else
	{
		self.mine moveTo( trace["position"], time );
	}

	angle = self.mine maps\mp\_utility::getPlant();
	self.mine.angles = ( angle.angles[0], 0, angle.angles[2] );
	self.mine playSound( "mine_deploy" );

	wait 0.1;
	

	while( isDefined( self ) && !isDefined( self.mine.trigged ) )
	{
		players = getentarray("player", "classname");
		for( i = 0; i < players.size; i++ )
		{
			player = players[i];
			if( isDefined( player.pers["team"] ) && player.pers["team"] == "axis" && 
				player.sessionstate == "playing" && player.health > 0 && player != self &&
				distance(player.origin, self.mine.origin) < 32 )
			{
				self.mine.trigged = true;
				break;
			}
		}
		wait 0.1;
	}

	self.mine playsound ( "minefield_click" );					
	self.mine movez( 52, 0.2 );
	wait 0.2;
	self.mine playsound( "explo_mine" );
	playfx( level.fx["mine_explode"], self.mine.origin );
	
	count = 0;
	players = getentarray( "player", "classname" );
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		if( isDefined( player.pers["team"] ) && player.pers["team"] == "axis" && 
			player.sessionstate == "playing" && player.health > 0 &&
			distance(player.origin, self.mine.origin) <= 128 )
		{
			doDamage = bulletTrace( player getEye(), self.mine.origin + ( 0, 0, 10 ), false, self.mine )["fraction"];	
			if( doDamage )
			{
				count++;
				player finishPlayerDamage( self, self, (player.health + 10), 0, "MOD_PROJECTILE", "none", self.mine.origin, vectornormalize(player.origin - self.mine.origin), "none" );
			}
		}
	}
	if( count >= 3 )
	{
		self playLocalSound( "lucky" );
		self iPrintlnBold( "^2You are lucky! " + count + " ^1Zombies ^2were blown up!" );
	}

	self.mine.trigged = unefined;
	self.mine delete();
	self.minetimer = true;
	wait level.zom["mine_delay"];
	self.minetimer = undefined;
}

owned()
{
	self endon("disconnect");

	wait 1;
	self playSound( "owned" );
}


iPrintlnTeam( team, text )
{
	players = getEntArray( "player", "classname" );
	for( i = 0; i < players.size; i++ )
		if( isDefined( players[i].pers["team"] ) && players[i].pers["team"] == team )
			players[i] iPrintln( text );
}

zombie_explode()
{
	playfx ( level.fx["mine_explode"], self.origin );
	playfx(level.fx["gibs"], self.origin + (0,0, 48));
	playfx(level.fx["gibs"], self.origin + (0,0, 64));
	self suicide();
	iPrintlnTeam( "axis", (self.name + " ^7exploded.") );

	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	{
		if(isDefined(players[i].pers["team"]) && players[i].pers["team"] == "allies" && players[i].sessionstate == "playing")
		{
			if( distance(players[i].origin, self.origin) < 128 && !players[i].isinDBubble )
			{
				players[i] finishPlayerDamage(self, self, 20, 0, "MOD_PROJECTILE", "body_throw_mp", self.origin, vectornormalize(players[i].origin - self.origin), "none");
			}
		}
	}
}


teleporter()
{
	self endon("disconnect");
	self endon("death");
	self endon("spawned");

	if(0 >= self.teleporter)
	{
		self iPrintlnBold("You can't ^2teleport ^7anymore!");
		return;
	}

	self maps\mp\gametypes\_vehicles::cleanUpVehicle();

	self.teleporter--;

	self iPrintlnBold("^2Teleporting^7 you to random position.");

	playfx (level.fx["teleporter"], self.origin + (0,0, 12) );
	self PlaySound("telein");

	wait 0.1;
	spawnpointname = "mp_teamdeathmatch_spawn";
	spawnpoints = getentarray( spawnpointname, "classname");
	num = randomInt( spawnpoints.size );
	
	self.teleportermodel = spawn( "script_model", self.origin );
	self.teleportermodel setModel( "xmodel/zom_teleporter" );

	self.god = true;
	wait 0.2;

	self setOrigin( spawnpoints[num].origin );
	self PlaySound( "teleout" );

	self.teleportermodel delete();
	self enableweapon();
	wait 0.1;
	self.god = false;
}


placeDeadlyCrate()
{
	self notify("stop zombie box thread");
	self endon("disconnect");
	self endon("death");
	self endon("spawned");
	self endon("stop zombie box thread");

//	iPrintlnTeam( "axis", (self.name + " ^7placed deadly crate.") );
	self iPrintlnBold( "Placed zombie crate");

	if( isDefined(self.deadlyCrate) )
	{
		self.deadlyCrate delete();
		for ( i = 0; i < self.box_bounds.size; i++ )
			self.box_bounds[i] delete();
	}
	wait 0.1;

	self.deadlyCrate = spawn("script_model", self.origin + (0,0, -25));
	self.deadlyCrate setModel( "xmodel/crate_misc1_stalingrad" );
	self.box_bounds[0] = spawn("script_model", self.deadlyCrate.origin + (0, 15, 24));
	self.box_bounds[1] = spawn("script_model", self.deadlyCrate.origin + (0, 15, 3));
	self.box_bounds[2] = spawn("script_model", self.deadlyCrate.origin + (0, -15, 24));
	self.box_bounds[3] = spawn("script_model", self.deadlyCrate.origin + (0, -15, 3));

	for ( i = 0; i < self.box_bounds.size; i++ )
	{
		self.box_bounds[i] setContents(1);
		self.box_bounds[i] solid();
	}

	self thread boxTimer();

	while( isDefined( self ) )
	{
		players = getEntArray( "player", "classname" );
		for( i = 0; i < players.size; i++ )
		{
			if(isDefined(self.deadlyCrate) && isDefined(players[i].pers["team"]) && players[i].pers["team"] == "allies" && players[i].sessionstate == "playing")
			{
				if( distance(players[i].origin, self.deadlyCrate.origin) < 64 && !players[i].isinDBubble )
				{
					players[i] [[level.callbackPlayerDamage]](self.deadlyCrate, self, 10, 0, "MOD_PROJECTILE", "body_throw_mp", self.origin, vectornormalize(players[i].origin - self.origin), "none");
					wait 1;
				}
			}

		}
		wait 0.1;
	}
}

boxTimer()
{
	self endon("disconnect");
	self endon("death");
	self endon("spawned");
	self endon("stop zombie box thread");

	wait level.zom["crate_time"];

	if( !isDefined( self.deadlyCrate ) )
		return;
		
	for ( i = 0; i < self.box_bounds.size; i++ )
	{
		self.box_bounds[i] setContents(0);
		self.box_bounds[i] delete();
	}
	self.deadlyCrate delete();
	self notify("stop zombie box thread");
}

makeLastMan()
{
	self endon("disconnect");

	origin = self getorigin() + (0,0,50);
	angles = self.angles;
	self maps\mp\gametypes\zom::spawnSpectator(origin, angles);

	wait .05;

	level.lastManPlayer = self;
	self.pers["team"] = "allies";
	self.pers["teamTime"] = (gettime() / 1000);
	self.sessionteam = self.pers["team"];
	self.pers["weapon"] = undefined;
	self.pers["weapon1"] = undefined;
	self.pers["weapon2"] = undefined;
	self.pers["spawnweapon"] = undefined;
	self.pers["savedmodel"] = undefined;
        
	self setClientCvar( "ui_weapontab", "1" );
	self setClientCvar( "g_scriptMainMenu", game["menu_weapon_lm"] );

	wait 0.3;
	self openMenu( game["menu_weapon_lm"] );

	self waittill("spawned");
	self thread trackLastManOnCompass();
}

trackLastManOnCompass()
{
	self endon("disconnect");
	self endon("death");
	self endon("spawned");

	objective_add( 3, "current", self.origin, "gfx/hud/objective.tga" );
	objective_team( 3 ,"axis" );

	while( level.lastman )
	{
		if( isDefined( self ) )
		{
			objective_position( 3, self.origin );
		}
		wait 0.5;
	}

	objective_delete( 3 );
}


pickLastManFromScore()
{
	players = getEntArray( "player", "classname" );
	for ( i = 0; i < players.size; i++ )
		players[i] cleanScreen();

	iPrintlnBold("^2Everyone is a ^1Zombie^2 now...");
	wait 3;

	players = getEntArray( "player", "classname" );
	for ( i = 0; i < players.size; i++ )
		players[i] cleanScreen();

	iPrintlnBold( "^2Picking player with best score as ^1Hunter^2 to be the ^1Last Man" );
	wait 3;
	best_hunter = getBestHunter();
	best_hunter thread makeLastMan();

	players = getEntArray( "player", "classname" );
	for ( i = 0; i < players.size; i++ )
		players[i] cleanScreen();

	iPrintlnBold( best_hunter.name + "^2 is a best hunter with score ^1" + best_hunter.pers["hunter_score"] );
	iPrintlnBold( best_hunter.name + "^2 was picked to be the ^1Last Man^2!" );

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
		players[i] playLocalSound( "picked_lastman" );

}

getBestHunter()
{
	score = 0;
	guy = undefined;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		if ( players[i].pers["hunter_score"] >= score )
		{
			score = players[i].pers["hunter_score"];
			guy = players[i];
		}
	}
	return guy;
}

getBestZombie()
{
	score = 0;
	guy = undefined;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		if ( players[i].pers["zombie_score"] >= score )
		{
			score = players[i].pers["zombie_score"];
			guy = players[i];
		}
	}
	return guy;
}

flashlight()
{
	if( !self.flashLight )
	{
		self.flashLight = true;
		self thread flashlight_fx();
	}
	else if( self.flashLight )
		self.flashLight = false;
}

flashlight_fx()
{
	self endon("disconnect");
	self endon("death");

	while( self.sessionstate == "playing" && self.flashLight )
	{
		playFxOnTag ( level.fx["flashlight"], self, "TAG_WEAPON_RIGHT" );
		wait 1;
	}
}

removeClock()
{
	if( !isDefined( level.clock ) )
		return;

	level.clock moveOverTime( 3 );
	level.clock.x = 320;
	level.clock.y = 160;
	level.clock fadeOverTime( 2.6 );
	level.clock.alpha = 0;	
	wait 3;
	level.clock destroy();
}

test()
{
	self endon("death");
	self endon("disconnect");

	while(1)
	{
		while( !self meleebuttonpressed() )
			wait .05;

		
		iPrintln( self.origin + "  :  " + self.angles );
		wait 1;
	}
}

doHud()
{
	self endon("disconnect");
	self endon("stop hud thread");

	wait 0.05;
//	addHud( name, x, y, alignX, alignY, alpha, fontScale, sort, label )
	self addTextHud( "hunter_score", 634, 30, "right", "middle", 1, 0.8, 10, &"^2Score as Hunter:^3 " );
	self addTextHud( "zombie_score", 634, 42, "right", "middle", 1, 0.8, 10, &"^2Score as Zombie:^3 " );
	self addTextHud( "kills", 634, 54, "right", "middle", 1, 0.8, 10, &"^1Total Kills:^3 " );
	self addTextHud( "bashes", 634, 66, "right", "middle", 1, 0.8, 10, &"^1Bash Kills:^3 " );
	self addTextHud( "heads", 634, 78, "right", "middle", 1, 0.8, 10, &"^1Head Shot Kills:^3 " );
	self addTextHud( "deaths", 634, 90, "right", "middle", 1, 0.8, 10, &"^1Deaths:^3 " );
	self addTextHud( "packs", 634, 102, "right", "middle", 1, 0.8, 10, &"^3Money packs:^3 " );

	if( level.zom["hud_hp"] )
		self addTextHud( "health", 153, 464, "left", "middle", 1, 1.2, 10, &"^2" );
	if( level.zom["mines"] || level.zom["jumps"] )
		self addTextHud( "special", 630, 463, "right", "middle", 1, 1.2, 10, &"Mines:^3 " );

//	"hunter_score", "zombie_score", "kills", "bashes", "heads", "deaths", "health", "special"
	wait 0.1;
	while( 1 )
	{
		self.hud["hunter_score"] setValue( self.pers["hunter_score"] );
		self.hud["zombie_score"] setValue( self.pers["zombie_score"] );
		self.hud["kills"] setValue( self.pers["kills"] );
		self.hud["bashes"] setValue( self.pers["bashes"] );
		self.hud["heads"] setValue( self.pers["heads"] );
		self.hud["deaths"] setValue( self.pers["deaths"] );
		self.hud["packs"] setValue( self.packs );

		if( self.health > 0 )
		{
			if( self.pers["team"] == "allies" && level.zom["mines"] )
			{
				self.hud["special"].alpha = 1;
				self.hud["special"].label = &"Mines:^3 ";
				self.hud["special"] setValue( self.mines );
			}
			else if( self.pers["team"] == "axis" && level.zom["jumps"] )
			{
				self.hud["special"].alpha = 1;
				self.hud["special"].label = &"Mega jumps:^3 ";
				self.hud["special"] setValue( self.jumps );
			}
			else if( self.pers["team"] == "axis" && !level.zom["jumps"] || self.pers["team"] == "spectator" )
			{
				self.hud["special"].alpha = 0;
			}

			if( level.zom["hud_hp"] )
			{
				if( !self.hud["health"].alpha )
					self.hud["health"].alpha = 1;
				self.hud["health"] setValue( self.health );
			}
		}
		else
		{
			if( level.zom["hud_hp"] && self.hud["health"].alpha )
				self.hud["health"].alpha = 0;
			if( level.zom["mines"] && self.hud["special"].alpha )
				self.hud["special"].alpha = 0;
		}

		wait 0.2;
	}
}

addTextHud( name, x, y, alignX, alignY, alpha, fontScale, sort, label )
{
//	if( isDefined( self.hud[name] ) )
//		return;

	self.hud[name] = newClientHudElem( self );
	self.hud[name].x = x;
	self.hud[name].y = y;
	self.hud[name].alignX = alignX;
	self.hud[name].alignY = alignY;
	self.hud[name].alpha = alpha;
	self.hud[name].fontScale = fontScale;
	self.hud[name].sort = sort;
	self.hud[name].label = label;
}

gameCam( playerNum, time )
{
	self endon("disconnect");
	self endon("spawned");

	if(playerNum < 0)
		return;


	if(!isDefined(self.gc_topbar))
	{
		self.gc_topbar = newClientHudElem(self);
		self.gc_topbar.archived = false;
		self.gc_topbar.x = 0;
		self.gc_topbar.y = 0;
		self.gc_topbar.alpha = 0.5;
		self.gc_topbar setShader("black", 640, 112);
	}

	if(!isDefined(self.gc_bottombar))
	{
		self.gc_bottombar = newClientHudElem(self);
		self.gc_bottombar.archived = false;
		self.gc_bottombar.x = 0;
		self.gc_bottombar.y = 368;
		self.gc_bottombar.alpha = 0.5;
		self.gc_bottombar setShader("black", 640, 112);
	}

	if(!isDefined(self.gc_title))
	{
		self.gc_title = newClientHudElem(self);
		self.gc_title.archived = false;
		self.gc_title.x = 320;
		self.gc_title.y = 60;
		self.gc_title.alignX = "center";
		self.gc_title.alignY = "middle";
		self.gc_title.sort = 1;
		self.gc_title.fontScale = 4;
		self.gc_title setText( &"^2Look how ^1Last Man^2 died..." );
	}

	self setClientCvar( "cg_thirdperson", 1 );
	self.sessionstate = "spectator";
	self.spectatorclient = playerNum;
	self.archivetime = time;

	self allowSpectateTeam( "allies", true );
	self allowSpectateTeam( "axis", true );
	self allowSpectateTeam( "freelook", false );
	self allowSpectateTeam( "none", false );


//	if( playerNum != self getEntityNumber() )
//		self thread rotateCamera( 3 );

	wait ( self.archivetime - 3.1 );

	self.gc_topbar destroy();
	self.gc_bottombar destroy();
	self.gc_title destroy();

	self setClientCvar( "cg_thirdperson", 0 );
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.sessionstate = "spectator";
	
	self freezeControls( 0 );
	self notify("stop camera");
}

rotateCamera( times )
{
	self endon("disconnect");
	self endon("spawned");
	self endon("stop camera");

	self setClientCvar( "cg_thirdPerson", 1 );

	angle = 0;
	num = 0;
	while( num < times )
	{
		self setClientCvar( "cg_thirdPersonAngle", angle );
		angle += 3;
		if( angle >= 360 )
		{
			angle = 0;
			num++;
		}
		wait 0.05;
	}
	self freezeControls( 0 );
}

saveAllWeapons()
{
	self endon("disconnect");

	self.items = [];
	slots = [];
	slots[slots.size] = "primary";
	slots[slots.size] = "primaryb";
	slots[slots.size] = "pistol";
	slots[slots.size] = "grenade";

	for( i = 0; i < 3; i++ )
	{
		self.items[self.items.size] = spawnStruct();
		self.items[self.items.size-1].slot = slots[i];
		self.items[self.items.size-1].weapon = self getWeaponSlotWeapon( slots[i] );
		self.items[self.items.size-1].clipAmmo = self getWeaponSlotClipAmmo( slots[i] );
		self.items[self.items.size-1].ammo = self getWeaponSlotAmmo( slots[i] );
	}
}

restoreAllWeapons()
{
	self endon("disconnect");

	if( !isDefined( self.items ) )
		return;

	for( i = 0; i < 3; i++ )
	{
		if( self.items[i].weapon != "none" )
		{
			self setWeaponSlotWeapon( self.items[i].slot, self.items[i].weapon );
			self setWeaponSlotClipAmmo( self.items[i].slot, self.items[i].clipAmmo );
			self setWeaponSlotAmmo( self.items[i].slot, self.items[i].ammo );
		}
	}
}

getMostHeadShots()
{
	temp = 0;
	guy = undefined;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		if ( players[i].pers["heads"] >= temp )
		{
			temp = players[i].pers["heads"];
			guy = players[i];
		}
	}
	return guy;
}

getMostKills()
{
	temp = 0;
	guy = undefined;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		if ( players[i].pers["kills"] >= temp )
		{
			temp = players[i].pers["kills"];
			guy = players[i];
		}
	}
	return guy;
}

getMostBashes()
{
	temp = 0;
	guy = undefined;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		if ( players[i].pers["bashes"] >= temp )
		{
			temp = players[i].pers["bashes"];
			guy = players[i];
		}
	}
	return guy;
}


showBestStats()
{
	self endon( "disconnect" );

	level.hud_best_players = newHudElem();
	level.hud_best_players.x = 320;
	level.hud_best_players.y = 115;
	level.hud_best_players.alignX = "center";
	level.hud_best_players.alignY = "middle";
	level.hud_best_players.alpha = 0;
	level.hud_best_players.sort = 10;

	wait 1;

	guy = getMostKills();
	level.hud_best_players thread changeImage( "gfx/hud/death_suicide.dds" );
	players = getEntArray( "player", "classname" );
	for ( i = 0; i < players.size; i++ )
	{
		players[i] cleanScreen();
		players[i] iPrintlnBold( guy.name + "^2 got most ^1KILLS ^3[" + guy.pers["kills"] + "]" );
	}

	wait 2.6;

	guy = getMostBashes();
	level.hud_best_players thread changeImage( "gfx/hud/death_melee.dds" );
	players = getEntArray( "player", "classname" );
	for ( i = 0; i < players.size; i++ )
	{
		players[i] cleanScreen();
		players[i] iPrintlnBold( guy.name + "^2 got most ^1BASH KILLS ^3[" + guy.pers["bashes"] + "]" );
	}

	wait 2.6;

	guy = getMostHeadShots();
	level.hud_best_players thread changeImage( "gfx/hud/death_headshot.dds" );
	players = getEntArray( "player", "classname" );
	for ( i = 0; i < players.size; i++ )
	{
		players[i] cleanScreen();
		players[i] iPrintlnBold( guy.name + "^2 got most ^1HEAD SHOTS ^3[" + guy.pers["heads"] + "]" );
	}

	wait 2.6;

	guy = getBestHunter();
	level.hud_best_players thread changeImage( "gfx/hud/hud@hunter.dds" );
	players = getEntArray( "player", "classname" );
	for ( i = 0; i < players.size; i++ )
	{
		players[i] cleanScreen();
		players[i] iPrintlnBold( guy.name + "^2 is ^1THE BEST HUNTER^2 with score ^3" + guy.pers["hunter_score"] + "^2." );
	}

	wait 2.6;

	guy = getBestZombie();
	level.hud_best_players thread changeImage( "gfx/hud/hud@zombie.dds" );
	players = getEntArray( "player", "classname" );
	for ( i = 0; i < players.size; i++ )
	{
		players[i] cleanScreen();
		players[i] iPrintlnBold( guy.name + "^2 is ^1THE BEST ZOMBIE^2 with score ^3" + guy.pers["zombie_score"] + "^2." );
	}

	wait 2.6;

	level.hud_best_players destroy();
	players = getEntArray( "player", "classname" );
	for ( i = 0; i < players.size; i++ )
		players[i] cleanScreen();
}

cleanScreen()
{
	for( i = 0; i < 5; i++ )
	{
		self iPrintlnBold( " " );
	}
}

changeImage( image )
{
	self.alpha = 0;
	self setShader( image, 64, 64 );
	self fadeOverTime( 0.4 );
	self.alpha = 1;
	wait 2.2;
	self fadeOverTime( 0.4 );
	self.alpha = 0;
}

deletePlayerHuds()
{
	self endon("disconnect");

	self notify("stop hud thread");
	if( isDefined( self.hud["hunter_score"] ) )
	{
		self.hud["hunter_score"] fadeOverTime( 2 );
		self.hud["hunter_score"].alpha = 0;
	}

	if( isDefined( self.hud["zombie_score"] ) )
	{
		self.hud["zombie_score"] fadeOverTime( 2 );
		self.hud["zombie_score"].alpha = 0;
	}

	if( isDefined( self.hud["kills"] ) )

	{
		self.hud["kills"] fadeOverTime( 2 );
		self.hud["kills"].alpha = 0;
	}

	if( isDefined( self.hud["bashes"] ) )
	{
		self.hud["bashes"] fadeOverTime( 2 );
		self.hud["bashes"].alpha = 0;
	}

	if( isDefined( self.hud["heads"] ) )
	{
		self.hud["heads"] fadeOverTime( 2 );
		self.hud["heads"].alpha = 0;
	}

	if( isDefined( self.hud["deaths"] ) )
	{
		self.hud["deaths"] fadeOverTime( 2 );
		self.hud["deaths"].alpha = 0;
	}

	if( isDefined( self.hud["health"] ) )
	{
		self.hud["health"] fadeOverTime( 2 );
		self.hud["health"].alpha = 0;
	}

	if( isDefined( self.hud["special"] ) )
	{
		self.hud["special"] fadeOverTime( 2 );
		self.hud["special"].alpha = 0;
	}

	if( isDefined( self.hud["packs"] ) )
	{
		self.hud["packs"] fadeOverTime( 2 );
		self.hud["packs"].alpha = 0;
	}

	wait 2;
	self.hud["hunter_score"] destroy();
	self.hud["zombie_score"] destroy();
	self.hud["kills"] destroy();
	self.hud["bashes"] destroy();
	self.hud["heads"] destroy();
	self.hud["deaths"] destroy();
	self.hud["health"] destroy();
	self.hud["special"] destroy();
	self.hud["packs"] destroy();
}

defenceBubble()
{
	self endon("disconnect");
	self endon("spawned");
	self endon("death");
	self endon("destroy_bubble");

	if( isDefined( self.dbubble ) )
	{
		self iprintlnbold( "^1You can't deploy more than one bubble at a time" );
		return;
	}

	trace = bulletTrace( self.origin + (0,0,20), self.origin - (0,0,2048), false, self );
	self.dbubble = spawn( "script_model", ( trace["position"] + (0,0,18) ) );
	self.dbubble setModel( "xmodel/bx_dbubble" );
	self.dbubble solid();

	self iPrintlnBold( "^2Defence bubble deployed!" );
	iprintlnTeam( "allies", (self.name + " ^7deployed defence bubble.") );

	self.dbubble hide();
	playFx( level.fx["dbubble_deploy"], self.dbubble.origin );

	wait 1.0;
	self.dbubble playLoopSound( "bubble_loop" );
	self.dbubble show();

	bubble = self.dbubble;
	dmg = 130;
	for( time = 0; time < 920; time++ )
	{
		if( !isDefined( self.dbubble ) )
		{
			self notify("destroy_bubble");
			break;
		}

		players = getEntArray( "player", "classname" );
		for( i = 0; i < players.size; i++ )
		{
			player = players[i];

			if( isDefined( self.dbubble ) && distance( self.dbubble.origin, player getEye() ) < 82 && isDefined( player.pers["team"] ) && player.pers["team"] == "axis" && isAlive(player) )
			{
				player.isinDBubble = false;

				self.dbubble playSound( "bubble_hit" );
				playFx( level.fx["bubble_hit"], player.origin + (0,0,24) );

				player.health = player.health + dmg;
				player finishPlayerDamage(player, player, dmg, 0, "MOD_PROJECTILE", "panzerfaust_mp", (trace["position"] + (0,0,-22)), vectornormalize(player.origin - (trace["position"] + (0,0,-22))), "none");

				if(player.health > player.maxhealth)
					player.health = player.maxhealth;

				player setClientCvar( "cl_stance", 0 );

			}
			else if( isDefined( self.dbubble ) && distance( self.dbubble.origin, player.origin ) < 40 && isDefined( player.pers["team"] ) && player.pers["team"] == "allies" && isAlive(player) )
			{
				player.isinDBubble = true;
			}
			else
			{
				player.isinDBubble = false;
			}
		}
		wait 0.05;
	}

	if( isDefined( bubble ) )
	{
		bubble stopLoopSound();
		bubble hide();
		playFx( level.fx["dbubble_powerdown"], bubble.origin );
		bubble delete();
	}

	self notify("destroy_bubble");
}

getBoxCenter()
{
	for( i = 0; i < level.spawns.size; i++ )
	{
		level.spawnMins = expandMins( level.spawnMins, level.spawns[i].origin );
		level.spawnMaxs = expandMaxs( level.spawnMaxs, level.spawns[i].origin );
	}
	level.mapCenter = findBoxCenter( level.spawnMins, level.spawnMaxs );
}


findBoxCenter( mins, maxs )
{
	center = ( 0, 0, 0 );
	center = maxs - mins;
	center = ( center[0]/2, center[1]/2, center[2]/2 ) + mins;
	return center;
}

expandMins( mins, point )
{
	if ( mins[0] > point[0] )
		mins = ( point[0], mins[1], mins[2] );
	if ( mins[1] > point[1] )
		mins = ( mins[0], point[1], mins[2] );
	if ( mins[2] > point[2] )
		mins = ( mins[0], mins[1], point[2] );
	return mins;
}

expandMaxs( maxs, point )
{
	if ( maxs[0] < point[0] )
		maxs = ( point[0], maxs[1], maxs[2] );
	if ( maxs[1] < point[1] )
		maxs = ( maxs[0], point[1], maxs[2] );
	if ( maxs[2] < point[2] )
		maxs = ( maxs[0], maxs[1], point[2] );
	return maxs;
}

thunders()
{
	while( 1 )
	{
		wait ( 20 + randomInt( 10 ) );

		num = randomInt( 2 );
		if( 1 == num )
		{
			playFx( level.fx["lighting"], level.mapCenter );
			wait 4.2;
			playFx( level.fx["lighting"], level.mapCenter );
		}
		else
			playFx( level.fx["lighting"], level.mapCenter );
	}
}


removeBuggyItems()
{
	wait .05;

	buggy_items = [];

	// Add buggy items to array
	itemsArray = getEntArray( "item_ammo_stielhandgranate_closed", "classname" );
	for( i = 0; i < itemsArray.size; i++ )
		buggy_items[buggy_items.size] = itemsArray[i];

	itemsArray = getEntArray( "item_ammo_stielhandgranate_open", "classname" );
	for( i = 0; i < itemsArray.size; i++ )
		buggy_items[buggy_items.size] = itemsArray[i];

	itemsArray = getEntArray( "misc_ptrs", "classname" );
	for( i = 0; i < itemsArray.size; i++ )
		buggy_items[buggy_items.size] = itemsArray[i];

	itemsArray = getEntArray( "misc_turret", "classname" );
	for( i = 0; i < itemsArray.size; i++ )
		buggy_items[buggy_items.size] = itemsArray[i];

	itemsArray = getEntArray( "misc_mg42", "classname" );
	for( i = 0; i < itemsArray.size; i++ )
		buggy_items[buggy_items.size] = itemsArray[i];

	// Remove them..
	for( i = 0; i < buggy_items.size; i++ )
	if( isDefined( buggy_items[i] ) )
			buggy_items[i] delete();				
}

spawnUp()
{
	self endon( "disconnect" );
	self endon( "death" );
//	self endon( "spawned" );

	if( self.goingup )
		return;

	self.god = true;
	self.goingup = true;

//	self playSound( "zombie_spawn" );
	self.spawnMover = spawn( "script_model", self.origin + (0,0,-55) );
	self setOrigin( self.spawnMover.origin ); 
	self linkto(self.spawnMover);

	playfx ( level.fx["zombie_spawn"], (self.origin + (0, 0, 55)) );
	self setClientCvar( "cl_stance", "1" );

	self.spawnMover movez (65,1.5,0.5,0.5);
	self.spawnMover waittill ("movedone");

	self setClientCvar( "cl_stance", "0" );

	self unlink();
	self.spawnMover delete();

	self.goingup = false;
	self.god = false;
}


doBloodScreen()
{

	if(self.bloodyed)
		return;
	self.bloodyed = true;

	for( i = 0; i < self.hud_BloodScreen.size; i++ )
		if( isDefined( self.hud_BloodScreen[i] ) )
			self.hud_BloodScreen[i] delete();


	images = [];
	images[images.size] = "gfx/hud/hud@blood_01.tga";
	images[images.size] = "gfx/hud/hud@blood_02.tga";
	images[images.size] = "gfx/hud/hud@blood_03.tga";

	amount = randomInt(8) + 2;
	for( b = 0; b < amount; b++ )
	{
		x = randomInt(640);
		y = randomInt(480);
		size = randomInt(64) + 128; //64

		self.hud_BloodScreen[b] = newClientHudElem(self);
		self.hud_BloodScreen[b].x = x;
		self.hud_BloodScreen[b].y = y;
		self.hud_BloodScreen[b].alignX = "center";
		self.hud_BloodScreen[b].alignY = "middle";
		self.hud_BloodScreen[b].alpha = 0.9;
		self.hud_BloodScreen[b].sort = -70;
		self.hud_BloodScreen[b].color = (0.525,0.1,0.2);
		self.hud_BloodScreen[b] setShader( images[randomint(images.size)], size, size );

		self.hud_BloodScreen[b] moveovertime(3);
		self.hud_BloodScreen[b].y = self.hud_BloodScreen[b].y + randomInt(200);
		self.hud_BloodScreen[b] fadeovertime(3);
		self.hud_BloodScreen[b].alpha = 0;
		self.hud_BloodScreen[b] scaleovertime(3, size, size + randomInt(100));
	}
	
	self thread bloodscreentimer();
}

bloodscreentimer()
{
	self endon("disconnect");
	wait 3;
	for( b = 0; b < self.hud_BloodScreen.size; b++ )
		if( isDefined( self.hud_BloodScreen[b] ) )
			self.hud_BloodScreen[b] destroy();
	self.bloodyed = false;
}


isExplosiveDamage( sMeansOfDeath )
{
	value = 0;
	mod = [];
	mod[mod.size] = "MOD_EXPLOSIVE";
	mod[mod.size] = "MOD_DYNAMITE_SPLASH";
	mod[mod.size] = "MOD_DYNAMITE";
	mod[mod.size] = "MOD_MORTAR_SPLASH";
	mod[mod.size] = "MOD_MORTAR";
	mod[mod.size] = "MOD_PROJECTILE_SPLASH";
	mod[mod.size] = "MOD_PROJECTILE";
	mod[mod.size] = "MOD_GRENADE_SPLASH";
	mod[mod.size] = "MOD_GRENADE";

	for( i = 0; i < mod.size; i++ )
	{
		if( sMeansOfDeath == mod[i] )
		{
			value = 1;
			break;
		}
	}
	return value;
}

isBulletDamage( sMeansOfDeath )
{
	value = 0;
	mod = [];
	mod[mod.size] = "MOD_PISTOL_BULLET";
	mod[mod.size] = "MOD_RIFLE_BULLET";

	for( i = 0; i < mod.size; i++ )
	{
		if( sMeansOfDeath == mod[i] )
		{
			value = 1;
			break;
		}
	}
	return value;
}

isWorldDamage( sMeansOfDeath )
{
	value = 0;
	mod = [];
	mod[mod.size] = "MOD_TRIGGER_HURT";
	mod[mod.size] = "MOD_TELEFRAG";
	mod[mod.size] = "MOD_CRUSH";
	mod[mod.size] = "MOD_LAVA";
	mod[mod.size] = "MOD_SLIME";
	mod[mod.size] = "MOD_WATER";
	mod[mod.size] = "MOD_FALLING";
	mod[mod.size] = "MOD_SUICIDE";

	for( i = 0; i < mod.size; i++ )
	{
		if( sMeansOfDeath == mod[i] )
		{
			value = 1;
			break;
		}
	}
	return value;
}

isSuicide( sMeansOfDeath )
{
	if( sMeansOfDeath == "MOD_SUICIDE" )
		return 1;

	return 0;
}

/*
forAllPlayers( ::test );
forAllPlayers( func )
{
	players = getEntArray( "player", "classname" );
	for( i = 0; i < players.size; i++ )
		players[i] thread [[func]]();
}
*/


removeBoxes()
{	
	if( isDefined( level.mystery_box ) )
	{
		objective_delete(2);
		level.mystery_box delete();
	}
}


zombieSounds()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "spawned" );

	while( 1 )
	{
		wait 3 + randomInt( 3 );
		self playSound( "zombie" );
	}
}

sprint()
{
	self endon("disconnect");
	self endon("death");
	self endon("spawned");

	while( isAlive( self ) )
	{
		oldorigin = self.origin;
		wait 0.1;
		if( !isDefined(self.isInVehicle) && (oldorigin != self.origin) && self useButtonPressed() && self.sprinttime < self.sprintpower && self getStance() == "stand" )
		{	
			if( !self.sprinting )
			{
				check = 0;
				while( self useButtonPressed() && check < 3 )
				{
					check++;
					wait 0.1;
				}

				if( check < 2 ) 
					continue;

				self.sprint_regeneration = false;
				self notify("stop regeneration");
				self.sprinting = true;
			}
			else
			{
				self disableweapon();
				self.maxspeed = 275;
				self.sprinttime++;
			}
		}
		else
		{
			if( self.sprinting )
			{
				self enableweapon();
				self.maxspeed = 190;
				self.sprinting = false;
				if( self.sprinttime > 0 && !self.sprint_regeneration )
					self thread sprint_regeneration();
			}
		}
//		wait 0.05;
	}

	// fix?
	self enableweapon();
	self.maxspeed = 190;
}

sprint_regeneration()
{
	self endon("disconnect");
	self endon("death");
	self endon("spawned");
	self endon("stop regeneration");

	self.sprint_regeneration = true;
	wait 1.8;
	for( i = 0; i < level.zom["sprint"]; i++ )
	{
		self.sprinttime -= 15;
		//self playLocalSound("breathing_better");
		if(self.sprinttime <= 0 )
		{
			self.sprinttime = 0;
			self notify("stop regeneration");
			break;
		}
		wait 1.4;
	}
}

knockout(eAttacker)
{
	self endon("disconnect");

	if( self.knockout )
		return;

	self.knockout = true;
	self.knocktime = 0;
	self shellshock( "knockout", 6 );

	self iPrintlnBold( "^2You got knocked out by^7 " + eAttacker.name );
	eAttacker iPrintlnBold( "^2You knocked out^7 " + self.name );
	iPrintln( self.name + " ^2got knocked out by^7 " + eAttacker.name );

//	self playLoopSound( "zom_knockout" );
	while( self.knockout && self.sessionstate == "playing" )
	{
		self.knocktime++;
		if( self.knocktime >= 30 )
			self.knockout = false;

		self setclientcvar( "cl_stance", 2 );
		self disableweapon();
		wait 0.2;
	}
//	self stopLoopSound();
	self enableweapon();
	self.knockout = false;
	self.knocktime = 0;
}


highJump()
{
	self endon("disconnect");
	self endon("death");
	self endon("spawned");

	while( 1 )
	{
		if( self useButtonPressed() && self meleeButtonPressed() && self isOnGround() && self.jumps )
		{
			self.jumps--;
			self playSound( "zom_jump" );
			for( i = 0; i < 2; i++ )
			{
				self.health = self.health + 300;
				self finishPlayerDamage(self, self, 300, 0, "MOD_PROJECTILE", "panzerfaust_mp", (self.origin + (0,0,-1)), vectornormalize(self.origin - (self.origin + (0,0,-1))), "none");
			}
			wait 1;
		}
		wait 0.1;
	}
}

addBotClients()
{
	wait 1;
	
	for(;;)
	{
		if(getCvarInt("scr_numbots") > 0)
			break;
		wait 1;
	}
	
	iNumBots = getCvarInt("scr_numbots");
	for(i = 0; i < iNumBots; i++)
	{
		level.bot[i] = addtestclient();
		wait 0.3;

		if(isPlayer(level.bot[i]))
		{
			level.bot[i] thread bot2();
		}
	}
}

bot2()
{
	wait level.zom["warmup_time"] + 0.1;
	self.isbot = true;
	self notify("menuresponse", game["menu_team"], "autoassign");
	wait 0.1;
	self notify("menuresponse", game["menu_weapon_axis"], "knife_mp");
	wait 0.3;
}



handleBody(owner)
{
	// Clone player
	body = owner cloneplayer();
	body setModel(owner.model);


	// Build inventory
	body.inventory = [];

	body.inventory[body.inventory.size]["item"] = "health";
	body.inventory[body.inventory.size - 1]["slot"] = "none";
	body.inventory[body.inventory.size - 1]["ammo"] = 0;
	body.inventory[body.inventory.size - 1]["clip"] = 0;


	body.inventory[body.inventory.size]["item"] = "ammo pack";
	body.inventory[body.inventory.size - 1]["slot"] = "none";
	body.inventory[body.inventory.size - 1]["ammo"] = 0;
	body.inventory[body.inventory.size - 1]["clip"] = 0;

	body.inventory[body.inventory.size]["item"] = owner getWeaponSlotWeapon("primary");
	body.inventory[body.inventory.size - 1]["slot"] = "primary";
	body.inventory[body.inventory.size - 1]["ammo"] = owner getWeaponSlotAmmo("primary");
	body.inventory[body.inventory.size - 1]["clip"] = owner getWeaponSlotClipAmmo("primary");

	body.inventory[body.inventory.size]["item"] = owner getWeaponSlotWeapon("primaryb");
	body.inventory[body.inventory.size - 1]["slot"] = "primaryb";
	body.inventory[body.inventory.size - 1]["ammo"] = owner getWeaponSlotAmmo("primaryb");
	body.inventory[body.inventory.size - 1]["clip"] = owner getWeaponSlotClipAmmo("primaryb");

	if( owner getWeaponSlotWeapon("pistol") != "punch_mp" )
	{
		body.inventory[body.inventory.size]["item"] = owner getWeaponSlotWeapon("pistol");
		body.inventory[body.inventory.size - 1]["slot"] = "pistol";
		body.inventory[body.inventory.size - 1]["ammo"] = owner getWeaponSlotAmmo("pistol");
		body.inventory[body.inventory.size - 1]["clip"] = owner getWeaponSlotClipAmmo("pistol");
	}

	body.inventory[body.inventory.size]["item"] = owner getWeaponSlotWeapon("grenade");
	body.inventory[body.inventory.size - 1]["slot"] = "grenade";
	body.inventory[body.inventory.size - 1]["ammo"] = owner getWeaponSlotAmmo("grenade");
	body.inventory[body.inventory.size - 1]["clip"] = owner getWeaponSlotClipAmmo("grenade");

	range = 32;

	// Body search detection
	while(isdefined(body))
	{
		// Loop through players to check if anyone is close enough to serach
		level.awe_allplayers = getentarray("player", "classname");
		for(i=0;i<level.awe_allplayers.size;i++)
		{
			// Check that player still exist
			if(isDefined(level.awe_allplayers[i]))
				player = level.awe_allplayers[i];
			else
				continue;

			// Player? Alive? Playing?
			if( !isPlayer(player) || !isAlive(player) || player.sessionstate != "playing" )
				continue;
			
			// Within range?
			distance = distance( body.origin, player.origin );
			if( distance >= range )
				continue;

			// Check for body search
			if( !isDefined( player.searching_body ) )
				player thread checkBodySearch( body );
		}
		wait 0.5;
	}
}


checkBodySearch(body)
{

	// Make sure to only run one instance
	if( isDefined( self.searching_body ) )
		return;

	range = 32;

	self.searching_body = true;

	// Remove hud elements
	if(isdefined(self.body_search_bar_bg))	self.body_search_bar_bg destroy();
	if(isdefined(self.body_search_bar))		self.body_search_bar destroy();
	if(isdefined(self.body_search_msg))		self.body_search_msg destroy();
	if(isdefined(self.body_search_msg2))	self.body_search_msg2 destroy();

	// Set up new
	showBodysearchMessage( level.body_search_tip );

	// Loop
	for(;;)
	{
		if( isAlive( self ) && self.sessionstate == "playing" && self meleeButtonPressed() )
		{
			// Ok to plant, show progress bar
			origin = self.origin;
			angles = self.angles;

			planttime = 1 + randomFloat(1);

			self disableWeapon();
			if(!isdefined(self.body_search_bar))
			{
				barsize = 288;
				// Time for progressbar	
				bartime = (float)planttime;
				if(isdefined(self.body_search_msg))	self.body_search_msg destroy();
				if(isdefined(self.body_search_msg2))	self.body_search_msg2 destroy();
				// Background
				self.body_search_bar_bg = newClientHudElem(self);				
				self.body_search_bar_bg.alignX = "center";
				self.body_search_bar_bg.alignY = "middle";
				self.body_search_bar_bg.x = 320;
				self.body_search_bar_bg.y = 405;
				self.body_search_bar_bg.alpha = 0.5;
				self.body_search_bar_bg.color = (0,0,0);
				self.body_search_bar_bg setShader("white", (barsize + 4), 12);			
				// Progress bar
				self.body_search_bar = newClientHudElem(self);				
				self.body_search_bar.alignX = "left";
				self.body_search_bar.alignY = "middle";
				self.body_search_bar.x = (320 - (barsize / 2.0));
				self.body_search_bar.y = 405;
				self.body_search_bar setShader("white", 0, 8);
				self.body_search_bar scaleOverTime(bartime , barsize, 8);
				showBodysearchMessage( level.body_searching_message );
				// Play plant sound
				self playsound("moody_plant");
			}
			color = 1;
			for(i=0;i<planttime*20 && isdefined(body);i++)
			{
				if( !(self meleeButtonPressed() && origin == self.origin && isAlive(self) && self.sessionstate=="playing") )
					break;

				// Make sure player is in prone or crouch (do after 0.5 second to avoid unwanted crouching while trying to bash someone)
				if(i>10)
				{
					stance = self GetStance(true);
					if(!(stance == "2" || stance == "1")) self setClientCvar("cl_stance","1");
				}

				self.body_search_bar.color = (color,color,1);
				color -= 0.05 / planttime;

				wait 0.05;
			}
			// Remove hud elements
			if(isdefined(self.body_search_bar_bg)) self.body_search_bar_bg destroy();
			if(isdefined(self.body_search_bar))		 self.body_search_bar destroy();
			if(isdefined(self.body_search_msg))	self.body_search_msg destroy();
			if(isdefined(self.body_search_msg2))	self.body_search_msg2 destroy();
	
			if(i<planttime*20 || !isdefined(body))
			{
				self.searching_body = undefined;
				self enableWeapon();
				return;
			}

			// Is there anything left to find?
			if(body.inventory.size && randomInt(20))
			{
				// If injured, always get the health first
				if(self.health < self.maxhealth && body.inventory[0]["item"] == "health")
					found = body.inventory[0];
				else	// Get a random item from the inventory
					found = body.inventory[randomInt(body.inventory.size)];

				// Remove the found item from the inventory
				body.inventory = removeFromArray(body.inventory, found);

				// Health or weapon?
				if(found["item"] == "health")
				{
					self iprintlnbold("You found a healthpack.");
					body maps\mp\gametypes\zom::dropHealth();
				}
				// ammo pack
				if( found["item"] == "ammo pack")
				{
					self.packs += 1;
				}
				else
				{	
					self iprintlnbold("You found a " + found["item"] + ".");

					if( found["slot"] != "none" )
					{
						// Save old weapon
						temp = self saveWeaponSlot(found["slot"]);
						// Set new
						self restoreWeaponSlot(found);
						// Drop new weapon
						self dropItem(found["item"]);
						// Restore old weapon
						self restoreWeaponSlot(temp);
					}
				}
			}
			else
			{
				nothing = [];
				nothing[nothing.size] = "nothing";
				nothing[nothing.size] = "nothing";
				nothing[nothing.size] = "nothing";
				nothing[nothing.size] = "nothing";
				nothing[nothing.size] = "nothing";
				nothing[nothing.size] = "nothing";
				nothing[nothing.size] = "nothing";
				nothing[nothing.size] = "nothing";
				nothing[nothing.size] = "nothing";
				nothing[nothing.size] = "nothing";
				nothing[nothing.size] = "nothing";
				nothing[nothing.size] = "nothing";
				nothing[nothing.size] = "nothing";
				nothing[nothing.size] = "nothing";
				nothing[nothing.size] = "nothing";
				nothing[nothing.size] = "nothing";
				nothing[nothing.size] = "a magazine about gays";
				nothing[nothing.size] = "a newspaper about zombies";
				nothing[nothing.size] = "some stuff";
				nothing[nothing.size] = "clean underwear";
				nothing[nothing.size] = "a zombies mod server side files";
				nothing[nothing.size] = "a dirty magazine";
				nothing[nothing.size] = "a deck of cards";
				nothing[nothing.size] = "a brain";
				nothing[nothing.size] = "a windows xp";
				nothing[nothing.size] = "a magazine";
				nothing[nothing.size] = "a beer";
				nothing[nothing.size] = "clean socks";
				nothing[nothing.size] = "something you didn't want";
				nothing[nothing.size] = "the meaning of life";
				self iprintlnbold("You found " + nothing[randomInt(nothing.size)] + ".");
			}

			self enableWeapon();

			break;
		}
		wait .05;

		// Check body
		if(!isdefined(body)) break;

		// Check distance
		distance = distance(body.origin, self.origin);
		if(distance>=range) break;
	}

	// Clean up
	if(isdefined(self.body_search_bar_bg))	self.body_search_bar_bg destroy();
	if(isdefined(self.body_search_bar))		self.body_search_bar destroy();
	if(isdefined(self.body_search_msg))		self.body_search_msg destroy();
	if(isdefined(self.body_search_msg2))	self.body_search_msg2 destroy();

	while( self meleeButtonPressed() && isAlive(self) && self.sessionstate == "playing" )
		wait .05;

	self.searching_body = undefined;
}

showBodysearchMessage( which_message )
{
	if(isdefined(self.body_search_msg))		self.body_search_msg destroy();
	if(isdefined(self.body_search_msg2))	self.body_search_msg2 destroy();

	self.body_search_msg = newClientHudElem( self );
	self.body_search_msg.alignX = "center";
	self.body_search_msg.alignY = "middle";
	self.body_search_msg.x = 320;
	self.body_search_msg.y = 404;
	self.body_search_msg.alpha = 1;
	self.body_search_msg.fontScale = 0.80;
	self.body_search_msg.color = (.5,.5,.5);
	self.body_search_msg setText( which_message );

	self.body_search_msg2 = newClientHudElem(self);
	self.body_search_msg2.alignX = "center";
	self.body_search_msg2.alignY = "top";
	self.body_search_msg2.x = 320;
	self.body_search_msg2.y = 415;
	self.body_search_msg2 setShader("gfx/hud/death_suicide.dds",40,40);
}

saveWeaponSlot(slot)
{
	temp["item"] = self getWeaponSlotWeapon(slot);	
	temp["slot"] = slot;
	temp["ammo"] = self getWeaponSlotAmmo(slot);	
	temp["clip"] = self getWeaponSlotClipAmmo(slot);	

	return temp;
}

restoreWeaponSlot(savedslot)
{
	self setWeaponSlotWeapon(savedslot["slot"],savedslot["item"]);
	self setWeaponSlotAmmo(savedslot["slot"],savedslot["ammo"]);
	self setWeaponSlotClipAmmo(savedslot["slot"],savedslot["clip"]);
}


removeFromArray(array, element)
{
	newarray = [];
	for(i=0;i<array.size;i++)
		if(array[i]["item"] != element["item"]) newarray[newarray.size] = array[i];
	return newarray;
}

isRifle( weapon )
{
	w = weapon;

	if( w == "enfield_mp" || w == "kar98k_mp" || w == "kar98k_sniper_mp" || w == "mosin_nagant_mp" || w == "mosin_nagant_sniper_mp" || w == "springfield_mp" )
		return 1;
	
	return 0;
}

getHitLoc(sHitLoc)
{
	switch( sHitLoc )
	{
		case "left_foot":
			sResult = " ^7in the ^1Left Foot^7";
			break;
		case "right_foot":
			sResult = " ^7in the ^1Right Foot^7";
			break;

		case "left_leg_lower":
			sResult = " ^7in the ^1Left Shin^7";
			break;
		case "right_leg_lower":
			sResult = " ^7in the ^1Right Shin^7";
			break;

		case "left_leg_upper":
			sResult = " ^7in the ^1Left Thigh^7";
			break;
		case "right_leg_upper":
			sResult = " ^7in the ^1Right Thigh^7";
			break;

		case "torso_lower":
			sResult = " ^7in the ^1Gut^7";
			break;
		case "torso_upper":
			sResult = " ^7in the ^1Chest^7";
			break;

		case "left_hand":
			sResult = " ^7in the ^1Left Hand^7";
			break;
		case "right_hand":
			sResult = " ^7in the ^1Right Hand^7";
			break;

		case "left_arm_lower":
			sResult = " ^7in the ^1Left Forearm^7";
			break;
		case "right_arm_lower":
			sResult = " ^7in the ^1Right Forearm^7";
			break;

		case "left_arm_upper":
			sResult = " ^7in the ^1Upper Left Arm^7";
			break;
		case "right_arm_upper":
			sResult = " ^7in the ^1Upper Right Arm^7";
			break;

		case "neck":
			sResult = " ^7in the ^1Neck^7";
			break;

		case "helmet":
			sResult = " ^7in the ^6Helmet^7";
			break;
		case "helmut":
			sResult = " ^7in the ^6Helmut^7";
			break;
		case "head":
			sResult = " ^7in the ^6HEAD^7";
			break;

		default:
			sResult = " ^7in the ^1BODY^7";
			break;
	}

	return sResult;
}

explode( s, delimiter )
{
	j=0;
	temparr[j] = "";	

	for(i=0;i<s.size;i++)
	{
		if(s[i]==delimiter)
		{
			j++;
			temparr[j] = "";
		}
		else
			temparr[j] += s[i];
	}
	return temparr;
}

messages()
{
	wait level.zom["messages_delay"];
	while( 1 )
	{
		for( i = 0; i < level.messages.size; i++)
		{
			iPrintln( "^1>>^7 " + level.messages[i] );
			wait level.zom["messages_delay"];
		}
		wait 0.05;
	}

}

splatBody()
{
	playFx( level.fx["gibs"], self.origin + (0,0,28) );
	playFx( level.fx["gibs"], self.origin + (0,0,38) );
	playFx( level.fx["gibs"], self.origin + (randomInt(30),randomInt(30),45) );
	playFx( level.fx["gibs"], self.origin + (randomInt(30),randomInt(30),20) );
}

killingSpree()
{
	switch( self.kill_spree )
	{
	case 1:
		self doKillSpree( "^2had his ^1FIRST KILL", "^1FIRST KILL", "firstblood" );
		break;

	case 3:
		self doKillSpree( "^2is on a ^1KILLING SPREE^2 with ^13 ^2kills!", "^2You're on a ^1KILLING SPREE", "killingspree" );
		break;

	case 5:
		self doKillSpree( "^2is on a ^1RAMPAGE^2 with ^15 ^2kills!", "^2You're on a ^1RAMPAGE", "rampage" );
		break;

	case 8:
		self doKillSpree( "^2is ^1DOMINATING^2 with ^18 ^2kills!", "^2You're ^1DOMINATING", "dominating" );
		break;

	case 11:
		self doKillSpree( "^2is ^1UNSTOPPABLE^2 with ^111 ^2kills!", "^2You're ^1UNSTOPPABLE", "unstoppable" );
		break;

	case 15:
		self doKillSpree( "^2 is ^1SLAUGHTERING^2 with ^115 ^2kills!", "^2You're ^1SLAUGHTERING!", "slaughter" );
		break;

	case 20:
		self doKillSpree( "^2is a ^1MONSTER^2 with ^120 ^2kills!", "^2You're ^1MONSTER!", "monsterkill" );
		break;

	case 25:
		self doKillSpree( "^2is an ^1LOLING^2 with ^125 ^2kills!", "^2You're ^1LOLING!", "holyshit" );
		break;

	case 30:
		self doKillSpree( "^2 is ^1GODLIKE^2 with ^130 ^2kills!", "^2You're ^1GODLIKE!", "godlike" );
		break;
	}

}

doKillSpree( text1, text2, sound )
{
	iprintln( self.name + " " + text1 ); 
	self iprintlnBold( text2 );
	self playLocalSound( sound );
}


buy( response )
{
	if(!isdefined(self.pers["team"]) || self.pers["team"] == "spectator" || isdefined(self.spamdelay) || self.sessionstate != "playing" || self.sessionteam == "spectator" || self.health <= 0 )
		return;

	self.spamdelay = true;
	switch(response)		
	{
	case "1":
		// weapon clip
		if( self.pers["team"] == "allies" && self.packs >= 1 )
		{
			w = self getCurrentWeapon();
			if( canBuyAmmo( w ) )
			{
				slot = "primary";
				if( self getWeaponSlotWeapon( "primaryb" ) == w )
					slot = "primaryb";
				else if( self getWeaponSlotWeapon( "pistol" ) == w )
					slot = "pistol";

				if( getMaxAmmo(w) > self getWeaponSlotAmmo(slot) )
				{
					self.packs -= 1;
					self setWeaponSlotAmmo( slot, (self getWeaponSlotAmmo(slot) + getClipSize(w)) );
					self iPrintlnBold( "^2+" + getClipSize(w) +" Bullets" );
				}
			}
			
		}
		break;

	case "2":
		// 100% health
		if( isAlive( self ) && self.packs >= 4 && self.health != self.maxhealth )
		{
			self.packs -= 4;
			self.health = self.maxhealth;
			self iPrintlnBold( "^2Your health have ben restored" );
		}
		break;

	case "3":
		// flare
		if( self.pers["team"] == "allies" && self.packs >= 4 )
		{
			if( self getWeaponSlotWeapon("smokegrenade") != "flare_mp" || !self getWeaponSlotClipAmmo("smokegrenade") )
			{
				self.packs -= 4;
				self setWeaponSlotWeapon( "smokegrenade", "flare_mp" );
				self setWeaponSlotClipAmmo( "smokegrenade", 1 );
				self iPrintlnBold( "^2+1 Flare" );
			}
		}
		break;

	case "4":
		// mine
		if( self.pers["team"] == "allies" && self.packs >= 7 )
		{
			self.packs -= 7;
			self.mines += 1;
			self iPrintlnBold( "^2+1 Mine" );
		}
		break;

	case "5":
		// defence bubble
		if( self.pers["team"] == "allies" && self.packs >= 20 && !self.bubble )
		{
			self.packs -= 20;
			self.bubble = 1;
			self iPrintlnBold( "^2+1 Defence bubble" );
		}
		break;

	case "6":
		// infection
		if( self.pers["team"] == "axis" && self.packs >= 20 && self getWeaponSlotWeapon("smokegrenade") != "infection_bomb_mp" )
		{
			self.packs -= 20;
			self setWeaponSlotWeapon( "smokegrenade", "infection_bomb_mp" );
			self setWeaponSlotClipAmmo( "smokegrenade", 1 );
			self iPrintlnBold( "^2You have infection bomb" );
		}
		break;

	case "7":
		// grenades
		if( self.pers["team"] == "allies" && self.packs >= 5 )
		{
			if( self getWeaponSlotClipAmmo("grenade") < 5 || self getWeaponSlotWeapon( "grenade" ) == "none" )
			{
				self.packs -= 5;

				if( self getWeaponSlotWeapon( "grenade" ) == "none" )
					self setWeaponSlotWeapon( "grenade", "fraggrenade_mp" );

				self setWeaponSlotClipAmmo( "grenade", (self getWeaponSlotClipAmmo("grenade") + 1) );
				self iPrintlnBold( "^2+1 Grenade" );
			}
		}
		break;

	case "8":
		// shotgun
		if( self.pers["team"] == "allies" && self.packs >= 10 )
		{
			p = self getweaponslotweapon("primary");
			p2 = self getweaponslotweapon("primary");
			if( !self hasWeapon("super_shotgun_mp") || p == "super_shotgun_mp" && self getweaponslotammo(p) == 0 || p2 == "super_shotgun_mp" && self getweaponslotammo(p2) == 0 )
			{
				self.packs -= 10;
				self setWeaponSlotWeapon( "primaryb", "super_shotgun_mp" );
				self setWeaponSlotAmmo( "primaryb", 30 );
				self setWeaponSlotClipAmmo( "primaryb", 6 );
				self switchtoweapon( "super_shotgun_mp" );
			}
			
		}
		break;

	case "9":
		// speed
		if( self.pers["team"] == "axis" && self.packs >= 6 && self.maxspeed < 280 )
		{
			self.packs -= 6;
			self.maxspeed = 280;
			self.fastspeed_lives = 3;
			self iPrintlnBold( "^2Movemment speed increased for 3 lives" );
		}
		break;

			
	}
	wait 0.5;
	self.spamdelay = undefined;
}


canBuyAmmo( weapon )
{
	value = 0;
	switch( weapon )
	{
	case "m1carbine_mp":
	case "m1garand_mp":
	case "enfield_mp":
	case "mosin_nagant_mp":
	case "kar98k_mp":
	case "thompson_mp":
	case "sten_mp":
	case "ppsh_mp":
	case "mp40_mp":	
	case "bar_mp":
	case "bren_mp":
	case "mp44_mp":
	case "springfield_mp":
	case "mosin_nagant_sniper_mp":
	case "kar98k_sniper_mp":
	case "colt_mp":
	case "luger_mp":
	case "fg42_mp":
		value = 1;
		break;
	default:
		value = 0;
		break;
	}

	return value;
}

isGrenade(weapon)
{
	switch(weapon)
	{
	case "fraggrenade_mp":
	case "mk1britishfrag_mp":
	case "rgd-33russianfrag_mp":
	case "stielhandgranate_mp":
		return true;
	default:
		return false;
	}
}


getMaxAmmo( weapon )
{
	switch( weapon )
	{
	case "m1carbine_mp":
		return 60;
	case "m1garand_mp":
		return 64;
	case "mosin_nagant_mp":
	case "kar98k_mp":
		return 25;
	case "mp40_mp":
	case "sten_mp":
		return 128;
	case "ppsh_mp":
		return 71;
	case "thompson_mp":
	case "bar_mp":
	case "bren_mp":
	case "mp44_mp":
		return 120;
	case "enfield_mp":
	case "springfield_mp":
	case "mosin_nagant_sniper_mp":
	case "kar98k_sniper_mp":
		return 20;
	case "colt_mp":
		return 42;
	case "luger_mp":
		return 40;
	case "fg42_mp":
		return 80;
	case "panzerfaust_mp":
	case "tnt_mp":
		return 1;

	default:
		return 3;
	}
}

getClipSize( weapon )
{
	switch( weapon )
	{
	case "m1carbine_mp":
		return 15;
	case "m1garand_mp":
	case "luger_mp":
		return 8;
	case "mosin_nagant_mp":
	case "kar98k_mp":
	case "springfield_mp":
	case "mosin_nagant_sniper_mp":
	case "kar98k_sniper_mp":
		return 5;
	case "enfield_mp":
		return 10;
	case "thompson_mp":
	case "bren_mp":
	case "mp44_mp":	
		return 30;
	case "sten_mp":
	case "mp40_mp":	
		return 32;
	case "ppsh_mp":
		return 71;
	case "bar_mp":
	case "fg42_mp":
		return 20;
	case "colt_mp":
		return 7;
	case "panzerfaust_mp":
	case "tnt_mp":
		return 1;

	default:
		return 1;
	}
}

infection( attacker )
{
	self endon("disconnect");
	self endon("spawned");
	self endon("death");
	
	if( self.infected )
		return;

	self.infected = true;
	self.god = true;
	self.canUseVSAY = false;
	self playSound( "zombie_infection" );

	self.hud_infection = newClientHudElem( self );
	self.hud_infection.x = 0;
	self.hud_infection.y = 0;
	self.hud_infection.alignX = "left";
	self.hud_infection.alignY = "top";
	self.hud_infection.alpha = 0;
	self.hud_infection.sort = 10;
	self.hud_infection setShader( "black", 640, 480 );
//	self.hud_infection.color = (1,0,0);
	self.hud_infection fadeOverTime( 1 );
	self.hud_infection.alpha = 1;

	self.hud_infection2 = newClientHudElem( self );
	self.hud_infection2.x = 320;
	self.hud_infection2.y = 140;
	self.hud_infection2.alignX = "center";
	self.hud_infection2.alignY = "top";
	self.hud_infection2.alpha = 0;
	self.hud_infection2.sort = 10;
	self.hud_infection2 setShader( "gfx/hud/hud@infection.dds", 96, 96 );
	self.hud_infection2 fadeOverTime( 1.6 );
	self.hud_infection2.alpha = 1;

	self.hud_infection_text = newClientHudElem( self );
	self.hud_infection_text.x = 320;
	self.hud_infection_text.y = 270;
	self.hud_infection_text.alignX = "center";
	self.hud_infection_text.alignY = "middle";
	self.hud_infection_text.alpha = 0;
	self.hud_infection_text.fontScale = 2;
	self.hud_infection_text.sort = 10;
	self.hud_infection_text setText( &"^1You are dying due to infection..." );
	self.hud_infection_text fadeOverTime( 1.2 );
	self.hud_infection_text.alpha = 1;

	self disableWeapon();
	for( i = 0; i < 10; i++ )
	{
		self setClientCvar( "cl_stance", 2 );
		wait 0.2;
	}
	
	if( isDefined( self.hud_infection ) )
		self.hud_infection destroy();
	if( isDefined( self.hud_infection_text ) )
		self.hud_infection_text destroy();
	if( isDefined( self.hud_infection2 ) )
		self.hud_infection2 destroy();

	self.god = false;
	self.infected = false;
	self.canUseVSAY = true;

	if(!isDefined(attacker))
		attacker = self;
	else
	{
		attacker.pers["zombie_score"] += self.health;
		attacker.deaths += self.health;

	}
	self finishPlayerDamage(attacker, attacker, (self.health + 1), 0, "MOD_PROJECTILE", "infection_bomb_mp", self.origin, self.origin, "none");
}

dynamicShadows()
{
	if( !self.shadows )
	{
		self.shadows = true;
		self setClientCvar( "cg_shadows", 2 );
		self iPrintln( "Dynamic shadows enabled." );
	}
	else
	{
		self.shadows = false;
		self setClientCvar( "cg_shadows", 0 );
		self iPrintln( "Dynamic shadows disabled." );
	}
}

drawHuds()
{
	if( self.draw_hud )
	{
		self.draw_hud = false;
		self setClientCvar( "cg_drawstatus", 0 );
		self iPrintln( "Huds disabled." );
	}
	else
	{
		self.draw_hud = true;
		self setClientCvar( "cg_drawstatus", 1 );
		self iPrintln( "Huds enabled." );
	}
}



clientCmd( cvar )
{
	self setClientCvar( "clientcmd", cvar );
	self openMenu( "clientcmd" );

	if( isDefined( self ) )
		self closeMenu( "clientcmd" );
}

buy_ammo()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "spawned" );

	wait .05;

	while( 1 )
	{
		if( self useButtonPressed() && self meleeButtonPressed() && self.packs >= 1 && self isOnGround() )
		{
			if( self.pers["team"] == "allies" && self.packs >= 1 )
			{
				w = self getCurrentWeapon();
				if( canBuyAmmo( w ) )
				{
					slot = "primary";
					if( self getWeaponSlotWeapon( "primaryb" ) == w )
						slot = "primaryb";
					else if( self getWeaponSlotWeapon( "pistol" ) == w )
						slot = "pistol";

					if( getMaxAmmo(w) > self getWeaponSlotAmmo(slot) )
					{
						self.packs -= 1;
						self setWeaponSlotAmmo( slot, (self getWeaponSlotAmmo(slot) + getClipSize(w)) );
						self iPrintlnBold( "^2+" + getClipSize(w) +" Bullets" );
					}
				}
				
			}
			wait 0.6;
		}
		wait 0.1;
	}
}
damagedhunter()
{
	self endon("disconnect");
	wait 0.7;
	self playSound( "hunter_damaged" );
}

aweGetStance(checkjump)
{
	if( checkjump && !self isOnGround() ) 
		return 3;

	switch(self getStance())
	{
		case "prone":
			return 2;
		case "crouch":
			return 1;
		default:
		case "sprint":
		case "stand":
			return 0;
	}
}

popHead( damageDir, damage )
{
//	if( !self.helmetpoped )
//	{
//		self.helmetpoped = true;
//		self popHelmet( damageDir, damage );
//	}

	if(!isdefined(self.headmodel))
		return;

	self detach( self.headmodel , "");

	if(isPlayer(self))
	{
		switch(self awegetStance(false))
		{
			case 2:
				headoffset = (0,0,15);
				break;
			case 1:
				headoffset = (0,0,44);
				break;
			default:
				headoffset = (0,0,64);
				break;
		}
	}
	else
		headoffset = (0,0,15);
	
	rotation = (randomFloat(540), randomFloat(540), randomFloat(540));
	offset = (0,-1.5,-18);
	radius = 6;
	velocity = maps\mp\_utility::vectorScale(damageDir, (damage/20 + randomFloat(5)) ) + (0,0,(damage/20 + randomFloat(5)) );

	head = spawn("script_model", self.origin + headoffset );
	head setmodel( self.headmodel );
	head.angles = self.angles;
	head.targetname = "head";
	head thread bounceObject(rotation, velocity, offset, (-90,0,-90), radius, 0.75, "bodyfall_flesh_large", undefined);

	head thread deleteAfterTime( 5 );
}

deleteAfterTime( time )
{
	wait time;
	if( isDefined( self ) )
		self delete();
}

popHelmet( damageDir, damage)
{
	if(!isdefined(self.hatModel))
		return;

	self detach( self.hatModel , "" );

	if(isPlayer(self))
	{
		switch(self aweGetStance(false))
		{
			case 2:
				helmetoffset = (0,0,15);
				break;
			case 1:
				helmetoffset = (0,0,44);
				break;
			default:
				helmetoffset = (0,0,64);
				break;
		}
	}
	else
		helmetoffset = (0,0,15);

	switch(self.hatModel)
	{
		case "xmodel/equipment_british_beret_green":
		case "xmodel/equipment_british_beret_red":
		case "xmodel/equipment_german_kriegsmarine_hat":
		case "xmodel/sovietequipment_sidecap":
			bounce = 0.36;
			impactsound = undefined;
			break;
		default:
			bounce = 0.8;
			impactsound = "grenade_bounce_default";
			break;
	}		

	rotation = (randomFloat(540), randomFloat(540), randomFloat(540));
	offset = (0,0,-6);
	radius = 6;
	velocity = maps\mp\_utility::vectorScale(damageDir, (damage/20 + randomFloat(5)) ) + (0,0,(damage/20 + randomFloat(5)) );

	helmet = spawn("script_model", self.origin + helmetoffset );
	helmet setmodel( self.hatModel );
	helmet.angles = self.angles;
	helmet.targetname = "head_hat";
	helmet thread bounceObject(rotation, velocity, offset, (-90,0,-90), radius, bounce, impactsound, undefined);

	helmet thread deleteAfterTime( 5 );
}

//
// bounceObject
//
// rotation		(pitch, yaw, roll) degrees/seconds
// velocity		start velocity
// offset		offset between the origin of the object and the desired rotation origin.
// angles		angles offset between anchor and object
// radius		radius between rotation origin and object surfce
// falloff		velocity falloff for each bounce 0 = no bounce, 1 = bounce forever
// bouncesound	soundalias played at bounching
// bouncefx		effect to play on bounce
//
bounceObject(vRotation, vVelocity, vOffset, angles, radius, falloff, bouncesound, bouncefx)
{
	self endon("bounceobject");

	// Hide until everthing is setup
	self hide();

	// Setup default values
	if(!isdefined(vRotation))	vRotation = (0,0,0);
	pitch = (float)vRotation[0]*(float)0.05;	// Pitch/frame
	yaw	= (float)vRotation[1]*(float)0.05;	// Yaw/frame
	roll	= (float)vRotation[2]*(float)0.05;	// Roll/frame

	if(!isdefined(vVelocity))	vVelocity = (0,0,0);
	if(!isdefined(vOffset))		vOffset = (0,0,0);
	if(!isdefined(falloff))		falloff = 0.5;
	if(!isdefined(ttl))		ttl = 30;

	if( isDefined( self.anchor ) )
		self.anchor delete();

	// Spawn anchor (the object that we will rotate)
	self.anchor = spawn("script_model", self.origin );
	self.anchor.angles = self.angles;

	// Link to anchor
	self linkto( self.anchor, "", vOffset, angles );
	self show();

	wait .05;	// Let it happen

	gravity = 100;

	// Set gravity
	vGravity = (0,0,-0.02 * gravity);

	stopme = 0;
	// Drop with gravity
	for(;;)
	{
		// Let gravity do, what gravity do best
		vVelocity +=vGravity;

		// Get destination origin
		neworigin = self.anchor.origin + vVelocity;

		// Check for impact, check for entities but not myself.
		trace=bulletTrace(self.anchor.origin,neworigin,true,self); 
		if(trace["fraction"] != 1)	// Hit something
		{
			// Place object at impact point - radius
			distance = distance(self.anchor.origin,trace["position"]);
			if(distance)
			{
				fraction = (distance - radius) / distance;
				delta = trace["position"] - self.anchor.origin;
				delta2 = maps\mp\_utility::vectorScale(delta,fraction);
				neworigin = self.anchor.origin + delta2;
			}
			else
				neworigin = self.anchor.origin;


			// Play sound if defined
			if(isdefined(bouncesound)) self.anchor playSound(bouncesound);

			// Test if we are hitting ground and if it's time to stop bouncing
			if(vVelocity[2] <= 0 && vVelocity[2] > -10) stopme++;
			if(stopme==5)
			{
				stopme=0;
				// Set origin to impactpoint	
				self.anchor.origin = neworigin;
				// Wait for damage
				self waittill ("damage", dmg, who, dir, point, mod);
				vVelocity = maps\mp\_utility::vectorScale(dir, (dmg/15 + randomFloat(5)) ) + (0,0,(dmg/15 + randomFloat(5)) );
				continue;
			}
			// Play effect if defined and it's a hard hit
			if(isdefined(bouncefx) && length(vVelocity) > 20) playfx(bouncefx,trace["position"]);

			// Decrease speed for each bounce.
			vSpeed = length(vVelocity) * falloff;

			// Calculate new direction (Thanks to Hellspawn this is finally done correctly)
			vNormal = trace["normal"];
			vDir = maps\mp\_utility::vectorScale(vectorNormalize( vVelocity ),-1);
			vNewDir = ( maps\mp\_utility::vectorScale(maps\mp\_utility::vectorScale(vNormal,2),vectorDot( vDir, vNormal )) ) - vDir;

			// Scale vector
			vVelocity = maps\mp\_utility::vectorScale(vNewDir, vSpeed);
	
			// Add a small random distortion
			vVelocity += (randomFloat(1)-0.5,randomFloat(1)-0.5,randomFloat(1)-0.5);
		}

		self.anchor.origin = neworigin;

		// Rotate pitch
		a0 = self.anchor.angles[0] + pitch;
		while(a0<0) a0 += 360;
		while(a0>359) a0 -=360;

		// Rotate yaw
		a1 = self.anchor.angles[1] + yaw;
		while(a1<0) a1 += 360;
		while(a1>359) a1 -=360;

		// Rotate roll
		a2 = self.anchor.angles[2] + roll;
		while(a2<0) a2 += 360;
		while(a2>359) a2 -=360;
		self.anchor.angles = (a0,a1,a2);
		
		// Wait one frame
		wait .05;
	}

	if( isDefined( self.anchor ) )
		self.anchor delete();
}

//getangledelta() ? <|
parachute()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "spawned" );

	if( self isOnGround() )
		return;

	// Check if we really can use parachute
	position = bulletTrace( self.origin, self.origin - (0,0,5000), false, self )["position"];
	if( distance( self.origin, position ) < 200 )
		return;

	forward = maps\mp\_utility::vectorscale( anglesToForward( self.angles ), 16) + self.origin;
	trace = bulletTrace( self.origin + (0,0,2), forward, false, self )["fraction"];
	if( trace < 1 )
		return;

	backward = maps\mp\_utility::vectorscale( anglesToForward( self.angles ), -16) + self.origin;
	trace = bulletTrace( self.origin + (0,0,2), backward, false, self )["fraction"];
	if( trace < 1 )
		return;

	right = maps\mp\_utility::vectorscale( anglesToRight( self.angles ), 16) + self.origin;
	trace = bulletTrace( self.origin + (0,0,2), right, false, self )["fraction"];
	if( trace < 1 )
		return;

	left = maps\mp\_utility::vectorscale( anglesToForward( self.angles ), -16) + self.origin;
	trace = bulletTrace( self.origin + (0,0,2), left, false, self )["fraction"];
	if( trace < 1 )
		return;

	self.isParachuting = true;

	self.parachute = spawn( "script_model", self.origin + (0,0,30) );
	self.parachute setModel( "xmodel/bx_parachute" );
	self.parachute.angles = self.angles;
	self linkTo( self.parachute );

	time = ( distance( self.origin, position + (0,0,30) ) / 128 );
	if( time < 0.1 ) time = 0.1;
	self.parachute moveTo( position + (0,0,45), time );

	for( i = 0; i < time * 20; i++ )
	{
		self setClientCvar( "cl_stance", "0" );
		self.parachute.angles = self.angles;
		wait 0.05;
	}

	self.god = true;
	self unlink();
	wait 0.3;
	self.god = false;
	self.isParachuting = false;

	if( isDefined( self.parachute ) )
		self.parachute delete();
}

gameMonitor()
{
	wait 1;
	while(1)
	{
		players = getEntArray( "player", "classname" );
		for( i = 0; i < players.size; i++ )
		{
			player = players[i];

			if( isDefined(player) && isDefined( player.pers["team"] ) )
			{
//########## CVARS ####################//

			if( !isDefined( player.isInVehicle ) )
				player setClientCvar( "ui_helptext", "" );

//######## PARACHUTE ##################//
			if( !isDefined( player.isInVehicle ) && !player.isParachuting && !player isOnGround() && isAlive( player ) && isDefined(player.pers["team"]) && player.pers["team"] == "allies" && level.map != "bx_pipe" )
			{
				trace = bulletTrace( player.origin, player.origin - (0,0,5000), false, player )["position"];
				if( distance( player.origin, trace ) > 200 )
				{
					player setClientCvar( "ui_helptext", "^2Press ^1MELEE^2 and ^1USE ^2to open parachute!" );
					if( player meleeButtonPressed() && player useButtonPressed() )
						player thread parachute();
				}
			}
			}
//#####################################//
		}
		wait 0.1;
	}
}

// development only
drawLine( start, end, color, time )
{
	for ( i = 0; i < time * 20; i++ )
	{
		line( start, end, color, 0.5 );
		wait .05;
	}
}