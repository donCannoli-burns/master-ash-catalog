import "scripts/PVP/PVP Library";
int stance = 5;

boolean [int] searchForPlayersCurrentlyInPVP(boolean searching_hardcore)
{
	print("Running multiple searches to identify players...");
	boolean [int] player_ids;
	print_html("Searching...");
	foreach s in $strings[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z]
	{
		buffer page_text = visit_url("searchplayer.php?searching=Yep.&for=&searchstring=" + s + "&startswith=1&searchlevel=&searchranking=&pvponly=on&hardcoreonly=" + (searching_hardcore ? "1" : "2"));
//searchplayer.php?searching=Yep.&for=&searchstring=a&startswith=1&searchlevel=&searchranking=&pvponly=on&hardcoreonly=1
		if (page_text.contains_text("more than 100 players matched this pattern"))
		{
			print_html("ERROR while searching " + s);
		}
		string [int][int] matches = page_text.group_string("showplayer.php.who=([0-9]*)");
		foreach key in matches
		{
			int player_id = matches[key][1].to_int();
			player_ids[player_id] = true;
		}
	}
	print_html("Found " + player_ids.count() + " players.");
	return player_ids;
}

boolean [int] getPlayersCurrentlyInPVP()
{
	//FIXME cache
	return searchForPlayersCurrentlyInPVP(in_hardcore());
}

boolean [int] searchForPlayersWonVictoriesAgainst()
{
	PVPLoggedFight [int] fights = collectLast1000Fights();
	
	boolean [int] results_player_ids;
	
	int my_id_int = my_id().to_int();
	foreach key, fight in fights
	{
		if (fight.instigator_id == my_id_int && fight.instigator_won)
		{
			results_player_ids[fight.target_id] = true;
		}
	}
	return results_player_ids;
}

boolean [int] oldCodeIgnore()
{
	print("Loading previous fights...");
	boolean [int] results_player_ids;
	buffer page_text = visit_url("peevpee.php?place=logs&mevs=0&oldseason=0&showmore=1", false, false);
	
	string inner_text = page_text.recurseTable().recurseTable().recurseTable().recurseTable().recurseTable();
	
	//print("inner_text = " + inner_text);
	string [int][int] fights_html = inner_text.group_string("<tr[^>]*>(.*?)</tr>");
	print_html(fights_html.count() + " fights found.");
	
	int my_id_int = my_id().to_int();
	foreach fight_key in fights_html
	{
		//string [int] fight = fights_html[fight_key];
		//print_html("fight = " + fight.to_json().entity_encode());
		string fight = fights_html[fight_key][1];
		if (fight.length() == 0) continue;
		/*string [int][int] fight_split_1 = fight.group_string("<td[^>]*>(.*?)</td>");
		
		string [int] fight_split_2;
		foreach key in fight_split_1
		{
			fight_split_2[fight_split_2.count()] = fight_split_1[key][1];
		}
		if (fight_split_2.length() < 3) continue;*/
		/*Layout:
		0: Instigator
		1: vs
		2: target
		3: time
		4: Result
		*/
		
		
		string [int] fight_split = fight.split_string("<td>");
		if (fight_split.count() < 5) continue;
		//print_html("fight_split = " + fight_split.to_json().entity_encode());
		/*
			Layout:
			1: Fight link
			2: Instigator
			3: vs
			4: Target
			5: Result:
		*/
		
		int instigator_id = fight_split[2].extractPlayerIdFromShowplayerLink();
		int target_id = fight_split[4].extractPlayerIdFromShowplayerLink();
		boolean instigator_won = fight_split[2].contains_text("<b>");
		
		//print_html("fight_split_2 = " + fight_split_2.to_json().entity_encode());
		//print_html(instigator_id + " vs " + target_id + ": " + (instigator_won ? "victory!" : "failure"));
		if (instigator_id == my_id_int && instigator_won)
		{
			//print_html("We won! We won! Good for me!");
			//print_html(my_name() + " vs " + target_id + ": " + (instigator_won ? "victory!" : "failure"));
			results_player_ids[target_id] = true;
		}
	}
	
	return results_player_ids;
}

void main()
{
	boolean [int] player_victories = searchForPlayersWonVictoriesAgainst();
	print_html(player_victories.count() + " unique player victories.");
	
	boolean [int] players_in_pvp = getPlayersCurrentlyInPVP();
	
	boolean [int] players_to_fight;
	foreach player_id in players_in_pvp
	{
		if (!player_victories[player_id])
		{
			//print("Fight player " + player_id);
			players_to_fight[player_id] = true;
		}
	}
	print("Full list: " + players_to_fight.to_json());
	
	
	foreach player_id in players_to_fight
	{
		if (pvp_attacks_left() == 0 || !hippy_stone_broken()) break;
		print("Fighting player " + player_id + "...");
		try
		{
			string who = player_id;
			int ranked = 0;
			string attacktype = "fame";
			string win_message = "-1";
			string lose_message = "-1";
			string page_text = visit_url("peevpee.php?action=fight&place=fight&ranked=" + ranked + "&who=" + who + "&stance=" + stance + "&attacktype=" + attacktype + "&winmessage=" + win_message + "&losemessage=" + lose_message);
		}
		finally
		{
		}
	}
}