void sneakyAdventure(item target_item, string area)
{
	while (available_amount(target_item) == 0)
	{
		if (have_effect($effect[fresh scent]) == 0)
			cli_execute("use 1 chunk of rock salt");
		if (have_effect($effect[Smooth Movements]) == 0)
			cli_execute("cast smooth movement");
		if (have_effect($effect[Sonata of Sneakiness]) == 0)
			cli_execute("cast sonata");
		cli_execute("adventure 1  " + area);
	}
}

void adventureUltrahydratedDesert(int times)
{
	if (have_effect($effect[Ultrahydrated]) == 0)
	{
		string old_clover_protect = get_property("cloverProtectActive"); 
		set_property("cloverProtectActive", "false");
		cli_execute("acquire ten-leaf clover; adventure 1 oasis");
		set_property("cloverProtectActive", old_clover_protect);
	}
	cli_execute("adventure " + times + " desert (ultrahydrated)");
}

int dustyBottleWithGlyph(int glyph)
{
	int i = 2271;
	while (i <= 2276)
	{
		if (to_int(get_property("lastDustyBottle" + i)) == glyph)
			return i;
		i = i + 1;
	}
	return -1;
}

boolean solveWinePuzzle()
{
	if (contains_text(visit_url("manor3.php"), "Summoning Chamber"))
		return true;
	string puzzle_text = visit_url("manor3.php?place=goblet");
	//Hacky:
//source:
//<img src="/images/otherimages/manor/glyph6.gif" width=75 height=75 alt="Arcane Glyph #6" title="Arcane Glyph #6"></td></tr><tr><td height=230 align=right valign=bottom><img src="/images/otherimages/manor/glyph4.gif" width=75 height=75 alt="Arcane Glyph #4" title="Arcane Glyph #4"></td><td valign=top><img src="/images/otherimages/manor/bigglyph.gif" width=200 height=200 alt="Big Cental Arcane Glyph" title="Big Central Arcane Glyph"></td><td align=left valign=bottom><img src="/images/otherimages/manor/glyph3.gif" width=75 height=75 alt="Arcane Glyph #3" title="Arcane Glyph #3">
	int [int] glyph_locations;
	for i from 1 upto 6
		glyph_locations[i] = index_of(puzzle_text, "Arcane Glyph #" + i);
	int min_glyph = -1;
	int min_glyph_location = -1;
	int max_glyph = -1;
	int max_glyph_location = -1;
	int middle_glyph = -1;
	int middle_glyph_location = -1;
	foreach i in glyph_locations
	{
		int glyph_location = glyph_locations[i];
		if (glyph_location < 0) continue;
		if (glyph_location < min_glyph_location || min_glyph == -1)
		{
			min_glyph_location = glyph_location;
			min_glyph = i;
		}
		if (glyph_location > max_glyph_location || max_glyph == -1)
		{
			max_glyph_location = glyph_location;
			max_glyph = i;
		}
	}
	if (min_glyph == -1 || max_glyph == -1)
		return false;
	foreach i in glyph_locations
	{
		int glyph_location = glyph_locations[i];
		if (glyph_location < 0) continue;

		if (glyph_location == min_glyph_location || glyph_location == max_glyph_location)
			continue;
		if (glyph_location > min_glyph_location && glyph_location < max_glyph_location && (glyph_location < middle_glyph_location || middle_glyph == -1))
		{
			middle_glyph_location = glyph_location;
			middle_glyph = i;
		}
	}
	if (middle_glyph == -1)
		return false;
	print("Pour " + min_glyph + ", then " + middle_glyph + ", then " + max_glyph + ".");
	
	int min_glyph_bottle = dustyBottleWithGlyph(min_glyph);
	int middle_glyph_bottle = dustyBottleWithGlyph(middle_glyph);
	int max_glyph_bottle = dustyBottleWithGlyph(max_glyph);
	print("Pour " +min_glyph_bottle + ", then " + middle_glyph_bottle + ", then " + max_glyph_bottle + ".");
	if (min_glyph_bottle == -1 || middle_glyph_bottle == -1 || max_glyph_bottle == -1)
		return false;
	print("Pour " + to_item(min_glyph_bottle) + ", then " + to_item(middle_glyph_bottle) + ", then " + to_item(max_glyph_bottle) + ".");
	
	cli_execute("acquire " + to_item(min_glyph_bottle));
	cli_execute("acquire " + to_item(middle_glyph_bottle));
	cli_execute("acquire " + to_item(max_glyph_bottle));
	//manor3.php?action=pourwine&whichwine=itemid
	cli_execute("manor3.php?action=pourwine&whichwine=" + min_glyph_bottle);
	cli_execute("manor3.php?action=pourwine&whichwine=" + middle_glyph_bottle);
	cli_execute("manor3.php?action=pourwine&whichwine=" + max_glyph_bottle);

	return true;
}

void main()
{
	if (my_level() < 11) return;
	if (get_property("questL11MacGuffin") == "finished")
		return;
	//oh god

	if (!contains_text(visit_url("questlog.php?which=1"), "Ezandora and the Quest for the Holy MacGuffin"))
	{
		return;
	}
	//The Council has instructed you to collect your father's archaeology notes from Distant Lands, and use them to hunt down the Holy MacGuffin. Your first step is to find the Black Market, to get some forged ID.
	if (contains_text(visit_url("questlog.php?which=1"), "Your first step is to find the Black Market, to get some forged ID."))
	{
		cli_execute("call ../Outfit experience");
		cli_execute("call ../Outfit -combat");
		sneakyAdventure($item[black market map], "black forest");
		cli_execute("use black market map");
		//cli_execute("acquire ");
		
	}
	//You've found the Black Market... now to hit the Travel Agency and get yourself on a slow boat to China. I mean, Distant Lands.
	if (contains_text(visit_url("questlog.php?which=1"), "You've found the Black Market... now to hit the Travel Agency and get yourself on a slow boat to China. I mean, Distant Lands."))
	{
		if (available_amount($item[forged identification documents]) == 0)
			cli_execute("acquire forged identification documents");
		cli_execute("adventure 1 moxie vacation");
		cli_execute("use your father's MacGuffin diary");
	}

//Never Odd Or Even
//If you're going to get the Staff of Fats, it looks like the first step is to get into the Palindome. Maybe it has something to do with that amulet your father mentioned in his diary? That password looks important, too.
//Well, you found the Staff of Fats, but then you lost it again. Good going. Looks like you're going to have to track down this Mr. Alarm guy for help...

//A Pyramid Scheme
//Your father's diary indicates that the key to finding the Holy MacGuffin is hidden somewhere in the desert. I hope you've got your walking shoes on.
//You've managed to stumble upon a hidden oasis out in the desert. That should help make your desert explorations a little less... dry.
//The fremegn leader Gnasir has tasked you with finding a stone rose, at his abandoned encampment near the oasis. Apparently it's an ancient symbol of his tribe or something, I dunno, whatever. He's not gonna help you unless you get it for him, though.
//You've found all of Gnasir's missing manual pages. Time to take them back to the sietch.
//You've found the hidden buried pyramid that guards the Holy MacGuffin. You're so close you can almost taste it! (In a figurative sense, I mean -- I don't recommend you go around licking things you find in ancient tombs.)


//Gotta Worship Them All
//Your father seemed to think the hidden temple in the Distant Woods might be guarding part of the Staff of Ed. I hope you've got your lucky fedora with you.
//Awesome, you've evaded all of the temple's traps! Of course, it turned out that getting the piece of the Staff of Ed isn't going to be nearly that easy, but you were probably expecting that anyway. If you weren't, well, sorry.

//In a Manor of Spooking
//Your father's notes indicate that the gem from the Staff of Ed is probably hidden in a Seaside Town mansion. At a guess, you figure Spookyraven Manor is probably your best bet.
//You've unlocked the wine cellar in Spookyraven Manor. What are the chances there's a secret door hidden somewhere? Yeah, probably about one in one.

//Ezandora and the Quest for the Holy MacGuffin
//You've picked up your father's diary, and things just got a whole lot more complicated. Oh dear.
	//Spookyraven:
	if (contains_text(visit_url("questlog.php?which=1"), "Your father's notes indicate that the gem from the Staff of Ed is probably hidden in a Seaside Town mansion. At a guess, you figure Spookyraven Manor is probably your best bet.") && available_amount($item[spookyraven ballroom key]) > 0)
	{
		cli_execute("call ../Outfit experience");
		cli_execute("call ../Outfit -combat");
		while (!contains_text(visit_url("questlog.php?which=1"), "You've unlocked the wine cellar in Spookyraven Manor."))
			cli_execute("adventure 1 haunted ballroom");
	}
	if (contains_text(visit_url("questlog.php?which=1"), "You've unlocked the wine cellar in Spookyraven Manor."))
	{
		solveWinePuzzle();
	}
	if (contains_text(visit_url("questlog.php?which=1"), "You've found Lord Spookyraven's secret black magic laboratory."))
	{
		cli_execute("call scripts/Zone Prepares/Lord Spookyraven");
		cli_execute("call Library/switch to stringozzi serpent combat script.ash");
		cli_execute("call ../Outfit experience");
		print("Fighting lord spookyraven...");
		visit_url("manor3.php?place=chamber");
		run_combat();
	}
	if (my_adventures() < 30) return;


	//Hidden City:
	if (contains_text(visit_url("questlog.php?which=1"), "Your father seemed to think the hidden temple in the Distant Woods might be guarding part of the Staff of Ed. I hope you've got your lucky fedora with you."))
	{
		
		if (false && to_int(get_property("lastTempleAdventures")) < my_ascensions())
		{
			//+3 adventures:
			//doesn't work
			cli_execute("set choiceAdventure582 = 1");
			cli_execute("set choiceAdventure579 = 3");
			//cli_execute("use stone wool; adventure 1 hidden temple");
		}
		if (available_amount($item[Nostril of the serpent]) == 0)
		{
			//nostril of the serpent:
			cli_execute("set choiceAdventure579 = 2");
			cli_execute("use stone wool; adventure 1 hidden temple");
		}
		
		if (available_amount($item[Nostril of the serpent]) > 0)
		{	
			//final:
			//a bit hacky
			cli_execute("use stone wool");
			visit_url("adventure.php?snarfblat=280");
			visit_url("choice.php?whichchoice=582&option=2"); //hidden heart
			visit_url("choice.php?whichchoice=580&option=2"); //do you have stairs in your temple
			visit_url("choice.php?whichchoice=584&option=4"); //press button
			visit_url("choice.php?whichchoice=580&option=1"); //go through the door
			visit_url("choice.php?whichchoice=123&option=2"); //raise your hands like you just don't care
			//bananas:
			visit_url("tiles.php?action=jump&whichtile=4");
			visit_url("tiles.php?action=jump&whichtile=6");
			visit_url("tiles.php?action=jump&whichtile=3");
			visit_url("tiles.php?action=jump&whichtile=5");
			visit_url("tiles.php?action=jump&whichtile=7");
			visit_url("tiles.php?action=jump&whichtile=6");
			visit_url("tiles.php?action=jump&whichtile=3");

			//cli_execute("dvorak"); //word puzzle
			visit_url("choice.php?whichchoice=125&option=3"); //do nothing
			//visit_url("choice.php?whichchoice=125&option=3"); //again, just in case?
			//cli_execute("set choiceAdventure582 = 2");
			//cli_execute("set choiceAdventure580 = 2");
			//cli_execute("set choiceAdventure584 = 4");
			//cli_execute("use stone wool; adventure 1 hidden temple");
		}
	}
	if (contains_text(visit_url("questlog.php?which=1"), "Awesome, you've evaded all of the temple's traps!"))
	{
		//Do haunted city
		cli_execute("call ../Outfit experience");
		//implement this
		cli_execute("call Library/switch to cannelloni combat script.ash");
		while (available_amount($item[cracked stone sphere]) + available_amount($item[mossy stone sphere]) + available_amount($item[rough stone sphere]) + available_amount($item[smooth stone sphere]) + available_amount($item[triangular stone]) < 4)
			cli_execute("adventure 1 hidden city (automatic)");
		
		while (!contains_text(get_property("hiddenCityLayout"), "T") || !contains_text(get_property("hiddenCityLayout"), "L") || !contains_text(get_property("hiddenCityLayout"), "W") || !contains_text(get_property("hiddenCityLayout"), "N") || !contains_text(get_property("hiddenCityLayout"), "F"))
			cli_execute("adventure 1 hidden city (automatic)");
		cli_execute("call Library/switch to stringozzi serpent combat script.ash");

		if (available_amount($item[Triangular stone]) < 4 && contains_text(get_property("hiddenCityLayout"), "T") && contains_text(get_property("hiddenCityLayout"), "L") && contains_text(get_property("hiddenCityLayout"), "W") && contains_text(get_property("hiddenCityLayout"), "N") && contains_text(get_property("hiddenCityLayout"), "F"))
		{
			int lightning_id = 0;
			int water_id = 0;
			int nature_id = 0;
			int fire_id = 0;
			int i = 2174;
			while (i <= 2177)
			{
				string sphere_identification = get_property("lastStoneSphere" + i);
				if (sphere_identification == "lightning")
					lightning_id = i;
				else if (sphere_identification == "water")
					water_id = i;
				else if (sphere_identification == "nature")
					nature_id = i;
				else if (sphere_identification == "fire")
					fire_id = i;
				i = i + 1;
			}
			if (lightning_id == 0 || water_id == 0 || nature_id == 0 || fire_id == 0) //internal error
				return;
			if (available_amount(to_item(lightning_id)) > 0)
			{
				cli_execute("hiddencity.php");
				cli_execute("hiddencity.php?which=" + index_of(get_property("hiddenCityLayout"), "L"));
				cli_execute("hiddencity.php?action=roundthing&whichitem=" + lightning_id);
			}	
			if (available_amount(to_item(water_id)) > 0)
			{
				cli_execute("hiddencity.php");
				cli_execute("hiddencity.php?which=" + index_of(get_property("hiddenCityLayout"), "W"));
				cli_execute("hiddencity.php?action=roundthing&whichitem=" + water_id);
			}
			if (available_amount(to_item(nature_id)) > 0)
			{
				cli_execute("hiddencity.php");
				cli_execute("hiddencity.php?which=" + index_of(get_property("hiddenCityLayout"), "N"));
				cli_execute("hiddencity.php?action=roundthing&whichitem=" + nature_id);
			}	
			if (available_amount(to_item(fire_id)) > 0)
			{
				cli_execute("hiddencity.php");
				cli_execute("hiddencity.php?which=" + index_of(get_property("hiddenCityLayout"), "F"));
				cli_execute("hiddencity.php?action=roundthing&whichitem=" + fire_id);
			}	
		}
		if (available_amount($item[Triangular stone]) == 4)
		{
			cli_execute("ccs cannelloni");
			cli_execute("hiddencity.php");
			cli_execute("hiddencity.php?which=" + index_of(get_property("hiddenCityLayout"), "T"));
			cli_execute("hiddencity.php?action=trisocket");
			run_combat();
			cli_execute("call Library/switch to stringozzi serpent combat script.ash");
		}
	}
	if (my_adventures() < 30) return;

	//Palindome:
	if ((available_amount($item[pirate fledges]) > 0 || equipped_amount($item[pirate fledges]) > 0) && available_amount($item[talisman o' nam]) == 0 && my_basestat($stat[mysticality]) >= 60)
	{
		cli_execute("call ../Outfit experience");
		cli_execute("equip acc3 pirate fledges");
		//Acquire talisman o' nam:
		//Check if we can go belowdecks. If not, unlock belowdecks:
		if (!contains_text(visit_url("cove.php"), "cove3_5x2b.gif"))
		{
			cli_execute("call ../Outfit -combat");
			cli_execute("equip acc3 pirate fledges");
			cli_execute("set choiceAdventure189 = 2");
			while (!contains_text(visit_url("cove.php"), "cove3_5x2b.gif"))
			{
				cli_execute("adventure 1 poop deck");
			}
		}
		//Acquire talisman o' nam:
		if (contains_text(visit_url("cove.php"), "cove3_5x2b.gif"))
		{
			cli_execute("ccs casualbelowdecks");
			while (!(available_amount($item[talisman o' nam]) > 0 || available_amount($item[Snakehead charrrm]) >= 2 || available_amount($item[Gaudy key]) >= 2))
			{
				cli_execute("adventure 1 belowdecks");
				
			}
			cli_execute("call Library/switch to stringozzi serpent combat script.ash");
		}
	}
	if (my_adventures() < 30) return;
	while (available_amount($item[Gaudy key]) > 0)
		cli_execute("use gaudy key");
	if (available_amount($item[Snakehead charrrm]) == 2)
	{
		cli_execute("acquire talisman o' nam");
	}

	if (available_amount($item[talisman o' nam]) > 0)
	{
		//Talisman available
		//Check quest status:
		if (available_amount($item[I love me, Vol. I]) == 0)
		//if (contains_text(visit_url("questlog.php?which=1"), "Congratulations, you've discovered the fabulous Palindome, rumored to be the final resting place of the legendary Staff of Fats! Now all you have to do is find it"))
		{
			cli_execute("call ../Outfit experience");
			cli_execute("equip talisman o' nam");
			//Acquire I love me:
			while (available_amount($item[I love me, Vol. I]) == 0)
				cli_execute("adventure 1 palindome");
			cli_execute("use I love me, Vol. I");
		}
		//Look for Mr. Alarm:
		if (contains_text(visit_url("questlog.php?which=1"), "Looks like you're going to have to track down this Mr. Alarm guy for help..."))
		{
			cli_execute("call ../Outfit experience");
			cli_execute("call ../Outfit -combat");
			cli_execute("acquire wet stunt nut stew");
			cli_execute("set choiceAdventure517 = 1");
			if (available_amount($item[cobb's knob lab key]) > 0)
			{
				while (available_amount($item[mega gem]) == 0)
					cli_execute("adventure 1 cobb's knob laboratory");
			}
		}
		//Fight Dr. Awkward:
		if (contains_text(visit_url("questlog.php?which=1"), "Oh yeah, you've got the Mega Gem, and are ready to deliver some pain to Dr. Awkward."))
		{
			cli_execute("call ../Outfit experience");
			cli_execute("equip acc3 talisman o'nam");
			cli_execute("equip acc2 mega gem");
			cli_execute("call Library/switch to stringozzi serpent combat script.ash");
			cli_execute("adventure 1 palindome");
			cli_execute("call ../Outfit experience");
		}
	}

	if (my_adventures() < 30) return;
	if (contains_text(visit_url("questlog.php?which=1"), "A Pyramid Scheme"))
	{
		//Unlocking the pyramid:
		cli_execute("call ../Outfit experience");
		if (contains_text(visit_url("questlog.php?which=1"), "Your father's diary indicates that the key to finding the Holy MacGuffin is hidden somewhere in the desert. I hope you've got your walking shoes on."))
		{
			//Need oasis unlocked.
			cli_execute("set choiceAdventure132 = 2");
			while (contains_text(visit_url("questlog.php?which=1"), "Your father's diary indicates that the key to finding the Holy MacGuffin is hidden somewhere in the desert. I hope you've got your walking shoes on."))
				cli_execute("adventure 1 desert (unhydrated)");
			cli_execute("hottub");
		}
		cli_execute("call Library/UseHipster.ash");
		if (contains_text(visit_url("questlog.php?which=1"), "You've managed to stumble upon a hidden oasis out in the desert."))
		{
			//Find gnasir the first time:
			cli_execute("call ../Outfit experience");
			cli_execute("call Library/UseHipster.ash");
			while (contains_text(visit_url("questlog.php?which=1"), "You've managed to stumble upon a hidden oasis out in the desert."))
			{
				adventureUltrahydratedDesert(1);
			}
		}
		if (contains_text(visit_url("questlog.php?which=1"), "The fremegn leader Gnasir has tasked you with finding a stone rose, at his abandoned encampment near the oasis."))
		{
			while (available_amount($item[stone rose]) == 0)
				cli_execute("adventure 1 oasis");
			while (contains_text(visit_url("questlog.php?which=1"), "The fremegn leader Gnasir has tasked you with finding a stone rose, at his abandoned encampment near the oasis."))
			{
				adventureUltrahydratedDesert(1);
			}
			
		}
		cli_execute("acquire 2 drum machine; acquire 2 can of black paint");
		while (contains_text(visit_url("questlog.php?which=1"), "Gnasir seemed satisfied with the tasks you performed for his tribe, and has asked you to come back later."))
		{
			adventureUltrahydratedDesert(1);
		}
		while (contains_text(visit_url("questlog.php?which=1"), "You need to find fifteen missing pages from Gnasir's worm-riding manual. Have fun!"))
			cli_execute("adventure 1 oasis");
		while (contains_text(visit_url("questlog.php?which=1"), "One worm-riding manual page down, fourteen to go."))
			cli_execute("adventure 1 oasis");
		if (contains_text(visit_url("questlog.php?which=1"), "Two worm-riding manual pages down, thirteen to go. Sigh."))
		{
			while (available_amount($item[worm-riding manual pages 3-15]) == 0)
				cli_execute("adventure 1 oasis");
		}
		while (contains_text(visit_url("questlog.php?which=1"), "You've found all of Gnasir's missing manual pages. Time to take them back to the sietch."))
			adventureUltrahydratedDesert(1);
		//if (available_amount($item[Worm-riding hooks]) != 0)
			cli_execute("beach.php?action=woodencity");
		if (my_adventures() < 30) return;

		//Actual pyramid:
		if (contains_text(visit_url("questlog.php?which=1"), "You've found the hidden buried pyramid that guards the Holy MacGuffin. You're so close you can almost taste it!"))
		{
			//Hmm...
			//No way to tell if the wheel's been put on.
			//Basics:
			cli_execute("pyramid.php");
			if (to_int(get_property("pyramidPosition")) == 1 && !(available_amount($item[ancient bomb]) > 0 || to_boolean(get_property("pyramidBombUsed"))))
			{
				cli_execute("set choiceAdventure134 = 1"); //spin wheel
				cli_execute("set choiceAdventure135 = 1"); //spin wheel
				//cli_execute("set choiceAdventure164 = 1"); //spin wheel
				//Assume we're at the start.
				//Acquire wheel:
				cli_execute("call ../Outfit experience");
				cli_execute("call ../Outfit -combat");
				while (available_amount($item[carved wooden wheel]) == 0)
					cli_execute("adventure 1 upper chamber");
				while (available_amount($item[carved wooden wheel]) != 0)
					cli_execute("adventure 1 middle chamber");
				//Now do more stuff:
				if (available_amount($item[carved wooden wheel]) != 0)
				{
					print("VERY BAD THING");
					return;
				}
				cli_execute("pyramid.php");
				//implement this
			}
			if (to_int(get_property("pyramidPosition")) == 2)
			{
				cli_execute("use 2 tomb ratchet");
				cli_execute("pyramid.php");
			}
			if (to_int(get_property("pyramidPosition")) == 4)
			{
				cli_execute("adventure 1 lower chambers"); //acquire token
				cli_execute("use 4 tomb ratchet");
				cli_execute("pyramid.php");
			}
			if (to_int(get_property("pyramidPosition")) == 3)
			{
				cli_execute("pyramid.php?action=lower"); //trade token
				cli_execute("use 3 tomb ratchet");
				cli_execute("pyramid.php");
			}
			if (to_int(get_property("pyramidPosition")) == 1)
			{
				//fight ed:
				cli_execute("call ../Outfit experience");
				cli_execute("call Library/switch to stringozzi serpent combat script.ash");
				//final:
				if (!to_boolean(get_property("pyramidBombUsed")))
				{
					if (available_amount($item[ancient bomb]) == 0)
					{
						print("internal error");
					}
					cli_execute("adventure 1 lower chambers"); //open it
				}
				cli_execute("adventure 1 lower chambers"); //fight
				run_combat(); //2
				run_combat(); //3
				run_combat(); //4
				run_combat(); //5
				run_combat(); //6
				run_combat(); //7
			}
		}
	}
	cli_execute("council.php");
}