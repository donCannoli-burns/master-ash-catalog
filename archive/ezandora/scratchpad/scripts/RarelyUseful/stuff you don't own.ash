

void main()
{
	int missing_item_count = 0;
	int tradable_missing_item_count = 0;
	int [int] cheap_missing_item_counts;
	int [int] cheap_missing_item_totals;
	int [int] price_cutoffs;

	price_cutoffs[count(price_cutoffs)] = 100;
	price_cutoffs[count(price_cutoffs)] = 500;
	price_cutoffs[count(price_cutoffs)] = 1000;
	price_cutoffs[count(price_cutoffs)] = 2000;
	price_cutoffs[count(price_cutoffs)] = 10000;
	price_cutoffs[count(price_cutoffs)] = 100000;
	foreach i in $items[]
	{
		int price = -1;
		if (available_amount(i) + display_amount(i) > 0)
			continue;
		missing_item_count = missing_item_count + 1;
		if (!is_tradeable(i))
			continue;
		
		if (historical_age(i) > 7)
			price = mall_price(i);
		else
			price = historical_price(i);
		//print("You don't have " + i + " for " + price + " meat.");
		tradable_missing_item_count = tradable_missing_item_count + 1;
		foreach j in price_cutoffs
		{
			int price_cutoff = price_cutoffs[j];
			if (price < price_cutoff && price != -1)
			{
				cheap_missing_item_counts[j] = cheap_missing_item_counts[j] + 1;
				cheap_missing_item_totals[j] = cheap_missing_item_totals[j] + price;
			}
		}
	}
	print("You are missing " + missing_item_count + " items.");
	print("You are missing " + tradable_missing_item_count + " buyable items.");
	
	foreach j in price_cutoffs
	{
		print("Limit " + price_cutoffs[j] + ": you are missing " + cheap_missing_item_counts[j] + " cheap buyable items costing " + cheap_missing_item_totals[j] + " meat.");
	}
}