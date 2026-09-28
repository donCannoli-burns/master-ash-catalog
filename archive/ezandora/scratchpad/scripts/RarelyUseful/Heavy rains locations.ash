void main()
{
	location [int] all_locs;
	foreach l in $locations[]
		all_locs[all_locs.count()] = l;
	
	sort all_locs by value.recommended_stat;
	
	foreach key, l in all_locs
	{
		int base_level = 1;
		if (l.recommended_stat >= 40)
			base_level = 2;
		if (l.environment == "indoor")
			base_level += 2;
		else if (l.environment == "outdoor")
			base_level += 0;
		else if (l.environment == "underground")
			base_level += 4;
		else
			continue;
		print(l + " - " + l.environment + " - water level " + base_level);
	}
}