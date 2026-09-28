void doSneakyAdventure(string area)
{		if (have_effect($effect[fresh scent]) == 0)		cli_execute("use 1 chunk of rock salt");	if (have_effect($effect[Smooth Movements]) == 0)		cli_execute("cast smooth movement");	if (have_effect($effect[Sonata of Sneakiness]) == 0)		cli_execute("cast sonata");	cli_execute("adventure 1  " + area);
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
	if (my_level() < 2) return;
	if (get_property("questL02Larva") == "finished")
		return;
	if (!contains_text(visit_url("questlog.php?which=1"), "Looking for a Larva in All the Wrong Places"))
		return;
	if (my_basestat($stat[mysticality]) < 25) //need ring of conflict
		return;
	cli_execute("call ../Outfit Experience");
	cli_execute("call ../Outfit -combat");
	cli_execute("call Library/UseHipster.ash");
	//mosquito larva: choiceAdventure502 = 2, choiceAdventure505 = 1
	//spooky-gro fertilizer: choiceAdventure502 = 3, choiceAdventure506 = 2
	//spooky quest coin: choiceAdventure502 = 2, choiceAdventure505 = 2
	//spooky sapling and sell bar skins: choiceAdventure502 = 1, choiceAdventure503 = 3, choiceAdventure504 = 3? 4?
	//spooky temple map then skip adventure: choiceAdventure502 = 3, choiceAdventure506 = 3

	//choiceAdventure502:
	//choiceAdventure503:
	//choiceAdventure505:
	//choiceAdventure506:
	cli_execute("set choiceAdventure502 = 2");
	cli_execute("set choiceAdventure505 = 1");
	
	sneakyAdventure($item[Mosquito larva], "spooky forest");


	cli_execute("call ../Outfit experience");
	cli_execute("council.php");
}