//update from
//https://docs.google.com/spreadsheets/d/1N-9Ohjv11ch8bhivYxqYs6JHdTx8Ug2vMeGNLDzMH70/edit#gid=0
boolean isValidKOLUsernameOrPlayerID(string name)
{
	for c_index from 0 to name.length() - 1
	{
		string c = name.char_at(c_index).to_lower_case();
		if (!($strings[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,_,0,1,2,3,4,5,6,7,8,9] contains c) && c != " ")
		{
			return false;
		}
	}
	return true;
}

string [int] get_training_target_list()
{
	string [int] targets_in = file_to_array("data/crimbo_2022_skill_training_list.txt");
	
	string [int] matching_regexes = 
	{
	"^(.+?) \\(##([0-9]+)\\)[ ]*$",
	"^(.+?) \\(#([0-9]+)\\)[ ]*$",
	"^(.+?)\\(#([0-9]+)\\)$",
	"^(.+?) #([0-9]+)$",
	"^(.+?) \\(\\(#([0-9]+)\\)\\)[ ]*$",
	"^(.+?) \\(#(.*?)\\)$",
	"^(.+?)\\(#([0-9]+)$",
	"^(.+?) \\((.*?)\\)$",
	"^(.+?)\\((.*?)\\)$",
	};
	string [int] targets_out;
	int unique_players = 0;
	foreach key, target in targets_in
	{
		if (target == "") continue;
		string [int][int] matches;
		foreach key, regex in matching_regexes
		{
			matches = target.group_string(regex);
			if (matches.count() > 0)
			{
				break;
			}
		}
		
		if (matches.count() > 0) //target.contains_text("#"))
		{
			//print_html("target = \"" + target + "\"");
			//parse:
			
			//print_html("matches = " + matches.to_json());
			string name = matches[0][1];
			string player_id = matches[0][2];
			if (name == "" || player_id == "")
			{
				print_html("Error with parsing \"" + target + "\"");
				print_html("name = \"" + name + "\"");
				print_html("player_id = \"" + player_id + "\"");
				continue;
			}
			if (!name.isValidKOLUsernameOrPlayerID())
			{
				print_html("\"" + name + "\" is an invalid name, from \"" + target + "\"");
			}
			if (!player_id.isValidKOLUsernameOrPlayerID())
			{
				print_html("\"" + player_id + "\" is an invalid name, from \"" + target + "\"");
			}
			//print_html("\"" + name + "\": " + player_id);
			targets_out[targets_out.count()] = name;
			targets_out[targets_out.count()] = player_id;
		}
		else
		{
			targets_out[targets_out.count()] = target;
			
			if (!target.isValidKOLUsernameOrPlayerID())
			{
				print_html("\"" + target + "\" is an invalid name");
			}
		}
		unique_players += 1;
	}
	print_html("Found " + unique_players + " players.");
	//abort("found " + targets_out.count() + " targets");
	return targets_out;
}

void main()
{
	return;
	if (get_property("_ezandoraDidCrimbo2022SkillTraining").to_boolean()) return;
	if ($item[crimbo training manual].item_amount() == 0 && $item[crimbo training manual].available_amount() > 0)
	{
		retrieve_item($item[crimbo training manual]);
	}
	if ($item[crimbo training manual].item_amount() == 0)
	{
		abort("get the manual");
	}
	
	string [int] targets = get_training_target_list();
	//abort("well?");
	boolean [string] already_trained;
	file_to_map("crimbo_2022_trained_people.txt", already_trained);
	
	foreach key, target in targets
	{
		if (already_trained[target]) continue;
		
		//attempt training:
		
		//curse.php?action=use&whichitem=11046&targetplayer=
		print("Training \"" + target + "\"");
		buffer result = visit_url("curse.php?action=use&whichitem=11046&targetplayer=" + target);
		//print_html("result = " + result.entity_encode());
		
		if (result.contains_text("You've already trained somebody today.  Take the rest of the day off."))
		{
			print_html("Already trained today.");
			set_property("_ezandoraDidCrimbo2022SkillTraining", true);
			return;
		}
		if (result.contains_text("They already know that skill"))
		{
			print_html("They know that skill");
			already_trained[target] = true;
			map_to_file(already_trained, "crimbo_2022_trained_people.txt");
			continue;
		}
		if (result.contains_text("<td>You train"))
		{
			print_html("Trained.");
			already_trained[target] = true;
			map_to_file(already_trained, "crimbo_2022_trained_people.txt");
			set_property("_ezandoraDidCrimbo2022SkillTraining", true);
			break;
		}
		print("Unknown result! Probably in ronin?");
	}
}