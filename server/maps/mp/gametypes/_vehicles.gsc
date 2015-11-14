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

/*QUAKED mp_brax_vehicle (1 1 0) (-32 -32 0) (32 32 56)
defaultmdl="xmodel/vehicle_german_kubelwagen_carride"
Useable vehicle for MP.
Spawn point for BraXi's Zombie Mod version 1.2 or greater.
*/

main()
{
	level.cars = [];

	if( !level.zom["vehicles"] )
		return;

	precacheModel( "xmodel/vehicle_german_kubelwagen" );

	vehicles = getEntArray( "mp_brax_vehicle", "classname" );
	if( !vehicles.size )
	{
		map = getCvar( "mapname" );
		switch( map )
		{
			case "big_Boom":
			spawnVehicle( (41,-206, 9), (0,90,0) );
			break;
		}
	}
	else
	{
		for ( i = 0; i < vehicles.size; i++ )
		{
			spawnVehicle( vehicles[i].origin, vehicles[i].angles );
		}
	}

}

spawnVehicle( origin, angles )
{
	level.cars[level.cars.size] = spawn( "script_model", origin );
	level.cars[level.cars.size-1].angles = angles;
	level.cars[level.cars.size-1] setModel( "xmodel/vehicle_german_kubelwagen" );
	level.cars[level.cars.size-1].targetname = "vehicle_BraXi";
	level.cars[level.cars.size-1].driver = undefined;
	level.cars[level.cars.size-1].passenger1 = undefined;
	level.cars[level.cars.size-1].passenger2 = undefined;
	level.cars[level.cars.size-1].gunner = undefined;

	level.cars[level.cars.size-1] thread waitForUse();
	level.cars[level.cars.size-1] thread initialize();

	iPrintln( "Vehicle spawned at position " + origin );
}

waitForUse()
{
	while( isDefined( self ) )
	{
		wait 0.1;
		players = getEntArray( "player", "classname" );
		for( i = 0; i < players.size; i++ )
		{
			if( distance( self.origin, players[i].origin ) < 82 )
			{
				if( players[i] useButtonPressed() && isDefined( self.driver ) && self.driver == players[i] )
				{
					players[i] iPrintlnBold( "You left the vehicle" );
					players[i] cleanUpVehicle();
					players[i] enableWeapon();
					wait 0.4;
					continue;
				}
				else if( players[i] useButtonPressed() && isDefined( self.passenger1 ) && self.passenger1 == players[i] )
				{
					players[i] iPrintlnBold( "You left the vehicle" );
					players[i] cleanUpVehicle();	
					wait 0.4;
					continue;
				}
				else if( players[i] useButtonPressed() && isDefined( self.passenger2 ) && self.passenger2 == players[i] )
				{
					players[i] iPrintlnBold( "You left the vehicle" );
					players[i] cleanUpVehicle();	
					wait 0.4;
					continue;
				}
				else if( players[i] useButtonPressed() && isDefined( self.gunner ) && self.gunner == players[i] )
				{
					players[i] iPrintlnBold( "You left the vehicle" );
					players[i] cleanUpVehicle();	
					wait 0.4;
					continue;
				}

				if( !isDefined( players[i].isInVehicle ) && players[i] useButtonPressed() && !isDefined( self.driver ) )
				{
					players[i].isInVehicle = self;
					self.driver = players[i];
					players[i] iPrintlnBold( "You are driver" );
					seatOrigin = self.origin + (0,0,14) + maps\mp\_utility::vectorScale( anglesToForward( self.angles ), 8 ) + maps\mp\_utility::vectorScale( anglesToRight( self.angles ), -16 );
					players[i] setOrigin( seatOrigin );
					players[i] linkTo( self );
					players[i] disableWeapon();
					self.soundEntity playSound( "zombx_vehicle_start" );
					self stopLoopSound();
					self playLoopSound( "zombx_vehicle_idle" );
					players[i].angles = ( self.angles[0], self.angles[1], 0 );
					wait 0.4;
					continue;
				}

				if( !isDefined( players[i].isInVehicle ) && players[i] useButtonPressed() && isDefined( self.driver ) && !isDefined( self.passenger1 ) )
				{
					players[i].isInVehicle = self;
					self.passenger1 = players[i];
					players[i] iPrintlnBold( "You are passenger" );
					seatOrigin = self.origin + maps\mp\_utility::vectorScale( anglesToForward( self.angles ), 8 ) + maps\mp\_utility::vectorScale( anglesToRight( self.angles ), 16 );
					players[i] setOrigin( seatOrigin );
					players[i] linkTo( self );
					wait 0.4;
					continue;
				}
				if( !isDefined( players[i].isInVehicle ) && players[i] useButtonPressed() && isDefined( self.driver ) && isDefined( self.passenger1 ) && !isDefined( self.passenger2 ) )
				{
					players[i].isInVehicle = self;
					self.passenger2 = players[i];
					players[i] iPrintlnBold( "You are passenger" );
					seatOrigin = self.origin + maps\mp\_utility::vectorScale( anglesToForward( self.angles ), -8 ) + maps\mp\_utility::vectorScale( anglesToRight( self.angles ), -16 );
					players[i] setOrigin( seatOrigin );
					players[i] linkTo( self );
					wait 0.4;
					continue;
				}

				if( !isDefined( players[i].isInVehicle ) && players[i] useButtonPressed() && isDefined( self.driver ) && isDefined( self.passenger1 ) && isDefined( self.passenger2 ) && !isDefined( self.gunner ) )
				{
					players[i].isInVehicle = self;
					self.gunner = players[i];
					players[i] iPrintlnBold( "You are passenger" );
					seatOrigin = self.origin + maps\mp\_utility::vectorScale( anglesToForward( self.angles ), -8 ) + maps\mp\_utility::vectorScale( anglesToRight( self.angles ), 16 );
					players[i] setOrigin( seatOrigin );
					players[i] linkTo( self );
					wait 0.4;
					continue;
				}
			}
		}
	}
}

initialize()
{
	self.speed = 0;
	self.movetype = "idle";
	oldOrigin = (0,0,0);
	oldMovetype = "idle";
	self.soundEntity = spawn( "script_model", self.origin + (0,0,50) );
	self.soundEntity setContents( 0 );
	self.soundEntity linkTo( self );

	while( isDefined( self ) )
	{
		if( isDefined( self.driver ) ) 
			angle = self.driver.angles[1];
		else 
			angle = self.angles[1];

		gravity = bulletTrace( self.origin + (0,0,70), self.origin - (0,0,100), false, self );
		angles = ( self.angles[0], angle, self.angles[2] );
		forward = self.origin + maps\mp\_utility::vectorScale( anglesToForward( angles ), (36 * self.speed) );
		backward = self.origin + maps\mp\_utility::vectorScale( anglesToForward( angles ), -12 );
		fall = self maps\mp\_utility::getPlant();

		forward_bones = [];
		backward_bones = [];
		forwardLeftC = self.origin + (0,0,30) + maps\mp\_utility::vectorScale( anglesToForward( self.angles ), 75 ) + maps\mp\_utility::vectorScale( anglesToRight( angles ), -30 );
		forwardRightC = self.origin + (0,0,30) + maps\mp\_utility::vectorScale( anglesToForward( self.angles ), 75 ) + maps\mp\_utility::vectorScale( anglesToRight( angles ), 30 );
		forwardCentreC = self.origin + (0,0,30) + maps\mp\_utility::vectorScale( anglesToForward( self.angles ), 75 );
		backwardLeftC = self.origin + (0,0,30) + maps\mp\_utility::vectorScale( anglesToForward( self.angles ), -70 ) + maps\mp\_utility::vectorScale( anglesToRight( angles ), -30 );
		backwardRightC = self.origin + (0,0,30) + maps\mp\_utility::vectorScale( anglesToForward( self.angles ), -70) + maps\mp\_utility::vectorScale( anglesToRight( angles ), 30 );
		backwardCentreC = self.origin + (0,0,30) + maps\mp\_utility::vectorScale( anglesToForward( self.angles ), -70 );
		forward_bones[forward_bones.size] = bulletTrace( self.origin + (0,0,30), forwardLeftC, false, self )["fraction"];
		forward_bones[forward_bones.size] = bulletTrace( self.origin + (0,0,30), forwardRightC, false, self )["fraction"];
		forward_bones[forward_bones.size] = bulletTrace( self.origin + (0,0,30), forwardCentreC, false, self )["fraction"];
		backward_bones[backward_bones.size] = bulletTrace( self.origin + (0,0,30), backwardLeftC, false, self )["fraction"];
		backward_bones[backward_bones.size] = bulletTrace( self.origin + (0,0,30), backwardRightC, false, self )["fraction"];
		backward_bones[backward_bones.size] = bulletTrace( self.origin + (0,0,30), backwardCentreC, false, self )["fraction"];

		collision_forward = undefined;
		collision_backward = undefined;
		for( i = 0; i < forward_bones.size; i++ )
		{
			if( forward_bones[i] < 1.0 )
			{
				collision_forward = true;
				break;
			}
		}
		for( i = 0; i < backward_bones.size; i++ )
		{
			if( backward_bones[i] < 1.0 )
			{
				collision_backward = true;
				break;
			}
		}

		players = getEntArray( "player", "classname" );
		for( i = 0; i < players.size; i++ )
		{
			player = players[i];	
			if( isDefined(player) && !isDefined( player.isInVehicle ) && player.pers["team"] != "spectator" && player.sessionstate == "playing" && distance( player.origin, self.origin ) < 110 )
			{
				self thread kickOut( player, forwardLeftC, forwardRightC, forwardCentreC, backwardLeftC, backwardRightC, backwardCentreC );
			}
		}

		/# // developer_script 1
		line( self.origin + (0,0,30), forwardLeftC, (0,1,0), false, 0.3 );
		line( self.origin + (0,0,30), forwardCentreC, (0,1,0), false, 0.3 );
		line( self.origin + (0,0,30), forwardRightC, (0,1,0), false, 0.3 );
		line( self.origin + (0,0,30), backwardLeftC, (0,1,0), false, 0.3 );
		line( self.origin + (0,0,30), backwardCentreC, (0,1,0), false, 0.3 );
		line( self.origin + (0,0,30), backwardRightC, (0,1,0), false, 0.3 );
		line( forwardLeftC, forwardRightC, (0,0,1), false, 0.3 );
		line( backwardLeftC, backwardRightC, (0,0,1), false, 0.3 );
		line( forwardLeftC, backwardLeftC, (1,0,0), false, 0.3 );
		line( forwardRightC, backwardRightC, (1,0,0), false, 0.3 );
		#/

		if( isDefined( collision_forward ) )
		{
			self.speed = 0;
//			iPrintln( "Forward collision detected" );
		}
		if( isDefined( collision_backward ) )
		{
			self.speed = 0;
//			iPrintln( "Backward collision detected" );
		}

		if( isDefined( self.driver ) && self.driver meleeButtonPressed() && !isDefined( collision_forward ) )
		{
			if( self.movetype != "forward" )
				self.driver.angles = self.angles;

			self.speed += 0.05;
			if( self.speed > 2 ) self.speed = 2;
			self moveTo( (forward[0], forward[1], gravity["position"][2]) , 0.2 );
			self rotateTo( (fall.angles[0], self.driver.angles[1], fall.angles[2]), 0.2 );
			self.movetype = "forward";
		}
		else if( isDefined( self.driver ) && !self.driver meleeButtonPressed() && self.movetype != "backward" && self.speed > 0.2 && !isDefined( collision_forward ) )
		{
			self.speed -= 0.1;
			if( self.speed < 0 ) self.speed = 0;
			self moveTo( (forward[0], forward[1], gravity["position"][2]) , 0.2 );
			self rotateTo( (fall.angles[0], self.driver.angles[1], fall.angles[2]), 0.2 );
			self.movetype = "forward";
		}
		else if( isDefined( self.driver ) && self.driver attackButtonPressed() && !isDefined( collision_backward ) )
		{
			self.speed = 0;
			self moveTo( (backward[0], backward[1], gravity["position"][2]) , 0.2 );
			self rotateTo( (fall.angles[0], self.driver.angles[1], fall.angles[2]), 0.2 );
			self.movetype = "backward";
		}
		else if( !isDefined( collision_forward ) && !isDefined( collision_backward ) && isDefined( self.driver ) && !self.driver meleeButtonPressed() || !isDefined( collision_forward ) && !isDefined( collision_backward ) && !isDefined( self.driver ) )
		{
			self.speed -= 0.1;
			if( self.speed < 0 ) self.speed = 0;
			self moveTo( (forward[0], forward[1], gravity["position"][2]) , 0.2 );
			self rotateTo( (fall.angles[0], self.angles[1], fall.angles[2]), 0.2 );
			self.movetype = "idle";
		}
		if( self.origin == oldOrigin )
		{
			self.movetype = "idle";
		}

		if( isDefined( self.driver ) )
		{
			self.driver setClientCvar( "cg_fov", 90 );
			self.driver setClientCvar( "cl_stance", 1 );
			self.driver shellShock( "vehicle_driver", 0.21 );
			self.driver.sprinting = false;
			self.driver disableWeapon();
			self.driver.maxspeed = 190;

			if( self.movetype == "forward" )
				self.driver setClientCvar( "ui_helptext", "^2Speed: ^1" + (32 * self.speed) + " ^2(^1" + (self.speed * 50) + " percent^2)" );
			else 
				self.driver setClientCvar( "ui_helptext", "^1MELEE ^2to drive forward and ^1FIRE^2 to drive backward | ^1USE^2 to exit vehicle" );
		}

		if( self.movetype != oldMovetype )
		{
			self stopLoopSound();
			if( self.movetype == "forward" && isDefined( self.driver ) || self.movetype == "backward" && isDefined( self.driver ) )
			{
				self playLoopSound( "zombx_vehicle_engine" );
			}
			else if( self.movetype == "idle" && isDefined( self.driver ) )
			{
				self playLoopSound( "zombx_vehicle_idle" );
			}
		}
		wait 0.1;
		oldOrigin = self.origin;
		oldMovetype = self.movetype;
	}

//	if( isDefined( self.isInVehicle.soundEntity ) )
//		self.isInVehicle.soundEntity delete();
}


cleanUpVehicle()
{
	if( isDefined( self.isInVehicle ) )
	{
		self unLink();
		if( isDefined( self.isInVehicle.driver ) && self.isInVehicle.driver == self )
		{
			self.isInVehicle.driver = undefined;
			self.isInVehicle stopLoopSound();
			self setClientCvar( "cg_fov", 80 );
			self setClientCvar( "cl_stance", 0 );
			self stopShellShock();
		}
		if( isDefined( self.isInVehicle.passenger1 ) && self.isInVehicle.passenger1 == self )
			self.isInVehicle.passenger1 = undefined;
		if( isDefined( self.isInVehicle.passenger2 ) && self.isInVehicle.passenger2 == self )
			self.isInVehicle.passenger2 = undefined;
		if( isDefined( self.isInVehicle.gunner ) && self.isInVehicle.gunner == self )
			self.isInVehicle.gunner = undefined;
		self.isInVehicle = undefined;
	}
}

kickOut( player, forwardLeftC, forwardRightC, forwardCentreC, backwardLeftC, backwardRightC, backwardCentreC )
{
	if( self.movetype == "forward" )
	{
		if( distance( player.origin, forwardLeftC ) <= 40 ||
			distance( player.origin, forwardRightC ) <= 40 ||
			distance( player.origin, forwardCentreC ) <= 38 )
		{
			for( i = 0; i < 2; i++ )
			{
				kickPower = (300 * self.speed);
				player.health = player.health + kickPower;
				who = player;
				if( isDefined( self.driver ) ) who = self.driver;
				player finishPlayerDamage( who, self, kickPower, 0, "MOD_PROJECTILE", "none", (self.origin - (0,0,10)), vectornormalize( player.origin - (self.origin - (0,0,10)) ), "none" );
			}
			if( isDefined( self.driver ) && self.driver.pers["team"] != player.pers["team"] )
			{
				damage = player.maxhealth * 0.34;
				player [[level.callbackPlayerDamage]]( self.driver, self.driver, damage, 0, "MOD_PROJECTILE", "none", (self.origin - (0,0,10)), vectornormalize( player.origin - (self.origin - (0,0,10)) ), "none" );
			}
		}
	}
	else if( self.movetype == "backward" )
	{

		if( distance( player.origin, backwardLeftC ) <= 40 ||
			distance( player.origin, backwardRightC ) <= 40 ||
			distance( player.origin, backwardCentreC ) <= 38 )
		{
			for( i = 0; i < 2; i++ )
			{
				kickPower = (300 * self.speed);
				player.health = player.health + kickPower;
				who = player;
				if( isDefined( self.driver ) ) who = self.driver;
				player finishPlayerDamage( who, self, kickPower, 0, "MOD_PROJECTILE", "none", (self.origin - (0,0,10)), vectornormalize( player.origin - (self.origin - (0,0,10)) ), "none" );
			}
			if( isDefined( self.driver ) && self.driver.pers["team"] != player.pers["team"] )
			{
				damage = player.maxhealth * 0.34;
				player [[level.callbackPlayerDamage]]( self.driver, self.driver, damage, 0, "MOD_PROJECTILE", "none", (self.origin - (0,0,10)), vectornormalize( player.origin - (self.origin - (0,0,10)) ), "none" );
			}
		}
	}
}

