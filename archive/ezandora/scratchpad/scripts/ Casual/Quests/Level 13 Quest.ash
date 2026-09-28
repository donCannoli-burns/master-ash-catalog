void tryEntryway()
{
	cli_execute("acquire 1 balloon monkey");	//command is entryway clover	//sneaky pete's key -> fish hose	//jarlsberg's key -> fishtank	//boris's key -> fishbowl		//fish hose + fishbowl = hosed fishbowl + fishtank = makeshift scuba gear	//fish hose + fishtank = hosed tank + fishbowl = makeshift scuba gear

	boolean have_sneaky_petes_key = (available_amount($item[sneaky pete's key]) > 0);	boolean have_jarlsbergs_key = (available_amount($item[jarlsberg's key]) > 0);	boolean have_boriss_key = (available_amount($item[boris's key]) > 0);	boolean have_sneaky_petes_item = false;	boolean have_jarlsbergs_item = false;	boolean have_boriss_item = false;	if (available_amount($item[fish hose]) > 0)		have_sneaky_petes_item = true;	if (available_amount($item[fishtank]) > 0)		have_jarlsbergs_item = true;	if (available_amount($item[fishbowl]) > 0)		have_boriss_item = true;	if (available_amount($item[hosed fishbowl]) > 0)	{		//fish hose + fishbowl		have_sneaky_petes_item = true;		have_boriss_item = true;	}	if (available_amount($item[hosed tank]) > 0)	{		//fish hose + fishtank		have_sneaky_petes_item = true;		have_jarlsbergs_item = true;	}	if (available_amount($item[makeshift scuba gear]) > 0)	{		have_sneaky_petes_item = true;		have_jarlsbergs_item = true;		have_boriss_item = true;	}	boolean have_zap_wand = ((available_amount($item[aluminum wand]) + available_amount($item[ebony wand]) + available_amount($item[hexagonal wand]) + available_amount($item[marble wand]) + available_amount($item[pine wand])) > 0);		//Complicated...	boolean have_key_to_use = false;	if (have_sneaky_petes_key && !have_sneaky_petes_item)		have_key_to_use = true;	if (have_jarlsbergs_key && !have_jarlsbergs_item)		have_key_to_use = true;	if (have_boriss_key && !have_boriss_item)		have_key_to_use = true;	if (!have_key_to_use)	{		//Acquire next key:		if (!have_sneaky_petes_key && !have_jarlsbergs_key && !have_boriss_key)		{			//buy next key:			if (available_amount($item[fat loot token]) == 0)
			{				print("No fat loot tokens to be found.");				return;
			}
			print("Buying sneaky pete's key");			visit_url("shop.php?whichshop=damachine&action=buyitem&quantity=1&whichrow=95", true);		}		else		{			if (have_zap_wand)			{				if (have_sneaky_petes_key && have_sneaky_petes_item)					cli_execute("zap sneaky pete's key");				else if (have_jarlsbergs_key && have_jarlsbergs_item)					cli_execute("zap jarlsberg's key");				else if (have_boriss_key && have_boriss_item)					cli_execute("zap boris's key");			}			else			{				//buy next key:				if (available_amount($item[fat loot token]) == 0)				{					if (closet_amount($item[fat loot token]) == 0)					{						print("No fat loot tokens to be found.");						return;					}					cli_execute("closet take fat loot token");				}				if (!have_sneaky_petes_key && !have_sneaky_petes_item)				{
					print("Buying sneaky pete's key");					//sneaky pete's key - row 95					visit_url("shop.php?whichshop=damachine&action=buyitem&quantity=1&whichrow=95", true);							}				else if (!have_jarlsbergs_key && !have_jarlsbergs_item)				{
					print("Buying jarlsberg's key");					//jarlsberg - row 94					visit_url("shop.php?whichshop=damachine&action=buyitem&quantity=1&whichrow=94", true);				}				else if (!have_boriss_key && !have_boriss_item)				{
					print("Buying boris's key");					//boris - row 93					visit_url("shop.php?whichshop=damachine&action=buyitem&quantity=1&whichrow=93", true);				}			}		}	}
	//cli_execute("entryway clover");
	if (entryway())
	{
		//blank if?
	}
}

void main()
{
	if (my_level() < 13) return;
	if (get_property("questL13Final") == "finished")
		return;
	cli_execute("call Library/switch to stringozzi serpent combat script no runaways.ash");
	//if (get_property("questL13Final") == "unstarted")
		//return;
	if (get_property("questL13Final") == "started" || get_property("questL13Final") == "step1" || get_property("questL13Final") == "step2" || get_property("questL13Final") == "step3")
	{
		cli_execute("mood none");
		//entryway
		while (!contains_text(visit_url("lair.php"), "usemap=\"#Map"))
		{
			//I think this aborts - fix it
			tryEntryway();
			if (available_amount($item[sneaky pete's key]) + available_amount($item[jarlsberg's key]) + available_amount($item[boris's key]) > 2)
			{
				print("internal error");
				return;
			}
		}

	}
	//if (get_property("questL13Final") == "step4")
	if (contains_text(visit_url("lair.php"), "usemap=\"#Map\""))
	{
		//hedge maze
		//command is hedge
		cli_execute("call ../Outfit items");
		while (!contains_text(visit_url("lair.php"), "usemap=\"#Map2\""))
		{
			while (available_amount($item[hedge maze puzzle]) == 0)
			{
				cli_execute("adventure 1 hedge maze");
			}
			//I think this aborts - fix it
			//cli_execute("hedge");
			if (hedgemaze())
			{
				//blank if?
			}
		}
	}
	if (contains_text(visit_url("lair.php"), "usemap=\"#Map2\"") || contains_text(visit_url("lair.php"), "usemap=\"#Map3\""))
	{
		cli_execute("mood none");
		cli_execute("call ../Outfit experience");
		cli_execute("ccs apathetic");
		cli_execute("familiar sandworm");
		//tower guardians
		//command is guardians
		cli_execute("guardians");
	}
	//if (get_property("questL13Final") == "step10")
	if (contains_text(visit_url("lair6.php"), "chamber5.gif"))
	{
		print("Time to fight... the sorceress.");
		//Set up outfit, combat macro:
		//Let's do it!
		cli_execute("maximize muscle -tie");
		cli_execute("acquire wand of nagamar");
		cli_execute("familiar sandworm");
		cli_execute("equip brimstone boxers");
		cli_execute("equip depleted grimacite ninja mask");
		cli_execute("mcd 0");
		cli_execute("restore hp");
		cli_execute("ccs casual defeat naughty sorceress");
		cli_execute("lair6.php?place=5");
		run_combat();
		run_combat();
		run_combat();
		cli_execute("ccs Cannelloni");
		
	}
	//if (get_property("questL13Final") == "step11")
	if (contains_text(visit_url("lair6.php"), "kingprism1"))
	{
		//free the imprisimed king
		print("Hi-keeba!");
		cli_execute("lair6.php?place=6");
	}
	
}