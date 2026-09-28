void main()
{
	cli_execute("mood none");
	//Food/drink:
	//We use a bottle of pete's sake, and two slick makis.
	if (have_effect($effect[Fishy]) < 20)
	{
		if (!contains_text(visit_url("campground.php?action=inspectkitchen"), "sushi-rolling mat"))
		{
			cli_execute("use sushi-rolling mat");
		}
		int available_drunkness = inebriety_limit() - my_inebriety();
		int available_fullness = fullness_limit() - my_fullness();
		if (available_drunkness >= 3 && available_fullness >= 6)
		{
			cli_execute("uneffect sonata; uneffect carlweather; uneffect phat loot");
			cli_execute("call scripts/Library/CastOde.ash 10");
			cli_execute("drink bottle of pete's sake");
			cli_execute("create 2 slick maki");
			cli_execute("uneffect ode");
		}
	}

	cli_execute("call Sea/Sea Set Sup");
	cli_execute("call Sea/Unlock Mer-Kin Deepcity.ash");
	cli_execute("mood none");
}