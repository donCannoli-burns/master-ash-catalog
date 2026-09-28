int item_price(item it)
{
	if (!it.is_tradeable())
		return 0.0;
	if (it.historical_age() > 30.0)
		return it.mall_price();
	return it.historical_price();
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
	boolean [item] ignoring_items = $items[anniversary pewter cape,Pretty Predator Clawicure Kit,Gregarious Gregorian Smock,glow-in-the-dark stuffed burrowgrub];
	string letter = "w";
	item [slot] found;
	foreach it in $items[]
	{
		if (it.to_slot() == $slot[none])
			continue;
		if (ignoring_items contains it)
			continue;
		if (it.to_slot() == $slot[weapon] && it.weapon_hands() > 1)
			continue;
		if (it.available_amount() + it.closet_amount() == 0) continue;
		if (it.available_amount() == 0) continue;
		slot s = it.to_slot();
		//if (it == $item[spoon!])
			//continue;
		if (it.itemLetterLength(letter) > found[s].itemLetterLength(letter) && it.itemLetterLength(letter) > 0)
			found[s] = it;
	}
	print(found.to_json());
	foreach s, it in found
	{
		if (s == $slot[familiar])
			continue;
		if (s == $slot[off-hand] && found[$slot[weapon]].weapon_hands() > 1)
			continue;
		equip(it);
	}
}