boolean spading_signal = false;
void main()
{
	if (my_inebriety() > inebriety_limit())
		return;
	if ($familiar[reagnimated gnome].have_familiar() && $item[gnomish housemaid's kgnee].available_amount() > 0) //'
	{
		cli_execute("familiar reagnimated gnome");
	}
	else if ($familiar[disembodied hand].have_familiar())
		cli_execute("familiar disembodied hand");
	string maximisation_string = "maximize 1000.0 fishing skill 1.0 combat -tie -equip Drunkula's Wineglass";
	
	if (spading_signal)
		maximisation_string += " +equip signal receiver";
	if ($item[mafia thumb ring].available_amount() > 0)
		maximisation_string += " +equip mafia thumb ring";
	if ($item[pantsgiving].available_amount() > 0)
		maximisation_string += " +equip pantsgiving";
	cli_execute(maximisation_string);
	if (my_familiar() == $familiar[reagnimated gnome])
		cli_execute("equip gnomish housemaid's kgnee");
	//FIXME pantsgiving
	set_auto_attack(1); //attack with weapon; speed up fight.php
	
	
		
	location target_location;
	
	if (get_property("questL09Topping") != "unstarted")
		target_location = $location[the smut orc logging camp];
	else if (true)
	{
		//avoid spooky forest, because we don't want to trip the semi-rare there
		target_location = $location[whitey's grove]; //'
	}
	else
	{
		if (true)
		{
			//Collect spooky-gro fertilizer:
			set_property("choiceAdventure502", 3);
			set_property("choiceAdventure506", 2);
		}
		target_location = $location[the spooky forest];
	}
	
	
	while (my_adventures() > 0)
	{
		//if (!spading_signal && false)
			//cli_execute("call CheckKramcoSpading.ash");
		if (target_location == $location[none])
			break;
		if (target_location == $location[whitey's grove]) //'
			cli_execute("scripts/gain.ash 15 combat rate 1 eff silent " + my_adventures() + " turns");
		if (my_familiar() == $familiar[reagnimated gnome] && $slot[familiar].equipped_item() == $item[gnomish housemaid's kgnee]) //'
			cli_execute("scripts/gain.ash familiar weight 1 eff silent " + my_adventures() + " turns");
			
		adv1(target_location, -1, "");
	}
	set_auto_attack(0);
}