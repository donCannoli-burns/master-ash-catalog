void main()
{
	if ($item[antique tacklebox].available_amount() > 0)
		cli_execute("acquire antique tacklebox");
	cli_execute("equip fishin' hat");
	cli_execute("equip sonar fishfinder");
	foreach e in $effects[Baited Hook,High-Test Fishing Line]
	{
		while (e.have_effect() < min(my_adventures(), 100))
			cli_execute("up " + e);
	}
}