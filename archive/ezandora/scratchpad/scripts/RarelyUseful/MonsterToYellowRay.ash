void main()
{
	boolean [monster] relevant_monsters;
	foreach m in $monsters[]
	{
		break;
		if (!m.copyable) continue;
		relevant_monsters[m] = true;
	}
	foreach l in $locations[]
	{
		if (l.zone == "Twitch" || l.zone == "Crimbo") continue;
		if (l.parent == "Removed") continue;
		
		
		if (l.environment == "underwater") continue;
		foreach m, rate in l.appearance_rates()
		{
			if (m == $monster[none]) continue;
			if (rate <= 0) continue;
			relevant_monsters[m] = true;
		}
	}
	
	float [monster] monster_profit;
	monster [int] monster_profit_sort;
	foreach m in relevant_monsters
	{
		float profit = 0.0;
		foreach key, r in m.item_drops_array()
		{
			if (r.rate < 0) continue;
			if (r.rate >= 50) continue;
			if (!r.drop.tradeable) continue;
			if (r.type == "c" || r.type == "p") continue;
			profit += r.drop.historical_price();
		}
		if (profit <= 0.0) continue;
		
		monster_profit[m] = profit;
		monster_profit_sort[monster_profit_sort.count()] = m;
	}
	sort monster_profit_sort by -monster_profit[value];
	
	foreach key, m in monster_profit_sort
	{
		if (monster_profit[m] < 10000) continue;
		print_html(m + ": " + monster_profit[m]);
		foreach key, r in m.item_drops_array()
		{
			if (r.rate < 0) continue;
			if (!r.drop.tradeable) continue;
			if (r.type == "c" || r.type == "p") continue;
			print_html("&nbsp;&nbsp;&nbsp;&nbsp;" + r.drop + " - " + r.drop.historical_price() + " (" + r.type + ")");
			
		}
	}
}