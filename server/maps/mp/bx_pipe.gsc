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
	maps\mp\_load::main();

	//setCullFog (0, 8000, .32, .36, .40, 0);
	ambientPlay("bxpipe");
	
	game["allies"] = "american";
	game["axis"] = "german";

	game["american_soldiertype"] = "airborne";
	game["american_soldiervariation"] = "normal";
	game["german_soldiertype"] = "wehrmacht";
	game["german_soldiervariation"] = "normal";

	game["layoutimage"] = "bx_pipe";

	precacheShader("white");

	thread trigger();
}

trigger()
{

	bottom = getent("bottom", "targetname");
	bottom thread teleport();

}

teleport()
{
	if(getCvar("g_gametype") == "dm")
		spawnpoints = getentarray("mp_teamdeathmatch_spawn", "classname");
	else
		spawnpoints = getentarray("mp_deathmatch_spawn", "classname");

	while(1)
	{
		self waittill("trigger", player);
		if(player.sessionstate == "playing")
		{
			if( isDefined( player.pers["team"] ) && player.pers["team"] == "allies" )
			{
				player.health += 10;
				if( player.health > player.maxhealth )
					player.health = player.maxhealth;
			}

			num = randomInt(spawnpoints.size);
			player setOrigin(spawnpoints[num].origin);
			player thread flash();
		}
		wait 0.1;
	}
}

flash()
{
	self endon( "disconnect" );
	if(isDefined(self.spawnhud))	self.spawnhud destroy();

	self.spawnhud = newClientHudElem(self);
	self.spawnhud.x = 0;
	self.spawnhud.y = 0;
	self.spawnhud.alignX = "left";
	self.spawnhud.alignY = "top";
	self.spawnhud.alpha = 1;
	self.spawnhud.sort = -70;
	self.spawnhud setShader("white", 640, 480 );
	self.spawnhud FadeOverTime( 1.41 );
	self.spawnhud.alpha = 0;
	wait 1.41;

	if(isDefined(self.spawnhud))	self.spawnhud destroy();
}