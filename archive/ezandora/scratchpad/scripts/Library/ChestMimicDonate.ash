import "scripts/Helix Fossil/Helix Fossil Interface.ash"

boolean [monster] __blocked_monsters = $monsters[cursed villager, Source Agent,quadfaerie,barrow wraith?];

Record DNABankMonster
{
	monster m;
	boolean unlocked;
	int samples_left;
};

DNABankMonster [monster] DNABankParseChoicePageText(string page_text)
{
	DNABankMonster [monster] results;
	string [int][int] matches = page_text.group_string("(<option.*?</option>)");
	foreach key in matches
	{
		string text = matches[key][1];
		
		string monster_id_string = text.group_string("value=\"([0-9]+)\"")[0][1];
		if (monster_id_string == "") continue;
		monster m = monster_id_string.to_int().to_monster();
		int samples_left = 0;
		if (text.contains_text("samples required"))
		{
			samples_left = text.group_string("\\(([0-9]+) samples required")[0][1].to_int();
		}
		else if (text.contains_text("sample required"))
		{
			samples_left = text.group_string("\\(([0-9]+) sample required")[0][1].to_int();
		}
		//print_html(text.entity_encode());
		//print_html(m + ": " + samples_left);
		
		DNABankMonster bank_monster;
		bank_monster.m = m;
		bank_monster.samples_left = samples_left;
		if (samples_left <= 0) //maybe check for "disabled"?
			bank_monster.unlocked = true;
		results[bank_monster.m] = bank_monster;
		
	}
	return results;
}

void donateEggs()
{
	if (get_property("_mimicEggsDonated").to_int() >= 3) return;
	if ($item[mimic egg].available_amount() == 0) return;
	
	//visit DNA bank:
	cli_execute("familiar chest mimic");
	//parse and donate:
	int breakout = 12;
	buffer dna_bank_page_text = visit_url("place.php?whichplace=town_right&action=townright_dna", false, false);
	while (breakout > 0)
	{
		breakout -= 1;
		if (!dna_bank_page_text.contains_text("Donate the egg of "))
		{
			break;
		}
		
		//print_html("dna_bank_page_text = " + dna_bank_page_text.entity_encode());
		string subtext = dna_bank_page_text.replace_string("\n"," ").replace_string("\r", " ").group_string("Donate the egg of(.*?)</form>")[0][1];
		if (subtext == 0) break;
		//print_html("subtext = " + subtext.entity_encode());
		
		string [int][int] submatches = subtext.group_string("value=\"([0-9]+)\"");
		if (submatches.count() == 0) break;
		int submatch = submatches[0][1].to_int();
		//print_html("submatch = " + submatch);
		
		set_property("_ezandoraMimicEggsDonated", get_property("_ezandoraMimicEggsDonated").to_int() + 1);
		print("Donating egg for " + submatch.to_int().to_monster().to_string()); //ye guilty
		dna_bank_page_text = visit_url("choice.php?whichchoice=1517&option=1&mid=" + submatch);
	}
	cli_execute("refresh inventory");
}


void runFreeFights()
{
	HelixResetSettings();
	HelixWriteSettings();
	cli_execute("familiar chest mimic");
	cli_execute("maximize familiar experience -tie");
	cli_execute("gain familiar experience 500 maxmeatspent limited");
	if (!get_property("_defectiveTokenUsed").to_boolean() && $item[defective game grid token].available_amount() > 0 && $effect[Video... Games?].have_effect() == 0)
		use(1, $item[defective game grid token]);
	while ($familiar[chest mimic].experience < 150)
	{
		location target_location = $location[none];
		
		if (get_property("snojoAvailable").to_boolean() && get_property("_snojoFreeFights").to_int() < 10)
		{
			target_location = $location[The X-32-F Combat Training Snowman];
		}
		else if (get_property("ownsSpeakeasy").to_boolean() && get_property("_speakeasyFreeFights").to_int() < 3) //oliver's place
		{
			target_location = $location[An Unusually Quiet Barroom Brawl];
		}
		//snojo, neverending...
		
		if (target_location == $location[none])
			break;
		adv1(target_location);
	}
}

void main()
{
	donateEggs();
	if (get_property("_ezandoraMimicEggsDonated").to_int() >= 3) return;
	if (get_property("_mimicEggsDonated").to_int() >= 3) return;
	boolean [monster] monsters_to_target_first = $monsters[Astronomer,batwinged gremlin (tool),beanbat,big swarm of ghuol whelps,Black Crayon Beast,Black Crayon Beetle,Black Crayon Constellation,Black Crayon Crimbo Elf,Black Crayon Demon,Black Crayon Elemental,Black Crayon Fish,Black Crayon Flower,Black Crayon Frat Orc,Black Crayon Goblin,Black Crayon Golem,Black Crayon Hippy,Black Crayon Hobo,Black Crayon Man,Black Crayon Manloid,Black Crayon Mer-kin,Black Crayon Penguin,Black Crayon Pirate,Black Crayon Shambling Monstrosity,Black Crayon Slime,Black Crayon Spiraling Shape,Black Crayon Undead Thing,blur,Bob Racecar,Bram the Stoker,Camel's Toe,dairy goat,dense liana,dirty old lihc,erudite gremlin (tool),forest spirit,giant swarm of ghuol whelps,Green Ops Soldier,Knight in White Satin,Knob Goblin Harem Girl,lynyrd skinner,modern zmobie,oil cartel,pygmy bowler,pygmy janitor,pygmy witch accountant,Racecar Bob,red butler,screambat,Skinflute,spider gremlin (tool),swarm of ghuol whelps,vegetable gremlin (tool),War Frat Mobile Grill Unit,white lion,whitesnake,Witchess King,Witchess Queen,Witchess Witch]; //'
	
	if ($item[combat lover's locket].available_amount() == 0) return; //'
	if (!$familiar[chest mimic].have_familiar()) return;
	if (my_adventures() == 0) return;
	
	string [int] locket_monsters_fought = get_property("_locketMonstersFought").split_string(",");
	
	if (locket_monsters_fought.count() >= 3)
	{
		print("ChestMimicDonate.ash: Can't use combat lover's locket to donate chest mimic eggs");
		return;
	}
	
	
	cli_execute("familiar chest mimic");
	if ($familiar[chest mimic].experience < 150)
	{
		runFreeFights();
		if ($familiar[chest mimic].experience < 150)
		abort("get chest mimic experience (currently at " + $familiar[chest mimic].experience + ")");
	}
	
	
	buffer dna_bank_page_text = visit_url("place.php?whichplace=town_right&action=townright_dna", false, false);
	DNABankMonster [monster] bank_monsters = DNABankParseChoicePageText(dna_bank_page_text);
	if (bank_monsters.count() == 0) return;
	
	boolean [monster] monsters_already_contributed;
	int breakout = 3;
	while (breakout > 0 && get_property("_mimicEggsDonated").to_int() < 3 && get_property("_locketMonstersFought").split_string(",").count() < 3)
	{
		breakout -= 1;
	
		boolean [monster] locket_monsters = get_locket_monsters();
	
	
		monster chosen_monster = $monster[none];
		if (true)
		{
			float [monster] monster_scores;
		
			//Generate monster scores and spare DNA bank monsters:
			foreach m in locket_monsters
			{
				if (__blocked_monsters contains m) continue; //cannot egg these
				DNABankMonster bank_monster;
				if (bank_monsters contains m)
				{
					bank_monster = bank_monsters[m];
				}
				else
				{
					bank_monster.m = m;
					bank_monster.samples_left = 100;
					bank_monster.unlocked = false;
					bank_monsters[m] = bank_monster;
				}
			
				if (bank_monster.unlocked) continue;
			
			
				//Generate score (higher is worse)
				float score = bank_monster.samples_left;
				if (monsters_to_target_first[m])
				{
					score -= 200;
				}
				//Slightly prefer non-wishable monsters, since they're more difficult to access.
				if (!m.wishable)
				{
					score -= 10;
				}
				score += m.id / 1000.0; //very tiny adjustment; very slightly prefer older monsters
			
				monster_scores[m] = score;
			}
			foreach m in locket_monsters	
			{
				DNABankMonster bank_monster = bank_monsters[m];
				if (monsters_already_contributed[m]) continue;
				if (__blocked_monsters contains m) continue;
				if (bank_monster.unlocked) continue;
				if (chosen_monster == $monster[none] || monster_scores[chosen_monster] > monster_scores[m])
					chosen_monster = m;
			}
		}
		else
		{
			//first attempt:
			DNABankMonster chosen_target;
			foreach m, bank_monster in bank_monsters
			{
				if (bank_monster.unlocked) continue;
				if (!locket_monsters[bank_monster.m]) continue;
		
			
				if (chosen_target.m == $monster[none] || chosen_target.samples_left > bank_monster.samples_left)
				{
					chosen_target = bank_monster;
				}
				if (monsters_to_target_first[bank_monster.m])
				{
					//this, and no other:
					chosen_target = bank_monster;
					break;
				}
			}
			chosen_monster = chosen_target.m;
		}
		if (chosen_monster == $monster[none])
		{
			print("ChestMimicDonate.ash: No monsters we can donate; collect more monsters in your locket.");
			break;
		}
		print("ChestMimicDonate.ash: Chosen target: " + chosen_monster + " with " + bank_monsters[chosen_monster].samples_left + " samples left");
		//abort("Well?");
	
	
		int samples_to_collect = 3 - get_property("_mimicEggsDonated").to_int();
		samples_to_collect = MIN($familiar[chest mimic].experience / 50, samples_to_collect);
		
		
		if (samples_to_collect <= 0 || samples_to_collect > 3) break;
		
		//abort("ChestMimicDonate.ash: double check - does " + chosen_monster + " need chest mimic donating?");
		if (bank_monsters[chosen_monster].samples_left > 0)
		{
			samples_to_collect = MAX(1, MIN(samples_to_collect, bank_monsters[chosen_monster].samples_left));
		}
	
		HelixResetSettings();
		for i from 1 to samples_to_collect
		{
			__helix_settings.skills_to_cast.listAppend($skill[%fn\, lay an egg]);
		}
		HelixWriteSettings();
		
		visit_url("main.php"); //mafia doesn't know about the DNA bank yet
		//Reminisce:
		monsters_already_contributed[chosen_monster] = true;
		cli_execute("reminisce " + chosen_monster);
		run_combat();
		
		HelixResetSettings();
		HelixWriteSettings();
		
		donateEggs();
	}
	
	HelixResetSettings();
	HelixWriteSettings();
}