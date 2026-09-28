void main()
{
	if (my_level() < 3) return;
	if (get_property("questL03Rat") == "finished")
		return;

	if (!contains_text(visit_url("questlog.php?which=1"), "Ooh, I Think I Smell a Rat"))
		return;

	cli_execute("call Library/switch to cannelloni combat script.ash");
	cli_execute("call ../Outfit experience");

	cli_execute("tavern.php?place=barkeep");

	while (contains_text(visit_url("questlog.php?which=1"), "Ooh, I Think I Smell a Rat"))
	{
		cli_execute("adventure 1 tavern cellar");
		cli_execute("tavern.php?place=barkeep");
		cli_execute("council.php");
	}
	//cli_execute("echo you'll have to do the tavern cellar on your own");
}