

void main()
{
	item [int] candy;
	foreach i in $items[]
	{
		if (!i.candy) continue;
		if (available_amount(i) == 0) continue;
		candy[count(candy)] = i;
		//print(available_amount(i) + " " + i);
	}
	sort candy by available_amount(value);
	foreach key in candy
	{
		item it = candy[key];
		string addendum;
		if (autosell_price(it) > 0)
			addendum = " sells for " + autosell_price(it);
		print(available_amount(it) + " " + it + addendum);
	}
}