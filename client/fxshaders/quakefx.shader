
plasma_ball1
{
	entityMergable
	{
		map gfx/weapons/plasma/plasma_ball1
		blendfunc add
		rgbGen vertex
	}
}

plasma_ball2
{
	entityMergable
	{
		map gfx/weapons/plasma/plasma_ball2
		blendfunc add
		rgbGen vertex
	}
}

plasma_ball3
{
	entityMergable
	{
		map gfx/weapons/plasma/plasma_ball3
		blendfunc add
		rgbGen vertex
	}
}

impact/plasma
{
	entityMergable
	surfaceparm nonsolid
	surfaceparm trans
	polygonOffset2
	{
		map gfx/weapons/plasma/impact_plasma
		blendfunc blend
		rgbGen vertex
		nextbundle
		map $lightmap
	}
	{
		perlight
		map gfx/weapons/plasma/impact_plasma
		blendfunc GL_SRC_ALPHA GL_ONE
		rgbGen vertex
		nextbundle
		map $dlight
	}
}

rocket_fly
{
	entityMergable
	{
		map gfx/weapons/rocket/rocket_fly
		blendfunc add
		rgbGen vertex
	}
}



rocket1
{
	entityMergable
	sort	additive
    {
        map gfx/weapons/rocket/rocket1
        blendFunc GL_ONE GL_ONE
        rgbGen exactVertex
    }
}

rocket2
{
	entityMergable
	sort	additive
    {
        map gfx/weapons/rocket/rocket2
        blendFunc GL_ONE GL_ONE
        rgbGen exactVertex
    }
}

rocket3
{
	entityMergable
	sort	additive
    {
        map gfx/weapons/rocket/rocket3
        blendFunc GL_ONE GL_ONE
        rgbGen exactVertex
    }
}