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

main()
{
	level endon("lastman thread started");
	wait 10;
	while(1)
	{
		spawnpoint = level.spawns;

		while( 1 )
		{
			num = RandomInt( spawnpoint.size );
			if( !isDefined( spawnpoint[num].ammodrop ) )
				break;

			wait 0.1;
		}

		spawnpoint[num].mysterybox = true;
		level.mystery_box_spawned = true;
		
		origin = bulletTrace( spawnpoint[num].origin + (0,0,30), spawnpoint[num].origin + (0,0,-100), false, undefined )["position"];
		
		level.mystery_box = spawn( "script_model", origin );
		angles = level.mystery_box maps\mp\_utility::getPlant();
		level.mystery_box.angles = angles.angles + spawnpoint[num].angles;
		level.mystery_box setModel( "xmodel/crate_misc1_stalingrad" );
		level.mystery_box thread mystery_box();
//		level.mystery_box thread playLightFx();

		objective_add( 2, "current", level.mystery_box.origin, "gfx/hud/hud@objectivegoal.tga" );
		objective_team( 2 ,"allies" );

		players = getentarray( "player", "classname" );
		for( i = 0; i < players.size; i++ )
		{
			if(isDefined( players[i].pers["team"]) && players[i].pers["team"] == "allies" )
				players[i] iPrintlnBold( "^3Mystery Box is now ready!" );

			players[i].pickedMysteryWeapon = false;
		}

		wait level.zom["mystery_box_time"];
				
		level.mystery_box_spawned = false;
		objective_delete(2);

		if( isDefined( level.mystery_box.weapon ) )
			level.mystery_box.weapon delete();
		level.mystery_box delete();
		spawnpoint[num].mysterybox = undefined;

		wait level.zom["mystery_box_delay"];
	}
}

playLightFx()
{
	level endon("lastman thread started");
	while( isDefined( self ) )
	{
		playFx( level.fx["green_light_128"], self.origin + (0,0,38) );
		wait 0.98;
	}
}



mystery_box()
{
	level endon("lastman thread started");
	while( level.mystery_box_spawned )
	{
		players = getentarray("player", "classname");
		for( i = 0; i < players.size; i++ )
		{
			player = players[i];
			if( player.sessionstate == "playing" && player.pers["team"] == "allies" )
			{
				if( distance(player.origin, self.origin) < 72 && player useButtonPressed() && !player.pickedMysteryWeapon )
				{
					if( !isDefined(self.weapon) )
					{
						self.weapon = spawn( "script_model", self.origin + (0,0,20) );
						self.weapon.angles = (0,(self.angles[1] + 90),0);
						//self.weapon linkTo(self);
						self playSound( "mystery_box_open" );
	
						self.weapon moveZ( 22, 1.1 );
						self.weapon createRandomItem();
						for( i = 0; i < 3; i++ )
						{
							wait 0.33;
							self.weapon createRandomItem();
						}
						wait 0.1;
						self.weapon.ready = true;
						self.weapon thread deleteOverTime(2.5);
					}
					else if( isDefined( self.weapon ) && isDefined( self.weapon.ready ) && !player.pickedMysteryWeapon )
					{
						player.pickedMysteryWeapon = true;
						self playSound( "mystery_box_take" );

						slot = self.weapon.slot;
						if( slot == "primary" && player getWeaponSlotWeapon("primary") != "none" )
							slot = "primaryb";
						
						ammo = maps\mp\gametypes\_zombie::getClipSize(self.weapon.weaponName);
						if( self.weapon.weaponName == "tnt_mp" )
							ammo = 1;

						player setWeaponSlotWeapon( slot, self.weapon.weaponName );
						player setWeaponSlotClipAmmo( slot, ammo );
						player setWeaponSlotAmmo( slot, (ammo * 2) );
						player switchToWeapon( self.weapon.weaponName );

						self.weapon delete();

						player playLocalSound( "weap_pickup" );
						wait 1.6;
					}
				}
			}
		}
		wait 0.15;
	}
}

createRandomItem()
{
	num = randomInt( 20 );
	switch( num )
	{
	case 0:
		self setModel( "xmodel/weapon_MK2FragGrenade" );
		self.weaponName = "fraggrenade_mp";
		self.slot = "grenade";
		break;

	case 1:
		self setModel( "xmodel/weapon_colt45" );
		self.weaponName = "colt_mp";
		self.slot = "pistol";
		break;

	case 2:
		self setModel( "xmodel/weapon_m1carbine" );
		self.weaponName = "m1carbine_mp";
		self.slot = "primary";
		break;

	case 3:
		self setModel( "xmodel/weapon_thompson" );
		self.weaponName = "thompson_mp";
		self.slot = "primary";
		break;

	case 4:
		self setModel( "xmodel/weapon_bar" );
		self.weaponName = "bar_mp";
		self.slot = "primary";
		break;

	case 5:
		self setModel( "xmodel/weapon_springfield" );
		self.weaponName = "springfield_mp";
		self.slot = "primary";
		break;

	case 6:
		self setModel( "xmodel/weapon_m1garand" );
		self.weaponName = "m1garand_mp";
		self.slot = "primary";
		break;

	case 7:
		self setModel( "xmodel/weapon_enfield" );
		self.weaponName = "enfield_mp";
		self.slot = "primary";
		break;

	case 8:
		self setModel( "xmodel/weapon_sten" );
		self.weaponName = "sten_mp";
		self.slot = "primary";
		break;

	case 9:
		self setModel( "xmodel/weapon_bren" );
		self.weaponName = "bren_mp";
		self.slot = "primary";
		break;

	case 10:
		self setModel( "xmodel/weapon_mosinnagant" );
		self.weaponName = "mosin_nagant_mp";
		self.slot = "primary";
		break;

	case 11:
		self setModel( "xmodel/weapon_ppsh" );
		self.weaponName = "ppsh_mp";
		self.slot = "primary";
		break;

	case 12:
		self setModel( "xmodel/weapon_mosinnagantscoped" );
		self.weaponName = "mosin_nagant_sniper_mp";
		self.slot = "primary";
		break;

	case 13:
		self setModel( "xmodel/weapon_kar98" );
		self.weaponName = "kar98k_mp";
		self.slot = "primary";
		break;

	case 14:
		self setModel( "xmodel/weapon_mp40" );
		self.weaponName = "mp40_mp";
		self.slot = "primary";
		break;

	case 15:
		self setModel( "xmodel/weapon_mp44" );
		self.weaponName = "mp44_mp";
		self.slot = "primary";
		break;

	case 16:
		self setModel( "xmodel/weapon_kar98scoped" );
		self.weaponName = "kar98k_sniper_mp";
		self.slot = "primary";
		break;

	case 17:
		self setModel( "xmodel/weapon_panzerfaust" );
		self.weaponName = "panzerfaust_mp";
		self.slot = "primary";
		break;

	case 18:
		self setModel( "xmodel/weapon_fg42" );
		self.weaponName = "fg42_mp";
		self.slot = "primary";
		break;

	case 19:
		self setModel( "xmodel/mp_bomb1" );
		self.weaponName = "tnt_mp";
		self.slot = "grenade";
		break;

		
	}
}

deleteOverTime( time )
{
	for( i = 0; i < time; i++ )
	{
		wait 1;
		if( !isDefined( self ) )
			break;
	}	

	if( isDefined( self ) )
		self delete();
}