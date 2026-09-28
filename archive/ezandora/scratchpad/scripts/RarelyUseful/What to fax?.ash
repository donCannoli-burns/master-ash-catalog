boolean setting_always_search = false;

Record MonsterDropEntry
{
	monster m;
	float earnings;
	string route;
};

MonsterDropEntry MonsterDropEntryMake(monster m, float earnings, string earnings_route)
{
	MonsterDropEntry result;
	result.m = m;
	result.earnings = earnings;
	result.route = earnings_route;
	return result;
}

void listAppend(MonsterDropEntry [int] list, MonsterDropEntry entry)
{
	int position = count(list);
	while (list contains position)
		position = position + 1;
	list[position] = entry;
}

int item_price(item it)
{
	if (!it.is_tradeable())
		return 0.0;
	if (it.historical_age() > 30.0 || (setting_always_search && it.historical_price() > 10000))
		return it.mall_price();
	return it.historical_price();
}


float meatEarningsForMonster(monster m, float assumed_item_drop, float assumed_meat_drop)
{
	float monster_meat = m.meat_drop();
	
	float sum;
	
	sum += monster_meat * (assumed_meat_drop / 100.0 + 1.0);
	
	foreach it in m.item_drops()
	{
		int drop_rate = m.item_drops()[it];
		if (m == $monster[pygmy witch surgeon])
			drop_rate = 0.0;
		if (drop_rate == 0)
		{
			drop_rate = 20; //ASSUMPTION
		}
		float price = MAX(it.item_price(), it.autosell_price());
		
		float effective_drop_rate = MAX(0.0, MIN(1.0, (drop_rate.to_float() / 100.0) * (assumed_item_drop / 100.0 + 1.0)));
		//if (m == $monster[pygmy witch nurse])
			//print(it + ", " + drop_rate + ", " + price + ", " + effective_drop_rate);
		sum += effective_drop_rate * price;
	}
	return sum;
}



void main()
{
	boolean [monster] banned_monsters;
	banned_monsters["Neil".to_monster()] = true;
banned_monsters["Oscus".to_monster()] = true;
banned_monsters["Zombo".to_monster()] = true;
banned_monsters["Frosty".to_monster()] = true;
banned_monsters["Peanut".to_monster()] = true;
banned_monsters["Wumpus".to_monster()] = true;
banned_monsters["Chester".to_monster()] = true;
banned_monsters["The Man".to_monster()] = true;
banned_monsters["Boss Bat".to_monster()] = true;
banned_monsters["Moneybee".to_monster()] = true;
banned_monsters["The Nuge".to_monster()] = true;
banned_monsters["Vine gar".to_monster()] = true;
banned_monsters["Bee swarm".to_monster()] = true;
banned_monsters["Buzzerker".to_monster()] = true;
banned_monsters["Mumblebee".to_monster()] = true;
banned_monsters["Queen Bee".to_monster()] = true;
banned_monsters["Bee thoven".to_monster()] = true;
banned_monsters["Beelephant".to_monster()] = true;
banned_monsters["Bonerdagon".to_monster()] = true;
banned_monsters["Croqueteer".to_monster()] = true;
banned_monsters["Skulldozer".to_monster()] = true;
banned_monsters["Snapdragon".to_monster()] = true;
banned_monsters["The Server".to_monster()] = true;
banned_monsters["Tiger-lily".to_monster()] = true;
banned_monsters["Trophyfish".to_monster()] = true;
banned_monsters["Zim Merman".to_monster()] = true;
banned_monsters["Beebee King".to_monster()] = true;
banned_monsters["Caveman Dan".to_monster()] = true;
banned_monsters["Dr. Awkward".to_monster()] = true;
banned_monsters["Mayor Ghost".to_monster()] = true;
banned_monsters["Ol' Scratch".to_monster()] = true;
banned_monsters["Beebee queue".to_monster()] = true;
banned_monsters["Guard turtle".to_monster()] = true;
banned_monsters["Water cooler".to_monster()] = true;
banned_monsters["Book of Faces".to_monster()] = true;
banned_monsters["Carbuncle Top".to_monster()] = true;
banned_monsters["Crazy bastard".to_monster()] = true;
banned_monsters["Danglin' Chad".to_monster()] = true;
banned_monsters["Hermetic seal".to_monster()] = true;
banned_monsters["Mimic (Cloak)".to_monster()] = true;
banned_monsters["Novia Cadáver".to_monster()] = true;
banned_monsters["Novio Cadáver".to_monster()] = true;
banned_monsters["Padre Cadáver".to_monster()] = true;
banned_monsters["Tomb rat king".to_monster()] = true;
banned_monsters["Wasp in a wig".to_monster()] = true;
banned_monsters["X Stone Golem".to_monster()] = true;
banned_monsters["Beebee gunners".to_monster()] = true;
banned_monsters["Best Game Ever".to_monster()] = true;
banned_monsters["Broodling seal".to_monster()] = true;
banned_monsters["Count Drunkula".to_monster()] = true;
banned_monsters["Ed the Undying".to_monster()] = true;
banned_monsters["Essence of Soy".to_monster()] = true;
banned_monsters["Falls-From-Sky".to_monster()] = true;
banned_monsters["Giant sandworm".to_monster()] = true;
banned_monsters["Knott Slanding".to_monster()] = true;
banned_monsters["Moister oyster".to_monster()] = true;
banned_monsters["Spawn of Wally".to_monster()] = true;
banned_monsters["Stuffing Golem".to_monster()] = true;
banned_monsters["The Landscaper".to_monster()] = true;
banned_monsters["Tome of Tropes".to_monster()] = true;
banned_monsters["X-headed Hydra".to_monster()] = true;
banned_monsters["Bugbear Captain".to_monster()] = true;
banned_monsters["Chatty coworker".to_monster()] = true;
banned_monsters["Cyrus the Virus".to_monster()] = true;
banned_monsters["Essence of Tofu".to_monster()] = true;
banned_monsters["Fearsome Wacken".to_monster()] = true;
banned_monsters["Filthworm drone".to_monster()] = true;
banned_monsters["Queen filthworm".to_monster()] = true;
banned_monsters["Shadow opponent".to_monster()] = true;
banned_monsters["Spaghetti Demon".to_monster()] = true;
banned_monsters["Drunken rat king".to_monster()] = true;
banned_monsters["Guy Made Of Bees".to_monster()] = true;
banned_monsters["Knob Goblin King".to_monster()] = true;
banned_monsters["Larval filthworm".to_monster()] = true;
banned_monsters["Lord Spookyraven".to_monster()] = true;
banned_monsters["Smut orc pervert".to_monster()] = true;
banned_monsters["Vanya's Creature".to_monster()] = true;
banned_monsters["White Bone Demon".to_monster()] = true;
banned_monsters["Beast with X Ears".to_monster()] = true;
banned_monsters["Beast with X Eyes".to_monster()] = true;
banned_monsters["Candied Yam Golem".to_monster()] = true;
banned_monsters["Demon of New Wave".to_monster()] = true;
banned_monsters["Family of kobolds".to_monster()] = true;
banned_monsters["Naughty Sorceress".to_monster()] = true;
banned_monsters["Overflowing inbox".to_monster()] = true;
banned_monsters["Professor Jacking".to_monster()] = true;
banned_monsters["Protector Spectre".to_monster()] = true;
banned_monsters["War Frat Streaker".to_monster()] = true;
banned_monsters["All-Hallow's Steve".to_monster()] = true;
banned_monsters["Disorganized files".to_monster()] = true;
banned_monsters["Full-length mirror".to_monster()] = true;
banned_monsters["Goblin conspirator".to_monster()] = true;
banned_monsters["Hammered Yam Golem".to_monster()] = true;
banned_monsters["Hideous slide show".to_monster()] = true;
banned_monsters["Spider conspirator".to_monster()] = true;
banned_monsters["Spirit alarm clock".to_monster()] = true;
banned_monsters["The Big Wisniewski".to_monster()] = true;
banned_monsters["Apathetic lizardman".to_monster()] = true;
banned_monsters["Baron von Ratsworth".to_monster()] = true;
banned_monsters["Centurion of Sparky".to_monster()] = true;
banned_monsters["Giant bird-creature".to_monster()] = true;
banned_monsters["Inebriated Tofurkey".to_monster()] = true;
banned_monsters["Malevolent Tofurkey".to_monster()] = true;
banned_monsters["Slow Talkin' Elliot".to_monster()] = true;
banned_monsters["Tedious spreadsheet".to_monster()] = true;
banned_monsters["The Temporal Bandit".to_monster()] = true;
banned_monsters["Tin can conspirator".to_monster()] = true;
banned_monsters["BRICKO oyster (item)".to_monster()] = true;
banned_monsters["BRICKO python (item)".to_monster()] = true;
banned_monsters["BRICKO turtle (item)".to_monster()] = true;
banned_monsters["Bugbear robo-surgeon".to_monster()] = true;
banned_monsters["Rotten dolphin thief".to_monster()] = true;
banned_monsters["Unoptimized database".to_monster()] = true;
banned_monsters["Wu Tang the Betrayer".to_monster()] = true;
banned_monsters["X-dimensional horror".to_monster()] = true;
banned_monsters["BRICKO airship (item)".to_monster()] = true;
banned_monsters["BRICKO octopus (item)".to_monster()] = true;
banned_monsters["Filthworm royal guard".to_monster()] = true;
banned_monsters["Fnord the Unspeakable".to_monster()] = true;
banned_monsters["Glass of Orange Juice".to_monster()] = true;
banned_monsters["Great Wolf of the Air".to_monster()] = true;
banned_monsters["Naughty Sorceress (2)".to_monster()] = true;
banned_monsters["Naughty Sorceress (3)".to_monster()] = true;
banned_monsters["Soused Stuffing Golem".to_monster()] = true;
banned_monsters["Space beast matriarch".to_monster()] = true;
banned_monsters["Unearthed monstrosity".to_monster()] = true;
banned_monsters["BRICKO elephant (item)".to_monster()] = true;
banned_monsters["Carnivorous dill plant".to_monster()] = true;
banned_monsters["Tin spider conspirator".to_monster()] = true;
banned_monsters["Black pudding (monster)".to_monster()] = true;
banned_monsters["BRICKO cathedral (item)".to_monster()] = true;
banned_monsters["Endless conference call".to_monster()] = true;
banned_monsters["Little blob of gray goo".to_monster()] = true;
banned_monsters["Mayor Ghost (Hard Mode)".to_monster()] = true;
banned_monsters["The Sierpinski brothers".to_monster()] = true;
banned_monsters["The Unkillable Skeleton".to_monster()] = true;
banned_monsters["Totally Malicious 'Zine".to_monster()] = true;
banned_monsters["Hodgman, The Hoboverlord".to_monster()] = true;
banned_monsters["Largish blob of gray goo".to_monster()] = true;
banned_monsters["Next-generation Frat Boy".to_monster()] = true;
banned_monsters["Persona Inocente Cadáver".to_monster()] = true;
banned_monsters["The Clownlord Beelzebozo".to_monster()] = true;
banned_monsters["Canned goblin conspirator".to_monster()] = true;
banned_monsters["Enormous blob of gray goo".to_monster()] = true;
banned_monsters["Pooltergeist (Ultra-Rare)".to_monster()] = true;
banned_monsters["Spider-goblin conspirator".to_monster()] = true;
banned_monsters["The Crimbomination (2008)".to_monster()] = true;
banned_monsters["The Crimbomination (2009)".to_monster()] = true;
banned_monsters["Brutus, the toga-clad lout".to_monster()] = true;
banned_monsters["Count Drunkula (Hard Mode)".to_monster()] = true;
banned_monsters["Falls-From-Sky (Hard Mode)".to_monster()] = true;
banned_monsters["Larry of the Field of Signs".to_monster()] = true;
banned_monsters["Monty Basingstoke-Pratt, IV".to_monster()] = true;
banned_monsters["Category: Combat Adventures".to_monster()] = true;
banned_monsters["BRICKO vacuum cleaner (item)".to_monster()] = true;
banned_monsters["C.A.R.N.I.V.O.R.E. Operative".to_monster()] = true;
banned_monsters["Lumpy, the Demonic Sauceblob".to_monster()] = true;
banned_monsters["X Bottles of Beer on a Golem".to_monster()] = true;
banned_monsters["Ghostly pickle factory worker".to_monster()] = true;
banned_monsters["Gorgolok, the Demonic Hellseal".to_monster()] = true;
banned_monsters["Somerset Lopez, Demon Mariachi".to_monster()] = true;
banned_monsters["Zombie Homeowners' Association".to_monster()] = true;
banned_monsters["Essence of Interspecies Respect".to_monster()] = true;
banned_monsters["BRICKO gargantuchicken (monster)".to_monster()] = true;
banned_monsters["Guy Made Of Bees (Bees Hate You)".to_monster()] = true;
banned_monsters["Plastered Can of Cranberry Sauce".to_monster()] = true;
banned_monsters["Possessed Can of Cranberry Sauce".to_monster()] = true;
banned_monsters["Great Wolf of the Air (Hard Mode)".to_monster()] = true;
banned_monsters["Victor the Insult Comic Hellhound".to_monster()] = true;
banned_monsters["Ghost of Fernswarthy's Grandfather".to_monster()] = true;
banned_monsters["Spirit of New Wave (Inner Sanctum)".to_monster()] = true;
banned_monsters["Spirit of New Wave (Volcanic Cave)".to_monster()] = true;
banned_monsters["Stella, the Demonic Turtle Poacher".to_monster()] = true;
banned_monsters["Spaghetti Elemental (Inner Sanctum)".to_monster()] = true;
banned_monsters["Spaghetti Elemental (Volcanic Cave)".to_monster()] = true;
banned_monsters["The Unkillable Skeleton (Hard Mode)".to_monster()] = true;
banned_monsters["Skelter Butleton, the Butler Skeleton".to_monster()] = true;
banned_monsters["Spirit of New Wave (The Nemesis' Lair)".to_monster()] = true;
banned_monsters["Frank \"Skipper\" Dan, the Accordion Lord".to_monster()] = true;
banned_monsters["Spaghetti Elemental (The Nemesis' Lair)".to_monster()] = true;
banned_monsters["Felonia, Queen of the Spooky Gravy Fairies".to_monster()] = true;
banned_monsters["Stella, the Turtle Poacher (Inner Sanctum)".to_monster()] = true;
banned_monsters["Stella, the Turtle Poacher (Volcanic Cave)".to_monster()] = true;
banned_monsters["Zombie Homeowners' Association (Hard Mode)".to_monster()] = true;
banned_monsters["Gorgolok, the Infernal Seal (Inner Sanctum)".to_monster()] = true;
banned_monsters["Gorgolok, the Infernal Seal (Volcanic Cave)".to_monster()] = true;
banned_monsters["Lumpy, the Sinister Sauceblob (Inner Sanctum)".to_monster()] = true;
banned_monsters["Lumpy, the Sinister Sauceblob (Volcanic Cave)".to_monster()] = true;
banned_monsters["Somerset Lopez, Dread Mariachi (Inner Sanctum)".to_monster()] = true;
banned_monsters["Somerset Lopez, Dread Mariachi (Volcanic Cave)".to_monster()] = true;
banned_monsters["Stella, the Turtle Poacher (The Nemesis' Lair)".to_monster()] = true;
banned_monsters["Gorgolok, the Infernal Seal (The Nemesis' Lair)".to_monster()] = true;
banned_monsters["Lumpy, the Sinister Sauceblob (The Nemesis' Lair)".to_monster()] = true;
banned_monsters["Somerset Lopez, Dread Mariachi (The Nemesis' Lair)".to_monster()] = true;
	float assumed_item_drop = 400.0;
	float assumed_meat_drop = 800.0;
	
	if (true)
	{
		print("Options:");
		foreach l in $locations[]
		{
			if (l.zone == "Events" || l.zone.contains_text("Crimbo"))
				continue;
			float [monster] appearance_rates = l.appearance_rates();
			
			float item_drop_route_total_earnings;
			float meat_drop_route_total_earnings;
			
			float highest_item_drop_route_earnings;
			monster hitdre_monster;
			float highest_meat_drop_route_earnings;
			monster hmtdre_monster;
			foreach m in appearance_rates
			{
				float item_drop_route_earnings = m.meatEarningsForMonster(assumed_item_drop, 200.0);
				float meat_drop_route_earnings = m.meatEarningsForMonster(100.0, assumed_meat_drop);
				
				float rate = MAX(0.0, MIN(1.0, appearance_rates[m] / 100.0));
				
				item_drop_route_total_earnings += rate * item_drop_route_earnings;
				meat_drop_route_total_earnings += rate * meat_drop_route_earnings;
				
				if (!m.boss && rate > 0.0)
				{
					if (item_drop_route_earnings > highest_item_drop_route_earnings)
					{
						highest_item_drop_route_earnings = item_drop_route_earnings;
						hitdre_monster = m;
					}
					if (meat_drop_route_earnings > highest_meat_drop_route_earnings)
					{
						highest_meat_drop_route_earnings = meat_drop_route_earnings;
						hmtdre_monster = m;
					}
				}
			}
			
			string tab_characters = "&nbsp;&nbsp;&nbsp;&nbsp;";
			
			float cutoff = 1500.0;
			if (item_drop_route_total_earnings < cutoff && meat_drop_route_total_earnings < cutoff && highest_item_drop_route_earnings < cutoff && highest_meat_drop_route_earnings < cutoff)
				continue;
			
			if (item_drop_route_total_earnings > 0 || meat_drop_route_total_earnings > 0 || highest_item_drop_route_earnings > 0 || highest_meat_drop_route_earnings > 0)
				print(l);
			if (item_drop_route_total_earnings > 0 || meat_drop_route_total_earnings > 0)
			{
				if (item_drop_route_total_earnings > meat_drop_route_total_earnings)
				{
					print(tab_characters + item_drop_route_total_earnings + " for item route.");
				}
				else
					print(tab_characters + meat_drop_route_total_earnings + " for meat route.");
			}
			
			if (highest_item_drop_route_earnings > 0 || highest_meat_drop_route_earnings > 0)
			{
				if (highest_item_drop_route_earnings > highest_meat_drop_route_earnings)
				{
					print(tab_characters + highest_item_drop_route_earnings + " for single-target (" + hitdre_monster + ") item route.");
				}
				else
					print(tab_characters + highest_meat_drop_route_earnings + " for single-target (" + hmtdre_monster + ") meat route.");
			}
			
			/*float [location] adding;
			adding[l] = MAX(item_drop_route_total_earnings, meat_drop_route_total_earnings);
			per_location_profit[per_location_profit.count()] = adding;
			
			float [location] adding2;
			adding2[l] = MAX(highest_item_drop_route_earnings, highest_meat_drop_route_earnings);
			per_location_single_profit[per_location_profit.count()] = adding2;*/
		}
		
	}
	else
	{
		MonsterDropEntry [int] monster_drop_earnings;
		foreach m in $monsters[]
		{
			if (banned_monsters contains m)
				continue;
			float item_drop_route_earnings = m.meatEarningsForMonster(assumed_item_drop, 200.0);
			float meat_drop_route_earnings = m.meatEarningsForMonster(100.0, assumed_meat_drop);
		
			float efficient_route_earnings = item_drop_route_earnings;
			string route_text = "item";
			if (meat_drop_route_earnings > efficient_route_earnings)
			{
				efficient_route_earnings = meat_drop_route_earnings;
				route_text = "meat";
			}
			if (efficient_route_earnings == 0.0)
				continue;
			if (m.boss)
				continue;
			
			MonsterDropEntry entry = MonsterDropEntryMake(m, efficient_route_earnings, route_text);
			monster_drop_earnings.listAppend(entry);
		}
		//return;
		sort monster_drop_earnings by value.earnings;
		foreach key in monster_drop_earnings
		{
			MonsterDropEntry entry = monster_drop_earnings[key];
			print(entry.m + " for " + entry.earnings + " meat by running " + entry.route);
		
		}
	}
}