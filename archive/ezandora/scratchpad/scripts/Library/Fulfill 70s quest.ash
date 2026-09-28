void resolveWithClarabells(int [string] seen_options)
{
	if ($item[clara's bell].available_amount() == 0) //'
		return;
	if (get_property("_claraBellUsed").to_boolean())
		return;
	if (my_inebriety() > inebriety_limit()) return;
	location target_location;
	int option_picked = -1;
	item desired_item;
	if (seen_options contains "fused fuse ")
	{
		//abort("verify 70s");
		option_picked = seen_options["fused fuse "];
		desired_item = $item[fused fuse];
		target_location = $location[LavaCo&trade; Lamp Factory];
		set_property("choiceAdventure1091", 7); //FIXME learn this
	}
	/*else if (seen_options contains "half-melted hula girl ")
	{
		option_picked = seen_options["half-melted hula girl "];
		desired_item = $item[half-melted hula girl];
		target_location = $location[The Velvet / Gold Mine];
		set_property("choiceAdventure1095", -1); //FIXME learn this
	}*/
	/*else if (seen_options contains "The One Mood Ring ")
	{
		//abort("verify 70s");
		option_picked = seen_options["The One Mood Ring "];
		desired_item = $item[The One Mood Ring];
		target_location = $location[The Bubblin' Caldera]; //'
		set_property("choiceAdventure1097", -1); //FIXME learn this
	}*/
	/*else if (seen_options contains "glass ceiling fragments ")
	{
		//abort("verify 70s");
		option_picked = seen_options["glass ceiling fragments "];
		desired_item = $item[glass ceiling fragments];
		target_location = $location[The Velvet / Gold Mine];
		set_property("choiceAdventure1096", -1); //FIXME learn this
	}*/
	else
	{
		abort("implement this for " + seen_options.to_json());
	}
	
	if (option_picked > 0)
	{
		cli_execute("use clara's bell");
		int starting_adventures = my_adventures();
		while (my_adventures() > 0 && starting_adventures == my_adventures() && desired_item.available_amount() == 0)
		{
			adv1(target_location, -1, "");
		}
		if (desired_item.available_amount() > 0)
		{
			visit_url("place.php?whichplace=airport_hot&action=airport4_questhub");
			visit_url("choice.php?whichchoice=1093&option= " + option_picked);
		}
	}
}

void main()
{
	if (!get_property("hotAirportAlways").to_boolean() && !get_property("_hotAirportToday").to_boolean())
		return;
	string [int][int] choice_group_string = visit_url("place.php?whichplace=airport_hot&action=airport4_questhub").group_string("<td valign=center><b>([^<]*)</b>&nbsp;&nbsp;&nbsp;</td><td valign=center>proof: <img style='vertical-align: middle' class=hand src='[^']*' onclick='descitem.[0-9]*.' alt=\"[^\"]*\" title=\"[^\"]*\">([^<]*)</td>");
	
	int [string] seen_options;
	foreach key in choice_group_string
	{
		seen_options[choice_group_string[key][2]] = key + 1;
	}
	
	if (seen_options.count() == 0)
		return;
	
	print_html("seen_options = " + seen_options.to_json());
	
	//√New Age healing crystal (5)
	//√gooey lava globs (5)
	//√SMOOCH bottlecap
	//√smooth velvet bra (3)
	int option_picked = -1;
	if (seen_options contains "New Age healing crystal (5)")
	{
		option_picked = seen_options["New Age healing crystal (5)"];
		cli_execute("acquire 5 New Age healing crystal");
	}
	else if (seen_options contains "gooey lava globs (5)" && $item[gooey lava globs].mall_price() < 500)
	{
		option_picked = seen_options["gooey lava globs (5)"];
		cli_execute("acquire 5 gooey lava globs");
	}
	else if (seen_options contains "SMOOCH bracers (3)" && $item[Superheated metal].mall_price() < 500)
	{
		option_picked = seen_options["SMOOCH bracers (3)"];
		cli_execute("acquire 4 smooch bracers");
	}
	else if (seen_options contains "SMOOCH bottlecap" && $item[SMOOCH bottlecap].mall_price() < 2000)
	{
		option_picked = seen_options["SMOOCH bottlecap"];
		cli_execute("acquire 1 SMOOCH bottlecap");
	}
	else if (seen_options contains "smooth velvet bra (3)" && $item[unsmoothed velvet].mall_price() < 1000)
	{
		option_picked = seen_options["smooth velvet bra (3)"];
		cli_execute("acquire 4 smooth velvet bra");
	}
	else if (seen_options contains "fused fuse ")
	{
		resolveWithClarabells(seen_options);
	}
	if (option_picked > 0)
		visit_url("choice.php?whichchoice=1093&option= " + option_picked);
}