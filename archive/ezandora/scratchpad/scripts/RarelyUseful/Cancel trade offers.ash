import "relay/Guide/Support/List.ash";

void main()
{
	buffer page_text = visit_url("makeoffer.php");
	
	int limit = 100;
	while (page_text.contains_text("Offer from") && limit > 0)
	{
		limit -= 1;
		string [int][int] name_matches = page_text.group_string("<p>Offer from (.*?) \\(");
		string [int][int] matches = page_text.group_string("makeoffer.php.action=decline&whichoffer=([0-9]*)");
		
		boolean [string] people_sending_offers;
		foreach key in name_matches
			people_sending_offers[name_matches[key][1]] = true;
			
		int [int] cancelation_ids;
		foreach key in matches
		{
			cancelation_ids.listAppend(matches[key][1].to_int());
		}
		if (cancelation_ids.count() == 0)
			break;
		
		print_html(cancelation_ids.count() + " offers: " + people_sending_offers.listInvert().listJoinComponents(", ", "and"));
		//print_html("Cancelation IDs: " + cancelation_ids.listJoinComponents(", ", "and"));
		
		page_text = visit_url("makeoffer.php?action=decline&whichoffer=" + cancelation_ids[0]);
	}
}