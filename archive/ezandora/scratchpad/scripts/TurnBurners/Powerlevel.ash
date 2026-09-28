import "scripts/Destiny Ascension/Destiny Ascension/Support/Library.ash"
import "scripts/Library/PreAdventureScript.ash"

boolean [item] __item_blacklist = $items[M-242,snake,sparkler,power pill,white candy heart,orange candy heart,yellow candy heart,black candy heart,hair of the fish,power-guy 2000 holo-record,bottle of fire,green-frosted astral cupcake,orange-frosted astral cupcake];

float __meat_per_mainstat_cutoff = 3.5; //less than that, but testing


/*effect to_effect(item it)
{
	return effect_modifier(it, "effect");
}

int availableDrunkenness()
{
    if (inebriety_limit() == 0) return 0; //certain edge cases
	return inebriety_limit() - my_inebriety();
}*/

//flaskfull of hollow, that vacation thing,

boolean [effect] to_effects(boolean [item] items)
{
	boolean [effect] result;
	foreach it in items
	{
		effect e = it.to_effect();
		if (e != $effect[none])
			result[e] = true;
	}
	return result;
}

boolean pirate_tract_purchasable(item tract_type)
{
	int offset = my_ascensions() % 3;
	if (tract_type == $item[pirate brochure] && offset == 1)
		return true;
	if (tract_type == $item[pirate tract] && offset == 2)
		return true;
	if (tract_type == $item[pirate pamphlet] && offset == 0)
		return true;
	return false;
}

void main()
{
	int breakout = 200;
	boolean have_drunk_jungle_juice = false;
	
	int last_turn_maximised = -1000000000; //in the year negative a billion japan might not have been here
	boolean tried_to_plant = false;
	
	boolean powerleveling_until_juice_runs_out = false;
	if (!(my_basestat($stat[muscle]) < 200 || my_basestat($stat[mysticality]) < 200 || my_basestat($stat[moxie]) < 200))
		powerleveling_until_juice_runs_out = true;
	
	cli_execute("familiar galloping grill");
	int starting_turncount = my_turncount();
	int starting_level = my_level();
	while ((my_basestat($stat[muscle]) < 200 || my_basestat($stat[mysticality]) < 200 || my_basestat($stat[moxie]) < 200 || (powerleveling_until_juice_runs_out && $effect[jungle juiced].have_effect() > 0)) && breakout > 0)
	{
		if (my_level() >= 15 && starting_level < 15) break;
		breakout -= 1;
		int turn_delta = my_turncount() - starting_turncount;
		
		if ($effect[jungle juiced].have_effect() == 0 && get_property("_machineTunnelsAdv").to_int() >= 5)
		{
			if (!have_drunk_jungle_juice)
			{
				have_drunk_jungle_juice = true;
				if (availableDrunkenness() > 0)
				{
					cli_execute("call scripts/Library/CastOde.ash 1");
					cli_execute("drink jungle juice; uneffect ode");
				}
				else if (!get_property("_syntheticDogHairPillUsed").to_boolean() && $item[synthetic dog hair pill].available_amount() > 0)
				{
					print("Gain 1 drunkenness (synthetic dog hair pill)");
					return;
				}
			}
			else if (false)
			{
				print("Already drunk jungle juice once.");
				return;
			}
		}
		//abort("1");
		boolean [effect] effects_wanted;
		if (my_primestat() != $stat[moxie])
		{
			effects_wanted[$effect[synthesis: style]] = true;
			effects_wanted[$effect[perception]] = true;
		}
		if (my_primestat() != $stat[muscle])
		{
			effects_wanted[$effect[synthesis: movement]] = true;
			effects_wanted[$effect[purpose]] = true;
		}
		if (my_primestat() != $stat[mysticality])
		{
			effects_wanted[$effect[synthesis: learning]] = true;
			effects_wanted[$effect[category]] = true;
		}
		if (my_primestat() == $stat[mysticality])
			effects_wanted[$effect[synthesis: smart]] = true;
		else if (my_primestat() == $stat[muscle])
			effects_wanted[$effect[synthesis: strong]] = true;
		else if (my_primestat() == $stat[moxie])
			effects_wanted[$effect[synthesis: cool]] = true;
		//abort("2");
		foreach e in effects_wanted
		{
			if (e.have_effect() == 0 && spleen_limit() - my_spleen_use() > 0)
			{
				print_html("up " + e);
				cli_execute("up " + e);
			}
		}
		//abort("3");
		
		if (my_turncount() - last_turn_maximised >= 5)
		{
			last_turn_maximised = my_turncount();
			string maximisation_string = "0.25 mainstat 1.0 experience ";
			foreach s in $stats[muscle,mysticality, moxie]
			{
				if (my_primestat() == s)
					maximisation_string += " 200.0 ";
				else
					maximisation_string += " 100.0 ";
				maximisation_string += s + " experience percent";
			}
			maximisation_string += " 100.0 muscle experience percent 100.0 mysticality experience percent 100.0 moxie experience percent";
			maximisation_string += " -tie";
			if (powerleveling_until_juice_runs_out)
			{
				/*if (my_primestat() == $stat[muscle])
				{
					if ($item[fake washboard].available_amount() > 0)
						maximisation_string += " +equip fake washboard";
					if ($item[trench coat].available_amount() > 0)
						maximisation_string += " +equip trench coat";
				}
				else if (my_primestat() == $stat[mysticality] && $item[basaltamander buckler].available_amount() > 0)
					maximisation_string += " +equip basaltamander buckler";*/
			}
			else
			{
				item paperweight_type = $item[none];
				int [stat] base_stats;
				foreach s in $stats[muscle,mysticality,moxie]
					base_stats[s] = s.my_basestat();
				
				if (base_stats[$stat[muscle]] < base_stats[$stat[mysticality]] && base_stats[$stat[muscle]] < base_stats[$stat[moxie]])
				{
					if (my_primestat() != $stat[muscle])
						paperweight_type = $item[tropical paperweight];
				}
				else if (base_stats[$stat[mysticality]] < base_stats[$stat[muscle]] && base_stats[$stat[mysticality]] < base_stats[$stat[moxie]])
				{
					if (my_primestat() != $stat[mysticality])
						paperweight_type = $item[deck of tropical cards];
				}
				else if (base_stats[$stat[moxie]] < base_stats[$stat[muscle]] && base_stats[$stat[moxie]] < base_stats[$stat[mysticality]])
				{
					if (my_primestat() != $stat[moxie])
						paperweight_type = $item[Tiki lighter];
				}
				
				if (paperweight_type != $item[none] && paperweight_type.have())
					maximisation_string += " +equip " + paperweight_type;
			}
			if ($item[astral pet sweater].available_amount() > 0)
				maximisation_string += " +equip astral pet sweater";
			cli_execute("maximize " + maximisation_string);
		}
		
		//Gain buffs that matter:
		//boolean [item] potential_buff_items;
	
		float [item] potential_buff_item_prices;
		float [item] potential_buff_item_meat_per_mainstat;
		
		//int [effect] duplicates_counted;
		int max_probable_turns = 50;
		int min_stats = MIN(MIN(my_basestat($stat[muscle]), my_basestat($stat[moxie])), my_basestat($stat[mysticality]));
		int stats_remaining = MAX(0, 200 - min_stats);
		max_probable_turns = MIN(50, MAX(5, stats_remaining.to_float() / 100.0 * 40.0));
		if (powerleveling_until_juice_runs_out)
			max_probable_turns = MIN(50, $effect[jungle juiced].have_effect());
		//print_html("max_probable_turns = " + max_probable_turns);
		//abort("");
		
		item [effect] potential_buff_effects;
		foreach it in $items[]
		{
			if (it.to_effect() == $effect[none])
				continue;
			if (it.fullness > 0 || it.inebriety > 0 || it.spleen > 0)
				continue;
			if (__item_blacklist[it])
				continue;
			if ($items[pirate brochure, pirate tract, pirate pamphlet] contains it && !it.pirate_tract_purchasable())
				continue;
		
			if (it.historical_price() >= 100000)
				continue;
		
			float mainstats_added_per_turn = 0.0;
			effect e = it.to_effect();
			mainstats_added_per_turn += 0.25 * e.numeric_modifier(my_primestat());
			mainstats_added_per_turn += 0.25 * e.numeric_modifier(my_primestat() + " Percent") * my_basestat(my_primestat()) / 100.0;
			
			mainstats_added_per_turn += 0.33 * e.numeric_modifier("Monster Level");
			mainstats_added_per_turn += 0.5 * e.numeric_modifier("Experience");
			
			mainstats_added_per_turn *= 2.0 * 1.25; //jungle juice, exotic vacation
			
			int effect_turn_length = MIN(max_probable_turns, it.numeric_modifier("effect duration")); //this is a hack, but w/e
			
			float total_mainstats_gained = mainstats_added_per_turn * effect_turn_length;
			if (total_mainstats_gained <= 0)
				continue;
			
			float price = it.cost_to_acquire(false, 0.0);
			/*int price = it.mall_price();
			if (it.is_npc_item() && it.npc_price() > 0)
			{
				if (price == 0)
					price = it.npc_price();
				else
					price = MIN(price, it.npc_price());
			}*/
			if (price <= 0)
				continue;
			float meat_per_mainstat = price / total_mainstats_gained;
			//duplicates_counted[e] += 1;
			if (meat_per_mainstat >= __meat_per_mainstat_cutoff)
				continue;
			
			if (potential_buff_effects contains e)
			{
				item other_it = potential_buff_effects[e];
				if (potential_buff_item_meat_per_mainstat[other_it] <= meat_per_mainstat)
					continue;
			}
			
			potential_buff_item_prices[it] = price;
			potential_buff_item_meat_per_mainstat[it] = meat_per_mainstat;
			
			potential_buff_effects[e] = it;
			
			//potential_buff_items_sorted[potential_buff_items_sorted.count()] = it;
		}
		item [int] potential_buff_items_sorted;
		
		foreach e, it in potential_buff_effects
		{
			potential_buff_items_sorted[potential_buff_items_sorted.count()] = it;
		}
		/*foreach e, amount in duplicates_counted
		{
			if (amount <= 1)
				continue;
			print_html(e + ": " + amount);
		}*/
		
		sort potential_buff_items_sorted by potential_buff_item_meat_per_mainstat[value];
		if (false)
		{
			foreach key, it in potential_buff_items_sorted
			{
				float meat_per_mainstat = potential_buff_item_meat_per_mainstat[it];
				print_html(it + ": " + meat_per_mainstat.roundForOutput(1));
			}
		}
		
		boolean [effect] other_effects_wanted;
		other_effects_wanted[$effect[trivia master]] = true;
		other_effects_wanted[$effect[Merry Smithsness]] = true;
		other_effects_wanted[$effect[Expert Vacationer]] = true;
		
		
		other_effects_wanted[$effect[Empathy]] = true;
		other_effects_wanted[$effect[Leash of Linguini]] = true;
		other_effects_wanted[$effect[Song of Bravado]] = true;
		other_effects_wanted[$effect[Ur-Kel's Aria of Annoyance]] = true; //'
		other_effects_wanted[$effect[Drescher's Annoying Noise]] = true; //'
		other_effects_wanted[$effect[Stevedave's Shanty of Superiority]] = true; //'
		if (my_primestat() == $stat[muscle])
		{
			other_effects_wanted[$effect[Rage of the Reindeer]] = true;
		}
		
		foreach e in other_effects_wanted
		{
			if (e.have_effect() > 1)
				continue;
			cli_execute("up " + e);
		}
		
		foreach key, it in potential_buff_items_sorted
		{
			if (it.to_effect().have_effect() > 1)
				continue;
			if (my_buffedstat(my_primestat()) >= 10000)
				continue;
			if ($items[pressurized potion of perception,pressurized potion of perspicacity,pressurized potion of proficiency,pressurized potion of puissance,pressurized potion of pulchritude,pressurized potion of pneumaticity] contains it)
			{
				if ($items[pressurized potion of perception,pressurized potion of perspicacity,pressurized potion of proficiency,pressurized potion of puissance,pressurized potion of pulchritude,pressurized potion of pneumaticity].to_effects().have_effect() > 0)
					continue;
			}
			use(1, it);
		}
		//swim laps
		
		if (florist_available() && get_property("lastAdventure").to_location() == $location[the deep dark jungle] && !tried_to_plant)
		{
			boolean has_right_plant = false;
			foreach key, plant in get_florist_plants()[$location[the deep dark jungle]]
			{
				if (plant == "Rabid Dogwood")
				{
					has_right_plant = true;
					break;
				}
			}
			if (!has_right_plant)
			{
				visit_url("place.php?whichplace=forestvillage&action=fv_friar");
				visit_url("choice.php?whichchoice=720&option=1&plant=1");
				visit_url("place.php?whichplace=forestvillage&action=fv_friar");
				tried_to_plant = true;
			}
		}
		
		if (!to_boolean(get_property("telescopeLookedHigh")))
			cli_execute("telescope high");
		if (!get_property("_ballpit").to_boolean())
			cli_execute("ballpit");
		if (!get_property("_olympicSwimmingPool").to_boolean())
			cli_execute("swim laps");
		
		equipMostUsefulTropicalItem();
		
		if (get_property("_machineTunnelsAdv").to_int() < 5) //use up the free fights, even if they don't give as much stats, because they're free
		{
			cli_execute("familiar machine elf");
			adv1($location[the deep machine tunnels], 0, "");
		}
		else
		{
			if (get_property("_hipsterAdv").to_int() < 3) //use up the initial free fights, grill probably gives more stats for the rest?
				cli_execute("familiar mini-hipster");
			else
				cli_execute("familiar galloping grill");
			adv1($location[the deep dark jungle], 0, "");
		}
	}
}