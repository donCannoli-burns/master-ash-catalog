void main()
{
	if (!$monster[resort waiter].is_banished() || !$monster[lovestruck tropical honeymooners].is_banished())
	{
		print_html("maximize pickpocket chance -equip tiny black hole +equip bling of the new wave +equip pantsgiving -tie");
		return;
	}
	set_auto_attack(99121385);
	
	//maximize pickpocket chance -equip tiny black hole +equip bling of the new wave +equip pantsgiving -tie
	//bjornify warbear drone
	int limit = 400;
	int initial_tatter_count = $item[tattered scrap of paper].item_amount();
	while ($item[tattered scrap of paper].item_amount() > 50 && $item[tattered scrap of paper].item_amount() - initial_tatter_count < limit)
	{
		if ($effect[tropical contact high].have_effect() == 0)
		{
			print("get there fast");
			return;
		}
		adv1($location[kokomo resort], 0, "");
	}
}