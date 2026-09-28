void listAppend(string [int] list, string entry)
{
	int position = count(list);
	while (list contains position)
		position = position + 1;
	list[position] = entry;
}

void listAppend(int [int] list, int entry)
{
	int position = count(list);
	while (list contains position)
		position = position + 1;
	list[position] = entry;
}

string [int] listMake()
{
	string [int] result;
	return result;
}

string [int] listMake(string e1)
{
	string [int] result;
	listAppend(result, e1);
	return result;
}


string componentsJoinedByString(string [int] map, string joining_string)
{
	string result;
	boolean first = true;
	foreach i in map
	{
		if (first)
		{
			result = map[i];
			first = false;
		}
		else
			result = result + joining_string + map[i];
	}
	return result;
}


void main()
{
	int [int] path_base_leaderboards;
	int latest_path = 0;
	
	buffer musuem_text = visit_url("museum.php");
	
	string [int][int] musuem_matches = musuem_text.group_string("whichboard=([0-9]*)");
	foreach key in musuem_matches
	{
		int value = musuem_matches[key][1].to_int();
		if (value >= 998) continue;
		if (value > latest_path)
			latest_path = value;
	}
	//latest_path -= 1;
	//latest_path = 23;
	//latest_path = 32;
	print("Latest path is " + latest_path + ".");
	//latest_path = 21;
	for i from 9 to latest_path
	{
		if (!($ints[27] contains i)) //batfellow
			path_base_leaderboards.listAppend(i);
	}
		

	string [int] leaderboard_urls;
	foreach key in path_base_leaderboards
	{
		int i = path_base_leaderboards[key];
		leaderboard_urls.listAppend("museum.php?floor=1&place=leaderboards&whichboard=" + i);
	}
	
	string [string][int] player_path_unlocks;
	
	int [string] player_name_to_id;
	
	string [int] path_names;
	
	foreach key in leaderboard_urls
	{
		string leaderboard_url = leaderboard_urls[key];
		string leaderboard_text = visit_url(leaderboard_url);
		
		
		string path_name = group_string(leaderboard_text, "blue><b>([^\\(<]*)\\(Frozen\\)")[0][1];
		
		if (path_name.length() == 0)
			path_name = group_string(leaderboard_text, "blue><b>([^\\(<]*) Leaderboards")[0][1];
			
		//print("path_name = \"" + path_name + "\"");
			
		if (length(path_name) > 1 && path_name.char_at(length(path_name) - 1) == " ")
			path_name = substring(path_name, 0, length(path_name) - 1);
		print("path_name = \"" + path_name + "\"");
		path_names.listAppend(path_name);
		
		
		int fastest_start = index_of(leaderboard_text, "<tr><td style=\"color: white;\" align=center bgcolor=blue><b>Fastest");
		if (fastest_start == -1)
			fastest_start = index_of(leaderboard_text, "<tr><td style=\"color: white;\" align=center bgcolor=blue><b>Normal Seal Clubber");
		if (fastest_start != -1)
			leaderboard_text = substring(leaderboard_text, fastest_start, length(leaderboard_text));
		else
			print("Unknown fastest");
		
		//string [int][int] matches = group_string(leaderboard_text, "showplayer.php\\?who=([^\"]*)");
		string [int][int] matches = group_string(leaderboard_text, "<a class=nounder href=\"showplayer\\.php\\?who=([0-9]*)\"><b>([^<]*)");
		
		boolean [string] seen_player_names_this_leaderboard;
		
		foreach key2 in matches
		{
			int player_actual_id = matches[key2][1].to_int();
			//print("player_actual_id = " + player_actual_id);
			string player_name = matches[key2][2];
			
			player_name_to_id[player_name] = player_actual_id;
			if (seen_player_names_this_leaderboard[player_name])
				continue;
			seen_player_names_this_leaderboard[player_name] = true;
			
			if (!(player_path_unlocks contains player_name))
				player_path_unlocks[player_name] = listMake(path_name);
			else
				player_path_unlocks[player_name].listAppend(path_name);
		}
	}
	//string [int] new_players;
	string [int] most_recent_players;
	string most_recent_path = path_names[path_names.count() - 1];
	foreach player_id in player_path_unlocks
	{
		string line = player_id + " leaderboard paths: " + componentsJoinedByString(player_path_unlocks[player_id], ", ");
		print(line);
		
		//if (player_path_unlocks[player_id].count() == 1 && player_path_unlocks[player_id][0] == "Class Act II: A Class For Pigs")
			//new_players[count(new_players)] = player_id;
		if (player_path_unlocks[player_id].count() == 1 && player_path_unlocks[player_id][0] == most_recent_path)
			most_recent_players[count(most_recent_players)] = player_id;
		
	}
	print("");
	foreach key in path_names
	{
		string path_name = path_names[key];
		int number_first = 0;
		int number_only = 0;
		
		foreach player_id in player_path_unlocks
		{
			if (player_path_unlocks[player_id][0] == path_name)
			{
				number_first = number_first + 1;
				if (count(player_path_unlocks[player_id]) == 1)
					number_only = number_only + 1;
			}
		}
		string actual_path_name = path_name;
		if (actual_path_name == "Slow and Steady") //listed name on leaderboards is mistaken; spaded by Leaderboard Robot
			actual_path_name = "Avatar of Sneaky Pete II: Slow and Steady";
		if (actual_path_name == "Heavy Rains") //listed name on leaderboards is mistaken; spaded by Leaderboard Robot
			actual_path_name = "Avatar of Heavy Rains";
		
		print(actual_path_name + " was the first leaderboard path for " + number_first + " players. (" + number_only + " only leaderboarded this path)");
	}
	print("");
	print(count(player_path_unlocks) + " players leaderboarded.");
	
	print(most_recent_path + " leaderboarders: " + componentsJoinedByString(most_recent_players, ", "));
	
	string min_player_name = "";
	string max_player_name = "";
	foreach player_name in player_name_to_id
	{
		int id = player_name_to_id[player_name];
		if (player_name_to_id[max_player_name] < id || max_player_name.length() == 0)
			max_player_name = player_name;
		if (player_name_to_id[min_player_name] > id || min_player_name.length() == 0)
			min_player_name = player_name;
	}
	print("Oldest ascender is " + min_player_name);
	print("Newest ascender is " + max_player_name);
	
	print("done");
}