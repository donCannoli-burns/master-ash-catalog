void main()
{
	if (pvp_attacks_left() == 0) return;
	cli_execute("call Prepare to PVP.ash");
	cli_execute("call run fights.ash");
}