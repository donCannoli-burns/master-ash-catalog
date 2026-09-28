void main()
{
	if (my_id() != 2456416)
		return;
	int last_turn_saw_nc = -1;
	while (my_adventures() > 0)
	{
		//cli_execute("restore hp");
		//cli_execute("restore mp");
		cli_execute("mood execute");
		boolean skip = false;
		if (get_property("lastEncounter") == "Consciousness of a Stream")
		{
			if (last_turn_saw_nc == my_turncount())
			{
				skip = true;
				adv1($location[the bat hole entrance], -1, "");
			}
			else
				last_turn_saw_nc = my_turncount();
		}
		if (!skip)
			adv1($location[the spooky forest], -1, "");
	}
}