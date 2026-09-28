import "scripts/Library/OpenATSongSlotLibrary.ash";

void castOde(int min_turns)
{
	if (have_effect($effect[ode to booze]) >= min_turns)
		return;
	if (!$skill[the ode to booze].have_skill())
		return;
	
	boolean want_cast_mmm = my_maxmp() < 50 && $skill[The Magical Mojomuscular Melody].have_skill() && $effect[The Magical Mojomuscular Melody].have_effect() == 0;

	if (have_effect($effect[ode to booze]) == 0)
	{
		int slots_wanted = 1;
		if (want_cast_mmm)
			slots_wanted = 2;
		openATSongSlot(slots_wanted, $skills[The Ode to Booze,The Magical Mojomuscular Melody]);
	}

	int iteration = 0;
	while ($effect[ode to booze].have_effect() < min_turns && iteration < 10)
	{
		iteration += 1;
		if (want_cast_mmm && $effect[The Magical Mojomuscular Melody].have_effect() == 0)
			use_skill(1, $skill[The Magical Mojomuscular Melody]);
		use_skill(1, $skill[The Ode to Booze]);
	}
}