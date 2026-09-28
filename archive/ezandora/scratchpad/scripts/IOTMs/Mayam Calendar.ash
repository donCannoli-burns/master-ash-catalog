string mayamPickOrdering(string [int] position_ordering, boolean [string] symbols_used)
{
	foreach key, symbol in position_ordering
	{
		if (symbols_used[symbol]) continue;
		return symbol;
	}
	return "";
}

void performMayam()
{
	string [int] position_1_ordering = {
		"chair", 
		"fur", 
		"yam1",
		"eye",
		"sword", 
		"vessel"
	};
	string [int] position_2_ordering = {
		"meat",
		"yam2", 
		"bottle", 
		"wood",
		"lightning"
	};
	string [int] position_3_ordering = {
		"yam3", 
		"cheese", 
		"wall",
		"eyepatch"
	};
	string [int] position_4_ordering = {
		"clock", //+5 adventures
		"explosion", //PVP fights
		"yam4"
	};
	
	string [int] symbols_used_inverse = get_property("_mayamSymbolsUsed").split_string(",");
	
	boolean [string] symbols_used;
	foreach key, value in symbols_used_inverse
	{
		symbols_used[value] = true;
	}
	
	string [int] ordering;
	ordering[ordering.count()] = mayamPickOrdering(position_1_ordering, symbols_used);
	ordering[ordering.count()] = mayamPickOrdering(position_2_ordering, symbols_used);
	ordering[ordering.count()] = mayamPickOrdering(position_3_ordering, symbols_used);
	ordering[ordering.count()] = mayamPickOrdering(position_4_ordering, symbols_used);
	
	buffer executing_command;
	executing_command.append("mayam rings");
	foreach key, symbol in ordering
	{
		if (symbol == "")
		{
			return;
		}
		executing_command.append(" ");
		if (symbol == "yam1" || symbol == "yam2" || symbol == "yam3" || symbol == "yam4")
		{
			symbol = "yam";
		}
		executing_command.append(symbol);
	}
	
	boolean absorb = cli_execute(executing_command);
}

void main()
{
	if ($item[Mayam Calendar].available_amount() == 0)
		return;
	
	boolean absorb = cli_execute("mayam resonance stuffed yam stinkbomb");
	for i from 1 to 3
	{
		performMayam();
	}
}