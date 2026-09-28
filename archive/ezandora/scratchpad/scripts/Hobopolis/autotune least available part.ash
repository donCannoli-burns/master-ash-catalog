skill [string] hoboskill;

hoboskill["hot"] = $skill[Spirit of Cayenne];
hoboskill["cold"] = $skill[Spirit of Peppermint];
hoboskill["stench"] = $skill[Spirit of Garlic];
hoboskill["spooky"] = $skill[Spirit of Wormwood];
hoboskill["sleaze"] = $skill[Spirit of Bacon Grease];
hoboskill["phys"] = $skill[Spirit of Nothing];


string [string] hobo_parts_description;

hobo_parts_description["hot"] = "charred hobo boots (hot)";
hobo_parts_description["cold"] = "frozen hobo eyes (cold)";
hobo_parts_description["stench"] = "stinking hobo guts (stench)";
hobo_parts_description["spooky"] = "creepy hobo skull (spooky)";
hobo_parts_description["sleaze"] = "hobo crotches (sleaze)";
hobo_parts_description["phys"] =  "hobo skins (physical)";


string [string] hobo_colors;

hobo_colors["hot"] = "red";
hobo_colors["cold"] = "blue";
hobo_colors["stench"] = "green";
hobo_colors["spooky"] = "gray";
hobo_colors["sleaze"] = "purple";
hobo_colors["phys"] =  "black";
void main()
{
        int [string] hoboparts;
        string strategy = "";
        int best = 16777216;
        skill desired_skill;

        string richard = visit_url(
            "clan_hobopolis.php?place=3&action=talkrichard&whichtalk=3");

        if (!contains_text(richard, "bring me enough hobo bits"))
                abort("You don't appear to have Town Square access.");

	if (!have_skill($skill[Flavour of Magic]))
		abort("You don't have flavour of magic, can't auto-tune.");

        richard = replace_string(richard, "<b>", "");
        richard = replace_string(richard, "</b>", "");
        string [int, int] t;
        t = group_string(richard, "has (\\d+) pairs? of charred");
        hoboparts["hot"] = to_int(t[0][1]);
        t = group_string(richard, "has (\\d+) pairs? of frozen");
        hoboparts["cold"] = to_int(t[0][1]);
        t = group_string(richard, "has (\\d+) piles? of stinking");
        hoboparts["stench"] = to_int(t[0][1]);
        t = group_string(richard, "has (\\d+) creepy");
        hoboparts["spooky"] = to_int(t[0][1]);
        t = group_string(richard, "has (\\d+) hobo crotch");
        hoboparts["sleaze"] = to_int(t[0][1]);
        t = group_string(richard, "has (\\d+) hobo skin");
        hoboparts["phys"] = to_int(t[0][1]);

	int maximum_parts = 0;
        foreach i in hoboparts
        {
                int n = hoboparts[i];

                if (n < best)
                {
                        strategy = i;
                        best = n;
                }
		if (n > maximum_parts)
			maximum_parts = n;
        }
	if (strategy == "")
		abort("Internal script error.");

        desired_skill = hoboskill[strategy];
        use_skill(1, desired_skill);
	print("Current collection: Hot-" + hoboparts["hot"] + ", Cold-" + hoboparts["cold"]+ ", Stench-" + hoboparts["stench"] + ", Spooky-" + hoboparts["spooky"] + ", Sleaze-" + hoboparts["sleaze"] + ", Physical-" + hoboparts["phys"] + " (min: " + best + ", max: " + maximum_parts + ")");

	string output_color = hobo_colors[strategy];
	//print("Target hobo part: " + hobo_parts_description[strategy] + " (" + best + " available)", output_color);
	print_html("<font color=" + output_color + ">Target hobo part: <bold>" + hobo_parts_description[strategy] + "</bold> (" + best + " available)</font>");
}