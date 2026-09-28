int letterCount(string str, string letter)
{
	string lowercase_name = str.to_lower_case();
	if (!lowercase_name.contains_text(letter))
		return 0;
	
	int letter_count = 0;
	for i from 0 to lowercase_name.length() - 1
	{
		if (lowercase_name.char_at(i) == letter)
			letter_count += 1;
	}
	return letter_count;
}

int itemLetterLength(item it, string letter)
{
	string s = it.to_string().to_lower_case();
	int count = 0;
	boolean in_ampersand = false;
	for i from 0 to s.length() - 1
	{
		string c = s.char_at(i);
		if (c == "&")
		{
			in_ampersand = true;
		}
		if (in_ampersand)
		{
			if (c == ";")
				in_ampersand = false;
			continue;
		}
		if (s.char_at(i) == letter)
			count += 1;
	}
	return count;
}

void main()
{
	string pvp_page_text = visit_url("peevpee.php?place=rules");
	
	string todays_letter = pvp_page_text.group_string("Who has the most <b>(.)</b>")[0][1];
	
	boolean [string] letters;
	//letters = $strings[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z];
	letters[todays_letter] = true;
	
	foreach letter in letters
	{
		item [slot][int] equippables;
		foreach it in $items[]
		{
			slot s = it.to_slot();
			if (s == $slot[none])
				continue;
			int letter_count = it.itemLetterLength(letter);
			if (letter_count == 0)
				continue;
			if (!(equippables contains s))
			{
				item [int] blank;
				equippables[s] = blank;
			}
			equippables[s][equippables[s].count()] = it;
		}
		foreach s in equippables
		{
			sort equippables[s] by -value.itemLetterLength(letter);
		}
		print(letter + ": ");
		string tab_character = "&nbsp;&nbsp;&nbsp;&nbsp;";
		foreach s in equippables
		{
			print(tab_character + s + ":");
			foreach key, it in equippables[s]
			{
				if (key > 10)
					break;
				string colour = "";
				if (it.available_amount() == 0 || !it.can_equip())
				{
					colour = "gray"; //grey does not work
				}
				print(tab_character + tab_character + it + " - " + it.itemLetterLength(letter), colour);
			}
		}
	}
}