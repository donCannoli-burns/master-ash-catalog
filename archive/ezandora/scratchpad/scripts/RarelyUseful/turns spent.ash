void main()
{
	location [int] places;
	foreach l in $locations[]
	{
		if (l.turns_spent == 0)
			continue;
		places[places.count()] = l;
	}
	//sort places by -value.turns_spent;
	foreach key, l in places
	{
		print(l + ": " + l.turns_spent + " turns spent");
	}
}