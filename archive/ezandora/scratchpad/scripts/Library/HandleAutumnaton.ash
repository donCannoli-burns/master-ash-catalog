import "scripts/Destiny Ascension/Destiny Ascension/Support/Library.ash";
import "scripts/Library/ArchiveEquipment.ash"

int __setting_autumnaton_minimum_profit = 0;

float autumnatonItemWorth(item it)
{
	float multiplier = 1.0;
	if (!can_interact())
	{
		multiplier = 0.01;
	}
	int base_price = it.historical_price();
	int autosell = it.autosell_price();
	if (autosell > 0)
	{
		//if it's at mall minimum, just treat it as its autosell price
		if (base_price == max(100, autosell * 2))
		{
			//print_html(it + ": " + base_price + " of an autosell " + autosell);
			return autosell * multiplier;
		}
	}
	return base_price * multiplier;
}

int [item] autumnatonFarmableItemsAtLocation(location l)
{
	int [item] result;
	
	int autumn_unique_item_amount = 1;
	//FIXME test against upgrades for 2
	
	if (l.environment == "outdoor")
	{
		if (l.difficulty_level == "low")
		{
			result[$item[autumn leaf]] = autumn_unique_item_amount;
		}
		else if (l.difficulty_level == "mid")
		{
			result[$item[autumn debris shield]] = autumn_unique_item_amount;
		}
		else if (l.difficulty_level == "high")
		{
			result[$item[autumn leaf pendant]] = autumn_unique_item_amount;
		}
	}
	else if (l.environment == "indoor")
	{
		if (l.difficulty_level == "low")
		{
			result[$item[AutumnFest ale]] = autumn_unique_item_amount;
		}
		else if (l.difficulty_level == "mid")
		{
			result[$item[autumn-spice donut]] = autumn_unique_item_amount;
		}
		else if (l.difficulty_level == "high")
		{
			result[$item[autumn breeze]] = autumn_unique_item_amount;
		}
	}
	else if (l.environment == "underground")
	{
		if (l.difficulty_level == "low")
		{
			result[$item[autumn sweater-weather sweater]] = autumn_unique_item_amount;
		}
		else if (l.difficulty_level == "mid")
		{
			result[$item[autumn dollar]] = autumn_unique_item_amount;
		}
		else if (l.difficulty_level == "high")
		{
			result[$item[autumn years wisdom]] = autumn_unique_item_amount;
		}
	}
	
	foreach m, rate in l.appearance_rates()
	{
		if (rate <= 0) continue;
		if (m.boss) continue;
		foreach key, drop in m.item_drops_array()
		{
			//drop.drop, drop.rate, drop.type
			//print_html(drop.drop + ": " + drop.type);
			if (drop.type.contains_text("n") || drop.type.contains_text("p") || drop.type.contains_text("c") || drop.type.contains_text("f") || drop.type.contains_text("a"))
			{
				continue;
			}
			if (drop.rate <= 0)
			{
				//not accurate; mafia does not know everything
				continue;
			}
			if (!drop.drop.tradeable) continue;
			if (drop.drop.historical_price() >= 100000 && drop.rate <= 0) continue; //probably not viable
			//print_html(drop.drop + ": " + drop.drop.historical_price());
			if (result contains drop.drop)
			{
				result[drop.drop] += 1;
			}
			else
			{
				result[drop.drop] = 1;
			}
			//result[drop.drop] = drop.drop.autumnatonItemWorth();
		}
	}
	return result;
	
}

float autumnatonProfitAtLocation(location l, float [item] item_override_values)
{
	int farmable_item_prices_total = 0;
	int farmable_item_count = 0;
	int unique_item_prices_total = 0;
	int unique_item_count = 0;
	foreach it, amount in l.autumnatonFarmableItemsAtLocation()
	{
		float worth = it.autumnatonItemWorth();
		if (item_override_values contains it)
		{
			worth = item_override_values[it];
		}
		if ($items[autumn leaf,AutumnFest ale,autumn sweater-weather sweater,autumn debris shield,autumn-spice donut,autumn dollar,autumn leaf pendant,autumn breeze,autumn years wisdom] contains it)
		{
			unique_item_prices_total += amount * worth;
			unique_item_count += amount;
		}
		else
		{
			farmable_item_prices_total += amount * worth;
			farmable_item_count += amount;
		}
	}
	/*foreach m, rate in l.appearance_rates()
	{
		if (rate <= 0) continue;
		foreach key, drop in m.item_drops_array()
		{
			//drop.drop, drop.rate, drop.type
			//print_html(drop.drop + ": " + drop.type);
			if (drop.type.contains_text("n") || drop.type.contains_text("p") || drop.type.contains_text("c") || drop.type.contains_text("f") || drop.type.contains_text("a"))
			{
				continue;
			}
			if (drop.rate <= 0)
			{
				//not accurate; mafia does not know everything
				continue;
			}
			if (!drop.drop.tradeable) continue;
			//print_html(drop.drop + ": " + drop.drop.historical_price());
			farmable_item_prices_total += drop.drop.autumnatonItemWorth();
			farmable_item_count += 1;
		}
	}*/

	if (farmable_item_count > 0)
	{
		float average_profit = to_float(farmable_item_prices_total) / to_float(farmable_item_count);
		average_profit += unique_item_prices_total;
		return average_profit;
	}
	return 0;
}

void autumnatonDoLocationEquips(location target_location) //none for all
{
	if ($location[8-bit realm].turns_spent > 0 && $item[continuum transfunctioner].have() && $item[continuum transfunctioner].equipped_amount() == 0 && (target_location == $location[8-bit realm] || target_location == $location[none]))
	{
		equip($item[continuum transfunctioner], $slot[acc1]);
	}
}


//returns choice text, performs upgrades:
buffer autumnatonInit()
{
	ArchiveEquipment();
	autumnatonDoLocationEquips($location[none]);
	buffer page_text = visit_url("inv_use.php?whichitem=10954");
	boolean changed = true;
	int breakout = 20;
	while (changed && breakout > 0)
	{
		breakout -= 1;
		changed = false;
		foreach choice_id, choice_text in available_choice_options()
		{
			if (choice_text == "Send your autumn-aton to: ")
			{
				continue;
			}
			else if (choice_text == "Back to Inventory")
			{
				continue;
			}
			else if (choice_text.starts_with("Attach the "))
			{
				//else if (choice_text == "Attach the high speed right leg that you found." || choice_text == "Attach the high performance right arm that you found." || choice_text == "Attach the enhanced left arm that you found." || choice_text == "Attach the energy-absorptive hat that you found." || choice_text == "Attach the upgraded left leg that you found." || choice_text == "Attach the radar dish that you found." || choice_text == "Attach the collection prow that you found." || choice_text == "Attach the enhanced left arm and high performance right arm that you found." || choice_text == "Attach the dual exhaust that you found.")
				page_text = visit_url("choice.php?whichchoice=1483&option=" + choice_id);
				changed = true;
				break;
			}
			else if (choice_text != "")
			{
				abort("HandleAutumnaton: Unknown option \"" + choice_text + "\"");
			}
		}
	}
	RestoreArchivedEquipment();
	return page_text;
}

void autumnatonCheck(float [item] desired_item_values)
{
	if ($item[autumn-aton].available_amount() == 0)
	{
		return;
	}
	buffer page_text = autumnatonInit();
	
	//autumnatonUpgrades: rightleg1
	//upgrades we want:
	/*
	Mid outdoor, High performance right arm: +1 item from zone
	Low indoor, Enhanced left arm: +1 item from zone
	options:
	Low underground, Upgraded left leg: -11 expedition length
	Mid indoor, Upgraded right leg: -11 expedition length
	*/
	//Low: recommended stat is 0-20
	//Mid: recommended stat is 25?-100
	//High: recommended stat is > 100
	
	/*
	enhanced left arm: leftarm1
	upgraded left leg: leftleg1
	high performance right arm: rightarm1
	high speed right leg: rightleg1
	energy-absorptive hat: base_blackhat
	collection prow: cowcatcher
	vision extender: periscope
	radar dish: radardish
	dual exhaust: dualexhaust
	*/
	boolean [string] upgrades_have = get_property("autumnatonUpgrades").split_string_alternate(",").listInvert();
	
	boolean [string] desired_upgrades;
	if (true)
	{
		desired_upgrades["leftarm1"] = true;
		desired_upgrades["rightarm1"] = true;
	}
	
	
	boolean [string] desired_upgrades_out;
	foreach upgrade in desired_upgrades
	{
		if (upgrades_have[upgrade]) continue;
		desired_upgrades_out[upgrade] = true;
	}
	
	
	string [string] upgrade_location_difficulty =
	{
		"leftarm1":"low",
		"leftleg1":"low",
		"rightarm1":"mid",
		"rightleg1":"mid",
		"base_blackhat":"low",
		"cowcatcher":"mid",
		"periscope":"high",
		"radardish":"high",
		"dualexhaust":"high",
	};
	string [string] upgrade_location_environment =
	{
		"leftarm1":"indoor",
		"leftleg1":"underground",
		"rightarm1":"outdoor",
		"rightleg1":"indoor",
		"base_blackhat":"outdoor",
		"cowcatcher":"underground",
		"periscope":"outdoor",
		"radardish":"indoor",
		"dualexhaust":"underground",
	};
	
	boolean [item] hard_overrides;
	foreach it, value in desired_item_values
	{
		if (value >= 10000)
		{
			hard_overrides[it] = true;
		}
	}
	
	//boolean [int] possible_location_ids;
	boolean [location] possible_locations;
	string [int][int] matches = page_text.group_string("<option  value=\"([0-9]+)\">");
	foreach key in matches
	{
		int location_id = matches[key][1].to_int();
		//possible_location_ids[location_id] = true;
		location l = location_id.to_location();
		if (l != $location[none])
		{
			possible_locations[l] = true;
		}
		//print_html("matches[" + key + "] = " + matches[key][1]);
	}
	float max_profit = 0;
	location max_profit_location = $location[none];
	foreach l in possible_locations
	{
		float profit = autumnatonProfitAtLocation(l, desired_item_values);
		
		foreach part in desired_upgrades_out
		{
			if (l.difficulty_level == upgrade_location_difficulty[part] && l.environment == upgrade_location_environment[part])
			{
				if (hard_overrides.count() == 0)
					profit += 999999999;
				else
					profit += 2500;
			}
		}
		/*string location_type = "low";
		if (l.recommended_stat >= 25 && l.recommended_stat <= 100)
		{
			location_type = "middle";
		}
		else if (l.recommended_stat > 100)
		{
			location_type == "high";
		}*/
		
		if (profit > max_profit)
		{
			max_profit = profit;
			max_profit_location = l;
		}
	}
	if ($locations[Infernal Rackets Backstage,The Laugh Floor] contains max_profit_location)
	{
		//pick bus pass/imp air depending on how many we have of each:
		if ($item[bus pass].available_amount() < $item[imp air].available_amount())
		{
			if (possible_locations[$location[Infernal Rackets Backstage]])
			{
				max_profit_location = $location[Infernal Rackets Backstage];
				max_profit = -1;
			}
		}
		else
		{
			if (possible_locations[$location[The Laugh Floor]])
			{
				max_profit_location = $location[The Laugh Floor];
				max_profit = -1;
			}
		}
	}
	if (max_profit_location == $location[none])
	{
		return;
	}
	print("Best autumnaton spot is " + max_profit_location + " for " + max_profit.to_int() + " profit per item.");
	//abort("double check that");
	
	if (max_profit >= __setting_autumnaton_minimum_profit || max_profit == -1)
	{
		int destination = max_profit_location.to_int();
		if ($locations[Shadow Rift,Shadow Rift (Desert Beach),Shadow Rift (Forest Village),Shadow Rift (Mt. McLargeHuge),Shadow Rift (Somewhere Over the Beanstalk),Shadow Rift (Spookyraven Manor Third Floor),Shadow Rift (The 8-Bit Realm),Shadow Rift (The Ancient Buried Pyramid),Shadow Rift (The Castle in the Clouds in the Sky),Shadow Rift (The Distant Woods),Shadow Rift (The Hidden City),Shadow Rift (The Misspelled Cemetary),Shadow Rift (The Nearby Plains),Shadow Rift (The Right Side of the Tracks)] contains max_profit_location)
		{
			destination = 567;
		}
		if (destination < 0)
		{
			abort("destination " + max_profit_location + " disagreement " + destination);
		}
		print("Sending autumnaton off to " + max_profit_location + " - " + destination + " (worth " + max_profit + ")");
		
		ArchiveEquipment();
		autumnatonDoLocationEquips(max_profit_location);
		visit_url("choice.php?whichchoice=1483&option=2&heythereprogrammer=" + destination);
		RestoreArchivedEquipment();
	}
	
}

void autumnatonCheck()
{
	float [item] blank_values;
	autumnatonCheck(blank_values);
}

void main()
{
	if (true)
	{
		autumnatonCheck();
	}
	else
	{
		float [item] blank_values;
		float [location] location_profit;
		location [int] locations;
		foreach l in $locations[]
		{
			if (true && (l.zone == "Twitch" || l.parent == "Removed" || l.parent == "PastEvents")) continue;
			
			float profit = l.autumnatonProfitAtLocation(blank_values);
			if (profit > 0)
			{
				locations[locations.count()] = l;
				location_profit[l] = profit;
			}
		}
		sort locations by -location_profit[value];
		string tab = "&nbsp;&nbsp;&nbsp;&nbsp;";
		foreach key, l in locations
		{
			if (location_profit[l] < 100) continue;
			print_html(l + ": " + location_profit[l].to_int());
			buffer line;
			line.append(tab);
			boolean previous = false;
			foreach it, amount in l.autumnatonFarmableItemsAtLocation()
			{
				float price = it.autumnatonItemWorth();
				//print_html(tab + amount + " " + it + ": " + price);
				if (previous)
				{
					line.append(", ");
				}
				line.append(amount);
				line.append(" ");
				line.append(it);
				line.append(" (");
				line.append(price);
				line.append(")");
				previous = true;
			}
			print_html(line);
		}
	}
}