gfx/zombie_vision
{
	{
		map $whiteImage
		rgbgen constLighting ( 0.11 0 0 )
		alphaGen wave sin 0.5 0.5 0.5 .3
		blendFunc GL_SRC_ALPHA GL_ONE
	}
}