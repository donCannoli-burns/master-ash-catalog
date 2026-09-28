void main()
{
	if (my_level() < 23)
	{
		if ($effect[trivia master].have_effect() == 0)
			cli_execute("up trivia master");
		foreach it in $items[hawking's elixir of brilliance, ointment of the occult, potion of temporary gr8tness, tomato juice of powerful power, ferrigno's elixir of power, philter of phorce]
		{
			if (effect_modifier(it, "effect").have_effect() == 0)
				cli_execute("use " + it);
		}
	}
	cli_execute("acquire 11 new age healing crystal");
	cli_execute("maximize 0.1 HP 1.0 spell damage percent +equip rain-doh green lantern -familiar -tie");
	
	if (!(get_property("lttQuestName") == "Missing: Many Children"))
	{
		if ($effect[Frigidalmatian].have_effect() == 0 && $skill[Frigidalmatian].have_skill())
			cli_execute("cast Frigidalmatian");
	}
	cli_execute("acquire 11 whosit");
	cli_execute("restore hp");
}