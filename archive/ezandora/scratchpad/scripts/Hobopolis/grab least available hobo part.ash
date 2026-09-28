import <canadv.ash>

void main(int part_count)
{
	if (part_count < 0 || part_count > 200)
		abort("Invalid part count " + part_count);
	cli_execute("set choiceAdventure230 = 2"); //binder	cli_execute("set choiceAdventure272 = 2"); //marketplace	cli_execute("set choiceAdventure225 = 0"); //attention a tent
	cli_execute("set choiceAdventure200 = 2"); //hoboverlord
	cli_execute("autoattack fury of the time lord");
	cli_execute("outfit Hamster Run");
	cli_execute("mood hamsterrun");
	cli_execute("call autotune least available part.ash");
	if (!can_adv($location["Hobopolis Town Square"], false))
	{
		abort("Hobopolis inaccessible.");
	}
	int n = 0;
	while (n < part_count)
	{
		cli_execute("adventure 1 hobopolis town square");
		cli_execute("call autotune least available part.ash");

		n = n + 1;
	}
}