import "relay/Guide/Support/LocationAvailable.ash";

//string __setting_datafile_name = "ezandora_spading_invisible_ties_data.txt";
string __setting_datafile_name = "ezandora_spading_invisibly_ripped_data.txt";


boolean [string] __location_parentdesc_whitelist {"Nearby Plains":true,"Bat Hole":true,"Big Mountains":true,"Mysterious Island":true,"Above the Beanstalk":true,"Distant Woods":true,"Spookyraven Manor":true,"Cobb's Knob":true, "Desert Beach":true,"Pandamonium":true,"Seaside Town":true};

boolean [string] __location_parentdesc_blacklist {"Elemental International Airport":true,"Memories":true,"Clan Basement":true,"Holiday Zones":true,"Batfellow Area":true,"Removed Areas":true};

boolean [location] __location_blacklist = $locations[the daily dungeon];

//{"Signed Zones":true,"Secret Tropical Island Volcano Lair":true,"The Sea":true,"El Vibrato Island":true,"Island War Quest":true,"Astral Plane":true,"No Category":true,"Worm Wood":true,"Antique Maps":true,"Item-Driven Zones":true,"Deep Fat Friar's":true,"The Suburbs of Dis":true,"Psychoses":true,"Events":true,"Little Canadia":true,"The Bugbear Mothership":true}

void adventureInLocation(location chosen_location)
{
	if (total_turns_played() % 37 == 0 && !(get_property("lastLightsOutTurn").to_int() >= total_turns_played()))
		abort("spookyraven!");
	foreach s in $skills[Carlweather's Cantata of Confrontation, musk of the moose] //'
	{
		if (s.have_skill() && s.to_effect().have_effect() == 0)
			cli_execute("cast " + s);
	}
	boolean success = false;
	try
	{
		adv1(chosen_location, 0, "");
		success = true;
		if ($monsters[animated mahogany nightstand, animated ornate nightstand, animated rustic nightstand, elegant animated nightstand, Wardr&ouml;b nightstand] contains last_monster())
		{
			visit_url("choice.php");
			run_turn();
		}
	}
	finally
	{
	}
	
	if (!success)
		return;
		
	int [monster] monsters_encountered;
	file_to_map(__setting_datafile_name, monsters_encountered);
	
	monster last_monster = get_property("lastEncounter").to_monster();
	if (last_monster == $monster[none])
		last_monster = get_property("lastEncounter").replace_string("the ", "").replace_string("The ", "").to_monster(); //the cabinet of Dr. Limpieza
	if ($monsters[ancestral Spookyraven portrait] contains last_monster() || !(monsters_encountered contains last_monster())) //honestly? just do this
	{
		print("FIXME SPADING INVISIBLE TIES problems with " + last_monster(), "red");
		last_monster = last_monster();
	}
	if (last_monster == $monster[none])
	{
		print_html("<font color=\"red\">Not a monster.</font>");
		return;
	}
	
	cli_execute("refresh inventory");
	if (to_item("invisible seam ripper").available_amount() > 0)
	{
		abort("FOUND IT against " + last_monster);
	}
	
	int [monster] monsters_encountered;
	file_to_map(__setting_datafile_name, monsters_encountered);
	monsters_encountered[last_monster] += 1;
	map_to_file(monsters_encountered, __setting_datafile_name);
}

void main()
{
	cli_execute("refresh inventory");
	if (to_item("invisible seam ripper").available_amount() > 0)
	{
		abort("You have it!");
		return;
	}

	cli_execute("familiar trick-or-treating tot; unequip familiar");
	cli_execute("maximise combat rate -tie +equip talisman o' namsilat +equip pirate fledges +equip pantsgiving -familiar");
	//FIXME support things like the secret government lab, although it's improbable that it's there, and the palindome/pirates areas
	location [monster][int] locations_for_monster;
	monster [int] monsters;
	
	boolean [location] locations_allowed;
	
	foreach l in $locations[]
	{
		if (!l.locationAvailable())
			continue;
		if (__location_blacklist contains l)
			continue;
		if (__location_parentdesc_blacklist contains l.parentdesc)
			continue;
		boolean whitelisted = false;
		if (__location_parentdesc_whitelist contains l.parentdesc)
			whitelisted = true;
		if (whitelisted)
			locations_allowed[l] = true;
		foreach m, rate in l.appearance_rates()
		{
			if (rate <= 0.0) continue;
			if (m == $monster[none]) continue;
			
			if (!(locations_for_monster contains m))
			{
				location [int] blank;
				locations_for_monster[m] = blank;
			}
			locations_for_monster[m][locations_for_monster[m].count()] = l;
			monsters[monsters.count()] = m;
		}
	}
	
	
	if (false)
	{
		location [int] built_locations;
		foreach key in locations_for_monster
		{
			foreach key2 in locations_for_monster[key]
			{
				built_locations[built_locations.count()] = locations_for_monster[key][key2];
			}
		}
		boolean [string] parentdesc;
		foreach key, l in built_locations
		{
			if (locations_allowed[l]) continue;
			parentdesc[l.parentdesc] = true;
			print_html(l + ": " + l.parentdesc);
		}
		print_html("parentdesc = " + parentdesc.to_json());
		return;
	}
	/*int [monster] monsters_encountered;
	file_to_map(__setting_datafile_name, monsters_encountered);
	
	sort monsters by monsters_encountered[value];*/
	
	//print_html("locations_for_monster = " + locations_for_monster.to_json());
	//print_html("monsters = " + monsters.to_json());
	//return;

	/*location [int] eligible_locations;
	foreach l in $locations[]
	{
		if (l.parentdesc.contains_text("Spookyraven Manor"))
			eligible_locations[eligible_locations.count()] = l;
	}*/
	
	//print_html("monsters.count() = " + monsters.count());
	//return;
	int limit = 10;
	//$effect[invisible ties].have_effect() > 0 &&
	while (my_adventures() > 0 && $effect[invisibly ripped].have_effect() > 0 && limit > 0)
	{
		limit -= 1;
		//Pick monster:
		
		
		int [monster] monsters_encountered;
		file_to_map(__setting_datafile_name, monsters_encountered);
		sort monsters by monsters_encountered[value];
		
		monster [int] monster_list_picking_from;
		foreach key, m in monsters
		{
			if (monsters_encountered[m] != monsters_encountered[monsters[0]] && monsters_encountered[monsters[0]] == 0)
				break;
			monster_list_picking_from[monster_list_picking_from.count()] = m;
		}
		
		if ($effect[Ultrahydrated].have_effect() > 0)
		{
			monster [int] new_monster_list;
			foreach m in $monsters[blur,oasis monster,rolling stone,swarm of scarab beatles]
				new_monster_list[new_monster_list.count()] = m;
			
			monster_list_picking_from = new_monster_list;
		}
		
		print_html("Picking from " + monster_list_picking_from.count() + " monsters.");
		//print_html("monsters = " + monsters.to_json());
		//break;
		
		monster chosen_monster = monster_list_picking_from[random(monster_list_picking_from.count())];
		
		//testing against "the cabinet of Dr. Limpieza" silliness
		//chosen_monster = $monster[cabinet of Dr. Limpieza];
		location chosen_location;
		if (locations_for_monster[chosen_monster].count() == 1)
			chosen_location = locations_for_monster[chosen_monster][0]; //Random range must be at least 2 because FUCK you
		else
			chosen_location = locations_for_monster[chosen_monster][random(locations_for_monster[chosen_monster].count())];
		
		if (chosen_location == $location[the oasis] && $effect[ultrahydrated].have_effect() == 0)
		{
			print("Use a clover in the oasis; this isn't implemented because lazy.", "red");
			return;
		}
		print_html(chosen_monster + ": " + chosen_location);
		//location chosen_location = eligible_locations[random(eligible_locations.count())];
		adventureInLocation(chosen_location);
	}
}