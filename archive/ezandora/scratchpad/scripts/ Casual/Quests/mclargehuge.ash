void main()
{
	if (my_level() < 8) return;
	if (get_property("questL08Trapper") == "finished")
		return;
	if (!contains_text(visit_url("questlog.php?which=1"), "Am I My Trapper's Keeper?"))
		return;
	cli_execute("acquire 3 goat cheese; acquire 3 asbestos ore; acquire 3 chrome ore; acquire 3 linoleum ore");
	cli_execute("place.php?whichplace=mclargehuge&action=trappercabin");
	cli_execute("place.php?whichplace=mclargehuge&action=trappercabin");
	cli_execute("call scripts/Zone Prepares/Icy Peak Resistance");
	cli_execute("place.php?whichplace=mclargehuge&action=cloudypeak");

	cli_execute("call ../Outfit experience");

	cli_execute("restore hp; restore mp");
	cli_execute("place.php?whichplace=mclargehuge&action=cloudypeak2");
	run_combat();

	cli_execute("restore hp; restore mp");
	cli_execute("place.php?whichplace=mclargehuge&action=cloudypeak2");
	run_combat();

	cli_execute("restore hp; restore mp");
	cli_execute("place.php?whichplace=mclargehuge&action=cloudypeak2");
	run_combat();

	cli_execute("restore hp; restore mp");
	cli_execute("place.php?whichplace=mclargehuge&action=cloudypeak2");
	run_combat();

	cli_execute("place.php?whichplace=mclargehuge&action=trappercabin");

	cli_execute("council.php");

	cli_execute("closet put * fuzzy montera");
}