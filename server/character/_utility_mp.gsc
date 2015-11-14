attachFromArray(a)
{
	self.headmodel = character\_utility::randomElement(a);
	self attach( self.headmodel, "", true );
}
