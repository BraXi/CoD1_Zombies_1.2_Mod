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

modeltype()
{
	switch(game["allies"])
	{
	case "american":
		if(isdefined(game["american_soldiertype"]))
		{
			switch(game["american_soldiertype"])
			{
			case "airborne":
				if(isdefined(game["american_soldiervariation"]))
				{
					switch(game["american_soldiervariation"])
					{
					case "normal":
						mptype\american_airborne::precache();
						game["allies_model"] = mptype\american_airborne::main;	
						break;
					
					case "winter":
						mptype\american_airborne_winter::precache();
						game["allies_model"] = mptype\american_airborne_winter::main;
						break;
				
					default:
						println("Unknown american_soldiervariation specified, using default");
						mptype\american_airborne::precache();
						game["allies_model"] = mptype\american_airborne::main;
						break;
					}
				}
				else
				{
					mptype\american_airborne::precache();
					game["allies_model"] = mptype\american_airborne::main;
				}
				break;
				
			default:
				println("Unknown american_soldiertype specified, using default");
				mptype\american_airborne::precache();
				game["allies_model"] = mptype\american_airborne::main;
				break;
			}
		}
		else
		{
			mptype\american_airborne::precache();
			game["allies_model"] = mptype\american_airborne::main;
		}
		break;

	case "british":
		if(isdefined(game["british_soldiertype"]))
		{
			switch(game["british_soldiertype"])
			{
			case "airborne":
				if(isdefined(game["british_soldiervariation"]))
				{
					switch(game["british_soldiervariation"])
					{
					case "normal":
						mptype\british_airborne::precache();
						game["allies_model"] = mptype\british_airborne::main;	
						break;
					
					default:
						println("Unknown british_soldiervariation specified, using default");
						mptype\british_airborne::precache();
						game["allies_model"] = mptype\british_airborne::main;
						break;
					}
				}
				else
				{
					mptype\british_airborne::precache();
					game["allies_model"] = mptype\british_airborne::main;
				}
				break;

			case "commando":
				if(isdefined(game["british_soldiervariation"]))
				{
					switch(game["british_soldiervariation"])
					{
					case "normal":
						mptype\british_commando::precache();
						game["allies_model"] = mptype\british_commando::main;	
						break;
					
					case "winter":
						mptype\british_commando_winter::precache();
						game["allies_model"] = mptype\british_commando_winter::main;
						break;
				
					default:
						println("Unknown british_soldiervariation specified, using default");
						mptype\british_commando::precache();
						game["allies_model"] = mptype\british_commando::main;
						break;
					}
				}
				else
				{
					mptype\british_commando::precache();
					game["allies_model"] = mptype\british_commando::main;
				}
				break;
				
			default:
				println("Unknown british_soldiertype specified, using default");
				mptype\british_commando::precache();
				game["allies_model"] = mptype\british_commando::main;
				break;
			}
		}
		else
		{
			mptype\british_commando::precache();
			game["allies_model"] = mptype\british_commando::main;
		}
		break;

	case "russian":
		if(isdefined(game["russian_soldiertype"]))
		{
			switch(game["russian_soldiertype"])
			{
			case "conscript":
				if(isdefined(game["russian_soldiervariation"]))
				{
					switch(game["russian_soldiervariation"])
					{
					case "normal":
						mptype\russian_conscript::precache();
						game["allies_model"] = mptype\russian_conscript::main;	
						break;
					
					case "winter":
						mptype\russian_conscript_winter::precache();
						game["allies_model"] = mptype\russian_conscript_winter::main;
						break;
				
					default:
						println("Unknown russian_soldiervariation specified, using default");
						mptype\russian_conscript::precache();
						game["allies_model"] = mptype\russian_conscript::main;
						break;
					}
				}
				else
				{
					mptype\russian_conscript::precache();
					game["allies_model"] = mptype\russian_conscript::main;
				}
				break;
				
			case "veteran":
				if(isdefined(game["russian_soldiervariation"]))
				{
					switch(game["russian_soldiervariation"])
					{
					case "normal":
						mptype\russian_veteran::precache();
						game["allies_model"] = mptype\russian_veteran::main;	
						break;
					
					case "winter":
						mptype\russian_veteran_winter::precache();
						game["allies_model"] = mptype\russian_veteran_winter::main;	
						break;

					default:
						println("Unknown russian_soldiervariation specified, using default");
						mptype\russian_veteran::precache();
						game["allies_model"] = mptype\russian_veteran::main;
						break;
					}
				}
				else
				{
					mptype\russian_veteran::precache();
					game["allies_model"] = mptype\russian_veteran::main;
				}
				break;

			default:
				println("Unknown russian_soldiertype specified, using default");
				mptype\russian_conscript::precache();
				game["allies_model"] = mptype\russian_conscript::main;
				break;
			}
		}
		else
		{
			mptype\russian_conscript::precache();
			game["allies_model"] = mptype\russian_conscript::main;
		}
		break;
	}

	mptype\german_wehrmacht::precache();
	game["axis_model"] = mptype\german_wehrmacht::main;	
}

precache()
{
	precacheHeadIcon("gfx/hud/headicon@quickmessage");	//TEMP
	precacheString(&"PATCH_1_3_TEAMBALANCE_NOTIFICATION_AMERICAN");
	precacheString(&"PATCH_1_3_TEAMBALANCE_NOTIFICATION_BRITISH");
	precacheString(&"PATCH_1_3_TEAMBALANCE_NOTIFICATION_RUSSIAN");
	precacheString(&"PATCH_1_3_TEAMBALANCE_NOTIFICATION_GERMAN");
	precacheString(&"PATCH_1_3_CANTJOINTEAM_AMERICAN");
	precacheString(&"PATCH_1_3_CANTJOINTEAM_BRITISH");
	precacheString(&"PATCH_1_3_CANTJOINTEAM_RUSSIAN");
	precacheString(&"PATCH_1_3_CANTJOINTEAM_AXIS");
	precacheString(&"PATCH_1_3_CANTJOINTEAM_ALLIED");
	precacheString(&"PATCH_1_3_CANTJOINTEAM_ALLIED2");
	precacheString(&"PATCH_1_3_CANTJOINTEAM_AXIS2");
	precacheString(&"PATCH_1_3_AMERICAN");
	precacheString(&"PATCH_1_3_BRITISH");
	precacheString(&"PATCH_1_3_RUSSIAN");
	

	precacheItem("fraggrenade_mp");
	precacheItem("colt_mp");
	precacheItem("m1carbine_mp");
	precacheItem("m1garand_mp");
	precacheItem("thompson_mp");
	precacheItem("bar_mp");
	precacheItem("springfield_mp");

	precacheItem("mk1britishfrag_mp");
	precacheItem("enfield_mp");
	precacheItem("sten_mp");
	precacheItem("bren_mp");

	precacheItem("rgd-33russianfrag_mp");
	precacheItem("luger_mp");
	precacheItem("mosin_nagant_mp");
	precacheItem("ppsh_mp");
	precacheItem("mosin_nagant_sniper_mp");

	precacheItem("stielhandgranate_mp");
	precacheItem("kar98k_mp");
	precacheItem("mp40_mp");
	precacheItem("mp44_mp");
	precacheItem("kar98k_sniper_mp");

	game["headicon_allies"] = "gfx/hud/headicon@hunter.dds";
	game["headicon_axis"] = "gfx/hud/headicon@zombie.dds";
	
	precacheHeadIcon(game["headicon_allies"]);
	precacheHeadIcon(game["headicon_axis"]);
}
	
scoreboard()
{
	setcvar("g_ScoresBanner_Allies", "gfx/hud/hud@mpflag_hunters.dds");
	setcvar("g_ScoresBanner_Axis", "gfx/hud/hud@mpflag_zombies.dds");
	switch(game["allies"])
	{
	case "american":
		setcvar("g_TeamName_Allies", "Hunters");
		setcvar("g_TeamColor_Allies", "0.0 1.0 0.0");
		break;
	
	case "british":
		setcvar("g_TeamName_Allies", "Hunters");
		setcvar("g_TeamColor_Allies", "0.0 1.0 0.0");
		break;
	
	case "russian":
		setcvar("g_TeamName_Allies", "Hunters");
		setcvar("g_TeamColor_Allies", "0.0 1.0 0.0");
		break;
	}

	switch(game["axis"])
	{
	case "german":
		setcvar("g_TeamName_Axis", "Zombies");
		setcvar("g_TeamColor_Axis", "1.0 0.0 0.0");
		break;
	}
}

initGlobalCvars()
{
	level.hostname = getCvar("sv_hostname");
	if(level.hostname == "")
		level.hostname = "CoDHost";
	setCvar("sv_hostname", level.hostname);
	setCvar("ui_hostname", level.hostname);
	makeCvarServerInfo("ui_hostname", "CoDHost");

	level.motd = getCvar("scr_motd");
	if(level.motd == "")
		level.motd = "";
	setCvar("scr_motd", level.motd);
	setCvar("ui_motd", level.motd);
	makeCvarServerInfo("ui_motd", "");

	level.allowvote = getCvar("g_allowvote");
	if(level.allowvote == "")
		level.allowvote = "1";
	setCvar("g_allowvote", level.allowvote);
	setCvar("ui_allowvote", level.allowvote);
	makeCvarServerInfo("ui_allowvote", "1");

	level.friendlyfire = getCvar("scr_friendlyfire");
	if(level.friendlyfire == "")
		level.friendlyfire = "0";
	setCvar("scr_friendlyfire", level.friendlyfire, true);
	setCvar("ui_friendlyfire", level.friendlyfire);
	makeCvarServerInfo("ui_friendlyfire", "0");
}

initWeaponCvars()
{
	level.allow_m1carbine = getCvar("scr_allow_m1carbine");
	if(level.allow_m1carbine == "")
		level.allow_m1carbine = "1";
	setCvar("scr_allow_m1carbine", level.allow_m1carbine);
	setCvar("ui_allow_m1carbine", level.allow_m1carbine);
	makeCvarServerInfo("ui_allow_m1carbine", "1");

	level.allow_m1garand = getCvar("scr_allow_m1garand");
	if(level.allow_m1garand == "")
		level.allow_m1garand = "1";
	setCvar("scr_allow_m1garand", level.allow_m1garand);
	setCvar("ui_allow_m1garand", level.allow_m1garand);
	makeCvarServerInfo("ui_allow_m1garand", "1");

	level.allow_thompson = getCvar("scr_allow_thompson");
	if(level.allow_thompson == "")
		level.allow_thompson = "1";
	setCvar("scr_allow_thompson", level.allow_thompson);
	setCvar("ui_allow_thompson", level.allow_thompson);
	makeCvarServerInfo("ui_allow_thompson", "1");

	level.allow_bar = getCvar("scr_allow_bar");
	if(level.allow_bar == "")
		level.allow_bar = "1";
	setCvar("scr_allow_bar", level.allow_bar);
	setCvar("ui_allow_bar", level.allow_bar);
	makeCvarServerInfo("ui_allow_bar", "1");

	level.allow_springfield = getCvar("scr_allow_springfield");
	if(level.allow_springfield == "")
		level.allow_springfield = "1";
	setCvar("scr_allow_springfield", level.allow_springfield);
	setCvar("ui_allow_springfield", level.allow_springfield);
	makeCvarServerInfo("ui_allow_springfield", "1");

	level.allow_enfield = getCvar("scr_allow_enfield");
	if(level.allow_enfield == "")
		level.allow_enfield = "1";
	setCvar("scr_allow_enfield", level.allow_enfield);
	setCvar("ui_allow_enfield", level.allow_enfield);
	makeCvarServerInfo("ui_allow_enfield", "1");

	level.allow_sten = getCvar("scr_allow_sten");
	if(level.allow_sten == "")
		level.allow_sten = "1";
	setCvar("scr_allow_sten", level.allow_sten);
	setCvar("ui_allow_sten", level.allow_sten);
	makeCvarServerInfo("ui_allow_sten", "1");

	level.allow_bren = getCvar("scr_allow_bren");
	if(level.allow_bren == "")
		level.allow_bren = "1";
	setCvar("scr_allow_bren", level.allow_bren);
	setCvar("ui_allow_bren", level.allow_bren);
	makeCvarServerInfo("ui_allow_bren", "1");

	level.allow_nagant = getCvar("scr_allow_nagant");
	if(level.allow_nagant == "")
		level.allow_nagant = "1";
	setCvar("scr_allow_nagant", level.allow_nagant);
	setCvar("ui_allow_nagant", level.allow_nagant);
	makeCvarServerInfo("ui_allow_nagant", "1");
	
	level.allow_ppsh = getCvar("scr_allow_ppsh");
	if(level.allow_ppsh == "")
		level.allow_ppsh = "1";
	setCvar("scr_allow_ppsh", level.allow_ppsh);
	setCvar("ui_allow_ppsh", level.allow_ppsh);
	makeCvarServerInfo("ui_allow_ppsh", "1");

	level.allow_nagantsniper = getCvar("scr_allow_nagantsniper");
	if(level.allow_nagantsniper == "")
		level.allow_nagantsniper = "1";
	setCvar("scr_allow_nagantsniper", level.allow_nagantsniper);
	setCvar("ui_allow_nagantsniper", level.allow_nagantsniper);
	makeCvarServerInfo("ui_allow_nagantsniper", "1");

	level.allow_kar98k = getCvar("scr_allow_kar98k");
	if(level.allow_kar98k == "")
		level.allow_kar98k = "1";
	setCvar("scr_allow_kar98k", level.allow_kar98k);
	setCvar("ui_allow_kar98k", level.allow_kar98k);
	makeCvarServerInfo("ui_allow_kar98k", "1");

	level.allow_mp40 = getCvar("scr_allow_mp40");
	if(level.allow_mp40 == "")
		level.allow_mp40 = "1";
	setCvar("scr_allow_mp40", level.allow_mp40);
	setCvar("ui_allow_mp40", level.allow_mp40);
	makeCvarServerInfo("ui_allow_mp40", "1");

	level.allow_mp44 = getCvar("scr_allow_mp44");
	if(level.allow_mp44 == "")
		level.allow_mp44 = "1";
	setCvar("scr_allow_mp44", level.allow_mp44);
	setCvar("ui_allow_mp44", level.allow_mp44);
	makeCvarServerInfo("ui_allow_mp44", "1");

	level.allow_kar98ksniper = getCvar("scr_allow_kar98ksniper");
	if(level.allow_kar98ksniper == "")
		level.allow_kar98ksniper = "1";
	setCvar("scr_allow_kar98ksniper", level.allow_kar98ksniper);
	setCvar("ui_allow_kar98ksniper", level.allow_kar98ksniper);
	makeCvarServerInfo("ui_allow_kar98ksniper", "1");

	level.allow_fg42 = getCvar("scr_allow_fg42");
	if(level.allow_fg42 == "")
		level.allow_fg42 = "0";
	setCvar("scr_allow_fg42", level.allow_fg42);
	setCvar("ui_allow_fg42", level.allow_fg42);
	makeCvarServerInfo("ui_allow_fg42", "0");

	level.allow_panzerfaust = getCvar("scr_allow_panzerfaust");
	if(level.allow_panzerfaust == "")
		level.allow_panzerfaust = "1";
	setCvar("scr_allow_panzerfaust", level.allow_panzerfaust);
	setCvar("ui_allow_panzerfaust", level.allow_panzerfaust);
	makeCvarServerInfo("ui_allow_panzerfaust", "1");
}

updateGlobalCvars()
{
	for(;;)
	{
		sv_hostname = getCvar("sv_hostname");
		if(level.hostname != sv_hostname)
		{
			level.hostname = sv_hostname;
			setCvar("ui_hostname", level.hostname);
		}

		scr_motd = getCvar("scr_motd");
		if(level.motd != scr_motd)
		{
			level.motd = scr_motd;
			setCvar("ui_motd", level.motd);
		}

		g_allowvote = getCvar("g_allowvote");
		if(level.allowvote != g_allowvote)
		{
			level.allowvote = g_allowvote;
			setCvar("ui_allowvote", level.allowvote);
		}
		
		scr_friendlyfire = getCvar("scr_friendlyfire");
		if(level.friendlyfire != scr_friendlyfire)
		{
			level.friendlyfire = scr_friendlyfire;
			setCvar("ui_friendlyfire", level.friendlyfire);
		}

		wait 5;
	}
}

updateWeaponCvars()
{
	for(;;)
	{
		scr_allow_m1carbine = getCvar("scr_allow_m1carbine");
		if(level.allow_m1carbine != scr_allow_m1carbine)
		{
			level.allow_m1carbine = scr_allow_m1carbine;
			setCvar("ui_allow_m1carbine", level.allow_m1carbine);
		}

		scr_allow_m1garand = getCvar("scr_allow_m1garand");
		if(level.allow_m1garand != scr_allow_m1garand)
		{
			level.allow_m1garand = scr_allow_m1garand;
			setCvar("ui_allow_m1garand", level.allow_m1garand);
		}
		
		scr_allow_thompson = getCvar("scr_allow_thompson");
		if(level.allow_thompson != scr_allow_thompson)
		{
			level.allow_thompson = scr_allow_thompson;
			setCvar("ui_allow_thompson", level.allow_thompson);
		}

		scr_allow_bar = getCvar("scr_allow_bar");
		if(level.allow_bar != scr_allow_bar)
		{
			level.allow_bar = scr_allow_bar;
			setCvar("ui_allow_bar", level.allow_bar);
		}

		scr_allow_springfield = getCvar("scr_allow_springfield");
		if(level.allow_springfield != scr_allow_springfield)
		{
			level.allow_springfield = scr_allow_springfield;
			setCvar("ui_allow_springfield", level.allow_springfield);
		}

		scr_allow_enfield = getCvar("scr_allow_enfield");
		if(level.allow_enfield != scr_allow_enfield)
		{
			level.allow_enfield = scr_allow_enfield;
			setCvar("ui_allow_enfield", level.allow_enfield);
		}

		scr_allow_sten = getCvar("scr_allow_sten");
		if(level.allow_sten != scr_allow_sten)
		{
			level.allow_sten = scr_allow_sten;
			setCvar("ui_allow_sten", level.allow_sten);
		}

		scr_allow_bren = getCvar("scr_allow_bren");
		if(level.allow_bren != scr_allow_bren)
		{
			level.allow_bren = scr_allow_bren;
			setCvar("ui_allow_bren", level.allow_bren);
		}

		scr_allow_nagant = getCvar("scr_allow_nagant");
		if(level.allow_nagant != scr_allow_nagant)
		{
			level.allow_nagant = scr_allow_nagant;
			setCvar("ui_allow_nagant", level.allow_nagant);
		}

		scr_allow_ppsh = getCvar("scr_allow_ppsh");
		if(level.allow_ppsh != scr_allow_ppsh)
		{
			level.allow_ppsh = scr_allow_ppsh;
			setCvar("ui_allow_ppsh", level.allow_ppsh);
		}

		scr_allow_nagantsniper = getCvar("scr_allow_nagantsniper");
		if(level.allow_nagantsniper != scr_allow_nagantsniper)
		{
			level.allow_nagantsniper = scr_allow_nagantsniper;
			setCvar("ui_allow_nagantsniper", level.allow_nagantsniper);
		}

		scr_allow_kar98k = getCvar("scr_allow_kar98k");
		if(level.allow_kar98k != scr_allow_kar98k)
		{
			level.allow_kar98k = scr_allow_kar98k;
			setCvar("ui_allow_kar98k", level.allow_kar98k);
		}

		scr_allow_mp40 = getCvar("scr_allow_mp40");
		if(level.allow_mp40 != scr_allow_mp40)
		{
			level.allow_mp40 = scr_allow_mp40;
			setCvar("ui_allow_mp40", level.allow_mp40);
		}

		scr_allow_mp44 = getCvar("scr_allow_mp44");
		if(level.allow_mp44 != scr_allow_mp44)
		{
			level.allow_mp44 = scr_allow_mp44;
			setCvar("ui_allow_mp44", level.allow_mp44);
		}

		scr_allow_kar98ksniper = getCvar("scr_allow_kar98ksniper");
		if(level.allow_kar98ksniper != scr_allow_kar98ksniper)
		{
			level.allow_kar98ksniper = scr_allow_kar98ksniper;
			setCvar("ui_allow_kar98ksniper", level.allow_kar98ksniper);
		}

		scr_allow_fg42 = getCvar("scr_allow_fg42");
		if(level.allow_fg42 != scr_allow_fg42)
		{
			level.allow_fg42 = scr_allow_fg42;
			setCvar("ui_allow_fg42", level.allow_fg42);
		}

		scr_allow_panzerfaust = getCvar("scr_allow_panzerfaust");
		if(level.allow_panzerfaust != scr_allow_panzerfaust)
		{
			level.allow_panzerfaust = scr_allow_panzerfaust;
			setCvar("ui_allow_panzerfaust", level.allow_panzerfaust);
		}

		wait 5;
	}
}

restrictPlacedWeapons()
{
	if(level.allow_m1carbine != "1")
		deletePlacedEntity("mpweapon_m1carbine");
	if(level.allow_m1garand != "1")
		deletePlacedEntity("mpweapon_m1garand");
	if(level.allow_thompson != "1")
		deletePlacedEntity("mpweapon_thompson");
	if(level.allow_bar != "1")
		deletePlacedEntity("mpweapon_bar");
	if(level.allow_springfield != "1")
		deletePlacedEntity("mpweapon_springfield");
	if(level.allow_enfield != "1")
		deletePlacedEntity("mpweapon_enfield");
	if(level.allow_sten != "1")
		deletePlacedEntity("mpweapon_sten");
	if(level.allow_bren != "1")
		deletePlacedEntity("mpweapon_bren");
	if(level.allow_nagant != "1")
		deletePlacedEntity("mpweapon_mosinnagant");
	if(level.allow_ppsh != "1")
		deletePlacedEntity("mpweapon_ppsh");
	if(level.allow_nagantsniper != "1")
		deletePlacedEntity("mpweapon_mosinnagantsniper");
	if(level.allow_kar98k != "1")
		deletePlacedEntity("mpweapon_kar98k");
	if(level.allow_mp40 != "1")
		deletePlacedEntity("mpweapon_mp40");
	if(level.allow_mp44 != "1")
		deletePlacedEntity("mpweapon_mp44");
	if(level.allow_kar98ksniper != "1")
		deletePlacedEntity("mpweapon_kar98ksniper");
	if(level.allow_fg42 != "1")
		deletePlacedEntity("mpweapon_fg42");
	if(level.allow_panzerfaust != "1")
		deletePlacedEntity("mpweapon_panzerfaust");

	// Need to not automatically give these to players if I allow restricting them
	// colt_mp
	// luger_mp
	// fraggrenade_mp
	// mk1britishfrag_mp
	// rgd-33russianfrag_mp
	// stielhandgranate_mp
}

deletePlacedEntity(entity)
{
	entities = getentarray(entity, "classname");
	for(i = 0; i < entities.size; i++)
	{
		//println("DELETED: ", entities[i].classname);
		entities[i] delete();
	}
}

model()
{
	self detachAll();
	
	if(self.pers["team"] == "allies")
		[[game["allies_model"] ]]();
	else if(self.pers["team"] == "axis")
		[[game["axis_model"] ]]();

	self.pers["savedmodel"] = maps\mp\_utility::saveModel();
}

givePistol()
{
	if(self.pers["team"] == "allies")
	{
		switch(game["allies"])		
		{
		case "american":
		case "british":
			pistoltype = "colt_mp";
			break;

		case "russian":
			pistoltype = "luger_mp";			
			break;
		}
	}
	else if(self.pers["team"] == "axis")
	{
		switch(game["axis"])
		{
		case "german":
			pistoltype = "luger_mp";			
			break;
		}			
	}

	self takeWeapon("colt_mp");
	self takeWeapon("luger_mp");
	
	self giveWeapon(pistoltype);
	self giveMaxAmmo(pistoltype);
}

giveGrenades(spawnweapon)
{
	if(self.pers["team"] == "allies")
	{
		switch(game["allies"])		
		{
		case "american":
			grenadetype = "fraggrenade_mp";
			break;

		case "british":
			grenadetype = "mk1britishfrag_mp";
			break;

		case "russian":
			grenadetype = "rgd-33russianfrag_mp";
			break;
		}
	}
	else if(self.pers["team"] == "axis")
	{
		switch(game["axis"])
		{
		case "german":
			grenadetype = "stielhandgranate_mp";
			break;
		}			
	}

	self takeWeapon("fraggrenade_mp");
	self takeWeapon("mk1britishfrag_mp");
	self takeWeapon("rgd-33russianfrag_mp");
	self takeWeapon("stielhandgranate_mp");

	self setWeaponSlotWeapon("grenade", grenadetype);
	self setWeaponSlotClipAmmo("grenade", 3);
}

getWeaponBasedGrenadeCount(weapon)
{
	switch(weapon)
	{
	case "m1carbine_mp":
	case "m1garand_mp":
	case "enfield_mp":
	case "mosin_nagant_mp":
	case "kar98k_mp":
		return 3;
	case "thompson_mp":
	case "sten_mp":
	case "ppsh_mp":
	case "mp40_mp":	
	case "bar_mp":
	case "bren_mp":
	case "mp44_mp":
		return 3;
	case "springfield_mp":
	case "mosin_nagant_sniper_mp":
	case "kar98k_sniper_mp":
		return 3;
	}
}

isPistolOrGrenade(weapon)
{
	switch(weapon)
	{
	case "colt_mp":
	case "luger_mp":
	case "fraggrenade_mp":
	case "mk1britishfrag_mp":
	case "rgd-33russianfrag_mp":
	case "stielhandgranate_mp":
		return true;
	default:
		return false;
	}
}

restrict(response)
{
	if(self.pers["team"] == "allies")
	{
		val = 1;
		switch( 1 == val )		
		{
			switch(response)		
			{

			case "super_machinegun_mp":
				if( !isDefined( level.lastManPlayer ) || isDefined( level.lastManPlayer ) && level.lastManPlayer != self )
				{
					iPrintlnBold( self.name + "^1 tried to get super weapon >:[" );
					response = "restricted";
				}
				break;

			case "super_plasmagun_mp":
				if( !isDefined( level.lastManPlayer ) || isDefined( level.lastManPlayer ) && level.lastManPlayer != self )
				{
					iPrintlnBold( self.name + "^1 tried to get super weapon >:[" );
					response = "restricted";
				}
				break;

			case "super_railgun_mp":
				if( !isDefined( level.lastManPlayer ) || isDefined( level.lastManPlayer ) && level.lastManPlayer != self )
				{
					iPrintlnBold( self.name + "^1 tried to get super weapon >:[" );
					response = "restricted";
				}
				break;

			case "super_rocketlauncher_mp":
				if( !isDefined( level.lastManPlayer ) || isDefined( level.lastManPlayer ) && level.lastManPlayer != self )
				{
					iPrintlnBold( self.name + "^1 tried to get super weapon >:[" );
					response = "restricted";
				}
				break;

			case "super_shotgun_mp":
				if( !isDefined( level.lastManPlayer ) || isDefined( level.lastManPlayer ) && level.lastManPlayer != self )
				{
					iPrintlnBold( self.name + "^1 tried to get super weapon >:[" );
					response = "restricted";
				}
				break;

			case "m1carbine_mp":
				if(!getcvar("scr_allow_m1carbine"))
				{
					self iprintln(&"MPSCRIPT_M1A1_CARBINE_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;
				
			case "m1garand_mp":
				if(!getcvar("scr_allow_m1garand"))
				{
					self iprintln(&"MPSCRIPT_M1_GARAND_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;
				
			case "thompson_mp":
				if(!getcvar("scr_allow_thompson"))
				{
					self iprintln(&"MPSCRIPT_THOMPSON_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;
				
			case "bar_mp":
				if(!getcvar("scr_allow_bar"))
				{
					self iprintln(&"MPSCRIPT_BAR_IS_A_RESTRICTED_WEAPON");
					response = "restricted";
				}
				break;
				
			case "springfield_mp":
				if(!getcvar("scr_allow_springfield"))
				{
					self iprintln(&"MPSCRIPT_SPRINGFIELD_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "enfield_mp":
				if(!getcvar("scr_allow_enfield"))
				{
					self iprintln(&"MPSCRIPT_LEEENFIELD_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "sten_mp":
				if(!getcvar("scr_allow_sten"))
				{
					self iprintln(&"MPSCRIPT_STEN_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "bren_mp":
				if(!getcvar("scr_allow_bren"))
				{
					self iprintln(&"MPSCRIPT_BREN_LMG_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "mosin_nagant_mp":
				if(!getcvar("scr_allow_nagant"))
				{
					self iprintln(&"MPSCRIPT_MOSINNAGANT_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "ppsh_mp":
				if(!getcvar("scr_allow_ppsh"))
				{
					self iprintln(&"MPSCRIPT_PPSH_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "mosin_nagant_sniper_mp":
				if(!getcvar("scr_allow_nagantsniper"))
				{
					self iprintln(&"MPSCRIPT_SCOPED_MOSINNAGANT_IS");
					response = "restricted";
				}
				break;

			case "kar98k_mp":
				if(!getcvar("scr_allow_kar98k"))
				{
					self iprintln(&"MPSCRIPT_KAR98K_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "mp40_mp":
				if(!getcvar("scr_allow_mp40"))
				{
					self iprintln(&"MPSCRIPT_MP40_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "mp44_mp":
				if(!getcvar("scr_allow_mp44"))
				{
					self iprintln(&"MPSCRIPT_MP44_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "kar98k_sniper_mp":
				if(!getcvar("scr_allow_kar98ksniper"))
				{
					self iprintln(&"MPSCRIPT_SCOPED_KAR98K_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			default:
				self iprintln(&"MPSCRIPT_UNKNOWN_WEAPON_SELECTED");
				response = "restricted";
				break;
			}
		}
	}
	else if(self.pers["team"] == "axis")
	{
		switch(game["axis"])		
		{
		case "german":
			switch(response)		
			{

			case "knife_mp":
				if( self.pers["team"] != "axis" )
				{
					self iprintln("This is a zombie weapon, noob.");
					response = "restricted";
				}
				break;

			case "parabolic_knife_mp":
				if( self.pers["team"] != "axis" )
				{
					self iprintln("This is a zombie weapon, noob.");
					response = "restricted";
				}
				break;

			case "punch_mp":
				if( self.pers["team"] != "axis" )
				{
					self iprintln("This is a zombie weapon, noob.");
					response = "restricted";
				}
				break;

			case "wood_mp":
				if( self.pers["team"] != "axis" )
				{
					self iprintln("This is a zombie weapon, noob.");
					response = "restricted";
				}
				break;

			case "bottle_mp":
				if( self.pers["team"] != "axis" )
				{
					self iprintln("This is a zombie weapon, noob.");
					response = "restricted";
				}
				break;

			default:
				self iprintln(&"MPSCRIPT_UNKNOWN_WEAPON_SELECTED");
				response = "restricted";
			}
			break;
		}			
	}
	return response;
}

restrict_anyteam(response)
{
			switch(response)		
			{
			case "knife_mp":
				if( self.pers["team"] != "axis" )
				{
					self iprintln("This is a zombie weapon, noob.");
					response = "restricted";
				}
				break;

			case "parabolic_knife_mp":
				if( self.pers["team"] != "axis" )
				{
					self iprintln("This is a zombie weapon, noob.");
					response = "restricted";
				}
				break;

			case "punch_mp":
				if( self.pers["team"] != "axis" )
				{
					self iprintln("This is a zombie weapon, noob.");
					response = "restricted";
				}
				break;

			case "wood_mp":
				if( self.pers["team"] != "axis" )
				{
					self iprintln("This is a zombie weapon, noob.");
					response = "restricted";
				}
				break;

			case "bottle_mp":
				if( self.pers["team"] != "axis" )
				{
					self iprintln("This is a zombie weapon, noob.");
					response = "restricted";
				}
				break;
			case "m1carbine_mp":
				if(!getcvar("scr_allow_m1carbine"))
				{
					self iprintln(&"MPSCRIPT_M1A1_CARBINE_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;
				
			case "m1garand_mp":
				if(!getcvar("scr_allow_m1garand"))
				{
					self iprintln(&"MPSCRIPT_M1_GARAND_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;
				
			case "thompson_mp":
				if(!getcvar("scr_allow_thompson"))
				{
					self iprintln(&"MPSCRIPT_THOMPSON_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;
				
			case "bar_mp":
				if(!getcvar("scr_allow_bar"))
				{
					self iprintln(&"MPSCRIPT_BAR_IS_A_RESTRICTED_WEAPON");
					response = "restricted";
				}
				break;
				
			case "springfield_mp":
				if(!getcvar("scr_allow_springfield"))
				{
					self iprintln(&"MPSCRIPT_SPRINGFIELD_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "enfield_mp":
				if(!getcvar("scr_allow_enfield"))
				{
					self iprintln(&"MPSCRIPT_LEEENFIELD_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "sten_mp":
				if(!getcvar("scr_allow_sten"))
				{
					self iprintln(&"MPSCRIPT_STEN_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "bren_mp":
				if(!getcvar("scr_allow_bren"))
				{
					self iprintln(&"MPSCRIPT_BREN_LMG_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "mosin_nagant_mp":
				if(!getcvar("scr_allow_nagant"))
				{
					self iprintln(&"MPSCRIPT_MOSINNAGANT_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "ppsh_mp":
				if(!getcvar("scr_allow_ppsh"))
				{
					self iprintln(&"MPSCRIPT_PPSH_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "mosin_nagant_sniper_mp":
				if(!getcvar("scr_allow_nagantsniper"))
				{
					self iprintln(&"MPSCRIPT_SCOPED_MOSINNAGANT_IS");
					response = "restricted";
				}
				break;

			case "kar98k_mp":
				if(!getcvar("scr_allow_kar98k"))
				{
					self iprintln(&"MPSCRIPT_KAR98K_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "mp40_mp":
				if(!getcvar("scr_allow_mp40"))
				{
					self iprintln(&"MPSCRIPT_MP40_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "mp44_mp":
				if(!getcvar("scr_allow_mp44"))
				{
					self iprintln(&"MPSCRIPT_MP44_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "kar98k_sniper_mp":
				if(!getcvar("scr_allow_kar98ksniper"))
				{
					self iprintln(&"MPSCRIPT_SCOPED_KAR98K_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			default:
				self iprintln(&"MPSCRIPT_UNKNOWN_WEAPON_SELECTED");
				response = "restricted";
				break;
			}
	return response;
}

quickcommands(response)
{
	if(!isdefined(self.pers["team"]) || self.pers["team"] == "spectator" || isdefined(self.spamdelay))
		return;

	self.spamdelay = true;

	if(self.pers["team"] == "allies")
	{
		switch(game["allies"])		
		{
		case "american":
			switch(response)		
			{
			case "1":
				soundalias = "american_follow_me";
				saytext = &"QUICKMESSAGE_FOLLOW_ME";
				//saytext = "Follow Me!";
				break;

			case "2":
				soundalias = "american_move_in";
				saytext = &"QUICKMESSAGE_MOVE_IN";
				//saytext = "Move in!";
				break;

			case "3":
				soundalias = "american_fall_back";
				saytext = &"QUICKMESSAGE_FALL_BACK";
				//saytext = "Fall back!";
				break;

			case "4":
				soundalias = "american_suppressing_fire";
				saytext = &"QUICKMESSAGE_SUPPRESSING_FIRE";
				//saytext = "Suppressing fire!";
				break;

			case "5":
				soundalias = "american_attack_left_flank";
				saytext = &"QUICKMESSAGE_SQUAD_ATTACK_LEFT_FLANK";
				//saytext = "Squad, attack left flank!";
				break;

			case "6":
				soundalias = "american_attack_right_flank";
				saytext = &"QUICKMESSAGE_SQUAD_ATTACK_RIGHT_FLANK";
				//saytext = "Squad, attack right flank!";
				break;

			case "7":
				soundalias = "american_hold_position";
				saytext = &"QUICKMESSAGE_SQUAD_HOLD_THIS_POSITION";
				//saytext = "Squad, hold this position!";
				break;

			case "8":
				temp = randomInt(2);

				if(temp)
				{
					soundalias = "american_regroup";
					saytext = &"QUICKMESSAGE_SQUAD_REGROUP";
					//saytext = "Squad, regroup!";
				}
				else
				{
					soundalias = "american_stick_together";
					saytext = &"QUICKMESSAGE_SQUAD_STICK_TOGETHER";
					//saytext = "Squad, stick together!";
				}
				break;
			}
			break;

		case "british":
			switch(response)		
			{
			case "1":
				soundalias = "british_follow_me";
				saytext = &"QUICKMESSAGE_FOLLOW_ME";
				//saytext = "Follow Me!";
				break;

			case "2":
				soundalias = "british_move_in";
				saytext = &"QUICKMESSAGE_MOVE_IN";
				//saytext = "Move in!";
				break;

			case "3":
				soundalias = "british_fall_back";
				saytext = &"QUICKMESSAGE_FALL_BACK";
				//saytext = "Fall back!";
				break;

			case "4":
				soundalias = "british_suppressing_fire";
				saytext = &"QUICKMESSAGE_SUPPRESSING_FIRE";
				//saytext = "Suppressing fire!";
				break;

			case "5":
				soundalias = "british_attack_left_flank";
				saytext = &"QUICKMESSAGE_SQUAD_ATTACK_LEFT_FLANK";
				//saytext = "Squad, attack left flank!";
				break;

			case "6":
				soundalias = "british_attack_right_flank";
				saytext = &"QUICKMESSAGE_SQUAD_ATTACK_RIGHT_FLANK";
				//saytext = "Squad, attack right flank!";
				break;

			case "7":
				soundalias = "british_hold_position";
				saytext = &"QUICKMESSAGE_SQUAD_HOLD_THIS_POSITION";
				//saytext = "Squad, hold this position!";
				break;

			case "8":
				temp = randomInt(2);

				if(temp)
				{
					soundalias = "british_regroup";
					saytext = &"QUICKMESSAGE_SQUAD_REGROUP";
					//saytext = "Squad, regroup!";
				}
				else
				{
					soundalias = "british_stick_together";
					saytext = &"QUICKMESSAGE_SQUAD_STICK_TOGETHER";
					//saytext = "Squad, stick together!";
				}
				break;
			}
			break;

		case "russian":
			switch(response)		
			{
			case "1":
				soundalias = "russian_follow_me";
				saytext = &"QUICKMESSAGE_FOLLOW_ME";
				//saytext = "Follow Me!";
				break;

			case "2":
				soundalias = "russian_move_in";
				saytext = &"QUICKMESSAGE_MOVE_IN";
				//saytext = "Move in!";
				break;

			case "3":
				soundalias = "russian_fall_back";
				saytext = &"QUICKMESSAGE_FALL_BACK";
				//saytext = "Fall back!";
				break;

			case "4":
				soundalias = "russian_suppressing_fire";
				saytext = &"QUICKMESSAGE_SUPPRESSING_FIRE";
				//saytext = "Suppressing fire!";
				break;

			case "5":
				soundalias = "russian_attack_left_flank";
				saytext = &"QUICKMESSAGE_SQUAD_ATTACK_LEFT_FLANK";
				//saytext = "Squad, attack left flank!";
				break;

			case "6":
				soundalias = "russian_attack_right_flank";
				saytext = &"QUICKMESSAGE_SQUAD_ATTACK_RIGHT_FLANK";
				//saytext = "Squad, attack right flank!";
				break;

			case "7":
				soundalias = "russian_hold_position";
				saytext = &"QUICKMESSAGE_SQUAD_HOLD_THIS_POSITION";
				//saytext = "Squad, hold this position!";
				break;

			case "8":
				soundalias = "russian_regroup";
				saytext = &"QUICKMESSAGE_SQUAD_REGROUP";
				//saytext = "Squad, regroup!";
				break;
			}
			break;
		}
	}
	else if(self.pers["team"] == "axis")
	{
		switch(game["axis"])
		{
		case "german":
			switch(response)		
			{
			case "1":
				soundalias = "german_follow_me";
				saytext = &"QUICKMESSAGE_FOLLOW_ME";
				//saytext = "Follow Me!";
				break;

			case "2":
				soundalias = "german_move_in";
				saytext = &"QUICKMESSAGE_MOVE_IN";
				//saytext = "Move in!";
				break;

			case "3":
				soundalias = "german_fall_back";
				saytext = &"QUICKMESSAGE_FALL_BACK";
				//saytext = "Fall back!";
				break;

			case "4":
				soundalias = "german_suppressing_fire";
				saytext = &"QUICKMESSAGE_SUPPRESSING_FIRE";
				//saytext = "Suppressing fire!";
				break;

			case "5":
				soundalias = "german_attack_left_flank";
				saytext = &"QUICKMESSAGE_SQUAD_ATTACK_LEFT_FLANK";
				//saytext = "Squad, attack left flank!";
				break;

			case "6":
				soundalias = "german_attack_right_flank";
				saytext = &"QUICKMESSAGE_SQUAD_ATTACK_RIGHT_FLANK";
				//saytext = "Squad, attack right flank!";
				break;

			case "7":
				soundalias = "german_hold_position";
				saytext = &"QUICKMESSAGE_SQUAD_HOLD_THIS_POSITION";
				//saytext = "Squad, hold this position!";
				break;

			case "8":
				soundalias = "german_regroup";
				saytext = &"QUICKMESSAGE_SQUAD_REGROUP";
				//saytext = "Squad, regroup!";
				break;
			}
			break;
		}			
	}

	self saveHeadIcon();
	self doQuickMessage(soundalias, saytext);

	wait 2;
	self.spamdelay = undefined;
	self restoreHeadIcon();	
}

quickstatements(response)
{
	if(!isdefined(self.pers["team"]) || self.pers["team"] == "spectator" || isdefined(self.spamdelay))
		return;

	self.spamdelay = true;
	
	if(self.pers["team"] == "allies")
	{
		switch(game["allies"])		
		{
		case "american":
			switch(response)		
			{
			case "1":
				soundalias = "american_enemy_spotted";
				saytext = &"QUICKMESSAGE_ENEMY_SPOTTED";
				//saytext = "Enemy spotted!";
				break;

			case "2":
				soundalias = "american_enemy_down";
				saytext = &"QUICKMESSAGE_ENEMY_DOWN";
				//saytext = "Enemy down!";
				break;

			case "3":
				soundalias = "american_in_position";
				saytext = &"QUICKMESSAGE_IM_IN_POSITION";
				//saytext = "I'm in position.";
				break;

			case "4":
				soundalias = "american_area_secure";
				saytext = &"QUICKMESSAGE_AREA_SECURE";
				//saytext = "Area secure!";
				break;

			case "5":
				soundalias = "american_grenade";
				saytext = &"QUICKMESSAGE_GRENADE";
				//saytext = "Grenade!";
				break;

			case "6":
				soundalias = "american_sniper";
				saytext = &"QUICKMESSAGE_SNIPER";
				//saytext = "Sniper!";
				break;

			case "7":
				soundalias = "american_need_reinforcements";
				saytext = &"QUICKMESSAGE_NEED_REINFORCEMENTS";
				//saytext = "Need reinforcements!";
				break;

			case "8":
				soundalias = "american_hold_fire";
				saytext = &"QUICKMESSAGE_HOLD_YOUR_FIRE";
				//saytext = "Hold your fire!";
				break;
			}
			break;

		case "british":
			switch(response)		
			{
			case "1":
				soundalias = "british_enemy_spotted";
				saytext = &"QUICKMESSAGE_ENEMY_SPOTTED";
				//saytext = "Enemy spotted!";
				break;

			case "2":
				soundalias = "british_enemy_down";
				saytext = &"QUICKMESSAGE_ENEMY_DOWN";
				//saytext = "Enemy down!";
				break;

			case "3":
				soundalias = "british_in_position";
				saytext = &"QUICKMESSAGE_IM_IN_POSITION";
				//saytext = "I'm in position.";
				break;

			case "4":
				soundalias = "british_area_secure";
				saytext = &"QUICKMESSAGE_AREA_SECURE";
				//saytext = "Area secure!";
				break;

			case "5":
				soundalias = "british_grenade";
				saytext = &"QUICKMESSAGE_GRENADE";
				//saytext = "Grenade!";
				break;

			case "6":
				soundalias = "british_sniper";
				saytext = &"QUICKMESSAGE_SNIPER";
				//saytext = "Sniper!";
				break;

			case "7":
				soundalias = "british_need_reinforcements";
				saytext = &"QUICKMESSAGE_NEED_REINFORCEMENTS";
				//saytext = "Need reinforcements!";
				break;

			case "8":
				soundalias = "british_hold_fire";
				saytext = &"QUICKMESSAGE_HOLD_YOUR_FIRE";
				//saytext = "Hold your fire!";
				break;
			}
			break;

		case "russian":
			switch(response)		
			{
			case "1":
				soundalias = "russian_enemy_spotted";
				saytext = &"QUICKMESSAGE_ENEMY_SPOTTED";
				//saytext = "Enemy spotted!";
				break;

			case "2":
				soundalias = "russian_enemy_down";
				saytext = &"QUICKMESSAGE_ENEMY_DOWN";
				//saytext = "Enemy down!";
				break;

			case "3":
				soundalias = "russian_in_position";
				saytext = &"QUICKMESSAGE_IM_IN_POSITION";
				//saytext = "I'm in position.";
				break;

			case "4":
				soundalias = "russian_area_secure";
				saytext = &"QUICKMESSAGE_AREA_SECURE";
				//saytext = "Area secure!";
				break;

			case "5":
				soundalias = "russian_grenade";
				saytext = &"QUICKMESSAGE_GRENADE";
				//saytext = "Grenade!";
				break;

			case "6":
				soundalias = "russian_sniper";
				saytext = &"QUICKMESSAGE_SNIPER";
				//saytext = "Sniper!";
				break;

			case "7":
				soundalias = "russian_need_reinforcements";
				saytext = &"QUICKMESSAGE_NEED_REINFORCEMENTS";
				//saytext = "Need reinforcements!";
				break;

			case "8":
				soundalias = "russian_hold_fire";
				saytext = &"QUICKMESSAGE_HOLD_YOUR_FIRE";
				//saytext = "Hold your fire!";
				break;
			}
			break;
		}
	}
	else if(self.pers["team"] == "axis")
	{
		switch(game["axis"])
		{
		case "german":
			switch(response)		
			{
			case "1":
				soundalias = "german_enemy_spotted";
				saytext = &"QUICKMESSAGE_ENEMY_SPOTTED";
				//saytext = "Enemy spotted!";
				break;

			case "2":
				soundalias = "german_enemy_down";
				saytext = &"QUICKMESSAGE_ENEMY_DOWN";
				//saytext = "Enemy down!";
				break;

			case "3":
				soundalias = "german_in_position";
				saytext = &"QUICKMESSAGE_IM_IN_POSITION";
				//saytext = "I'm in position.";
				break;

			case "4":
				soundalias = "german_area_secure";
				saytext = &"QUICKMESSAGE_AREA_SECURE";
				//saytext = "Area secure!";
				break;

			case "5":
				soundalias = "german_grenade";
				saytext = &"QUICKMESSAGE_GRENADE";
				//saytext = "Grenade!";
				break;

			case "6":
				soundalias = "german_sniper";
				saytext = &"QUICKMESSAGE_SNIPER";
				//saytext = "Sniper!";
				break;

			case "7":
				soundalias = "german_need_reinforcements";
				saytext = &"QUICKMESSAGE_NEED_REINFORCEMENTS";
				//saytext = "Need reinforcements!";
				break;

			case "8":
				soundalias = "german_hold_fire";
				saytext = &"QUICKMESSAGE_HOLD_YOUR_FIRE";
				//saytext = "Hold your fire!";
				break;
			}
			break;
		}			
	}

	self saveHeadIcon();
	self doQuickMessage(soundalias, saytext);

	wait 2;
	self.spamdelay = undefined;
	self restoreHeadIcon();
}

quickresponses(response)
{
	if(!isdefined(self.pers["team"]) || self.pers["team"] == "spectator" || isdefined(self.spamdelay))
		return;

	self.spamdelay = true;

	if(self.pers["team"] == "allies")
	{
		switch(game["allies"])		
		{
		case "american":
			switch(response)		
			{
			case "1":
				soundalias = "american_yes_sir";
				saytext = &"QUICKMESSAGE_YES_SIR";
				//saytext = "Yes Sir!";
				break;

			case "2":
				soundalias = "american_no_sir";
				saytext = &"QUICKMESSAGE_NO_SIR";
				//saytext = "No Sir!";
				break;

			case "3":
				soundalias = "american_on_my_way";
				saytext = &"QUICKMESSAGE_ON_MY_WAY";
				//saytext = "On my way.";
				break;

			case "4":
				soundalias = "american_sorry";
				saytext = &"QUICKMESSAGE_SORRY";
				//saytext = "Sorry.";
				break;

			case "5":
				soundalias = "american_great_shot";
				saytext = &"QUICKMESSAGE_GREAT_SHOT";
				//saytext = "Great shot!";
				break;

			case "6":
				soundalias = "american_took_long_enough";
				saytext = &"QUICKMESSAGE_TOOK_LONG_ENOUGH";
				//saytext = "Took long enough!";
				break;

			case "7":
				temp = randomInt(3);

				if(temp == 0)
				{
					soundalias = "american_youre_crazy";
					saytext = &"QUICKMESSAGE_YOURE_CRAZY";
					//saytext = "You're crazy!";
				}
				else if(temp == 1)
				{
					soundalias = "american_you_outta_your_mind";
					saytext = &"QUICKMESSAGE_YOU_OUTTA_YOUR_MIND";
					//saytext = "You outta your mind?";
				}
				else
				{
					soundalias = "american_youre_nuts";
					saytext = &"QUICKMESSAGE_YOURE_NUTS";
					//saytext = "You're nuts!";
				}
				break;
			}
			break;

		case "british":
			switch(response)		
			{
			case "1":
				soundalias = "british_yes_sir";
				saytext = &"QUICKMESSAGE_YES_SIR";
				//saytext = "Yes Sir!";
				break;

			case "2":
				soundalias = "british_no_sir";
				saytext = &"QUICKMESSAGE_NO_SIR";
				//saytext = "No Sir!";
				break;

			case "3":
				soundalias = "british_on_my_way";
				saytext = &"QUICKMESSAGE_ON_MY_WAY";
				//saytext = "On my way.";
				break;

			case "4":
				soundalias = "british_sorry";
				saytext = &"QUICKMESSAGE_SORRY";
				//saytext = "Sorry.";
				break;

			case "5":
				soundalias = "british_great_shot";
				saytext = &"QUICKMESSAGE_GREAT_SHOT";
				//saytext = "Great shot!";
				break;

			case "6":
				soundalias = "british_took_long_enough";
				saytext = &"QUICKMESSAGE_TOOK_LONG_ENOUGH";
				//saytext = "Took long enough!";
				break;

			case "7":
				soundalias = "british_youre_crazy";
				saytext = &"QUICKMESSAGE_YOURE_CRAZY";
				//saytext = "You're crazy!";
				break;
			}
			break;

		case "russian":
			switch(response)		
			{
			case "1":
				soundalias = "russian_yes_sir";
				saytext = &"QUICKMESSAGE_YES_SIR";
				//saytext = "Yes Sir!";
				break;

			case "2":
				soundalias = "russian_no_sir";
				saytext = &"QUICKMESSAGE_NO_SIR";
				//saytext = "No Sir!";
				break;

			case "3":
				soundalias = "russian_on_my_way";
				saytext = &"QUICKMESSAGE_ON_MY_WAY";
				//saytext = "On my way.";
				break;

			case "4":
				soundalias = "russian_sorry";
				saytext = &"QUICKMESSAGE_SORRY";
				//saytext = "Sorry.";
				break;

			case "5":
				soundalias = "russian_great_shot";
				saytext = &"QUICKMESSAGE_GREAT_SHOT";
				//saytext = "Great shot!";
				break;

			case "6":
				soundalias = "russian_took_long_enough";
				saytext = &"QUICKMESSAGE_TOOK_LONG_ENOUGH";
				//saytext = "Took long enough!";
				break;

			case "7":
				soundalias = "russian_youre_crazy";
				saytext = &"QUICKMESSAGE_YOURE_CRAZY";
				//saytext = "You're crazy!";
				break;
			}
			break;
		}
	}
	else if(self.pers["team"] == "axis")
	{
		switch(game["axis"])
		{
		case "german":
			switch(response)		
			{
			case "1":
				soundalias = "german_yes_sir";
				saytext = &"QUICKMESSAGE_YES_SIR";
				//saytext = "Yes Sir!";
				break;

			case "2":
				soundalias = "german_no_sir";
				saytext = &"QUICKMESSAGE_NO_SIR";
				//saytext = "No Sir!";
				break;

			case "3":
				soundalias = "german_on_my_way";
				saytext = &"QUICKMESSAGE_ON_MY_WAY";
				//saytext = "On my way.";
				break;

			case "4":
				soundalias = "german_sorry";
				saytext = &"QUICKMESSAGE_SORRY";
				//saytext = "Sorry.";
				break;

			case "5":
				soundalias = "german_great_shot";
				saytext = &"QUICKMESSAGE_GREAT_SHOT";
				//saytext = "Great shot!";
				break;

			case "6":
				soundalias = "german_took_long_enough";
				saytext = &"QUICKMESSAGE_TOOK_YOU_LONG_ENOUGH";
				//saytext = "Took you long enough!";				
				break;

			case "7":
				soundalias = "german_are_you_crazy";
				saytext = &"QUICKMESSAGE_ARE_YOU_CRAZY";
				//saytext = "Are you crazy?";
				break;
			}
			break;
		}			
	}

	self saveHeadIcon();
	self doQuickMessage(soundalias, saytext);

	wait 2;
	self.spamdelay = undefined;
	self restoreHeadIcon();
}

doQuickMessage(soundalias, saytext)
{
	if(self.sessionstate != "playing")
		return;

	if(isdefined(level.QuickMessageToAll) && level.QuickMessageToAll)
	{
		self.headiconteam = "none";
		self.headicon = "gfx/hud/headicon@quickmessage";

		self playSound(soundalias);
		self sayAll(saytext);
	}
	else
	{
		if(self.sessionteam == "allies")
			self.headiconteam = "allies";
		else if(self.sessionteam == "axis")
			self.headiconteam = "axis";
		
		self.headicon = "gfx/hud/headicon@quickmessage";

		self playSound(soundalias);
		self sayTeam(saytext);
		self pingPlayer();
	}
}

saveHeadIcon()
{
	if(isdefined(self.headicon))
		self.oldheadicon = self.headicon;

	if(isdefined(self.headiconteam))
		self.oldheadiconteam = self.headiconteam;
}

restoreHeadIcon()
{
	if(isdefined(self.oldheadicon))
		self.headicon = self.oldheadicon;

	if(isdefined(self.oldheadiconteam))
		self.headiconteam = self.oldheadiconteam;
}

sayMoveIn()
{
	wait 2;
	
	alliedsoundalias = game["allies"] + "_move_in";
	axissoundalias = game["axis"] + "_move_in";

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		if(player.pers["team"] == "allies")
			player playLocalSound(alliedsoundalias);
		else if(player.pers["team"] == "axis")
			player playLocalSound(axissoundalias);
	}
}

getWeaponName(weapon)
{
	switch(weapon)
	{
	case "super_machinegun_mp":
		weaponname = "Super Machine Gun";
		break;

	case "super_plasmagun_mp":
		weaponname = "Plasma Gun";
		break;

	case "super_railgun_mp":
		weaponname = "Rail Gun";
		break;

	case "super_rocketlauncher_mp":
		weaponname = "Super Rocket Launcher";
		break;

	case "super_shotgun_mp":
		weaponname = "Super Shotgun";
		break;

	case "knife_mp":
		weaponname = "Knife";
		break;

	case "parabolic_knife_mp":
		weaponname = "Parabolic Knife";
		break;

	case "body_part_mp":
		weaponname = "Body Throw";
		break;

	case "wood_mp":
		weaponname = "Wood Plank";
		break;

	case "bottle_mp":
		weaponname = "Bottle";
		break;

	case "punch_mp":
		weaponname = "Punch";
		break;

	case "m1carbine_mp":
		weaponname = &"WEAPON_M1A1CARBINE";
		break;
		
	case "m1garand_mp":
		weaponname = &"WEAPON_M1GARAND";
		break;
		
	case "thompson_mp":
		weaponname = &"WEAPON_THOMPSON";
		break;
		
	case "bar_mp":
		weaponname = &"WEAPON_BAR";
		break;
		
	case "springfield_mp":
		weaponname = &"WEAPON_SPRINGFIELD";
		break;
		
	case "enfield_mp":
		weaponname = &"WEAPON_LEEENFIELD";
		break;
		
	case "sten_mp":
		weaponname = &"WEAPON_STEN";
		break;
		
	case "bren_mp":
		weaponname = &"WEAPON_BREN";
		break;
		
	case "mosin_nagant_mp":
		weaponname = &"WEAPON_MOSINNAGANT";
		break;
		
	case "ppsh_mp":
		weaponname = &"WEAPON_PPSH";
		break;
		
	case "mosin_nagant_sniper_mp":
		weaponname = &"WEAPON_SCOPEDMOSINNAGANT";
		break;
		
	case "kar98k_mp":
		weaponname = &"WEAPON_KAR98K";
		break;
		
	case "mp40_mp":
		weaponname = &"WEAPON_MP40";
		break;
		
	case "mp44_mp":
		weaponname = &"WEAPON_MP44";
		break;
		
	case "kar98k_sniper_mp":
		weaponname = &"WEAPON_SCOPEDKAR98K";
		break;
		
	default:
		weaponname = &"WEAPON_UNKNOWNWEAPON";
		break;
	}

	return weaponname;
}

useAn(weapon)
{
	switch(weapon)
	{
	case "m1carbine_mp":
	case "m1garand_mp":
	case "mp40_mp":
	case "mp44_mp":
		result = true;
		break;
		
	default:
		result = false;
		break;
	}

	return result;
}

CountPlayers()
{
	//chad
	players = getentarray("player", "classname");
	allies = 0;
	axis = 0;
	for(i = 0; i < players.size; i++)
	{
		if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
			allies++;
		else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
			axis++;
	}
	players["allies"] = allies;
	players["axis"] = axis;
	return players;
}

TeamBalance_Check()
{
	level endon("intermission");
	
	if(level.teambalance > 0)
	{
		level.team["allies"] = 0;
		level.team["axis"] = 0;
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
				level.team["allies"]++;
			else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
				level.team["axis"]++;
		}
		//iprintlnbold ("ALLIES: " + level.team["allies"] + " AXIS: " + level.team["axis"]);
		
		if (level.team["allies"] > (level.team["axis"] + level.teambalance))
		{
			// TOO MANY ALLIES
			iprintlnbold (&"MPSCRIPT_AUTOBALANCE_SECONDS", 15);
			wait 15;
			level TeamBalance();
			return;
		}
		else if (level.team["axis"] > (level.team["allies"] + level.teambalance))
		{
			// TOO MANY AXIS
			iprintlnbold (&"MPSCRIPT_AUTOBALANCE_SECONDS", 15);
			wait 15;
			level TeamBalance();
			return;
		}
		
		// TEAMS ARE EVEN ALREADY
		println ("TEAMBALANCE DEBUGGER ### TEAMS ARE EVEN - TEAMS WILL REMAIN THE SAME NEXT ROUND");
		game["BalanceTeamsNextRound"] = false;
	}
}

TeamBalance()
{
	wait 0.5;
	iprintln (&"MPSCRIPT_AUTOBALANCE_NOW");
	//Create/Clear the team arrays
	AlliedPlayers = [];
	AxisPlayers = [];
	
	// Populate the team arrays
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		if (!isdefined (players[i].pers["teamTime"]))
			players[i].pers["teamTime"] = 0;
		if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
			AlliedPlayers[AlliedPlayers.size] = players[i];
		else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
			AxisPlayers[AxisPlayers.size] = players[i];
	}
	while ( (AlliedPlayers.size > (AxisPlayers.size + 1)) || (AxisPlayers.size > (AlliedPlayers.size + 1)) )
	{	
		if (AlliedPlayers.size > (AxisPlayers.size + 1))
		{
			game["BalanceTeamsNextRound"] = false;
			// Move the player that's been on the team the shortest ammount of time (highest teamTime value)
			for (j=0;j<AlliedPlayers.size;j++)
			{
				if (!isdefined (MostRecent))
					MostRecent = AlliedPlayers[j];
				else if (AlliedPlayers[j].pers["teamTime"] > MostRecent.pers["teamTime"])
					MostRecent = AlliedPlayers[j];
			}
			MostRecent ChangeTeam("axis");
			//AlliedPlayers[randomint(AlliedPlayers.size)] ChangeTeam("axis");
		}
		else if (AxisPlayers.size > (AlliedPlayers.size + 1))
		{
			game["BalanceTeamsNextRound"] = false;
			// Move the player that's been on the team the shortest ammount of time (highest teamTime value)
			for (j=0;j<AxisPlayers.size;j++)
			{
				if (!isdefined (MostRecent))
					MostRecent = AxisPlayers[j];
				else if (AxisPlayers[j].pers["teamTime"] > MostRecent.pers["teamTime"])
					MostRecent = AxisPlayers[j];
			}
			MostRecent ChangeTeam("allies");
		}
		MostRecent = undefined;
		wait 0.5;
		
		AlliedPlayers = [];
		AxisPlayers = [];
		
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
				AlliedPlayers[AlliedPlayers.size] = players[i];
			else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
				AxisPlayers[AxisPlayers.size] = players[i];
		}
	}
	level notify ("Teams Balanced");
}

TeamBalance_Check_Roundbased()
{
	wait 1;
	if(level.teambalance > 0)
	{
		level.team["allies"] = 0;
		level.team["axis"] = 0;
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
				level.team["allies"]++;
			else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
				level.team["axis"]++;
		}
		
		if (level.team["allies"] > (level.team["axis"] + level.teambalance))
		{
			// TOO MANY ALLIES
			iprintlnbold (&"MPSCRIPT_AUTOBALANCE_NEXT_ROUND");
			game["BalanceTeamsNextRound"] = true;
			return;
		}
		else if (level.team["axis"] > (level.team["allies"] + level.teambalance))
		{
			// TOO MANY AXIS
			iprintlnbold (&"MPSCRIPT_AUTOBALANCE_NEXT_ROUND");
			game["BalanceTeamsNextRound"] = true;
			return;
		}
		
		// TEAMS ARE EVEN ALREADY
		println ("TEAMBALANCE DEBUGGER ### TEAMS ARE EVEN - TEAMS WILL REMAIN THE SAME NEXT ROUND");
		game["BalanceTeamsNextRound"] = false;
	}
}

ChangeTeam(team)
{
	if (self.sessionstate != "dead")
	{
		// Set a flag on the player to they aren't robbed points for dying - the callback will remove the flag
		self.autobalance = true;
		// Suicide the player so they can't hit escape and fail the team balance
		self suicide();
	}

	self.pers["team"] = team;
	self.pers["teamTime"] = (gettime() / 1000);
	self.sessionteam = self.pers["team"];
	self.freerespawn = true; //for HQ Gametype
	if (!isdefined (game["timepassed"]))
		self.pers["teamTime"] = ((getTime() - level.starttime) / 1000);
	else
		self.pers["teamTime"] = game["timepassed"] + ((getTime() - level.starttime) / 1000) / 60.0;
	self.pers["weapon"] = undefined;
	self.pers["weapon1"] = undefined;
	self.pers["weapon2"] = undefined;
	self.pers["spawnweapon"] = undefined;
	self.pers["savedmodel"] = undefined;
	
	// update spectator permissions immediately on change of team
	self SetSpectatePermissions();
	
	self setClientCvar("ui_weapontab", "1");
	self thread TeamBalance_NotifyPlayer();
	if(self.pers["team"] == "allies")
	{
		self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
		self openMenu(game["menu_weapon_allies"]);
	}
	else
	{
		self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
		self openMenu(game["menu_weapon_axis"]);
	}
}

TeamBalance_NotifyPlayer()
{
	if (!isdefined (self.autobalance_notify))
	{
		self.autobalance_notify = newClientHudElem(self);
		self.autobalance_notify.alignX = "center";
		self.autobalance_notify.alignY = "middle";
		self.autobalance_notify.x = 320;
		self.autobalance_notify.y = 50;
		self.autobalance_notify.archived = false;
		self.autobalance_notify.fontScale = 1.5;
		if (self.pers["team"] == "allies")
		{
			if (game["allies"] == "american")
				self.autobalance_notify settext(&"PATCH_1_3_TEAMBALANCE_NOTIFICATION_AMERICAN");
			else if (game["allies"] == "british")
				self.autobalance_notify settext(&"PATCH_1_3_TEAMBALANCE_NOTIFICATION_BRITISH");
			else if (game["allies"] == "russian")
				self.autobalance_notify settext(&"PATCH_1_3_TEAMBALANCE_NOTIFICATION_RUSSIAN");
		}
		else
			self.autobalance_notify settext(&"PATCH_1_3_TEAMBALANCE_NOTIFICATION_GERMAN");
	}
	wait 5;
	if ( (isdefined (self)) && (isdefined (self.autobalance_notify)) )
		self.autobalance_notify destroy();
}

SetSpectatePermissions()
{
	if (isdefined(self.killcam))
		return;
	
	if ( (!isdefined (level.allowfreelook)) || (!isdefined (level.allowenemyspectate)) )
		return;
	
	freelook = true;
	if (level.allowfreelook <= 0)
		freelook = false;
	
	enemyspectate = true;
	if (level.allowenemyspectate <= 0)
		enemyspectate = false;
	
	//switch (self.pers["team"])
	switch (self.sessionteam)
	{
	case "allies":
		self allowSpectateTeam("allies", true);
		self allowSpectateTeam("axis", enemyspectate);
		self allowSpectateTeam("freelook", freelook);
		self allowSpectateTeam("none", false);
		break;
		
	case "axis":
		self allowSpectateTeam("allies", enemyspectate);
		self allowSpectateTeam("axis", true);
		self allowSpectateTeam("freelook", freelook);
		self allowSpectateTeam("none", false);
		break;
		
	default:
		self allowSpectateTeam("allies", true);
		self allowSpectateTeam("axis", true);
		self allowSpectateTeam("freelook", true);
		self allowSpectateTeam("none", true);
		break;
	}
}

SetKillcamSpectatePermissions()
{
	self allowSpectateTeam("allies", true);
	self allowSpectateTeam("axis", true);
	self allowSpectateTeam("freelook", true);
	self allowSpectateTeam("none", true);
}

UpdateSpectatePermissions()
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		players[i] thread SetSpectatePermissions();
	}
}

watchWeaponUsage()
{
	self endon("spawned");
	level endon("round_started");
	
	while(self attackButtonPressed())
		wait .05;

	while(!(self attackButtonPressed()))
		wait .05;
		
	self.usedweapons = true;
}


quickstuff(response)
{
	if(!isdefined(self.pers["team"]) || self.pers["team"] == "spectator" || isdefined(self.spamdelay) || self.sessionstate != "playing" || self.sessionteam == "spectator" || self.health <= 0 )
		return;

	self.spamdelay = true;
	switch(response)		
	{
	case "1":
		//mine
		if( self.pers["team"] == "allies" )
			self thread maps\mp\gametypes\_zombie::plantMine();
		else
			self iPrintln( "^1Zombies can't plant mines." );
		break;

	case "2":
		//deadly crate
		if( self.pers["team"] == "axis" )
			self thread maps\mp\gametypes\_zombie::placeDeadlyCrate();
		else
			self iPrintln( "^1Hunters can't plant deadly crates." );
		break;

	case "3":
		//explode
		if( self.pers["team"] == "axis" )
		{
			if( !self.boom )
			{
				self iPrintlnBold( "You can't explode any more!" );
				return;
			}
			self.boom--;
			self iPrintlnBold( self.boom + " ^1bombs ^7left." );
			self thread maps\mp\gametypes\_zombie::zombie_explode();
		}
		else
			self iPrintln("^1Hunters can't explode!");
		break;

	case "4":
		//defence bubble
		if( self.pers["team"] == "allies" )
		{
			if( self.bubble > 0 && !isDefined(self.dbubble) )
			{
				self.bubble--;
				self thread maps\mp\gametypes\_zombie::defenceBubble();
			}
			else
				self iPrintln("You don't have any defence bubbles left!");
		}
		else
			self iPrintln("^1Zombies can not deploy defence bubble.");
		break;

	case "5":
		//teleport
		if( self.pers["team"] == "allies" )
			self thread maps\mp\gametypes\_zombie::teleporter();
		else
			self iPrintln( "^1Zombies can't teleport." );
		break;

//	case "6":
//		//health pack
//		if( self.medkits > 0 )
//		{
//			self.medkits--;
//			self maps\mp\gametypes\zom::dropHealth();
//		}
//		else
//			self iPrintln( "^1You don't have any Med Kits left." );
//		break;

	case "7":
		//flashlight
		if( self.pers["team"] == "allies" && level.zom["flash_light"] )
		{
			self maps\mp\gametypes\_zombie::flashLight();
		}
		else if( self.pers["team"] == "axis" && level.zom["flash_light"] )
			self iPrintln( "^1Zombies are not allowed to use flashlight." );
		else if ( !level.zom["flash_light"] )
			self iPrintln( "^3Flash Light is not allowed on this server." );
		break;

	case "8":
		//3rd person
		self maps\mp\gametypes\_zombie::thirdPerson();
		break;

///// OPTIONS /////
	case "dynamic_shadows":
		self maps\mp\gametypes\_zombie::dynamicShadows();
		break;
	case "draw_hud":
		self maps\mp\gametypes\_zombie::drawHuds();
		break;
			
	}
	wait 0.5;
	self.spamdelay = undefined;
}