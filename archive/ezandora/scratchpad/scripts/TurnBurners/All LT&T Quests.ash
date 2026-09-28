void main()
{
	int times_started_quest = 0;
	int loops = 0;
	while (times_started_quest < 6 && loops < 10)
	{
		cli_execute("call scripts/TurnBurners/LT&T Quest.ash");
		if (get_property("questLTTQuestByWire") == "unstarted")
		{
			if (my_adventures() < 30) //don't start if we don't have time
				return;
			times_started_quest += 1;
			//Start:
			buffer page_text = visit_url("place.php?whichplace=town_right&action=townright_ltt");
			if (page_text.contains_text("Pay overtime"))
			{
				boolean allowed = false;
				if (page_text.contains_text("value=\"Pay overtime (1,000 Meat)\""))
				{
					allowed = true;
					if (my_meat() < 1000)
						return;
				}
				if (page_text.contains_text("value=\"Pay overtime (10,000 Meat)\""))
				{
					allowed = true;
					if (my_meat() < 10000)
						return;
				}
				if (!allowed)
				{
					print_html("Done.");
					return;
				}
				else
				{
					print_html("Paying overtime.");
					visit_url("choice.php?whichchoice=1171&option=4");
				}
			}
			print_html("Starting LT&T quest.");
			visit_url("choice.php?whichchoice=1171&option=3");
		}
		else if (get_property("questLTTQuestByWire") == "finished")
		{
			return;
		}
		else
			return;
		loops += 1;
	}
}