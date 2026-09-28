import "scripts/Library/BestSemi-rare.ash"
import "relay/Guide/Support/LocationAvailable.ash";
import "relay/Guide/Support/Counter.ash";
import "scripts/Destiny Ascension/Destiny Ascension/Support/Library.ash";
import "scripts/Library/ArchiveEquipment.ash";

int availableFullnessR()
{
	return fullness_limit() - my_fullness();
}


void checkGhostQuest()
{
	if ($item[protonic accelerator pack].available_amount() == 0)
		return;
	//if (CounterWanderingMonsterMayHitNextTurn()) //holidays... wait, do ghosts override wanderers?
		//return;
	if (inebriety_limit() - my_inebriety() < 0) //don't bother fighting drunks overghost
		return;
	location ghost_location = get_property("ghostLocation").to_location();
	if (ghost_location == $location[none])
		return;
	if (!get_property("kingLiberated").to_boolean())
		return;
		
	if (!ghost_location.locationAvailable())
	{
		if (ghost_location == $location[the skeleton store])
		{
			//Checked - works with unlocker used.
			visit_url("shop.php?whichshop=meatsmith&action=talk");
			visit_url("choice.php?whichchoice=1059&option=1");
		}
		if (ghost_location == $location[madness bakery])
		{
			//abort("Precheck Semirare use unlocker, test for unlocker bug.");
			visit_url("shop.php?whichshop=armory&action=talk", false, false);
			visit_url("choice.php?whichchoice=1065&option=1");
		}
		if (ghost_location == $location[the overgrown lot])
		{
			//Checked - works with unlocker used.
			visit_url("shop.php?whichshop=doc&action=talk");
			visit_url("choice.php?whichchoice=1064&option=1");
		}
	}
		
	
	if (!ghost_location.locationAvailable() && ghost_location != $location[inside the palindome])
	{
		//FIXME start quests?
		print("can't access location " + ghost_location, "red");
		return;
	}
	
	item [slot] saved_items;
	foreach s in $slots[hat,weapon,off-hand,back,shirt,pants,acc1,acc2,acc3,familiar]
		saved_items[s] = s.equipped_item();
	familiar saved_familiar = my_familiar();
	
	
	use_familiar($familiar[intergnat]);
	cli_execute("acquire hand in glove");
	cli_execute("maximize ML -familiar -tie +equip hand in glove +equip the crown of ed the undying -offhand -equip iflail"); //vykea companions kill ghosts before they can be trapped. pre-equip things because maximise takes forever and there's no way to temporarily reduce it without causing complications (what happens if a maximise aborts and your setting can't be changed back?)
	if (ghost_location == $location[inside the palindome] && $item[talisman o' namsilat].equipped_amount() == 0) //'
	{
		equip($slot[acc1], $item[talisman o' namsilat]); //'
	}
	equip($slot[back], $item[protonic accelerator pack]);
	
	
	
	adv1(ghost_location, 0, "");
	set_property("ghostLocation", ""); //don't bug out forever
	
	if (my_familiar() != saved_familiar)
		use_familiar(saved_familiar);
	foreach s, it in saved_items
	{
		if (s.equipped_item() != it && it.available_amount() > 0)
			equip(s, it);
	}
}

void precheckSemirareActual()
{
	if (!can_interact())
		return;
	//no way to properly do this anyways, since we don't know the last time we visited adventure.php, and this is being revamped
	/*if (availableFullnessR() >= 1 && get_property("relayCounters").contains_text("Semirare window begin") && !get_property("_borrowedTimeUsed").to_boolean())
	{
		if ($effect[got milk].have_effect() == 0)
			cli_execute("use milk of magnesium");
		eat(1, $item[fortune cookie]);
	}*/
	if (get_counters("Fortune Cookie", 0, 0).length() == 0)
		return;
	//semi-rare up:
	location last_location = get_property("semirareLocation").to_location();
	
	if (last_location != $location[the haunted storage room])
	{
		//abort("It's time.");	
		int saved_aa = get_auto_attack();
		familiar saved_familiar = my_familiar();
		ArchiveEquipment();
		cli_execute("familiar none; outfit birthday suit");
		
		string [int] prepare_commands;
		string [int] end_commands;
		calculateCommandsForFullLengthMirrorOutfit(calculateFullLengthMirrorOutfit(), prepare_commands, end_commands);
		//abort("build copy outfit");
		
		//cli_execute("outfit CopyCopyCopyCopy");
		//cli_execute("familiar angry jung man");
		//cli_execute("autoattack fury of the saucegeyser");
		//string previous_script = get_property("customCombatScript");
		//cli_execute("ccs saucegeyser");
		foreach key, s in prepare_commands
			cli_execute(s);
		adv1($location[the haunted storage room], 0, "");
		foreach key, s in end_commands
			cli_execute(s);
		//set_auto_attack(saved_aa);
		//set_property("customCombatScript", previous_script);
		RestoreArchivedEquipment();
		cli_execute("familiar " + saved_familiar);
		return;
	}
	
	location l = $location[the haunted billiards room];
	if (last_location == l || true)
		l = bestSemirareLocationForProfit();
	
	int saved_aa = get_auto_attack();
	set_auto_attack(99120329); //semi-rare attack
	
	adv1(l, 0, ""); //incredibly hacky way of adventuring while ignoring the counter
	
	set_auto_attack(saved_aa);
}

void precheckSemirare()
{
	precheckSemirareActual();
	checkGhostQuest();
}

void main()
{
	precheckSemirare();
}