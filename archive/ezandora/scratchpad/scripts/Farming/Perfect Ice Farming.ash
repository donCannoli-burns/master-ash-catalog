import "CheapFarm.ash";
import "scripts/Helix Fossil/Helix Fossil Interface.ash"

boolean __setting_early = false;


void insureItemEffects(boolean [item] items)
{
	foreach it in items
	{
		if (it.to_effect() == $effect[none])
			continue;
		if (it.to_effect().have_effect() > 1)
			continue;
		cli_execute("use " + it);
	}
}

void insureSkillEffects(boolean [skill] skills)
{
	foreach s in skills
	{
		if (!s.have_skill() || !s.is_unrestricted())
			continue;
		if (s.to_effect() == $effect[none])
			continue;
		if (s.to_effect().have_effect() > 1)
			continue;
		use_skill(s);
	}
}

void setUpKnownFarmingItems()
{
	known_items["Ice Hotel"] = cheap_farming_target_item_make(0.0, 0, 50.0);
}

void runMaximiseCommand()
{
	//string maximise_command = "maximize -10.0 combat 0.01 familiar weight -familiar";
	string maximise_command = "maximize 1.0 item 5.0 familiar weight -familiar";
	if (get_property("_pantsgivingFullness").to_int() < 2)
		maximise_command += " +equip pantsgiving";
	//maximise_command += " -equip space trip safety headphones"; //-ML
	//maximise_command += " +equip bellhop's hat";
	maximise_command += " +equip sonar fishfinder +equip fishin' hat";
	maximise_command += " +equip navel ring";
	string bucket_quest = get_property("questECoBucket");
	if ((bucket_quest == "started" || bucket_quest == "step1") && get_property("walfordBucketProgress").to_int() < 100)
		maximise_command += " +equip walford's bucket";
	maximise_command += " -tie";
	cli_execute(maximise_command);
}

void checkWalfordQuestStart()
{
	if (!(get_property("questECoBucket") == "started" || get_property("questECoBucket") == "step1"))
	{
		buffer the_time_has_come = visit_url("place.php?whichplace=airport_cold&action=glac_walrus");
		
		if (the_time_has_come.contains_text("I'll get you some"))
		{
			//2, 3, 4
			visit_url("choice.php?whichchoice=1114&option=4"); //FIXME is 1 correct?
		}
	}
}

void main()
{
	farmingLogTrackItemsFromArea($location[the ice hotel]);
	farmingLogStart();
	setUpKnownFarmingItems();
		
	HelixResetSettings();
	__helix_settings.monsters_to_olfact = $monsters[ice bartender];
	__helix_settings.monsters_to_run_away_from = $monsters[ice housekeeper,ice porter,ice concierge,ice clerk];
	__helix_settings.always_run_away_from_navel = true;
	HelixWriteSettings();
	
	
	set_location($location[the ice hotel]);
	
	
	int adventure_limit = 50;
	if (get_property("_borrowedTimeUsed").to_boolean())
	{
		adventure_limit = 6; //ice house
		if ($monster[a.m.c. gremlin].is_banished())
			adventure_limit = 0;
	}
	
	runMaximiseCommand();
	
	int last_pantsgiving_fullness = 0;
	familiar last_familiar = $familiar[none];
	int last_turn_quest_progress = get_property("walfordBucketProgress").to_int();
	while (my_adventures() > adventure_limit)
	{
		if (!get_property("_iceHotelRoomsRaided").to_boolean())
			set_property("choiceAdventure1116", 5);
		else
			set_property("choiceAdventure1116", 4);
		if (!insureOnceDailyFamiliars(false))
		{
			if (true)
			{
				if (my_familiar() != $familiar[reagnimated gnome])
					use_familiar($familiar[reagnimated gnome]);
				if ($slot[familiar].equipped_item() != $item[gnomish housemaid's kgnee]) //'
					cli_execute("equip gnomish housemaid's kgnee");
			}
			else
			{	
				if (my_familiar() != $familiar[angry jung man])
					use_familiar($familiar[angry jung man]);
				
				if ($slot[familiar].equipped_item() != $item[lucky Tam O'Shanter] && $item[lucky Tam O'Shanter].available_amount() > 0) //'
					cli_execute("equip lucky Tam O'Shanter");
			}
		}
		//FIXME actions
		if (last_familiar != my_familiar())
		{
			runMaximiseCommand();
		}
		else if (get_property("_pantsgivingFullness").to_int() != last_pantsgiving_fullness)
		{
			last_pantsgiving_fullness = get_property("_pantsgivingFullness").to_int();
			runMaximiseCommand();
		}
		last_familiar = my_familiar();
		int turns_expected_to_remain = my_adventures() - adventure_limit;
		insureAllFarmingEffects("Ice Hotel", turns_expected_to_remain);
		insureItemEffects($items[knob goblin pet-buffing spray,knob goblin eyedrops]);
		insureSkillEffects($skills[leash of linguini,empathy of the newt,The Sonata of Sneakiness,smooth movement,fat leon's phat loot lyric,singer's faithful ocelot,the polka of plenty]);
		if (__setting_early)
			break;
		adv1($location[the ice hotel]);
		farmingLogTurn();
		
		int progress = get_property("walfordBucketProgress").to_int();
		if (last_turn_quest_progress != progress && progress >= 100 && $item[walford's bucket].equipped_amount() > 0) //'
		{
			//FINISH IT
			visit_url("place.php?whichplace=airport_cold&action=glac_walrus");
			visit_url("choice.php?whichchoice=1114&option=1");
			checkWalfordQuestStart();
			runMaximiseCommand();
		}
		last_turn_quest_progress = progress;
	}
	farmingLogEnd();
	int [item] items_gained = farmingLogItemsGained();
	
	if (!__setting_early)
		cli_execute("fam medium");
}