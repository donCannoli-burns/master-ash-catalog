void main()
{
	
	visit_url("inv_use.php?whichitem=9104");
	
	visit_url("choice.php?whichchoice=1195&option=1");
	string page_text = visit_url("choice.php?whichchoice=1195&option=1");
	visit_url("choice.php?whichchoice=1196&option=2");
	
	string [int][int] matches = page_text.group_string("<option value=\"([0-9]*)\">([^<]*)");
	foreach key in matches
	{
		print_html(matches[key][1] + " - " + matches[key][2]);
	}
}