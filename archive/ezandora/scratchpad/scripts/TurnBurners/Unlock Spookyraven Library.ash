
import "scripts/Helix Fossil/Helix Fossil Interface.ash"

void upkeepSkills(boolean [skill] skills)
{
	foreach s in skills
	{
		if (!s.have_skill())
			continue;
		effect e = s.to_effect();
		if (e.have_effect() == 0)
			use_skill(1, s);
	}
}

void main()
{
	if ($item[telegram from Lady Spookyraven].available_amount() > 0)
		cli_execute("use telegram from Lady Spookyraven");
	while (my_adventures() > 0 && $item[Spookyraven billiards room key].available_amount() == 0)
	{
		upkeepSkills($skills[astral shell,elemental saucesphere]);
		if ($effect[red door syndrome].have_effect() == 0)
			cli_execute("use can of black paint");
		if ($familiar[mini-hipster].have_familiar() && my_familiar() != $familiar[mini-hipster])
		{
			cli_execute("familiar mini-hipster");
		}
		adv1($location[the haunted kitchen], 0, "");
	}
	boolean initialised_2 = false;
	while (my_adventures() > 0 && $item[7302].available_amount() == 0) //spookyraven library key
	{
		if ($location[the haunted billiards room].noncombat_queue.contains_text("That's Your Cue"))
		{
			//FIXME calculate pool skill correctly
			if (numeric_modifier("pool skill") < 8 && my_inebriety() < 2)
			{
				abort("Drink 2 drunkenness");
				return;
			}
		}
		upkeepSkills($skills[the sonata of sneakiness,smooth movement]);
		if ($effect[Chalky Hand].have_effect() == 0)
			cli_execute("use handful of hand chalk");
		if (!initialised_2)
		{
			cli_execute("maximise -combat -tie +equip pool cue +equip navel ring of navel gazing");
			if ($familiar[baby sandworm].have_familiar() && my_familiar() != $familiar[baby sandworm])
			{
				cli_execute("familiar baby sandworm");
			}
			
			HelixResetSettings();
			__helix_settings.monsters_to_olfact = $monsters[chalkdust wraith];
			__helix_settings.monsters_to_run_away_from = $monsters[chalkdust wraith];
			__helix_settings.always_run_away_from_navel = true;
			HelixWriteSettings();
			initialised_2 = true;
		}
		set_property("choiceAdventure875", 1);
		adv1($location[the haunted billiards room], 0, "");
	}
	
	
	HelixResetSettings();
	HelixWriteSettings();
	if (get_property("chateauAvailable").to_boolean() && false)
	{
		abort("we don't need this anymore?");
		cli_execute("acquire alpine watercolor set");
		if ($item[navel ring of navel gazing].available_amount() > 0)
			cli_execute("equip acc3 navel ring of navel gazing");
			
		__helix_settings.monsters_to_run_away_from = $monsters[banshee librarian,bookbat,writing desk];
		__helix_settings.actions_to_execute[0] = "if monstername writing desk; use alpine watercolor set; endif";
		HelixWriteSettings();
		
		while (my_adventures() > 0 && get_property("chateauMonster").to_monster() != $monster[writing desk])
		{
			adv1($location[the haunted library], 0, "");
		}
		
		
		HelixResetSettings();
		HelixWriteSettings();
	}
}