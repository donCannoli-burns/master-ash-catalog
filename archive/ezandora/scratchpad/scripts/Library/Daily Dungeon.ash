import "scripts/Library/PrecheckSemirare.ash";

void main()
{
	if (get_property_boolean("dailyDungeonDone"))
		return;
	if (my_inebriety() > inebriety_limit()) return;
	familiar starting_familiar = my_familiar();
	
	foreach f in $familiars[intergnat,ms. puck man,hovering sombrero]
	{
		if (f.have_familiar())
		{
			use_familiar(f);
			break;
		}
	}
	cli_execute("refresh inventory; acquire eleven-foot pole; acquire Pick-O-Matic lockpicks");
	cli_execute("maximize hp, mp, exp -tie -equip the superconductor's cpu");
	set_property("choiceAdventure692", 3); //door
	set_property("choiceAdventure693", 2); //trap
	set_property("choiceAdventure690", 2); //treasure chest
	set_property("choiceAdventure691", 2); //treasure chest
	set_property("choiceAdventure689", 1); //treasure chest
	//if ($skill[saucegeyser].have_skill())
		//cli_execute("autoattack saucegeyser");
	if ($item[ring of detect boring doors].available_amount() > 0 && $item[ring of detect boring doors].equipped_amount() == 0)
		cli_execute("equip acc3 ring of detect boring doors");
	if ($slot[weapon].equipped_item() == $item[none])
	{
		if (my_primestat() == $stat[moxie])
			cli_execute("equip disco ball"); //something
		else
			cli_execute("equip seal-clubbing club");
	}
	int max_attempts = 15;
	while (max_attempts > 0 && !get_property_boolean("dailyDungeonDone") && my_adventures() > 0)
	{
		precheckSemirare();
		restore_mp(16);
		adv1($location[the daily dungeon], -1, "");
		max_attempts -= 1;
	}
	cli_execute("autoattack none");
	if (starting_familiar != my_familiar())
		use_familiar(starting_familiar);
}