int __setting_total_turns_to_spend = 10;

int totalTurnsSpentOnScavenging()
{
	int scavenges = get_property("_daycareGymScavenges").to_int();
	int total = 0;
	for i from 0 to scavenges
	{
		total += min(3, i);
	}
	return total;
}

int nextTurnsSpentOnScavenging()
{
	int scavenges = get_property("_daycareGymScavenges").to_int();
	return MIN(3, scavenges);
}

void main()
{
	if (!get_property("daycareOpen").to_boolean())
	{
		return;
	}
	
	
	
	boolean have_initialised = false;
	int breakout = 20;
	while (breakout > 0)
	{
		breakout -= 1;
		int total_turns = totalTurnsSpentOnScavenging();
		int next_turns = nextTurnsSpentOnScavenging();
		//print("next_turns = " + next_turns + " total_turns = " + total_turns);
		if (next_turns > my_adventures()) break;
		if (total_turns + next_turns > __setting_total_turns_to_spend) break;
		
		if (!have_initialised)
		{
	        visit_url("place.php?whichplace=town_wrong&action=townwrong_boxingdaycare");
	        visit_url("choice.php?whichchoice=1334&option=3");
		}
        visit_url("choice.php?whichchoice=1336&option=2");
	}
	if (have_initialised)
	{
        visit_url("choice.php?whichchoice=1336&option=5");
        visit_url("choice.php?whichchoice=1334&option=4");
	}
}