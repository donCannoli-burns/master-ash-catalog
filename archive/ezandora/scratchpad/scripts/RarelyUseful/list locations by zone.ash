boolean setting_output_for_spreadsheet = false;

location [int] listMakeBlankLocation()
{
	location [int] result;
	return result;
}


void listAppend(location [int] list, location entry)
{
	int position = count(list);
	while (list contains position)
		position = position + 1;
	list[position] = entry;
}


void main()
{
	location [string][int] locations_by_zone;
	
	foreach loc in $locations[]
	{
		if (!(locations_by_zone contains (loc.zone)))
			locations_by_zone[loc.zone] = listMakeBlankLocation();
		locations_by_zone[loc.zone].listAppend(loc);
	}
	foreach zone in locations_by_zone
	{
		boolean first = true;
		if (!setting_output_for_spreadsheet)
			print(zone + ":");
		foreach key in locations_by_zone[zone]
		{
			location loc = locations_by_zone[zone][key];
			if (first && setting_output_for_spreadsheet)
			{
				print(zone + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + loc);
				first = false;
			}
			else
				print("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + loc);
		}
	}
	
	print("done");
}