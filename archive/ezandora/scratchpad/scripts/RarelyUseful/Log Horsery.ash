void main()
{
	//string [int][int] matches = visit_url("place.php?whichplace=town_right&action=town_horsery").group_string("<b>(.*?)</b>");
	//<td valign=top class=small><b>Peculiar Impressive</b> the Crazy Horse<P>
	string [int][int] matches = visit_url("place.php?whichplace=town_right&action=town_horsery").group_string("<td valign=top class=small><b>(.*?)</b> the (.*?)<P>");
	//if (matches.count() == 0) return;
	//if (matches[0][1] != "The Hostler") return;
	foreach key in matches
	{
		string name = matches[key][1];
		string horse = matches[key][2];
		
		//if (match.contains_text("JP432")) break; //reached key
		print("HORSERY_NAME_LOG: " + name + "•" + horse);
	}
}