int freeRunawaysRemaining()
{
	int current_runaways = to_int(get_property("_banderRunaways"));
	int available_runaways = (weight_adjustment() + familiar_weight($familiar[Pair of Stomping Boots])) / 5;
	if (current_runaways >= available_runaways)
		return 0;
	return available_runaways - current_runaways;
}

void main()
{
	if (get_property("umdLastObtained").length() == 0)
		return;
	string umd_date_obtained = get_property("umdLastObtained");
	
	int day_in_year_acquired_umd = format_date_time("yyyy-MM-dd", umd_date_obtained, "D").to_int();
	int year_umd_acquired = format_date_time("yyyy-MM-dd", umd_date_obtained, "yyyy").to_int();
	
	string todays_date = today_to_string();
	int today_day_in_year = format_date_time("yyyyMMdd", todays_date, "D").to_int();
	int todays_year = format_date_time("yyyyMMdd", todays_date, "yyyy").to_int();
	
	//We compute the delta of days since last UMD obtained. If it's seven or higher, they can obtain it.
	//If the year is different, more complicated.
	//Umm... this will inevitably have an off by one error from me not looking closely enough.
	
	boolean has_been_seven_days = false;
	if (year_umd_acquired != todays_year)
	{
		//Query the number of days in last year, then subtract it from day_in_year_acquired_umd.
		
		int days_in_last_year = format_date_time("yyyy-MM-dd", todays_year + "-12-31", "D").to_int(); //this may work well past the year 10k. if it doesn't and you track down this bug and it's a problem, hello from eight thousand years ago!
		
		day_in_year_acquired_umd -= days_in_last_year * (todays_year - year_umd_acquired); //this is technically incorrect due to leap years, but it'll still result in proper checking. do not use for delta code
	}
	
	if (today_day_in_year - day_in_year_acquired_umd >= 7)
		has_been_seven_days = true;
	if (!has_been_seven_days)
		return;
	
	
	use_familiar($familiar[stomping boots]);
	cli_execute("use * fishy pipe");
	if ($effect[fishy].have_effect() == 0)
		return;
	
	item breathing_item = $item[aerated diving helmet];
	if ($item[old SCUBA tank].available_amount() > 0)
		breathing_item = $item[old SCUBA tank];
	
	string maximise_extra;
	if ($effect[Wet Willied].have_effect() == 0)
	{
		if ($item[willyweed].available_amount() > 2)
			cli_execute("use willyweed");
		else
			maximise_extra += " +equip das boot";
	}
	//if ($item[navel ring of navel gazing].available_amount() > 0)
		//maximise_extra += " +equip navel ring of navel gazing";
	cli_execute("maximize familiar weight -tie +equip " + breathing_item + maximise_extra);
	
	set_property("choiceAdventure918", "1");
	cli_execute("autoattack runaway");
	while (get_property("lastEncounter") != "Yachtzee!" && $effect[fishy].have_effect() > 0)
	{
		if (freeRunawaysRemaining() == 0 && my_familiar() == $familiar[stomping boots])
		{
			cli_execute("equip acc1 navel ring of navel gazing");
			use_familiar($familiar[happy medium]);
		}
		adv1($location[the sunken party yacht], 0, "");
	}
	
	cli_execute("autoattack none");
}