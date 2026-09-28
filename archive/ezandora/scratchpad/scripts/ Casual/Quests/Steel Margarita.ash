boolean haveUnicornItems()
{
	if (available_amount($item[gin-soaked blotter paper]) == 0) return false;
	if (available_amount($item[beer-scented teddy bear]) == 0) return false;
	if (available_amount($item[booze-soaked cherry]) == 0) return false;
	if (available_amount($item[sponge cake]) == 0) return false;
	return true;
}

void giveBandMember(string band_member_name, item i)
{
	visit_url("pandamonium.php?action=sven&bandmember=" + band_member_name + "&togive=" + to_int(i) + "&preaction=try");
}


void main()
{
	if (to_boolean(get_property("__user_casual_ascension_use_tatters")))
		return;
	if (my_level() < 6) return;
	if (get_property("questL06Friar") != "finished")
		return;
	if (get_property("questM10Azazel") == "finished")
		return;
	cli_execute("pandamonium.php");
	cli_execute("acquire 5 bus pass; acquire 5 imp air");
	cli_execute("pandamonium.php?action=moan");
	cli_execute("pandamonium.php?action=moan");

	if (available_amount($item[steel margarita]) > 0)
	{
		cli_execute("drink steel margarita");
		return;
	}
	if (available_amount($item[Azazel's lollipop]) == 0)
	{
		//Do comedy club:
		//cli_execute("call ../Outfit experience");
		//cli_execute("call ../Outfit +combat");
		cli_execute("maximize +combat -tie -equip hoa zombie eyes -familiar");
		if ($skill[musk of the moose].have_skill())
			cli_execute("cast 2 musk of the moose");
		if ($skill[Carlweather's Cantata of Confrontation].have_skill())
			cli_execute("cast 2 Carlweather's Cantata of Confrontation");
		while (available_amount($item[observational glasses]) == 0)
		{
			cli_execute("adventure 1 the laugh floor");
		}
		cli_execute("unequip weapon");
		cli_execute("equip victor, the insult comic hellhound");
		cli_execute("pandamonium.php?action=mourn&preaction=insult");
		cli_execute("equip acc1 observational glasses");
		cli_execute("pandamonium.php?action=mourn&preaction=observe");
		cli_execute("equip acc2 hilarious comedy prop");
		cli_execute("pandamonium.php?action=mourn&preaction=prop");
		//cli_execute("call ../Outfit experience");

	}
	if (available_amount($item[Azazel's unicorn]) == 0)
	{
		//Do hey deze arena:
		cli_execute("pandamonium.php?action=sven");
		cli_execute("pandamonium.php?action=sven&preaction=help");
		//We need to adventure until we hit a noncombat.
		//Cheat:
		string page = visit_url("pandamonium.php?action=sven");
		if (!contains_text(page, "Give Items") || !haveUnicornItems())
		{
			//cli_execute("call ../Outfit experience");
			//cli_execute("call ../Outfit -combat");
			
			cli_execute("uneffect musk of the moose");
			cli_execute("uneffect Carlweather's Cantata of Confrontation");
			if ($skill[smooth movement].have_skill())
				cli_execute("cast 2 smooth movement");
			if ($skill[the sonata of sneakiness].have_skill())
				cli_execute("cast 2 sonata of sneakiness");
			cli_execute("maximize -combat -tie -familiar");
			boolean finished = false;
			while (!finished)
			{
				cli_execute("restore hp; restore mp");
				adv1($location[Infernal Rackets Backstage], -1, "");
				/*string adventure_results = visit_url("adventure.php?snarfblat=243");
				if (contains_text(adventure_results, "You're fighting"))
					run_combat();
				else
				{
				}*/
				if (haveUnicornItems())
					finished = true;
			}
		}
		//print("you should visit sven");
		if (haveUnicornItems())
		{
			giveBandMember("Bognort", $item[gin-soaked blotter paper]);
			giveBandMember("Stinkface", $item[beer-scented teddy bear]);
			giveBandMember("Flargwurm", $item[booze-soaked cherry]);
			giveBandMember("Jim", $item[sponge cake]);
		}
	}
	cli_execute("pandamonium.php?action=temp");
	if (available_amount($item[steel margarita]) > 0)
	{
		cli_execute("drink steel margarita");
	}
}