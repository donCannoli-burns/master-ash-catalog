
void main()
{
	if (my_level() < 4) return;
	if (get_property("questL04Bat") == "finished")
		return;

	if (!contains_text(visit_url("questlog.php?which=1"), "Ooh, I Think I Smell a Bat"))
		return;
	cli_execute("call ../Outfit experience");
	cli_execute("call Library/switch to cannelloni combat script.ash");
	cli_execute("use 3 sonar-in-a");
	cli_execute("mcd 8");
	while (available_amount($item[boss bat bandana]) == 0)
		cli_execute("adventure 1 boss bat's lair");

	cli_execute("mcd 10");
	cli_execute("council.php");
}