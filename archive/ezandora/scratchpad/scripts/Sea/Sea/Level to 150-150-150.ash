void powerlevelUntilStatReaches(stat whichstat, int limit)
{
	if (my_basestat(whichstat) >= limit)
		return;
	cli_execute("acquire 40 disassembled clover");
	string area = "";
	if (whichstat == $stat[muscle])
	{
		area = "Haunted Gallery";
		cli_execute("call Library/unlock haunted gallery.ash");
	}
	else if (whichstat == $stat[mysticality])
		area = "Haunted Bathroom";
	else if (whichstat == $stat[moxie])
		area = "Haunted Ballroom";
	string old_clover_protect = get_property("cloverProtectActive"); 
	set_property("cloverProtectActive", "false");
	while (my_basestat(whichstat) < limit)
	{
		cli_execute("acquire ten-leaf clover; adventure 1 " + area);
	}
	set_property("cloverProtectActive", old_clover_protect);
}

void main()
{
	powerlevelUntilStatReaches($stat[mysticality], 150);
	powerlevelUntilStatReaches($stat[moxie], 150);
	powerlevelUntilStatReaches($stat[muscle], 150);
}