int __fights = 100;


void main()
{
	float seconds_elapsed = to_float(gametime_to_int()) / 1000.0;
	float percent_of_day_elapsed = seconds_elapsed / 86400.0;
	
	int fights_have = pvp_attacks_left();
	
	float fights_can_use_total = percent_of_day_elapsed * to_float(__fights);
	
	int fights_delta = __fights - fights_have;
	
	
	int fights_delta_2 = fights_can_use_total - fights_delta;
	
	
	print_html((floor(percent_of_day_elapsed * 100.0 * 100.0) / 100.0) + "% of day elapsed. Fights at " + fights_can_use_total + ".");
	if (fights_delta_2 > 0)
		print_html("Can use <font color=red>" + fights_delta_2 + "</font> fights.");
	else
		print_html("<font color=red>No fights left.</font>");
	
}