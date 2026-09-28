void main()
{
	if (!$familiar[robortender].have_familiar())
		return;
	cli_execute("familiar robortender");
	//Feliz Navidad -> peppermint sprig - candy after every combat
	//single entendre ->bottle of anís - +item?
	//drive-by shooting -> fish head - +meat?
	//Newark -> can of cherry-flavored sterno - I refuse, possibly useless?
	
	if ($item[fish head].available_amount() > 0 && $item[piscatini].available_amount() == 0)
		cli_execute("make piscatini");
	item [item] items_to_feed_and_their_base_components;
	//items_to_feed_and_their_base_components[$item[feliz navidad]] = $item[peppermint sprig]; //candy
	items_to_feed_and_their_base_components[$item[single entendre]] = $item[bottle of an&iacute;s]; //1x item
	items_to_feed_and_their_base_components[$item[drive-by shooting]] = $item[fish head]; //2x meat
	//items_to_feed_and_their_base_components[$item[Newark]] = $item[can of cherry-flavored sterno]; //I refuse!
	
	string robo_drinks_property = get_property("_roboDrinks");
	foreach item_to_feed in items_to_feed_and_their_base_components
	{
		if (robo_drinks_property.contains_text(item_to_feed))
			remove items_to_feed_and_their_base_components[item_to_feed];
	}
	boolean have_all = true;
	foreach item_to_feed, source in items_to_feed_and_their_base_components
	{
		if (item_to_feed.available_amount() + item_to_feed.creatable_amount() == 0)
		{
			print("Need " + item_to_feed + ". Farm a " + source + "?", "red");
			have_all = false;
		}
		if (item_to_feed.available_amount() == 0 && item_to_feed.creatable_amount() > 0)
		{
			cli_execute("make " + item_to_feed);
		}
		if (item_to_feed.available_amount() > 0 && item_to_feed.item_amount() == 0)
		{
			retrieve_item(1, item_to_feed);
		}
	}
	//if (!have_all)
		//return;
		
	foreach item_to_feed in items_to_feed_and_their_base_components
	{
		if (item_to_feed.item_amount() == 0)
		{
			continue;
			//abort("Internal error: can't feed " + item_to_feed);
			//return;
		}
		print("Feeding " + item_to_feed + "...");
		visit_url("inventory.php?action=robooze&whichitem=" + item_to_feed.to_int());
		//inventory.php?action=robooze&whichitem=9387&pwd
	}
	print("Done.");
}