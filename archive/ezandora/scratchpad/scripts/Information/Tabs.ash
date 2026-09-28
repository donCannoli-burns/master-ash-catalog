void main()
{
	buffer page_text = visit_url("place.php?whichplace=kgb");
	string configuration = "";
	for i from 1 to 6
	{
		string [int][int] matches = page_text.group_string("<div id=kgb_tab" + i + "[^>]*>(.*?)</div>");
		string line = matches[0][1];
		if (line.contains_text("A Short Tab"))
			configuration += "1";
		else if (line.contains_text("A Long Tab"))
			configuration += "2";
		else
			configuration += "0";
	}
	string [int][int] matches2 = page_text.group_string("<div id=kgb_lightrings[^>]*><img src=\"([^\"]*)\" width=250 height=100 border=0 alt=\"([^\"]*)");
	
	if (matches2.count() > 0)
	{
		string image_2 = matches2[0][1].group_string("kgb/(.*)")[0][1];
		if (image_2 != "side.gif")
			configuration += " - " + image_2 + " - " + matches2[0][2];
	}
	print("KGB tabs: " + configuration);
}