void calculateExtraItemsForLocation(location l, item [int] extra_items)
{
	if (l == $location[No Man's And Also No Skeleton's Land])
	{
		extra_items[extra_items.count()] = $item[chocolate and nylons detector];
	}
}

void prepareTurnForLocation(location target_location)
{
	int item_desired = 0;
	if (target_location == $location[Smoldering Bone Spikes])
	{
		item_desired = 567;
	}
	if (target_location == to_location("Smoldering Fingerbones"))
	{
		item_desired = 567;
	}
	if (item_desired > 0)
		cli_execute("gain silent " + item_desired + " item 200 spendperturn");
}

slot advanceAccessorySlot(slot acc)
{
	if (acc == $slot[acc1]) return $slot[acc2];
	if (acc == $slot[acc2]) return $slot[acc3];
	if (acc == $slot[acc3]) return $slot[none];
	return $slot[none];
}

void farmArea(location target_location, int turns)
{
	use_familiar($familiar[Reagnimated Gnome]);
	equip($item[gnomish housemaid's kgnee], $slot[familiar]); //'
	cli_execute("maximize familiar weight -familiar -tie");
	
	
	item [int] extra_items;
	extra_items[extra_items.count()] = $item[mafia thumb ring];
	
	calculateExtraItemsForLocation(target_location, extra_items);
	
	slot next_accessory_slot = $slot[acc1];
	
	foreach key, it in extra_items
	{
		slot s = it.to_slot();
		if (s == $slot[acc1] || s == $slot[acc2] || s == $slot[acc3])
		{
			s = next_accessory_slot;
			next_accessory_slot = advanceAccessorySlot(next_accessory_slot);
		}
		equip(it, s);
	}
	
	int turns_stopping_point = my_turncount() + turns;
	if (turns == -1) turns_stopping_point += 100000;
	
	while (my_turncount() < turns_stopping_point && my_adventures() > 0)
	{
		prepareTurnForLocation(target_location);
		cli_execute("gain silent familiar weight 100 spendperturn");
		adv1(target_location);
	}
	
}

void main(string arguments)
{
	farmArea(arguments.to_location(), -1);
}