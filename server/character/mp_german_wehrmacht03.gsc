// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("xmodel/playerbody_german_wehrmacht");
	character\_utility_mp::attachFromArray(xmodelalias\head_axis::main());
	self.hatModel = "xmodel/germanhelmet";
	self attach(self.hatModel);
	self setViewmodel("xmodel/viewmodel_hands_whermact");
	self.voice = "american";
}

precache()
{
	precacheModel("xmodel/playerbody_german_wehrmacht");
	character\_utility::precacheModelArray(xmodelalias\head_axis::main());
	precacheModel("xmodel/germanhelmet");
	precacheModel("xmodel/viewmodel_hands_whermact");
}
