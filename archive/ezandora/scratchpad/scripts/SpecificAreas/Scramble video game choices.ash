void main()
{
	foreach s in $strings[660,661,662,663,659,665]
	{
		string property_name = "choiceAdventure" + s;
		int current_value = get_property(property_name).to_int();
		int new_value = 1;
		if (current_value == new_value)
			new_value = 2;
		set_property(property_name, new_value);
	}
}