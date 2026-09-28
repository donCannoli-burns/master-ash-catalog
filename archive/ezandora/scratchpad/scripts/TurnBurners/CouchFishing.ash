import "relay/Guide/Support/LocationAvailable.ash";
import "scripts/TurnBurners/NewYou.ash";

int __setting_minimum_fish_limit = 1000;

int [string] __current_fish_count;
location [string] __current_fishing_spots;

void parseFishingState()
{
	buffer page_text = visit_url("clan_viplounge.php?action=floundry");
	string core_1 = page_text.group_string("<table><tr><td>You check the readout on the Floundry's fabrication unit:(.*?)</table>")[0][1];
	
	string core_fish_stock = core_1.group_string("<b>Current Fish Stock:</b></center>(.*?)</td>")[0][1];
	string core_fishing_spots = core_1.group_string("<b>Good fishing spots today:</b></center>(.*?)</td>")[0][1];
	
	//print_html("core_fish_stock = " + core_fish_stock.entity_encode());
	//print_html("core_fishing_spots = " + core_fishing_spots.entity_encode());
	
	foreach key, s in core_fish_stock.split_string("<br>")
	{
		if (s == "" || s == " ") continue;
		
		string [int] split = s.split_string(" ");
		string fish_type = split[1];
		//you can use to_int() on a buffer, but it'll return 0 silently because it hates you
		//int fish_amount = split[0].replace_string(",", "").to_int();
		int fish_amount = split[0].replace_string(",", "").to_string().to_int();
		
		__current_fish_count[fish_type] = fish_amount;
		
		//print_html(fish_type + ", " + fish_amount);
	}
	foreach key, s in core_fishing_spots.split_string("<br>")
	{
		if (s == "" || s == " ") continue;
		//print_html("s = " + s.entity_encode());
		
		string [int][int] matches = s.group_string("<b>(.*?):</b> (.+)");
		string fish_type = matches[0][1];
		string location_name = matches[0][2];
		
		location l = location_name.to_location();
		
		if (l == $location[none])
		{
			print("Unknown location " + location_name);
			continue;
		}
		
		//print_html(fish_type + ", " + l);
		__current_fishing_spots[fish_type] = l;
	}
}

//location pickTargetFishingSpot()
string pickBestFishToFarm()
{
	//location fishing_spot = $location[none];
	string best_fish_type = "";
	int fish_count = -1;
	foreach fish_type, spot in __current_fishing_spots
	{
		if ($locations[the fun-guy mansion] contains spot) continue; //combat script can't handle
		int current_count = __current_fish_count[fish_type];
		if (!spot.locationAvailable()) continue;
		//if (fishing_spot == $location[none] || (current_count < fish_count))
		if (best_fish_type == "" || current_count < fish_count)
		{
			fish_count = current_count;
			//fishing_spot = spot;
			best_fish_type = fish_type;
		}
	}
	
	return best_fish_type;
	//return fishing_spot;
}

void main()
{
	if (get_clan_id() <= 0)
	{
		print("You need to be in a clan.");
		return;
	}
	if ($item[fishin' pole].available_amount() == 0) //'
	{
		print("Can't fish without a fishing pole.");
		return;
	}
	parseFishingState();
	
	//location fishing_spot = pickTargetFishingSpot();
	string best_fish = pickBestFishToFarm();
	
	
	print("Collect " + best_fish + " in " + __current_fishing_spots[best_fish] + ": need " + (__setting_minimum_fish_limit - __current_fish_count[best_fish]) + " more");
	if (__current_fishing_spots[best_fish] == $location[none])
	{
		print("No fishing spot?");
		return;
	}
	if (my_inebriety() > inebriety_limit())
	{
		print("Overdrunk.");
		return;
	}
	if (__current_fish_count[best_fish] >= __setting_minimum_fish_limit) return;
	
	if ($familiar[disembodied hand].have_familiar())
		cli_execute("familiar disembodied hand");
	cli_execute("maximize 1000.0 fishing skill 1.0 combat -tie");
	int breakout = 1000;
	if ($item[antique tacklebox].item_amount() == 0 && $item[antique tacklebox].available_amount() > 0)
	{
		cli_execute("acquire antique tacklebox");
	}
	while (my_adventures() > 0 && breakout > 0)
	{
		if (__current_fish_count[best_fish] >= __setting_minimum_fish_limit) break;
		cli_execute("call CheckKramcoSpading.ash");
		breakout -= 1;
		location target = __current_fishing_spots[best_fish];
		if ($item[antique tacklebox].available_amount() == 0 && $location[the haunted storage room].locationAvailable())
			target = $location[the haunted storage room];
		cli_execute("gain meat 10 spendperturn");
		cli_execute("gain combat 10 spendperturn");
		cli_execute("gain fishing skill 10 spendperturn");
		prepareToAdventureIn(target);
		adv1(target, -1, "");
		
		parseFishingState();
		best_fish = pickBestFishToFarm();
	}
}
