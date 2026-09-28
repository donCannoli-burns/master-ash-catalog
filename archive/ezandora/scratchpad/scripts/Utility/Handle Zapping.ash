void rebalanceItems(boolean [item] items, boolean use_up_entirety_of_wand)
{
	int times_to_use = 1;
	if (use_up_entirety_of_wand)
		times_to_use = 9999;
	while (get_property("_zapCount").to_int() < times_to_use)
	{
		if ($item[aluminum wand].available_amount() == 0 && $item[ebony wand].available_amount() == 0 && $item[hexagonal wand].available_amount() == 0 && $item[marble wand].available_amount() == 0 && $item[pine wand].available_amount() == 0) return;
		item minimum_item = $item[none];
		item maximum_item = $item[none];
		foreach it in items
		{
			if (minimum_item == $item[none])
				minimum_item = it;
			if (maximum_item == $item[none])
				maximum_item = it;
			if (it.available_amount() < minimum_item.available_amount())
			{
				minimum_item = it;
			}
			if (it.available_amount() > maximum_item.available_amount())
			{
				maximum_item = it;
			}
		}
		if (maximum_item.available_amount() > 0 && maximum_item.available_amount() > minimum_item.available_amount() + 1)
		{
			if (to_int(get_property("lastZapperWand")) != my_ascensions())
			{
				cli_execute("call scripts/Utility/Collect Zap Wand.ash");
			}
			if (maximum_item.item_amount() == 0)
			{
				retrieve_item(maximum_item, 1);
			}
			cli_execute("zap " + maximum_item);
		}
	}
}

void main()
{
	boolean use_up_entirety_of_wand = (get_property("ezandoraCustomTimesAscendedToday").to_int() == 0);
	rebalanceItems($items[cursed pirate cutlass, cursed tricorn hat, cursed swash buckle], use_up_entirety_of_wand);
}