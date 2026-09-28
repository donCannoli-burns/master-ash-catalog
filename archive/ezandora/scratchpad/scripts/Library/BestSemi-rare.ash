location bestSemirareLocationForProfit()
{
	location last_semirare = get_property("semirareLocation").to_location();
	int [location][item] semirare_items;
	//High value:
	if ($item[Cobb's Knob Menagerie key].available_amount() > 0)
		semirare_items[$location[Cobb's Knob Menagerie\, Level 2]][$item[irradiated pet snacks]] = 1; //'
	semirare_items[$location[The Castle in the Clouds in the Sky (Top Floor)]][$item[Mick's IcyVapoHotness Inhaler]] = 1; //'
	semirare_items[$location[The Limerick Dungeon]][$item[cyclops eyedrops]] = 1;
	//semirare_items[$location[Cobb's Knob Harem]][$item[scented massage oil]] = 3; //'
	//semirare_items[$location[The Haunted Pantry]][$item[tasty tart]] = 3;
	//semirare_items[$location[The Outskirts of Cobb's Knob]][$item[Knob Goblin lunchbox]] = 1; //'
	//semirare_items[$location[The Sleazy Back Alley]][$item[distilled fortified wine]] = 3;
	
	/*semirare_items[$location[The Haunted Kitchen]][$item[freezerburned ice cube]] = 1;
	semirare_items[$location[Lair of the Ninja Snowmen]][$item[bottle of antifreeze]] = 1;
	semirare_items[$location[The Copperhead Club]][$item[Flamin' Whatshisname]] = 3; //'
	semirare_items[$location[The Haunted Library]][$item[black eyedrops]] = 1;
	semirare_items[$location[The Goatlet]][$item[can of spinach]] = 1;
	semirare_items[$location[A-boo Peak]][$item[death blossom]] = 1;
	semirare_items[$location[Oil Peak]][$item[unnatural gas]] = 1;
	semirare_items[$location[The Batrat and Ratbat Burrow]][$item[Dogsgotnonoz pills]] = 1;
	semirare_items[$location[The Castle in the Clouds in the Sky (Basement)]][$item[Super Weight-Gain 9000]] = 1;
	semirare_items[$location[The Castle in the Clouds in the Sky (Ground Floor)]][$item[possibility potion]] = 1;
	semirare_items[$location[Guano Junction]][$item[Eau de Guaneau]] = 1;
	semirare_items[$location[cobb's knob Laboratory]][$item[bottle of Mystic Shell]] = 1; //'
	semirare_items[$location[The Dark Heart of the Woods]][$item[SPF 451 lip balm]] = 1;
	semirare_items[$location[The Hidden Park]][$item[shrinking powder]] = 1;*/
	//semirare_items[$location[REPLACEME]][$item[REPLACEME]] = REPLACEME;
	
	int best_profit_amount = -1;
	location best_profit_location;
	foreach l in semirare_items
	{
		if (l == last_semirare)
			continue;
		int profit = 0;
		foreach it in semirare_items[l]
		{
			profit += it.mall_price() * semirare_items[l][it];
		}
		if (profit > best_profit_amount || best_profit_location == $location[none])
		{
			best_profit_location = l;
			best_profit_amount = profit;
		}
	}
	return best_profit_location;
}

void main()
{
	location l = bestSemirareLocationForProfit();
	print("Best location is " + l);
}