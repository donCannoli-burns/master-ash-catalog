import "scripts/Library/ArchiveEquipment.ash";

//No option for encoded; we do that ourselves.
buffer visit_url_arguments(string base_url, string [string] options, boolean use_post)
{
	//Construct URL:
	buffer url;
	url.append(base_url);
	if (options.count() > 0)
	{
		url.append("?");
		options["pwd"] = my_hash();
		
		boolean first = true;
		foreach key, value in options
		{
			if (!first)
				url.append("&");
			else
				first = false;
			url.append(key);
			url.append("=");
			url.append(value);
		}
	}
	return visit_url(url, use_post, false);
}

buffer visit_url_arguments(string base_url, string [string] options)
{
	return visit_url_arguments(base_url, options, true);
}


void main()
{
	if (!hippy_stone_broken()) return;
	if (pvp_attacks_left() <= 0) return;
	
	ArchivedEquipment ae = ArchiveEquipment();
	boolean ignore = cli_execute("call scripts/PVP/Prepare to PVP.ash");
	
	int breakout = 50;
	while (pvp_attacks_left() > 0 && breakout > 0)
	{
		breakout -= 1;
		string ranked = "2";
		string who = "";
		string stance = get_property("ezandoraChosenPVPStance").to_int();
		string attacktype = "fame";
		string win_message = "-1";
		string lose_message = "-1";
		
		string [string] options =
		{"action":"fight", "place":"fight", "ranked":ranked, "who":who, "stance":stance, "attacktype":attacktype, "winmessage":win_message, "losemessage":lose_message};
		
		buffer page_text = visit_url_arguments("peevpee.php", options);
		
		if (page_text.contains_text("<b>" + my_name() + "</b> won the fight"))
		{
			print_html("won");
			break;
		}
		else
		{
			print_html("loss");
		}
	}
	//affects purity:
	if (false && can_interact() && $effect[Stark Raven Mad].have_effect() == 0 && $item[ravenous eye].historical_price() <= 500)
	{
		cli_execute("use ravenous eye");
	}
	ae.RestoreArchivedEquipment();
}