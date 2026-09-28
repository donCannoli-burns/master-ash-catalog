import "scripts/Library/ArchiveEquipment.ash";
import "scripts/Helix Fossil/Helix Fossil Interface.ash";

void unlockDungeonOfDoom()
{
	int breakout = 50;
	while (my_adventures() > 0 && breakout > 0)
	{
		breakout -= 1;
		if (to_int(get_property("lastPlusSignUnlock")) == my_ascensions())
		{
			if ($item[plus sign].available_amount() > 0)
			{
				use(1, $item[plus sign]);
			}
			if ($effect[teleportitis].have_effect() > 0)
				cli_execute("uneffect teleportitis");
			return;
		}
		if ($item[plus sign].available_amount() == 0)
		{
			set_property("choiceAdventure451", 3);
			cli_execute("maximize -combat -tie");
			cli_execute("gain -35 combat 500 spendperturn");
			adventure(1, $location[The Enormous Greater-Than Sign]);
		}
		else
		{
			if (my_meat() < 1000)
			{
				abort("get 1000 meat");
				return;
			}
			
			if ($effect[teleportitis].have_effect() == 0)
			{
				if ($skill[Calculate the Universe].have_skill() && get_property("_universeCalculated").to_int() < get_property("skillLevel144").to_int() && reverse_numberology() contains 58)
				{
					cli_execute("numberology 58");
				}
				else
				{
					set_property("choiceAdventure451", 5);
					cli_execute("maximize -combat -tie");
					cli_execute("gain -35 combat 500 spendperturn");
					adventure(1, $location[The Enormous Greater-Than Sign]);
				}
			}
			else
			{
				set_property("choiceAdventure3", 3);
				
				//some areas have weird fighting (cyberrealm)
				if ($item[navel ring of navel gazing].available_amount() > 0)
					equip($item[navel ring of navel gazing], $slot[acc3]);
				__helix_settings.actions_to_execute.listAppend("runaway; repeat;");
				HelixWriteSettings();
				adventure(1, $location[The Enormous Greater-Than Sign]);
			}
		}
	}
}

void collectZapWandCore()
{
	if (to_int(get_property("lastZapperWand")) == my_ascensions())
	{
		return;
	}
	if (to_int(get_property("lastPlusSignUnlock")) < my_ascensions())// && $item[plus sign].available_amount() == 0)
	{
		unlockDungeonOfDoom();
	}
	if (to_int(get_property("lastPlusSignUnlock")) != my_ascensions())
		return;
	
	int explosion_day = get_property("lastZapperWandExplosionDay").to_int();
	if (get_property("lastZapperWand").to_int() == my_ascensions() && explosion_day > 0 && my_daycount() - explosion_day > 0)
	{
		print("Can't collect wand yet, explosion too recent.", "red");
		return;
	}
	int breakout = 50;
	while (breakout > 0 && my_adventures() > 0 && $item[aluminum wand].available_amount() == 0 && $item[ebony wand].available_amount() == 0 && $item[hexagonal wand].available_amount() == 0 && $item[marble wand].available_amount() == 0 && $item[pine wand].available_amount() == 0)
	{
		breakout -= 1;
		if ($item[dead mimic].available_amount() > 0)
		{
			use(1, $item[dead mimic]);
			return;
		}
		if (my_meat() < 5000)
		{
			abort("get 5k meat");
			return;
		}
		set_property("choiceAdventure25", 2);
		cli_execute("maximize -combat -tie");
		cli_execute("gain -35 combat 500 spendperturn");
		adventure(1, $location[The Dungeons of Doom]);
		
	}
}

void main()
{
	ArchivedEquipment saved_equipment = ArchiveEquipment();
	collectZapWandCore();
	RestoreArchivedEquipment(saved_equipment);
	
	HelixResetSettings();
	HelixWriteSettings();
}