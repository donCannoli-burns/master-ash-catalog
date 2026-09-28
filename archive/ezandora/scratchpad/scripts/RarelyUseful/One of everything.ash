void main()
{
	int cutoff = 100000;
	cutoff = 1000;
	cutoff = 500;
	int missing_items = 0;
	int missing_items_under_cutoff = 0;
	int total_to_acquire_easy_items = 0;
	foreach i in $items[]
	{
		if (!is_tradeable(i))
			continue;
		if (to_string(i) == "none")
			continue;
		if (available_amount(i) > 0)
			continue;
		
		int price = 0;
		if (!is_npc_item(i))
		{
			if (historical_age(i) < 11)
				price = historical_price(i);
			else
				price = mall_price(i);
		}
		if (price == 0)
			continue;
		if (price < 0)
			continue;
		boolean cheaper_as_npc = false;
		if (is_npc_item(i) && npc_price(i) != 0)
		{
			if (npc_price(i) < price)
			{
				cheaper_as_npc = true;
				price = npc_price(i);
			}
		}
		missing_items = missing_items + 1;
		if (price < cutoff)
		{
			print(i + " for " + price + " meat.");
			missing_items_under_cutoff = missing_items_under_cutoff + 1;
			total_to_acquire_easy_items = total_to_acquire_easy_items + price;
		}
	}
	print("Tradable missing items: " + missing_items);
	print("Items under cutoff: " + missing_items_under_cutoff);
	print("Total cost: " + total_to_acquire_easy_items);
}