string [int] messages = {"be excellent to each other", "be good, alright", "Life is to be worn gloriously. Until our last moment, the future is what we make."};
string id_property_name = "ezandoraBurnFirewoodLastMessageNumber";

string pickNextMessage()
{
	//confirmed supported characters: ,.'"
	if (messages.count() == 0) return "";
	if (messages.count() == 1) return messages[0]; //random(1) doesn't work
	return messages[random(messages.count())];
}

void main()
{
	if (can_interact())
	{
		cli_execute("pull * stick of firewood");
		cli_execute("pull * campfire smoke");
	}
	if ($item[stick of firewood].item_amount() != 0)
	{
		cli_execute("make " + $item[stick of firewood].item_amount() + " campfire smoke");
	}
	int smoke_used = 0;
	while ($item[campfire smoke].item_amount() > 0)
	{	
		visit_url("inv_use.php?whichitem=10313");
		smoke_used += 1;
		
		string message = pickNextMessage();
		
		if (message == "")
			message = "be excellent to each other";
		
		print("Sending up smoke message \"" + message + "\"");
		visit_url("choice.php?whichchoice=1394&option=1&message=" + message);
		set_property(id_property_name, get_property(id_property_name).to_int() + 1);
		//if (smoke_used >= $item[campfire smoke].item_amount() - 1)
			//cli_execute("refresh inventory");
	}
}