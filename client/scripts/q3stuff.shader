// Q3Mod Stuff |
//-------------+

//Plasma Gun
skins/plasma_glow
{
	{
		map skins/plasma_glow.tga
		tcMod scroll 0 1
		rgbGen identity
	}
}

skins/plasma_glass
{
	{
		map textures/effects/envmap.tga
		tcGen environment
		blendfunc GL_ONE GL_ONE
		rgbGen lightingDiffuse
	}
}

gfx/railgun11
{
	{
		map gfx/railgun.tga
		blendfunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		rgbGen identity
	}
}


skins/railgun2
{
	sort additive
	cull disable
	{
		map	skins/railgun2glow.tga
		blendfunc GL_ONE GL_ONE
		rgbGen entity	// identity
	}
}

skins/railgun3
{
	{
		map	skins/railgun3.tga
		rgbGen lightingDiffuse				
	}

	{
		map	skins/railgun3glow.tga
		blendfunc GL_ONE GL_ONE
		rgbGen entity	// identity
	}
}

skins/railgun4
{
	{
		map skins/railgun4.tga
		tcMod scroll 0 1
		rgbGen entity	// identity
	}

}


skins/redenergy
{

	{
		map skins/redenergy.tga 
		blendFunc GL_ONE GL_ONE
		tcMod scroll 1 1.3
	}

}

//Crosshair
gfx/hud/quake_crosshair
{
	nopicmip
	{
		map gfx/hud/quake_crosshair.tga            
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		rgbGen identity
	}       
}


skins/ring1
{
	sort additive
	{
		map skins/ring02_1.tga
		rgbGen oneMinusEntity
		blendfunc GL_ONE GL_ONE
	}
	{
		map skins/ring02_2.tga
		rgbGen oneMinusEntity
		blendfunc GL_ONE GL_ONE
	}
	{
		map skins/ring02_3.tga
		rgbGen oneMinusEntity
		blendfunc GL_ONE GL_ONE
	}
	{
		map skins/ring02_4.tga
		rgbGen oneMinusEntity
		blendfunc GL_ONE GL_ONE
	}
	cull disable
}