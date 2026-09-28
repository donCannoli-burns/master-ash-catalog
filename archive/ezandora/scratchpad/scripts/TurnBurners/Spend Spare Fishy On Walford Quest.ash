import "scripts/Farming/Perfect Ice Farming.ash"
import "scripts/Helix Fossil/Helix Fossil Interface.ash"

boolean setting_adventure_in_wreck = true;

void main()
{
	if (!can_interact())
		return;
	if (!$item[aerated diving helmet].can_equip())
		return;
	if (!(get_property("coldAirportAlways").to_boolean() || get_property("_coldAirportToday").to_boolean()))
		return;
	if (my_adventures() < 10 || get_property("_borrowedTimeUsed").to_boolean())
		return;
	checkWalfordQuestStart();
	
	if ($effect[fishy].have_effect() == 0 && $item[fishy pipe].available_amount() > 0 && !get_property("_fishyPipeUsed").to_boolean())
	{
		cli_execute("use fishy pipe");
	}
	if ($effect[fishy].have_effect() == 0)
		return;
	string monkees = get_property("questS02Monkees");
	if (monkees == "unstarted" || monkees == "step1")
		setting_adventure_in_wreck = false;
	
	if (setting_adventure_in_wreck)
	{
		cli_execute("call scripts/Library/Extend current effects.ash");
		set_property("choiceAdventure299", "2");
	}
	//What to equip?
	//boolean failure_ignore = cli_execute("familiar grouper groupie");
	boolean failure_ignore = cli_execute("familiar artistic goth");
	//mini-hipster
	string maximise_command = "maximize item +equip aerated diving helmet +equip das boot";
	if (!setting_adventure_in_wreck)
		maximise_command += "  +equip walford's bucket";
	if ($item[pantsgiving].available_amount() > 0)
		maximise_command += " +equip pantsgiving";
	if ($item[buddy bjorn].available_amount() > 0)
		maximise_command += " +equip buddy bjorn";
	
	maximise_command += " -tie";
	failure_ignore = cli_execute(maximise_command);
	if ($item[buddy bjorn].equipped_amount() > 0 && $familiar[warbear drone].have_familiar())
		cli_execute("bjornify warbear drone");
	int breakout = 30;
	if (!setting_adventure_in_wreck)
	{
		HelixResetSettings();
		__helix_settings.monsters_to_olfact = $monsters[Arctic Octolus];
		HelixWriteSettings();
	}
	while ($effect[fishy].have_effect() > 0 && my_adventures() > 0 && breakout > 0)
	{
		if (get_property("walfordBucketProgress").to_int() == 100)
		{
			visit_url("place.php?whichplace=airport_cold&action=glac_walrus");
			visit_url("choice.php?whichchoice=1114&option=1");
			checkWalfordQuestStart();
		}
		if (setting_adventure_in_wreck)
			adv1($location[The Wreck of the Edgar Fitzsimmons]);
		else
			adv1($location[the ice hole]);
		breakout -= 1;
		
		item dolphin_item = get_property("dolphinItem").to_item();
		if (($items[octolus-skin cloak,norwhal helmet,sardine can key] contains dolphin_item) && $item[dolphin whistle].mall_price() <= 20000 && my_level() >= 13)
		{
			cli_execute("use dolphin whistle");
		}
	}
	HelixResetSettings();
	HelixWriteSettings();
}