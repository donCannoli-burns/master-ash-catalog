void main()
{
	if (to_boolean(get_property("__user_casual_ascension_use_tatters")))
		cli_execute("ccs casualtatteredcann");
	else
		cli_execute("ccs helix fossil"); //cli_execute("ccs Cannelloni");
}