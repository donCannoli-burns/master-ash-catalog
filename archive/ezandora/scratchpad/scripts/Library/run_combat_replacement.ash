import "Destiny Ascension/Destiny Ascension/Support/Library.ash";

/*void run_combat_replacement()
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
}*/

void main()
{
	run_combat_replacement();
}