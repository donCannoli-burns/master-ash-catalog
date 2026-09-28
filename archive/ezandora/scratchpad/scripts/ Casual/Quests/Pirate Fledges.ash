int responseForText(string text)
{
	//one of these is wrong
	if (contains_text(text, "You attempt to make up for the slip, but it's too late -- your nerve has been broken, and you soon find yourself pushing your way through the crowd, away from the beer pong table and the jeering cat-calls of Old Don Rickets."))
		return 0;

	if (to_boolean(get_property("lastPirateInsult1")) && contains_text(text, "Arrr, the power of me serve'll flay the skin from yer bones!"))
		return 1;
	if (to_boolean(get_property("lastPirateInsult2")) && contains_text(text, "Do ye hear that, ye craven blackguard? It be the sound of yer doom!"))
		return 2;
	if (to_boolean(get_property("lastPirateInsult3")) && contains_text(text, "ye miserable, pestilent wretch!"))
		return 3;
	if (to_boolean(get_property("lastPirateInsult4")) && contains_text(text, "The streets will run red with yer blood when I'm through with ye!"))
		return 4;
	if (to_boolean(get_property("lastPirateInsult5")) && contains_text(text, "Yer face is as foul as that of a drowned goat!"))
		return 5;
	if (to_boolean(get_property("lastPirateInsult6")) && contains_text(text, "When I'm through with ye, ye'll be crying like a little girl!"))
		return 6;
	if (to_boolean(get_property("lastPirateInsult7")) && contains_text(text, "In all my years I've not seen a more loathsome worm than yerself!"))
		return 7;
	if (to_boolean(get_property("lastPirateInsult8")) && contains_text(text, "Not a single man has faced me and lived to tell the tale!"))
		return 8;


	return 9; //default, always available
}

void doInsultBeerPong()
{
	string text = visit_url("adventure.php?snarfblat=157");
	//step up:
	//beerpong.php?response=1
	text = visit_url("choice.php?whichchoice=187&option=1");
	int response = responseForText(text);
	if (response == 0)
		return;
	text = visit_url("beerpong.php?response=" + response);

	response = responseForText(text);
	if (response == 0)
		return;
	text = visit_url("beerpong.php?response=" + response);

	response = responseForText(text);
	if (response == 0)
		return;
	text = visit_url("beerpong.php?response=" + response);
}

int currentInsultCount()
{
	int number = 0;
	if (to_boolean(get_property("lastPirateInsult1")))
		number = number + 1;
	if (to_boolean(get_property("lastPirateInsult2")))
		number = number + 1;
	if (to_boolean(get_property("lastPirateInsult3")))
		number = number + 1;
	if (to_boolean(get_property("lastPirateInsult4")))
		number = number + 1;
	if (to_boolean(get_property("lastPirateInsult5")))
		number = number + 1;
	if (to_boolean(get_property("lastPirateInsult6")))
		number = number + 1;
	if (to_boolean(get_property("lastPirateInsult7")))
		number = number + 1;
	if (to_boolean(get_property("lastPirateInsult8")))
		number = number + 1;
	return number;
}

void main()
{
	if (my_level() < 8) return; //eight is a good time for this
	if (available_amount($item[pirate fledges]) > 0 || equipped_amount($item[pirate fledges]) > 0)
		return;
	cli_execute("call ../Outfit experience");
	cli_execute("outfit swashbuckling getup");

//I Rate, You Rate
//A salty old pirate named Cap'm Caronch has offered to let you join his crew if you find some treasure for him. He gave you a map, which causes you to wonder why he didn't just go dig it up himself, but oh well...

//Cap'm Caronch has given you a set of blueprints to the Orcish Frat House, and asked you to steal his dentures back from the Frat Orcs.
//
//If you are caught or killed, the secretary will disavow any knowledge of your actions.

//You have successfully swiped the Cap'm's teeth from the Frat Orcs -- time to take the nasty things back to him. And then wash your hands.

//You've completed two of Cap'm Caronch's tasks, but (surprise surprise) he's got a third one for you before you can join his crew. Strange how these things always come in threes...

//You have successfully joined Cap'm Caronch's crew! Unfortunately, you've been given crappy scutwork to do before you're a full-fledged pirate.

//choice adventure 188 for infiltration
//choice adventure 187 for stepping up
//don't forget to use cocktail napkins on clingy pirates

	cli_execute("call Library/switch to stringozzi serpent combat script.ash");
	cli_execute("autoattack big book of pirate insults");
	

	if (!contains_text(visit_url("questlog.php?which=1"), "I Rate, You Rate"))
	{
		//Acquire map/quest:
		while (available_amount($item[Cap'm Caronch's Map]) == 0)
			cli_execute("adventure 1 Barrrney's Barrr");
	}
	cli_execute("call ../Outfit +combat"); //each 5% of +combat saves half a turn
	cli_execute("outfit swashbuckling getup");


	if (contains_text(visit_url("questlog.php?which=1"), "A salty old pirate named Cap'm Caronch has offered to let you join his crew if you find some treasure for him. He gave you a map, which causes you to wonder why he didn't just go dig it up himself, but oh well..."))
	{
		//Use map:
		cli_execute("use Cap'm Caronch's Map");
	}

	if (contains_text(visit_url("questlog.php?which=1"), "Now that you've found Cap'm Caronch's booty (and shaken it a few times), you should probably take it back to him."))
	{
		//Take booty back:
		while (available_amount($item[Orcish Frat House blueprints]) == 0)
			cli_execute("adventure 1 Barrrney's Barrr");
	}

	if (contains_text(visit_url("questlog.php?which=1"), "Cap'm Caronch has given you a set of blueprints to the Orcish Frat House, and asked you to steal his dentures back from the Frat Orcs."))
	{
		//Collect insults until we have five or six:
		//five if our combat rate is < 20%, six if it's >= 20%
		//it's optimal™
		cli_execute("call Library/switch to stringozzi serpent combat script no runaways.ash");
		while ((currentInsultCount() < 5 && combat_rate_modifier() < 20.0) || currentInsultCount() < 6 && combat_rate_modifier() >= 20.0)
		{
			cli_execute("adventure 1 Barrrney's Barrr");
			print("At " + currentInsultCount() + " insults.");
		}
		cli_execute("call Library/switch to stringozzi serpent combat script.ash");
		//Use blueprints:
		cli_execute("set choiceAdventure188 = 3");
		cli_execute("acquire 3 hot wing; equip frilly skirt; use orcish frat house blueprints; equip swashbuckling pants");
	}

	if (contains_text(visit_url("questlog.php?which=1"), "You have successfully swiped the Cap'm's teeth from the Frat Orcs -- time to take the nasty things back to him. And then wash your hands."))
	{
		//Take blueprints back:
		cli_execute("adventure 1 Barrrney's Barrr");
	}

	if (contains_text(visit_url("questlog.php?which=1"), "You've completed two of Cap'm Caronch's tasks, but (surprise surprise) he's got a third one for you before you can join his crew. Strange how these things always come in threes..."))
	{
		//Do insults:
		if (currentInsultCount() < 5)
		{
			print("internal error");
			return;
		}
		if (currentInsultCount() >= 5)
		{
			cli_execute("set choiceAdventure187 = 1");
			while (!contains_text(visit_url("questlog.php?which=1"), "You have successfully joined Cap'm Caronch's crew! Unfortunately, you've been given crappy scutwork to do before you're a full-fledged pirate."))
			{
				//tricky
				doInsultBeerPong();
				//cli_execute("adventure 1 Barrrney's Barrr");
			}
		}
	}
	cli_execute("autoattack none");

	if (my_adventures() < 15)
		return;

	if (contains_text(visit_url("questlog.php?which=1"), "You have successfully joined Cap'm Caronch's crew! Unfortunately, you've been given crappy scutwork to do before you're a full-fledged pirate."))
	{
		//Do f'c'le:
		//use item_drop_modifier()
		cli_execute("call ../Outfit items");
		cli_execute("outfit swashbuckling getup");
		cli_execute("unequip stuffed shoulder parrot; equip acc1 stuffed shoulder parrot");
		cli_execute("maximize items -tie -hat -pants -acc1");
		cli_execute("familiar scarecrow; equip familiar spangly mariachi pants");
		cli_execute("cast 2 musk of the moose");
		cli_execute("use 2 resolution: be happier");
		cli_execute("use 2 lavender candy heart");
		cli_execute("ccs casualfcle");
		while (available_amount($item[pirate fledges]) == 0)
		{
			if (item_drop_modifier() < 234.0)
			{
				print("Unable to get modifier high enough.");
				return;
			}
			cli_execute("adventure 1 f'c'le; use * ball polish; use * mizzenmast mop; use * rigging shampoo");
		}
		
		cli_execute("call Library/switch to stringozzi serpent combat script.ash");
		
	}
	


	cli_execute("council.php");
}