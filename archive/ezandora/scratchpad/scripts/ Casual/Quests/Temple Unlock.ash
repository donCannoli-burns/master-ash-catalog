void doSneakyAdventure(string area)
{		if (have_effect($effect[fresh scent]) == 0)		cli_execute("use 1 chunk of rock salt");	if (have_effect($effect[Smooth Movements]) == 0)		cli_execute("cast smooth movement");	if (have_effect($effect[Sonata of Sneakiness]) == 0)		cli_execute("cast sonata");	cli_execute("adventure 1  " + area);
}

void sneakyAdventure(item target_item, string area, int turn_limit)
{
	int turns = 0;
	while (available_amount(target_item) == 0)
	{
		doSneakyAdventure(area);
		turns = turns + 1;
		if (turns == turn_limit)
			return;
	}
}

void main()
{
	if (my_basestat($stat[mysticality]) < 25) //need ring of conflict
		return;
	if (to_int(get_property("lastTempleUnlock")) >= my_ascensions())
		return;

	cli_execute("call ../Outfit Experience");
	cli_execute("call ../Outfit -combat");

	//spooky-gro fertilizer: choiceAdventure502 = 3, choiceAdventure506 = 2
	//spooky quest coin: choiceAdventure502 = 2, choiceAdventure505 = 2
	//spooky temple map then skip adventure: choiceAdventure502 = 3, choiceAdventure506 = 3
	//spooky sapling and sell bar skins: choiceAdventure502 = 1, choiceAdventure503 = 3, choiceAdventure504 = 3? 4?

	//Acquire spooky sapling:
	if (available_amount($item[spooky sapling]) == 0)
	{
		cli_execute("set choiceAdventure502 = 1");
		cli_execute("set choiceAdventure503 = 3");
		cli_execute("set choiceAdventure504 = 4");
		sneakyAdventure($item[spooky sapling], "spooky forest", 10);
	}
	//Acquire spooky-gro fertilizer:
	if (available_amount($item[spooky-gro fertilizer]) == 0)
	{
		cli_execute("set choiceAdventure502 = 3");
		cli_execute("set choiceAdventure506 = 2");
		sneakyAdventure($item[spooky-gro fertilizer], "spooky forest", 10);
	}
	//Acquire the tree-holed coin, if we don't have the spooky temple map:
	if (available_amount($item[tree-holed coin]) == 0 && available_amount($item[spooky temple map]) == 0)
	{
		cli_execute("set choiceAdventure502 = 2");
		cli_execute("set choiceAdventure505 = 2");
		sneakyAdventure($item[tree-holed coin], "spooky forest", 10);
	}
	//Acquire the spooky temple map, if we have the tree-holed coin:
	if (available_amount($item[tree-holed coin]) > 0 && available_amount($item[spooky temple map]) == 0)
	{
		cli_execute("set choiceAdventure502 = 2");
		cli_execute("set choiceAdventure506 = 3");
		cli_execute("set choiceAdventure507 = 1");
		sneakyAdventure($item[spooky temple map], "spooky forest", 10);
	}
	//Use spooky map:
	if (available_amount($item[spooky temple map]) > 0 && available_amount($item[spooky sapling]) > 0 && available_amount($item[spooky-gro fertilizer]) > 0)
		cli_execute("use spooky temple map");
	cli_execute("call ../Outfit Experience");
}