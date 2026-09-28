void sneakyAdventure(item target_item, string area)
{
	while (available_amount(target_item) == 0)
	{
		if (have_effect($effect[fresh scent]) == 0)
			cli_execute("use 1 chunk of rock salt");
		if (have_effect($effect[Smooth Movements]) == 0)
			cli_execute("cast smooth movement");
		if (have_effect($effect[Sonata of Sneakiness]) == 0)
			cli_execute("cast sonata");
		cli_execute("adventure 1  " + area);
	}
}

void main()
{
	if (my_level() < 6) return;
	if (get_property("questL06Friar") == "finished")
		return;
	if (!contains_text(visit_url("questlog.php?which=1"), "Trial By Friar"))
		return;
	if (my_basestat($stat[mysticality]) < 25) //need ring of conflict
		return;

	cli_execute("friars.php?action=friars");
	cli_execute("call ../Outfit -combat");

	sneakyAdventure($item[dodecagram], "dark neck of the woods");
	sneakyAdventure($item[Box of birthday candles], "dark heart of the woods");
	sneakyAdventure($item[Eldritch butterknife], "dark elbow of the woods");

	cli_execute("call ../Outfit experience");

	cli_execute("friars.php?action=ritual");
	cli_execute("council.php");
	cli_execute("friars familiar");
}