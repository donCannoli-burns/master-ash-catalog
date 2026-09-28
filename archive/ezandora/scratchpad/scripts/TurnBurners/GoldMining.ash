import "relay/Guide/Support/Counter.ash";

/*
GoldMining.ash

Will automatically try to farm meat in that 70s volcano via mining. Requires the charter or one-day pass to use.
Should average around 2940 MPA.
To only use free mines (via Unaccompanied Miner), pass in a value of zero for turns to spend.
Doesn't support mining for unsmoothed velvet.

Written by Ezandora. This script is in the public domain.

CHECK IF WE HAVE MINING DRILL
CHECK IF WE HAVE HOT RES
CHECK IF WE HAVE THAT ONE PLACE ACCESS
FREE MINING
AUTOSELL
*/

string __version = "0.01";
boolean __setting_autosell_gold = true;
boolean __setting_autosell_healing_crystals = false; //useful to keep around for that one quest, so don't by default.

string [int][int] __mine_layout;
boolean __free_mines_are_remaining;

//A bunch of support code from guide.
//We should probably make this some sort of library. Hmm...


int manhattanDistanceBetweenComboPositions(int combo_position_1, int combo_position_2)
{
	int x_1 = combo_position_1 % 8;
	int x_2 = combo_position_2 % 8;
	
	int y_1 = combo_position_1 / 8;
	int y_2 = combo_position_2 / 8;
	
	return abs(x_2 - x_1) + abs(y_2 - y_1);
}

int mineComboPositionForXY(int x, int y)
{
	return y * 8 + x;
}

boolean queryMineLayout(int mine_id, buffer mine_page_text)
{
	string [int] base_layout;

	string [int][int] page_matches = group_string(mine_page_text, "alt='([^\\(]*) \\(([0-7]),([0-7])\\)'");
	
	if (page_matches.count() == 0)
	{
		//abort("Unable to parse mine.");
		return false;
	}
	//Mining a chunk of the cavern wall takes one Adventure.
	__free_mines_are_remaining = true;
	if (mine_page_text.contains_text("Mining a chunk of the cavern wall takes one Adventure"))
	{
		__free_mines_are_remaining = false;
	}
	
	foreach key in page_matches
	{
		string [int] match = page_matches[key];
		string type = match[1];
		int x = match[2].to_int();
		int y = match[3].to_int();
		int a_converted_position_in_venice_italy = mineComboPositionForXY(x, y);
		
		base_layout[a_converted_position_in_venice_italy] = type;
		//print_html("(" + x + ", " + y + " - " + a_converted_position_in_venice_italy + "): " + type);
	}
	
	//Now the property:
	string layout_property_value = get_property("mineLayout" + mine_id);
	
	string [int][int] layout_matches = layout_property_value.group_string("#([0-9]*)<img src=\"[^\"]*\" alt=\"([^\"]*)\"[^>]*>");
	
	foreach key in layout_matches
	{
		string [int] match = layout_matches[key];
		int position = match[1].to_int();
		string type = match[2];
		//print_html(position + ": " + type);
		if (base_layout[position] != "Open Cavern")
		{
			//abort("parse error");
			return false;
		}
		base_layout[position] = type;
	}
	
	__mine_layout[mine_id] = base_layout;
	//print_html("__mine_layout = " + __mine_layout.to_json());
	return true;
}

boolean queryMineLayout(int mine_id)
{
	buffer mine_page_text = visit_url("mining.php?mine=" + mine_id);
	return queryMineLayout(6, mine_page_text);
}


int [int] findEmptyMiningSpots(int mine_id)
{
	int [int] results;
	for y from 1 to 7
	{
		for x from 1 to 6
		{
			int combo_position = mineComboPositionForXY(x, y);
			string type = __mine_layout[mine_id][combo_position];
			if (!(type == "Promising Chunk of Wall" || type == "Rocky Wall"))
				results.listAppend(combo_position);
		}
	}
	return results;
}

int pickPositionToMineToReachOneOfTheseSpots(int mine_id, int [int] spots)
{
	//We go through each spot, and find the [spot, empty space] combination with the shortest manhattan distance.
	//Then pick the mining direction that heads towards that spot.
	
	int [int] mine_empty_spots = findEmptyMiningSpots(mine_id);
	//print_html("mine_empty_spots = " + mine_empty_spots.to_json());
	
	int spot_position = -1;
	int empty_position = -1;
	int cached_manhattan_distance = -1;
	
	foreach key, combo_position_spot in spots
	{
		foreach key2, combo_position_empty in mine_empty_spots
		{
			int manhattan_distance = manhattanDistanceBetweenComboPositions(combo_position_spot, combo_position_empty);
			int cave_ins = -1; 
			
			boolean should_replace = false;
			if (cached_manhattan_distance == -1)
				should_replace = true;
			else if (manhattan_distance < cached_manhattan_distance)
				should_replace = true;
			
			if (should_replace)
			{
				spot_position = combo_position_spot;
				empty_position = combo_position_empty;
				cached_manhattan_distance = manhattan_distance;
			}
		}
	}
	if (cached_manhattan_distance > 1)
		return -1;
	//print_html("Best combination from " + empty_position + " to " + spot_position + " (distance " + cached_manhattan_distance + ")");
	//Now determine how to mine for that:
	
	int spot_x = spot_position % 8;
	int empty_x = empty_position % 8;
	
	int spot_y = spot_position / 8;
	int empty_y = empty_position / 8;
	
	int x_delta = spot_x - empty_x;
	int y_delta = spot_y - empty_y;
	
	//print_html("x_delta = " + x_delta + ", y_delta = " + y_delta);
	//Very simple. Mine up, then across:
	if (y_delta < 0)
	{
		return mineComboPositionForXY(empty_x, empty_y - 1);
	}
	else if (y_delta > 0)
	{
		return mineComboPositionForXY(empty_x, empty_y + 1);
	}
	else if (x_delta < 0)
	{
		return mineComboPositionForXY(empty_x - 1, empty_y);
	}
	else if (x_delta > 0)
	{
		return mineComboPositionForXY(empty_x + 1, empty_y);
	}
	
	return -1;
}

//void main(string turns_to_spend_string)
void main(string turns_to_spend_string)
{
	int turns_to_spend = turns_to_spend_string.to_int();
	if (turns_to_spend_string == "")
		turns_to_spend = -40;
	if (!(get_property("_hotAirportToday").to_boolean() || get_property("hotAirportAlways").to_boolean()))
	{
		print("no ticket");
		return;
	}
	if (my_inebriety() > inebriety_limit())
	{
		print("I'm drunk and can't mine my horse");
		return;
	}
	cli_execute("acquire heat-resistant gloves; acquire heat-resistant necktie");
	boolean free_mine_only = false;
	
	if (turns_to_spend < 0 && my_meat() >= 100000)
	{
		cli_execute("consume.ash 3400");
		turns_to_spend = MAX(0, my_adventures() - (-turns_to_spend));
	}
	if (turns_to_spend == 0)
	{
		free_mine_only = true; //for your mine only
	}
	if ($effect[object detection].have_effect() > 0)
	{
		print_html("can't operate with object detection at the moment (well, we probably can, but don't want to chance it)");
		return;
	}
	//cli_execute("maximize 10.0 hot res 15.0 min 15.0 max, 1.0 hp regen 1.0 max, mp regen -familiar +equip high-temperature mining drill -tie"); //this expression does not work properly - specifically max and min
	//maximize 10.0 hot res 15.0 min 15.0 max, 1.0 hp regen, mp regen -familiar +equip high-temperature mining drill -tie
	//if we use 15 max, then an effect runs out and breaks the script
	cli_execute("maximize 10.0 hot res, 1.0 hp regen, mp regen -familiar +equip high-temperature mining drill -tie"); //this expression does not work properly - specifically max and min
	boolean [item] tracking_items = $items[1\,970 carat gold,new age healing crystal,unsmoothed velvet];
	int [item] starting_amount_of_items;
	foreach it in tracking_items
	{
		starting_amount_of_items[it] = it.item_amount();
	}
	
	int turns_spent = 0;
	buffer last_page_text = visit_url("mining.php?mine=" + 6);
	int last_turncount = -1;
	boolean did_reset_mine = false;
	int limit = 1000;
	int spin_limit = 10;
	while (my_adventures() > 0 && (turns_spent < turns_to_spend || free_mine_only) && limit > 0)
	{
		if (free_mine_only && last_page_text.contains_text("Mining a chunk of the cavern wall takes one Adventure"))
			break;
		limit -= 1;
		if (my_hp() == 0)
			restore_hp(1);
		
		
		cli_execute("call scripts/Library/find wandering monster.ash");
		
		if (last_turncount == my_turncount() && !did_reset_mine)
		{
			if (!__free_mines_are_remaining || spin_limit <= 0)
			{
				print("Spinning our wheels.", "red");
				break;
			}
			else
				spin_limit -= 1;
		}
		else
			spin_limit = 10;
		did_reset_mine = false;
		//queryMineLayout(6);
		boolean layout_query_successful = queryMineLayout(6, last_page_text);
		if (!layout_query_successful)
			layout_query_successful = queryMineLayout(6);
		if (!layout_query_successful)
		{
			print("last page text:");
			print(last_page_text);
			print("second stage:");
			print(visit_url("mining.php?mine=6"));
			abort("Unable to parse mine.");
		}
		//print_html("__mine_layout = " + __mine_layout.to_json());
		
		//Find promising chunks of wall:
		int spots_mined_out = 0;
		int gold_found = 0;
		int [int] areas_still_to_mine;
		foreach pos, type in __mine_layout[6]
		{
			if (type == "Promising Chunk of Wall")
			{
				int pos_y = pos / 8;
				if (pos_y >= 5) //for now, just the lower two levels
				{
					areas_still_to_mine.listAppend(pos);
				}
			}
			if (type == "1,970 carat gold")
				gold_found += 1;
			if (!(type == "Promising Chunk of Wall" || type == "Rocky Wall"))
				spots_mined_out += 1;
		}
		if (gold_found > 0)
		{
			did_reset_mine = true;
			print_html("Resetting mine.");
			last_page_text = visit_url("mining.php?mine=6&reset=1&pwd");
			continue;
		}
		int mining_position = pickPositionToMineToReachOneOfTheseSpots(6, areas_still_to_mine);
		if (mining_position < 0)
		{
			if (spots_mined_out <= 6)
			{
				mining_position = 52; //mine this spot first
			}
			else
			{
				print_html("Resetting mine.");
				last_page_text = visit_url("mining.php?mine=6&reset=1&pwd");
				continue;
			}
		}
		if (my_hp() == 0)
		{
			print("Too low on HP to continue mining.");
			break;
		}
		
		turns_spent += 1;
		//print_html("mining_position = " + mining_position);
		last_turncount = my_turncount();
		last_page_text = visit_url("mining.php?mine=6&which=" + mining_position);
	}
	int [item] ending_amount_of_items;
	foreach it in tracking_items
	{
		ending_amount_of_items[it] = it.item_amount();
	}
	
	string [int] items_found;
	float meat_gained = 0.0;
	foreach it in tracking_items
	{
		int delta = MAX(ending_amount_of_items[it] - starting_amount_of_items[it], 0);
		meat_gained += delta * it.autosell_price();
		if (delta > 0)
		{
			items_found.listAppend(pluralise(delta, it));
		}
	}
	
	//int gold_delta = ending_amount_of_items[$item[1\,970 carat gold]] - starting_amount_of_items[$item[1\,970 carat gold]];
	
	float mpa = 0.0;
	if (turns_spent > 0)
		mpa = meat_gained / (turns_spent.to_float());
	
	//print("Velvet Mining: found " + gold_delta + " gold in " + turns_spent + " turns. " + mpa + " MPA.");
	if (items_found.count() > 0)
		print("Finished mining. Found " + items_found.listJoinComponents(", ", "and") + " in " + pluralise(turns_spent, "turn", "turns") + ". " + mpa + " MPA.");
	else
		print("Finished mining. Found nothing.");
		
	//FIXME autosell gold, healing crystals(?)
	
	int gold_found = ending_amount_of_items[$item[1\,970 carat gold]] - starting_amount_of_items[$item[1\,970 carat gold]];
	if (gold_found > 0)
	{
		autosell(gold_found, $item[1\,970 carat gold]);
	}
	if ($item[hazmat helmet].equipped_amount() > 0)
		cli_execute("unequip hazmat helmet");
}