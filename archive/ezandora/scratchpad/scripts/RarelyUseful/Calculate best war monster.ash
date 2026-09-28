float clampf(float v, float min_value, float max_value)
{
	if (v > max_value)
		return max_value;
	if (v < min_value)
		return min_value;
	return v;
}
float clampNormalf(float v)
{
	return clampf(v, 0.0, 1.0);
}

Record TargetMonster
{
	monster m;
	float dimes_from_monster;
};

Record item_drops_array_entry
{
	item drop;
	int rate;
	string type;
};

void main()
{
	int [item] item_dime_amount;
	item_dime_amount[$item[PADL Phone]] = 2;
	item_dime_amount[$item[kick-ass kicks]] = 2;
	item_dime_amount[$item[beer helmet]] = 1;
	item_dime_amount[$item[distressed denim pants]] = 1;
	item_dime_amount[$item[perforated battle paddle]] = 1;
	item_dime_amount[$item[bejeweled pledge pin]] = 1;
	item_dime_amount[$item[red class ring]] = 1;
	item_dime_amount[$item[blue class ring]] = 3;
	item_dime_amount[$item[white class ring]] = 5;
	item_dime_amount[$item[bottle opener belt buckle]] = 1;
	item_dime_amount[$item[keg shield]] = 1;
	item_dime_amount[$item[giant foam finger]] = 1;
	item_dime_amount[$item[war tongs]] = 2;
	item_dime_amount[$item[energy drink IV]] = 3;
	item_dime_amount[$item[Elmley shades]] = 3;
	item_dime_amount[$item[beer bong]] = 3;
	
	monster [int] monsters = $location[the battlefield (hippy uniform)].get_monsters();
	float item_modifier = 150.0;
	float slimeling_bonus = 0.0;
	
	TargetMonster [int] target_monsters;
	foreach key, m in monsters
	{
		float dimes_from_monster = 0;
		foreach key, entry in m.item_drops_array()
		{
			item it = entry.drop;
			int drop_rate = entry.rate;
			float effective_drop_rate = clampNormalf((drop_rate / 100.0) * (1.0 + item_modifier / 100.0));
			if (it.to_slot() != $slot[none])
			{
				//print("before slimeling: " + effective_drop_rate);
				effective_drop_rate += (1.0 - effective_drop_rate) * (drop_rate / 100.0) * (slimeling_bonus / 100.0);
				//print("after slimeling: " + effective_drop_rate);
			}
			effective_drop_rate = clampNormalf(effective_drop_rate);
			
			if (!(item_dime_amount contains it))
				continue;
			
			dimes_from_monster += item_dime_amount[it].to_float() * effective_drop_rate;
		}
		
		TargetMonster tm;
		tm.m = m;
		tm.dimes_from_monster = dimes_from_monster;
		target_monsters[target_monsters.count()] = tm;
	}
	
	sort target_monsters by -value.dimes_from_monster;
	print("At " + item_modifier + "% item, with " + slimeling_bonus + "% slimeling bonus:");
	foreach key, tm in target_monsters
	{
		print(tm.dimes_from_monster + " dimes from " + tm.m);
	}
}