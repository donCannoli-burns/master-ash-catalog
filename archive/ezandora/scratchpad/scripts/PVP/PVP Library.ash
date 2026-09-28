Record PVPLoggedFight
{
	int fight_id;
	int instigator_id;
	int target_id;
	boolean instigator_won;
};

int extractPlayerIdFromShowplayerLink(string link)
{
	//print_html("link = " + link.entity_encode());
	return link.group_string("showplayer.php.who=([0123456789]+)")[0][1].to_int();
}

string recurseTable(string page_text)
{
	return page_text.group_string("<table[^>]*>(.*?</html>)")[0][1];
}

PVPLoggedFight [int] collectLast1000Fights()
{
	print("Loading previous fights...");
	buffer page_text = visit_url("peevpee.php?place=logs&mevs=0&oldseason=0&showmore=1", false, false);
	
	string inner_text = page_text.recurseTable().recurseTable().recurseTable().recurseTable().recurseTable();
	
	//print("inner_text = " + inner_text);
	string [int][int] fights_html = inner_text.group_string("<tr[^>]*>(.*?)</tr>");
	print_html(fights_html.count() + " fights found.");
	
	PVPLoggedFight [int] results;
	
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
		
		PVPLoggedFight logged_fight;
		logged_fight.fight_id = fight.group_string("lid=([0123456789]+)&")[0][1].to_int();
		logged_fight.instigator_id = fight_split[2].extractPlayerIdFromShowplayerLink();
		logged_fight.target_id = fight_split[4].extractPlayerIdFromShowplayerLink();
		logged_fight.instigator_won = fight_split[2].contains_text("<b>");;
	//http://127.0.0.1:60080/peevpee.php?action=log&ff=1&lid=394629&place=logs&pwd=fb0d4a3305bbf537e6ecc5d5e772c4e4
	}
	
	return results;
}
