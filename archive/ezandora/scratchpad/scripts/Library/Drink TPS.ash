void main()
{
	if ($item[tiny plastic sword].available_amount() == 0)
		return;
	item [int] items;
	items[items.count()] = $item[grogtini];
	items[items.count()] = $item[Bodyslam];
	items[items.count()] = $item[Dirty martini];
	items[items.count()] = $item[Vesper];
	items[items.count()] = $item[Cherry bomb];
	items[items.count()] = $item[Sangria del diablo];
	
	item drink = items[random(items.count())];
	cli_execute("call scripts/Library/CastOde.ash 10");
	cli_execute("drink " + drink);
}