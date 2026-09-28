import "CheapFarm.ash";
import "scripts/Library/PrecheckSemirare.ash";
import "relay/Guide/Support/Library.ash"
import "relay/Guide/Support/Counter.ash";
import "scripts/Helix Fossil/Helix Fossil Interface.ash"

int setting_price_limit = 750000;

void insureEffectCheaply(effect e, item source, int cutoff_price, int min_number)
{
	if (have_effect(e) > 0 && min_number == 0) return;
	while (have_effect(e) < min_number)
	{
		if (mall_price(source) <= cutoff_price - 50)
		{
			int before = have_effect(e);
			cli_execute("use " + source);
			int after = have_effect(e);
			if (before == after)
			{
				print("error in script when using " + source);
				return;
			}
		}
		else
			return;
	}
}


void setUpKnownFarmingItems()
{
	known_items["Spice Melange"] = cheap_farming_target_item_make(0.001, MIN(500000, mall_price($item[spice melange])), 250.0);
}



/*void insureFarmingEffectCheaply(effect e, string command_source, item item_source, float items_used_per_cast, float turns_gained_per_cast, float item_find, float meat_find, float familiar_weight_modifier, float target_item_rate, float target_item_price, float target_monster_meat_drop)
{
	//complicated:
	if (items_used_per_cast < 1) items_used_per_cast = 1;

	if (have_effect(e) > 0 && min_number == 0) return;

	while (have_effect(e) < min_number)
	{
		//Calculate cost effectiveness:

		float cost_per_adventure = to_float(mall_price(item_source)) * items_used_per_cast / turns_gained_per_cast;
		float profit_per_adventure = item_find * target_item_rate * target_item_price + meat_find * target_monster_meat_drop;
		
		//if (mall_price(source) <= cutoff_price - 50)
		if (profit_per_adventure > cost_per_adventure + 25) //25 as a margin
		{
			int before = have_effect(e);
			if (command_source != "")
				cli_execute(command_source);
			else if (items_used_per_cast > 1)
				cli_execute("use " + items_used_per_cast + " " + item_source);
			else
				cli_execute("use " + item_source);
			
			int after = have_effect(e);
			if (before == after)
			{
				print("error in script when using " + source);
				return;
			}
		}
		else
			return;
	}
}*/

void equipOutfit()
{
	//cli_execute("outfit Spice Melange");
	float item_percent_worth = $item[spice melange].mall_price().to_float() / 1000.0 / 100.0;
	if (my_basestat($stat[mysticality]) >= 200 && false)
	{
		//mafia's maximizer is broken, AVOID USING
		//cli_execute("unequip wepaon; equip hodgman's imaginary hamster; equip camp scout backpack; maximize 2.5 meat, " + item_percent_worth + " item -tie -back -offhand");
		
		//cli_execute("maximize 2.5 meat, " + item_percent_worth + " item -tie +equip camp scout backpack +equip hodgman's imaginary hamster +");
		//cli_execute("equip hodgman's porkpie hat; equip gnawed-up dog bone; equip hodgman's imaginary hamster; equip camp scout backpack; equip origami pasties; equip hodgman's lobsterskin pants; equip acc1 belt of loathing; equip acc2 hodgman's lucky sock; equip acc3 hodgman's bow tie");
		cli_execute("outfit Spice Melange");
	}
	else
	{
		item back_item = $item[protonic accelerator pack];
		if ($item[CSA fire-starting kit].available_amount() < 11)
			back_item = $item[Camp Scout backpack];
		cli_execute("maximize 2.5 meat, " + item_percent_worth + " item -tie +equip " + back_item + " +equip Mr. Screege's spectacles +equip hodgman's imaginary hamster"); // +equip source shades");
	}
	//+equip hodgman's imaginary hamster probably shouldn't be here, but I'm not sure I trust mafia's maximiser, as at the moment it's giving inconsistent results
}

void main()
{
	if (!(my_basestat($stat[muscle]) >= 200 && my_basestat($stat[mysticality]) >= 200 && my_basestat($stat[moxie]) >= 200))
	{
		print("Get basestats to 200/200/200 first.", "Red");
		return;
	}
	//cli_execute("call Meat Farm Until Familiars Are Burned.ash");
	cli_execute("uneffect ode to booze; uneffect sonata of sneakiness; uneffect carlweather; uneffect moxious; uneffect mojomuscular; uneffect benetton");
	if (!get_property("friarsBlessingReceived").to_boolean())
		cli_execute("friars familiar");

	item i = $item[spice melange];
	int previous_amount = available_amount(i);

	boolean setting_on_holiday = false;
	int adventure_cutoff = 40;
	if (get_property("_borrowedTimeUsed").to_boolean())
	{
		if ($monster[a.m.c. gremlin].is_banished() || true)
			adventure_cutoff = 0;
		else
			adventure_cutoff = 11;
	}
	int adventures_to_use = my_adventures() - adventure_cutoff;

	if (adventures_to_use < 0 || adventures_to_use > 650)
	{
		abort("weird adventures_to_use value: " + adventures_to_use);
		return;
	}

	int starting_meat = my_meat();
	print("Starting meat: " + starting_meat);

	if (mall_price($item[drum machine]) > 2500)
	{
		print("Mall price of drum machine is too high: " + mall_price($item[drum machine]));
		return;
	}
	setUpKnownFarmingItems();
	
	int additional_machines_needed = MAX(0, adventures_to_use - available_amount($item[drum machine]));
	if (additional_machines_needed > 0)
		cli_execute("buy " + additional_machines_needed + " drum machine @ 2500");
	if ($item[drum machine].available_amount() < adventures_to_use)
		adventures_to_use = $item[drum machine].available_amount();
	print("Meat after acquiring drum machines: " + my_meat());

	cli_execute("uneffect Ur-Kel's Aria of Annoyance; uneffect Stevedave's Shanty of Superiority;");

	if (!to_boolean(get_property("_madTeaParty")))
	{
		cli_execute("acquire filthy knitted dread sack");
		cli_execute("hatter filthy knitted dread sack");
	}
	if (!to_boolean(get_property("demonSummoned")))
		cli_execute("summon Preternatural Greed");
	if (!to_boolean(get_property("_witchessBuff")))
		cli_execute("witchess");

	//cli_execute("call Library/equip item gear.ash");
	boolean recheck_outfit = false;
	//cli_execute("familiar angry jung man");
	cli_execute("familiar robortender");
	//cli_execute("familiar intergnat");
	equipOutfit();
	if (!(my_basestat($stat[muscle]) >= 200 && my_basestat($stat[mysticality]) >= 200 && my_basestat($stat[moxie]) >= 200))
	{
		recheck_outfit = true;
	}
	if ($item[lucky Tam O'Shanter].available_amount() > 0) //'
	{
		if ($item[lucky Tam O'Shanter].equipped_amount() == 0) //'
			equip($item[lucky Tam O'Shanter]); //'
	}
	else if ($item[astral pet sweater].available_amount() > 0)
	{
		if ($item[astral pet sweater].equipped_amount() == 0)
			equip($item[astral pet sweater]);
	}
	else
		cli_execute("equip familiar sugar shield");
	//cli_execute("autoattack spice melange");
	
	if (get_campground()[$item[source terminal]] > 0)
	{
		int limit = 0;
		while (get_property("_sourceTerminalEnhanceUses").to_int() < 3 && limit < 3)
		{
			cli_execute("terminal enhance items.enh");
			limit += 1;
		}
	}
	cli_execute("mood spicemelange");
	if (to_int(get_property("_poolGames")) < 3)
		cli_execute("pool 3; pool 3; pool 3");
	if (!to_boolean(get_property("_legendaryBeat")))
		cli_execute("use the legendary beat");
	if (!get_property("concertVisited").to_boolean())
		cli_execute("concert 3");
	//cli_execute("equip acc3 source shades");
	float target_item_rate = 0.001;
	//float target_item_price = mall_price(i);
	float target_monster_meat_drop = 250.0;
	float total_item_drop = 0.0;
	float total_meat_drop = 0.0;
	float total_count = 0.0;
	while (my_adventures() > adventure_cutoff)
	{
		insureAllFarmingEffects("Spice Melange", my_adventures() - adventure_cutoff);
		
		if (recheck_outfit)
		{
			if (my_basestat($stat[muscle]) >= 200 && my_basestat($stat[mysticality]) >= 200 && my_basestat($stat[moxie]) >= 200)
			{
				equipOutfit();
				recheck_outfit = false;
			}
		}
		
		if ($item[Fun-Guy spore].available_amount() > 0 && $effect[Mush-Mouth].have_effect() == 0)
			use(1, $item[Fun-Guy spore]);
		if ($effect[Mush-Mouth].have_effect() > 0)
		{
			if ($effect[trivia master].have_effect() == 0) //counteract
				cli_execute("up trivia master");
		}
		/*insureEffectCheaply($effect[Joyful Resolve], $item[resolution: be happier], 1199, 0);
		insureEffectCheaply($effect[Red Tongue], $item[red snowcone], 2499, 0);
		insureEffectCheaply($effect[Greedy Resolve], $item[resolution: be wealthier], 1499, 0);
		insureEffectCheaply($effect[Your Cupcake Senses Are Tingling], $item[pink-frosted astral cupcake], 1499, 0);
		insureEffectCheaply($effect[Chorale of Companionship], $item[recording of Chorale of Companionship], 3453, 0);
		insureEffectCheaply($effect[Sour Softshoe], $item[pulled yellow taffy], 4599, 50);
		insureEffectCheaply($effect[Blue Swayed], $item[Pulled blue taffy], 863, 50);
		insureEffectCheaply($effect[Sweet Heart], $item[Love song of sugary cuteness], 499, 20);
		insureEffectCheaply($effect[polka face], $item[Polka Pop], 3574, 0);
		insureEffectCheaply($effect[greedy resolve], $item[Resolution: be wealthier], 1499, 0);*/

		//insureFarmingEffectCheaply($effect[Sweet Heart], "", $item[Love song of sugary cuteness], 1, 5.0, 0.55, 0.55, 0.0, target_item_rate, target_item_price, target_monster_meat_drop);
		//insureFarmingEffectCheaply($effect[polka face], "", $item[Polka Pop], 1, 10.0, 0.55, 0.55, 0.0, target_item_rate, target_item_price, target_monster_meat_drop);
		//insureFarmingEffectCheaply($effect[greedy resolve], "", $item[Resolution: be wealthier], 1, 20.0, 0.0, 0.3, 0.0, target_item_rate, target_item_price, target_monster_meat_drop);
		//if (available_amount($item[secret tropical island volcano lair map]) > 0)
		//	return;
		//need 20 d20
		//210 turns of effect, 20 d20s, 10% +item
		//base drop rate is 0.1%
		//so...
		//price(d20) * 20.0 / 210.0 is cost per adventure
		boolean equip_other_familiar_equipment = true;
		if (available_amount($item[snow suit]) > 0)
		{
			//if (to_int(get_property("_snowSuitCount")) < 50)
			if (numeric_modifier($item[snow suit], "familiar weight") > 10.0)
			{
				equip_other_familiar_equipment = false;
				if (equipped_amount($item[snow suit]) == 0)
					cli_execute("equip snow suit");
			}
		}
		if (equip_other_familiar_equipment)
		{
			if ($item[lucky Tam O'Shanter].available_amount() > 0) //'
			{
				equip_other_familiar_equipment = false;
				if ($item[lucky Tam O'Shanter].equipped_amount() == 0) //'
					equip($item[lucky Tam O'Shanter]); //'
			}
			else if ($item[astral pet sweater].available_amount() > 0)
			{
				if ($item[astral pet sweater].equipped_amount() == 0)
					equip($item[astral pet sweater]);
			}
			else if (equipped_amount($item[sugar shield]) == 0)
				cli_execute("equip sugar shield");
		}
		if (have_effect($effect[beaten up]) > 0)
			break;
		//if (get_property("relayCounters").contains_text("window") || get_property("_romanticFightsLeft").to_int() > 0 || setting_on_holiday)
			//cli_execute("call scripts/Library/find wandering monster.ash");
		if (CounterWanderingMonsterMayHitNextTurn())
		{
			cli_execute("call scripts/Library/find wandering monster.ash");
		}
		precheckSemirare();
		float meat_before = my_meat();
		boolean need_helix_rewrite_later = false;
		set_property("_lord_helix_please_try_to_rave_concentration_these_monsters", "giant sandworm");
		set_property("_lord_helix_please_try_to_rave_nirvana_these_monsters", "giant sandworm");
		HelixResetSettings();
		if (get_property("_hoboUnderlingSummons").to_int() < 5 && is_wearing_outfit("Hodgman's Regal Frippery"))
		{
			__helix_settings.skills_to_cast[__helix_settings.skills_to_cast.count()] = $skill[Summon hobo underling];
			__helix_settings.skills_to_cast[__helix_settings.skills_to_cast.count()] = $skill[Ask the hobo for a drink]; //around the world around the world
			__helix_settings.skills_to_cast[__helix_settings.skills_to_cast.count()] = $skill[Ask the hobo to dance for you];
			need_helix_rewrite_later = true;
		}
		HelixWriteSettings();
		//profit is (0.001 * melange_cost * 0.1)
		if ($item[drum machine].available_amount() > 0)
			use(1, $item[drum machine]);
		else
			break; //???
		
		if (need_helix_rewrite_later)
		{
			HelixResetSettings();
			HelixWriteSettings();
		}
		
		float meat_after = my_meat();
		if (meat_before == meat_after)
			break;
		if (false)//if (get_property("romanticTarget") != "" && to_int(get_property("_romanticFightsLeft")) > 0)
		{
			cli_execute("outfit save Backup2");
			cli_execute("equip acc1 over-the-shoulder folder holder");
			cli_execute("call scripts/Library/find wandering monster.ash");
			cli_execute("outfit Backup2");
		}
		item pants = $item[none];
		//get_property("_pantsgivingBanish").to_int() < 5 && !$monster[pygmy witch surgeon].is_banished() || 
		if (get_property("_pantsgivingCount").to_int() < 51 || (get_property("_pantsgivingFullness").to_int() < 2 && availableFullness() == 0))
		{
			pants = $item[pantsgiving];
		}
		else
			pants = $item[hodgman's lobsterskin pants]; //'
		
		if ($slot[pants].equipped_item() != pants)
			pants.equip();
		
		float item_drop = item_drop_modifier();
		if (my_class() == $class[disco bandit])
			item_drop += 30.0 + 30.0;
		total_item_drop += item_drop;
		float meat_drop = meat_drop_modifier();
		if (my_class() == $class[disco bandit])
			meat_drop += 20.0 + 50.0;
		total_meat_drop += meat_drop;
		total_count += 1.0;
	}
	cli_execute("mood none");
	
	HelixResetSettings();
	HelixWriteSettings();
	

	int new_amount = available_amount(i);
	int amount_gained = new_amount - previous_amount;
	int price = mall_price(i);
	if (price < setting_price_limit)
		price = setting_price_limit;
	int final_meat = my_meat();
	print("Starting meat: " + starting_meat);
	print("Final meat: " + final_meat);
	int meat_gained = final_meat - starting_meat;
	if (amount_gained > 0)
	{
		print("Selling " + amount_gained + " " + i + " for " + price + ".");
		cli_execute("mallsell " + amount_gained + " " + i + " @ " + price);
		meat_gained = meat_gained + amount_gained * price;
	}
	cli_execute("autoattack none");
	cli_execute("familiar none; outfit birthday suit");
	if ($item[haiku katana].available_amount() > 0)
		equip($item[haiku katana]);
	int spices_available = available_amount($item[spices]);
	int spices_selling = spices_available - 111;
	cli_execute("mallsell -111 spices @ 100");
	print("Selling " + spices_selling + " spices.");
	meat_gained = meat_gained  + spices_selling * 100;
	
	
	if (total_count != 0.0)
	{
		float average_item = total_item_drop / total_count;
		float average_meat = total_meat_drop / total_count;
		
		print("+" + roundForOutput(average_item, 1) + "% item average.");
		print("+" + roundForOutput(average_meat, 1) + "% meat average.");
		float average_total_meat_gain = 250 * total_count * (1.0 + (average_meat / 100.0));
		float average_total_melanges_found = (total_count * (1.0 + (average_item / 100.0))) / 1000.0;
		print("Average melanges found: " + roundForOutput(average_total_melanges_found, 3) + " over " + total_count + " adventures.");
		print("Average total meat found: " + roundForOutput(average_total_meat_gain, 1) + " over " + total_count + " adventures.");
		print("Average melanges found: " + roundForOutput((average_total_melanges_found * 1000.0) / total_count, 3) + " over 1000 adventures.");
		print("Average melanges found: " + roundForOutput((average_total_melanges_found * 400.0) / total_count, 3) + " over 400 adventures.");
	}
	print("Meat gain: " + (meat_gained > 0 ? "+" : "") + meat_gained);

}