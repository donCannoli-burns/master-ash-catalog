//This script is in the public domain.

string __version = "1.0";

int __backoffice_script_requests_made = 0;
int [item] __minimum_price_cache;
//"allow_limited" means "limited to X purchases/day"
int minimumMallPrice(item it, boolean allow_limited, boolean allow_cache, boolean silence)
{
	//Safety:
	if (allow_cache)
	{
		if (__minimum_price_cache contains it)
			return __minimum_price_cache[it];
	}
	__backoffice_script_requests_made += 1;
	if (__backoffice_script_requests_made >= 10000) //there are about that many items in the game
	{
		abort("Script made too many server requests; aborting as a safety feature.");
		return -1;
	}
	if (!silence)
	{
		print_html("Looking up price for " + it + "...");
	}
	buffer page_text = visit_url("backoffice.php?iid=" + it.to_int() + "&action=prices&ajax=1");
	
	string unlimited = page_text.group_string("<tr><td>unlimited:</td><td><b>([^<]*)</b>")[0][1];
	string limited = page_text.group_string("<tr><td>limited:</td><td><b>([^<]*)</b>")[0][1];
	
	int price = -1;
	if (unlimited != "")
		price = unlimited.to_int();
	if (limited != "" && allow_limited)
	{
		int value = limited.to_int();
		if (price == -1 || price > value)
			price = value;
	}
	__minimum_price_cache[it] = price;
	return price;
}

int minimumMallPrice(item it, boolean allow_limited)
{
	return minimumMallPrice(it, allow_limited, false, false);
}

string convertIntegerToStringWithCommas(int value)
{
	string step_1 = value.to_string();
	//Is ln() in mafia...?
	int integer_count = 0;
	for i from 0 to step_1.length() - 1
	{
		string s = step_1.char_at(i);
		if (is_integer(s) && s != "-")
			integer_count += 1;
	}
	if (integer_count <= 3)
		return step_1;
	
	buffer result;
	int counter = 0;
	if (integer_count % 3 == 1)
		counter = 2;
	if (integer_count % 3 == 2)
		counter = 1;
	if (integer_count % 3 == 0)
		counter = 0;
	for i from 0 to step_1.length() - 1
	{
		string c = step_1.char_at(i);
		result.append(c);
		if (is_integer(c) && c != "-")
			counter += 1;
		if (counter >= 3 && i != step_1.length() - 1)
		{
			result.append(",");
			counter = 0;
		}
	}
	
	return result;
}

void snowcones()
{
	int total = 0;
	foreach it in $items[]
	{
		if (!it.tradeable) continue;
		if (it.skill_modifier("skill") == $skill[none]) continue;
		
		int price = it.minimumMallPrice(true);
		print_html(it + ": " + price);
		total += price;
	}
	print_html("Total: " + total);
}

void main()
{
	if (false)
	{
		//minor test:
		foreach i in $ints[1, 10, 100, 1000, 50000, 200123123, 3125235, 40365669, 4575705693, -123456789]
			print_html(convertIntegerToStringWithCommas(i));
		return;
	}
	print_html("Capital.ash version " + __version);
	
	refresh_shop(); //won't load by default
	item [int] owned_items;
	int [item] owned_items_amount;
	int [item] owned_items_price;
	
	int liquid_meat = my_meat() + my_storage_meat() + my_closet_meat();
	int total_meat_value = liquid_meat;
	int display_case_meat_value = 0;
	int store_meat_value = 0;
	
	int [item] items_equipped_on_familiars;
	//equipped_amount() does not take into account familiars we aren't running at the moment:
	foreach f in $familiars[]
	{
		if (!f.have_familiar())
			continue;
		if (my_familiar() == f)
			continue;
		item equipped_item = f.familiar_equipped_equipment();
		if (equipped_item != $item[none])
			items_equipped_on_familiars[equipped_item] += 1;
	}
	
	foreach it in $items[]
	{
		if (!it.tradeable) continue;
		int amount_own = it.item_amount() + it.equipped_amount() + it.closet_amount() + it.shop_amount() + it.storage_amount() + it.display_amount();
		if (items_equipped_on_familiars contains it)
			amount_own += items_equipped_on_familiars[it];
		if (amount_own == 0)
			continue;
			
		owned_items[owned_items.count()] = it;
		owned_items_amount[it] = amount_own;
		
		owned_items_price[it] = -1;
		
	}
	
	boolean [item] additional_items_to_search;
	//Find zappables/foldables:
	foreach it in owned_items_price
	{
		foreach it2 in it.get_related("fold")
		{
			additional_items_to_search[it2] = true;
		}
		foreach it2 in it.get_related("zap")
		{
			additional_items_to_search[it2] = true;
		}
	}
	//Add them to prices to search:
	foreach it in additional_items_to_search
	{
		owned_items_price[it] = -1;
	}
	//Discover prices:
	foreach it in owned_items_price
	{
		int price = 0;
		
		int age_limit = 60;
		int historical_price = it.historical_price();
		if (historical_price > 100000)
			age_limit = 15;
		if (historical_price < 1000)
			age_limit = 120;
		if (historical_price > 100000000)
			age_limit = 3;
		
		int historical_age = it.historical_age();
		
		if (historical_age > age_limit)
			price = it.mall_price();
		else
			price = historical_price;
		
		if (price >= 1000000 || price * owned_items_amount[it] >= 2000000 || price == -1)
		{
			boolean allow_limited = true;
			if (owned_items_amount[it] >= 20)
				allow_limited = false;
			price = minimumMallPrice(it, allow_limited);
		}
		int theoretical_mall_minimum = MAX(100, it.autosell_price() * 2);
		if (price == theoretical_mall_minimum)
		{
			//assume mall minimum is essentially worthless (this may not be true for some things, like bricko bricks?)
			if (it.autosell_price() > 0)
				price = it.autosell_price();
			else
				price = 1;
		}
		owned_items_price[it] = price;
	}
	//Make the price of an item equal to the minimum of its related:
	//(i.e., a radio free baseball cap, pants, and foil should all be the same "value", since they're zappable)
	foreach it, price in owned_items_price
	{
		foreach it2 in it.get_related("fold")
		{
			price = min(price, owned_items_price[it2]);
		}
		foreach it2 in it.get_related("zap")
		{
			price = min(price, owned_items_price[it2]);
		}
		owned_items_price[it] = price;
	}
	
	//Calculate total meat value:
	foreach it, price in owned_items_price
	{
		total_meat_value += price * owned_items_amount[it];
		display_case_meat_value += price * it.display_amount();
		store_meat_value += price * it.shop_amount();
	}
	
	sort owned_items by owned_items_amount[value] * owned_items_price[value];
	
	//Display:
	foreach key, it in owned_items
	{
		string line;
		line = owned_items_amount[it] + " ";
		if (owned_items_amount[it] > 1)
			line += it.plural;
		else
			line += it;
		line += " worth ";
		line += convertIntegerToStringWithCommas(owned_items_price[it]);
		line += " each for a total of ";
		line += convertIntegerToStringWithCommas(owned_items_price[it] * owned_items_amount[it]);
		print_html(line);
	}
	print_html("Liquid meat: " + convertIntegerToStringWithCommas(liquid_meat));
	if (display_case_meat_value > 0)
		print_html("Display case worth: " + convertIntegerToStringWithCommas(display_case_meat_value));
	if (store_meat_value > 0)
		print_html("Mall store worth: " + convertIntegerToStringWithCommas(store_meat_value));
	print_html("Total net worth: " + convertIntegerToStringWithCommas(total_meat_value));
}