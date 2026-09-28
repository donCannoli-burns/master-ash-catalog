boolean [monster] __blocked_monsters = $monsters[hulking construct];

void main()
{
	int breakout = 4;
	cli_execute("call scripts/Library/LoadMonsterManuel.ash");
	if (my_adventures() == 0) return;
	while (get_property("_locketMonstersFought").split_string(",").count() < 3 && breakout > 0)
	{
		boolean [monster] locket_monsters_fought;
		foreach key, monster_id_string in get_property("_locketMonstersFought").split_string(",")
		{
			int monster_id = monster_id_string.to_int();
			monster m = monster_id.to_monster();
			if (m != $monster[none])
				locket_monsters_fought[m] = true;
		}
		breakout -= 1;
		boolean [monster] locket_monsters = get_locket_monsters();
		monster target_monster = $monster[none];
		foreach m in locket_monsters
		{
			if (locket_monsters_fought[m]) continue;
			if (__blocked_monsters[m]) continue;
			if (monster_factoids_available(m, true) < 3)
			{
				target_monster = m;
				break;
			}
		}
		if (target_monster == $monster[none])
		{
			return;
		}
		print_html("Reminisce " + target_monster + " for factoids");
		cli_execute("reminisce " + target_monster);
		print_html("visiting main.php");
		visit_url("main.php");
		print_html("running combat");
		run_combat();
		print_html("now what?");
		monster_factoids_available(target_monster, false); //reload because mafia will set this back to zero (?)
	}
}