void main()
{
	foreach e in $effects[Polka of Plenty,fat leon's phat loot lyric, ur-kel's aria of annoyance,The Sonata of Sneakiness,Curiosity of Br'er Tarrypin,Empathy,ode to booze,Elemental Saucesphere,Carlweather's Cantata of Confrontation,Astral Shell,Ghostly Shell,Reptilian Fortitude,scarysauce,Cartographically Rooted,Cartographically Charged,Cartographically Aware] //'
	{
		if (e.have_effect() > 0)
			cli_execute("shrug " + e);
	}
}