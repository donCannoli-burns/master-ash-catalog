import "scripts/RarelyUseful/machine elves.ash"

float powf(float x, float y)
{
	return x ** y;
}

void machineElfRunTurns()
{
	//pick an item:
	/*if ($location[the deep machine tunnels].turns_spent != 5)
	{
		return;
	}*/
	//nothing to do, don't bother with setup
	if (!(get_property("_machineTunnelsAdv").to_int() < 5 || $location[the deep machine tunnels].turns_spent == 5))
	{
		return;
	}
	if (!can_interact())
	{
		return;
	}
	
	int [item] personal_inventory_desired =
	{
		$item[corned beet]:5,
		$item[pickled bread]:5,
		$item[salted mutton]:5,
	};
	
	item item_to_duplicate = $item[none];
	float item_duplicating_value = 0.0;
	foreach it in $items[]
	{
		if (!it.isMachineElfable())
		{
			continue;
		}
		int amount_have_total_minus_shop = it.available_amount() + it.display_amount() + it.closet_amount();
		if (amount_have_total_minus_shop == 0)
		{
			continue;
		}
		int shop_amount = it.shop_amount();
		
		
		float item_value = to_float(it.historical_price());
		
		float exponential_backoff = 1.4;
		int starting_point = 2;
		int ending_point = 20;
		
		item_value /= powf(exponential_backoff, min(ending_point, max(shop_amount - starting_point, 0)));
		
		/*if (shop_amount > 5)
		{
			//int extra_items = shop_amount - 5;
			item_value /= to_float(shop_amount);
		}*/
		
		//Keep these around at all times:
		if (personal_inventory_desired contains it && amount_have_total_minus_shop < personal_inventory_desired[it])
		{
			item_value += 999999999;
		}
		/// to_float(it.available_amount() + it.display_amount() + it.closet_amount() + it.shop_amount());
		//if (item_to_duplicate == $item[none] || item_to_duplicate.historical_price() < it.historical_price())
		if (item_to_duplicate == $item[none] || item_value > item_duplicating_value)
		{
			print_html("HandleAftercoreMachineElf.ash: switching to " + it);
			item_to_duplicate = it;
			item_duplicating_value = item_value;
		}
	}
	
	print("Best item for duplication is " + item_to_duplicate + " at approximate item value " + item_duplicating_value);
	//abort("duplicate " + item_to_duplicate);
	
	cli_execute("familiar machine elf");
	
	if (item_to_duplicate.available_amount() > 0 && item_to_duplicate.item_amount() == 0)
	{
		retrieve_item(item_to_duplicate, 1);
	}
	
	boolean put_back_in_case = false;
	if (item_to_duplicate.item_amount() == 0 && item_to_duplicate.display_amount() > 0)
	{
		take_display(item_to_duplicate, 1);
		put_back_in_case = true;
	}
	
	boolean put_back_in_closet = false;
	if (item_to_duplicate.item_amount() == 0 && item_to_duplicate.closet_amount() > 0)
	{
		take_closet(item_to_duplicate, 1);
		put_back_in_closet = true;
	}
	if (item_to_duplicate.item_amount() == 0)
	{
		abort("can't find " + item_to_duplicate + " (maybe it's in the closet?)");
	}
	
	if ($item[june cleaver].equipped_amount() > 0)
	{
		//not bothering with these choice adventures
		cli_execute("unequip june cleaver");
	}
	
	//run:
	int breakout = 10;
	//ezandoraDeepMachineTunnelsLastAscensionSawChoice
	while (breakout > 0 && (get_property("_machineTunnelsAdv").to_int() < 5 || get_property("ezandoraDeepMachineTunnelsLastAscensionSawChoice").to_int() < my_ascensions()))// || $location[the deep machine tunnels].turns_spent == 5))
	{
		breakout -= 1;
		int previous_amount = item_to_duplicate.item_amount();
	
		buffer page_text = visit_url("adventure.php?snarfblat=458");
	
		if (page_text.contains_text("fight.php"))
		{
			//Fight:
			run_combat();
		}
		else if (page_text.contains_text("whichchoice") && page_text.contains_text("1119"))
		{
			//Choice:
			visit_url("choice.php?pwd&whichchoice=1119&option=4");
			visit_url("choice.php?whichchoice=1125&pwd&option=1&iid=" + item_to_duplicate.to_int());
			cli_execute("refresh inventory");
			set_property("ezandoraDeepMachineTunnelsLastAscensionSawChoice", my_ascensions());
		}
		else
		{
			run_turn();
			/*if (put_back_in_case)
			{
				print("put " + item_to_duplicate + " back in display case", "red");
			}
			if (put_back_in_closet)
			{
				print("put " + item_to_duplicate + " back in closet", "red");
			}
			abort("UNKNOWN PAGE TEXT.");*/
		}
		int current_amount = item_to_duplicate.item_amount();
		int items_gained = current_amount - previous_amount;
		
		//put it in the shop?
		if (items_gained > 0 && !(personal_inventory_desired contains item_to_duplicate && item_to_duplicate.available_amount() + item_to_duplicate.display_amount() + item_to_duplicate.closet_amount() <= personal_inventory_desired[item_to_duplicate]))
		{
			int price = item_to_duplicate.shop_price();
			if (price < 10000)
			{
				price = 10000;
			}
			put_shop(price, 0, 1, item_to_duplicate);
		}
	}
	
	if (put_back_in_case)
	{
		put_display(item_to_duplicate, 1);
	}
	
	if (put_back_in_closet)
	{
		put_closet(item_to_duplicate);
	}
	else if (item_to_duplicate.historical_price() >= 50000)
	{
		put_closet(item_to_duplicate);
	}
}

void main()
{
	//machineElfRunDuplicate(); return;
	if (!($familiar[machine elf].have_familiar() && my_inebriety() <= inebriety_limit()))
	{
		return;
	}
	machineElfRunTurns();
	/*
	int attempts = 10;
	while (attempts > 0)
	{
		attempts -= 1;
		
		if ($location[the deep machine tunnels].turns_spent == 5)
		{
			//abort("check wanderer");
			machineElfRunDuplicate();
		}
		else if (get_property("_machineTunnelsAdv").to_int() < 5)
		{
			//abort("check wanderer");
			cli_execute("familiar machine elf");
			adv1($location[the deep machine tunnels]);
		}
		else
		{
			break;
		}
	}*/
}