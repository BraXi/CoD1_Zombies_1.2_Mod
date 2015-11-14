skins/mine_trigger
{
	surfaceparm metal
	nofog
	{
		map skins/mine_trigger
//		rgbGen identity
//		alphaGen wave sin 1 1 2 2
//		blendFunc GL_SRC_ALPHA GL_ONE

		rgbGen lightingDiffuse
//		rgbGen exactVertex
		tcmod scroll 0 -1
		rgbgen constLighting ( 0.7 0 0.9 )
		alphaGen const .5
		blendfunc blend
	}
}
