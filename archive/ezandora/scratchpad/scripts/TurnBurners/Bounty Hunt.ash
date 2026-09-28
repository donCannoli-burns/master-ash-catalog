import "scripts/Farming/CheapFarm.ash";
import "scripts/Helix Fossil/Helix Fossil Interface.ash"
import "relay/Guide/Support/LocationAvailable.ash"

static
{
	item [bounty] __bounty_unlocks;
	void initialiseBountyUnlocks()
	{
		__bounty_unlocks[$bounty[glittery skate key]] = $item[tiny bottle of absinthe];
		__bounty_unlocks[$bounty[pile of country guano]] = $item[astral mushroom];
		__bounty_unlocks[$bounty[wig powder]] = $item[&quot;DRINK ME&quot; potion];
		__bounty_unlocks[$bounty[grizzled stubble]] = $item[transporter transponder];
		__bounty_unlocks[$bounty[hickory daiquiri]] = $item[devilish folio];
	}
	initialiseBountyUnlocks();
}

void tryToFulfillBounty(string property_name)
{
	boolean maximised = false;
	int breakout = 100;
	while (breakout > 0)
	{
		breakout -= 1;
		string property_value = get_property(property_name);
		if (property_value == "")
			break;
		string [int] property_list = property_value.split_string(":");
		if (property_list.count() != 2)
			break;
		bounty bounty_item = property_list[0].to_bounty();
		int bounty_amount = property_list[1].to_int();
		
		
		if (bounty_amount >= bounty_item.number)
		{
			//return to the BHH:
			visit_url("bounty.php");
			break;
		}
		if (bounty_item == $bounty[hickory daiquiri])
		{
			visit_url("bounty.php");
			//abort("handle this");
			if (get_property(property_name) == "")
				break;
		}
		
		HelixResetSettings();
		__helix_settings.monsters_to_olfact[bounty_item.monster] = true;
		foreach key, m in bounty_item.location.get_monsters()
		{
			if (m == bounty_item.monster)
				continue;
			__helix_settings.monsters_to_run_away_from[m] = true;
			//FIXME use free banishes
		}
		__helix_settings.always_run_away_from_navel = true;
		HelixWriteSettings();
		
		if (!maximised || (bounty_item.location == $location[the secret government laboratory] && $item[personal ventilation unit].available_amount() > 0 && $item[personal ventilation unit].equipped_amount() == 0))
		{
			//if ($familiar[reagnimated gnome].have_familiar())
				//cli_execute("familiar reagnimated gnome");
			string maximisation_string = "max 25 combat rate";
			maximisation_string = "combat rate";
			if (bounty_item == $bounty[burned-out arcanodiode])
				maximisation_string = "-combat rate 0.01 monster level";
			maximisation_string += " -familiar -equip hoa zombie eyes";
			//FIXME exact
			//if ($familiar[reagnimated gnome].have_familiar())
				//maximisation_string += ", 1.0 familiar weight +equip ";
			if ($item[navel ring of navel gazing].available_amount() > 0)
				maximisation_string += " +equip navel ring of navel gazing";
			else if ($item[greatest american pants].available_amount() > 0)
				maximisation_string += " +equip greatest american pants";
			if ($item[pantsgiving].available_amount() > 0)
				maximisation_string += " +equip pantsgiving";
			if (my_class() == $class[seal clubber] && $item[meat tenderizer is murder].available_amount() > 0) //banish
				maximisation_string += " +equip meat tenderizer is murder";
			if (bounty_item.location == $location[inside the palindome])
				maximisation_string += " +equip talisman o' namsilat";
			if (bounty_item.location == $location[the poop deck])
				maximisation_string += " +equip pirate fledges";
			if (bounty_item.location == $location[the secret government laboratory] && $item[personal ventilation unit].available_amount() > 0)
				maximisation_string += " +equip personal ventilation unit";
			maximisation_string += " -tie";
			string command = "maximize " + maximisation_string;
			//print_html("executing \"" + command + "\"");
			cli_execute(command);
			
			maximised = true;
		}
		
		item unlocking_potion = __bounty_unlocks[bounty_item];
		if (property_name == "currentSpecialBountyItem" && unlocking_potion == $item[none] && !bounty_item.location.locationAvailable())
		{
			boolean allowed = false;
			//hack - this is incorrect
			if (bounty_item.location == $location[chinatown shops] && get_campground()[$item[jar of psychoses (The Suspicious-Looking Guy)]] > 0)
				allowed = true;
			if (!allowed)
			{
				abort("don't know how to handle this bounty");
				return;
			}
		}
		if (unlocking_potion != $item[none] && unlocking_potion.effect_modifier("effect").have_effect() == 0)
		{
			cli_execute("use 1 " + unlocking_potion);
		}
		if (bounty_item.location == $location[The Copperhead Club])
		{
			set_property("choiceAdventure1074", 1);
		}
		
		insureOnceDailyFamiliars(true, $familiars[artistic goth kid]);
		adv1(bounty_item.location);
	}
}

void main()
{
	foreach s in $strings[currentEasyBountyItem,currentHardBountyItem,currentSpecialBountyItem]
		tryToFulfillBounty(s);
}