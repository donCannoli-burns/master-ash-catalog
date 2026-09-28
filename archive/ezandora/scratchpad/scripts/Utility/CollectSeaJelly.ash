void main()
{
	if (my_level() < 11)
	{
		print("You need to be level eleven first.", "red");
		return;
	}
	if (!$familiar[space jellyfish].have_familiar())
	{
		print("You don't seem to have a Space Jellyfish. Check SR388.", "red");
		return;
	}
	visit_url("place.php?whichplace=sea_oldman&action=oldman_oldman");
	familiar old_familiar = my_familiar();
	use_familiar($familiar[space jellyfish]);
	visit_url("place.php?whichplace=thesea&action=thesea_left2");
	visit_url("choice.php?whichchoice=1219&&option=1");
	use_familiar(old_familiar);
}