import "scripts/Farming/CheapFarm.ash"
import "scripts/Helix Fossil/Helix Fossil Interface.ash"


int __setting_cubes_to_farm = 10;

void main()
{
	if (get_property("valueOfAdventure") >= 5000) return;
	if (get_property("__turns_spent_farming_sugar_cubes").to_int() >= __setting_cubes_to_farm)
		return;
	if (!get_property("_sleazeAirportToday").to_boolean() && !get_property("sleazeAirportAlways").to_boolean())
		return;
	
	cli_execute("familiar fancypants scarecrow");
	cli_execute("maximize item +equip pantsgiving +equip navel ring of navel gazing");
	cli_execute("equip familiar spangly mariachi pants");
	//SGEEA:
//	if ($effect[on the trail].have_effect() > 0 && get_property("olfactedMonster").to_monster() != $monster[Sloppy Seconds Sundae])
	
	HelixResetSettings();
	__helix_settings.monsters_to_olfact = $monsters[Sloppy Seconds Sundae];
	__helix_settings.monsters_to_run_away_from = $monsters[Sloppy Seconds Cocktail,Sloppy Seconds Burger];
	__helix_settings.always_run_away_from_navel = true;
	HelixWriteSettings();
	
	farmingLogTrackItemsFromArea($location[sloppy seconds diner]);
	farmingLogStart();
	int last_turncount = my_turncount();
	while (my_adventures() > 0 && get_property("__turns_spent_farming_sugar_cubes").to_int() < __setting_cubes_to_farm)
	{
		farmingLogTurn();
		if (get_property("_sloppyDinerBeachBucks").to_int() < 4)
		{
			set_property("choiceAdventure919", 1);
		}
		else
			set_property("choiceAdventure919", 6);
		adv1($location[sloppy seconds diner]);
		
		if (my_turncount() != last_turncount)
			set_property("__turns_spent_farming_sugar_cubes", get_property("__turns_spent_farming_sugar_cubes").to_int() + 1);
		last_turncount = my_turncount();
	}
	farmingLogEnd();
	
	
	
	
	int [item] items_gained = farmingLogItemsGained();
	print("items_gained = " + items_gained.to_json());
	if (items_gained[$item[possessed sugar cube]] > 0 && false)
		cli_execute("mallsell " + items_gained[$item[possessed sugar cube]] + " possessed sugar cube @ " + MAX(10000, $item[possessed sugar cube].mall_price()));
	HelixResetSettings();
	HelixWriteSettings();
}