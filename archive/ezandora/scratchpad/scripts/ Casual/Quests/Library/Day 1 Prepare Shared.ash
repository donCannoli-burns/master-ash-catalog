void main()
{
	if (to_boolean(get_property("__user_casual_ascension_use_tatters")))
	{			/*if (available_amount($item[drum of pomade]) == 0)		{			print("buy a drum of pomade");			return;		}
		if (available_amount($item[Essential soy]) == 0)
		{			print("buy an essential soy");			return;
		}		if (available_amount($item[d4]) < 100)		{			print("You'll have to acquire 100 D4s first. If you're sure...");			return;		}*/
	}
	if (have_effect($effect[aloysius' antiphon of aptitude]) == 0 && !to_boolean(get_property("__user_casual_ascension_use_tatters")))
	{
		print("acquire aloysius' antiphon of aptitude from a buff bot, then run this again");
		return;
	}
	//cast a single instance of all the spells to save MP
	cli_execute("counters clear"); //clear semi-rare counter
	cli_execute("set hpAutoRecovery=0.9");
	cli_execute("set hpAutoRecoveryTarget=1.0");
	cli_execute("set mpAutoRecovery=0.5");
	cli_execute("set mpAutoRecoveryTarget=0.9");
	cli_execute("set relayMaintainsHealth = true");
	cli_execute("set relayMaintainsMana = true");
	cli_execute("set relayMaintainsEffects = true");

	cli_execute("breakfast");
	//cli_execute("refresh inventory");

	cli_execute("acquire unbearable light");
	cli_execute("acquire crystal skull");
	cli_execute("acquire 40 gob of wet hair");

	cli_execute("acquire 40 fetid feather");
	cli_execute("acquire 40 flaming feather");
	cli_execute("acquire 40 flirtatious feather");
	cli_execute("acquire 40 frightful feather");
	cli_execute("acquire 40 frozen feather");

	cli_execute("acquire 40 dance card");
	cli_execute("acquire 11 tattered scrap of paper");
	cli_execute("acquire 3 green smoke bomb");
	cli_execute("acquire 7 pufferfish spine");
	cli_execute("acquire 5 bus pass");
	cli_execute("acquire 5 imp air");
	cli_execute("acquire jar of oil");
	cli_execute("acquire skeletal skiff");
	cli_execute("acquire bitchin' meat car");
	cli_execute("acquire 3 drum machine");
	cli_execute("acquire 100 gyroscope");
	cli_execute("acquire bottle of pete's sake; acquire 5 slick fish meat; acquire 5 white rice; acquire 5 seaweed");

	cli_execute("main.php");
	//pull hobo code binder
	cli_execute("swim item");

	cli_execute("council.php");
	cli_execute("tutorial.php?action=toot");

	cli_execute("use letter from King Ralph XI");
	cli_execute("use pork elf goodies sack");

	cli_execute("use Newbiesport");
	cli_execute("call scripts/ Immediates/Do Free Dailies");

	cli_execute("use * carton of astral energy drinks");


	if (available_amount($item[astral shirt]) > 0)
		cli_execute("equip astral shirt");
	if (available_amount($item[astral belt]) > 0)
		cli_execute("equip astral belt");
	cli_execute("familiar scarecrow");
	cli_execute("maximize exp -tie");
	cli_execute("equip familiar pin-strip slacks");
	cli_execute("use meat maid");


	//acquire level 1 quest, which we may do first:
	cli_execute("guild.php?place=challenge");
	//artist quest, maybe? this gives us a pail, at the "cost" of 3 adventures in areas that are awful anyways:
	cli_execute("town_wrong.php?place=artist&getquest=1");

	cli_execute("acquire 3 can of black paint");
	cli_execute("acquire 3 drum machine");

	cli_execute("mcd 10");

	cli_execute("bhh.php?action=takebounty&whichitem=2106");
	cli_execute("forestvillage.php?action=mystic;choice.php?whichchoice=664&option=1;choice.php?whichchoice=664&option=1;choice.php?whichchoice=664&option=1");

	cli_execute("buy time's arrow; kmail time's arrow to kbay");

	//cli_execute("acquire 40 crayon shavings");
	cli_execute("acquire 3 sea lasso");
	cli_execute("acquire 3 sea cowbell");
	cli_execute("acquire pulled yellow taffy");
	cli_execute("acquire 9 tomb ratchet");
	cli_execute("acquire 15 volcanic ash");
	cli_execute("acquire bricko ooze");	cli_execute("acquire wet stunt nut stew");	cli_execute("equip disco mask");


	if (to_boolean(get_property("__user_casual_ascension_use_tatters")))
		cli_execute("mood casual-no-experience; shower muscle");	else if (my_class() == $class[Seal Clubber] || my_class() == $class[Turtle Tamer])		cli_execute("mood casual-muscle; shower muscle");	else if (my_class() == $class[Pastamancer] || my_class() == $class[Sauceror])		cli_execute("mood casual-myst; shower myst");	else if (my_class() == $class[Disco Bandit] || my_class() == $class[Accordion Thief])		cli_execute("mood casual-moxie; shower moxie");
	cli_execute("cast magical");
	cli_execute("cast 1 drescher's annoying noise; cast 1 ur-kel's aria of annoyance; cast 1 empathy; cast 1 leash");	cli_execute("mood execute");

	if (to_boolean(get_property("__user_casual_ascension_use_tatters")))
	{
		//fight kobolds		cli_execute("acquire 100 gyroscope; acquire 2 pufferfish spine");
		print("You should use 100 d4s and fight some kobolds. Be sure to use all the stat buffs - there's a lot!", "red");		/*cli_execute("ccs casual fight kobolds");
		//Use +moxie/muscle/myst item:
		if (my_class() == $class[Seal Clubber] || my_class() == $class[Turtle Tamer])			cli_execute("use Baobab sap");		if (my_class() == $class[Pastamancer] || my_class() == $class[Sauceror])			cli_execute("use desktop zen garden; use essential soy");		if (my_class() == $class[Disco Bandit] || my_class() == $class[Accordion Thief])			cli_execute("use Marvin's marvelous pill; use drum of pomade");
		cli_execute("use honey stick");
		cli_execute("use 100 d4");*/
	}
	else
	{			cli_execute("use ant agonist");		cli_execute("use swabbie");		cli_execute("pool 3");		cli_execute("use upsy daisy");		cli_execute("use crimbo fudge");		cli_execute("use angry farmer candy");		cli_execute("use 2 marzipan skull");		cli_execute("equip costume sword");		cli_execute("unequip silent beret");				cli_execute("faxbot merkin");		cli_execute("ccs casual opener");		if (available_amount($item[photocopied monster]) > 0)			cli_execute("use photocopied monster");		if (available_amount($item[Spooky Putty monster]) > 0)			cli_execute("use Spooky Putty monster");		if (available_amount($item[Spooky Putty monster]) > 0)			cli_execute("use Spooky Putty monster");		if (available_amount($item[Spooky Putty monster]) > 0)			cli_execute("use Spooky Putty monster");		if (available_amount($item[Spooky Putty monster]) > 0)			cli_execute("use Spooky Putty monster");		cli_execute("ccs casual opener final");		if (available_amount($item[Spooky Putty monster]) > 0)			cli_execute("use Spooky Putty monster");
	}


	cli_execute("call switch to cannelloni combat script.ash");

	cli_execute("uneffect Magical Mojomuscular Melody");

	cli_execute("call Outfit experience");
	cli_execute("main.php");
	print("done");
	if (available_amount($item[mer-kin lockkey]) > 0)
	{
		set_property("__user_lockkey_dropped_from", to_string(last_monster()));
		set_property("__user_lockkey_dropped_from_ascension", to_string(my_ascensions()));
		print("We found a lockkey from the raider. Remember this for the tent.");
	}
}