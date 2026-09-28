void parseLastCombat(int turncount_attempted, boolean intro)
{
	buffer text = run_combat();
	string match = text.group_string("You flip open the Big Book of Pirate Insults and pick one at random.(.*?)<center><table>")[0][1];
	print("LARS_PIRATE_INSULT_SPADING|" + intro + "|" + (turncount_attempted) + "|" + match);
}

void main()
{
	parseLastCombat(my_turncount() - 1, true);
	while (my_adventures() > 0)
	{
		int turncount = my_turncount();
		adv1($location[barrrney's barrr], 0, ""); //'
		if (get_property("lastEncounter").to_monster() == last_monster())
			parseLastCombat(turncount, false);
		//break;
	}
}