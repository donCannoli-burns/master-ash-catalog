//c2t trainer
//c2t

//trains people with your crimbo training manual if they send you a kmail with the message "trainme"


import <zlib.ash>

//flag to mark item use as it only needs to be used the first time no matter how many attempts
boolean c2t_trainer_first = true;

//print
void c2t_trainer_print(string s,string c) {
	print(`c2t_trainer: {s}`,c);
}
void c2t_trainer_print(string s) {
	c2t_trainer_print(s,"");
}

//train from kmessage
boolean c2t_trainer_train(kmessage m) {
	string player = `{m.fromname} (#{m.fromid})`;
	buffer buf;

	//manual used today
	if (get_property("_crimboTraining").to_boolean())
		return false;
	//manual in inventory
	if (item_amount($item[crimbo training manual]) == 0)
		return false;

	//use manual
	if (c2t_trainer_first) {
		buf = visit_url(`inv_use.php?pwd={my_hash()}&which=3&whichitem=11046`,false,true);

		c2t_trainer_first = false;

		if (buf.contains_text("You've already trained somebody today."))
			return false;
	}

	//train
	buf = visit_url(`curse.php?pwd&action=use&whichitem=11046&targetplayer={m.fromid}`,true,true);
	//"You train <playername>."
	if (buf.contains_text('<table><tr><td>You train '))
		c2t_trainer_print(`{player} was trained`,"blue");
	//already know skill
	else if (buf.contains_text('They already know that skill.'))
		c2t_trainer_print(`{player} already knows the skill`);
	//on their ignore list
	else if (buf.contains_text("You can't use this item on somebody whose ignore list you're on."))
		c2t_trainer_print(`{player} ignores you`);
	//ronin/hardcore
	else if (buf.contains_text("That item cannot be used on a player in Ronin or Hardcore.")) {
		c2t_trainer_print(`{player} is in ronin or hardcore`);
		return false;
	}
	//unknown error
	else {
		c2t_trainer_print(`unknown error trying to train {player}`,"red");
		return false;
	}

	return true;
}

//process kmails via zlib process_kmail()
boolean c2t_trainer_processRequests(kmessage m) {
	boolean result = false;
	matcher mat = create_matcher("\\s",m.message.to_lower_case());
	if (replace_all(mat,"") == "trainme") {
		result = c2t_trainer_train(m);
		//result = false;//for testing purposes
	}
	return result;
}

//function to call if importing
void c2t_trainer() {
	if (get_property("_crimboTraining").to_boolean()) {
		c2t_trainer_print("already trained today");
		return;
	}
	if (item_amount($item[crimbo training manual]) == 0) {
		c2t_trainer_print("no crimbo training manual on hand","red");
		return;
	}
	c2t_trainer_first = true;
	c2t_trainer_print("processing kmails...");
	process_kmail("c2t_trainer_processRequests");
	c2t_trainer_print("done");
}

//can run script from CLI
void main() c2t_trainer();

