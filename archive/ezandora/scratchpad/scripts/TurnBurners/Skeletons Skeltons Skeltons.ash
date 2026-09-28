void main()
{
	visit_url("shop.php?whichshop=meatsmith");
	visit_url("shop.php?whichshop=meatsmith&action=talk");
	visit_url("choice.php?whichchoice=1059&option=1");
	if ($item[bone with a price tag on it].available_amount() > 0)
		use(1, $item[bone with a price tag on it]);
		
	boolean tried_to_acquire_office_key = false;
	boolean tried_to_acquire_ring = false;
	boolean tried_to_fight_store_manager = false;
	int adventures_tried = 0;
	while (my_adventures() > 0 && adventures_tried < 17)
	{
		if ($item[skeleton key].item_amount() == 0)
			cli_execute("acquire skeleton key");
		
		if ($item[Skeleton Store office key].item_amount() == 0 && !tried_to_acquire_office_key)
		{
			set_property("choiceAdventure1060", "1");
			//tried_to_acquire_office_key = true;
		}
		else if ($item[skeleton key].item_amount() > 0 && $item[ring of telling skeletons what to do].item_amount() == 0 && !tried_to_acquire_ring)
		{
			set_property("choiceAdventure1060", "2");
			//tried_to_acquire_ring = true;
		}
		else if ($item[skeleton store office key].item_amount() > 0 && !tried_to_fight_store_manager)
		{
			set_property("choiceAdventure1060", "4");
			//tried_to_fight_store_manager = true;
		}
		else
			return;
			
		adv1($location[the skeleton store], -1, "");
		adventures_tried += 1;
	}
	visit_url("shop.php?whichshop=meatsmith");
	visi_url("choice.php?whichchoice=1059&option=2");
}