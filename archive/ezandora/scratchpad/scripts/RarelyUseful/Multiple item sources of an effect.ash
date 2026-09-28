void main()
{
	item [effect][int] defined;
	foreach it in $items[]
	{
		effect e = it.effect_modifier("effect");
		if (it.spleen > 0 || it.fullness > 0 || it.inebriety > 0) continue;
		if (e == $effect[none]) continue;
		if (!(defined contains e))
		{
			defined[e][0] = it;
			continue;
		}
		else
		{
			defined[e][defined[e].count()] = it;
		}
	}
	foreach e in defined
	{
		if (defined[e].count() < 2)
			continue;
			
		string line = "Effect " + e + " has multiple sources: ";
		boolean first = true;
		foreach key, it in defined[e]
		{
			if (first)
				first = false;
			else
				line += ", ";
			line += it;
		}
		print(line);
	}
}