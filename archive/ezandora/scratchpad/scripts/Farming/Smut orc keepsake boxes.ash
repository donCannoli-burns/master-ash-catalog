import "scripts/Helix Fossil/Helix Fossil Interface.ash"

void main()
{
	HelixResetSettings();
	__helix_settings.monsters_to_run_away_from = $monsters[smut orc pipelayer,smut orc screwer,smut orc jacker,smut orc nailer];
	__helix_settings.always_run_away_from_navel = true;
	HelixWriteSettings();
	
	if ($familiar[mini-hipster].have_familiar())
		cli_execute("familiar mini-hipster");
	if ($item[navel ring of navel gazing].available_amount() > 0)
		cli_execute("maximize pickpocket chance -equip tiny black hole +equip pantsgiving +equip bling of the new wave +equip navel ring of navel gazing -tie");
	else if (my_primestat() == $stat[moxie])
		cli_execute("maximize 100.0 pickpocket chance 1.0 HP -tie");
	else
		cli_execute("maximize 1.0 HP -tie");
	if (inebriety_limit() - my_inebriety() < 0)
	{
		if ($item[drunkula's wineglass].can_equip() && $item[drunkula's wineglass].available_amount() > 0)
			cli_execute("equip drunkula's wineglass");
		else
			return;
	}
	
	set_location($location[the smut orc logging camp]);
	
	int adventure_limit = 50;
	if (get_property("_borrowedTimeUsed").to_boolean())
	{
		adventure_limit = 6; //ice house
		if ($monster[a.m.c. gremlin].is_banished())
			adventure_limit = 0;
	}
	while (my_adventures() > adventure_limit)
	{
		cli_execute("call scripts/Library/find wandering monster.ash");
		cli_execute("call scripts/Library/PrecheckSemirare.ash");
		adv1($location[the smut orc logging camp], 0, "");
	}
}