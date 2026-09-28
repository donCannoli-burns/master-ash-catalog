import "scripts/Helix Fossil/Helix Fossil Interface.ash";

void main()
{
	HelixResetSettings();
	__helix_settings.monsters_to_run_away_from = $monsters[toxic beastie,Filthy Pirate,Fishy Pirate,Funky Pirate,Flashy Pirate,C<i>bzzt</i>er the Grisly Bear,Gurgle the Turgle,Skeezy the Jug Rat];
	HelixWriteSettings();
	
	if ($item[the lot's engagement ring].equipped_amount() == 0) //'
	{
		if ($item[navel ring of navel gazing].available_amount() > 0)
		{
			cli_execute("equip acc1 navel ring of navel gazing");
		}
		if ($item[pantsgiving].available_amount() > 0)
		{
			cli_execute("equip pantsgiving");
		}
	
		if (my_primestat() != $stat[moxie] && $item[tiny black hole].available_amount() > 0)
		{
			if ($familiar[xiblaxian holo-companion].have_familiar())
				cli_execute("familiar xiblaxian holo-companion");
			string maximisation_string = "init +equip tiny black hole -equip helps-you-sleep";
			if ($item[navel ring of navel gazing].available_amount() > 0)
				maximisation_string += " +equip navel ring of navel gazing";
			if ($item[pantsgiving].available_amount() > 0)
				maximisation_string += " +equip pantsgiving";
			cli_execute("maximize " + maximisation_string + " -tie");
		}
	}
	location [item] keycard_locations;
	
	keycard_locations[$item[8240]] = $location[Pirates of the Garbage Barges];
	keycard_locations[$item[8241]] = $location[The Toxic Teacups];
	keycard_locations[$item[8242]] = $location[Uncle Gator's Country Fun-Time Liquid Waste Sluice]; //'
	
	foreach keycard in keycard_locations
	{
		location keycard_location = keycard_locations[keycard];
		
		while (keycard.available_amount() == 0)
		{
			adv1(keycard_location, 0, "");
		}
	}
}