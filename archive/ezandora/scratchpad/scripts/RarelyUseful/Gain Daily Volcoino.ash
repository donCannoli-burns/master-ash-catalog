void main()
{
	if (get_property("_infernoDiscoVisited").to_boolean())
		return;
	int accessories_equipped = 0;
	foreach it in $items[smooth velvet hanky,smooth velvet hat,smooth velvet pants,smooth velvet pocket square,smooth velvet shirt,smooth velvet socks]
	{
		if (it.equipped_amount() > 0)
			continue;
		
		if (it.to_slot() == $slot[acc1])
		{
			cli_execute("equip acc" + (accessories_equipped + 1) + " " + it);
			accessories_equipped += 1;
		}
		else
			cli_execute("equip " + it);
	}
	visit_url("place.php?whichplace=airport_hot&action=airport4_zone1");
	visit_url("choice.php?whichchoice=1090&option=7"); //50k each?
}