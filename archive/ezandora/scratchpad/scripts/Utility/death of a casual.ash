import "scripts/Helix Fossil/Helix Fossil Interface.ash";
import "scripts/Farming/Farm daily generators-hairs-pills.ash";

int currentBeachTideLevel()
{
	int m = gameday_to_int() % 8;
	int [int] mappings = {0:2,1:3,2:4,3:5,4:4,5:3,6:2,7:1};
	return mappings[m];
}

boolean twitching = false;
void twitch()
{
	if (!twitching)
		return;
	string maximise_command = "maximize elemental damage -tie +equip time-twitching toolbelt";
	if (inebriety_limit() - my_inebriety() < 0 && $item[drunkula's wineglass].can_equip()) //'
		maximise_command += " +equip drunkula's wineglass";
	else
	{
		cli_execute("unequip weapon; equip kol con 13 snowglobe");
		maximise_command += " -offhand";
		//maximise_command += " +equip kol con 13 snowglobe ";
	}
	cli_execute(maximise_command);
	cli_execute("fam intergnat");
	while (my_adventures() > 0)
	{
		cli_execute("adventure 1 Globe Theatre Main Stage");
	}
}


void farmSuperduperheatedMetal(int max_turns)
{
	cli_execute("maximize 10.0 hot res 1.0 muscle -1.0 monster level -offhand -tie");
	
	HelixResetSettings();
	if ($item[drunkula's wineglass].equipped_amount() == 0) //'
	{
		__helix_settings.actions_to_execute.listAppend("while !pastround 24 && !hppercentbelow 25 && hascombatitem " + $item[padl phone].to_int() + "; use padl phone,padl phone; endwhile");
	}
	HelixWriteSettings();
	int attempts = max_turns;
	while (true && attempts > 0 && $location[The Bubblin' Caldera].turns_spent < max_turns  && !$location[The Bubblin' Caldera].noncombat_queue.contains_text("Lava Dogs") && my_adventures() > 0) //'
	{
		cli_execute("gain hot res 1 eff");
		cli_execute("gain 120 muscle 1 eff");
		cli_execute("gain 120 moxie 1 eff");
		if (!get_property("_superduperheatedMetalDropped").to_boolean() && $item[heat-resistant sheet metal].mall_price() <= 1000)
		{
			cli_execute("closet take * heat-resistant sheet metal");
			if ($item[heat-resistant sheet metal].item_amount() <= 1)
				cli_execute("acquire 5 heat-resistant sheet metal");
		}
		else if (get_property("_superduperheatedMetalDropped").to_boolean())
			cli_execute("closet put * heat-resistant sheet metal");
		attempts -= 1;
		int metal_before = $item[superduperheated metal].item_amount();
		adv1($location[The Bubblin' Caldera], 0, ""); //'
		if ($item[superduperheated metal].item_amount() > metal_before)
		{
			set_property("_superduperheatedMetalDropped", true);
		}
	}
	HelixResetSettings();
	HelixWriteSettings();
}


void burnAdventuresFarming()
{
	print_html("burnAdventuresFarming()");
	if (my_adventures() == 0)
		return;
	boolean allow_side_stuff = true;
	
	//cli_execute("call scripts/Events/Crimbo2020FarmSpirit.ash ignore");
	//cli_execute("call scripts/Events/Crimbo2021.ash");
	
	if (false)
	{
		//events:
		//cli_execute("call scripts/Events/twitch-chroner-farm.ash");
		//cli_execute("call crimbo2022.ash");
	}
	
	int times_ascended_today = get_property("ezandoraCustomTimesAscendedToday").to_int();
	if (my_id() == 1877214)
		cli_execute("call CouchFishing.ash");

	boolean overdrunk = inebriety_limit() - my_inebriety() < 0;
	if (overdrunk && ($item[drunkula's wineglass].available_amount() == 0 || !$item[drunkula's wineglass].can_equip())) //not 100% - boxing care works
		return;
	if ($item[drunkula's wineglass].available_amount() > 0 && overdrunk && $item[drunkula's wineglass].can_equip())
	{
		if ($slot[weapon].equipped_item().weapon_hands() > 1)
			cli_execute("unequip weapon");
		cli_execute("equip drunkula's wineglass");
	}
	if (allow_side_stuff)
	{
		//cli_execute("piraterealm trash");
		//cli_execute("fantasyrealm mall");
	}
	set_property("choiceAdventure793", 1);
	while (my_adventures() >= 3 && $item[shore inc. ship trip scrip].available_amount() < 4 && !(overdrunk && $item[drunkula's wineglass].equipped_amount() == 0)) //absolute minimum '
		adv1($location[The Shore\, Inc. Travel Agency], 0, "");
	
	int min_turncount_allowed = my_turncount() + my_adventures();
	int max_turncount_allowed = my_turncount() + my_adventures();
	if (inebriety_limit() - my_inebriety() < 0 && false) //eh
	{
		//We want total_turns_spent() % 37 == 0 at some point > 57 turns after we ascend.
		//How do we do this?
		//Well...
		//That means 37 - (total_turns_spent() + 57) % 37 > 0 but less than, like... 14?
		
		int min_turns_allowed = 100000;
		int max_turns_allowed = 0;
		int turns_allowed = 0;
		
		while (true)
		{
			int delta = (37 - ((total_turns_played() + 57 + turns_allowed) % 37));
			
			if (delta > 2 && delta <= 10)
			{
				min_turns_allowed = MIN(min_turns_allowed, turns_allowed);
				max_turns_allowed = MAX(max_turns_allowed, turns_allowed);
			}
			if (turns_allowed >= my_adventures())
				break;
			turns_allowed += 1;
		}
		print_html("min_turns_allowed = " + min_turns_allowed + ", max_turns_allowed = " + max_turns_allowed);
		min_turncount_allowed = my_turncount() + min_turns_allowed;
		max_turncount_allowed = my_turncount() + max_turns_allowed;
	}
	if (my_turncount() >= min_turncount_allowed)
		return;
	if (inebriety_limit() - my_inebriety() < 0 && max_turncount_allowed < 37)
		abort("Spend " + min_turncount_allowed + " to " + max_turncount_allowed + " turns by hand.");
			
	//if (!overdrunk)
		//cli_execute("call scripts/Events/Crimbo2018.ash");
	
	if (false)
	{
		//Events go here:
		int event_delta = max_turncount_allowed - my_turncount();
		//abort("event_delta = " + event_delta);
		if (event_delta > 0)
			cli_execute("Lylefarm " + event_delta);
	}	
	//cli_execute("Lylefarm 400");
	if (my_turncount() > min_turncount_allowed)
		return;
	
	if (inebriety_limit() - my_inebriety() < 0 && $item[drunkula's wineglass].can_equip() && $item[drunkula's wineglass].available_amount() > 0) //'
		cli_execute("unequip weapon; equip drunkula's wineglass");
	if ($familiar[intergnat].have_familiar())
		cli_execute("familiar intergnat");
	/*if ($item[time-spinner].available_amount() > 0)
	{
		cli_execute("call scripts/Library/Prepare time-spinner monsters.ash");
	}*/
	cli_execute("call scripts/Library/Daily Dungeon.ash");
	if (!overdrunk && allow_side_stuff)
		cli_execute("party quest");
	//cli_execute("call scripts/RarelyUseful/Arrrrrrrr.ash");
	if (inebriety_limit() - my_inebriety() >= 0 && my_adventures() >= 32 && !twitching && $item[buffalo dime].available_amount() < 100 && get_property("telegraphOfficeAvailable").to_boolean() && allow_side_stuff && false)
		cli_execute("call scripts/TurnBurners/All LT&T Quests.ash");
	if (my_adventures() == 0)
		return;
	if ($item[drunkula's wineglass].equipped_amount() > 0) //'
	{
		//Farm volcoino, usually worth it:
		cli_execute("maximize muscle -tie -offhand"); //+equip drunkula's wineglass");
		if (get_campground()[$item[haunted doghouse]] > 0)
		{
			//we get beaten up here and it's hoenstly not really worth it
			//hot res
			farmSuperduperheatedMetal(10);
		}
		cli_execute("uneffect drenched in lava");
	}
	if (grimaceHasNoAliensToday() && ($item[distention pill].available_amount() < 30 || $item[synthetic dog hair pill].available_amount() < 30))
	{
		//abort("farm pills against my orders");
		cli_execute("call Farm daily generators-hairs-pills.ash");
	}
	if (my_id() == 1557284 && true)
	{
		cli_execute("call CombBeach.ash target all");
		/*if (true)// && gameday_to_int() % 2 == 0)// && times_ascended_today == 0 && my_adventures() >= 100)
			cli_execute("call CombBeach.ash target all");
		if (false && ($ints[1,2] contains currentBeachTideLevel()) && times_ascended_today == 0 && my_adventures() >= 100)
		{
			set_property("ezandora_comb_beach_next_unobserved_minute", 0);
			cli_execute("call CombBeach.ash unobserved");
		}
		//cli_execute("call CombBeach.ash unobserved");
		cli_execute("call CombBeach.ash t2");
		cli_execute("call CombBeach.ash all");*/
	}
	if (!overdrunk && allow_side_stuff && false)
		cli_execute("call scripts/TurnBurners/NewYou.ash");
	if (my_adventures() > 0 && allow_side_stuff)
		twitch();
	if (my_adventures() >= 50 && !overdrunk && allow_side_stuff)
		cli_execute("call scripts/TurnBurners/Mayor Zapruder Quest.ash");
	while (my_adventures() >= 3 && $item[shore inc. ship trip scrip].available_amount() < 30 && allow_side_stuff)
		adv1($location[The Shore\, Inc. Travel Agency], 0, "");
	set_property("choiceAdventure793", -1);
	
	int monsters_banished_in_bedroom = 0;
	foreach key, m in $location[the haunted bedroom].get_monsters()
	{
		if (m.is_banished())
			monsters_banished_in_bedroom += 1;
	}
	//Farm metal:
	if (allow_side_stuff)
		cli_execute("call scripts/TurnBurners/Farm_superduper_metal.ash 20");
	cli_execute("familiar jumpsuited hound dog");
	if (!overdrunk && allow_side_stuff)
		cli_execute("call scripts/TurnBurners/Spacegate.ash");
	
	if (false)
		cli_execute("call BoxingEquipment.ash " + ((true || overdrunk) ? "spar " : "") + my_adventures());
	if ($item[filthy lucre].available_amount() < 75)
		cli_execute("call scripts/TurnBurners/Bounty Hunt.ash");
	if ($item[smut orc keepsake box].mall_price() >= 30000 && false)
		cli_execute("call scripts/Farming/Smut orc keepsake boxes.ash");
	if (my_id() == 1877214 && false)
		abort("farm tatters?");
	//Farm cameras for casuals:
	if (monsters_banished_in_bedroom >= 3)// && $item[disposable instant camera].mall_price() >= 3000)
	{
		set_property("choiceAdventure878", 4); //disposable instant camera
		while (my_adventures() > 0)
		{
			adv1($location[The Haunted Bedroom], 0, "");
			visit_url("choice.php");
			run_combat();
		}
	}
	else if (false)
	{
		cli_execute("call scripts/Events/Monorail.ash");
	}
	else if (true || (my_adventures() >= 200 && $familiar[robortender].have_familiar() && my_id() != 1877214)) //get_campground() contains $item[packet of tall grass seeds] && 
	{
		//better farming
		cli_execute("call scripts/Farming/Meat Farm.ash");
	}
	else if (true && (my_class() != $class[seal clubber] || my_basestat($stat[mysticality]) >= 100) && inebriety_limit() - my_inebriety() >= 0 && (get_property("_hotAirportToday").to_boolean() || get_property("hotAirportAlways").to_boolean())) //farm the gold mine, if we can equip the wineglass
		cli_execute("call scripts/TurnBurners/GoldMining.ash " + my_adventures()); //more efficient, even with the latest additions
	else if (true || my_id() != 2456416)
	{
		cli_execute("call scripts/Farming/Meat Farm.ash");
	}
	else
		cli_execute("call scripts/Farming/Smut orc keepsake boxes.ash");
	if (my_adventures() > 0 && false)
		cli_execute("call scripts/Farming/Smut orc keepsake boxes.ash");
	if (my_adventures() > 0)
		cli_execute("call scripts/TurnBurners/GoldMining.ash " + my_adventures());
}

void main()
{
	//farmSuperduperheatedMetal(10); return;
	
	if (!get_property("kingLiberated").to_boolean())
		return;
	if (get_property("ezandoraCustomTimesAscendedToday").to_int() >= 2)
	{
		abort("cannot prepare for ascension; out of ascensions for the day");
		return;
	}
	
	set_property("_ezandora_script_1_running", true);
	if ($item[telegram from Lady Spookyraven].available_amount() > 0)
		cli_execute("use telegram from Lady Spookyraven");
	//cli_execute("qwop");
	if (!get_property("_borrowedTimeUsed").to_boolean())
		cli_execute("use borrowed time");
	//cli_execute("consume.ash 3400");
	if (get_property("chateauAvailable").to_boolean() && !($monsters[writing desk,lobsterfrogman,school of wizardfish,green ops soldier,fantasy bandit] contains get_property("chateauMonster").to_monster()) && my_adventures() > 0 && false)
	{
		print_html("Unlocking spookyraven library.");
		if ($item[navel ring of navel gazing].available_amount() > 0)
			cli_execute("equip acc3 navel ring of navel gazing");
		cli_execute("call scripts/TurnBurners/Unlock Spookyraven Library.ash");
		if (get_property("chateauMonster").to_monster() != $monster[writing desk])
			abort("writing desk in chateau");
	}
	for i from 1 to 5
	{
		if (get_property("_timeSpinnerMinutesUsed").to_int() >= 9)
			break;
		if ($item[time-spinner].available_amount() == 0) break;
		if (my_adventures() == 0)
			break;
		if (true) //buggy farfuture keeps on stop
			break;
		cli_execute("farfuture mall");
		if (get_property("_timeSpinnerMinutesUsed").to_int() <= 8)
			cli_execute("waitq 10"); //try to deal with that one session bug
	}
	if (inebriety_limit() - my_inebriety() >= 0 && $item[tiny plastic sword].available_amount() > 0 && my_adventures() > 0)
	{
		if ($item[tiny plastic sword].storage_amount() > 0)
			cli_execute("pull * tiny plastic sword");
		if ($item[bodyslam].available_amount() == 0)
			print_html("<font color=\"red\">bodyslam superstar shia labeouf</font>");
		cli_execute("acquire bodyslam");
	}
	if (get_campground()[$item[source terminal]] > 0)
	{
		int limit = 0;
		while (get_property("_sourceTerminalEnhanceUses").to_int() < 3 && limit < 3)
		{
			cli_execute("terminal enhance items.enh");
			limit += 1;
		}
		cli_execute("call source terminal use spare extrudes.ash");
		/*limit = 0;
		while (get_property("_sourceTerminalExtrudes").to_int() < 3 && limit < 3)
		{
			cli_execute("terminal extrude booze.ext");
			limit += 1;
		}*/
	}
	//cli_execute("mallsell * effluvium");
	
	cli_execute("autoattack none");
	if (!get_property("__ezandora_automated_prepare_shared_finished").to_boolean() && my_id() == 1557284)
		cli_execute("call scripts/Aftercore/Automated Prepare.ash");
	//cli_execute("call scripts/Destiny Ascension/Before Ascension.ash");
	//if (knoll_available() && $item[small leather glove].mall_price() <= 10000 && my_adventures() >= 20 && inebriety_limit() - my_inebriety() >= 0)
		//cli_execute("call scripts/TurnBurners/Mayor Zapruder Quest.ash");
	
	if (my_adventures() > 0)
	{
		burnAdventuresFarming();
	}
	if (my_adventures() == 0 && $item[drunkula's wineglass].available_amount() > 0 && $item[drunkula's wineglass].can_equip() && inebriety_limit() - my_inebriety() >= 0)
	{
		/*if (!get_property("autoRepairBoxServants").to_boolean())
		{
			if ($effect[Inigo's Incantation of Inspiration].have_effect() < 5) //'
				cli_execute("cast inigo");
		}
		cli_execute("call scripts/Library/CastOde.ash 10");
		if (false)
			abort("it's drinkin' time");
		//if ($item[cheer wine].available_amount() > 0)
			//cli_execute("drink cheer wine");
		//else
			cli_execute("drink body slam");
		cli_execute("uneffect ode");*/
		cli_execute("consume.ash 3500");
		if (false) //FIXME BAD BUG does not work
			cli_execute("call scripts/Library/overdrink.ash pvp 3500");
		else
			cli_execute("call scripts/Library/overdrink.ash 3500");
	}
	if (my_adventures() > 0)
	{
		burnAdventuresFarming();
			
	}
	if (hippy_stone_broken() && pvp_attacks_left() > 0 && fullness_limit() - my_fullness() <= 0)
	{
		cli_execute("call scripts/PVP/Prepare to PVP.ash");
		cli_execute("call scripts/PVP/run fights.ash");
	}
	if (get_property("chateauAvailable").to_boolean() && (get_chateau()[$item[artificial skylight]] > 0 || get_chateau()[$item[antler chandelier]] > 0))
	{
		visit_url("shop.php?whichshop=chateau&action=buyitem&quantity=1&whichrow=414");
		visit_url("place.php?whichplace=chateau");
	}
	
	//this one doesn't work:
	//cli_execute("call scripts/Destiny Ascension/Before Ascension.ash");
	//this one does:
	cli_execute("call scripts/Destiny Ascension/Before Ascending.ash");
	//why?
	
	set_property("_ezandora_script_1_running", false);
	
}