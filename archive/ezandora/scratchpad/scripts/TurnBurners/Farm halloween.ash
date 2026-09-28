void main()
{
	if ($familiar[trick-or-treating tot].have_familiar())
		cli_execute("familiar trick-or-treating tot");
	if ($item[mafia thumb ring].available_amount() > 0)
		cli_execute("equip acc2 mafia thumb ring");
	cli_execute("call scripts/RarelyUseful/farm halloween once.ash");
	while (my_adventures() >= 5)
	{
		visit_url("place.php?whichplace=town&action=town_trickortreat", false);
		visit_url("choice.php?whichchoice=804&option=1");
		cli_execute("call scripts/RarelyUseful/farm halloween once.ash");
	}
}