skill [int] activeATSongs()
{
	skill [int] active_songs;
	foreach s in $skills[]
	{
		if (s.class == $class[accordion thief] && s.buff == true && s.to_effect().have_effect() > 0) //FIXME is this test always correct?
		{
			active_songs[active_songs.count()] = s;
		}
	}
	return active_songs;
}

void castATSong(skill at_song_to_cast, int turns_wanted)
{
	if (at_song_to_cast.to_effect().have_effect() >= turns_wanted)
		return;
	//FIXME buy a toy accordion if we don't have a usable accordion?
	
	if (at_song_to_cast.to_effect().have_effect() == 0)
	{
		int at_song_limit = 3;
		if ($item[plexiglass pendant].equipped_amount() > 0 || $item[Brimstone Beret].equipped_amount() > 0 || $item[super-sweet boom box].equipped_amount() > 0 || $item[Scandalously Skimpy Bikini].equipped_amount() > 0 || $item[Sombrero De Vida].equipped_amount() > 0 || (my_class() == $class[accordion thief] && $item[Operation Patriot Shield].equipped_amount() > 0))
			at_song_limit += 1;
		if (my_class() == $class[accordion thief] && $item[La Hebilla del Cintur&oacute;n de Lopez].equipped_amount() > 0)
			at_song_limit += 1;
		if (my_class() == $class[accordion thief] && $item[zombie accordion].equipped_amount() > 0)
			at_song_limit += 1;
		if ($skill[mariachi memory].have_skill())
			at_song_limit += 1;

		skill [int] active_songs = activeATSongs();
		int breakout = 100;
		while (active_songs.count() + 1 > at_song_limit && breakout > 0)
		{
			breakout -= 1;
			//Remove the song that costs the least MP to replace:
			skill song_to_remove = $skill[none];
			foreach key, song in active_songs
			{
				if (song_to_remove == $skill[none] || song_to_remove.mp_cost() * song_to_remove.to_effect().have_effect() > song.mp_cost() * song.to_effect().have_effect())
					song_to_remove = song;
			}
			if (song_to_remove == $skill[none])
				break;
			cli_execute("uneffect " + song_to_remove.to_effect());
			active_songs = activeATSongs(); //there are certain situations where your active song count can go higher than you can currently cast, so double-check
		}
	}
	
	int breakout = 100;
	int casts = ceil((turns_wanted - at_song_to_cast.to_effect().have_effect()).to_float() / at_song_to_cast.turns_per_cast().to_float());
	if (casts > 0)
		use_skill(casts, at_song_to_cast);
}

void main()
{
	castATSong($skill[the ode to booze], 20);
}