
import "scripts/Helix Fossil/Helix Fossil Interface.ash"

void main()
{
	if (get_property("questM03Bugbear") == "finished")
		return;
	if (!knoll_available()) return;
	cli_execute("acquire annoying pitchfork");
	cli_execute("acquire frozen mushroom");
	cli_execute("acquire flaming mushroom");
	cli_execute("acquire stinky mushroom");
	visit_url("place.php?whichplace=knoll_friendly&action=dk_mayor");
	visit_url("place.php?whichplace=knoll_friendly&action=dk_mayor");
	visit_url("place.php?whichplace=knoll_friendly&action=dk_mayor");
	
	
	HelixResetSettings();
	__helix_settings.monsters_to_run_away_from = $monsters[spooky gravy fairy guard,spooky gravy fairy ninja,spooky gravy fairy warlock];
	HelixWriteSettings();
	
	if ($familiar[spooky gravy fairy].have_familiar())
		use_familiar($familiar[spooky gravy fairy]);
	else if ($familiar[sleazy gravy fairy].have_familiar())
		use_familiar($familiar[sleazy gravy fairy]);
	else
	{
		abort("no fairy");
		return;
	}
	string maximise_extra;
	if (inebriety_limit() - my_inebriety() < 0)
		maximise_extra = " +equip drunkula's wineglass";
	
	cli_execute("maximize item -tie" + maximise_extra);
	if ($item[navel ring of navel gazing].available_amount() > 0)
	{
		cli_execute("maximize -combat -tie +equip navel ring of navel gazing" + maximise_extra);
		//cli_execute("autoattack runaway");
	}
	else
		cli_execute("maximize -combat -tie" + maximise_extra);
	if ($item[pantsgiving].available_amount() > 0)
		cli_execute("equip pantsgiving");
	cli_execute("cast 4 smooth; cast 4 sonata");
	boolean set_auto_attack = false;
	while (get_property("questM03Bugbear") != "finished" && my_adventures() > 0)
	{
		if ($item[spooky fairy gravy].available_amount() > 0 && $item[spooky glove].available_amount() == 0)
		{
			visit_url("campground.php?action=inspectkitchen");
			cli_execute("acquire spooky glove");
		}
		if ($item[spooky glove].available_amount() > 0 && $item[spooky glove].equipped_amount() == 0)
			cli_execute("wear acc2 spooky glove");
		if ($item[spooky glove].equipped_amount() > 0 && $item[inexplicably glowing rock].available_amount() > 0 && !set_auto_attack)
		{
			//cli_execute("autoattack fury of the sauc");
			set_auto_attack = true;
		}
		if ($location[The Spooky Gravy Burrow].turns_spent >= 50)
		{
			break;
		}
		adv1($location[The Spooky Gravy Burrow], 0, "");
		visit_url("place.php?whichplace=knoll_friendly&action=dk_mayor");
	}
	if (hippy_stone_broken())
		cli_execute("closet put * mushroom fermenting solution");
	//cli_execute("mallsell * mushroom fermenting solution");
	cli_execute("autoattack none");
	cli_execute("fam none");
	HelixResetSettings();
	HelixWriteSettings();
}