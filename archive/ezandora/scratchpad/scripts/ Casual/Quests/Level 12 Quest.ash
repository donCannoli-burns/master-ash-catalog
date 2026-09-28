void doSneakyAdventure(string area)
{	
	if (have_effect($effect[fresh scent]) == 0)
		cli_execute("use 1 chunk of rock salt");
	if (have_effect($effect[Smooth Movements]) == 0)
		cli_execute("cast smooth movement");
	if (have_effect($effect[Sonata of Sneakiness]) == 0)
		cli_execute("cast sonata");
	cli_execute("adventure 1  " + area);
}

void sneakyAdventure(item target_item, string area)
{
	while (available_amount(target_item) == 0)
	{
		doSneakyAdventure(area);
	}
}

void main()
{
	if (my_level() < 12) return;
	if (get_property("questL12War") == "finished")
		return;

	if (!contains_text(visit_url("questlog.php?which=1"), "Make War, Not... Oh, Wait"))
	{
		return;
	}
	if (my_basestat($stat[mysticality]) < 70) //need round purple sunglasses
		return;

	if (contains_text(visit_url("questlog.php?which=1"), "The Council has gotten word of tensions building between the hippies and the frat boys on the Mysterious Island of Mystery."))
	{
		//Start war:
		cli_execute("set choiceAdventure143 = 3"); //Catching Some Zetas
		//cli_execute("set choiceAdventure145 = 3"); //Fratacombs?
		cli_execute("set choiceAdventure144 = 3"); //One Less Room Than In That Movie
		cli_execute("call ../Outfit experience");
		cli_execute("call ../Outfit -combat");
		cli_execute("outfit war hippy fatigues");
		while (contains_text(visit_url("questlog.php?which=1"), "The Council has gotten word of tensions building between the hippies and the frat boys on the Mysterious Island of Mystery."))
		{
			doSneakyAdventure("frat house");
		}
	}
	if (my_adventures() < 30) return;
	if (contains_text(visit_url("questlog.php?which=1"), "You've managed to get the war between the hippies and frat boys started, and now the Council wants you to finish it."))
	{
		//complicated
		cli_execute("outfit war hippy fatigues");
		//
		//cli_execute("bigisland.php?place=farm&action=farmer");
		//cli_execute("bigisland.php?place=nunnery&action=nuns");
		//Try to do sidequests
		//And adventure on the battlefield
		//Then defeat... The Man!

		if (get_property("sidequestOrchardCompleted") == "none")
		{
			//Do sidequest:
			cli_execute("call ../Outfit items");
			while (available_amount($item[filthworm hatchling scent gland]) == 0)
				cli_execute("adventure 1 hatching chamber");
			cli_execute("use filthworm hatchling scent gland");

			while (available_amount($item[filthworm drone scent gland]) == 0)
				cli_execute("adventure 1 feeding chamber");
			cli_execute("use filthworm drone scent gland");

			while (available_amount($item[filthworm royal guard scent gland]) == 0)
				cli_execute("adventure 1 guards' chamber");
			cli_execute("use filthworm royal guard scent gland");
			cli_execute("call ../Outfit experience");
			cli_execute("adventure 1 queen's chamber");
			cli_execute("outfit war hippy fatigues");
			cli_execute("bigisland.php?place=orchard&action=stand");
			cli_execute("bigisland.php?place=orchard&action=stand");
		}
		if (get_property("sidequestNunsCompleted") == "none")
		{
			cli_execute("outfit war hippy fatigues");
			cli_execute("unequip round purple sunglasses");
			cli_execute("equip acc3 round purple sunglasses");
			cli_execute("familiar scarecrow");
			cli_execute("maximize meat -hat -pants -acc3");
			cli_execute("summon 2");
			cli_execute("use mick's icyvapohotness inhaler");
			cli_execute("uneffect phat loot; uneffect sonata");
			cli_execute("cast 2 polka of plenty");
			cli_execute("use 2 knob goblin nasal spray");
			cli_execute("adventure * themthar hills");
			cli_execute("bigisland.php?place=nunnery");
			
		}
		if (get_property("sidequestFarmCompleted") == "none")
		{
			cli_execute("call ../Outfit experience");
			cli_execute("ccs chaosbutterfly");
			cli_execute("adventure 2 barn");
			cli_execute("call Library/switch to stringozzi serpent combat script.ash");
			cli_execute("adventure * barn");
			cli_execute("adventure 5 pond");
			cli_execute("adventure 5 back 40");
			cli_execute("adventure 5 other back 40");
			cli_execute("outfit war hippy fatigues");
			cli_execute("bigisland.php?place=farm&action=farmer");
			cli_execute("bigisland.php?place=farm&action=farmer");
		}
		if (get_property("sidequestOrchardCompleted") != "hippy" || get_property("sidequestNunsCompleted") != "hippy" || get_property("sidequestFarmCompleted") != "hippy") //internal checking
			return;
		cli_execute("call ../Outfit experience");
		cli_execute("outfit war hippy fatigues");

		cli_execute("call Library/switch to stringozzi serpent combat script no runaways.ash");
		while (to_int(get_property("fratboysDefeated")) < 64)
			cli_execute("adventure 1 battlefield (hippy uniform)");
		cli_execute("call Library/switch to stringozzi serpent combat script.ash");
		//sidequestLighthouseCompleted
		if (get_property("sidequestLighthouseCompleted") == "none")
		{
			cli_execute("call ../Outfit +combat");
			cli_execute("outfit war hippy fatigues");
			cli_execute("ccs photocopylobsters");
			while (available_amount($item[spooky putty monster]) == 0)
				cli_execute("adventure 1 wartime sonofa beach");
			cli_execute("use spooky putty monster");
			cli_execute("use spooky putty monster");
			cli_execute("use spooky putty monster");
			cli_execute("use spooky putty monster");
			cli_execute("call Library/switch to stringozzi serpent combat script.ash");
			cli_execute("use spooky putty monster");
			cli_execute("bigisland.php?place=lighthouse&action=pyro");
			cli_execute("bigisland.php?place=lighthouse&action=pyro");
			cli_execute("bigisland.php?place=lighthouse&action=pyro");

		}
		if (get_property("sidequestLighthouseCompleted") != "hippy")
			return;

		cli_execute("call Library/switch to stringozzi serpent combat script no runaways.ash");
		while (to_int(get_property("fratboysDefeated")) < 192)
			cli_execute("adventure 1 battlefield (hippy uniform)");
		cli_execute("call Library/switch to stringozzi serpent combat script.ash");

		if (my_adventures() < 30) return;
		//Junkyard
		if (get_property("sidequestJunkyardCompleted") == "none")
		{
			cli_execute("outfit war hippy fatigues");
			cli_execute("bigisland.php?action=junkman");
			if (available_amount($item[molybdenum magnet]) == 0) //internal error
				return;
			cli_execute("maximize hp -tie");
			cli_execute("acquire 2 crystal skull; acquire seal tooth");

			if (to_boolean(get_property("__user_casual_ascension_use_tatters")))
				cli_execute("autoattack junkyardwithtatters");
			else
				cli_execute("autoattack junkyardwithouttatters");

			int turn_limit = 15;
			int turns = 0;
			while (available_amount($item[molybdenum crescent wrench]) == 0 && turns < turn_limit)
			{
				cli_execute("adventure 1 over where the old tires are");
				turns = turns + 1;
			}
			if (turns == turn_limit)
			{
				print("error hit limit");
				return;
			}

			turns = 0;
			while (available_amount($item[molybdenum pliers]) == 0 && turns < turn_limit)
			{
				cli_execute("adventure 1 near an abandoned refrigerator");
				turns = turns + 1;
			}
			if (turns == turn_limit)
			{
				print("error hit limit");
				return;
			}

			turns = 0;
			while (available_amount($item[molybdenum hammer]) == 0 && turns < turn_limit)
			{
				cli_execute("adventure 1 next to that barrel");
				turns = turns + 1;
			}
			if (turns == turn_limit)
			{
				print("error hit limit");
				return;
			}

			turns = 0;
			while (available_amount($item[molybdenum screwdriver]) == 0 && turns < turn_limit)
			{
				cli_execute("adventure 1 out by that rusted-out car");
				turns = turns + 1;
			}
			if (turns == turn_limit)
			{
				print("error hit limit");
				return;
			}

			cli_execute("autoattack none");

			cli_execute("outfit war hippy fatigues");
			cli_execute("bigisland.php?action=junkman");
			cli_execute("bigisland.php?action=junkman");
			
		}
		if (get_property("sidequestJunkyardCompleted") != "hippy")
			return;
		if (my_adventures() < 30) return;


		cli_execute("autoattack none");
		cli_execute("call ../Outfit experience");
		cli_execute("outfit war hippy fatigues");
		cli_execute("call Library/switch to stringozzi serpent combat script no runaways.ash");
		while (to_int(get_property("fratboysDefeated")) < 458)
			cli_execute("adventure 1 battlefield (hippy uniform)");
		cli_execute("call Library/switch to stringozzi serpent combat script.ash");

		//Arena
		if (get_property("sidequestArenaCompleted") == "none")
		{
			cli_execute("bigisland.php?place=concert");
			if (available_amount($item[empty agua de vida bottle]) == 0)
			{
				cli_execute("display take 1 empty agua de vida bottle");
			}
			if (available_amount($item[jam band flyers]) == 0)
				return;
			if (to_int(get_property("flyeredML")) < 10000)
			{
				cli_execute("acquire green smoke bomb");
				cli_execute("ccs flyercyrus");
				if (get_property("questF01Primordial") == "unstarted")
				{
					cli_execute("set choiceAdventure350 = 1");
					//fix:
					//cli_execute("use 3 memory of some delicious amino acids");
					//cli_execute("adventure 4 primordial soup");
					cli_execute("adventure 3 primordial soup");
					cli_execute("set choiceAdventure349 = 3");
					cli_execute("adventure 1 primordial soup; use memory of some delicious amino acids");
					cli_execute("set choiceAdventure349 = 1");
					cli_execute("adventure 1 primordial soup");
					string old_clover_protect = get_property("cloverProtectActive"); 
					set_property("cloverProtectActive", "false");

					cli_execute("acquire ten-leaf clover; adventure 1 primordial soup");
					set_property("cloverProtectActive", old_clover_protect);
					cli_execute("use 2 memory of some delicious amino acids");
					cli_execute("adventure 1 primordial soup");
				}
			}
			cli_execute("call Library/switch to stringozzi serpent combat script.ash");
			cli_execute("bigisland.php?place=concert");
			cli_execute("bigisland.php?place=concert");
			
		}
		if (get_property("sidequestArenaCompleted") != "hippy")
			return;
		if (my_adventures() < 30) return;

		cli_execute("call Library/switch to stringozzi serpent combat script no runaways.ash");
		while (to_int(get_property("fratboysDefeated")) < 1000)
			cli_execute("adventure 1 battlefield (hippy uniform)");
		cli_execute("call Library/switch to stringozzi serpent combat script.ash");
		cli_execute("restore hp; restore mp");
		cli_execute("bigisland.php?place=camp&whichcamp=2");
		cli_execute("bigisland.php?action=bossfight");
		run_combat();
	}



	cli_execute("council.php");
}