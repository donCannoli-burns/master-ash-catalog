import "relay/Guide/Support/LocationAvailable.ash";

float __item_rate_1 = 416.80;
float __meat_rate_1 = 157.00;
float __item_rate_2 = 156.00;
float __meat_rate_2 = 588.23;

float profitForMonsterDrops(monster m, float item_rate, float meat_rate)
{
	//"So, I think that things which have a conditional and are pickpocketable=yes can drop from the yellow ray or vivala mask, for example. It's been a while since that was done, though, so I forget." - CDM
	//"n" isn't always known though, so...
	float profit = 0.0;
	
	float average_meat_from_monster = (m.min_meat + m.max_meat) * 0.5;
	if (m == $monster[dirty thieving brigand])
		average_meat_from_monster = 0.0;
	profit += average_meat_from_monster * (1.0 + meat_rate / 100.0);
	
	//Each item:
	foreach key, r in m.item_drops_array()
	{
		item it = r.drop;
		float drop_rate = r.rate;
		string type = r.type;
		if (!it.tradeable)
			continue;
		if (type.contains_text("p")) //FIXME pickpocket
			continue;
		if (type.contains_text("a")) //FIXME accordions
			continue;
		boolean fixed = false;
		boolean probably_conditional = false;
		if (it == $item[red fox glove])
			probably_conditional = true;
		if (probably_conditional || type.contains_text("c") || type.contains_text("f")) //FIXME does conditional imply fixed? assume yes for now, for safety
			fixed = true;
		
		float acquisition_rate = MAX(0.0, MIN(1.0, drop_rate / 100.0 * (1.0 + item_rate / 100.0)));
		if (fixed)
			acquisition_rate = drop_rate / 100.0;
		profit += acquisition_rate * it.historical_price();
	}
	return profit;
}

void main()
{
	if ($item[photocopied monster].available_amount() > 0 || get_property("_photocopyUsed").to_boolean())
		return;
	
	
	//monster chosen_monster = $monster[none];
	//float monster_profit = 0.0;
	//boolean farm_monster_via_item = false;
	
	boolean [monster] monsters_probably_accessible;
	foreach l in $locations[]
	{
		if (!l.locationAvailable())
			continue;
		if (l.environment == "underwater")
			continue;
		
        float [monster] monster_appearance_rates = l.appearance_rates_adjusted();
        foreach m, rate in monster_appearance_rates
        {
            if (rate <= 0)
                continue;
            if (rate >= 20)
            	monsters_probably_accessible[m] = true;
        }
	}
	
	monster [int] monsters;
	float [monster] monsters_profit;
	int [monster] monsters_farm_type; //1 for +item, 2 for +meat, 3 for YR
	
	int assumed_turns = 7;
	foreach m in $monsters[]
	{
		if (!m.can_faxbot())
			continue;
		if (monsters_probably_accessible[m]) //lava golem
			continue;
			
		monsters[monsters.count()] = m;
		
		float profit_1 = m.profitForMonsterDrops(__item_rate_1, __meat_rate_1);
		monsters_profit[m] = profit_1;
		monsters_farm_type[m] = 1;
		/*if (profit_1 > monster_profit)
		{
			chosen_monster = m;
			monster_profit = profit_1;
			farm_monster_via_item = true;
		}*/
		
		
		float profit_2 = m.profitForMonsterDrops(__item_rate_2, __meat_rate_2);
		/*if (profit_2 > monster_profit)
		{
			chosen_monster = m;
			monster_profit = profit_2;
			farm_monster_via_item = false;
		}*/
		if (profit_2 > monsters_profit[m])
		{
			monsters_profit[m] = profit_2;
			monsters_farm_type[m] = 2;
		}
		
		float profit_3 = m.profitForMonsterDrops(100000.0, __meat_rate_1);
		float average_profit_3 = (profit_3 + (assumed_turns - 1) * profit_1) / to_float(assumed_turns);
		if (average_profit_3 > monsters_profit[m])
		{
			monsters_profit[m] = average_profit_3;
			monsters_farm_type[m] = 3;
			
		}
	}
	sort monsters by -monsters_profit[value];
	//print_html(monsters.to_json());
	foreach key, m in monsters
	{
		if (key > 20)
			break;
		int farm_type = monsters_farm_type[m];
		string farm_type_string = "";
		if (farm_type == 1)
			farm_type_string = "+item";
		else if (farm_type == 2)
			farm_type_string = "+meat";
		else if (farm_type == 3)
			farm_type_string = "YR/+item";
		string line;
		foreach key, r in m.item_drops_array()
		{
			if (line != "")
				line += ", ";
			line += r.drop + " (" + r.type + r.rate + ")";
		}
		print_html("<b>" + m + "</b>: " + monsters_profit[m].to_int() + " via " + farm_type_string + ": " + line);
	}
	
	//print_html("Farm " + chosen_monster + " for " + monster_profit + " meat via " + (farm_monster_via_item ? "+item" : "+meat") + ".");
}