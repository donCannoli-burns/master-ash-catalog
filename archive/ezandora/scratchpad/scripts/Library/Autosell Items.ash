//Autosells items from Mr. Screege's spectacles
void main()
{
	if (my_path() == "Way of the Surprising Fist")
		return;
	
	int meat_before = my_meat();
	
	foreach it in $items[ancient vinyl coin purse, duct tape wallet, fat wallet, old coin purse, old leather wallet, pixel coin, pixellated moneybag, shiny stones, solid gold jewel, stolen meatpouch]
	{
		//Use:
		if (it.item_amount() < it.available_amount())
			retrieve_item(it.available_amount(), it);
		if (it.available_amount() == 0)
			continue;
			
		string additional_output;
		if (it.multi)
			additional_output += " (multi-use)";
		print("Use " + it.available_amount() + " " + it + additional_output);
		if (it.multi)
		{
			use(it.item_amount(), it);
		}
		else
		{
			while (it.item_amount() > 0)
				use(1, it);
		}
	}
	foreach it in $items[1952 Mickey Mantle card, decomposed boot, dollar-sign bag, half of a gold tooth, huge gold coin, leather bookmark, massive gemstone, pile of gold coins]
	{
		//Autosell:
		if (it.item_amount() < it.available_amount())
			retrieve_item(it.available_amount(), it);
		if (it.available_amount() == 0)
			continue;
		print("Autosell " + it.available_amount() + " " + it);
		autosell(it.item_amount(), it);
	}
	
	
	int meat_after = my_meat();
	
	if (meat_after > meat_before)
	{
		int delta = meat_after - meat_before;
		print("Earned " + delta + " meat.");
	}
}