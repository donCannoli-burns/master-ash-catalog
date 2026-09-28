void main()
{
	string out = "PIRATE_INSULTS_TRACKING";
	
	for i from 1 to 8
	{
		boolean have_insult = get_property("lastPirateInsult" + i).to_boolean();
		if (!have_insult) continue;
		out += ",";
		out += i;
	}
	print(out);
}