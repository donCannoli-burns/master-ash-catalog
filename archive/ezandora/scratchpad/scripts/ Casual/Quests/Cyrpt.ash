void main()
{
	if (my_level() < 7) return;
	if (get_property("questL07Cyrptic") == "finished")
		return;

	if (!contains_text(visit_url("questlog.php?which=1"), "Cyrptic Emanations"))
		return;
	if (my_basestat($stat[mysticality]) < 25) //need ring of conflict
		return;

	cli_execute("call Library/switch to cannelloni combat script.ash");


	if (to_int(get_property("cyrptCrannyEvilness")) > 0)
	{
		cli_execute("call ../Outfit experience");
		cli_execute("set choiceAdventure523 = 4");
		cli_execute("call ../Outfit -combat");
		cli_execute("adventure * defiled cranny");
	}
	
	if (my_adventures() < 30) return;
	if (to_int(get_property("cyrptAlcoveEvilness")) > 0)
	{
		cli_execute("maximize init -tie; use ant agonist; use swabbie");
		cli_execute("adventure * defiled alcove");
		cli_execute("call ../Outfit experience");
	}
	if (my_adventures() < 30) return;


	if (to_int(get_property("cyrptNicheEvilness")) > 0)
	{
		cli_execute("ccs niche");
		cli_execute("adventure * defiled niche");
	}
	if (my_adventures() < 30) return;

	cli_execute("call Library/switch to cannelloni combat script.ash");

	if (to_int(get_property("cyrptNookEvilness")) > 0)
	{
		cli_execute("call ../Outfit items");
		cli_execute("adventure * defiled nook");
	}
	if (my_adventures() < 30) return;
	

	if (to_int(get_property("cyrptTotalEvilness")) == 0)
	{
		cli_execute("call Library/switch to stringozzi serpent combat script.ash");
		cli_execute("call ../Outfit experience");
		cli_execute("maximize hp -tie");
		cli_execute("restore hp; restore mp");
		cli_execute("crypt.php?action=heart");
		cli_execute("choice.php?whichchoice=527&option=1");
		run_combat();
		cli_execute("use chest of the bonerdagon");
	}
	cli_execute("call ../Outfit experience");

	cli_execute("council.php");
}