void main()
{
	buffer museum_source_buffer = visit_url("museum.php?place=spelunky");
	
	string museum_source = museum_source_buffer.to_string();
	
	int yesterday_index = museum_source.index_of("Yesterday's Spelunkest");
	
	if (yesterday_index < 0)
		return;
		
	string since_yesterday = museum_source.substring(yesterday_index);
	
	string [int][int] parsed_buffer = since_yesterday.group_string("<a class=nounder href=showplayer.php.who=([^>]*)><b>([^<]*)</b></a></td><td></td><td>([^<]*)");
	
	if (parsed_buffer.count() == 0)
		return;
		
	logprint("Yesterday's spelunker leaderboard:");
	foreach key in parsed_buffer
	{
		string account_id_string = parsed_buffer[key][1];
		string account_name_string = parsed_buffer[key][2];
		string amount_earned_string = parsed_buffer[key][3];
		logprint("SPELUNKERLEADERBOARDYESTERDAY•" + account_id_string + "•" + account_name_string + "•" + amount_earned_string);
	}
	logprint("End yesterday's spelunker leaderboard.");
}