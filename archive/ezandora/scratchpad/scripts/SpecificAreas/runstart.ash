void main(string run_type)
{
	if (!get_property("kingLiberated").to_boolean() && !(my_path() == "Grey Goo"))
	{
		print_html("Free the king first.");
		return;
	}
	if (get_property("ezandoraCustomTimesAscendedToday").to_int() >= 2)
	{
		abort("can't ascend more than twice today, what? " + run_type);
		return;
	}
	
	class desired_class = $class[sauceror];
		
	int path_id = -1;
	int asctype = -1;
	item desired_food = $item[astral six-pack];
	item desired_equipment = $item[astral pet sweater];
	int moonsign_override = -1;
	boolean disable_reading_telegram = false;
	//moonsign_override = 6; //marmot, universally good because clover, no longer good because clovers are unimportant
	
	int intro_adventure_choice_id = -1;
	int intro_adventure_choice_option = -1;
	
	if (run_type == "casual")
	{
		path_id = 0;
		asctype = 1;
	}
	if (run_type == "explosions" || run_type == "explosion")
	{
		desired_class = $class[sauceror];
		path_id = 37;
		moonsign_override = 6; //marmot
		asctype = 2; //normal
	}
	if (run_type == "grey" || run_type == "goo" || run_type == "greygoo" || run_type == "grey goo")
	{
		asctype = 3; //HC
		desired_class = $class[sauceror];
		path_id = 40;
		moonsign_override = 8; //blender, for now
		desired_equipment = $item[astral mace];
		intro_adventure_choice_id = 1419;
		intro_adventure_choice_option = 1;
	}
	if (run_type == "community service" || run_type == "communityservice" || run_type == "cs")
	{
		asctype = 3; //HC
		desired_class = $class[pastamancer];
		if (my_id() == 1557284)
		{
			desired_class = $class[sauceror];
		}
		path_id = 25;
		disable_reading_telegram = true;
		moonsign_override = -1; //don't think we need clovers?
	}
	if (run_type == "g-lover")
	{
		desired_food = $item[astral hot dog dinner];
		desired_equipment = $item[astral ring];
		asctype = 2; //normal
		path_id = 33;
		desired_class = $class[seal clubber];
		
		intro_adventure_choice_id = 1311;
		intro_adventure_choice_option = 1;
	}
	if (run_type == "demiguise")
	{
		if (!(get_campground() contains $item[cornucopia]))
			abort("thanksgarden");
		asctype = 3; //HC
		path_id = 34;
	}
	if (run_type == "loki")
	{
		path_id = 39;
		asctype = 2; //normal
	}
	if (run_type == "quantum")
	{
		asctype = 2; //normal
		path_id = 42;
		desired_equipment = $item[astral mask];
		desired_food = $item[astral hot dog dinner]; //stats
	}
	if (run_type == "small" || run_type == "shrunken" || run_type == "shrunk" || run_type == "tiny")
	{
		desired_food = $item[astral six-pack];
		desired_equipment = $item[astral pet sweater];
		asctype = 2; //normal
		path_id = 49;
		desired_class = $class[disco bandit];
	}
	
	if (path_id == -1) return;
	boolean has_intro_adventure = false;
	if ($ints[40] contains path_id)
	{
		has_intro_adventure = true;
	}
	
	//desired_class = $class[disco bandit]; //pickpocket
	
	if (holiday() != "Feast of Boris" && run_type == "casual" && my_id() != 1877214 && false)
	{
		boolean yes = user_confirm("Are you sure you want to start a new casual?");
		if (!yes)
			return;
		yes = user_confirm("Are you suuuuure?");
		if (!yes)
			return;
		///ascend_as_sauceror = user_confirm("Do you want to ascend as a sauceror? (NO for seal clubber)");
	}
		
	if (asctype == -1) abort("asctype == -1");
	
	cli_execute("call scripts/Utility/death of a casual.ash");
	if (my_adventures() > 40 && false)
	{
		//what are you, a cop? disable
		print_html("Use up those adventures first.");
		return;
	}
	visit_url("ascend.php?action=ascend&confirm=on&confirm2=on");
	visit_url("afterlife.php");
	visit_url("afterlife.php?action=pearlygates");
	
	buffer permery_text = visit_url("afterlife.php?place=permery");
	if (!permery_text.contains_text("It looks like you've already got all of the skills from your last life marked permanent."))
	{
		abort("perm a skill");
		return;
	}
	visit_url("afterlife.php?action=buyarmory&whichitem=" + desired_equipment.to_int());
	//abort("pick the spleen item or wait until PVP season is over");
	
	if (!($items[astral six-pack,astral hot dog dinner] contains desired_food))
	{
		abort("unknown item " + desired_food);
	}
	visit_url("afterlife.php?action=buydeli&whichitem=" + desired_food.to_int());
	
	int sign = 2;
	if ($classes[seal clubber,turtle tamer] contains desired_class)
		sign = 1;
	else if ($classes[disco bandit,accordion thief] contains desired_class)
		sign = 3;
	if (moonsign_override != -1)
		sign = moonsign_override;
	
	if (disable_reading_telegram)
		set_property("autoQuest", "false");
	if (moonsign_override > 50)
		abort("figure out the moonsign id");
	buffer page_text = visit_url("afterlife.php?action=ascend&confirmascend=1&whichsign=" + sign + "&gender=2&whichclass=" + desired_class.to_int() + "&whichpath=" + path_id + "&asctype=" + asctype + "&noskillsok=1&lamesignok=1");
	//print("page_text = " + page_text);
	
	
	if (intro_adventure_choice_id != -1 && intro_adventure_choice_option != -1)
	{
		visit_url("choice.php?whichchoice=" + intro_adventure_choice_id + "&option=" + intro_adventure_choice_option);
	}
	else if (has_intro_adventure)
	{
		visit_url("choice.php");
		run_choice(1);
	}
	if (true)
	{
		//auto hill stealing:
		visit_url("peevpee.php?action=smashstone&confirm=on");
		string win_message = "-1";
		string lose_message = "-1";
		if (visit_url("peevpee.php?place=boards").contains_text("The top of this hill is empty"))
		{
			print("steal the hill, it's empty!");
			visit_url("peevpee.php?action=fight&place=fight&pwd&ranked=1&who=&stance=4&attacktype=flowers&winmessage=" + win_message + "&losemessage=" + lose_message);
		}
	}
	
	visit_url("main.php");
	run_turn();
	if (disable_reading_telegram)
		set_property("autoQuest", "true");
	visit_url("main.php"); //again?
	print_html("Welcome to your new life.");
}