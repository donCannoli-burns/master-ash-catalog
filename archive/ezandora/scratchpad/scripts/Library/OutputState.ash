import "relay/Guide/Support/Library.ash";

boolean [string] __numeric_modifier_names = $strings[Familiar Weight,Monster Level,Combat Rate,Initiative,Experience,Item Drop,Meat Drop,Damage Absorption,Damage Reduction,Cold Resistance,Hot Resistance,Sleaze Resistance,Spooky Resistance,Stench Resistance,Mana Cost,Moxie,Moxie Percent,Muscle,Muscle Percent,Mysticality,Mysticality Percent,Maximum HP,Maximum HP Percent,Maximum MP,Maximum MP Percent,Weapon Damage,Ranged Damage,Spell Damage,Spell Damage Percent,Cold Damage,Hot Damage,Sleaze Damage,Spooky Damage,Stench Damage,Cold Spell Damage,Hot Spell Damage,Sleaze Spell Damage,Spooky Spell Damage,Stench Spell Damage,Underwater Combat Rate,Fumble,HP Regen Min,HP Regen Max,MP Regen Min,MP Regen Max,Adventures,Familiar Weight Percent,Weapon Damage Percent,Ranged Damage Percent,Stackable Mana Cost,Hobo Power,Base Resting HP,Resting HP Percent,Bonus Resting HP,Base Resting MP,Resting MP Percent,Bonus Resting MP,Critical Hit Percent,PvP Fights,Volleyball,Sombrero,Leprechaun,Fairy,Meat Drop Penalty,Hidden Familiar Weight,Item Drop Penalty,Initiative Penalty,Food Drop,Booze Drop,Hat Drop,Weapon Drop,Offhand Drop,Shirt Drop,Pants Drop,Accessory Drop,Volleyball Effectiveness,Sombrero Effectiveness,Leprechaun Effectiveness,Fairy Effectiveness,Familiar Weight Cap,Slime Resistance,Slime Hates It,Spell Critical Percent,Muscle Experience,Mysticality Experience,Moxie Experience,Effect Duration,Candy Drop,DB Combat Damage,Sombrero Bonus,Familiar Experience,Sporadic Meat Drop,Sporadic Item Drop,Meat Bonus,Pickpocket Chance,Combat Mana Cost,Muscle Experience Percent,Mysticality Experience Percent,Moxie Experience Percent,Minstrel Level,Muscle Limit,Mysticality Limit,Moxie Limit,Song Duration,Prismatic Damage,Smithsness,Supercold Resistance,Reduce Enemy Defense,Pool Skill,Surgeonosity];

void main(string identifier)
{
	string [string] state;
	state["my_turncount()"] = my_turncount();
	state["my_hp()"] = my_hp();
	state["my_mp()"] = my_mp();
	state["total_turns_played()"] = total_turns_played();
	state["my_familiar().to_int()"] = my_familiar().to_int();
	state["my_adventures()"] = my_adventures();
	state["my_meat()"] = my_meat();
	state["my_location()"] = my_location();
	state["my_location().turns_spent"] = my_location().turns_spent;
	state["my_location().combat_queue"] = my_location().combat_queue;
	state["my_location().noncombat_queue"] = my_location().noncombat_queue;
	state["my_ascensions()"] = my_ascensions();
	if (my_audience() != 0)
		state["my_audience()"] = my_audience();
	foreach s in $stats[]
	{
		state["my_basestat($stat[" + s + "])"] = my_basestat(s);
		state["my_buffedstat($stat[" + s + "])"] = my_buffedstat(s);
	}
	state["my_class()"] = my_class();
	if (my_companion().length() != 0) //???
		state["my_companion()"] = my_companion();
	state["my_daycount()"] = my_daycount();
	if (true)
	{
		int [effect] my_effects = my_effects();
		int [int] my_effects_int;
		foreach e in my_effects
		{
			my_effects_int[e.to_int()] = my_effects[e];
		}
		state["my_effects_int().to_json()"] = my_effects_int.to_json();
	}
	else
		state["my_effects().to_json()"] = my_effects().to_json();
	state["my_fullness()"] = my_fullness();
	if (my_fury() != 0)
		state["my_fury()"] = my_fury();
	state["my_id()"] = my_id();
	state["my_inebriety()"] = my_inebriety();
	state["my_level()"] = my_level();
	state["my_maxhp()"] = my_maxhp();
	state["my_maxmp()"] = my_maxmp();
	state["my_name()"] = my_name();
	state["my_path()"] = my_path();
	state["my_primestat()"] = my_primestat();
	state["my_sign()"] = my_sign();
	if (my_soulsauce() != 0)
		state["my_soulsauce()"] = my_soulsauce();
	state["my_spleen_use()"] = my_spleen_use();
	if (my_thrall() != $thrall[none])
		state["my_thrall()"] = my_thrall();
	state["fullness_limit()"] = fullness_limit();
	state["inebriety_limit()"] = inebriety_limit();
	state["spleen_limit()"] = spleen_limit();
	state["gameday_to_int()"] = gameday_to_int();
	state["identifier"] = identifier;
	state["get_revision()"] = get_revision();
	state["format version"] = 2;
	
	if (true)
	{
		item [slot] equipped_items = equipped_items();
		int [slot] equipped_items_int;
		foreach s in equipped_items
		{
			equipped_items_int[s] = equipped_items[s].to_int();
		}
		state["equipped_item_int().to_json()"] = equipped_items_int.to_json();
	}
	
	
	string [string] properties;
	foreach s in $strings[lastEncounter,lastAdventure]
	{
		string v = get_property(s);
		if (v.length() == 0)
			continue;
		properties[s] = v;
	}
	if ($locations[The Battlefield (Frat Uniform), The Battlefield (Hippy Uniform)] contains my_location() || $locations[The Battlefield (Frat Uniform), The Battlefield (Hippy Uniform)] contains get_property("lastAdventure").to_location())
	{
		properties["hippiesDefeated"] = get_property("hippiesDefeated");
		properties["fratboysDefeated"] = get_property("fratboysDefeated");
	}
	if (my_path() == "The Source")
		properties["sourceInterval"] = get_property("sourceInterval");
	state["JSON get_property()s"] = properties.to_json();
	
	float [string] numeric_modifiers;
	foreach s in __numeric_modifier_names
	{
		float v = numeric_modifier(s);
		if (v == 0.0)
			continue;
		//state["numeric_modifier(\"" + s + "\")"] = v;
		numeric_modifiers[s] = v;
	}
	state["JSON numeric_modifier()s"] = numeric_modifiers.to_json();
	
	logprint("JSON player state: " + state.to_json());
}