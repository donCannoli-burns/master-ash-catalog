
import "relay/Guide/Support/LocationAvailable.ash";

string letterForMonster(monster m)
{
	string monster_name = m.name.replace_string(" ", "");
	if (monster_name.length() % 2 == 0) return "";
	if (monster_name.contains_text("&"))
	{
		//FIXME handle this
		return "";
	}
	
	if (monster_name.length() == 0) return "";
	string mid_letter = monster_name.char_at(monster_name.length() / 2).to_lower_case();
	if ($strings[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z] contains mid_letter)
		return mid_letter;
	return "";
	
}

void listPossibleLocationsForEachLetter()
{
	string tab = "&nbsp;";
	foreach s in $strings[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z]
	{
		print_html("");
		print_html("<b>" + s.to_upper_case() + ":</b>");
		foreach l in $locations[]
		{
			if (!l.locationAvailable()) continue;
			boolean did_output_location = false;
			buffer location_line;
			
			boolean first_monster = true;
			float total_rate = 0.0;
			foreach m, r in l.appearance_rates()
			{
				if (r <= 0) continue;
				if (m.letterForMonster() == s)
				{
					if (!did_output_location)
					{
						location_line.append("<b>");
						location_line.append(l);
						location_line.append("</b>: ");
						did_output_location = true;
					}
					if (!first_monster)
					{
						location_line.append(", ");
					}
					else
					{
						first_monster = false;
					}
					location_line.append(m);
					total_rate += r;
				}
			}
			if (total_rate > 0.0)
			{
				location_line.append(" (");
				location_line.append(total_rate.round());
				location_line.append("%)");
			}
			if (location_line.length() > 0)
				print_html(location_line);
		}
		buffer wishable_line;
		wishable_line.append("<b>Wishables:</b> ");
		boolean first_monster = true;
		int monsters_output = 0;
		foreach m in $monsters[]
		{
			if (m.boss) continue;
			if (!m.wishable) continue;
			if (m.letterForMonster() != s) continue;
			if (!first_monster)
				wishable_line.append(", ");
			else
				first_monster = false;
			wishable_line.append(m);
			monsters_output += 1;
			if (monsters_output == 7)
				break;
		}
		print_html(wishable_line);
	}
}

void outputWishablesForString(string s)
{
	s = s.to_lower_case();
	buffer line;
	line.append("<b>");
	line.append(s);
	line.append("</b>: ");
	for i from 0 to s.length() - 1
	{
		string c = s.char_at(i);
		if (i != 0)
			line.append(" -> ");
		foreach m in $monsters[]
		{
			if (m.boss) continue;
			if (!m.wishable) continue;
			if (m.letterForMonster() != c) continue;
			line.append(m.name);
			break;
		}
	}
	print_html(line);
}

void main()
{
	listPossibleLocationsForEachLetter();
	foreach s in $strings[BOOM,GONE,STUN,BUDS,BUFF,LUCK]
		outputWishablesForString(s);
}