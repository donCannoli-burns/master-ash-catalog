void main()
{
	if (get_property("privateLastThinknerdQuestComplete").to_int() == my_ascensions())
		return;
		
	if ($item[letter for melvign the gnome].available_amount() > 0)
		use(1, $item[letter for melvign the gnome]);
	
	if ($item[navel ring of navel gazing].available_amount() > 0)
		equip($item[navel ring of navel gazing]);
	else if ($item[greatest american pants].available_amount() > 0)
		equip($item[greatest american pants]);
	
	cli_execute("autoattack runaway");
	while (my_adventures() > 0 && $item[Professor What garment].available_amount() == 0)
	{
		adventure(1, $location[the thinknerd warehouse]);
	}
	if ($item[Professor What garment].available_amount() > 0)
	{
		visit_url("place.php?whichplace=mountains&action=mts_melvin");
		set_property("privateLastThinknerdQuestComplete", my_ascensions().to_string());
	}
}