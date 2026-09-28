void run_combat_replacement()
{
    int breakout = 11;
    while (breakout >= 0)
    {
        buffer page_text = visit_url("main.php");
        if (page_text.contains_text("choice.php"))
        {
            //Evaluate choice:
            cli_execute("choice-goal");
        }
        else
        {
            run_combat();
            break;
        }
        breakout -= 1;
    }
}


void listAppend(location [int] list, location entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

boolean __did_minus_combat_maximization = false;
void upkeepMinusCombat()
{
	if ($effect[the sonata of sneakiness].have_effect() == 0 && $skill[the sonata of sneakiness].have_skill())
		cli_execute("cast sonata");
	if ($effect[smooth movements].have_effect() == 0 && $skill[smooth movement].have_skill())
		cli_execute("cast smooth movement");
	
	if (!__did_minus_combat_maximization)
	{
		if ($item[pantsgiving].available_amount() > 0)
			cli_execute("maximize moxie -familiar -tie +equip pantsgiving -equip papier-m&acirc;ch&eacute;te");
		else
			cli_execute("maximize moxie -familiar -tie -equip papier-m&acirc;ch&eacute;te");
			
		/*if ($item[navel ring of navel gazing].available_amount() > 0)
			cli_execute("maximize -familiar -combat -tie -equip silent beret +equip navel ring of navel gazing");
		else*/
			cli_execute("maximize -familiar -combat -tie -equip silent beret");
		__did_minus_combat_maximization = true;
	}
}

buffer try_throw_items(item it1, item it2)
{
	if ($skill[Ambidextrous Funkslinging].have_skill())
		return throw_items(it1, it2);
	else
		return throw_item(it1);
}

void disAdventure(location l)
{
	int snarfblat = -1;
	if (l == $location[The Clumsiness Grove])
		snarfblat = 277;
	else if (l == $location[The Glacier of Jerks])
		snarfblat = 279;
	else if (l == $location[The Maelstrom of Lovers])
		snarfblat = 278;
	
	if (snarfblat == -1)
		return;
		
	string page_text = visit_url("adventure.php?snarfblat=" + snarfblat);
	
	
	//Use Item(s)
	if (page_text.contains_text("You're fighting"))
	{
		if (page_text.contains_text("The Thorax"))
		{
			while (page_text.contains_text("Use Item(s)"))
			{
				if (page_text.contains_text("draws back his big fist for a punch"))
				{
					page_text = throw_item($item[clumsiness bark]);
				}
				else
					page_text = attack();
			}
		}
		else if (page_text.contains_text("The Bat in the Spats"))
		{
			while (page_text.contains_text("Use Item(s)"))
			{
				if ($item[clumsiness bark].available_amount() == 0)
					abort("out of items");
				page_text = try_throw_items($item[clumsiness bark], $item[clumsiness bark]);
			}
		}
		else if (page_text.contains_text("The Terrible Pinch"))
		{
			boolean need_shield = true;
			while (page_text.contains_text("Use Item(s)"))
			{
				if (need_shield)
				{
					if ($item[gauze garter].available_amount() > 0 && false)
						page_text = try_throw_items($item[jar full of wind], $item[gauze garter]);
					else
						page_text = throw_item($item[jar full of wind]);
					need_shield = false;
				}
				else
				{
					page_text = use_skill($skill[saucegeyser]);
					//page_text = attack();
					need_shield = true;
				}
			}
		}
		else if (page_text.contains_text("Thug 1 and Thug 2"))
		{
			while (page_text.contains_text("Use Item(s)"))
			{
				if ($item[jar full of wind].available_amount() == 0)
					abort("out of items");
				page_text = try_throw_items($item[jar full of wind], $item[jar full of wind]);
			}
		}
		else if (page_text.contains_text("Mammon the Elephant"))
		{
			while (page_text.contains_text("Use Item(s)"))
			{
				if ($item[jar full of wind].available_amount() == 0)
					abort("out of items");
				page_text = try_throw_items($item[dangerous jerkcicle], $item[dangerous jerkcicle]);
			}
		}
		else if (page_text.contains_text("The Large-Bellied Snitch"))
		{
			//$skill[Ambidextrous Funkslinging].have_skill()
			int jerkcicle_used_count = 0;
			while (page_text.contains_text("Use Item(s)"))
			{
				if ($item[dangerous jerkcicle].available_amount() == 0)
					abort("out of items");
				if (jerkcicle_used_count < 10)
				{
					page_text = try_throw_items($item[dangerous jerkcicle], $item[dangerous jerkcicle]);
					if ($skill[Ambidextrous Funkslinging].have_skill())
						jerkcicle_used_count += 2;
					else
						jerkcicle_used_count += 1;
				}
				else
					page_text = attack();
			}
		}
		else if (page_text.contains_text("The Thing with No Name"))
		{
			run_combat_replacement();
		}
		else
		{
			if (false && (page_text.contains_text("Woeful Magnolia") || page_text.contains_text("Wonderful Winifred Wongle") || page_text.contains_text("Hugo Von Douchington")))
				throw_item($item[louder than bomb]);
			if ($item[navel ring of navel gazing].equipped_amount() > 0)
			{
				//need consumables now, so don't:
				//runaway(); //doesn't help with consumables, but saves turns
				run_combat_replacement();
			}
			else
				run_combat_replacement();
		}
	}
	else
	{
		run_combat_replacement();
	}
}

void acquire_item(int amount, item it, int buy_limit)
{
	//hack:
	int five_by_five = 0;
	while (five_by_five < amount)
	{
		if (it.mall_price() > buy_limit)
			break;
		five_by_five = MIN(five_by_five, amount);
		retrieve_item(five_by_five, it);
		five_by_five += 5;
	}
}

void main()
{

	/*if (get_property("namespace1557284LastDefeatedThingWithNoName").to_int() == my_ascensions())
	{
		print("Already done.");
		return;
	}*/
	cli_execute("acquire 3 louder than bomb");
	cli_execute("autoattack none");
	
	if (get_auto_attack() == 0)
		set_auto_attack(0);
	if ($familiar[steam-powered cheerleader].have_familiar())
		cli_execute("familiar steam-powered cheerleader");
	else if ($familiar[baby gravy fairy].have_familiar())
		cli_execute("familiar baby gravy fairy");
	else if ($familiar[Galloping Grill].have_familiar())
		cli_execute("familiar Galloping Grill");
	else if ($familiar[hovering sombrero].have_familiar())
		cli_execute("familiar hovering sombrero");
	else
		cli_execute("familiar none");
	
	cli_execute("refresh inventory"); //stone tracking bugged
	
	foreach s in $strings[560,561,563,564,565,566,567,568,569]
		set_property("choiceAdventure" + s, 1);
	while (true)
	{
		if ($effect[dis abled].have_effect() == 0)
			use(1, $item[devilish folio]);
		if ($effect[trivia master].have_effect() == 0) //survival
			cli_execute("up trivia master");
		if ($effect[song of sauce].have_effect() == 0 && $skill[song of sauce].have_skill())
			cli_execute("cast song of sauce");
		if ($item[furious stone].available_amount() > 0 && $item[vanity stone].available_amount() > 0 && $item[lecherous stone].available_amount() > 0 && $item[jealousy stone].available_amount() > 0 && $item[avarice stone].available_amount() > 0 && $item[gluttonous stone].available_amount() > 0)
		{
			//Fight the thing:
			//FIXME
			//cli_execute("maximize moxie -familiar -tie -equip papier-m&acirc;ch&eacute;te");
			cli_execute("maximize myst, spell damage percent -tie");
			cli_execute("cast song of sauce");
			visit_url("suburbandis.php?action=altar");
			visit_url("suburbandis.php?action=dothis", true);
			run_combat_replacement();
			
			cli_execute("mallsell * green eggnog");
			cli_execute("mallsell * green hamhock");
			
			return;
		}
		else
		{
				//abort("too expensive");
				//return;
			if ($item[clumsiness bark].mall_price() < 1500)
				acquire_item(50, $item[clumsiness bark], 1500);
			else
				abort("clumsiness bark too pricy");
			if ($item[jar full of wind].mall_price() < 1500)
				acquire_item(50, $item[jar full of wind], 1500);
			else
				abort("jar full of wind too pricy");
			if ($item[dangerous jerkcicle].mall_price() < 1500)
				acquire_item(50, $item[dangerous jerkcicle], 1500);
			else
				abort("dangerous jerkcicle too pricy");
			//Collect the stones, Korben:
			if (can_interact())
			{
				cli_execute("pull * clumsiness bark");
				cli_execute("pull * jar full of wind");
				cli_execute("pull * dangerous jerkcicle");
			}
			location [int] adventure_locations;
			if ($item[furious stone].available_amount() == 0 || $item[vanity stone].available_amount() == 0)
			{
				adventure_locations.listAppend($location[the clumsiness grove]);
			}
			if ($item[lecherous stone].available_amount() == 0 || $item[jealousy stone].available_amount() == 0)
			{
				adventure_locations.listAppend($location[the maelstrom of lovers]);
			}
			if ($item[avarice stone].available_amount() == 0 || $item[gluttonous stone].available_amount() == 0)
			{
				adventure_locations.listAppend($location[The Glacier of Jerks]);
			}
			
			if (adventure_locations.count() == 0)
			{
				print("internal error");
				return;
			}
			
			location l = adventure_locations[0];
			//Try adventure:
			
			upkeepMinusCombat();
			if (combat_rate_modifier() > -25.0)
			{
				print("Acquire a better combat rate modifier");
				return;
			}
			if ($effect[trivia master].have_effect() == 0)
				cli_execute("up trivia master");
			if ($effect[Superhuman Sarcasm].have_effect() == 0)
				cli_execute("use serum of sarcasm");
			if ($effect[Tomato Power].have_effect() == 0)
				cli_execute("use tomato juice of powerful power");
			if (my_primestat() == $stat[mysticality] && $effect[Expert Oiliness].have_effect() == 0)
				cli_execute("use oil of expertise");
			
			cli_execute("restore hp");
			disAdventure(l);
			if ($effect[beaten up].have_effect() > 0)
			{
				abort("beaten up");
				return;
			}
		}
	}
}