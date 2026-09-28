import "relay/Guide/Support/Library.ash";

boolean drinkableRegardless(item it)
{
	if ($items[glass of &quot;milk&quot;,cup of &quot;tea&quot;,thermos of &quot;whiskey&quot;,Lucky Lindy,Bee's Knees,Sockdollager,Ish Kabibble,Hot Socks,Phonus Balonus,Flivver,Sloppy Jalopy] contains it) return true; //'
	return false;
}

boolean [item] calculateRecentlyConsumedItems()
{
	boolean [item] recently_consumed_items;
	
	buffer page_text = visit_url("showconsumption.php?recent=1");
	//td width=300 valign=top><a class=nounder href='javascript:descitem(663984491);'>cup of lukewarm tea</a>&nbsp;&nbsp;&nbsp;</td><td>3</td><td nowrap><small>2016-01-11 03:05am</small>
	//<td width=300 valign=top><a class=nounder href='javascrip
	string [int][int] matches = page_text.group_string("t:descitem.[0-9]*.;'>(.*?)</a>.*?</td><td>[0123456789,]*</td><td nowrap><small>(.*?)</small>");
	//print_html(matches.to_json());
	
	
	int todays_year = format_today_to_string("YYYY").to_int_silent();
	int todays_month = format_today_to_string("MM").to_int_silent();
	int todays_day = format_today_to_string("dd").to_int_silent();
	int todays_hour = format_intraday_time_to_string("HH").to_int_silent();
	//int todays_minute = format_intraday_time_to_string("mm").to_int_silent();
	//print_html("we think today is " + todays_year + "-" + todays_month + "-" + todays_day + ", is that true?");
	//print_html("time = " + todays_hour + ":" + todays_minute);
	
	//01-01, 03-01, 05-01, 07-01, 09-01, 11-01
	int season_start_month = todays_month - (1 - todays_month % 2);
	
	int [int] days_per_month = {1:31, 2:28, 3:31, 4:30, 5:31, 6:30, 7:31, 8:31, 9:30, 10:31, 11:30, 12:31};
	
	
	boolean [string] valid_days;
	
	int operating_month = todays_month;
	int operating_day = todays_day + 1; //"today" is in  UTC, but our local time is not. probably should fix this. example: 7PM local time, we think today is 08 but KOL thinks it is 09
	if (gametime_to_int() < 10800000 && todays_hour >= 21)
	{
		//abort("we think today is " + todays_year + "-" + todays_month + "-" + todays_day + ", is that true?");
		operating_day += 1;
	}
	for i from 1 to 31
	{
	
		string valid_day_string = todays_year + "-";
		if (operating_month < 10)
			valid_day_string += "0";
		valid_day_string += operating_month;
		valid_day_string += "-";
		if (operating_day < 10)
			valid_day_string += "0";
		valid_day_string += operating_day;
		
		valid_days[valid_day_string] = true;
		operating_day -= 1;
		if (operating_day <= 0)
		{
			operating_month -= 1;
			operating_day = days_per_month[operating_month];
		}
	}
	
	if (false)
	{
		print_html("Valid days:");
		foreach day in valid_days
		{
			print_html(day);
		}
	}
	
	foreach key in matches
	{
		string item_name = matches[key][1];
		string time = matches[key][2];
		
		string date = time.group_string("([^ ]*)")[0][1];
		
		item it = item_name.to_item();
		//print_html(item_name + "/" + it + ": " + date);
		if (it == $item[none])
		{
			print_html("Unknown item " + item_name);
			continue;
		}
		//print_html("date = \"" + date + "\"");
		boolean recently_consumed = false;
		if (valid_days[date])
			recently_consumed = true;
		/*if (time.contains_text("2017-09-") || time.contains_text("2017-10-"))
			recently_consumed = true;
		if (time.contains_text("2017-09-01") || time.contains_text("2017-09-02"))
			recently_consumed = false;*/
		if (recently_consumed)
			recently_consumed_items[it] = true;
	}
	return recently_consumed_items;
}


void main()
{
	if (true)
	{
		boolean [item] recently_consumed_items = calculateRecentlyConsumedItems();
	
		int available_fullness = fullness_limit() - my_fullness();
		item [int] out;
		foreach it in $items[]
		{
			if (!can_interact())
			{
				if (it.available_amount() + it.creatable_amount() == 0 && !it.drinkableRegardless()) continue;
			}
			if (it.historical_price() >= 1000000) continue;
			if (recently_consumed_items[it]) continue;
		
			if (it.fullness == 0) continue;
			//if (it.fullness > 0) continue;
			if (it.levelreq > my_level()) continue;
			if (it.fullness > available_fullness && available_fullness > 0) continue;
		
			out[out.count()] = it;
		}
		sort out by value.fullness * 100000.0 - value.averageAdventuresForConsumable(false);
		if (available_fullness <= 0)
			sort out by value.fullness + value.averageAdventuresForConsumable(false);
		if (my_fullness() == fullness_limit())
			sort out by -value.averageAdventuresForConsumable(false);
	
		foreach key, it in out
		{
			string desired_colour = "";
			if (it.quality == "EPIC")
				desired_colour = "purple";
			else if (it.quality == "awesome")
				desired_colour = "blue";
			else if (it.quality == "good")
				desired_colour = "green";
			else if (it.quality == "crappy")
				desired_colour = "#999999";
			print_html("<font color=\"" + desired_colour + "\"><b>" + it + "</b> " + it.fullness + " - " + (it.averageAdventuresForConsumable(false) / to_float(it.fullness)) + " (" + it.historical_price() + ")</font>");
		}
	}
	
	if (false)
	{
		boolean [item] recently_consumed_items = calculateRecentlyConsumedItems();
	
		int available_inebriety = inebriety_limit() - my_inebriety();
		item [int] out;
		foreach it in $items[]
		{
			if (!can_interact())
			{
				if (it.available_amount() + it.creatable_amount() == 0 && !it.drinkableRegardless()) continue;
			}
			if (it.historical_price() >= 1000000) continue;
			if (recently_consumed_items[it]) continue;
		
			if (it.inebriety == 0) continue;
			//if (it.fullness > 0) continue;
			if (it.levelreq > my_level()) continue;
			if (it.inebriety > available_inebriety && available_inebriety > 0) continue;
		
			out[out.count()] = it;
		}
		sort out by value.inebriety * 100000.0 - value.averageAdventuresForConsumable(false);
		if (available_inebriety <= 0)
			sort out by value.inebriety + value.averageAdventuresForConsumable(false);
		if (my_inebriety() == inebriety_limit())
			sort out by -value.averageAdventuresForConsumable(false);
	
		foreach key, it in out
		{
			string desired_colour = "";
			if (it.quality == "EPIC")
				desired_colour = "purple";
			else if (it.quality == "awesome")
				desired_colour = "blue";
			else if (it.quality == "good")
				desired_colour = "green";
			else if (it.quality == "crappy")
				desired_colour = "#999999";
			print_html("<font color=\"" + desired_colour + "\"><b>" + it + "</b> " + it.inebriety + " - " + (it.averageAdventuresForConsumable(false) / to_float(it.inebriety)) + " (" + it.historical_price() + ")</font>");
		}
	
	}
}