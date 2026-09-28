void main()
{
	//too late, not safe:
	if (gametime_to_int() >= 86000000)
	{
		return;
	}
	
	if (true && can_interact())
	{
		item [int] stash_items_to_use;
		if (!get_property("expressCardUsed").to_boolean())
		{
			stash_items_to_use[stash_items_to_use.count()] = $item[Platinum Yendorian Express Card];
		}
		if (!get_property("_bagOTricksUsed").to_boolean())
		{
			stash_items_to_use[stash_items_to_use.count()] = $item[Bag o' Tricks]; //'
		}
		foreach key, it in stash_items_to_use
		{
			if (it.available_amount() > 0)
			{
				cli_execute("use " + it);
			}
			else
			{
				if (stash_amount(it) > 0 && get_clan_id() == 4242)
				{
					take_stash(1, it);
					try
					{
						use(1, it);
					}
					finally
					{
						put_stash(1, it);
					}
				}
			}
		}
	}
}