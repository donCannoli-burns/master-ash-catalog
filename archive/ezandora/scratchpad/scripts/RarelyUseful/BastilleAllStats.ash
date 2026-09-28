import "relay/BastilleRelay.ash"

Record BastilleConfigurationStats
{
	int [string] configuration;
	int [int] stats;
};


int configurationBestOfTwo(BastilleConfigurationStats config, boolean defence)
{
	int base_index = 0;
	if (defence)
		base_index = 3;
		
	
	int a = min(config.stats[base_index + 0], config.stats[base_index + 1]);
	int b = min(config.stats[base_index + 0], config.stats[base_index + 2]);
	int c = min(config.stats[base_index + 1], config.stats[base_index + 2]);
	
	int v = a;
	if (b > v) v = b;
	if (c > v) v = c;
	return v;
	
	//return max(max(min(config.stats[base_index + 0], config.stats[base_index + 1]), min(config.stats[base_index + 0], config.stats[base_index + 2])), min(config.stats[base_index + 1], config.stats[base_index + 2]));
}

boolean configurationIsBetter(BastilleConfigurationStats testing_configuration, BastilleConfigurationStats other_configuration, boolean prefer_attack_first)
{
	//Best-of-two defence, then attack.
	int a_defence_best_of_two = configurationBestOfTwo(testing_configuration, true);
	int b_defence_best_of_two = configurationBestOfTwo(other_configuration, true);
	int a_attack_best_of_two = configurationBestOfTwo(testing_configuration, false);
	int b_attack_best_of_two = configurationBestOfTwo(other_configuration, false);
	
	//print_html(a_defence_best_of_two + " versus " + b_defence_best_of_two);
	//print_html(a_attack_best_of_two + " versus " + b_attack_best_of_two);
	
	if (prefer_attack_first)
	{
		if (a_attack_best_of_two > b_attack_best_of_two) return true;
		if (b_attack_best_of_two > a_attack_best_of_two) return false;
		if (a_defence_best_of_two > b_defence_best_of_two) return true;
		if (b_defence_best_of_two > a_defence_best_of_two) return false;
	}
	else
	{
		if (a_defence_best_of_two > b_defence_best_of_two) return true;
		if (b_defence_best_of_two > a_defence_best_of_two) return false;
		if (a_attack_best_of_two > b_attack_best_of_two) return true;
		if (b_attack_best_of_two > a_attack_best_of_two) return false;
	}
	return true;
}

void main()
{
	if (false)
	{
		BastilleConfigurationStats artificial_1;
		BastilleConfigurationStats artificial_2;
		
		artificial_1.stats = {131, 122, 131, 243, 240, 243};
		artificial_2.stats = {130, 120, 130, 245, 243, 245};
		print_html("2 is better than 1? " + configurationIsBetter(artificial_2, artificial_1, false));
		return;
	}

	BastilleConfigurationStats [int] configurations;
	for barb from 1 to 3
	{
		bastilleChangeConfiguration("barb", barb);
		for moat from 1 to 3
		{
			bastilleChangeConfiguration("moat", moat);
			for bridge from 1 to 3
			{
				bastilleChangeConfiguration("bridge", bridge);
				for holes from 1 to 3
				{
					bastilleChangeConfiguration("holes", holes);
					BastilleConfigurationStats configuration_stats;
					
					string [int] output;
					output.listAppend(barb);
					output.listAppend(moat);
					output.listAppend(bridge);
					output.listAppend(holes);
					
					foreach key, stat_value in __bastille_state.stats
					{
						output.listAppend(stat_value);
						configuration_stats.stats[key] = stat_value;
						if (stat_value < __needle_minimum_possible_value[key])
							print("HEY! " + stat_value + " is less than " + __needle_minimum_possible_value[key], "red");
					}
					//print("BASTILLE_ALL_STATS: " + output.listJoinComponents(","));
					//abort("what");
					
					configuration_stats.configuration["barb"] = barb;
					configuration_stats.configuration["moat"] = moat;
					configuration_stats.configuration["bridge"] = bridge;
					configuration_stats.configuration["holes"] = holes;
					
					configurations[configurations.count()] = configuration_stats;
				}
			}
		}
	}
	logprint("BASTILLE_SEEN_CONFIGURATIONS: " + configurations.to_json());
	//Pick best:
	int best_configuration_defence_index = -1;
	int best_configuration_attack_index = -1;
	
	foreach key, configuration_stats in configurations
	{
		if (best_configuration_defence_index == -1)
		{
			best_configuration_defence_index = key;
			best_configuration_attack_index = key;
			continue;
		}
		if (configurationIsBetter(configurations[key], configurations[best_configuration_defence_index], false))
		{
			best_configuration_defence_index = key;
		}
		if (configurationIsBetter(configurations[key], configurations[best_configuration_attack_index], true))
		{
			best_configuration_attack_index = key;
		}
	}
	string best_type = "defence";
	int best_configuration_index = best_configuration_defence_index;
	
	int attack_pattern_delta = configurationBestOfTwo(configurations[best_configuration_attack_index], false) - __needle_minimum_possible_value[0];
	int defence_pattern_delta = configurationBestOfTwo(configurations[best_configuration_defence_index], true) - __needle_minimum_possible_value[3];
	/*for i from 0 to 2
		attack_pattern_delta += configurations[best_configuration_attack_index].stats[i] - __needle_minimum_possible_value[i];
	int defence_pattern_delta = 0;
	for i from 3 to 5
		defence_pattern_delta += configurations[best_configuration_defence_index].stats[i] - __needle_minimum_possible_value[i];*/
	
	print_html(attack_pattern_delta + " versus " + defence_pattern_delta);
	if (attack_pattern_delta > defence_pattern_delta)
	{
		best_configuration_index = best_configuration_attack_index;
		best_type = "attack";
	}
	print_html("best attack stats: " + configurations[best_configuration_attack_index].stats.listJoinComponents("/"));
	print_html("best defence stats: " + configurations[best_configuration_defence_index].stats.listJoinComponents("/"));
	
	if (best_configuration_index != -1)
	{
		string [int] configuration_display_names;
		foreach s in $strings[barb,moat,bridge,holes]
		{
			bastilleChangeConfiguration(s, configurations[best_configuration_index].configuration[s]);
			configuration_display_names.listAppend(__configuration_internals_to_display_name[s][configurations[best_configuration_index].configuration[s]]);
		}
		print("Best configuration is currently: " + best_type + " " + configuration_display_names.listJoinComponents(", ") + " with stats " + configurations[best_configuration_index].stats.listJoinComponents("/"));
	}
}