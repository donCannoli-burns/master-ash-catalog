boolean setting_track_item_drop = true;

float caloriesForItem(item it)
{
	if (it == $item[pie man was not meant to eat])
		return 0.0;
	int potency = it.inebriety + it.fullness;
	if (potency == 0)
		return 0;
	
	int multiplier = 1;
	if (it.quality == "crappy")
		multiplier = 1;
	if (it.quality == "decent")
		multiplier = 2;
	if (it.quality == "good")
		multiplier = 3;
	if (it.quality == "awesome")
		multiplier = 4;
	if (it.quality == "epic") //guess
		multiplier = 5;
		
	return multiplier * potency;
		
	
	/*string [int] adventures = it.adventures.split_string("-");
	
	float average_adventures = 0.0;
	float average_count = 0.0;
	foreach key in adventures
	{
		if (adventures[key] == "")
			continue;
		average_adventures += adventures[key].to_int();
		average_count += 1.0;
	}
	if (average_count != 0.0)
		average_adventures /= average_count;
	
	
		
	//float calories = multiplier.to_float() * size.to_float();
	float calories = average_adventures;
	if (potency != 0)
		calories /= potency;
	else
		return 0.0;
	return calories;*/
}

void listAppend(item [int] list, item entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void main()
{
	int [item] cosmic_cost;
	cosmic_cost[$item[celestial olive oil]] = 20;
	cosmic_cost[$item[celestial carrot juice]] = 30;
	cosmic_cost[$item[celestial au jus]] = 50;
	cosmic_cost[$item[celestial squid ink]] = 60;
		
	foreach it in cosmic_cost
	{
		it.mall_price();
	}
	
	foreach it in cosmic_cost
	{
		int calorie_cost = cosmic_cost[it];
		
		float meat_cost_per_calorie = it.mall_price();
		if (calorie_cost != 0)
			meat_cost_per_calorie /= calorie_cost.to_float();
		print(it + ": " + meat_cost_per_calorie + " meat/calorie");
	}
	
	item [int] calorie_items;
	
	
	
	foreach it in $items[]
	{
		float calories = it.caloriesForItem();
		if (calories == 0.0)
			continue;
			
		calorie_items.listAppend(it);
	}
	sort calorie_items by value.caloriesForItem();
	
	foreach key in calorie_items
	{
		item it = calorie_items[key];
		float calories = it.caloriesForItem();
		//print(it + ": " + calories + " calories");
	}
	
	float [monster] calorie_monsters;
	monster [int] sorted_monsters;
	foreach m in $monsters[]
	{
		int [item] item_drops = m.item_drops();
		float calorie_total = 0.0;
		foreach it in item_drops
		{
			
			int drop_rate = item_drops[it];
			if (drop_rate == 0)
				drop_rate = 20;
			float calories = it.caloriesForItem();
			if (setting_track_item_drop)
				calories *= MIN(1.0, drop_rate / 100.0 * (1.0 + item_drop_modifier() / 100.0));
			if (calories == 0.0)
				continue;
			calorie_total += calories;
		}
		if (calorie_total > 0.0)
			calorie_monsters[m] = calorie_total;
		sorted_monsters[sorted_monsters.count()] = m;
	}
	
	sort sorted_monsters by calorie_monsters[value];
	
	foreach key in sorted_monsters
	{
		monster m = sorted_monsters[key];
		if (calorie_monsters[m] == 0.0)
			continue;
		print(m + ": " + calorie_monsters[m] + " calories");
	}
}