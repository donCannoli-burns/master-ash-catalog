int beerPongResponseForText(string page_text, int round_number)
{
	if (contains_text(page_text, "You attempt to make up for the slip, but it's too late -- your nerve has been broken, and you soon find yourself pushing your way through the crowd, away from the beer pong table and the jeering cat-calls of Old Don Rickets."))
    {
        print("failure", "red");
		return 0;
    }
    
    int [string] text_to_id;
    text_to_id["Arrr, the power of me serve'll flay the skin from yer bones!"] = 1;
    text_to_id["Do ye hear that, ye craven blackguard"] = 2;
    text_to_id["ye miserable, pestilent wretch"] = 3;
    text_to_id["The streets will run red with yer blood when I'm through with ye"] = 4;
    text_to_id["Yer face is as foul as that of a drowned goat!"] = 5;
    text_to_id["When I'm through with ye, ye'll be crying like a little girl"] = 6;
    text_to_id["In all my years I've not seen a more loathsome worm than yerself"] = 7;
    text_to_id["Not a single man has faced me and lived to tell the tale"] = 8;
    
    int found_id = -1;
    foreach text, id in text_to_id
    {
        if (page_text.contains_text(text))
        {
            found_id = id;
            break;
        }
    }
    if (found_id == -1)
    {
        abort("/!\\ Unknown pirate insult /!\\");
        return 0;
    }
    
    if (get_property("lastPirateInsult" + found_id).to_boolean())
    {
        print("PIRATE_INSULTS_FOUND," + my_turncount() + "," + round_number + "," + found_id, "red");
        return found_id;
    }
    print("PIRATE_INSULTS_NOT_FOUND Round " + round_number + " unable to find insult " + found_id + ", giving up", "red");
    return 9; //default, always available
}

void doFakeInsultBeerPong()
{
	string text = visit_url("adventure.php?snarfblat=157");
	//step up:
	//beerpong.php?response=1
	text = visit_url("choice.php?whichchoice=187&option=1");
	int response = beerPongResponseForText(text, 1);
	if (response == 0)
		return;
	text = visit_url("beerpong.php?response=" + response);

	response = beerPongResponseForText(text, 2);
	if (response == 0)
		return;
	text = visit_url("beerpong.php?response=" + response);

	response = beerPongResponseForText(text, 3);
	if (response == 0)
		return;
	response = 13;
	text = visit_url("beerpong.php?response=" + response);
}


void main()
{
	while (my_adventures() > 0)
		doFakeInsultBeerPong();
}