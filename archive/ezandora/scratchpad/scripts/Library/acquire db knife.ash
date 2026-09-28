

void main()
{
	if (!have_skill($skill[that's not a knife])) //'
		return;
	
	if (to_boolean(get_property("_discoKnife")))
		return;
	
	string [int] knives = split_string("boot knife,broken beer bottle,sharpened spoon,candy knife,soap knife", ",");
	foreach key in knives
	{
		string knife = knives[key];
		cli_execute("closet put * " + knife);
	}
	use_skill($skill[that's not a knife]); //'
	
	foreach key in knives
	{
		string knife = knives[key];
		cli_execute("closet take * " + knife);
	}
}