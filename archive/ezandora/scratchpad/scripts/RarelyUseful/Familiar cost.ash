int item_price(item it)
{
	if (!it.is_tradeable())
		return 0.0;
	if (it.historical_age() > 30.0)
		return it.mall_price();
	return it.historical_price();
}


void main()
{
	familiar [int] missing_familiars;
	foreach f in $familiars[]
	{
		if (f.have_familiar())
			continue;
		missing_familiars[missing_familiars.count()] = f;
	}
	sort missing_familiars by (value.hatchling.item_price() <= 0 ? 10000000000 : value.hatchling.item_price());
	
	foreach key in missing_familiars
	{
		familiar f = missing_familiars[key];
		item hatchling = f.hatchling;
		int price = hatchling.item_price();
		//if (price <= 0)
			//continue;
		print(f + " (" + hatchling + ") for " + price + " meat.");
	}
}