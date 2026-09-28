//Times tried:
//30 adventures, 5 distention pills, 5 synthetic dog hairs.

void main()
{
	cli_execute("mood itemfinder-very-simple");
	
	cli_execute("mood execute");	cli_execute("familiar scarecrow");
	cli_execute("call Library/equip item gear.ash");
	if (have_effect($effect[Transpondent]) == 0)
		cli_execute("use transporter transponder");	cli_execute("autoattack none");


	//buy wrecked generators:
	int generator_count = available_amount($item[Wrecked Generator]);
	int purchasable_amount = available_amount($item[lunar isotope]) / 100;
	int wanted_amount = 50;
	if (wanted_amount > purchasable_amount)
		wanted_amount = purchasable_amount;
	int amount_to_purchase = wanted_amount - generator_count;
	if (amount_to_purchase > 0 && is_accessible($coinmaster[lunar lunch-o-mat]))
	{
		print("Purchasing " + amount_to_purchase + " wrecked generators...");
		buy($coinmaster[lunar lunch-o-mat], amount_to_purchase, $item[wrecked generator]);
	}
	

	//choiceAdventure536
	//1 -> distention pill
	//2 -> synthetic dog hair
	while (have_effect($effect[Transpondent]) != 0 && my_adventures() > 0)
	{
		if (available_amount($item[Map to Safety Shelter Grimace Prime]) > 0)
		{			cli_execute("set choiceAdventure536 = 2"); //get hair
			cli_execute("use Map to Safety Shelter Grimace Prime");
		}
		else
			cli_execute("adventure 1 domed city of grimacia");
	}
}