void openATSongSlot(int desired_slots_open, boolean [skill] songs_to_keep)
{
	skill [int] songs;
	foreach s in $skills[]
	{
		if (!s.buff || s.class != $class[Accordion Thief]) continue;
		songs[songs.count()] = s;
	}
	
	
	skill [int] songs_active;
	foreach key, song in songs
	{
		effect e = song.to_effect();
		if (e.have_effect() > 0)
		{
			songs_active[songs_active.count()] = song;
		}
	}
	int song_limit = 3;
	if (have_skill($skill[Mariachi Memory]))
		song_limit = 4;
	int breakout = 10;
	sort songs_active by value.to_effect().have_effect();
	while (breakout > 0 && songs_active.count() + desired_slots_open > song_limit && songs_active.count() > 0)
	{
		breakout -= 1;
		//remove the one we have the least turns of:
		foreach key, song in songs_active
		{
			if (songs_to_keep[song]) continue;
			cli_execute("shrug " + song.to_effect());
			remove songs_active[key];
			break;
		}
	}
	//print("You have " + songs_active + " songs active. Lowest is " + min_song + " with " + min_song_amount + " turns.");
}