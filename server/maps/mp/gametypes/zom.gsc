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

/*QUAKED mp_brax_zombie_spawn (1.0 0.0 0.0) (-16 -16 0) (16 16 72)
Zombie spawn for BraXi's Zombie Mod.
Zombies spawn near their team, away from Hunters.
*/

/*QUAKED mp_brax_hunter_spawn (0.0 1.0 0.0) (-16 -16 0) (16 16 72)
Hunter spawn for BraXi's Zombie Mod.
Hunters spawn near their team, away from Zombies.
*/

main()
{
	spawnpointname = "mp_teamdeathmatch_spawn";
	spawnpoints = getentarray(spawnpointname, "classname");
	
	if(!spawnpoints.size)
	{
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}

	for(i = 0; i < spawnpoints.size; i++)
		spawnpoints[i] placeSpawnpoint();

	level.callbackStartGameType = ::Callback_StartGameType;
	level.callbackPlayerConnect = ::Callback_PlayerConnect;
	level.callbackPlayerDisconnect = ::Callback_PlayerDisconnect;
	level.callbackPlayerDamage = ::Callback_PlayerDamage;
	level.callbackPlayerKilled = ::Callback_PlayerKilled;

	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	
	allowed[0] = "tdm";
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	if(getCvar("scr_zom_timelimit") == "")		// Time limit per map
		setCvar("scr_zom_timelimit", "14");
	else if(getCvarFloat("scr_zom_timelimit") > 1440)
		setCvar("scr_zom_timelimit", "1440");
	level.timelimit = getCvarFloat("scr_zom_timelimit");
	setCvar("ui_zom_timelimit", level.timelimit);
	makeCvarServerInfo("ui_zom_timelimit", "30");

	if(getCvar("scr_zom_scorelimit") == "")		// Score limit per map
		setCvar("scr_zom_scorelimit", "100");
	level.scorelimit = 0;
	setCvar("ui_zom_scorelimit", level.scorelimit);
	makeCvarServerInfo("ui_zom_scorelimit", "100");

	if(getCvar("scr_forcerespawn") == "")		// Force respawning
		setCvar("scr_forcerespawn", "0");
	
	if(getCvar("scr_teambalance") == "")		// Auto Team Balancing
		setCvar("scr_teambalance", "0");
	level.teambalance = 0;
	level.teambalancetimer = 0;
	
	killcam = getCvar("scr_kill_camera");
	if(killcam == "")				// Kill cam
		killcam = "1";
	setCvar("scr_kill_camera", killcam);
	level.killcam = getCvarInt("scr_kill_camera");
	
	if(getCvar("scr_drawfriend") == "")		// Draws a team icon over teammates
		setCvar("scr_drawfriend", "0");
	level.drawfriend = getCvarInt("scr_drawfriend");
	
	teamscorepenalty = getCvar("scr_teamscorepenalty");
	if(teamscorepenalty == "")			// Decrement teamscore for team kills and suicides
		teamscorepenalty = "0";
	setCvar("scr_teamscorepenalty", teamscorepenalty);

	if(!isDefined(game["state"]))
		game["state"] = "playing";

	level.mapended = false;
	level.healthqueue = [];
	level.healthqueuecurrent = 0;
	
	level.team["allies"] = 0;
	level.team["axis"] = 0;
	
	if(level.killcam >= 1 || level.zom["game_cam"] )
		setarchive(true);
}

Callback_StartGameType()
{
	// defaults if not defined in level script
	if(!isDefined(game["allies"]))
		game["allies"] = "american";
	if(!isDefined(game["axis"]))
		game["axis"] = "german";

	if(!isDefined(game["layoutimage"]))
		game["layoutimage"] = "default";
	layoutname = "levelshots/layouts/hud@layout_" + game["layoutimage"];
	precacheShader(layoutname);
	setCvar("scr_layoutimage", layoutname);
	makeCvarServerInfo("scr_layoutimage", "");

	// server cvar overrides
	if(getCvar("scr_allies") != "")
		game["allies"] = getCvar("scr_allies");	
	if(getCvar("scr_axis") != "")
		game["axis"] = getCvar("scr_axis");
	
	game["menu_serverinfo"] = "serverinfo_zom";
	game["menu_team"] = "team_hunters_zombies";
	game["menu_weapon_allies"] = "weapon_american";
	game["menu_weapon_allies2"] = "weapon_british";
	game["menu_weapon_allies3"] = "weapon_german";
	game["menu_weapon_allies4"] = "weapon_russian";
	game["menu_weapon_axis"] = "weapon_zombie";
	game["menu_viewmap"] = "viewmap";
	game["menu_callvote"] = "callvote";
	game["menu_quickcommands"] = "quickcommands";
	game["menu_quickstatements"] = "quickstatements";
	game["menu_quickresponses"] = "quickresponses";
	game["menu_stuff"] = "stuff";
	game["menu_weapon_lm"] = "weapon_lastman";
	game["menu_shop"] = "shop";

	precacheString(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");
	precacheString(&"MPSCRIPT_KILLCAM");

	precacheMenu(game["menu_serverinfo"]);	
	precacheMenu(game["menu_team"]);
	precacheMenu(game["menu_weapon_allies"]);
	precacheMenu(game["menu_weapon_allies2"]);
	precacheMenu(game["menu_weapon_allies3"]);
	precacheMenu(game["menu_weapon_allies4"]);
	precacheMenu(game["menu_weapon_axis"]);
	precacheMenu(game["menu_viewmap"]);
	precacheMenu(game["menu_callvote"]);
	precacheMenu(game["menu_quickcommands"]);
	precacheMenu(game["menu_quickstatements"]);
	precacheMenu(game["menu_quickresponses"]);
	precacheMenu(game["menu_stuff"]);
	precacheMenu(game["menu_weapon_lm"]);
	precacheMenu(game["menu_shop"]);

	precacheShader("black");
	precacheShader("hudScoreboard_mp");
	precacheShader("gfx/hud/hud@mpflag_spectator.tga");
	precacheStatusIcon("gfx/hud/hud@status_dead.tga");
	precacheStatusIcon("gfx/hud/hud@status_connecting.tga");
	precacheItem("item_health");

	maps\mp\gametypes\_zom_teams::modeltype();
	maps\mp\gametypes\_zom_teams::precache();
	maps\mp\gametypes\_zom_teams::scoreboard();
	maps\mp\gametypes\_zom_teams::initGlobalCvars();
	maps\mp\gametypes\_zom_teams::initWeaponCvars();
	maps\mp\gametypes\_zom_teams::restrictPlacedWeapons();
	thread maps\mp\gametypes\_zom_teams::updateGlobalCvars();
	thread maps\mp\gametypes\_zom_teams::updateWeaponCvars();

	setClientNameMode("auto_change");
	
	//	BraXi	
	maps\mp\gametypes\_zombie::main();

	//thread globalLogic();

//	thread startGame();
	//thread addBotClients(); // For development testing
	thread updateGametypeCvars();
}

Callback_PlayerConnect()
{
	self.statusicon = "gfx/hud/hud@status_connecting.tga";
	self waittill("begin");
	self.statusicon = "";
	self.pers["teamTime"] = 1000000;
	
	iprintln(&"MPSCRIPT_CONNECTED", self);

	lpselfnum = self getEntityNumber();
	lpGuid = self getGuid();
	logPrint("J;" + lpGuid + ";" + lpselfnum + ";" + self.name + "\n");


	//	BraXi	
	self maps\mp\gametypes\_zombie::playerConnect();

	if(game["state"] == "intermission")
	{
		spawnIntermission();
		return;
	}
	
	level endon("intermission");

	if(isDefined(self.pers["team"]) && self.pers["team"] != "spectator")
	{
		self setClientCvar("ui_weapontab", "1");

		if(self.pers["team"] == "allies")
		{
			self.sessionteam = "allies";
			self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
		}
		else
		{
			self.sessionteam = "axis";
			self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
		}
			
		if(isDefined(self.pers["weapon"]))
			spawnPlayer();
		else
		{
			spawnSpectator();

			if(self.pers["team"] == "allies")
				self openMenu(game["menu_weapon_allies"]);
			else
				self openMenu(game["menu_weapon_axis"]);
		}
	}
	else
	{
		self setClientCvar("g_scriptMainMenu", game["menu_team"]);
		self setClientCvar("ui_weapontab", "0");
		
		if(!isDefined(self.pers["skipserverinfo"]))
			self openMenu(game["menu_serverinfo"]);

		self.pers["team"] = "spectator";
		self.sessionteam = "spectator";

		spawnSpectator();
	}

	for(;;)
	{
		self waittill("menuresponse", menu, response);

//		iprintln("response: " + response );
		
		if(menu == game["menu_serverinfo"] && response == "close")
		{
			self.pers["skipserverinfo"] = true;
			self openMenu(game["menu_team"]);
		}

		if(response == "open" || response == "close")
			continue;

		if(menu == game["menu_team"])
		{
			switch(response)
			{
				case "autoassign":

				if( !level.gameStarted )
					response = "allies";
				else
					response = "axis";

				if(response == self.pers["team"] && self.sessionstate == "playing")
					continue;

//				if(response != self.pers["team"] && self.sessionstate == "playing")
//				{
//					self suicide();
//					self makeZombie();
//				}

				self.pers["team"] = response;
				self.pers["weapon"] = undefined;
				self.pers["weapon1"] = undefined;
				self.pers["weapon2"] = undefined;
				self.pers["spawnweapon"] = undefined;
				self.pers["savedmodel"] = undefined;

				self setClientCvar("scr_showweapontab", "1");

				if(self.pers["team"] == "allies")
				{
					self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
					self openMenu(game["menu_weapon_allies"]);
				}
				else
					self thread maps\mp\gametypes\_zombie::makeZombie( 0.1 );

			break;

			case "spectator":
				if(self.pers["team"] != "spectator")
				{
					self.pers["team"] = "spectator";
					self.pers["teamTime"] = 1000000;
					self.pers["weapon"] = undefined;
					self.pers["savedmodel"] = undefined;
					
					self.sessionteam = "spectator";
					self setClientCvar("g_scriptMainMenu", game["menu_team"]);
					self setClientCvar("ui_weapontab", "0");
					spawnSpectator();
				}
				break;

			case "weapon":
				if(self.pers["team"] == "allies")
					self openMenu(game["menu_weapon_allies"]);
				else if(self.pers["team"] == "axis")
					self openMenu(game["menu_weapon_axis"]);
				break;
				
			case "viewmap":
				self openMenu(game["menu_viewmap"]);
				break;

			case "callvote":
				self openMenu(game["menu_callvote"]);
				break;
			}
		}		
		else if(menu == game["menu_weapon_allies"] || menu == game["menu_weapon_allies2"] || menu == game["menu_weapon_allies3"] || menu == game["menu_weapon_allies4"] || menu == game["menu_weapon_axis"] || menu == game["menu_weapon_lm"] )
		{
			if(response == "team")
			{
				self openMenu(game["menu_team"]);
				continue;
			}
			else if(response == "viewmap")
			{
				self openMenu(game["menu_viewmap"]);
				continue;
			}
			else if(response == "callvote")
			{
				self openMenu(game["menu_callvote"]);
				continue;
			}
			
			if(!isDefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
				continue;

			weapon = self maps\mp\gametypes\_zom_teams::restrict(response);

			if(weapon == "restricted")
			{
				self openMenu(menu);
				continue;
			}
			
			if(isDefined(self.pers["weapon"]) && self.pers["weapon"] == weapon)
				continue;
			
			if(!isDefined(self.pers["weapon"]))
			{
				self.pers["weapon"] = weapon;
				spawnPlayer();
				self thread printJoinedTeam(self.pers["team"]);
			}
			else
			{
				self.pers["weapon"] = weapon;

				weaponname = maps\mp\gametypes\_zom_teams::getWeaponName(self.pers["weapon"]);
				
				if(maps\mp\gametypes\_zom_teams::useAn(self.pers["weapon"]))
					self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_AN", weaponname);
				else
					self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_A", weaponname);
			}
			if (isdefined (self.autobalance_notify))
				self.autobalance_notify destroy();
		}
		else if(menu == game["menu_viewmap"])
		{
			switch(response)
			{
			case "team":
				self openMenu(game["menu_team"]);
				break;
				
			case "weapon":
				if(self.pers["team"] == "allies")
					self openMenu(game["menu_weapon_allies"]);
				else if(self.pers["team"] == "axis")
					self openMenu(game["menu_weapon_axis"]);
				break;

			case "callvote":
				self openMenu(game["menu_callvote"]);
				break;
			}
		}
		else if(menu == game["menu_callvote"])
		{
			switch(response)
			{
			case "team":
				self openMenu(game["menu_team"]);
				break;
				
			case "weapon":
				if(self.pers["team"] == "allies")
					self openMenu(game["menu_weapon_allies"]);
				else if(self.pers["team"] == "axis")
					self openMenu(game["menu_weapon_axis"]);
				break;

			case "viewmap":
				self openMenu(game["menu_viewmap"]);
				break;
			}
		}
		else if(menu == game["menu_quickcommands"])
			maps\mp\gametypes\_zom_teams::quickcommands(response);
		else if(menu == game["menu_quickstatements"])
			maps\mp\gametypes\_zom_teams::quickstatements(response);
		else if(menu == game["menu_quickresponses"])
			maps\mp\gametypes\_zom_teams::quickresponses(response);
		else if(menu == game["menu_stuff"] || menu == "zombie_options")
			maps\mp\gametypes\_zom_teams::quickstuff(response);
		else if(menu == game["menu_shop"])
			maps\mp\gametypes\_zombie::buy(response);
		
	}
}

Callback_PlayerDisconnect()
{
	iprintln(&"MPSCRIPT_DISCONNECTED", self);

	//	BraXi	
	self maps\mp\gametypes\_zombie::playerDisonnect();
	
	lpselfnum = self getEntityNumber();
	lpGuid = self getGuid();
	logPrint("Q;" + lpGuid + ";" + lpselfnum + ";" + self.name + "\n");
}

Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc)
{
	if(self.sessionteam == "spectator")
		return;

	//	BraXi	
	self maps\mp\gametypes\_zombie::playerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);

	if(self.sessionstate != "dead")
	{
		lpselfnum = self getEntityNumber();
		lpselfname = self.name;
		lpselfteam = self.pers["team"];
		lpselfGuid = self getGuid();
		lpattackerteam = "";

		if(isPlayer(eAttacker))
		{
			lpattacknum = eAttacker getEntityNumber();
			lpattackGuid = eAttacker getGuid();
			lpattackname = eAttacker.name;
			lpattackerteam = eAttacker.pers["team"];
		}
		else
		{
			lpattacknum = -1;
			lpattackGuid = "";
			lpattackname = "";
			lpattackerteam = "world";
		}

		if(isDefined(friendly)) 
		{  
			lpattacknum = lpselfnum;
			lpattackname = lpselfname;
			lpattackGuid = lpselfGuid;
		}
		
		logPrint("D;" + lpselfGuid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackGuid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
	}
}

Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
	self endon("spawned");
	self endon("disconnect");
	
	if(self.sessionteam == "spectator")
		return;

	self.sessionstate = "dead";
	self.statusicon = "gfx/hud/hud@status_dead.tga";
	self.headicon = "";

	//	BraXi	
	self maps\mp\gametypes\_zombie::playerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc);

	

//	if (!isdefined (self.autobalance))
//		self.deaths++;

	lpselfnum = self getEntityNumber();
	lpselfname = self.name;
	lpselfguid = self getGuid();
	lpselfteam = self.pers["team"];
	lpattackerteam = "";

	attackerNum = -1;
	if(isPlayer(attacker))
	{
		if(attacker == self) // killed himself
		{
			doKillcam = false;
			if (!isdefined (self.autobalance))
			{
//				attacker.score--;
				
				if ( getCvar("scr_teamscorepenalty") )
				{
					// suicides should affect teamscore
					teamscore = getTeamScore(attacker.pers["team"]);
					teamscore--;
					setTeamScore(attacker.pers["team"], teamscore);
				}
			}
			
			if(isDefined(attacker.friendlydamage))
				clientAnnouncement(attacker, &"MPSCRIPT_FRIENDLY_FIRE_WILL_NOT"); 
		}
		else
		{
			attackerNum = attacker getEntityNumber();
			doKillcam = true;

			if(self.pers["team"] == attacker.pers["team"]) // killed by a friendly
			{
//				attacker.score--;
				
				if ( getCvar("scr_teamscorepenalty") )
				{
					// team kills should affect teamscore
					teamscore = getTeamScore(attacker.pers["team"]);
					teamscore--;
					setTeamScore(attacker.pers["team"], teamscore);
				}
			}
			else
			{
//				attacker.score++;

				teamscore = getTeamScore(attacker.pers["team"]);
				teamscore++;
				setTeamScore(attacker.pers["team"], teamscore);
			
				//checkScoreLimit();
			}
		}

		lpattacknum = attacker getEntityNumber();
		lpattackguid = attacker getGuid();
		lpattackname = attacker.name;
		lpattackerteam = attacker.pers["team"];
	}
	else // If you weren't killed by a player, you were in the wrong place at the wrong time
	{
		doKillcam = false;
		
//		self.score--;

		lpattacknum = -1;
		lpattackname = "";
		lpattackguid = "";
		lpattackerteam = "world";
	}

	logPrint("K;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackguid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");

	// Stop thread if map ended on this death
	if(level.mapended)
		return;
	
	// Make the player drop health
	self dropHealth();
	self.autobalance = undefined;

	delay = 2;	// Delay the player becoming a spectator till after he's done dying
	wait delay;	// ?? Also required for Callback_PlayerKilled to complete before respawn/killcam can execute

	if((getCvarInt("scr_kill_camera") <= 0))
		doKillcam = false;

	if( level.gameStarted && self.pers["team"] == "axis" || !level.gameStarted )
		self thread respawn();

	if( level.gameStarted && self.pers["team"] != "axis" )
	{
		wait 0.2;
		if( getCvarInt("scr_kill_camera") && !level.mapended )
		{
			self thread maps\mp\gametypes\_zombie::makeZombie( 6.2 );
			self setclientcvar( "cg_thirdpersonrange", 60 );
			if( isPlayer( attacker ) )
				attackerNum = attacker getEntityNumber();
			else
				attackerNum = self getEntityNumber();

			self killcam( attackerNum, 6, 0.15 );
		}
		else
			self thread maps\mp\gametypes\_zombie::makeZombie( 1 );
	}
}

spawnPlayer()
{
	self notify("spawned");
	self notify("end_respawn");
	
	resettimeout();

	self.sessionteam = self.pers["team"];
	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.friendlydamage = undefined;
		
	spawnpointname = "mp_teamdeathmatch_spawn";
	if( self.pers["team"] == "allies" && level.hunterSpawns.size > 0 )
		spawnpointname = "mp_brax_hunter_spawn";
	else if( self.pers["team"] == "axis" && level.zombieSpawns.size > 0 )
		spawnpointname = "mp_brax_zombie_spawn";

	spawnpoints = getentarray(spawnpointname, "classname");
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(spawnpoints);

	if(isDefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");

	//	BraXi	
	self thread maps\mp\gametypes\_zombie::spawnPlayer();
	
	self giveWeapon(self.pers["weapon"]);
	self giveMaxAmmo(self.pers["weapon"]);
	self setSpawnWeapon(self.pers["weapon"]);
	
	if(self.pers["team"] == "allies")
		self setClientCvar("cg_objectiveText", "Hunt ^1Zombies^7 or be hunted!");
	else if(self.pers["team"] == "axis")
		self setClientCvar("cg_objectiveText", "Eat some human's brains!");

	if(self.pers["team"] == "allies")
	{
		self.headicon = game["headicon_allies"];
		self.headiconteam = "allies";
		self.statusicon = "gfx/hud/hud@hunter.dds";
	}
	else
	{
		self.headicon = game["headicon_axis"];
		self.headiconteam = "axis";
		self.statusicon = "gfx/hud/hud@zombie.dds";
	}
}

spawnSpectator(origin, angles)
{
	self notify("spawned");
	self notify("end_respawn");

	resettimeout();

	//	BraXi	
	self maps\mp\gametypes\_zombie::spawnSpectator();

	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.friendlydamage = undefined;

	if(self.pers["team"] == "spectator")
		self.statusicon = "";
	
	if(isDefined(origin) && isDefined(angles))
		self spawn(origin, angles);
	else
	{
         	spawnpointname = "mp_teamdeathmatch_intermission";
		spawnpoints = getentarray(spawnpointname, "classname");
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
	
		if(isDefined(spawnpoint))
			self spawn(spawnpoint.origin, spawnpoint.angles);
		else
			maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
	}
	
	self setClientCvar("cg_objectiveText", "Hunt ^1zombies^7 or be hunted!");
}

spawnIntermission()
{
	self notify("spawned");
	self notify("end_respawn");

	resettimeout();

	//	BraXi	
	self maps\mp\gametypes\_zombie::spawnSpectator();

	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.friendlydamage = undefined;

	spawnpointname = "mp_teamdeathmatch_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
	
	if(isDefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
}

respawn()
{
	if(!isDefined(self.pers["weapon"]))
		return;
	
	self endon("end_respawn");
	
	if(getCvarInt("scr_forcerespawn") > 0)
	{
		self thread waitForceRespawnTime();
		self thread waitRespawnButton();
		self waittill("respawn");
	}
	else
	{
		self thread waitRespawnButton();
		self waittill("respawn");
	}
	
	self thread spawnPlayer();
}

waitForceRespawnTime()
{
	self endon("end_respawn");
	self endon("respawn");
	
	wait getCvarInt("scr_forcerespawn");
	self notify("respawn");
}

waitRespawnButton()
{
	self endon("end_respawn");
	self endon("respawn");
	
	wait 0; // Required or the "respawn" notify could happen before it's waittill has begun

	if( level.gameStarted && self.pers["team"] == "allies" )
		return;

	self.respawntext = newClientHudElem(self);
	self.respawntext.alignX = "center";
	self.respawntext.alignY = "middle";
	self.respawntext.x = 320;
	self.respawntext.y = 70;
	self.respawntext.archived = false;
	self.respawntext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");

	thread removeRespawnText();
	thread waitRemoveRespawnText("end_respawn");
	thread waitRemoveRespawnText("respawn");

	while(self useButtonPressed() != true)
		wait .05;
	
	self notify("remove_respawntext");

	self notify("respawn");	
}

removeRespawnText()
{
	self waittill("remove_respawntext");

	if(isDefined(self.respawntext))
		self.respawntext destroy();
}

waitRemoveRespawnText(message)
{
	self endon("remove_respawntext");

	self waittill(message);
	self notify("remove_respawntext");
}

killcam( attackerNum, time, delay )
{
	self endon("spawned");

//	previousorigin = self.origin;
//	previousangles = self.angles;
	
	// killcam
	if(attackerNum < 0)
		return;

	wait delay;

	self setClientCvar( "cg_thirdperson", 1 );

	self.sessionstate = "spectator";
	self.spectatorclient = attackerNum;
	self.archivetime = time - delay;

	// wait till the next server frame to allow code a chance to update archivetime if it needs trimming
	wait 0.05;
/*
	if(self.archivetime <= delay)
	{
		self.spectatorclient = -1;
		self.archivetime = 0;
		self.sessionstate = "dead";
	
		self thread respawn();
		return;
	}
*/
	if(!isDefined(self.kc_topbar))
	{
		self.kc_topbar = newClientHudElem(self);
		self.kc_topbar.archived = false;
		self.kc_topbar.x = 0;
		self.kc_topbar.y = 0;
		self.kc_topbar.alpha = 0.5;
		self.kc_topbar setShader("black", 640, 112);
	}

	if(!isDefined(self.kc_bottombar))
	{
		self.kc_bottombar = newClientHudElem(self);
		self.kc_bottombar.archived = false;
		self.kc_bottombar.x = 0;
		self.kc_bottombar.y = 368;
		self.kc_bottombar.alpha = 0.5;
		self.kc_bottombar setShader("black", 640, 112);
	}

	if(!isDefined(self.kc_title))
	{
		self.kc_title = newClientHudElem(self);
		self.kc_title.archived = false;
		self.kc_title.x = 320;
		self.kc_title.y = 40;
		self.kc_title.alignX = "center";
		self.kc_title.alignY = "middle";
		self.kc_title.sort = 1; // force to draw after the bars
		self.kc_title.fontScale = 3.5;
	}
	self.kc_title setText(&"MPSCRIPT_KILLCAM");

/*
	if(!isDefined(self.kc_skiptext))
	{
		self.kc_skiptext = newClientHudElem(self);
		self.kc_skiptext.archived = false;
		self.kc_skiptext.x = 320;
		self.kc_skiptext.y = 70;
		self.kc_skiptext.alignX = "center";
		self.kc_skiptext.alignY = "middle";
		self.kc_skiptext.sort = 1;
	}
	self.kc_skiptext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");
*/

	if(!isDefined(self.kc_timer))
	{
		self.kc_timer = newClientHudElem(self);
		self.kc_timer.archived = false;
		self.kc_timer.x = 320;
		self.kc_timer.y = 428;
		self.kc_timer.alignX = "center";
		self.kc_timer.alignY = "middle";
		self.kc_timer.fontScale = 3.5;
		self.kc_timer.sort = 1;
	}
	self.kc_timer setTenthsTimer(self.archivetime - (delay + 0.1));

	self thread spawnedKillcamCleanup();
//	self thread waitSkipKillcamButton();
	self thread waitKillcamTime();
	self waittill("end_killcam");

	self removeKillcamElements();

	self setClientCvar( "cg_thirdperson", 0 );

	self.spectatorclient = -1;
	self.archivetime = 0;
	self.sessionstate = "dead";

	//self thread spawnSpectator(previousorigin + (0, 0, 60), previousangles);
//	self thread respawn();
}

waitKillcamTime()
{
	self endon("end_killcam");
	
	wait(self.archivetime - 0.1);
	self notify("end_killcam");
}

waitSkipKillcamButton()
{
	self endon("end_killcam");
	
	while(self useButtonPressed())
		wait .05;

	while(!(self useButtonPressed()))
		wait .05;
	
	self notify("end_killcam");	
}

removeKillcamElements()
{
	if(isDefined(self.kc_topbar))
		self.kc_topbar destroy();
	if(isDefined(self.kc_bottombar))
		self.kc_bottombar destroy();
	if(isDefined(self.kc_title))
		self.kc_title destroy();
	if(isDefined(self.kc_skiptext))
		self.kc_skiptext destroy();
	if(isDefined(self.kc_timer))
		self.kc_timer destroy();
}

spawnedKillcamCleanup()
{
	self endon("end_killcam");

	self waittill("spawned");
	self removeKillcamElements();
}

startGame()
{
	level endon("lastman thread started");

	level.starttime = getTime();
	
	if(level.timelimit > 0)
	{
		level.clock = newHudElem();
		level.clock.x = 320;
		level.clock.y = 60;
		level.clock.alignX = "center";
		level.clock.alignY = "middle";
		level.clock.font = "bigfixed";
		level.clock.alpha = 0;
		level.clock setTimer( level.timelimit * 60 );
		level.clock fadeOverTime( 2.2 );
		level.clock.alpha = 1;
	}
	
	while( !level.lastMan )
	{
		checkTimeLimit();
		wait 1;
	}
}

endMap( winningteam )
{
	maps\mp\gametypes\_zombie::endMap( winningteam );
}

checkTimeLimit()
{
	if(level.timelimit <= 0)
		return;
	
	timepassed = (getTime() - level.starttime) / 1000;
	timepassed = timepassed / 60.0;
	
	if(timepassed < level.timelimit)
		return;
	
	if(level.mapended)
		return;
	level.mapended = true;

	//iprintln(&"MPSCRIPT_TIME_LIMIT_REACHED");
	if( level.hunters > 0 )
		level thread endMap( "hunters" );
	else
		level thread endMap( "zombies" );
}

checkScoreLimit()
{
	if(level.scorelimit <= 0)
		return;
	
	if(getTeamScore("allies") < level.scorelimit && getTeamScore("axis") < level.scorelimit)
		return;

	if(level.mapended)
		return;
	level.mapended = true;

//	iprintln(&"MPSCRIPT_SCORE_LIMIT_REACHED");
//	level thread endMap();
}

updateGametypeCvars()
{
	for(;;)
	{
		timelimit = getCvarFloat("scr_zom_timelimit");
		if(level.timelimit != timelimit)
		{
			if(timelimit > 1440)
			{
				timelimit = 1440;
				setCvar("scr_zom_timelimit", "1440");
			}
			
			level.timelimit = timelimit;
			setCvar("ui_zom_timelimit", level.timelimit);
			level.starttime = getTime();
			
			if(level.timelimit > 0)
			{
				if(!isDefined(level.clock))
				{
					level.clock = newHudElem();
					level.clock.x = 320;
					level.clock.y = 440;
					level.clock.alignX = "center";
					level.clock.alignY = "middle";
					level.clock.font = "bigfixed";
				}
				level.clock setTimer(level.timelimit * 60);
			}
			else
			{
				if(isDefined(level.clock))
					level.clock destroy();
			}
			
			checkTimeLimit();
		}

		scorelimit = getCvarInt("scr_zom_scorelimit");
		if(level.scorelimit != scorelimit)
		{
			level.scorelimit = scorelimit;
			setCvar("ui_zom_scorelimit", level.scorelimit);
		}
		//checkScoreLimit();

		drawfriend = getCvarFloat("scr_drawfriend");
		if(level.drawfriend != drawfriend)
		{
			level.drawfriend = drawfriend;
			
			if(level.drawfriend)
			{
				// for all living players, show the appropriate headicon
				players = getentarray("player", "classname");
				for(i = 0; i < players.size; i++)
				{
					player = players[i];
					
					if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
					{
						if(player.pers["team"] == "allies")
						{
							player.headicon = game["headicon_allies"];
							player.headiconteam = "allies";
						}
						else
						{
							player.headicon = game["headicon_axis"];
							player.headiconteam = "axis";
						}
					}
				}
			}
			else
			{
				players = getentarray("player", "classname");
				for(i = 0; i < players.size; i++)
				{
					player = players[i];
					
					if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
						player.headicon = "";
				}
			}
		}

		killcam = getCvarInt("scr_kill_camera");
		if (level.killcam != killcam)
		{
			level.killcam = getCvarInt("scr_kill_camera");
			if(level.killcam >= 1)
				setarchive(true);
			else
				setarchive(false);
		}
		
		teambalance = getCvarInt("scr_teambalance");
		if (level.teambalance != teambalance)
		{
			level.teambalance = getCvarInt("scr_teambalance");
			if (level.teambalance > 0)
			{
				level thread maps\mp\gametypes\_zom_teams::TeamBalance_Check();
				level.teambalancetimer = 0;
			}
		}
		
		
		
		if (level.teambalance > 0)
		{
			level.teambalancetimer++;
			if (level.teambalancetimer >= 60)
			{
				level thread maps\mp\gametypes\_zom_teams::TeamBalance_Check();
				level.teambalancetimer = 0;
			}
		}
		
		wait 1;
	}
}

printJoinedTeam(team)
{
	if(team == "allies")
		iprintln( self.name + "^7 joined ^2The Hunters^7.");
	else if(team == "axis")
		iprintln( self.name + "^7 joined ^1The Zombies^7.");
}

dropHealth()
{
	if(isDefined(level.healthqueue[level.healthqueuecurrent]))
		level.healthqueue[level.healthqueuecurrent] delete();
	
	level.healthqueue[level.healthqueuecurrent] = spawn("item_health", self.origin + (0, 0, 1));
	level.healthqueue[level.healthqueuecurrent].angles = (0, randomint(360), 0);

	level.healthqueuecurrent++;
	
	if(level.healthqueuecurrent >= 16)
		level.healthqueuecurrent = 0;
}

addBotClients()
{
	wait 5;
	
	for(;;)
	{
		if(getCvarInt("scr_numbots") > 0)
			break;
		wait 1;
	}
	
	iNumBots = getCvarInt("scr_numbots");
	for(i = 0; i < iNumBots; i++)
	{
		ent[i] = addtestclient();
		wait 0.5;

		if(isPlayer(ent[i]))
		{
			if(i & 1)
			{
				ent[i] notify("menuresponse", game["menu_team"], "axis");
				wait 0.5;
				ent[i] notify("menuresponse", game["menu_weapon_axis"], "kar98k_mp");
			}
			else
			{
				ent[i] notify("menuresponse", game["menu_team"], "allies");
				wait 0.5;
				ent[i] notify("menuresponse", game["menu_weapon_allies"], "springfield_mp");
			}
		}
	}
}


