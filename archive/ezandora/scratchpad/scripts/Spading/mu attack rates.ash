import "scripts/Helix Fossil/Helix Fossil/Library.ash";

void main(int samples_wanted)
{
	location using_location = $location[the neverending party];
	using_location = $location[Hamburglaris Shield Generator];
	//int samples_wanted = 1;
	
	cli_execute("familiar mu");
	int starting_familiar_weight = $familiar[mu].familiar_weight();
	for i from 1 to samples_wanted
	{
		if ($familiar[mu].familiar_weight() != starting_familiar_weight && numeric_modifier("familiar weight") < 30)
		{
			print_html("Mu gained a pound.");
			break;
		}
		restore_hp(my_maxhp());
		restore_mp(MIN(300, my_maxmp() / 2));
		cli_execute("gain 1500 muscle 4 efficiency");
		if (using_location == $location[Hamburglaris Shield Generator] && $effect[Transpondent].have_effect() == 0)
		{
			cli_execute("up Transpondent");
		}
		//int target_muscle = MAX(1500, MIN(5000, my_basestat($stat[muscle]) * 5));
		//cli_execute("gain.ash " + target_muscle + " muscle");
		int familiar_weight = MAX(1, my_familiar().familiar_weight() + numeric_modifier("familiar weight"));
		buffer initial_text = visit_url(using_location.to_url());
		
		
		if (initial_text.contains_text("It Hasn't Ended, It's Just Paused"))
			visit_url("choice.php?whichchoice=1324&option=5");
		string macro = "while !pastround 29; use seal tooth; endwhile;";
		if (true || using_location != $location[the neverending party])
			macro = "use seal tooth; repeat;"; //get beaten up, more data points
		buffer page_text = submitMacro(macro);
		
		int seal_tooth_matches = page_text.group_string("You scratch your opponent with your seal tooth").count();
		int mu_matches = page_text.group_string("Bubble attacks your foes with some kind of crazy rainbow space laser").count() + page_text.group_string("Bubble blasts your enemies with multicolored").count() + page_text.group_string("Bubble sings a cheerful tune as it mows your enemies down with multicolored bolts of space energy").count();
		
		foreach s in $strings[Bubble attacks your foes with some kind of crazy rainbow space laser for (.*?) damage,Bubble sings a cheerful tune as it mows your enemies down with multicolored bolts of space energy\, causing (.*?) damage,Bubble blasts your enemies with multicolored psychic bolts for (.*?) damage!]
		{
			string [int][int] match = page_text.group_string(s);
			//print_html("match = " + match.to_json().entity_encode());
			foreach key in match
			{
				string damage = match[key][1];
				if (damage == "") continue;
				//V0 doesn't have monster_level_adjustment()
				string line = gametime_to_int() + "," + familiar_weight + "," + monster_level_adjustment() + "," + damage;
				logprint("MU_DAMAGE_SPADING_V1: " + line);
			}
		}
		
		submitMacro("skill saucegeyser; repeat;"); //introduces bias, otherwise
		if (seal_tooth_matches > 0)
		{
			string line = gametime_to_int() + "," + familiar_weight + "," + seal_tooth_matches + "," + mu_matches;
			print_html(line);
			logprint("MU_SPADING_V3: " + line);
		}
		
		run_turn();
	}
}