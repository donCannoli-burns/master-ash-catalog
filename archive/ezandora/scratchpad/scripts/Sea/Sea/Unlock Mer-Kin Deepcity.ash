void doSneakyAdventure(string area)
{	
	if (have_effect($effect[fresh scent]) == 0)
		cli_execute("use 1 chunk of rock salt");
	if (have_effect($effect[Smooth Movements]) == 0)
		cli_execute("cast smooth movement");
	if (have_effect($effect[the Sonata of Sneakiness]) == 0)
		cli_execute("cast sonata");
	cli_execute("adventure 1  " + area);
}

void trainLasso()
{
	if (to_int(get_property("__user_last_expert_lasso_ascension")) == my_ascensions())
		return;
	//One tricky problem is mafia doesn't track our lasso level yet.
	//Which means we have to do it ourselves...
	//Which I don't really like.
	//We do this by calling adventure.php directly with visit_url, running run_combat() when appropriate, and checking it for "and expertly toss it over the"	
	//We only do this in the starting area, to vastly simplify things.
	cli_execute("ccs sea train lasso");
	cli_execute("outfit I blame... the sea");
	cli_execute("equip sea cowboy hat");
	cli_execute("equip sea chaps");
	//cli_execute("equip acc3 makeshift scuba gear");
	cli_execute("equip old scuba tank");
	cli_execute("unequip octopus's spade");

	print("Training lasso");
	while (to_int(get_property("__user_last_expert_lasso_ascension")) != my_ascensions())
	{
		cli_execute("acquire 3 sea lasso");
		cli_execute("restore hp;");// restore mp");
		string adventure_text = visit_url("adventure.php?snarfblat=190");
		string combat_text = run_combat();
		if (contains_text(combat_text, "and expertly toss it over the"))
		{
			set_property("__user_last_expert_lasso_ascension", to_string(my_ascensions()));
		}
	}
	
	

	cli_execute("outfit I blame... the sea");
	cli_execute("ccs helix fossil");
}

void doNextStepInSeaFloor()
{
	if (contains_text(visit_url("sea_merkin.php?seahorse=1"), "you crest an undersea ridge and discover, spread out beneath you, a magnificent Mer-kin City"))
		return;
	string seafloor_text = visit_url("seafloor.php");
	string monkeycastle_text = visit_url("monkeycastle.php");
	if (contains_text(seafloor_text, "The Coral Corral")) //coral corral present
	{
		//Wrangle us a seahorse:
		//may need to do this by hand? maybe not
		cli_execute("ccs sea wrangle a seahorse");
		cli_execute("acquire louder than bomb; acquire crystal skull; acquire pulled indigo taffy");
		while (!contains_text(visit_url("sea_merkin.php?seahorse=1"), "you crest an undersea ridge and discover, spread out beneath you, a magnificent Mer-kin City"))
		{
			//cli_execute("adventure 1 coral corral");
			cli_execute("restore hp; mood execute;"); //restore mp;
			string adventure_text = visit_url("adventure.php?snarfblat=199");
			run_combat();
		}
		cli_execute("ccs helix fossil");
	}
	else if (contains_text(seafloor_text, "seafloor.php?action=currents")) //intense currents present, unlock the coral (safety feature)
	{
		cli_execute("grandpa currents");
	}
	else if (contains_text(seafloor_text, "The Mer-Kin Outpost")) //outpost present?
	{
		print("Outpost is buggy, proceed at your own risk.", "red");
		//return;
		cli_execute("outfit I blame... the sea");
		while (available_amount($item[mer-kin lockkey]) == 0 && available_amount($item[Mer-kin trailmap]) == 0 && available_amount($item[Mer-kin stashbox]) == 0)
		{
			//Find a key.
			cli_execute("adventure 1 mer-kin outpost");
			if (available_amount($item[mer-kin lockkey]) == 1)
			{
				set_property("__user_lockkey_dropped_from", to_string(last_monster()));
				set_property("__user_lockkey_dropped_from_ascension", to_string(my_ascensions()));
			}
		}
		//Do noncombat:
		if (available_amount($item[mer-kin lockkey]) == 0)
			return;
		
		//We don't save our current second_choice because honestly

		cli_execute("equip ring of conflict");
		int second_choice = 1;
		while (!(available_amount($item[Mer-kin trailmap]) > 0 || available_amount($item[Mer-kin stashbox]) > 0))
		{
			if (to_int(get_property("__user_lockkey_dropped_from_ascension")) != my_ascensions())
				return;

			int first_choice = 0;
			int first_choice_leads_to = 0;
			if (get_property("__user_lockkey_dropped_from") == "Mer-kin burglar")
			{
				first_choice = 1;
				first_choice_leads_to = 313;
			}
			else if (get_property("__user_lockkey_dropped_from") == "Mer-kin raider")
			{
				first_choice = 2;
				first_choice_leads_to = 314;
			}
			else if (get_property("__user_lockkey_dropped_from") == "Mer-kin healer")
			{
				first_choice = 3;
				first_choice_leads_to = 315;
			}
			else
			{
				print("Unknown lockkey source");
			}
			cli_execute("restore hp;");// restore mp");

			if (have_effect($effect[fresh scent]) == 0)
				cli_execute("use 1 chunk of rock salt");
			if (have_effect($effect[Smooth Movements]) == 0)
				cli_execute("cast smooth movement");
			if (have_effect($effect[the Sonata of Sneakiness]) == 0)
				cli_execute("cast sonata");
			string adventure_text = visit_url("adventure.php?snarfblat=198");
			if (contains_text(adventure_text, "You're fighting"))
				run_combat();
			else
			{
				if (contains_text(adventure_text, "Into the Outpost"))
				{
					visit_url("choice.php?whichchoice=312&option=" + first_choice);
					visit_url("choice.php?whichchoice=" + first_choice_leads_to + "&option=" + second_choice);
					second_choice = second_choice + 1;
					if (second_choice > 4)
					{
						print("internal error");
						return;
					}
					visit_url("main.php");
				}
			}
		}
		if (available_amount($item[Mer-kin stashbox]) > 0)
		{
			cli_execute("use mer-kin stashbox");
		}
		if (available_amount($item[Mer-kin trailmap]) > 0)
		{
			cli_execute("use mer-kin trailmap");
		}

		cli_execute("grandpa currents");
	}
	else if (contains_text(monkeycastle_text, "monkeycastle.php?who=2")) //big brother rescued?
	{
		cli_execute("monkeycastle.php?who=2");
		cli_execute("monkeycastle.php?who=1");
		if (available_amount($item[sushi-rolling mat]) == 0)
		{
			//buy one for next ascension
			cli_execute("acquire 50 sand dollar");
			cli_execute("monkeycastle.php?action=buyitem&whichitem=3581&quantity=1");
		}
		if (contains_text(visit_url("questlog.php?which=1"), "An Old Guy and The Ocean"))
		{
			if (available_amount($item[damp old boot]) == 0)
			{
				//acquire boot:
				cli_execute("acquire 50 sand dollar");
				cli_execute("monkeycastle.php?action=buyitem&whichitem=3471&quantity=1");
				cli_execute("place.php?whichplace=sea_oldman&action=oldman_oldman");
				cli_execute("place.php?whichplace=sea_oldman&action=oldman_oldman&preaction=pickreward&whichreward=6313");
				cli_execute("use * damp old wallet");
			}
		}
		cli_execute("swim sprints");
		//go find grandpa
		string area = "";

		if (my_class() == $class[Seal Clubber] || my_class() == $class[Turtle Tamer])
			area = "Anemone Mine";
		if (my_class() == $class[Pastamancer] || my_class() == $class[Sauceror])
			area = "The Marinara Trench";
		if (my_class() == $class[Disco Bandit] || my_class() == $class[Accordion Thief])
			area = "The Dive Bar";
		while (!contains_text(visit_url("monkeycastle.php"), "monkeycastle.php?who=3"))
		{
			doSneakyAdventure(area);
		}
		//ask him about grandma:
		cli_execute("grandpa grandma");
	}
	else if (contains_text(monkeycastle_text, "monkeycastle.php?who=1")) //little brother rescued?
	{
		cli_execute("monkeycastle.php?who=1");
		//go rescue big brother
		cli_execute("equip ring of conflict");
		cli_execute("set choiceAdventure299 = 1");
		while (!contains_text(visit_url("monkeycastle.php"), "monkeycastle.php?who=2"))
		{
			doSneakyAdventure("the wreck of the edgar fitzsimmons");
		}
	}
	else
	{
		//let's go rescue little brother
		while (available_amount($item[wriggling flytrap pellet]) == 0 && !(contains_text(visit_url("monkeycastle.php"), "monkeycastle.php?who=1")))
		{
			cli_execute("adventure 1 an octopus's garden"); //in the shade
		}
		cli_execute("use wriggling flytrap pellet");
	}
}

void main()
{
	cli_execute("mood iblame...thesea");
	cli_execute("outfit I blame... the sea");
	cli_execute("familiar grouper groupie");
	//cli_execute("familiar adorable space buddy");
	cli_execute("oldman.php?action=talk");
	cli_execute("equip familiar li'l business");
	cli_execute("acquire 3 sea cowbell");
	cli_execute("acquire 4 sea lasso");
	cli_execute("acquire 15 volcanic ash");
	cli_execute("acquire 30 crayon shavings");
	cli_execute("use * fishy pipe");
	cli_execute("friars familiar");
	cli_execute("ccs helix fossil");
	
	//cast ode to booze; drink 1 bottle of pete's sake; create 3 slick maki; drink 1 pumpkin beer

	//tricky
	if (my_level() < 11) return;
	if (get_property("questL13Final") != "finished")
		return;
	if (contains_text(visit_url("sea_merkin.php?seahorse=1"), "you crest an undersea ridge and discover, spread out beneath you, a magnificent Mer-kin City"))
		return;
	//How to do this?
	//Well, the hardest part is training the lasso, because mafia doesn't track that yet.
	//The code structure is essentially the same as the castle - we start at the Coral Corral and work backwards until we find a spot we can go to.
	
	trainLasso();
	doNextStepInSeaFloor(); //octopus's garden
	doNextStepInSeaFloor(); //rescue big brother
	doNextStepInSeaFloor(); //find grandpa
	//doNextStepInSeaFloor(); //acquire lock-key
	doNextStepInSeaFloor(); //acquire stashbox
	doNextStepInSeaFloor(); //wrangle a horse
}