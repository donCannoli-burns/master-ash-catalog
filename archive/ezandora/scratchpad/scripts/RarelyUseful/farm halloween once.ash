//outfit halloween; call scripts/RarelyUseful/farm halloween once.ash; outfit mp regen
//ash visit_url("town.php?action=trickortreat"); visit_url("choice.php?whichchoice=804&option=1"); cli_execute("cast * resolutions");

//outfit halloween; call scripts/RarelyUseful/farm halloween once.ash; outfit mp regen; ash visit_url("town.php?action=trickortreat"); visit_url("choice.php?whichchoice=804&option=1"); cli_execute("cast * resolutions");

//ash cli_execute("outfit mp regen"); visit_url("town.php?action=trickortreat"); visit_url("choice.php?whichchoice=804&option=1"); cli_execute("cast * resolutions"); cli_execute("outfit halloween; call scripts/RarelyUseful/farm halloween once.ash;");


//ash while (my_adventures() > 70) { cli_execute("outfit mp regen"); visit_url("town.php?action=trickortreat"); visit_url("choice.php?whichchoice=804&option=1"); cli_execute("cast * resolutions"); cli_execute("outfit halloween; call scripts/RarelyUseful/farm halloween once.ash;"); }


//ash cli_execute("familiar cocoabo; outfit mp regen"); visit_url("town.php?action=trickortreat"); visit_url("choice.php?whichchoice=804&option=1"); cli_execute("cast * resolutions"); cli_execute("outfit halloween; call scripts/RarelyUseful/farm halloween once.ash;"); cli_execute("call scripts/Library/find wandering monster.ash");


//ash while (my_adventures() > 70) { cli_execute("familiar cocoabo; outfit mp regen"); visit_url("town.php?action=trickortreat"); visit_url("choice.php?whichchoice=804&option=1"); cli_execute("cast * resolutions"); cli_execute("outfit halloween; call scripts/RarelyUseful/farm halloween once.ash;"); cli_execute("call scripts/Library/find wandering monster.ash"); cli_execute("call scripts/Library/find wandering monster.ash"); }


//ashq while (my_adventures() > 400) { cli_execute("familiar cocoabo"); visit_url("town.php?action=trickortreat"); visit_url("choice.php?whichchoice=804&option=1"); cli_execute("call scripts/RarelyUseful/farm halloween once.ash;"); }

//ashq while (my_adventures() > 70) { cli_execute("familiar stocking mimic; outfit mp regen"); visit_url("town.php?action=trickortreat"); visit_url("choice.php?whichchoice=804&option=1"); cli_execute("cast * resolutions"); cli_execute("outfit Halloween; call scripts/RarelyUseful/farm halloween once.ash;"); }


//ashq while (my_adventures() > 70) { visit_url("place.php?whichplace=town&action=town_trickortreat", false); visit_url("choice.php?whichchoice=804&option=1"); cli_execute("cast * resolutions"); cli_execute("call scripts/RarelyUseful/farm halloween once.ash;"); }


//ashq while (my_adventures() >= 5) { visit_url("place.php?whichplace=town&action=town_trickortreat", false); visit_url("choice.php?whichchoice=804&option=1"); cli_execute("call scripts/RarelyUseful/farm halloween once.ash;"); }
//ashq while (my_adventures() >= 5) { visit_url("place.php?whichplace=town&action=town_trickortreat", false); visit_url("choice.php?whichchoice=804&option=1"); cli_execute("call scripts/RarelyUseful/farm halloween once.ash;"); adv1($location[the daily dungeon], -1, ""); }
import "scripts/Library/burn familiars.ash"

//mafia :/
void run_combat_replacement()
{
    int breakout = 11;
    while (breakout >= 0)
    {
        buffer page_text = visit_url("main.php");
        if (page_text.contains_text("choice.php"))
        {
            //Evaluate choice:
            cli_execute("choice-goal");
        }
        else
        {
            run_combat();
            break;
        }
        breakout -= 1;
    }
}


void main()
{
	familiar base_familiar = my_familiar();
	//if (get_auto_attack() != 99108225) //halloween
		//set_auto_attack(99108225);
	//cli_execute("mood halloween; mood execute");
	boolean should_reload_town = true;
	for i from 0 to 11
	{
		//burnFamiliars(base_familiar, "not hipster");
    	cli_execute("restore hp");
    	if (should_reload_town)
			visit_url("place.php?whichplace=town&action=town_trickortreat");
		buffer page_text = visit_url("choice.php?whichchoice=804&option=3&whichhouse=" + i);
		if (page_text.contains_text("choice.php") && page_text.contains_text("Click on a house to go Trick-or-Treating!"))
		{
            //cli_execute("choice-goal");
			should_reload_town = false;
		}
		else
			run_combat_replacement();
		//ash visit_url("choice.php?whichchoice=806&option=2");
	}
	cli_execute("familiar " + base_familiar);
	//print("done");
}