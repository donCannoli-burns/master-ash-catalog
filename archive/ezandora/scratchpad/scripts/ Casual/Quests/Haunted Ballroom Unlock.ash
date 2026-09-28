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
		if (have_effect($effect[Chalky Hand]) == 0 && area == "haunted billiards room")
			cli_execute("use handful of hand chalk");
		doSneakyAdventure(area);
	}
}

int freeRunawaysRemaining()
{
	int current_runaways = to_int(get_property("_banderRunaways"));
	int available_runaways = (weight_adjustment() + familiar_weight($familiar[stomping boots])) / 5;
	if (current_runaways >= available_runaways)
		return 0;
	return available_runaways - current_runaways;
}

void doFreeRunawayAdventure(string area)
{
	cli_execute("familiar stomping boots");
	cli_execute("maximize familiar weight -tie");
	if (have_effect($effect[Heavy Petting]) == 0)
		cli_execute("use knob goblin pet-buffing spray");
	if (freeRunawaysRemaining() == 0)
	{
		cli_execute("call ../Outfit experience");
	}
	else
	{
		cli_execute("autoattack runaway");
	}

	cli_execute("adventure 1 " + area);
	cli_execute("autoattack none");
}

void main()
{
	//unlock pantry:
	while (!contains_text(visit_url("town_right.php"), "manor.php"))
	{
		doFreeRunawayAdventure("haunted pantry");
		//cli_execute("adventure 1 haunted pantry");
	}

	//Unlock Library:
	if (available_amount($item[spookyraven library key]) == 0)
	{
		cli_execute("call ../Outfit experience");
		cli_execute("call ../Outfit -combat");
		cli_execute("call ../Outfit -combat");
		cli_execute("call Library/switch to cannelloni combat script.ash");
		cli_execute("call Library/UseHipster.ash");
		sneakyAdventure($item[spookyraven library key], "haunted billiards room");
	}
	//Unlock gallery:
	boolean should_unlock_gallery = false;
	if (my_class() == $class[seal clubber] || my_class() == $class[turtle tamer])
		should_unlock_gallery = true;
	if (should_unlock_gallery && available_amount($item[spookyraven gallery key]) == 0 && available_amount($item[spookyraven library key]) > 0)
	{
		cli_execute("call Library/unlock haunted gallery.ash");

	}
	
	//Unlock Upstairs:
	if (available_amount($item[spookyraven library key]) > 0 && to_int(get_property("lastSecondFloorUnlock")) < my_ascensions())
	{
		cli_execute("call ../Outfit experience");
		cli_execute("call ../Outfit -combat");
		cli_execute("set choiceAdventure80 = 99");
		cli_execute("set choiceAdventure81 = 99");
		//while (to_int(get_property("lastSecondFloorUnlock")) < my_ascensions())
		while (!contains_text(visit_url("manor2.php"), "manor2.php"))
		{
			doSneakyAdventure("haunted library");
		}
		//how to do this... hmm
		//Doing nothing, 80 = 4, 81 = 4, 87 = 2
		//Unlock second floor, 80 = 99, 81 = 99, 87 = 2
		//Reveal key, 80 = 99, 81 = 1, 87 = 2
	}


	//Unlock ballroom:
	if (available_amount($item[spookyraven ballroom key]) == 0)
	{
		if (to_int(get_property("lastSecondFloorUnlock")) >= my_ascensions())
		{
			//Second floor unlocked.
			cli_execute("call ../Outfit experience");
			cli_execute("call ../Outfit -combat");
			cli_execute("call Library/switch to stringozzi serpent combat script.ash");

	
			boolean step_one_done = false;
			boolean finished = false;
			while (!finished)
			{
				if (have_effect($effect[fresh scent]) == 0)
					cli_execute("use 1 chunk of rock salt");
				if (have_effect($effect[Smooth Movements]) == 0)
					cli_execute("cast smooth movement");
				if (have_effect($effect[Sonata of Sneakiness]) == 0)
					cli_execute("cast sonata");
				if (have_effect($effect[Fishy Fortification]) == 0)
					cli_execute("use fish liver oil");
				if (have_effect($effect[Standard Issue Bravery]) == 0)
					cli_execute("use CSA bravery badge");

				cli_execute("restore hp; restore mp");
				string adventure_results = visit_url("adventure.php?snarfblat=108");
				if (contains_text(adventure_results, "You're fighting"))
					run_combat();
				else if (contains_text(adventure_results, "the Haunted Bedroom of Spookyraven Manor, you find a fine mahogany nightstand."))
				{
					visit_url("choice.php?whichchoice=83&option=2");
					run_combat();
				}
				else if (contains_text(adventure_results, "In the Haunted Bedroom, you encounter an ornately carved nightstand."))
				{
					if (available_amount($item[Lord Spookyraven's spectacles]) == 0)
						visit_url("choice.php?whichchoice=84&option=3");
					else
						visit_url("choice.php?whichchoice=84&option=2");
				}
				else if (contains_text(adventure_results, "In the Haunted Bedroom, you come across a simple white nightstand."))
				{
					visit_url("choice.php?whichchoice=82&option=3");
					run_combat();
				}
				else if (contains_text(adventure_results, "In the Haunted Bedroom, you find a simple wooden nightstand, the top of which is covered with what seem to be piles of cheap costume jewelry."))
				{
					if (!step_one_done)
					{
						visit_url("choice.php?whichchoice=85&option=1");
						step_one_done = true;
					}
					else
					{
						visit_url("choice.php?whichchoice=85&option=2");
						finished = true;
					}
				}

			}
		}
	}

}