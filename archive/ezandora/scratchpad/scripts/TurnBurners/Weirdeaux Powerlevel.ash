import "scripts/Library/PrecheckSemirare.ash";

void main()
{
	cli_execute("familiar fancypants scarecrow");
	cli_execute("equip familiar spangly mariachi pants");
	cli_execute("outfit weirdeaux");
	
	while (my_adventures() >= 50)
	{
		if (true && my_level() >= 245)
			break;
		if ($effect[Expert Vacationer].have_effect() == 0)
			cli_execute("up Expert Vacationer");
		precheckSemirare();
		adv1($location[The Mansion of Dr. Weirdeaux], 0, "");
	}
}