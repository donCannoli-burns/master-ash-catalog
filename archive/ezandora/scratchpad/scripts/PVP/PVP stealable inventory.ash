int item_price(item it)
{
	if (!it.is_tradeable())
		return 0.0;
	if (it.historical_age() > 365.0 || (it.historical_age() >= 2 && it.historical_price() > 50000))
		return it.mall_price();
	return it.historical_price();
}

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

int available_minus_storage_amount(item it)
{
	if (can_interact())
		return it.available_amount() - it.storage_amount();
	else
		return it.available_amount();
}

void main()
{
	item [int] stealables;
	foreach i in $items[]
	{
		if (i.item_amount() == 0)
			continue;
		
		if (!i.item_is_pvp_stealable())
			continue;
		stealables[stealables.count()] = i;
	}
	
	//sort stealables by value.item_amount() * item_price(value);
	sort stealables by item_price(value);
	
	print("Stealable items:");
	foreach key in stealables
	{
		item it = stealables[key];
		int total_price = it.item_amount() * it.item_price();
		if (total_price == 0.0)
			print(it.item_amount() + " " + it);
		else
			print(it.item_amount() + " " + it + " (" + total_price + " meat)");
	}
}