
int freeRunawaysRemaining()
{
	int current_runaways = to_int(get_property("_banderRunaways"));
	int available_runaways = (weight_adjustment() + familiar_weight($familiar[stomping boots])) / 5;
	if (current_runaways >= available_runaways)
		return 0;
	return available_runaways - current_runaways;
}

void doFreeRunawayAdventure(string area)
{
	cli_execute("familiar stomping boots");
	cli_execute("maximize familiar weight -tie");
	if (have_effect($effect[Heavy Petting]) == 0)
		cli_execute("use knob goblin pet-buffing spray");
	if (freeRunawaysRemaining() == 0)
	{
		cli_execute("call ../Outfit experience");
	}
	else
	{
		cli_execute("autoattack runaway");
	}

	cli_execute("adventure 1 " + area);
	cli_execute("autoattack none");
}

void main()
{
	if (my_level() < 5) return;
	if (get_property("questL05Goblin") == "finished")
		return;

	if (!contains_text(visit_url("questlog.php?which=1"), "The Goblin Who Wouldn't Be King"))
		return;

	cli_execute("call ../Outfit experience");
	cli_execute("call Library/UseHipster.ash");
	cli_execute("call Library/switch to cannelloni combat script.ash");
	//Unlock area:
	if (available_amount($item[Cobb's Knob Map]) > 0)
	{
		//Acquire encryption key:
		while (available_amount($item[Knob Goblin encryption key]) == 0)
			//doFreeRunawayAdventure("outskirts of the knob");
			cli_execute("adventure 1 outskirts of the knob");
		cli_execute("use Cobb's Knob Map");
	}
	cli_execute("call ../Outfit experience");
	//FARQUAR
	if (to_int(get_property("lastDispensaryOpen")) < my_ascensions())
	{
		cli_execute("outfit Knob Goblin Elite Guard Uniform");
		cli_execute("adventure 1 Cobb's Knob Barracks");
	}
	//King:
	cli_execute("outfit Knob Goblin Harem Girl Disguise");
	cli_execute("use Knob Goblin Perfume; use CSA bravery badge; use fish-liver oil");
	cli_execute("mcd 3");
	cli_execute("restore hp");
	cli_execute("adventure 1 throne room");
	cli_execute("mcd 10");
	cli_execute("call ../Outfit experience");

	cli_execute("council.php");
}