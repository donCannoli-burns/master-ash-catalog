
import "scripts/Destiny Ascension/Destiny Ascension/Support/Library.ash";

int stance = get_property("ezandoraChosenPVPStance").to_int(); //5

void runPledgeofAllegiance()
{
	buffer page_text = visit_url("peevpee.php?place=fight");
	if (!page_text.contains_text("Before entering combat, you must pledge your allegiance to a clan for the season"))
		return;
	int target_clan_id = -1;
	
	if (my_id() == 1557284)
		target_clan_id = 2046984450;
	if (target_clan_id == -1)
		abort("run fights.ash: pick a clan, any clan");
	
	int original_clan_id = get_clan_id();
	if (original_clan_id != target_clan_id)
		switchToClan(target_clan_id);
	visit_url("peevpee.php?action=pledge&place=fight");
	if (original_clan_id != target_clan_id)
		switchToClan(original_clan_id);
}

void main()
{
	//abort("run targeted fights first");
	//if (my_id() == 1557284) return;
	if (!hippy_stone_broken()) return;
	if ($effect[Fortunate\, Son].have_effect() > 0 && my_adventures() > 0) return;
	
	runPledgeofAllegiance();
	string win_message;
	string lose_message;
	string attack_specific_target;
	if (my_id() == 2456416)
	{
		win_message = "Flowers!";
		lose_message = "Umm... sorry";
	}
	else
	{
		//attack_specific_target = "honus carbuncle";
		//attack_specific_target = "missfishie";
		win_message = "-1";
		lose_message = "-1";
	}
	
	int attacks_limit = 0;
	//if (!get_property("_borrowedTimeUsed").to_boolean() || get_property("ezandoraCustomTimesAscendedToday").to_int() >= 2)
		//attacks_limit = 20;
	if (false && gametime_to_int() >= (23 * 60 * 60 + 20 * 60) * 1000 && !get_property("_borrowedTimeUsed").to_boolean()) //stop running fights before rollover hits
		attacks_limit = 30;
		
	if (my_daycount() == 3 && in_hardcore() && my_path() == "Grey Goo")
	{
		attacks_limit = pvp_attacks_left() - 110;
		if (attacks_limit > 0)
			print("Limiting attacks for next ascension, down to " + attacks_limit + "...");
		else
			attacks_limit = 0;
	}
	//attacks_limit = 0;
	
	int ranked = 1; //a random opponent
	string attacktype = "flowers";
	if (current_pvp_stances()["Beary Famous"] > 0 || true)
	{
		ranked = 2; //a random opponent (increased fame gain)
		attacktype = "fame";
	}
	while (pvp_attacks_left() > attacks_limit)
	{
		string who = "";
		if (attack_specific_target != "")
		{
			who = attack_specific_target;
			//abort("attack " + attack_specific_target);
		}
		buffer page_text;
		try
		{
			page_text = visit_url("peevpee.php?action=fight&place=fight&ranked=" + (who == "" ? ranked : 0) + "&who=" + who + "&stance=" + stance + "&attacktype=" + attacktype + "&winmessage=" + win_message + "&losemessage=" + lose_message);
		}
		finally
		{
		}
		if (who == "" && page_text.contains_text("Sorry, I couldn't find the player")) //can't find a tougher opponent
		{
			if (ranked == 1)
			{
				print("You're out of targets. Stopping.");
				break;
			}
			ranked = 1;
		}
		if (attack_specific_target != "")
		{
			if (page_text.contains_text("<b>" + my_name() + "</b> won the fight"))
			{
				print_html("won the fight");
				//attack_specific_target = "";
			}
			if (page_text.contains_text("You can't attack a player against whom you've already won"))
			{
				attack_specific_target = "";
			}
			
		}
	}
	/*if ($familiar[happy medium].have_familiar())
		cli_execute("familiar happy medium");
	else if ($familiar[cocoabo].have_familiar())
		cli_execute("familiar cocoabo");
	print("done");*/
}