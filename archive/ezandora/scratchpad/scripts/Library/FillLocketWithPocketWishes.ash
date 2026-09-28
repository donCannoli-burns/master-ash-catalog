import "relay/Guide/Support/Library.ash"

void main()
{
	if ($item[combat lover's locket].available_amount() == 0) return; //'
	int breakout = 4;
	boolean [int] banned_monster_ids = $ints[-43, -42, -41, -40, 0, 995, 549,1202,1192,547,1194,397,398,553,906,945,1360,1187,1205,1196,1188,1198,1746,1852,1191, 1197, 1195,1994,1940,1998,2001,2004].makeConstantIntArrayMutable();
	
	foreach key, monster_string in get_property("_locketMonstersFought").split_string(",")
	{
		int monster_id = monster_string.to_int();
		banned_monster_ids[monster_id] = true;
	}
	boolean [monster] banned_monsters = $monsters[bizarre construct (translated), clingy pirate (female), Elf Hobo,exercise robot, hulking construct (translated),industrious construct (translated),lonely construct (translated), intelligent alien,menacing construct (translated), possessed wine rack (obsolete),amateur ninja,animated nightstand (mahogany combat), animated nightstand (mahogany noncombat),animated nightstand (white combat), animated nightstand (white noncombat), Bram the Stoker,redhat hacker,greenhat hacker,greyhat hacker,firewall,ice barrier,parental controls, null container,zombie process,botfly,network worm,ice man,rat (remote access trojan),purplehat hacker,bluehat hacker,corruption quarantine];
	//,towering construct (translated)
	
	monster [int] monsters_sorted;
	foreach m in $monsters[]
	{
		monsters_sorted[monsters_sorted.count()] = m;
	}
	sort monsters_sorted by value.id;
	while (get_property("_genieFightsUsed").to_int() < 3 && breakout > 0)
	{
		breakout -= 1;
		boolean [monster] locket_monsters = get_locket_monsters();
		monster target_monster = $monster[none];
		if (target_monster == $monster[none])
		{
			//Factoidless monsters, can't RM:
			cli_execute("call scripts/Library/LoadMonsterManuel.ash");
			foreach key, m in monsters_sorted
			{
				if (!m.copyable || !m.wishable || locket_monsters[m]) continue;
				if (banned_monster_ids[m.id] || banned_monsters[m]) continue;
				if (m.id <= 0) continue;
				if (monster_factoids_available(m, true) == 0)
				{
					target_monster = m;
					break;
				}
			}
		}
		if (target_monster == $monster[none])
		{
			int monsters_left = 0;
			foreach key, m in monsters_sorted
			{
				if (!m.copyable || !m.wishable || locket_monsters[m]) continue;
				if (banned_monster_ids[m.id] || banned_monsters[m]) continue;
				if (m.id <= 0) continue;
				if (target_monster == $monster[none])
				{
					target_monster = m;
				}	
				monsters_left += 1;
			}
			print(monsters_left + " monsters left. ~" + ceil(to_float(monsters_left) / 6.0) + " days to finish.");
		}
		if (target_monster != $monster[none])
		{
			cli_execute("acquire pocket wish");
			if ($item[combat lover's locket].equipped_amount() == 0)
				equip($item[combat lover's locket], $slot[acc1]);
			print("FillLocketWithPocketWishes.ash: Picked " + target_monster.id + ": " + target_monster);
			boolean go_time = true; //user_confirm("Wish for " + target_monster + "?");
			if (go_time)
			{
				int previous_fight_value = get_property("_genieFightsUsed").to_int();
				cli_execute("genie monster " + target_monster.manuel_name);
				visit_url("main.php"); //run_combat is clueless otherwise
				run_combat();
				int current_fight_value = get_property("_genieFightsUsed").to_int();
				if (current_fight_value == previous_fight_value)
				{
					print("FillLocketWithPocketWishes.ash: " + target_monster + " (" + target_monster.id + ") is likely not wishable, update script.");
					return;
				}
				else if (get_locket_monsters().count() == locket_monsters.count())
				{
					print("didn't gain a locket monster, skip this one: " + target_monster + " (" + target_monster.id + ")");
					return;
				}
			}
			else
			{
				return;
			}
		}
		
	}
}