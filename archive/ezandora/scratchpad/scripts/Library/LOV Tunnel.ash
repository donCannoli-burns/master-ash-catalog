//LOV Earrings, LOV Epaulettes, or LOV Eardigan
item __equipment_wanted = $item[LOV Earrings]; //earrings for +meat
effect __buff_wanted = $effect[Wandering Eye Surgery]; //+50% item
item __item_to_farm = $item[none]; //None means it'll pick all three equally.

static
{
	int [item] __items_to_choice_ids;
	__items_to_choice_ids[$item[LOV Enamorang]] = 1;
	__items_to_choice_ids[$item[LOV Emotionizer]] = 2;
	__items_to_choice_ids[$item[LOV Extraterrestrial Chocolate]] = 3;
}

void runTunnel(item equipment, effect buff, item gift_item)
{
	string page_text = visit_url("place.php?whichplace=town_wrong&action=townwrong_tunnel");
	if (page_text.contains_text("You've already gone through the Tunnel once today"))
	{
		run_choice(2);
		return;
	}
	run_choice(1);
	run_choice(1);
	visit_url("choice.php");
	if (equipment == $item[LOV Eardigan])
		run_choice(1);
	else if (equipment == $item[LOV Epaulettes])
		run_choice(2);
	else //earrings
		run_choice(3);
	run_choice(1);
	visit_url("choice.php");
	if (buff == $effect[Lovebotamy])
		run_choice(1);
	else if (buff == $effect[Open Heart Surgery])
		run_choice(2);
	else
		run_choice(3);
	run_choice(1);
	visit_url("choice.php");
	run_choice(__items_to_choice_ids[gift_item]);
}


void main()
{
	if (get_property("_loveTunnelUsed").to_boolean())
		return;
	//run init + tiny black hole for pickpocket chance against third
	//abort("Fix this. Run_combat()?");
	familiar previous_familiar = my_familiar();
	if ($familiar[Oily Woim].have_familiar())
		use_familiar($familiar[oily woim]);
	if ($skill[springy fusilli].have_skill() && $effect[springy fusilli].have_effect() == 0)
		cli_execute("cast springy fusilli");
		
	cli_execute("outfit save Backup");
	cli_execute("outfit birthday suit"); //remove attackables?
	
	string maximise_string = "1.0 init 0.01 pickpocket chance -equip helps-you-sleep -tie -equip buddy bjorn"; //avoid bjorn attack
	if (my_primestat() != $stat[moxie])
		maximise_string += " +equip tiny black hole";
	cli_execute("maximize " + maximise_string);
		
	
	
	//Now, which one do we want?
	//LOV Enamorang is an extra copy.
	//LOV Emotionizer is amazing chat effect.
	//LOV Extraterrestrial Chocolate is adventures.
	item chosen_item = $item[none];
	foreach it in $items[LOV Enamorang,LOV Emotionizer,LOV Extraterrestrial Chocolate]
	{
		if (chosen_item == $item[none] || chosen_item.available_amount() > it.available_amount())
			chosen_item = it;
	}
	if (__item_to_farm != $item[none] && __items_to_choice_ids contains __item_to_farm)
		chosen_item = __item_to_farm;
	
	runTunnel(__equipment_wanted, __buff_wanted, chosen_item);
	
	use_familiar(previous_familiar);
	cli_execute("outfit Backup");
}