void main(int max_attempts)
{
	boolean first = true;
	int attempts = 0;
	while (my_adventures() > 0 && !get_property("_superduperheatedMetalDropped").to_boolean() && ($item[heat-resistant sheet metal].mall_price() <= 1000 || $item[heat-resistant sheet metal].available_amount() >= 5) && attempts < max_attempts)
	{
		attempts += 1;
		if (first)
		{
			string maximize_command = "maximize muscle -tie";
			if (inebriety_limit() - my_inebriety() < 0)
				maximize_command += " +equip drunkula's wineglass";
			cli_execute(maximize_command);
			first = false;
		}
		if (get_property("_hipsterAdv").to_int() < 7)
			cli_execute("familiar artistic goth kid");
		else
			cli_execute("familiar intergnat");
		cli_execute("closet take * heat-resistant sheet metal");
		if ($item[heat-resistant sheet metal].item_amount() <= 1)
			cli_execute("acquire 5 heat-resistant sheet metal");
		int metal_before = $item[superduperheated metal].item_amount();
		adv1($location[The Bubblin' Caldera], 0, ""); //'
		if ($item[superduperheated metal].item_amount() > metal_before)
		{
			set_property("_superduperheatedMetalDropped", true);
			break;
		}
	}
	cli_execute("uneffect drenched in lava");
	
	if (hippy_stone_broken())
		cli_execute("closet put * superduperheated metal");
}