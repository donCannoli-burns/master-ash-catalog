void doSneakyAdventure(string area)
{		if (have_effect($effect[fresh scent]) == 0)		cli_execute("use 1 chunk of rock salt");	if (have_effect($effect[Smooth Movements]) == 0)		cli_execute("cast smooth movement");	if (have_effect($effect[Sonata of Sneakiness]) == 0)		cli_execute("cast sonata");	if (have_effect($effect[Teleportitis]) > 0)		cli_execute("uneffect Teleportitis");	cli_execute("adventure 1  " + area);
}

void sneakyAdventure(item target_item, string area)
{
	while (available_amount(target_item) == 0)
	{
		doSneakyAdventure(area);
	}
}

void main()
{
	if (my_level() < 10) return; //let's do this later
	if (to_int(get_property("lastZapperWand")) == my_ascensions()) //already acquired one, and one is enough for anybody
		return;

	if (to_int(get_property("lastPlusSignUnlock")) < my_ascensions())
	{
		//Acquire plus sign:
		if (available_amount($item[plus sign]) == 0)
		{
			cli_execute("set choiceAdventure451 = 3");
			cli_execute("call ../Outfit experience");
			cli_execute("call ../Outfit -combat");
			sneakyAdventure($item[plus sign], "greater-than sign");
		}
		if (available_amount($item[plus sign]) > 0)
		{
			cli_execute("set choiceAdventure3 = 3");
			cli_execute("call Library/switch to cannelloni combat script.ash");
			while (to_int(get_property("lastPlusSignUnlock")) < my_ascensions())
			{				if (have_effect($effect[Teleportitis]) == 0)					cli_execute("use potion of teleportitis");				cli_execute("adventure 1 greater-than sign");
			}
			cli_execute("uneffect teleportitis");
			cli_execute("use plus sign");
		}
	}
	if (to_int(get_property("lastPlusSignUnlock")) < my_ascensions())
		return;

	//Now acquire wand if we don't have one:
	if (available_amount($item[aluminum wand]) == 0 && available_amount($item[ebony wand]) == 0 && available_amount($item[hexagonal wand]) == 0 && available_amount($item[marble wand]) == 0 && available_amount($item[pine wand]) == 0)
	{
		cli_execute("call ../Outfit experience");
		cli_execute("call ../Outfit -combat");
		cli_execute("set choiceAdventure25 = 2");
		sneakyAdventure($item[dead mimic], "dungeons of doom");
		if (available_amount($item[dead mimic]) > 0)
			cli_execute("use dead mimic");
	}
}