import "ArchiveEquipment.ash";
import "scripts/Helix Fossil/Helix Fossil Interface.ash"

void main()
{
	if ($item[[glitch season reward name]].available_amount() == 0) return;
	
	if (!can_interact()) return;
	if (get_property("_glitchMonsterFights").to_int() > 0) return;
	if ($item[unwrapped knock-off retro superhero cape].available_amount() == 0) return;
	if (!$skill[shadow noodles].have_skill()) return;
	if (my_maxmp() < 50) return;
	
	ArchiveEquipment();
	
	cli_execute("pull * glitch season reward");
	
	
	//get can of rain-doh:
	if ($item[rain-doh blue balls].available_amount() == 0)
	{
		if ($item[can of rain-doh].available_amount() > 0)
		{
			cli_execute("use can of rain-doh");
		}
		if ($item[rain-doh blue balls].available_amount() == 0)
			abort("unlock rain-doh");
	}
	cli_execute("familiar warbear drone");
	//cli_execute("outfit birthday suit");
	stat prime_stat = my_primestat();
	stat secondary_stat_1 = $stat[muscle];
	stat secondary_stat_2 = $stat[moxie];
	if (prime_stat == $stat[muscle])
		secondary_stat_1 = $stat[mysticality];
	if (prime_stat == $stat[moxie])
		secondary_stat_2 = $stat[mysticality];
		
	cli_execute("maximize 100.0 " + prime_stat + " experience percent, 10.0 " + secondary_stat_1 + " experience percent, 10.0 " + secondary_stat_2 + " experience percent, 1.0 familiar weight, -1000.0 monster level -tie -back");
	
	if (get_property("garbageShirtCharge").to_int() > 0 && $item[January's Garbage Tote].available_amount() > 0) //'
	{
		if ($item[makeshift garbage shirt].available_amount() == 0)
		{
			visit_url("inv_use.php?whichitem=9690");
			visit_url("choice.php?whichchoice=1275&option=5");
		}
		cli_execute("equip makeshift garbage shirt");
	}
	
	if ($item[unwrapped knock-off retro superhero cape].equipped_amount() + $item[unwrapped knock-off retro superhero cape].item_amount() == 0)
	{
		retrieve_item(1, $item[unwrapped knock-off retro superhero cape]);
	}
	cli_execute("equip unwrapped knock-off retro superhero cape");
	cli_execute("retrocape robot kiss");
	//garbage shirt?
	//feel pride?
	//doesn't help meat dropped, just makes the fight more difficult. might help stats though...? but, incurs the cost of the gas balloon
	//cli_execute("equip unbreakable umbrella");
	//cli_execute("umbrella ml");
	
	
	//abort("fight glitch monster.ash - check how feel pride worked");
	cli_execute("acquire 2 gas balloon");
	string plan;
	plan += "cast shadow noodles;";
	if ($skill[feel pride].have_skill() && get_property("_feelPrideUsed").to_int() < 3)
	{
		plan += "cast feel pride;";
	}
	else
	{
		plan += "cast blow a robo-kiss;";
	}
	plan += "use rain-doh blue balls,Rain-Doh indigo cup;";
	plan += "cast blow a robo-kiss;";
	plan += "cast blow a robo-kiss;";
	plan += "cast blow a robo-kiss;";
	plan += "cast blow a robo-kiss;";
	plan += "use gas balloon;"; //300 meat
	plan += "cast blow a robo-kiss;";
	plan += "cast blow a robo-kiss;";
	plan += "cast blow a robo-kiss;";
	plan += "use gas balloon;";
	plan += "cast blow a robo-kiss;";
	plan += "repeat";
	
	HelixResetSettings();
	__helix_settings.actions_to_execute.listAppend(plan);
	HelixWriteSettings();
	if ($item[backup camera].equipped_amount() > 0 || $item[folder holder].equipped_amount() > 0)
	{
		abort("fight glitch monster do not equip these");
	}
	if (monster_level_adjustment() > 0)
	{
		abort("fight glitch monster never with monster level");
	}
	restore_mp(50);
	cli_execute("fightglitchraw.ash");
	run_combat();
	
	HelixResetSettings();
	HelixWriteSettings();
	//cli_execute("unequip weapon; unequip off-hand");
	//this doesn't work.
	//RestoreArchivedEquipment();
	
}