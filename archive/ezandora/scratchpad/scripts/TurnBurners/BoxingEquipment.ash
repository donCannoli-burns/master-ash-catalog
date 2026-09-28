void main(string arguments)
{
	boolean turns_to_spend_initialised = false;
	int turns_to_spend = 0;
	string [int] arguments_split = arguments.split_string(" ");
	boolean end_with_spar = false;
	foreach key, word in arguments_split
	{
		if (is_integer(word))
		{
			turns_to_spend = word.to_int();
			turns_to_spend_initialised = true;
		}
		if (word == "spar")
			end_with_spar = true;
	}
	if (!turns_to_spend_initialised)
	{
		turns_to_spend = -40;
		turns_to_spend_initialised = true;
	}
	if (turns_to_spend < 0)
	{
		turns_to_spend = MAX(0, my_adventures() - (-turns_to_spend));
	}
	int limit = my_adventures() - turns_to_spend;
	boolean did_initial = false;
	while (my_adventures() > limit && !(end_with_spar && my_adventures() <= 3))
	{
		if (!did_initial)
		{
			visit_url("place.php?whichplace=town_wrong&action=townwrong_boxingdaycare");
			visit_url("choice.php?whichchoice=1334&option=3");
			did_initial = true;
			
		}
		int adventures_before = my_adventures();
		buffer page_text = visit_url("choice.php?whichchoice=1336&option=2");
		if (!page_text.contains_text("Boxing Daycare")) break;
		if (my_adventures() == adventures_before && get_property("_daycareGymScavenges").to_int() != 1) break;
		
		string found_amount = page_text.group_string("You manage to find ([0-9]+)")[0][1];
		print("BOXING_EQUIPMENT•2•" + my_ascensions() + "•" + my_turncount() + "•" + found_amount);
	}
	visit_url("choice.php?whichchoice=1336&option=5");
	visit_url("choice.php?whichchoice=1334&option=4");
	if (end_with_spar && my_adventures() > 0 && false)
		abort("spar");
	if (!get_property("_daycareNap").to_boolean())
	{
		cli_execute("daycare item");
	}
	print_html("Done");
}