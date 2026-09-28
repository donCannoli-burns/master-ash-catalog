import "CheapFarm.ash";
//Times tried:
//30 adventures, 5 distention pills, 5 synthetic dog hairs.

boolean grimaceHasNoAliensToday()
{
	int grimace_phase = moon_phase() / 2;
	if (grimace_phase == 4)
		return false;
	else if (grimace_phase < 2 || grimace_phase > 6)
		return true;
	else
		return false;
}

void main()
{
	if (my_inebriety() > inebriety_limit())
	{
		return;
	}
	float actual_percent_aliens = 0.0;
	int grimace_phase = moon_phase() / 2;
	if (grimace_phase == 4)
		actual_percent_aliens = 0.3;
	else if (grimace_phase < 2 || grimace_phase > 6)
		actual_percent_aliens = 0.0;
	else
		actual_percent_aliens = 0.15;
		
	print("Aliens are " + to_int(actual_percent_aliens * 100) + "%.");
	if (actual_percent_aliens > 0.0)
	{
		print("Not farming this today.");
		return;
	}
	insureVYKEAItemManual();
	
	//cli_execute("mood itemfinder-very-simple");
	
	cli_execute("mood execute");
	if ($familiar[fancypants scarecrow].have_familiar() && false)
	{
		cli_execute("familiar scarecrow");
		cli_execute("call Library/equip item gear.ash");
		//cli_execute("autoattack Item Farming");
	}
	else if ($familiar[jumpsuited hound dog].have_familiar()) //better than the scarecrow these days
	{
		cli_execute("familiar hound dog");
	}
	else
	{
	}
	if ($item[flaskfull of hollow].effect_modifier("effect").have_effect() == 0 && $item[flaskfull of hollow].mall_price() <= 20000)
	{
		cli_execute("use flaskfull of hollow");
	}
	cli_execute("equip a light that never goes out; maximize item -tie");

	float mpa = 3500;
	known_items["map"] = cheap_farming_target_item_make(0.1, mpa * 6.0 * 0.5, 0.0);

	//buy wrecked generators:
	if (my_id() == 1557284)
	{
		int generator_count = available_amount($item[Wrecked Generator]);
		int purchasable_amount = available_amount($item[lunar isotope]) / 100;
		int wanted_amount = 50;
		if (wanted_amount > purchasable_amount)
			wanted_amount = purchasable_amount;
		int amount_to_purchase = wanted_amount - generator_count;
		if (amount_to_purchase > 0 && is_accessible($coinmaster[lunar lunch-o-mat]))
		{
			print("Purchasing " + amount_to_purchase + " wrecked generators...");
			buy($coinmaster[lunar lunch-o-mat], amount_to_purchase, $item[wrecked generator]);
		}
	}
	

	//choiceAdventure536
	//1 -> distention pill
	//2 -> synthetic dog hair
	int target_amount = 100;
	int turns_to_keep = 50;
	while (my_adventures() > turns_to_keep || $item[map to safety shelter grimace prime].available_amount() > 0)
	{
		boolean should_farm_more_maps = $item[synthetic dog hair pill].available_amount() < target_amount || $item[distention pill].available_amount() < target_amount;
		
		if (have_effect($effect[Transpondent]) == 0)
			cli_execute("use transporter transponder");
		if (available_amount($item[Map to Safety Shelter Grimace Prime]) >= my_adventures() - 1 - turns_to_keep && available_amount($item[Map to Safety Shelter Grimace Prime]) > 0 || (available_amount($item[Map to Safety Shelter Grimace Prime]) > 0 && !should_farm_more_maps))
		{
			if (available_amount($item[synthetic dog hair pill]) > available_amount($item[distention pill]))
				cli_execute("set choiceAdventure536 = 1"); //get pill
			else
				cli_execute("set choiceAdventure536 = 2"); //get hair
			cli_execute("use Map to Safety Shelter Grimace Prime");
		}
		else if (should_farm_more_maps)
		{
			if ($effect[synthesis: collection].have_effect() == 0)
				cli_execute("synthesis item");
			if ($item[flaskfull of hollow].effect_modifier("effect").have_effect() == 0 && $item[a light that never goes out].equipped_amount() > 0)
			{
				if ($item[flaskfull of hollow].mall_price() < 20000)
				{
					cli_execute("use flaskfull of hollow");
				}
				else
				{
					cli_execute("maximize item -tie");
				}
			}
			cli_execute("gain item 500 spt");
			insureAllFarmingEffects("map", ((my_adventures() - turns_to_keep) - available_amount($item[Map to Safety Shelter Grimace Prime])) * 0.5 );
			adv1($location[domed city of grimacia], 0, "");
		}
		else
			break;
	}
	if ($item[Map to Safety Shelter Grimace Prime].available_amount() > 0)
	{
		abort("math error, we still have a map");
	}
	cli_execute("mood apathetic");
	//cli_execute("autoattack none");
}