void doSneakyAdventure(string area)
{		if (have_effect($effect[fresh scent]) == 0)		cli_execute("use 1 chunk of rock salt");	if (have_effect($effect[Smooth Movements]) == 0)		cli_execute("cast smooth movement");	if (have_effect($effect[Sonata of Sneakiness]) == 0)		cli_execute("cast sonata");	cli_execute("adventure 1  " + area);
}

void sneakyAdventure(item target_item, string area)
{
	while (available_amount(target_item) == 0)
	{
		if (available_amount($item[model airship]) != 0)
			cli_execute("set choiceAdventure182 = 1");
		doSneakyAdventure(area);
	}
}


void solveCastleFloors()
{
	if (available_amount($item[S.O.C.K]) == 0)
		return;
	if (!contains_text(visit_url("questlog.php?which=1"), "The Rain on the Plains is Mainly Garbage"))
		return;
	boolean top_floor_available = true;
	boolean ground_floor_available = true;
	//Solve top floor:
	cli_execute("call ../Outfit experience");
	cli_execute("call ../Outfit -combat");
	cli_execute("equip mohawk wig");
	//Top floor:
	cli_execute("set choiceAdventure677 = 1"); //copper feel
	cli_execute("set choiceAdventure675 = 4"); //Melon Collie and the Infinite Lameness
	cli_execute("set choiceAdventure678 = 1"); //Yeah, You're for Me, Punk Rock Giant
	cli_execute("set choiceAdventure676 = 4"); //Flavor of a Raver
	//Ground floor:
	cli_execute("set choiceAdventure672 = 3"); //There's No Ability Like Possibility
	cli_execute("set choiceAdventure673 = 3"); //Putting Off Is Off-Putting
	cli_execute("set choiceAdventure674 = 3"); //Huzzah!
	//Basement:
	cli_execute("set choiceAdventure670 = 4"); //Don't Mess Around with Gym
	cli_execute("set choiceAdventure671 = 4"); //Out in the Open Source
	cli_execute("set choiceAdventure669 = 1"); //The Fast and the Furry-ous
	cli_execute("set choiceAdventure679 = 1"); //Spin that wheel
	while (contains_text(visit_url("questlog.php?which=1"), "The Rain on the Plains is Mainly Garbage"))
	{
		//check if we have access:
		int last_adventures = my_adventures();
		doSneakyAdventure("giant's castle (top floor)");
		if (my_adventures() == last_adventures)
		{
			//Not available
			top_floor_available = false;
			break;
		}
		cli_execute("council.php");
	}

	while (!top_floor_available && ground_floor_available)
	{
		//Unlock top floor:		int last_adventures = my_adventures();
		cli_execute("call Library/switch to stringozzi serpent combat script no runaways.ash");		cli_execute("adventure 1 giant's castle (ground floor)");
		cli_execute("call Library/switch to stringozzi serpent combat script.ash");		if (my_adventures() == last_adventures)		{			//Not available			ground_floor_available = false;		}
		if (ground_floor_available)
		{			//Test top floor:			last_adventures = my_adventures();			doSneakyAdventure("giant's castle (top floor)");			if (my_adventures() != last_adventures)			{
					cli_execute("council.php");				ground_floor_available = true;				top_floor_available = true;			}
				if (!ground_floor_available)
					break;
		}
	}
	if (!ground_floor_available)
	{
		cli_execute("equip 1 amulet of extreme plot significance");
		cli_execute("unequip weapon; equip 1 titanium assault umbrella");
	}
	while (!ground_floor_available)
	{
		//Unlock ground floor:		doSneakyAdventure("giant's castle (basement)");
		//Test ground floor
		int last_adventures = my_adventures();		cli_execute("adventure 1 giant's castle (ground floor)");		if (my_adventures() != last_adventures)		{			//Available			ground_floor_available = true;		}
	}
	cli_execute("set choiceAdventure670 = 5"); // Don't Mess Around with Gym
}

void main()
{
	if (my_level() < 10) return;
	if (get_property("questL10Garbage") == "finished")
		return;
	if (!contains_text(visit_url("questlog.php?which=1"), "The Rain on the Plains is Mainly Garbage"))
	{
		return;
	}

	if (!contains_text(visit_url("place.php?whichplace=plains"), "beanstalk"))
		cli_execute("use enchanted bean");

	
	//The Council of Loathing wants you to investigate the source of the giant garbage raining down on the Nearby Plains.
	if (available_amount($item[S.O.C.K]) == 0)
	{
		//Airship:
		if (available_amount($item[model airship]) == 0)
			cli_execute("set choiceAdventure182 = 0"); //should be 4
		cli_execute("call ../Outfit experience");
		cli_execute("call ../Outfit -combat");
		cli_execute("call Library/UseHipster.ash");
		sneakyAdventure($item[S.O.C.K], "fantasy airship");
	}

	//So what we do here is
	//Try to solve the top floor.
	//If that errors, try to solve the ground floor.
	//If that errors, try to solve the bottom floor.

	//Top failure:
	//Also you can't get to the top floor of a building if you can't get to the ground floor.
	//Ground failure:
	//You climb the stairs from the castle's basement, but the door at the top is closed and you can't find the doorknob.

	solveCastleFloors();
	solveCastleFloors();
	solveCastleFloors();
	

}