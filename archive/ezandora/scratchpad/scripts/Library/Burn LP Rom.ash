void castLPROMSkill(skill s, int times)
{
	if (!have_skill(s))
		return;
	if (my_maxmp() < mp_cost(s))
		return;
	if (mp_cost(s) > my_mp())
		restore_mp(mp_cost(s));
	visit_url("campground.php?action=lprom");
	visit_url("choice.php?whicheffect=" + (s.to_effect().to_int()) + "&times=" + times + "&whichchoice=821&option=1");
}

void main()
{
	if (get_campground()[$item[warbear LP-ROM burner]] == 0)
		return;
	if (have_skill($skill[Inigo's Incantation of Inspiration])) //'
	{
		while (get_property("_inigosCasts").to_int() < 5)
			castLPROMSkill($skill[Inigo's Incantation of Inspiration], 1); //'
	}
	if (my_class() == $class[accordion thief])
	{
		//FIXME add this
	}
}