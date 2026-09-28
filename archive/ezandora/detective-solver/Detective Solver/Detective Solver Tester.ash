import "Detective Solver Test Data.ash";
import "Detective Solver.ash";

//Detective Solver Tester.ash
//Runs internal parsing tests on collected data.
//This script is in the public domain.

void main()
{
	__abort_on_match_failure = true;
	//print_html("__core_text_test_data = " + __core_text_test_data.to_json());
	//print_html("__core_text_test_data has " + __core_text_test_data.count() + " responses.");
	Individual blank_existing_individual;
	blank_existing_individual.exists = true;
	
	boolean [string] seen_names;
	boolean [string] seen_locations;
	boolean [string] seen_occupations;
	string last_percent_output = "";
	foreach key in __core_text_test_data
	{
		string url = __core_text_test_data[key][0];
		string page_text = __core_text_test_data[key][1];
		if (false && !url.contains_text("ask=killer")) //only killers
			continue;
		if (false && !(!url.contains_text("ask=killer") && !url.contains_text("ask=rel") && url.contains_text("ask="))) //only non-rel asks
			continue;
		if (false && !(!url.contains_text("ask=killer") && url.contains_text("ask=rel"))) //only rel asks
			continue;
		string percent_output = (key.to_float() / __core_text_test_data.count().to_float() * 100).round();
		if (last_percent_output != percent_output)
		{
			print_html(percent_output + "% done");
			last_percent_output = percent_output;
		}
		//print_html("On url " + url);
		CoreTextMatch match = parseCoreText(blank_existing_individual, url, page_text);
		if (match.type == CORE_TEXT_MATCH_TYPE_NAME)
			seen_names[match.match] = true;
		else if (match.type == CORE_TEXT_MATCH_TYPE_LOCATION)
			seen_locations[match.match] = true;
		else if (match.type == CORE_TEXT_MATCH_TYPE_OCCUPATION)
			seen_occupations[match.match] = true;
	}
	print_html("Names: = " + seen_names.lineariseMap());
	print_html("");
	print_html("Locations: = " + seen_locations.lineariseMap());
	print_html("");
	print_html("Occupations: = " + seen_occupations.lineariseMap());
	
	//Verify they don't contain each other:
	//This means one of the regexes is inappropriately marked.
	foreach s in seen_names
	{
		foreach s2 in seen_locations
		{
			if (s == s2)
			{
				print_html("ERROR: seen_names and seen_locations both have \"" + s + "\"");
			}
		}
		foreach s2 in seen_occupations
		{
			if (s == s2)
			{
				print_html("ERROR: seen_names and seen_locations both have \"" + s + "\"");
			}
		}
	}
	foreach s in seen_locations
	{
		foreach s2 in seen_occupations
		{
			if (s == s2)
			{
				print_html("ERROR: seen_names and seen_locations both have \"" + s + "\"");
			}
		}
	}
}