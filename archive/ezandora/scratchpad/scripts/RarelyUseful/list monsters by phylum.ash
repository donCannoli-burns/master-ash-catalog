import "relay/Guide/Support/List.ash"



string __tab_string = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";


location [int] locationsForMonster(monster m)
{
    //hacky, slow, sorry
    location [int] result;
    if (m == $monster[none])
        return result;
    foreach l in $locations[]
    {
        monster [int] location_monsters = l.get_monsters();
        foreach key in location_monsters
        {
            if (location_monsters[key] == m)
                result.listAppend(l);
        }
    }
    
    return result;
}

string generateMonsterLine(monster m, location l)
{
	string line;
	line += __tab_string;
	line += __tab_string + m;
	return line;
}
void main()
{
	monster [phylum][int] monsters_by_zone;
	foreach m in $monsters[]
	{
		if (!(monsters_by_zone contains (m.phylum)))
			monsters_by_zone[m.phylum] = listMakeBlankMonster();
		monsters_by_zone[m.phylum].listAppend(m);
	}
	foreach phylum in monsters_by_zone
	{
		print(phylum + ":");
		monster [location][int] monsters_in_locations;
		foreach key in monsters_by_zone[phylum]
		{
			monster m = monsters_by_zone[phylum][key];
			location [int] locations = m.locationsForMonster();
			if (locations.count() == 0)
			{
				locations.listAppend($location[none]);
			}
			foreach key in locations
			{
				location l = locations[key];
				if (!(monsters_in_locations contains l))
				{
					monsters_in_locations[l] = listMakeBlankMonster();
				}
				monsters_in_locations[l].listAppend(m);
			}
			/**/
		}
		if (monsters_in_locations[$location[none]].count() > 0)
		{
			print(__tab_string + "Unknown:");
			foreach key in monsters_in_locations[$location[none]]
			{
				print(generateMonsterLine(monsters_in_locations[$location[none]][key], $location[none]));
			}
		}
		foreach l in monsters_in_locations
		{
			if (l == $location[none])
				continue;
			print(__tab_string + l + ":");
			foreach key in monsters_in_locations[l]
			{
				monster m = monsters_in_locations[l][key];
				print(generateMonsterLine(m, l));
			}
		}
	}
	
	print("done - " + monsters_by_zone.count());
	
	foreach phylum in monsters_by_zone
	{
		//print(phylum);
	}
}