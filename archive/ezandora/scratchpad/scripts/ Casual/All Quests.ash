void insureTatteredCount()
{
	if (to_boolean(get_property("__user_casual_ascension_use_tatters")))
	{
		if (available_amount($item[tattered scrap of paper]) < 200)
			cli_execute("acquire 200 tattered scrap of paper");
	}
}


void doQuestScript(string script_name)
{
	int adventure_limit = 30;
	if (my_adventures() < adventure_limit)
	{
		return;
	}
	insureTatteredCount();
	if (to_boolean(get_property("__user_casual_ascension_use_tatters")) && available_amount($item[tattered scrap of paper]) < 200)
	{
		abort("need tattered scrap of paper");
		return;
	}
	if (my_meat() < 150000)
	{
		abort("need more meat");
		return;
	}
	cli_execute("call " + script_name);
}

boolean doneWithAllQuests()
{
	string [15] quest_names;
	quest_names[0] = "questL02Larva";
	quest_names[1] = "questL03Rat";
	quest_names[2] = "questL04Bat";
	quest_names[3] = "questL05Goblin";
	quest_names[4] = "questL06Friar";
	quest_names[5] = "questL07Cyrptic";
	quest_names[6] = "questL08Trapper";
	quest_names[7] = "questL09Topping";
	quest_names[8] = "questL10Garbage";
	quest_names[9] = "questL11MacGuffin";
	quest_names[10] = "questL11Manor";
	quest_names[11] = "questL11Palindome";
	quest_names[12] = "questL11Pyramid";
	quest_names[13] = "questL11Worship";
	quest_names[14] = "questL12War";

	foreach i in quest_names
	{
		string quest_name = quest_names[i];
		if (get_property(quest_name) != "finished")
			return false;
	}
	return true;
}

void main()
{	int available_drunkness = inebriety_limit() - my_inebriety();
	if (available_drunkness < 0)
	{
		print("you're drunk");
		return;
	}

	cli_execute("council.php");
	doQuestScript("Quests/Level 13 Quest.ash");
	cli_execute("guild.php?place=challenge");
	doQuestScript("Quests/Information.ash");
	doQuestScript("Quests/Boss Bat.ash");
	doQuestScript("Quests/Goblin King.ash");
	doQuestScript("Quests/Daily Dungeon.ash");
	doQuestScript("Quests/Mosquito.ash");
	doQuestScript("Quests/Temple Unlock.ash");
	doQuestScript("Quests/Haunted Ballroom Unlock.ash");

	doQuestScript("Quests/Friars.ash");
	doQuestScript("Quests/Steel Margarita.ash");
	doQuestScript("Quests/tavern quest.ash");

	doQuestScript("Quests/mclargehuge.ash");
	doQuestScript("Quests/Cyrpt.ash");
	doQuestScript("Quests/Level 9 Quest.ash");
	doQuestScript("Quests/Level 10 Quest.ash");
	doQuestScript("Quests/Pirate Fledges.ash");
	doQuestScript("Quests/Level 11 Quest.ash");
	doQuestScript("Quests/Level 12 Quest.ash");
	doQuestScript("Quests/zapwand.ash"); //zap wand before level 13
	doQuestScript("Quests/Level 13 Quest.ash");

	cli_execute("council.php");
	if (available_amount($item[strange leaflet]) > 0)
		cli_execute("leaflet");
	print("Done");
	if (doneWithAllQuests())
	{
		if (my_level() == 12)
			print("Gain a level, then go forth to her lair!");
		else if (my_level() < 12)
			print("Gain... several levels? you deleveled? Then go forth to her lair!");
	}

}