void main()
{
	string area = "";
	if (my_class() == $class[Seal Clubber] || my_class() == $class[Turtle Tamer])
		area = "Haunted Gallery";
	if (my_class() == $class[Pastamancer] || my_class() == $class[Sauceror])
		area = "Haunted Bathroom";
	if (my_class() == $class[Disco Bandit] || my_class() == $class[Accordion Thief])
		area = "Haunted Ballroom";
	int base_level = my_level();
	string old_clover_protect = get_property("cloverProtectActive"); 
	set_property("cloverProtectActive", "false");
	while (my_level() == base_level)
	{
		cli_execute("acquire ten-leaf clover; adventure 1 " + area);
	}
	set_property("cloverProtectActive", old_clover_protect);
	print("At level " + my_level());

}