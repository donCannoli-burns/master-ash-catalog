import "scripts/Farming/CheapFarm.ash";
import "scripts/Helix Fossil/Helix Fossil Interface.ash";
import "scripts/Destiny Ascension/Destiny Ascension/Support/Library.ash";

string SourceTerminalURLForCommand(string command)
{
    return "choice.php?whichchoice=1191&option=1&input=" + command;
}

void SourceTerminalExecuteCommand(string command)
{
    visit_url("campground.php?action=terminal");
    visit_url(SourceTerminalURLForCommand(command));
}

void runStuartTentacleFight()
{
	buffer page_text = visit_url("place.php?whichplace=forestvillage&action=fv_scientist");
	/*if (!page_text.contains_text("Can I fight that tentacle you saved for science?"))
	{
		run_choice_by_text(page_text, "Great");
		return;
	}*/
	boolean success = run_choice_by_text(page_text, "Can I fight that tentacle you saved for science");
	if (success)
		run_combat();
	else
		run_choice_by_text(page_text, "Great");
		
}

boolean __ran_precheck_before = false;
void freeFightPrecheck()
{
	if (!__ran_precheck_before)
	{
		cli_execute("mood none");
		cli_execute("maximize mainstat -tie -weapon");
		if ($item[pantsgiving].available_amount() > 0)
			cli_execute("equip pantsgiving");
		//cli_execute("equip buddy bjorn");
		//cli_execute("equip protonic accelerator pack");
		__ran_precheck_before = true;
	}
	
	if ($item[buddy bjorn].equipped_amount() > 0 || true)
	{
		if (get_property("_grimFairyTaleDropsCrown").to_int() < 2 && $familiar[grim brother].have_familiar() && $familiar[grim brother] != my_familiar())
			bjornify_familiar($familiar[grim brother]);
		else if ($item[protonic accelerator pack].available_amount() > 0)
			cli_execute("equip protonic accelerator pack");
		else if (get_property("_grimstoneMaskDropsCrown").to_int() == 0 && $familiar[grimstone golem].have_familiar() && $familiar[grimstone golem] != my_familiar())
			bjornify_familiar($familiar[grimstone golem]);
		else if ($familiar[warbear drone].have_familiar() && $familiar[warbear drone] != my_familiar())
			bjornify_familiar($familiar[warbear drone]);
	}
	if (my_hp() < 100)
		cli_execute("restore hp");
	
	//stop animating all the time:
	if ($familiar[happy medium].have_familiar() && $familiar[happy medium].charges >= 1)
		cli_execute("familiar happy medium");
	else
	{
		boolean [familiar] banned_familiars = $familiars[mini-hipster, artistic goth kid,angry jung man, crimbo shrub];
		insureOnceDailyFamiliars(true, banned_familiars);
	}
}

void runFreeFights()
{
	int breakout = 15;
	while (to_int(get_property("_brickoFights")) < 10 && breakout > 0 && my_adventures() > 0 && $item[BRICKO eye brick].historical_price() < 500)
	{
		breakout -= 1;
		//cli_execute("autoattack pocket crumbs farm");
		cli_execute("acquire seal tooth");
		cli_execute("acquire 1 bricko ooze");
		freeFightPrecheck();
		use(1, $item[bricko ooze]);
		//cli_execute("autoattack none");
	}
	//not enough lynyrd snares in the mall to be worthwhile
	
	if ($item[Claw of the Infernal Seal].available_amount() > 0 && $item[Claw of the Infernal Seal].item_amount() + $item[Claw of the Infernal Seal].equipped_amount() == 0)
		cli_execute("acquire Claw of the Infernal Seal");
	
    int seal_summon_limit = 5;
    if ($item[Claw of the Infernal Seal].item_amount() + $item[Claw of the Infernal Seal].equipped_amount() > 0)
    {
        seal_summon_limit = 10;
    }
    if (my_class() != $class[seal clubber])
    	seal_summon_limit = 0;
    
    breakout = 15;
    while (MAX(seal_summon_limit - get_property("_sealsSummoned").to_int(), 0) > 0 && breakout > 0 && guild_store_available())
    {
    	cli_execute("equip weapon meat tenderizer is murder");
    	cli_execute("acquire seal-blubber candle");
		freeFightPrecheck();
    	cli_execute("use figurine of a wretched-looking seal");
    }
    
    if ($familiar[machine elf].have_familiar() && $familiar[machine elf].is_unrestricted())
    {
    	//FIXME implement this:
    	//that is, fighting the machine elf monsters... we do this somewhere else...?
    }
    boolean digitised = get_property("_sourceTerminalDigitizeUses").to_int() > 0; //FIXME proper
    for i from 0 to 4
    {
    	if (my_adventures() == 0)
    		break;
    	if (get_property("_witchessFights").to_int() >= 5)
    		break;
		freeFightPrecheck();
		boolean digitising = false;
		if (!digitised)
		{
			digitising = true;
			digitised = true;
			SourceTerminalExecuteCommand("educate extract.edu");
			SourceTerminalExecuteCommand("educate digitize.edu");
			
			HelixResetSettings();
			__helix_settings.monsters_to_digitise = $monsters[witchess knight,witchess bishop];
			HelixWriteSettings();
		}
		if (can_interact())
			restore_mp(100);
	    visit_url("campground.php?action=witchess");
	    run_choice(1);
	    visit_url("choice.php?option=1&whichchoice=1182&piece=1936&pwd=" + my_hash(), false);
	    run_combat();
	    if (digitising)
	    {
			HelixResetSettings();
			HelixWriteSettings();
			SourceTerminalExecuteCommand("educate turbo.edu");
			SourceTerminalExecuteCommand("educate extract.edu");
	    }
	}
	//FIXME oliver's place
	//Eldritch horrors:
	freeFightPrecheck();
	use_skill($skill[Evoke Eldritch Horror]);
	run_combat();
	
	freeFightPrecheck();
	runStuartTentacleFight();
	//FIXME tent
	//requires parsing buttons
	//visit_url("place.php?whichplace=forestvillage&action=fv_scientist");
}

void main()
{
	runFreeFights();
}