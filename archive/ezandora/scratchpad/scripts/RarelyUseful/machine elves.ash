boolean item_is_pvp_stealable(item it)
{
	if (it == $item[amulet of yendor])
		return true;
	if (!it.tradeable)
		return false;
	if (!it.discardable)
		return false;
	if (it.quest)
		return false;
	if (it.gift)
		return false;
	return true;
}

effect to_effect(item it)
{
	return effect_modifier(it, "effect");
}

boolean isMachineElfable(item it)
{	
	if (!it.item_is_pvp_stealable())
		return false;
	if (it.fullness > 0 || it.inebriety > 0 || it.spleen > 0)
		return true;
	//switch to item_type() == "potion" ?
	if (it.item_type() == "potion")
		return true;
	if (it.to_effect() != $effect[none])
		return true;
	//if ($items[oil of oiliness,half-baked potion] contains it) //these are copyable due to reasons
	//	return true;
	return false;
}

void main()
{

	item [int] pvpable_items;
	int maximum_item_id = 0;
	foreach it in $items[]
	{
		maximum_item_id = MAX(maximum_item_id, it.to_int());
	}
	
	foreach it in $items[]
	{
		if (!it.isMachineElfable())
			continue;
		pvpable_items[pvpable_items.count()] = it;
		
		float age_lookup_cutoff = 30.0;
		if (it.historical_price() >= 10000)
			age_lookup_cutoff = 15.0;
		if (it.to_int() >= maximum_item_id - 500)
			age_lookup_cutoff = 1;
		int price = it.historical_price();
		if (price <= 0 || it.historical_age() >= age_lookup_cutoff)
			price = it.mall_price();
	}
	sort pvpable_items by -value.historical_price();
	foreach key, it in pvpable_items
	{
		if (it.historical_price() >= 25000)
		{
			string line = it + ": " + it.historical_price() + " meat";
			int have = it.available_amount() + it.display_amount();
			if (have > 0)
				line += " (have " + have + ")";
			print_html(line);
		}
	}
}