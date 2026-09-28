void main()
{
	if (!to_boolean(get_property("_borrowedTimeUsed")))
		cli_execute("use borrowed time");
	cli_execute("buy time's arrow; kmail time's arrow to kbay");
	#consume spleen:	if (spleen_limit() - my_spleen_use() == 15 && my_level() >= 11)	{		//spleen:		cli_execute("chew astral energy drink; use mojo filter; chew astral energy drink");	}
	
	int available_fullness = fullness_limit() - my_fullness();
	if (available_fullness == 15 && (my_level() >= 10))
	{
		cli_execute("use potion of the field gar");
		if (have_effect($effect[Gar-ish]) == 0)
		{
			print("*********** can't eat yet, it's still monday ***********", "red");
		}
		else
		{
			cli_execute("use milk of magnesium");
			if (available_amount($item[gnat lasagna]) == 0)
			{
				cli_execute("buy 3 gnat lasagna");
			}
			cli_execute("eat 3 gnat lasagna");
		}
	}

	
	#consume drunk:	int available_drunkness = inebriety_limit() - my_inebriety();	if (available_drunkness == 19)
	{
		if (available_amount($item[wrecked generator]) <3 )
		{
			print("You need more wrecked generators", "red");
			return;
		}
		cli_execute("buy 300 lunar isotope");
		cli_execute("call scripts/Library/CastOde.ash 20");
		cli_execute("drink 3 wrecked generator");
		cli_execute("drink 1 pumpkin beer");
		cli_execute("uneffect ode");
	}

}