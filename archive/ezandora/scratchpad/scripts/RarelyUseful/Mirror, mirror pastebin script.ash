//Mirror, Mirror.ash - shows a list of items you can duplicate with the Full-Length Mirror semi-rare.

//Settings:
boolean setting_show_pastebin_output = true;
boolean setting_show_all_pvpable_items = false; //by default, only shows equipment; when set to true, shows everything you can steal


int __backoffice_script_requests_made = 0;
int [item] __minimum_price_cache;
int minimumMallPrice(item it)
{
	if (__minimum_price_cache contains it)
		return __minimum_price_cache[it];
	//Safety:
	__backoffice_script_requests_made += 1;
	if (__backoffice_script_requests_made >= 10000) //there are about that many items in the game
	{
		abort("Script made too many server requests; aborting as a safety feature.");
		return -1;
	}
	print_html("Looking up price for " + it + "...");
	buffer page_text = visit_url("backoffice.php?iid=" + it.to_int() + "&action=prices&ajax=1");
	
	string unlimited = page_text.group_string("<tr><td>unlimited:</td><td><b>([^<]*)</b>")[0][1];
	string limited = page_text.group_string("<tr><td>limited:</td><td><b>([^<]*)</b>")[0][1];
	
	int price = -1;
	if (unlimited != "")
		price = unlimited.to_int();
	if (limited != "")
	{
		int value = limited.to_int();
		if (price == -1 || price > value)
			price = value;
	}
	__minimum_price_cache[it] = price;
	return price;
}


int item_price(item it)
{
	int value = 0;
	if (!it.is_tradeable())
		value = 0;
	else if (it.historical_age() > 30.0 || (setting_show_pastebin_output && it.historical_price() > 10000))
		value = it.minimumMallPrice(); //it.mall_price();
	else
		value = it.historical_price();
	if (value == -1)
		value = 999999999;
	return value;
}

boolean item_is_pvp_stealable(item it)
{
	if ($items[candy dress shoes,chocolate pocketwatch,candy necktie] contains it) //no
		return false;
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

void main()
{
	item [int] stealables;
	foreach i in $items[]
	{
		if (!setting_show_all_pvpable_items && (i.to_slot() == $slot[none] || I.to_slot() == $slot[familiar]))
			continue;
		
		if (!i.item_is_pvp_stealable())
			continue;
		stealables[stealables.count()] = i;
	}
	
	sort stealables by -item_price(value);
	
	print("Stealable items:");
	foreach key in stealables
	{
		item it = stealables[key];
		int total_price = it.item_price();
		if (total_price < 10000 && setting_show_all_pvpable_items)
			continue;
		if (total_price == 0.0)
			print(it);
		else
		{
			if (setting_show_pastebin_output)
				print(it + " (" + total_price + " meat)");
			else
				print(it.available_amount() + " " + it + " (" + total_price + " meat)");
		}
	}
}