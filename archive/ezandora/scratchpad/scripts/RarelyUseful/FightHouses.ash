void main()
{
	while (true)
	{
		string fight_text = visit_url("main.php");
		if (!fight_text.contains_text("You're fighting"))
		{
			print_html("Not fighting. text is: " + fight_text.entity_encode());
			break;
		}
		if (fight_text.contains_text("Breath: 0/"))
		{
			print_html("huff");
			//huff
			fight_text = visit_url("fight.php?whichskill=7190&action=skill");
		}
		else
		{
			print_html("puff");
			//puff
			fight_text = visit_url("fight.php?whichskill=7191&action=skill");
		}
	}
	print_html("done");
}