/*
	Fight Dad Sea Monkee.ash
	Version 1.0
	Defeats Dad Sea Monkee in the Mer-Kin Temple.
	
	Requirements:
		-The Mer-kin Deepcity unlocked this ascension.
		-The first six items of Clothing of Loathing (Goggles, Stick-Knife, Scepter, Jeans, Treads, and Belt of Loathing). These can be acquired from the Mer-kin temple bosses: http://kol.coldfront.net/thekolwiki/index.php/Clothing_of_Loathing
		-A way to breathe underwater. Either the makeshift scuba gear, an old scuba tank, or the Really Deep Breath effect (from a fish juice box or others). The aerated diving helmet works too, but only if you have a Pocket Square of Loathing.
		-150 base stat in moxie, muscle, and mysticality.
		-1200 MP (720 MP if you have Volcanometeor Showeruption) after outfit is on.
		
	
	You don't have to set up your outfit, the script will do that for you. Avoid using buffs - they'll be removed at the start of combat.
	This script automatically learns and casts the 120MP Hobopolis skills ( http://kol.coldfront.net/thekolwiki/index.php/Hobopolis_skills ) to defeat Dad Sea Monkee. It will also cast Volcanometeor Showeruption if you have it, which will make the fight easier.
	If the script can't defeat dad sea monkee, try to level your mysticality or muscle.
*/


string [int] __element_names;
__element_names[0] = "Hot";
__element_names[1] = "Cold";
__element_names[2] = "Stench";
__element_names[3] = "Spooky";
__element_names[4] = "Sleaze";
__element_names[5] = "Physical";

//All clues and their solutions:
//Defined globally because we reuse them.

string [int] __clues_1;
__clues_1[0] = "chaotic";
__clues_1[1] = "horrifying";
__clues_1[2] = "pulpy";
__clues_1[3] = "rigid";
__clues_1[4] = "rotting";
__clues_1[5] = "slimy";

string [int] __clues_1_solutions;
__clues_1_solutions[0] = "Hot";
__clues_1_solutions[1] = "Spooky";
__clues_1_solutions[2] = "Physical";
__clues_1_solutions[3] = "Cold";
__clues_1_solutions[4] = "Stench";
__clues_1_solutions[5] = "Sleaze";

string [int] __clues_2;
__clues_2[0] = "float";
__clues_2[1] = "ooze";
__clues_2[2] = "shamble";
__clues_2[3] = "skitter";
__clues_2[4] = "slither";
__clues_2[5] = "swim";

string [int] __clues_2_solutions;
__clues_2_solutions[0] = "Spooky";
__clues_2_solutions[1] = "Stench";
__clues_2_solutions[2] = "Cold";
__clues_2_solutions[3] = "Hot";
__clues_2_solutions[4] = "Sleaze";
__clues_2_solutions[5] = "Physical";

string [int] __clues_3;
__clues_3[0] = "awful";
__clues_3[1] = "bloated";
__clues_3[2] = "curious";
__clues_3[3] = "frightening";
__clues_3[4] = "putrescent";
__clues_3[5] = "terrible";

string [int] __clues_3_solutions;
__clues_3_solutions[0] = "Cold";
__clues_3_solutions[1] = "Sleaze";
__clues_3_solutions[2] = "Physical";
__clues_3_solutions[3] = "Spooky";
__clues_3_solutions[4] = "Stench";
__clues_3_solutions[5] = "Hot";

string [int] __clues_4;
__clues_4[0] = "blackness";
__clues_4[1] = "darkness";
__clues_4[2] = "emptiness";
__clues_4[3] = "portal";
__clues_4[4] = "space";
__clues_4[5] = "void";

string [int] __clues_4_solutions;
__clues_4_solutions[0] = "Hot";
__clues_4_solutions[1] = "Spooky";
__clues_4_solutions[2] = "Sleaze";
__clues_4_solutions[3] = "Physical";
__clues_4_solutions[4] = "Cold";
__clues_4_solutions[5] = "Stench";

string [int] __clues_5;
__clues_5[0] = "cracks open";
__clues_5[1] = "shakes";
__clues_5[2] = "shifts";
__clues_5[3] = "shimmers";
__clues_5[4] = "warps";
__clues_5[5] = "wobbles";

string [int] __clues_5_solutions;
__clues_5_solutions[0] = "Physical";
__clues_5_solutions[1] = "Spooky";
__clues_5_solutions[2] = "Cold";
__clues_5_solutions[3] = "Stench";
__clues_5_solutions[4] = "Hot";
__clues_5_solutions[5] = "Sleaze";

string [int] __clues_6;
__clues_6[0] = "suddenly";
__clues_6[1] = "slowly";

//Clue 7 is a number.

string [int] __clues_8;
__clues_8[2] = "brain";
__clues_8[3] = "mind";
__clues_8[4] = "reason";
__clues_8[5] = "sanity";
__clues_8[6] = "grasp on reality";
__clues_8[7] = "sixth sense";
__clues_8[8] = "eyes";
__clues_8[9] = "thoughts";
__clues_8[10] = "senses";
__clues_8[11] = "memories";
__clues_8[12] = "fears";

//Clue 9 is a number.

string [int] __clues_10;
__clues_10[1] = "spleen";
__clues_10[2] = "stomach";
__clues_10[3] = "skull";
__clues_10[4] = "forehead";
__clues_10[5] = "brain";
__clues_10[6] = "mind";
__clues_10[7] = "heart";
__clues_10[8] = "throat";
__clues_10[9] = "chest";
__clues_10[10] = "head";

string findSubstringFromMap(string text, string [int] map)
{
	foreach i in map
	{
		string possible_match = map[i];
		if (contains_text(text, possible_match))
			return possible_match;
	}
	return "";
}

//Unusable for maps containing an index at -1.
int indexOfObject(string object, string [int] map)
{
	foreach i in map
	{
		if (map[i] == object)
			return i;
	}
	return -1;
}

//Unusable for maps containing an index at -1.
int lastIndexOfObject(string object, string [int] map)
{
	int index = -1;
	foreach i in map
	{
		if (map[i] == object && i > index)
			index = i;
	}
	return index;
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

int lookupElementValue(string e)
{
	return indexOfObject(e, __element_names);
}

string lookupElementString(int element_value)
{
	if (element_value < 0 || element_value > 5)
		return "";
	string [int] elements;
	
	return __element_names[element_value];
}

string lookupElementHTMLColor(string e)
{
	if (e == "Hot")
		return "red";
	else if (e == "Cold")
		return "blue";
	else if (e == "Stench")
		return "green";
	else if (e == "Spooky")
		return "gray";
	else if (e == "Sleaze")
		return "purple";
	else if (e == "Physical")
		return "black";
	else
		return "black";
}

string lookupElementHTML(string e)
{
	return "<font color=\"" + lookupElementHTMLColor(e) + "\">" + e + "</font>";
}

string decodeClue4(string clue_text)
{
	return findSubstringFromMap(clue_text, __clues_4);
}

string decodeClue5(string clue_text)
{
	return findSubstringFromMap(clue_text, __clues_5);
}

string decodeClue6(string clue_text)
{
	return findSubstringFromMap(clue_text, __clues_6);
}

string matchEarlyRoundKeyword(string keyword, int round)
{
	string [int] keywords;
	string [int] solutions;
	if (round == 1)
	{
		keywords = __clues_1;
		solutions = __clues_1_solutions;
	}
	else if (round == 2)
	{
		keywords = __clues_2;
		solutions = __clues_2_solutions;
	}
	else if (round == 3)
	{
		keywords = __clues_3;
		solutions = __clues_3_solutions;
	}
	else if (round == 4)
	{
		keywords = __clues_5;
		solutions = __clues_5_solutions;
	}
	else if (round == 5)
	{
		keywords = __clues_4;
		solutions = __clues_4_solutions;
	}
	int keyword_index = indexOfObject(keyword, keywords);
	if (keyword_index == -1)
		return "";
	return solutions[keyword_index];
}

string matchRounds67(string clue_6, string clue_7, int round)
{
	if (!(round == 6 || round == 7))
		return "";

	int clue_7_value = to_int(clue_7);

	//Calculate values:
	//Just look for a match:
	int min_found_value = -1;
	int max_found_value = -1;
	
	for r6 from 0 upto 5
	{
		for r7 from 0 upto 5
		{
			int v = (2 ** r6) + (2 ** r7);
			if (v == clue_7_value)
			{
				min_found_value = min(r6, r7);
				max_found_value = max(r6, r7);
				break;
			}
		}
		if (min_found_value != -1)
			break;
	}
	
	

	string [int] result;
	if (clue_6 == "slowly")
	{
		result[0] = lookupElementString(max_found_value);
		result[1] = lookupElementString(min_found_value);
	}
	else if (clue_6 == "suddenly")
	{
		result[0] = lookupElementString(min_found_value);
		result[1] = lookupElementString(max_found_value);
	}
	else
		return "";
	
	if (round == 6)
		return result[0];
	else if (round == 7)
		return result[1];
	else
		return "";
}


string matchRound8(string round_1_weakness, string clue)
{	
	int round_1_weakness_value = lookupElementValue(round_1_weakness);
	if (round_1_weakness_value == -1)
		return "";
	round_1_weakness_value = round_1_weakness_value + 1;
	
	int clue_value = indexOfObject(clue, __clues_8);
	if (clue_value == -1)
		return "";
	
	int lookup_value = clue_value - round_1_weakness_value - 1;
	
	return lookupElementString(lookup_value);
}

string matchRound9(string [int] round_weaknesses_so_far, string clue)
{
	int clue_value = to_int(clue);
	int value = lookupElementValue(round_weaknesses_so_far[1]) + lookupElementValue(round_weaknesses_so_far[2]) + lookupElementValue(round_weaknesses_so_far[3]) + lookupElementValue(round_weaknesses_so_far[4]) + 7 - clue_value;
	return lookupElementString(value);
}

string matchRound10(string [int] round_weaknesses_so_far, string clue)
{
	int clue_value = indexOfObject(clue, __clues_10);
	
	if (clue_value == -1)
		return "";
		
	if (clue_value == 10)
	{
			//We find the weakness not yet seen
			boolean [int] elements_seen;
			
			elements_seen[0] = false;
			elements_seen[1] = false;
			elements_seen[2] = false;
			elements_seen[3] = false;
			elements_seen[4] = false;
			elements_seen[5] = false;
			foreach i in round_weaknesses_so_far
			{
				if (i == 9)
					break;
				int value = lookupElementValue(round_weaknesses_so_far[i]);
				if (value != -1)
					elements_seen[value] = true;
			}
			foreach i in elements_seen
			{
				if (!elements_seen[i])
					return lookupElementString(i);
			}
			return "";
	}
	else
	{
		return round_weaknesses_so_far[clue_value - 1];
	}
}

string guessRound11(string [int] round_weaknesses_so_far, boolean should_output)
{
	//Guess round 11. Spading data seems to suggest the fight is generated as twelve rounds of each element twice.
	//We don't have to do this. Ten rounds is enough.
	
	int [string] element_count;
	foreach i in __element_names
		element_count[__element_names[i]] = 0;
	
	foreach i in round_weaknesses_so_far
	{
		string weakness = round_weaknesses_so_far[i];
		element_count[weakness] = element_count[weakness] + 1;
	}
	
	string [int] possible_elements;
	foreach i in element_count
	{
		int count = element_count[i];
		if (count < 2)
		{
			possible_elements[count(possible_elements)] = i;
		}
	}
	
	if (count(possible_elements) > 1)
	{
		string guess = possible_elements[random(count(possible_elements))];
		if (should_output)
		{
			string [int] output;
			foreach i in possible_elements
				output[i] = lookupElementHTML(possible_elements[i]);
			print_html("Round 11 potential weaknesses: " + componentsJoinedByString(output, ", "));
			print_html("Guessing " + lookupElementHTML(guess) +".");
			print("");
		}
		return guess;
	}
	else if (count(possible_elements) == 1)
		return possible_elements[0];
	else
		return "";
	
}

string [int] decodeWeaknesses(string [int] clues, boolean should_output)
{
	//Now use these clues for something
	//http://forums.kingdomofloathing.com/vb/showpost.php?p=4439411&postcount=369 for reference
	
	foreach i in clues
		clues[i] = to_lower_case(clues[i]);
	
	string [int] round_weaknesses;
	
	//First few rounds, just pattern matching:
	round_weaknesses[0] = matchEarlyRoundKeyword(clues[0], 1);
	round_weaknesses[1] = matchEarlyRoundKeyword(clues[1], 2);
	round_weaknesses[2] = matchEarlyRoundKeyword(clues[2], 3);
	round_weaknesses[3] = matchEarlyRoundKeyword(clues[4], 4);
	round_weaknesses[4] = matchEarlyRoundKeyword(clues[3], 5);
	
	//Rounds six and seven:
	round_weaknesses[5] = matchRounds67(clues[5], clues[6], 6);
	round_weaknesses[6] = matchRounds67(clues[5], clues[6], 7);
	
	//Round 8:
	round_weaknesses[7] = matchRound8(round_weaknesses[0], clues[7]);
	
	//Round 9:
	round_weaknesses[8] = matchRound9(round_weaknesses, clues[8]);
	
	//Round 10:
	round_weaknesses[9] = matchRound10(round_weaknesses, clues[9]);
	
	//Round 11:
	round_weaknesses[10] = guessRound11(round_weaknesses, should_output);
	
	if (should_output)
	{
		foreach i in round_weaknesses
		{
			print_html("Round " + (i + 1) + " weakness: " + lookupElementHTML(round_weaknesses[i]));
		}
		print("");
	}
	

	return round_weaknesses;
}

string [int] decodeClues(string clue_text, boolean should_output)
{
	
	string [int] clues;
	
	//This string parsing could stand some improvement.
	
	int clue_start_index = index_of(clue_text, "You shake your head and look above the tank, at the window into space.");
	int clue_end_index = index_of(clue_text, "You have to end this.");
	if (clue_start_index == -1 || clue_end_index == -1)
		return clues;
	clue_text = substring(clue_text, clue_start_index, clue_end_index + 21);

	if (should_output)
	{
		print("Clue text: " + clue_text);
		print("");
	}
	
	clue_text = to_lower_case(clue_text); //easier parsing

	clues[0] = substring(clue_text, index_of(clue_text, "at the window into space. ") + 26, index_of(clue_text, " forms "));
	clues[1] = substring(clue_text, index_of(clue_text, " forms ") + 7, index_of(clue_text, " in the darkness, each more "));
	clues[2] = substring(clue_text, index_of(clue_text, " in the darkness, each more ") + 28, index_of(clue_text, " than the last."));

	string clues_4_through_6_text = substring(clue_text, index_of(clue_text, "than the last. ") + 14, index_of(clue_text, "-dimensional monstrosities"));
	clues[3] = decodeClue4(clues_4_through_6_text);
	clues[4] = decodeClue5(clues_4_through_6_text);
	clues[5] = decodeClue6(clues_4_through_6_text);

	clues[6] = substring(clue_text, index_of(clue_text, "revealing ") + 10, index_of(clue_text, "-dimensional monstrosities"));
	clues[7] = "";
	if (contains_text(clue_text, "is your "))
		clues[7] = substring(clue_text, index_of(clue_text, "is your ") + 8, index_of(clue_text, " betraying you? as if on cue"));
	else if (contains_text(clue_text, "are your "))
		clues[7] = substring(clue_text, index_of(clue_text, "are your ") + 9, index_of(clue_text, " betraying you? as if on cue"));
	clues[8] = substring(clue_text, index_of(clue_text, "as if on cue, ") + 14, index_of(clue_text, "-sided triangles materialize and then disappear"));
	clues[9] = substring(clue_text, index_of(clue_text, "so impossible that your ") + 24, index_of(clue_text, " throbs."));
	
	if (should_output)
	{
		foreach i in clues
		{
			if (i == 10) break;
			print_html("Clue " + (i + 1) + ": \"" + clues[i] + "\"");
		}
		print("");
	}
 	return clues;
}

void doFight(string clue_text, boolean simulation, boolean intentionally_lose, boolean should_output_optional_information)
{
	string [int] clues = decodeClues(clue_text, should_output_optional_information);

	
	string [int] round_weaknesses = decodeWeaknesses(clues, should_output_optional_information);
		
	if (simulation)
		return;
	
	skill [int] response_skills;
	response_skills[0] = $skill[Awesome Balls of Fire];
	response_skills[1] = $skill[Snowclone];
	response_skills[2] = $skill[Eggsplosion];
	response_skills[3] = $skill[Raise Backup Dancer];
	response_skills[4] = $skill[Grease Lightning];
	response_skills[5] = $skill[Toynado];
	if (have_skill($skill[Volcanometeor Showeruption]))
		response_skills[0] = $skill[Volcanometeor Showeruption];
		
	foreach i in round_weaknesses
	{
		string weakness = round_weaknesses[i];
		int weakness_value = lookupElementValue(weakness);
		string next_fight_text;
		if (weakness == "" || intentionally_lose)
		{
			next_fight_text = attack();
		}
		else
		{
			skill response_skill = response_skills[weakness_value];
			if (my_mp() < 120 && response_skill != $skill[Volcanometeor Showeruption])
			{
				//Our MP is too low. Last ditch effort - delay and hope we get to a hot element that we can cast Volcanometeor Showeruption in response to.
				if (response_skills[0] == $skill[Volcanometeor Showeruption] && lastIndexOfObject("Hot", round_weaknesses) > i)
					print("Ran out of MP. Hoping to cast Volcanometeor Showeruption as a last ditch effort.");
				else
					print("Ran out of MP.", "red");
				next_fight_text = attack();
			}
			else 
				next_fight_text = use_skill(response_skill);
		}
		if (contains_text(next_fight_text, "You win the fight"))
		{
			visit_url("choice.php?whichchoice=717&option=1");
			print("");
			print_html("Dad is always was always <font color=\"#444444\">is always was always</font> <font color=\"#888888\">is always was always</font> <font color=\"#BBBBBB\">is always was always</font>");
			return;
		}
		else if (contains_text(next_fight_text, "You lose."))
		{
			print("");
			print("Dad Sea Monkee stomps the apple. The apple is " + my_name() + ". I'm sorry, " + my_name() + ". Next time, kiddo. Next time will be different, I promise.", "red");
			return;
		}
	}
}

boolean prepareForDadFight()
{
	if (!contains_text(visit_url("sea_merkin.php?seahorse=1"), "you crest an undersea ridge and discover, spread out beneath you, a magnificent Mer-kin City"))
	{
		print("You should get past the intense currents in the sea first.", "red");
		return false;
	}
	
	//Pick out our breathing source:
	string breathing_source = "";
	if (have_effect($effect[Really Deep Breath]) > 0)
		breathing_source = "Really Deep Breath";
	else if (available_amount($item[old scuba tank]) > 0)
		breathing_source = "old scuba tank";
	else if (available_amount($item[makeshift scuba gear]) > 0)
		breathing_source = "makeshift scuba gear";
	else if (available_amount($item[aerated diving helmet]) > 0 && available_amount($item[Pocket Square of Loathing]) > 0)
		breathing_source = "aerated diving helmet";
	
	if (breathing_source == "")
	{
		print("No source of breathing.", "red");
		return false;
	}
	

	if (my_basestat($stat[mysticality]) < 150)
	{
		print("You need 150 mysticality.", "red");
		return false;
	}
	if (my_basestat($stat[muscle]) < 150)
	{
		print("You need 150 muscle.", "red");
		return false;
	}
	if (my_basestat($stat[moxie]) < 150)
	{
		print("You need 150 moxie.", "red");
		return false;
	}
	
	if (my_adventures() < 2)
	{
		print("You need more adventures.", "red");
		return false;
	}

	//We assume the base six clothing of loathing items. We use the pocket square if it's available, but we still need the base six items to simplify things.
	//In theory (untested) we can get away with missing one of the base items if we have the pocket square.
	//This is unsupported. Who would smash an item that takes two ascensions to acquire?
	//if (to_lowercase(my_name()) == "crovax1234")
	
	if (!(available_amount($item[Goggles of loathing]) > 0 && available_amount($item[Stick-Knife of loathing]) > 0 && available_amount($item[Scepter of loathing]) > 0 && available_amount($item[Jeans of loathing]) > 0 && available_amount($item[Treads of loathing]) > 0 && available_amount($item[Belt of loathing]) > 0))
	{
		print("Missing part of the clothing of loathing outfit.", "red");
		return false;
	}
	
	//Learn hobopolis skills:
	if (item_amount($item[Unearthed volcanic meteoroid]) > 0 && !have_skill($skill[Volcanometeor Showeruption]))
	{
		//We have a volcanic meteroid, why not use it?
		cli_execute("use Unearthed volcanic meteoroid");
	}
	if (!have_skill($skill[Awesome Balls of Fire]) && !have_skill($skill[Volcanometeor Showeruption]))
		cli_execute("use Kissin' Cousins");
	if (!have_skill($skill[Snowclone]))
		cli_execute("use Blizzards I Have Died In");
	if (!have_skill($skill[Raise Backup Dancer]))
		cli_execute("use Let Me Be!");
	if (!have_skill($skill[Grease Lightning]))
		cli_execute("use Summer Nights");
	if (!have_skill($skill[Eggsplosion]))
		cli_execute("use Biddy Cracker's Old-Fashioned Cookbook");
		
	if (!have_skill($skill[toynado]))
	{
		//Try to acquire toynado:
		//First we check for used copies (unlimited use), then we try looking for non-used copies.
		if (item_amount($item[tales of a kansas toymaker (used)]) > 0)
			cli_execute("use tales of a kansas toymaker (used)");
		else if (closet_amount($item[tales of a kansas toymaker (used)]) > 0)
		{
			boolean can_use = user_confirm("You have Tales of a Kansas Toymaker (used) in your closet. Can I temporarily take it out? (you won't lose it))");
			if (can_use)
			{
				cli_execute("closet take tales of a kansas toymaker (used)");
				cli_execute("use tales of a kansas toymaker (used)");
				cli_execute("closet put tales of a kansas toymaker (used)");
			}
			else
			{
				print("Please take out Tales of a Kansas Toymaker (used) from your closet", "red");
				return false;
			}
			
		}
		else if (display_amount($item[tales of a kansas toymaker (used)]) > 0)
		{
			boolean can_take_out = user_confirm("You have Tales of a Kansas Toymaker (used) in your display case. Can I temporarily take it out? (you won't lose it)");
			if (can_take_out)
			{
				cli_execute("display take tales of a kansas toymaker (used)");
				cli_execute("use tales of a kansas toymaker (used)");
				cli_execute("display put tales of a kansas toymaker (used)");
			}
			else
			{
				print("Please take out Tales of a Kansas Toymaker (used) from your display case.", "red");
				return false;
			}
		}
		else if (item_amount($item[tales of a kansas toymaker]) > 0)
		{
			boolean can_use = user_confirm("You have Tales of a Kansas Toymaker. Can I use it? (it'll turn into a reusable, but untradable copy)");
			if (can_use)
				cli_execute("use tales of a kansas toymaker");
		}
		else if (closet_amount($item[tales of a kansas toymaker]) > 0)
		{
			boolean can_use = user_confirm("You have Tales of a Kansas Toymaker in your closet. Can I use it? (it'll turn into a reusable, but untradable copy)");
			if (can_use)
			{
				cli_execute("closet take tales of a kansas toymaker");
				cli_execute("use tales of a kansas toymaker");
			}
		}
		//We could check their display case for another one and take it out, but if someone put it in their display case, they probably don't want it gone.
	}
	if (!have_skill($skill[Toynado]))
	{
		//Tales of a kansas toymaker is expensive (25k), and supply is very limited. So, the user should buy one by hand.
		if (display_amount($item[tales of a kansas toymaker]) > 0)
			print("You should take Tales of a Kansas Toymaker out of your display case, buy it in the mall, or otherwise acquire one.", "red");
		else
			print("You should buy Tales of a Kansas Toymaker in the mall, or otherwise acquire one.", "red");
		return false;
	}
	
	//Mafia may not auto-buy the skillbooks, so double check
	if ((!have_skill($skill[Awesome Balls of Fire]) && !have_skill($skill[Volcanometeor Showeruption])) || !have_skill($skill[Snowclone]) || !have_skill($skill[Eggsplosion]) || !have_skill($skill[Raise Backup Dancer]) || !have_skill($skill[Grease Lightning]))
	{
		print("Missing one or more of the hobopolis skills.", "red");
		return false;
	}
	
	//Equip a useful back item:
	if (breathing_source != "old scuba tank")
		cli_execute("maximize all res -hat -weapon -offhand -shirt -pants -acc1 -acc2 -acc3 -familiar -tie");
	
	//Equip a useful shirt:
	cli_execute("maximize all res -hat -weapon -offhand -back -pants -acc1 -acc2 -acc3 -familiar -tie");
	
	//Equip the rest of the outfit:
	if (breathing_source == "old scuba tank" || breathing_source == "Really Deep Breath")
	{
		if (breathing_source == "old scuba tank")
			cli_execute("equip old scuba tank");
		cli_execute("equip goggles of loathing; equip stick-knife of loathing; equip scepter of loathing; equip jeans of loathing; equip acc1 treads of loathing; equip acc2 belt of loathing");
		if (available_amount($item[pocket square of loathing]) > 0)
			cli_execute("equip acc3 pocket square of loathing");
		else
			cli_execute("maximize all res -hat -weapon -offhand -back -shirt -pants -acc1 -acc2 -familiar -tie"); //pick a good resist all accessory in acc3
	}
	else if (breathing_source == "makeshift scuba gear")
	{
		cli_execute("equip goggles of loathing; equip stick-knife of loathing; equip scepter of loathing; equip jeans of loathing; equip acc1 treads of loathing");
		if (available_amount($item[pocket square of loathing]) > 0)
			cli_execute("equip acc2 pocket square of loathing");
		else
			cli_execute("equip acc2 belt of loathing");
		cli_execute("equip acc3 makeshift scuba gear");
	}
	else if (breathing_source == "aerated diving helmet")
	{
		cli_execute("equip aerated diving helmet");
		cli_execute("equip stick-knife of loathing; equip scepter of loathing; equip jeans of loathing; equip acc1 treads of loathing; equip acc2 belt of loathing; equip acc3 pocket square of loathing");
	}
	
	int absolute_minimum_mp = 0;
	if (have_skill($skill[Volcanometeor Showeruption]))
		absolute_minimum_mp = 6 * (120 + combat_mana_cost_modifier());
	else
		absolute_minimum_mp = 10 * (120 + combat_mana_cost_modifier());
	
	//Note that this is modified by buffs that will disappear, so it may not be accurate.
	if (my_maxmp() < absolute_minimum_mp)
	{
		print("Base MP is too low. You need at least " + absolute_minimum_mp + " maximum MP, and you have " + my_maxmp() + ".", "red");
		return false;
	}
	
	if (have_skill($skill[Volcanometeor Showeruption]))
		cli_execute("acquire 6 volcanic ash");
	
	return true;
}

void main()
{
	if (have_effect($effect[beaten up]) > 0)
		cli_execute("uneffect beaten up");
	
	boolean ready = prepareForDadFight();
	if (!ready)
	{
		return;
	}
	
	//Restore HP/MP to 100%:
	restore_hp(my_maxhp() - 10);
	restore_mp(my_maxmp() - 10);
	
	string temple_text = visit_url("sea_merkin.php?action=temple");
	if (contains_text(temple_text, "The temple is empty."))
	{
		print("The temple is empty.", "red");
		return;
	}
	if (contains_text(temple_text, "You can't go in there -- your familiar wouldn't be able to breathe!"))
	{
		print("Your familiar can't breathe underwater.", "red");
		return;
	}
	if (!contains_text(temple_text, "The temple door is unattended"))
	{
		print("Unknown temple error.", "red");
		print("Result was " + temple_text);
		return;
	}
	
	//Do choices:
	visit_url("choice.php?whichchoice=714&option=1"); //go to Life in the Stillness
	visit_url("choice.php?whichchoice=715&option=1"); //go to An Unguarded Door (2)
	string fight_text = visit_url("choice.php?whichchoice=716&option=1"); //Go inside
	
	boolean intentionally_lose = false; //used for testing
	boolean setting_output_optional_information = true;

	doFight(fight_text, false, intentionally_lose, setting_output_optional_information);
}