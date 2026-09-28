import "relay/Guide/QuestState.ash";
import "scripts/Library/Powerleveling Upkeep.ash";

boolean __setting_level_to_30 = false;

void main()
{
	int attempts = 0;
	int boss_attempts = 0;
	if ((my_basestat($stat[muscle]) < 200 || my_basestat($stat[mysticality]) < 200 || my_basestat($stat[moxie]) < 200 || (__setting_level_to_30 && my_level() < 30)) && !get_property("_borrowedTimeUsed").to_boolean())
		cli_execute("maximize mainstat -tie -familiar");
	while (attempts < 50 && my_adventures() > 0)
	{
		if ($effect[beaten up].have_effect() > 0)
			return;
		attempts += 1;
		QuestState quest_state = QuestState("questLTTQuestByWire");
	
		if (!quest_state.in_progress)
			return;
		if (my_hp() < my_maxhp())
			cli_execute("restore hp");
		if (my_mp() < 40 && my_maxmp() >= 40)
			restore_mp(40);
		if (boss_attempts > 0)
		{
			print("Boss failure?", "red");
			return;
		}
		cli_execute("call scripts/Library/PrecheckSemirare.ash");
		if (quest_state.mafia_internal_step >= 5 || (quest_state.mafia_internal_step >= 4 && get_property("lttQuestStageCount").to_int() == 9))
		{
			cli_execute("call scripts/Zone Prepares/LT&T bosskilling.ash");
			print("boss?");
			boss_attempts += 1;
		}
		else
		{
			if (my_level() <= 13 && $effect[trivia master].have_effect() == 0 && can_interact())
				cli_execute("up trivia master");
			if (false)
			{
				cli_execute("familiar crimbo shrub");
			}
			else if (true)
			{
				if ($familiar[ms. puck man].drops_today < $familiar[ms. puck man].drops_limit && $familiar[ms. puck man].have_familiar())
					cli_execute("familiar ms. puck man");
				else if ($familiar[intergnat].have_familiar())
					cli_execute("familiar intergnat");
				cli_execute("equip protonic accelerator pack; equip pantsgiving");
				if (my_class() == $class[seal clubber])
					cli_execute("equip meat tenderizer is murder");
				cli_execute("equip kol con 13 snowglobe; equip time-twitching toolbelt");
			}
			else if (my_class() == $class[sauceror] || my_level() >= 14 || my_mp() >= 100)
				cli_execute("call scripts/Zone Prepares/Gnomish adventures.ash");
			else
			{
				cli_execute("maximize mp regen -familiar -tie");
			}
			if ((my_basestat($stat[muscle]) < 200 || my_basestat($stat[mysticality]) < 200 || my_basestat($stat[moxie]) < 200) && !get_property("_borrowedTimeUsed").to_boolean() || (__setting_level_to_30 && my_level() < 30))
			{
				if ($item[tiki lighter].equipped_amount() + $item[tropical paperweight].equipped_amount() + $item[deck of tropical cards].equipped_amount() == 0 && can_interact() && !__setting_level_to_30)
					cli_execute("equip tiki lighter");
				if (__setting_level_to_30 && my_primestat() == $stat[muscle])
				{
					cli_execute("equip trench coat");
					cli_execute("equip fake washboard");
				}
				powerlevelingUpkeepEffects();
			}
			if ($item[source shades].available_amount() > 0 && $item[source shades].equipped_amount() == 0)
				cli_execute("equip acc3 source shades");
			if ($item[mr. screege's spectacles].available_amount() > 0 && $item[mr. screege's spectacles].equipped_amount() == 0)
				cli_execute("equip acc2 mr. screege's spectacles");
			if ($item[protonic accelerator pack].available_amount() > 0 && $item[protonic accelerator pack].equipped_amount() == 0)
				cli_execute("equip protonic accelerator pack");
		}
		adv1($location[Investigating a Plaintive Telegram], 0, "");
	}
}