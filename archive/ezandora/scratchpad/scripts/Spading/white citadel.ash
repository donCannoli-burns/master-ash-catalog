import "relay/Guide/Support/List.ash";

string [int][int] convertPageTextToChestInformation(string page_text)
{
	string [int][int] matches = page_text.group_string("There are too many treasure chests to describe all of them, but the three closest to hand are (.*)\.<p>Your adventurer senses tingle -- one of them is certainly trapped. But your meat radar is way louder than your adventurer senses.");
	
	string match = matches[0][1];
	
	//print("Found \"" + match + "\"");
	
	string [int][int] matches_2 = match.group_string("(.*), (.*), and (.*)");
	//print("Found " + matches_2.to_json());
	
	string [int] chests;
	chests[0] = matches_2[0][1];
	chests[1] = matches_2[0][2];
	chests[2] = matches_2[0][3];
	
	
	
	string [int][int] result;
	
	foreach key, chest in chests
	{
		string [int][int] chest_matches = chest.group_string("a ([^ ]*) ([^ ]*) chest with ([^ ]*) ([^ ]*) fittings");
		string [int] line;
		
		line[0] = chest_matches[0][1];
		line[1] = chest_matches[0][2];
		line[2] = chest_matches[0][3];
		line[3] = chest_matches[0][4];
		
		//print("chest_matches = " + chest_matches.to_json());
		result.listAppend(line);
	}
	
	return result;
}

void spadeTypes()
{
	int countdown = 100;
	while (countdown > 0)
	{
		string page_text = visit_url("choice.php");
		
		string [int][int] chest_information = page_text.convertPageTextToChestInformation();
		
		print("chest_information = " + chest_information.to_json());
		
		countdown -= 1;
		break;
	}
}

void encounter()
{
	int level = 0;
	boolean should_do_choice = false;
	while (true)
	{
		string page_text;
		
		if (should_do_choice)
		{
			page_text = visit_url("choice.php?whichchoice=932&option=1");
			should_do_choice = false;
		}
		else
			page_text = visit_url("choice.php");		
		string [int][int] chest_information = page_text.convertPageTextToChestInformation();
		
		string [int] output_information;
		
		output_information.listAppend(level);
		
		foreach key in chest_information
		{
			foreach key2 in chest_information[key]
			{
				string info = chest_information[key][key2];
				if (info.length() == 0)
				{
					abort("what");
					return;
				}
				output_information.listAppend(info);
			}
		}
		
		int chosen_choice = random(3) + 1;
		output_information.listAppend(chosen_choice);
		string page_text_2 = visit_url("choice.php?whichchoice=932&option=" + chosen_choice);
		
		boolean beaten_up = false;
		if (page_text_2.contains_text("Beaten Up"))
			beaten_up = true;
		
		
		output_information.listAppend(beaten_up);
		
		print("Info: " + output_information.listJoinComponents(","));
		if (beaten_up)
			break;
		else
			should_do_choice = true;
			
		level += 1;
	}
}

void main()
{
	//spadeTypes();
	
	while (my_adventures() > 0)
	{
		if (my_hp() == 0)
			visit_url("galaktik.php?action=curehp&quantity=1");
		visit_url("adventure.php?snarfblat=413");
		visit_url("choice.php?whichchoice=932&option=1");
		//choice.php?whichchoice=932&option=?
		encounter();
	}
	print("done");
}