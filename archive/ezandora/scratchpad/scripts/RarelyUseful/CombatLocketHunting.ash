
import "scripts/Helix Fossil/Helix Fossil Interface.ash"

boolean [monster] monstersInAreaNeedingLocket(location l, boolean [monster] locket_monsters)
{
	boolean [monster] results;
	foreach m, r in l.appearance_rates()
	{
		if (r <= 0.0 && l != $location[oil peak]) continue;
		if (!m.copyable) continue;
		if (locket_monsters[m]) continue;
		if (m.id <= 0) continue;
		
		results[m] = true;
	}
	return results;
}

boolean [monster] get_locket_monsters_full()
{
	boolean [monster] results = get_locket_monsters();
	
	foreach key, monster_id_string in get_property("_locketMonstersFought").split_string(",")
	{
		int monster_id = monster_id_string.to_int();
		monster m = monster_id.to_monster();
		if (m != $monster[none])
			results[m] = true;
	}
	return results;
}

void outputMonster(monster m, string prefix, string suffix)
{
	string line = prefix;
	line += "&nbsp;&nbsp;&nbsp;&nbsp;" + m;
	if (!m.wishable)
	{
		line += "*";
		
		//hobopolis hobos, plywood cultists, source agent:
		//if (!m.can_faxbot())
		//	line += "+";
	}
	line += suffix;
	print_html(line);
}

void main()
{
	boolean [monster] locket_monsters = get_locket_monsters_full();
	boolean [monster] monsters_outputted;
	boolean got_ready = false;
	
	boolean [monster] monsters_not_likely = $monsters[source agent];
	boolean skip_to_last = true;
	foreach l in $locations[]
	{
		if (skip_to_last && get_property("lastAdventure") == l)
			skip_to_last = false;
		if (l.root == "Removed") continue;
		if (l.root == "Antique Maps") continue; //do not waste these
		if (l.nocombats) continue;
		if (false && l.root != "Spaaace") continue;
		boolean [monster] relevant_monsters = monstersInAreaNeedingLocket(l, locket_monsters);
		
		if (relevant_monsters.count() == 0) continue;
		
		string prefix = "";
		string suffix = "";
		if (my_location() == l)
		{
			print_html("");
			print_html("---------------------------------------------------------------------------------------------------------------------------------------");
			prefix = "<b>";
			suffix = "</b>";
		}
		print_html(prefix + l + ": " + l.zone + "," + l.parent + "," + l.root + suffix);
		foreach m in relevant_monsters
		{
			if (monsters_not_likely[m]) continue;
			monsters_outputted[m] = true;
			outputMonster(m, prefix, suffix);
		}
		
		boolean [location] blocklist = $locations[Trick-or-Treating,The Velvet / Gold Mine,LavaCo&trade; Lamp Factory];
		boolean [location] problem_child = $locations[the haiku dungeon, The Clumsiness Grove,The Maelstrom of Lovers,The Glacier of Jerks]; //places where mafia parsing is disabled, due to weird text there
		if (false && !blocklist[l] && l.parent != "Antique Maps" && l.parent != "Psychoses" && l.parent != "Grimstone")
		{
			if (!got_ready)
			{
				cli_execute("maximize combat rate -tie -acc3 -acc2");
				equip($item[combat lover's locket], $slot[acc3]); //'
				equip($item[navel ring of navel gazing], $slot[acc2]);
				equip($item[mafia thumb ring], $slot[acc1]);
				got_ready = true;
			}
			//brute-force collection:
			if (l.parent == "Clan Basement") continue;
			print_html("Trying...");
			//abort(l);
			//int turns_before = total_turns_played();
			//boolean ignore = adv1(l);
			//int turns_after = total_turns_played();
			while (true)
			{
				if (skip_to_last)
				{
					break;
				}
				boolean [monster] area_monsters_needing_locket = monstersInAreaNeedingLocket(l, locket_monsters);
				if (area_monsters_needing_locket.count() == 0) break;
				print_html("Need monsters in locket: " + area_monsters_needing_locket.to_json());
				
				
				//navel run:
				HelixResetSettings();
				foreach key, m in l.get_monsters()
				{
					if (area_monsters_needing_locket[m]) continue;
					__helix_settings.monsters_to_run_away_from[m] = true;
				}
				HelixWriteSettings();
				
				if ($item[combat lover's locket].equipped_amount() == 0) //'
				{
					abort("equip the locket");
				}
				boolean success = adv1(l);
				if (!success) break;
				//Battlefield (Cloaca Uniform) returns true even during a failure, because...?
				if (get_property("lastAdventure").to_location() != l) break;
				
				if (problem_child[l])
				{
					visit_url("inventory.php?reminisce=1",false,false);
				}
				locket_monsters = get_locket_monsters_full();
			}
		}
	}
	print_html("Other:");
	foreach m in $monsters[]
	{
		if (!m.copyable) continue;
		if (locket_monsters[m]) continue;
		if (m.id <= 0) continue;
		if (monsters_outputted[m]) continue;
		if (monsters_not_likely[m]) continue;
		
		monsters_outputted[m] = true;
		outputMonster(m, "", "");
	}
	HelixResetSettings();
	HelixWriteSettings();
}