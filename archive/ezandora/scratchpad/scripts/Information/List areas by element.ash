void main()
{
	foreach e in $elements[stench,spooky,hot,cold,sleaze]
	{
		print(" ");
		print(e + ":");
		location [int] locations;
		float [location] locations_percentage_element;
		float [location] locations_ml;
		foreach l in $locations[]
		{
			if (l.zone.contains_text("Crimbo") || ($strings[WhiteWed,Event,Events,Twitch] contains l.zone))
				continue;
	        float [monster] monsters = l.appearance_rates();
	        float percentage = 0.0;
	        float average_monster_level = 0.0;
	        
	        float total_rate = 0.0;
	        int monster_count = 0;
	        foreach m, rate in monsters
	        {
	        	if (rate < 0.0) continue;
	        	if (m == $monster[none])
	        		continue;
	        	if (m.attributes.contains_text("ULTRARARE"))
	        		continue;
	        	monster_count += 1;
	        	total_rate += rate;
	        }
	        float rate_override = 0.0;
	        if (total_rate <= 10.0 && monster_count > 0)
	        {
	        	//Certain areas are just completely wrong after we defeat them.
	        	//Just guess.
	        	rate_override = 1.0 / to_float(monster_count) * 100.0;
	        	//print(l + " : " + rate_override, "red");
	        }
	        float rate_correction = 1.0;
	        if (monsters[$monster[none]] > 0.0 && monsters[$monster[none]] < 100.0)
	        {
	        	rate_correction = 1.0 / (1.0 - monsters[$monster[none]] / 100.0);
	        }
	        foreach m, rate in monsters
	        {
	        	rate *= rate_correction;
	        	if (rate_override > 0.0)
	        		rate = rate_override;
	        	if (rate <= 0.0)
	        		continue;
	        	float r = rate / 100.0;
	        	if (m.attributes.contains_text("Scale"))
	        		average_monster_level += r * 1.0;
	        	else
		        	average_monster_level += r * to_float(m.raw_attack);
	        	if (m.defense_element != e)
	        		continue;
	        	percentage += r;
	        }
	        percentage = round(percentage * 1000.0) / 1000.0;
	        locations_percentage_element[l] = percentage;
	        locations_ml[l] = average_monster_level;
	        if (percentage > 0)
	        {
		    	locations[locations.count()] = l;
		    }
		}
		//sort locations by (locations_percentage_element[value] >= 1.0 ? -99999999.0 + locations_ml[value] : locations_ml[value]);
		sort locations by -1000000.0 * locations_percentage_element[value] + locations_ml[value];
		foreach key, l in locations
		{
			float percentage = locations_percentage_element[l];
			print("&nbsp;&nbsp;&nbsp;&nbsp;" + l + " : " + round(percentage * 100.0) + "%");
		}
	}
}