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

Init()
{

	min = 0;
	max = 0;
	level.gametype = getcvar("g_gametype");
	level.logging = getcvarint("logfile");

	// Map voting	
	level.mapvote = 0;
	if ( level.zom["map_vote"] )
		level.mapvote = 1;

	if(!level.mapvote)
		return;

	level.mapvotetime = level.zom["map_vote_time"];
	if (level.mapvotetime > 60)
		level.mapvotetime = 60;

	level.mapvotereplay	= 0;
	if ( level.zom["map_vote_replay"] )
		level.mapvotereplay	= 1;
	
	if(!isdefined(game["gamestarted"]))
	{
		// Setup strings
		game["MapVote"]	= &"Press ^2FIRE^7 to vote                           Votes";
		game["TimeLeft"] = &"Time Left: ";
		game["MapVoteHeader"] = &"Next Map Vote";

		// Precache stuff used by map voting
		precacheShader("white");
		precacheString(game["MapVote"]);
		precacheString(game["TimeLeft"]);
		precacheString(game["MapVoteHeader"]);
	}
}

Initialize()
{
	if(!level.mapvote)
		return;

	level.mapvotehudoffset = 30;

	// Small wait
	wait .5;

	// Cleanup some stuff to free up some resources
	//CleanUp();

	// Create HUD
	CreateHud();

	// Start mapvote thread	
	thread RunMapVote();

	// Wait for voting to finish
	level waittill("VotingComplete");

	// Delete HUD
	DeleteHud();
}

CleanUp()
{
	// Kill AWE threads
	level notify("awe_killthreads");
	// Wait for threads to die
	wait .05;
	// Delete some HUD elements
	if(isdefined(level.clock)) level.clock destroy();
}

CreateHud()
{
	level.vote_hud_bgnd = newHudElem();
	level.vote_hud_bgnd.archived = false;
	level.vote_hud_bgnd.alpha = .7;
	level.vote_hud_bgnd.x = 205;
	level.vote_hud_bgnd.y = level.mapvotehudoffset + 17;
	level.vote_hud_bgnd.sort = 9000;
	level.vote_hud_bgnd.color = (0,0,0);
	level.vote_hud_bgnd setShader("white", 260, 140);
	
	level.vote_header = newHudElem();
	level.vote_header.archived = false;
	level.vote_header.alpha = .3;
	level.vote_header.x = 208;
	level.vote_header.y = level.mapvotehudoffset + 19;
	level.vote_header.sort = 9001;
	level.vote_header setShader("white", 254, 21);
	
	level.vote_headerText = newHudElem();
	level.vote_headerText.archived = false;
	level.vote_headerText.x = 210;
	level.vote_headerText.y = level.mapvotehudoffset + 21;
	level.vote_headerText.sort = 9998;
	level.vote_headerText.label = game["MapVoteHeader"];
	level.vote_headerText.fontscale = 1.3;

	level.vote_leftline = newHudElem();
	level.vote_leftline.archived = false;
	level.vote_leftline.alpha = .3;
	level.vote_leftline.x = 207;
	level.vote_leftline.y = level.mapvotehudoffset + 19;
	level.vote_leftline.sort = 9001;
	level.vote_leftline setShader("white", 1, 135);
	
	level.vote_rightline = newHudElem();
	level.vote_rightline.archived = false;
	level.vote_rightline.alpha = .3;
	level.vote_rightline.x = 462;
	level.vote_rightline.y = level.mapvotehudoffset + 19;
	level.vote_rightline.sort = 9001;
	level.vote_rightline setShader("white", 1, 135);
	
	level.vote_bottomline = newHudElem();
	level.vote_bottomline.archived = false;
	level.vote_bottomline.alpha = .3;
	level.vote_bottomline.x = 207;
	level.vote_bottomline.y = level.mapvotehudoffset + 154;
	level.vote_bottomline.sort = 9001;
	level.vote_bottomline setShader("white", 256, 1);

	level.vote_hud_timeleft = newHudElem();
	level.vote_hud_timeleft.archived = false;
	level.vote_hud_timeleft.x = 400;
	level.vote_hud_timeleft.y = level.mapvotehudoffset + 26;
	level.vote_hud_timeleft.sort = 9998;
	level.vote_hud_timeleft.fontscale = .8;
	level.vote_hud_timeleft.label = game["TimeLeft"];
	level.vote_hud_timeleft setValue( level.mapvotetime );	
	
	level.vote_hud_instructions = newHudElem();
	level.vote_hud_instructions.archived = false;
	level.vote_hud_instructions.x = 340;
	level.vote_hud_instructions.y = level.mapvotehudoffset + 56;
	level.vote_hud_instructions.sort = 9998;
	level.vote_hud_instructions.fontscale = 1;
	level.vote_hud_instructions.label = game["MapVote"];
	level.vote_hud_instructions.alignX = "center";
	level.vote_hud_instructions.alignY = "middle";
	
	level.vote_map1 = newHudElem();
	level.vote_map1.archived = false;
	level.vote_map1.x = 434;
	level.vote_map1.y = level.mapvotehudoffset + 69;
	level.vote_map1.sort = 9998;
		
	level.vote_map2 = newHudElem();
	level.vote_map2.archived = false;
	level.vote_map2.x = 434;
	level.vote_map2.y = level.mapvotehudoffset + 85;
	level.vote_map2.sort = 9998;
		
	level.vote_map3 = newHudElem();
	level.vote_map3.archived = false;
	level.vote_map3.x = 434;
	level.vote_map3.y = level.mapvotehudoffset + 101;
	level.vote_map3.sort = 9998;	

	level.vote_map4 = newHudElem();
	level.vote_map4.archived = false;
	level.vote_map4.x = 434;
	level.vote_map4.y = level.mapvotehudoffset + 117;
	level.vote_map4.sort = 9998;	

	level.vote_map5 = newHudElem();
	level.vote_map5.archived = false;
	level.vote_map5.x = 434;
	level.vote_map5.y = level.mapvotehudoffset + 133;
	level.vote_map5.sort = 9998;	
}

RunMapVote()
{
	maps = undefined;
	x = undefined;

	currentmap = getcvar("mapname");
	currentgt = level.gametype;
 
	x = GetRandomMapRotation();
	if(isdefined(x))
	{
		if(isdefined(level.maps_in_vote))
			maps = level.maps_in_vote;
	}

	// Any maps?
	if(!isdefined(maps))
	{
		wait 0.05;
		level notify("VotingComplete");
		return;
	}

	// Fill all alternatives with the current map in case there is not enough unique maps
	for(j=0;j<5;j++)
	{
		level.mapcandidate[j]["map"] = currentmap;
		level.mapcandidate[j]["mapname"] = "Replay this map";
		level.mapcandidate[j]["gametype"] = currentgt;
		level.mapcandidate[j]["votes"] = 0;
	}
	
	//get candidates
	i = 0;
	for(j=0;j<5;j++)
	{
		// Skip current map and gametype combination
		if(maps[i]["map"] == currentmap && maps[i]["gametype"] == level.gametype)
			i++;

		// Any maps left?
		if(!isdefined(maps[i]))
			break;

		level.mapcandidate[j]["map"] = maps[i]["map"];
		level.mapcandidate[j]["mapname"] = getMapName(maps[i]["map"]);
		//level.mapcandidate[j]["gametype"] = maps[i]["gametype"];
		level.mapcandidate[j]["gametype"] = "zom";
		level.mapcandidate[j]["votes"] = 0;

		i++;

		// Any maps left?
		if(!isdefined(maps[i]))
			break;

		// Keep current map as last alternative?
		if(level.mapvotereplay && j>2)
			break;
	}
	
	thread DisplayMapChoices();
	
	game["menu_team"] = "";

	//start a voting thread per player
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
		players[i] thread PlayerVote();
	
	thread VoteLogic();
	
	//Take a breath for players to restart with the map
	wait 0.1;	
	level.mapended = true;	
}

DeleteHud()
{
	level.vote_headerText destroy();
	level.vote_hud_timeleft destroy();	
	level.vote_hud_instructions destroy();
	level.vote_map1 destroy();
	level.vote_map2 destroy();
	level.vote_map3 destroy();
	level.vote_map4 destroy();
	level.vote_map5 destroy();
	level.vote_hud_bgnd destroy();
	level.vote_header destroy();
	level.vote_leftline destroy();
	level.vote_rightline destroy();
	level.vote_bottomline destroy();

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
		if(isdefined(players[i].vote_indicator))
			players[i].vote_indicator destroy();
}

//Displays the map candidates
DisplayMapChoices()
{
	level endon("VotingDone");
	for(;;)
	{
		iprintlnbold(level.mapcandidate[0]["mapname"]);
		iprintlnbold(level.mapcandidate[1]["mapname"]);
		iprintlnbold(level.mapcandidate[2]["mapname"]);
		iprintlnbold(level.mapcandidate[3]["mapname"]);
		iprintlnbold(level.mapcandidate[4]["mapname"]);
		wait 7.8;
	}	
}
/*
DisplayMapChoices()
{
	level endon("VotingDone");
	for(;;)
	{
		iprintlnbold(level.mapcandidate[0]["mapname"] + " (" + level.mapcandidate[0]["gametype"] +")");
		iprintlnbold(level.mapcandidate[1]["mapname"] + " (" + level.mapcandidate[1]["gametype"] +")");
		iprintlnbold(level.mapcandidate[2]["mapname"] + " (" + level.mapcandidate[2]["gametype"] +")");
		iprintlnbold(level.mapcandidate[3]["mapname"] + " (" + level.mapcandidate[3]["gametype"] +")");
		iprintlnbold(level.mapcandidate[4]["mapname"] + " (" + level.mapcandidate[4]["gametype"] +")");
		wait 7.8;
	}	
}
*/
//Changes the players vote as he hits the attack button and updates HUD
PlayerVote()
{
	level endon("VotingDone");
	self endon("disconnect");

	novote = false;
	
	// No voting for spectators
	//if(self.pers["team"] == "spectator") //Prueba unicamente voto espectador
	//	novote = true;

	// Spawn player as spectator
	self maps\mp\gametypes\zom::spawnSpectator();
	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	resettimeout();
	
	//remove the scoreboard
	self setClientCvar("g_scriptMainMenu", "");
	self closeMenu();

	self allowSpectateTeam("allies", false);
	self allowSpectateTeam("axis", false);
	self allowSpectateTeam("freelook", false);
	self allowSpectateTeam("none", true);

	if(novote)
		return;

//	self.votechoice = 0;

	colors[0] = (0  ,  0,  1);
	colors[1] = (0  ,0.5,  1);
	colors[2] = (0  ,  1,  1);
	colors[3] = (0  ,  1,0.5);
	colors[4] = (0  ,  1,  0);
	
	self.vote_indicator = newClientHudElem( self );
	self.vote_indicator.alignY = "middle";
	self.vote_indicator.x = 208;
	self.vote_indicator.y = level.mapvotehudoffset + 75;
	self.vote_indicator.archived = false;
	self.vote_indicator.sort = 9998;
	self.vote_indicator.alpha = 0;
	self.vote_indicator.color = colors[0];
	self.vote_indicator setShader("white", 254, 17);
	
	hasVoted = false;

	for (;;)
	{
		wait .01;
								
		if(self attackButtonPressed() == true)
		{
			// -- Added by Number7 --
			if(!hasVoted)
			{
				self.vote_indicator.alpha = .3;
				self.votechoice = 0;
				hasVoted = true;
			}
			else
				self.votechoice++;

			if (self.votechoice == 5)
				self.votechoice = 0;

//			self iprintln("You have voted for ^2" + level.mapcandidate[self.votechoice]["mapname"] + " (" + level.mapcandidate[self.votechoice]["gametype"]+")");
			self iprintln("You have voted for ^2" + level.mapcandidate[self.votechoice]["mapname"]);
			self.vote_indicator.y = level.mapvotehudoffset + 77 + self.votechoice * 16;			
			self.vote_indicator.color = colors[self.votechoice];

//			self playLocalSound("hq_score");
		}					
		while(self attackButtonPressed() == true)
			wait .05;

		self.sessionstate = "spectator";
		self.spectatorclient = -1;
	}
}

//Determines winning map and sets rotation
VoteLogic()
{
	//Vote Timer
	for (;level.mapvotetime>=0;level.mapvotetime--)
	{
		for(j=0;j<10;j++)
		{
			// Count votes
			for(i=0;i<5;i++)	level.mapcandidate[i]["votes"] = 0;
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
				if(isdefined(players[i].votechoice))
					level.mapcandidate[players[i].votechoice]["votes"]++;

			// Update HUD
			level.vote_map1 setValue( level.mapcandidate[0]["votes"] );
			level.vote_map2 setValue( level.mapcandidate[1]["votes"] );
			level.vote_map3 setValue( level.mapcandidate[2]["votes"] );
			level.vote_map4 setValue( level.mapcandidate[3]["votes"] );
			level.vote_map5 setValue( level.mapcandidate[4]["votes"] );
			wait .1;
		}
		level.vote_hud_timeleft setValue( level.mapvotetime );
	}	

	wait 0.2;
	
	newmapnum = 0;
	topvotes = 0;
	for(i=0;i<5;i++)
	{
		if (level.mapcandidate[i]["votes"] > topvotes)
		{
			newmapnum = i;
			topvotes = level.mapcandidate[i]["votes"];
		}
	}

	SetMapWinner(newmapnum);
}

//change the map rotation to represent the current selection
SetMapWinner(winner)
{
	map	= level.mapcandidate[winner]["map"];
	mapname	= level.mapcandidate[winner]["mapname"];
	gametype = level.mapcandidate[winner]["gametype"];

	setcvar("sv_maprotationcurrent", " gametype " + gametype + " map " + map);

	wait 0.1;

	// Stop threads
	level notify( "VotingDone" );

	// Wait for threads to die
	wait 0.05;

	// Announce winner
	iprintlnbold(" ");
	iprintlnbold(" ");
	iprintlnbold(" ");
	iprintlnbold("The winner is");
	iprintlnbold("^2" + mapname);
//	iprintlnbold("^2" + GetGametypeName(gametype));

	// Fade HUD elements
	level.vote_headerText fadeOverTime (1);
	level.vote_hud_timeleft fadeOverTime (1);	
	level.vote_hud_instructions fadeOverTime (1);
	level.vote_map1 fadeOverTime (1);
	level.vote_map2 fadeOverTime (1);
	level.vote_map3 fadeOverTime (1);
	level.vote_map4 fadeOverTime (1);
	level.vote_map5 fadeOverTime (1);
	level.vote_hud_bgnd fadeOverTime (1);
	level.vote_header fadeOverTime (1);
	level.vote_leftline fadeOverTime (1);
	level.vote_rightline fadeOverTime (1);
	level.vote_bottomline fadeOverTime (1);

	level.vote_headerText.alpha = 0;
	level.vote_hud_timeleft.alpha = 0;	
	level.vote_hud_instructions.alpha = 0;
	level.vote_map1.alpha = 0;
	level.vote_map2.alpha = 0;
	level.vote_map3.alpha = 0;
	level.vote_map4.alpha = 0;
	level.vote_map5.alpha = 0;
	level.vote_hud_bgnd.alpha = 0;
	level.vote_header.alpha = 0;
	level.vote_leftline.alpha = 0;
	level.vote_rightline.alpha = 0;
	level.vote_bottomline.alpha = 0;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(players[i].vote_indicator))
		{
			players[i].vote_indicator fadeOverTime (1);
			players[i].vote_indicator.alpha = 0;
		}
	}

	// Show winning map for a few seconds
	wait 4;
	level notify( "VotingComplete" );
}

GetRandomMapRotation(random, current, number)
{
	maprot = strip(getcvar("sv_maprotation"));

	if(!isdefined(number))
		number = 0;

	// No map rotation setup!
	if(maprot == "")
		return undefined;
	
	// Explode entries into an array
	j=0;
	temparr2[j] = "";	
	for(i=0;i<maprot.size;i++)
	{
		if(maprot[i]==" ")
		{
			j++;
			temparr2[j] = "";
		}
		else
			temparr2[j] += maprot[i];
	}

	// Remove empty elements (double spaces)
	temparr = [];
	for(i=0;i<temparr2.size;i++)
	{
		element = strip(temparr2[i]);
		if(element != "")
			temparr[temparr.size] = element;
	}

	level.maps_in_vote = [];
	lastgt = level.gametype;
	for(i=0;i<temparr.size;)
	{
		switch(temparr[i])
		{
			case "gametype":
				if(isdefined(temparr[i+1]))
					lastgt = temparr[i+1];
				i += 2;
				break;

			case "map":
				if(isdefined(temparr[i+1]))
				{
					level.maps_in_vote[level.maps_in_vote.size]["gametype"]	= lastgt;
					level.maps_in_vote[level.maps_in_vote.size-1]["map"] = temparr[i+1];
				}

				i += 2;
				break;

			// If code get here, then the maprotation is corrupt so we have to fix it
			default:
				iprintlnbold("Warning: Error detected in map rotation");
	
				if(isGametype(temparr[i]))
					lastgt = temparr[i];
				else
				{
					level.maps_in_vote[level.maps_in_vote.size]["gametype"]	= lastgt;
					level.maps_in_vote[level.maps_in_vote.size-1]["map"] = temparr[i];
				}
					

				i += 1;
				break;
		}
		if(number && level.maps_in_vote.size >= number)
			break;
	}

	// Shuffle the array 20 times
	for(k = 0; k < 20; k++)
	{
		for(i = 0; i < level.maps_in_vote.size; i++)
		{
			j = randomInt(level.maps_in_vote.size);
			element = level.maps_in_vote[i];
			level.maps_in_vote[i] = level.maps_in_vote[j];
			level.maps_in_vote[j] = element;
		}
	}

	return level.maps_in_vote;
}

// Strip blanks at start and end of string
strip(s)
{
	if(s=="")
		return "";

	s2="";
	s3="";

	i=0;
	while(i<s.size && s[i]==" ")
		i++;

	// String is just blanks?
	if(i==s.size)
		return "";
	
	for(;i<s.size;i++)
	{
		s2 += s[i];
	}

	i=s2.size-1;
	while(s2[i]==" " && i>0)
		i--;

	for(j=0;j<=i;j++)
	{
		s3 += s2[j];
	}
		
	return s3;
}

isGametype(gt)
{
	switch(gt)
	{
		case "dm":
		case "tdm":
		case "sd":
		case "hq":
		case "re":
		case "bel":
		case "zom":		
			return true;

		default:
			return false;
	}
}
getMapName(map)
{
	switch(map)
	{
		case "mp_bocage":
			mapname = "Bocage";
			break;
		
		case "mp_brecourt":
			mapname = "Brecourt";
			break;

		case "mp_carentan":
			mapname = "Carentan";
			break;

		case "mp_chateau":
			mapname = "Chateau";
			break;
		
		case "mp_dawnville":
			mapname = "Dawnville";
			break;
		
		case "mp_depot":
			mapname = "Depot";
			break;

		case "mp_harbor":
			mapname = "Harbor";
			break;
		
		case "mp_hurtgen":
			mapname = "Hurtgen";
			break;

		case "mp_neuville":
			mapname = "Neuville";
			break;
		
		case "mp_pavlov":
			mapname = "Pavlov";
			break;

		case "mp_powcamp":
			mapname = "P.O.W Camp";
			break;
		
		case "mp_railyard":
			mapname = "Railyard";
			break;

		case "mp_rocket":
			mapname = "Rocket";
			break;
		
		case "mp_ship":
			mapname = "Ship";
			break;

		case "mp_stalingrad":
			mapname = "Stalingrad";
			break;
		
		case "mp_tigertown":
			mapname = "Tigertown";
			break;

		case "DeGaulle_beta2":
			mapname = "DeGaulle Beta2";
			break;

		case "mp_bellicourt":
			mapname = "Bellicourt";
			break;

		case "mp_offensive":
			mapname = "Offensive";
			break;

		case "mp_rzgarena":
			mapname = "Rezorg Arena";
			break;

		case "mp_venicedock":
			mapname = "Venicedock";
			break;

		case "nuenen":
			mapname = "Nuenen";
			break;

		case "Outlaw_Bridge":
			mapname = "Outlaw Bridge";
			break;

		case "Outlaws_SFrance":
			mapname = "Outlaws France";
			break;

		case "the_hunt":
			mapname = "The Hunt";
			break;

		case "mp_streetwar":
			mapname = "Streetwar";
			break;

		case "mp_subharbor_night":
			mapname = "Subharbor Night";
			break;

		case "mp_subharbor_day":
			mapname = "Subharbor Day";
			break;

		case "mp_landsitz":
			mapname = "Landsitz";
			break;

		case "Hafen_beta":
			mapname = "Hafen";
			break;

		case "mp_hollenberg":
			mapname = "Hollenberg";
			break;

		case "viaduct":
			mapname = "Viaduct";
			break;

		case "mp_oase":
			mapname = "Oase";
			break;

		case "mp_v2_ver3":
			mapname = "V2 Rocket";
			break;

		case "arcville":
			mapname = "Arcville";
			break;

		case "arkov4":
			mapname = "Arkov";
			break;

		case "mp_saint-lo":
			mapname = "Saint-Lo";
			break;

		case "second_coming":
			mapname = "The Second Coming";
			break;

		case "mp_westwall":
			mapname = "Westwall";
			break;

		case "mp_maaloy":
			mapname = "Maaloy";
			break;

		case "dufresne":
			mapname = "Dufresne";
			break;

		case "dufresne_winter":
			mapname = "Dufresne Winter";
			break;

		case "gorges_du_wet":
			mapname = "Les Gorges du Wet";
			break;

		case "d-day+7":
			mapname = "D-Day";
			break;

		case "mp_wolfsquare_final":
			mapname = "Wolfsquare Public";
			break;

		case "the_bridge":
			mapname = "The Bridge";
			break;

		case "mp_amberville":
		case "mc_amberville":
			mapname = "Amberville";
			break;

		case "mp_stanjel":
		case "mc_stanjel":
			mapname = "Stanjel";
			break;

		case "mp_bazolles":
		case "mc_bazolles":
			mapname = "Bazolles";
			break;

		case "townville_beta":
		case "mp_townville":
		case "mc_townville":
			mapname = "Townville";
			break;

		case "german_town":
		case "mp_german_town":
		case "mc_german_town":
			mapname = "German Town";
			break;
		
		case "mp_drumfergus2":
			mapname = "Drum Fergus 2";
			break;

		case "bx_pipe":
			mapname = "BraXi's Pipe";
			break;

		case "bx_bunkers":
			mapname = "BraXi's Bunkers";
			break;

		case "q3tourney2":
			mapname = "BraXi's Q3 Tourney 2";
			break;

		case "q3dm1":
			mapname = "BraXi's Q3 DM 1";
			break;

		case "bx_nearsky":
			mapname = "BraXi's Near Sky";
			break;

		case "bx_freefall":
			mapname = "BraXi's Free Fall";
			break;

		case "bx_village":
			mapname = "BraXi's Village";
			break;

		case "bx_zombox":
			mapname = "BraXi's Zombie Box";
			break;

		case "dd_forest":
			mapname = "DUVAL's Forest";
			break;

		case "dd_vz_trash":
		case "dd_vz_trash_final":
			mapname = "DUVAL's VZ Trash";
			break;

		case "dd_boxes":
			mapname = "DUVAL's Boxes";
			break;

		case "FS_castle":
		case "FS_castle_v2":
			mapname = "F1s1ck's Castle";
			break;

		case "FS_zomship":
			mapname = "F1s1ck's Zombie Ship";
			break;

		case "fun_simpsons":
			mapname = "Simpsons";
			break;


		case "zombieTAG":
		case "zombieTAGv2":
			mapname = "Zombie TAG";
			break;

		case "the_dungeon":
		case "the_dungeon2":
			mapname = "The Dungeon";
			break;

		case "zom_airplane":
			mapname = "Zombie Airplane";
			break;

		case "o'crap":
			mapname = "O'crap!";
			break;

		case "mp_Biedronka":
			mapname = "Biedronka";
			break;

		case "core":
			mapname = "Core";
			break;
			
		case "amusement_park":
			mapname = "Amusement Park";
			break;

		case "neinville":
			mapname = "Neinville";
			break;

		case "16fighter":
			mapname = "Kruku's 16 Fighter";
			break;

		case "kruku_police":
			mapname = "Kruku's Police";
			break;

		case "dm701":
			mapname = "DM 701";
			break;

		case "bounce":
			mapname = "KiLL3R's Bounce";
			break;

		case "cube":
			mapname = "KiLL3R's Cube";
			break;

		case "mp_harbor2":
			mapname = "Harbor .2.";
			break;

		case "mp_sewer":
			mapname = "Sewer";
			break;

		case "mp_unmapped":
			mapname = "Unmapped";
			break;

		case "church":
		case "church_v2":
			mapname = "Church";
			break;

		default:
			mapname = map;
			break;
	}

	return mapname;
}

/*
spawnSpectator(origin, angles)
{
	self notify("spawned");
	self notify("end_respawn");

	resettimeout();

	// Stop shellshock and rumble
	self stopShellshock();
//	self stoprumble("damage_heavy");

	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.friendlydamage = undefined;

	if(self.pers["team"] == "spectator")
		self.statusicon = "";

	maps\mp\gametypes\_zom_teams::setSpectatePermissions();
	
	if(isDefined(origin) && isDefined(angles))
		self spawn(origin, angles);
	else
	{
       	spawnpointname = "mp_global_intermission";
		spawnpoints = getentarray(spawnpointname, "classname");
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
	
		if(isDefined(spawnpoint))
			self spawn(spawnpoint.origin, spawnpoint.angles);
		else
			maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
	}
}
*/
getGametypeName(gt)
{
	switch(gt)
	{
		case "bel":
			gtname = "Behind Enemy Lines";
			break;

		case "dm":
			gtname = "Deathmatch";
			break;
		
		case "tdm":
			gtname = "Team Deathmatch";
			break;

		case "sd":
			gtname = "Search & Destroy";
			break;

		case "hq":
			gtname = "Headquarters";
			break;
	
		case "re":
			gtname = "Retrieval";
			break;
			
		case "zom":
			gtname = "BraXi's Zombie Mod";
			break;					

		default:
			gtname = gt;
			break;
	}

	return gtname;
}