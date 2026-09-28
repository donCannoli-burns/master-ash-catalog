void main()
{
	if (get_campground()[$item[pagoda plans]] > 0)
		return;
	if (!can_interact())
		return;
	if ($item[hey deze nuts].item_amount() == 0)
	{
		while ($item[hey deze map].item_amount() == 0)
		{
			adv1($location[pandamonium slums], 0, "");
		}
		string [int] things_to_do;
		string [int] things_to_buy;
		if ($item[heavy metal sonata].item_amount() == 0)
			cli_execute("acquire 1 heavy metal sonata");
		if ($item[heavy metal thunderrr guitarrr].item_amount() == 0)
			cli_execute("acquire 1 heavy metal thunderrr guitarrr");
		if ($item[guitar pick].item_amount() == 0)
			cli_execute("acquire 1 guitar pick");
		
		cli_execute("use hey deze map");
	}
	if ($item[pagoda plans].item_amount() == 0)
	{
		if ($item[Elf Farm Raffle ticket].item_amount() == 0)
		{
			cli_execute("acquire elf farm raffle ticket");
		}
		string previous_clover_property = get_property("cloverProtectActive");
		set_property("cloverProtectActive", "false");
		cli_execute("acquire ten-leaf clover; use elf farm raffle ticket");
		set_property("cloverProtectActive", previous_clover_property);
	}
	if ($item[ketchup hound].item_amount() == 0)
	{
		cli_execute("acquire ketchup hound");
	}
	if ($item[ketchup hound].item_amount() > 0 && $item[hey deze nuts].item_amount() > 0 && $item[pagoda plans].item_amount() > 0)
	{
		cli_execute("use ketchup hound");
	}
}