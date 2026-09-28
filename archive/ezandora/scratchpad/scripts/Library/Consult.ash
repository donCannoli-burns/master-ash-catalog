int get_clan_id_safe()
{
    visit_url("clan_viplounge.php");
    get_clan_id();
    return get_clan_id();
}

boolean switchToClan(int clan_id)
{
	visit_url("showclan.php?whichclan=" + clan_id + "&action=joinclan&confirm");
    return get_clan_id_safe() == clan_id;
}



//Returns true if done, false otherwise.
boolean consult(string clanmate, string q1, string q2, string q3)
{
	print_html("Attempting consult...");
	buffer page_text = visit_url("clan_viplounge.php?preaction=lovetester");
	if (!page_text.contains_text("You may still consult Madame Zatara about your relationship"))
		return true;
	boolean last_one = page_text.contains_text("You may still consult Madame Zatara about your relationship with a clanmate 1 time today");
	page_text = visit_url("choice.php?whichchoice=1278&option=1&which=1&whichid=" + clanmate + "&q1=" + q1 + "&q2=" + q2 + "&q3=" + q3);
	
	if (!page_text.contains_text("You enter your answers and wait for "))
		return false;
	if (last_one)
		return true;
	return false;
}

void main()
{
	if (get_property("_clanFortuneConsultUses").to_int() >= 3) return;
	int original_clan_id = get_clan_id_safe();
	
	string clanmate = "Cheesefax";
	string q1 = "pizza";
	string q2 = "batman";
	string q3 = "thick";
	
	if (false && get_clan_id_safe() == 4242 && gametime_to_int() / 1000 / 60 >= 30) //too slow
	{
		clanmate = "Noblesse Oblige";
		q1 = "salt";
		q2 = "romeo";
		q3 = "null";
	}
	else if (false && get_clan_id_safe() != 90485)
	{
		boolean success = switchToClan(90485);
		if (!success)
		{
			print("Unable to switch clans for consult.");
			return;
		}
	}
	if (!can_interact())
		q2 = "demona"; //fail q2
	if (my_path() == "33" || my_path() == "G-Lover")
		q3 = "dream"; //fail q3
	if (clanmate == "Cheesefax") //dead
		return;
	int breakout = 10;
	while (breakout > 0)
	{
		breakout -= 1;
		if (consult(clanmate, q1, q2, q3))
			break;
		waitq(4);
		if (clanmate == "Noblesse Oblige") //takes forever
			waitq(10);
	}
	
	
	if (get_clan_id_safe() != original_clan_id)
		switchToClan(original_clan_id);
	cli_execute("call scripts/Utility/Delete Lady Spookyraven Kmails.ash"); //here? probably won't get them all
}