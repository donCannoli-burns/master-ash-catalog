//c2t choices mapgrim
//c2t

//automate the choices for maps to safety shelter grimace prime to evenly get pills
//can be used at any point where kolmafia might have stopped its automation of the choice chain to resume
//note that it won't do anything if you go off the normal course that gets pills
//returns true only if the pill was obtained
boolean c2t_choices_mapgrim();

//try to do choice without exploding on server errors
void c2t_choices_mapgrim_tryChoice(int option);

//print formatted message
void c2t_choices_mapgrim_print(string s);
void c2t_choices_mapgrim_print(string s,string color);

//can call script from CLI
void main() c2t_choices_mapgrim();

boolean c2t_choices_mapgrim() {
	//make sure we're in the choice adventure to do anything
	if (!handling_choice() || last_choice() != 536)
		return false;

	item pill;
	int target;
	if (available_amount($item[distention pill]) < available_amount($item[synthetic dog hair pill])) {
		pill = $item[distention pill];
		target = 1;
	}
	else {
		pill = $item[synthetic dog hair pill];
		target = 2;
	}
	int start = available_amount(pill);

	//keep trying even on server errors
	int tries = 0,max = 5;
	repeat {
		//do the choice chain to evenly get pills
		if (available_choice_options()[1] == "Down the Hatch!")
			c2t_choices_mapgrim_tryChoice(1);
		if (available_choice_options()[1] == "Have a Drink")
			c2t_choices_mapgrim_tryChoice(1);
		if (available_choice_options()[2] == "Try That One Door")
			c2t_choices_mapgrim_tryChoice(2);
		if (available_choice_options()[1] == "Follow Captain Smirk")
			c2t_choices_mapgrim_tryChoice(target);
		//if still in choice, give it a few seconds before trying again
		if (handling_choice()) {
			c2t_choices_mapgrim_print("problem encountered while handling the choice","blue");
			if (++tries < max) {
				c2t_choices_mapgrim_print("waiting a few seconds to try again","blue");
				wait(5);
			}
			else {
				c2t_choices_mapgrim_print(`giving up after {tries} tries`,"red");
				return false;
			}
		}
	} until (!handling_choice());
	return start < available_amount(pill);
}

void c2t_choices_mapgrim_tryChoice(int option) {
	cli_execute(`try;choice {option}`);
}

void c2t_choices_mapgrim_print(string s,string color) {
	print(`c2t_choices_mapgrim: {s}`,color);
}
void c2t_choices_mapgrim_print(string s) {
	c2t_choices_mapgrim_print(s,"");
}

