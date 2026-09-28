void main()
{
	buffer page_text = visit_url("raffle.php");
	//<td class=small><a href='showplayer.php?who=2587596'>misplacedme2 (#2587596)</a></td><td><img class=hand onclick='descitem(146911854);' style='vertical-align: middle' src='/images/itemimages/lcdgame.gif'> <b>electronic Brain Trainer game</b>
	//string [int][int] matches = page_text.group_string("<td class=small><a href='showplayer.php.who=([0-9]*)");//'>([^<]*)</a></td><td><img[^>]*>> <b>([^<]*)</b>");
	//string [int][int] matches = page_text.group_string("<td class=small><a href='showplayer.php.who=([0-9]*)'>([^<]*)");//</a></td><td><img[^>]*>> <b>([^<]*)</b>");
	string [int][int] matches = page_text.group_string("<td class=small><a href='showplayer.php.who=([0-9]*)'>([^<]*)</a></td><td><img[^>]*> <b>([^<]*)</b></td><td class=small>&nbsp;&nbsp;([0-9,]*)</td>");
	foreach key in matches
	{
		string [int] match = matches[key];
		logprint("YESTERDAY_RAFFLE: " + match[2] + " / " + match[1] + " / " + match[3] + " / " + match[4] + " / V2");
	}
	//print_html("matches = " + matches.to_json().entity_encode());
}