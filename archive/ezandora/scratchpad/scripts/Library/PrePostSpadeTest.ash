void main(string identifier)
{
	boolean output_spading = false;
	
	if ($locations[the haunted wine cellar, the haunted laundry room] contains get_property("lastAdventure").to_location())
		output_spading = true;
	if (!get_property("kingLiberated").to_boolean())
		output_spading = true;
	if (get_property("__output_spading").to_boolean())
		output_spading = true;
	if (true)
		output_spading = true;
	if (output_spading)
		cli_execute("call scripts/Library/OutputState.ash " + identifier);
}