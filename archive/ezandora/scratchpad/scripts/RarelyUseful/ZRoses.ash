void main()
{
	while (true)
	{
		string [int][int] groups = visit_url("shop.php?whichshop=flowertradein").group_string("Chroner</b>&nbsp;<b>.([0-9]*).");
		string [int] found;
		foreach key in groups
		{
			found[found.count()] = groups[key][1];
		}
		
		string output = "Rose->Chroner values at " + time_to_string() + ": ";
		foreach key, number in found
		{
			if (key != 0)
				output += ", ";
			output += number;
		}
		print(output);
		waitq(900);
	}
}