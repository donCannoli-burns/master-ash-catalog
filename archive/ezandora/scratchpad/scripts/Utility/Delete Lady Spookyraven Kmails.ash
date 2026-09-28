//This script is public domain.
//It will probably delete all of your kmails.
//Also deletes kmails from other sources.

Record KMail
{
	string id;
	string type;
	string fromid;
	string azunixtime;
	string message;
	string fromname;
	string localtime;
};

KMail [int] KMailGetAllKMails()
{
	buffer kmail_text = visit_url("api.php?what=kmail&count=100&for=ezandora_crimbo2020_crates");
	
	buffer processing_text = kmail_text.replace_string("\\\"", "•"); //parsing hack
	
	string [int][int] kmail_matches = kmail_text.group_string("\\{\"id\":\"([^\"]*)\",\"type\":\"([^\"]*)\",\"fromid\":\"([^\"]*)\",\"azunixtime\":\"([^\"]*)\",\"message\":\"([^\"]*)\",\"fromname\":\"([^\"]*)\",\"localtime\":\"([^\"]*)\"}");
	KMail [int] kmails;
	foreach key in kmail_matches
	{
		string [int] line = kmail_matches[key];
		KMail k;
		k.id = line[1];
		k.type = line[2];
		k.fromid = line[3];
		k.azunixtime = line[4];
		k.message = line[5].replace_string("•", "\\\"");
		k.fromname = line[6];
		k.localtime = line[7];
		kmails[kmails.count()] = k;
	}
	return kmails;
}

void KMailSaveKmail(KMail k)
{
	string command = "messages.php?the_action=save&box=Inbox";
	command += "&sel" + k.id + "=on";
	visit_url(command);
}
void KMailDeleteKmail(KMail k)
{
	string command = "messages.php?the_action=delete&box=Inbox";
	command += "&sel" + k.id + "=on";
	visit_url(command);
}

void main()
{
	buffer kmail_text = visit_url("api.php?what=kmail&count=100&for=deleting_kmails");
	
	buffer processing_text = kmail_text.replace_string("\\\"", "•"); //parsing hack
	
	string [int][int] kmail_matches = processing_text.group_string("\\{\"id\":\"([^\"]*)\",\"type\":\"([^\"]*)\",\"fromid\":\"([^\"]*)\",\"azunixtime\":\"([^\"]*)\",\"message\":\"([^\"]*)\",\"fromname\":\"([^\"]*)\",\"localtime\":\"([^\"]*)\"}");
	
	KMail [int] kmails;
	foreach key in kmail_matches
	{
		string [int] line = kmail_matches[key];
		KMail k;
		k.id = line[1];
		k.type = line[2];
		k.fromid = line[3];
		k.azunixtime = line[4];
		k.message = line[5];
		k.fromname = line[6];
		k.localtime = line[7];
		kmails[kmails.count()] = k;
	}
	KMail [int] kmails_to_delete;
	foreach key, kmail in kmails
	{
		boolean passes_tests = false;
		//print_html("from: \"" + kmail.fromname + "\" id: " + kmail.fromid);
		int id = kmail.fromid.to_int();
		if (id == 0)
		{
			if (kmail.fromname == "Lady Spookyraven's Ghost" || kmail.fromname == "The Loathing Postal Service")
			{
				boolean has_verified_message = false;
				foreach s in $strings[I am almost ready to leave this world,We found this telegram at the bottom of an old bin of mail,To the third floor of the Manor!] //'
				{
					if (kmail.message.contains_text(s))
					{
						has_verified_message = true;
						break;
					}
				}
				if (has_verified_message)
					passes_tests = true;
			}
			if (kmail.fromname == "Subject 37")
			{
				if (!kmail.message.contains_text("My escape went off without a hitch, and I've made my way safely home."))
					continue;
				if (!kmail.message.contains_text("I couldn't have done it without you"))
					continue;
				if (!kmail.message.contains_text("please accept this charm as a token of my thanks"))
					continue;
				if (!kmail.message.contains_text("Perhaps it will aid you in your future endeavors"))
					continue;
				if (!kmail.message.contains_text("Subject 37"))
					continue;
				if (!kmail.message.contains_text("You acquire an item"))
					continue;
				if (!kmail.message.contains_text("mysterious silver lapel pin"))
					continue;
				passes_tests = true;
				
			}
		}
		if (id == -1)
		{
			if (kmail.fromname == "Batfellow")
			{
				if (!kmail.message.contains_text("Your dedication to helping me fight crime in Gotpork city almost makes me forget about the fact that crime in Gotpork city cost me my parents."))
					continue;
				if (!kmail.message.contains_text("Please accept this as a reminder of how special you are."))
					continue;
				if (!kmail.message.contains_text("You acquire an item:"))
					continue;
				if (!kmail.message.contains_text("special edition Batfellow comic"))
					continue;
				passes_tests = true;
			}
		}
		if (id == 3038166) //Cheesefax
		{
			//print_html(kmail.message.entity_encode());
			if (!kmail.message.contains_text("CheeseFax completed your relationship fortune test!"))
				continue;
			if (!kmail.message.contains_text("Here are your results:"))
				continue;
			if (!kmail.message.contains_text("compatibility: "))
				continue;
			if (!kmail.message.contains_text("You acquire an item:"))
				continue;
			if (kmail.message.index_of("You acquire an item:") != kmail.message.last_index_of("You acquire an item:")) //two items
				continue;
			passes_tests = true;
		}
		if (id == 3342574)
		{
			if (!kmail.message.contains_text("Peace and Love"))
				continue;
			if (!kmail.message.contains_text("You acquire an item:"))
				continue;
			passes_tests = true;
		}
		
		if (!passes_tests) continue;
		kmails_to_delete[kmails_to_delete.count()] = kmail;
	}
	
	//print_html("Deleting " + kmails_to_delete.count());
	//return;
	if (kmails_to_delete.count() == 0)
		return;
	boolean yes = true; //user_confirm(kmails_to_delete.count() + " kmails to delete. READY?");
	if (!yes)
		return;
	string deletion_command = "messages.php?the_action=delete&box=Inbox";
	foreach key, kmail in kmails_to_delete
	{
		deletion_command += "&sel" + kmail.id + "=on";
	}
	visit_url(deletion_command);
	print(kmails_to_delete.count() + " kmails deleted.");
	//print_html("deletion_command = " + deletion_command);
	//return;
	//messages.php?the_action=delete&pwd&box=Inbox&sel130286567=on
	
	//print_html("kmails_to_delete = " + kmails_to_delete.to_json());
	//kmail_matches
	
	//[{"id":"130286425","type":"normal","fromid":"1557284","azunixtime":"1470249592","message":"&quot;}][,:","fromname":"Ezandora","localtime":"08\/03\/16 06:39:52 PM"}
	
	/*kmail_text.replace_string("\\.", "•"); //parsing hack
	//kmail_text.replace_string("\\\"", "•");
	
	string [int][int] kmail_group_matches = kmail_text.group_string("{([^}]*)}");
	
	
	foreach key in kmail_group_matches
	{
		string line = kmail_group_matches[key][1];
		
		string [int][int] matches_2 = line.group_string("\"([^\"]*)\":\"([^\"]*)\"");
		
		string [string] associations;
		foreach key2 in matches_2
		{
			string k = matches_2[key2][1];
			string v = matches_2[key2][2];
			associations[k] = v;
		}
		print_html("associations = " + associations.to_json());
		return;
	}*/
	
	//string [int][int] matches = kmail_text.group_string("{\"id\":\"130286382\",\"type\":\"normal\",\"fromid\":\"629293\",\"azunixtime\":\"1470249009\",\"message\":\"([^\"])*\"
}