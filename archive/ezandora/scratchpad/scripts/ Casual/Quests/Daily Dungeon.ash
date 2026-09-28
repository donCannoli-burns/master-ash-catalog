

void main()
{
	if (to_boolean(get_property("dailyDungeonDone")))
		return;

	cli_execute("adventure * daily dungeon");
	if (available_amount($item[fat loot token]) > 1) //closet extras
	{
		cli_execute("closet put -1 fat loot token");
	}
}