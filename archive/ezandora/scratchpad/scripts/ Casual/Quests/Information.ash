void main()
{
	if (to_boolean(get_property("__user_casual_ascension_use_tatters")))
		return;
	if (get_property("questM13Escape") == "finished" || contains_text(visit_url("questlog.php?which=2"), "The Pretty Good Escape"))
		return;
	//we should do palindome first, but boring
	//if (get_property("questL11Palindome") != "finished") //We do palindome first because optimal
	//	return;
	//if (my_daycount() > 1) //only worth doing on the first day
	//	return;
	if (available_amount($item[cobb's knob lab key]) == 0)
		return;
	if (available_amount($item[cobb's knob menagerie key]) == 0)
	{
		cli_execute("call scripts/ Casual/Outfit items");
		cli_execute("acquire crystal skull");
		//cli_execute("ccs casualmenageriekey");
		while (available_amount($item[cobb's knob menagerie key]) == 0)
			cli_execute("adventure 1 cobb's knob laboratory");
		cli_execute("call Library/switch to stringozzi serpent combat script.ash");
	}
	cli_execute("acquire 1 goto; acquire 1 weremoose spit; acquire 1 Abominable blubber");
	cli_execute("cobbsknob.php?level=3&action=cell37");
	if (get_property("questM13Escape") == "finished" || contains_text(visit_url("questlog.php?which=2"), "The Pretty Good Escape"))
		return;

	//Acquire subject 37 file:
	if (available_amount($item[Subject 37 file]) == 0)
	{
		cli_execute("call scripts/ Casual/Outfit items");
		cli_execute("acquire crystal skull");
		//cli_execute("ccs casualmenageriekey");
		while (available_amount($item[Subject 37 file]) == 0)
			cli_execute("adventure 1 cobb's knob laboratory");
		cli_execute("call Library/switch to stringozzi serpent combat script.ash");
	}
	cli_execute("cobbsknob.php?level=3&action=cell37");
	cli_execute("cobbsknob.php?level=3&action=cell37");
	cli_execute("cobbsknob.php?level=3&action=cell37");
	cli_execute("cobbsknob.php?level=3&action=cell37");
	cli_execute("unequip hat");
}