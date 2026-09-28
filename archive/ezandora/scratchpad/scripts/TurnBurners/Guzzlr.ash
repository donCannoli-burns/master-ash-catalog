boolean __setting_chase_bronze = true;
boolean __setting_platinum_only = false;
void main()
{
	cli_execute("familiar reagnimated gnome");
	cli_execute("equip gnomish housemaid's kgnee");
	cli_execute("maximize 1.0 combat rate 1.0 familiar weight +equip mafia thumb ring -tie -familiar");
	while (my_adventures() > 0)
	{
		if (get_property("guzzlrQuestLocation") == "" || get_property("questGuzzlr") == "unstarted")
		{
			buffer page_text = visit_url("inventory.php?tap=guzzlr", false, false);
			int option_id = -1;
			if (page_text.contains_text("value=\"Platinum Tier\"") && get_property("guzzlrPlatinumDeliveries").to_int() < 30)
				option_id = 4;
			else if (page_text.contains_text("value=\"Gold Tier\"") && get_property("guzzlrGoldDeliveries").to_int() < 150)
			{
				if (__setting_platinum_only)
					return;
				option_id = 3;
			}
			else if (page_text.contains_text("value=\"Bronze Tier\"") && __setting_chase_bronze && get_property("guzzlrBronzeDeliveries").to_int() < 200) //196 but eh
			{
				if (__setting_platinum_only)
					return;
				option_id = 2;
			}
			
			
			if (option_id != -1)
				visit_url("choice.php?whichchoice=1412&option=" + option_id);
			else
			{
				visit_url("choice.php?whichchoice=1412&option=5");
				return;
			}
		}
		if (get_property("guzzlrQuestLocation") == "")
		{
			print_html("no quest");
			return;
		}
		location target_location = get_property("guzzlrQuestLocation").to_location();
		
		string booze_string = get_property("guzzlrQuestBooze");
		item target_booze = booze_string.to_item();
		if (booze_string == "special personalized cocktail" || booze_string == "Guzzlr cocktail set")
		{
			target_booze = $item[Ghiaccio Colada];
			if ($item[Guzzlr cocktail set].available_amount() > 0 && target_booze.available_amount() == 0)
				cli_execute("make 1 " + target_booze);
		}
		if (target_booze.inebriety == 0)
		{
			abort(target_booze + " is not booze");
			return;
		}
		
		
		
		if (target_location == $location[none] || target_booze == $item[none])
		{
			print_html("no location " + target_location + " or item " + target_booze);
			break;
		}
		if (target_booze.mall_price() > 0 && target_booze.mall_price() >= 20000 && target_booze.available_amount() == 0)
		{
			abort(target_booze + " too expensive at " + target_booze.mall_price());
			return;
		}
		if (target_booze.item_amount() == 0)
			retrieve_item(1, target_booze);
		
		cli_execute("gain 25 combat rate 1 eff");
		cli_execute("gain familiar weight 1 eff");
		
		
		
		if ($item[Guzzlr shoes].available_amount() > 0 && $item[Guzzlr shoes].equipped_amount() == 0)
			cli_execute("equip acc3 Guzzlr shoes");
		if ($item[Guzzlr pants].available_amount() > 0 && $item[Guzzlr pants].equipped_amount() == 0)
			cli_execute("equip Guzzlr pants");
		if ($locations[Barrrney's Barrr, the f'c'le, belowdecks, poop deck] contains target_location)
		{
			cli_execute("equip acc1 pirate fledges");
		}
		if ($locations[the secret government laboratory] contains target_location && $item[personal ventilation unit].available_amount() > 0)
		{
			cli_execute("equip acc1 personal ventilation unit");
		}
		if (($locations[The Rogue Windmill,The Mouldering Mansion] contains target_location) && $effect[Absinthe Minded].have_effect() == 0)
		{
			cli_execute("up absinthe minded");
		}
		if (target_location == $location[The Red Queen's Garden] && $effect[Down the Rabbit Hole].have_effect() == 0)
		{
			use($item["drink me" potion]);
		}
		
		
		print_html("adv1(" + target_location + ")");
		adv1(target_location, -1, "");
		if (get_property("guzzlrQuestLocation") == "") //no tracking in mafia
			cli_execute("refresh inventory");
	}
}