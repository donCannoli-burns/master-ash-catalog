void updateBridge()
{
	//oh god
	string [31] hack;
	hack[0] = "place.php?whichplace=orc_chasm&action=bridge10";
	hack[1] = "place.php?whichplace=orc_chasm&action=bridge11";
	hack[2] = "place.php?whichplace=orc_chasm&action=bridge12";
	hack[3] = "place.php?whichplace=orc_chasm&action=bridge13";
	hack[4] = "place.php?whichplace=orc_chasm&action=bridge14";
	hack[5] = "place.php?whichplace=orc_chasm&action=bridge15";
	hack[6] = "place.php?whichplace=orc_chasm&action=bridge16";
	hack[7] = "place.php?whichplace=orc_chasm&action=bridge17";
	hack[8] = "place.php?whichplace=orc_chasm&action=bridge18";
	hack[9] = "place.php?whichplace=orc_chasm&action=bridge19";
	hack[10] = "place.php?whichplace=orc_chasm&action=bridge20";
	hack[11] = "place.php?whichplace=orc_chasm&action=bridge21";
	hack[12] = "place.php?whichplace=orc_chasm&action=bridge22";
	hack[13] = "place.php?whichplace=orc_chasm&action=bridge23";
	hack[14] = "place.php?whichplace=orc_chasm&action=bridge24";
	hack[15] = "place.php?whichplace=orc_chasm&action=bridge25";
	hack[16] = "place.php?whichplace=orc_chasm&action=bridge26";
	hack[17] = "place.php?whichplace=orc_chasm&action=bridge27";
	hack[18] = "place.php?whichplace=orc_chasm&action=bridge28";
	hack[19] = "place.php?whichplace=orc_chasm&action=bridge29";
	hack[20] = "place.php?whichplace=orc_chasm&action=bridge30";

	hack[21] = "place.php?whichplace=orc_chasm&action=bridge0";
	hack[22] = "place.php?whichplace=orc_chasm&action=bridge1";
	hack[23] = "place.php?whichplace=orc_chasm&action=bridge2";
	hack[24] = "place.php?whichplace=orc_chasm&action=bridge3";
	hack[25] = "place.php?whichplace=orc_chasm&action=bridge4";
	hack[26] = "place.php?whichplace=orc_chasm&action=bridge5";
	hack[27] = "place.php?whichplace=orc_chasm&action=bridge6";
	hack[28] = "place.php?whichplace=orc_chasm&action=bridge7";
	hack[29] = "place.php?whichplace=orc_chasm&action=bridge8";
	hack[30] = "place.php?whichplace=orc_chasm&action=bridge9";

	string text = visit_url("place.php?whichplace=orc_chasm");
	foreach i in hack
	{
		if (contains_text(text, hack[i]))
		{
			cli_execute(hack[i]);
			return;
		}
	}
}

void main()
{
	if (get_property("questL09Topping") == "finished")
		return;
	if (my_level() < 9) return;

	if (!contains_text(visit_url("questlog.php?which=1"), "There Can Be Only One Topping"))
		return;


	cli_execute("call ../Outfit experience");

	if (contains_text(visit_url("questlog.php?which=1"), "You should seek him out, in the Highlands beyond the Orc Chasm, in the Big Mountains."))
	{
		cli_execute("outfit swashbuckling getup");
		if (contains_text(visit_url("store.php?whichstore=r"), "abridged dictionary"))
		{
			cli_execute("acquire abridged dictionary");
			cli_execute("forestvillage.php?action=screwquest");
			cli_execute("knoll.php?place=smith");
			cli_execute("forestvillage.php?place=untinker");
			cli_execute("untinker abridged dictionary");
			cli_execute("place.php?whichplace=orc_chasm");
			cli_execute("place.php?whichplace=orc_chasm&action=bridge0");
			updateBridge();
		}
		int number_used = 0;
		int max_used = 4;
		updateBridge();
		while (contains_text(visit_url("questlog.php?which=1"), "You should seek him out, in the Highlands beyond the Orc Chasm, in the Big Mountains."))
		{
			if (number_used >= max_used)
			{
				print("VERY BAD THING");
				return;
			}
			updateBridge();
			cli_execute("use smut orc keepsake box");
			updateBridge();
			number_used = number_used + 1;
		}
		cli_execute("call ../Outfit experience");
	}


	if (contains_text(visit_url("questlog.php?which=1"), "He's in a tower in the Highlands. It's in the Big Mountains, past the Orc Chasm."))
	{
		cli_execute("place.php?whichplace=highlands&action=highlands_dude");
		cli_execute("place.php?whichplace=highlands&action=highlands_dude");
	}



	if (!contains_text(visit_url("place.php?whichplace=highlands"), "fire1") && (contains_text(visit_url("questlog.php?which=1"), "You should check out A-Boo Peak and see what's going on there.") || contains_text(visit_url("questlog.php?which=1"), "You should keep clearing the ghosts out of A-Boo Peak so you can reach the signal fire.")))
	{
		cli_execute("set choiceAdventure611 = 1");
		if (false)
		{	
			//old method:
			cli_execute("call ../Outfit items");
			cli_execute("call Library/switch to cannelloni combat script.ash");
			cli_execute("adventure 5 a-boo peak");
			while (available_amount($item[a-boo clue]) < 3)
				cli_execute("adventure 1 a-boo peak");
			cli_execute("maximize spooky res -tie");
			cli_execute("cast elemental saucesphere; cast scarysauce; use can of black paint; acquire can of black paint; use philter of phorce");
			cli_execute("use a-boo clue; adventure 1 a-boo peak");
			cli_execute("use a-boo clue; adventure 1 a-boo peak");
			cli_execute("use a-boo clue; adventure 1 a-boo peak");
			cli_execute("adventure 1 a-boo peak");
			cli_execute("call ../Outfit experience");
		}
		else
		{
			//new method:
			string old_clover_protect = get_property("cloverProtectActive"); 
			set_property("cloverProtectActive", "false");
			while (available_amount($item[a-boo clue]) < 4)
			{
				cli_execute("acquire 1 ten-leaf clover");
				cli_execute("adventure 1 a-boo peak");
			}
			set_property("cloverProtectActive", old_clover_protect);

			cli_execute("maximize spooky res -tie");
			cli_execute("cast elemental saucesphere; cast scarysauce; use can of black paint; acquire can of black paint; use philter of phorce");
			cli_execute("use a-boo clue; adventure 1 a-boo peak");
			cli_execute("use a-boo clue; adventure 1 a-boo peak");
			cli_execute("use a-boo clue; adventure 1 a-boo peak");
			cli_execute("use a-boo clue; adventure 1 a-boo peak");
			cli_execute("adventure 1 a-boo peak");
			cli_execute("call ../Outfit experience");
		}
	}


	if (!contains_text(visit_url("place.php?whichplace=highlands"), "fire3") && (contains_text(visit_url("questlog.php?which=1"), "You should go to Oil Peak and investigate the signal fire there.") || contains_text(visit_url("questlog.php?which=1"), "You should keep killing oil monsters until the pressure on the peak drops enough for you to reach the signal fire.")))
	{
		cli_execute("call ../Outfit experience");
		cli_execute("adventure 1 oil peak");
		while (contains_text(visit_url("questlog.php?which=1"), "You should keep killing oil monsters until the pressure on the peak drops enough for you to reach the signal fire."))
			cli_execute("adventure 1 oil peak");
	}


	if (contains_text(visit_url("questlog.php?which=1"), "You need to solve the mystery of Twin Peak and figure out how to light the signal fire."))
	{
		cli_execute("set choiceAdventure604 = 1");
		cli_execute("set choiceAdventure605 = 1");
		cli_execute("use ant agonist");
		cli_execute("use knob goblin eyedrops");
		cli_execute("cast elemental saucesphere");

		cli_execute("set choiceAdventure607 = 1");
		cli_execute("set choiceAdventure608 = 1");
		cli_execute("set choiceAdventure609 = 1");
		cli_execute("set choiceAdventure610 = 1");
		cli_execute("set choiceAdventure616 = 1");
		cli_execute("set choiceAdventure617 = 1");

		cli_execute("set choiceAdventure606 = 6"); //ignore this adventure
		
		cli_execute("adventure 1 twin peak");

		cli_execute("set choiceAdventure606 = 1");
		cli_execute("use rusty hedge trimmers");
		cli_execute("set choiceAdventure606 = 2");
		cli_execute("use rusty hedge trimmers");
		cli_execute("set choiceAdventure606 = 3");
		cli_execute("use rusty hedge trimmers");
		cli_execute("set choiceAdventure606 = 4");
		cli_execute("use rusty hedge trimmers");
		cli_execute("call Library/switch to cannelloni combat script.ash");
	
	}



	cli_execute("place.php?whichplace=highlands&action=highlands_dude");
	cli_execute("call ../Outfit experience");
	cli_execute("council.php");
}