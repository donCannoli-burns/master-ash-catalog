//c2t mapgrim
//c2t

//evenly acquires distention pills and dog hair pills using maps to grimace prime

import <c2t_choices_mapgrim.ash>

boolean c2t_mapgrim_cli;

//function to import and call
//returns true if sucessfully completed
boolean c2t_mapgrim();

//handles and displays error message
//returns false always
boolean c2t_mapgrim_error(string s);


//for the CLI
void main() {
	c2t_mapgrim_cli = true;
	c2t_mapgrim();
}

boolean c2t_mapgrim() {
	item it = $item[Map to Safety Shelter Grimace Prime];
	string out;
	while (my_adventures() > 1 && available_amount(it) > 0) {
		//get effect to adventure in zone if needed
		if (have_effect($effect[Transpondent]) == 0 && available_amount($item[transporter transponder]) > 0)
			use(1,$item[transporter transponder]);
		if (have_effect($effect[Transpondent]) == 0)
			return c2t_mapgrim_error(`Unable to get the Transpondent effect. Still have {available_amount(it)} {available_amount(it) != 1?it.plural:it}.`);

		//use item with visit_url() to circumvent kolmafia automation and use choices script to get pills
		if (!handling_choice() || last_choice() != 536)
			visit_url(`inv_use.php?pwd={my_hash()}&which=3&whichitem={it.id}`,false,true);
		if (!c2t_choices_mapgrim())
			return c2t_mapgrim_error(`Something broke using {it.plural}.`);
	}

	if (available_amount(it) == 0) {
		print(`Finished using all {it.plural}.`,'blue');
		return true;
	}
	else if (my_adventures() <= 1) {
		print(`Ran out of adventures to use {it.plural}. {available_amount(it)} remain.`,"blue");
		return false;
	}

	return c2t_mapgrim_error(`Something broke using {it.plural}.`);
}

boolean c2t_mapgrim_error(string s) {
	string out = `c2t_mapgrim error: {s}`;
	if (c2t_mapgrim_cli)
		abort(out);
	print(out,"red");
	return false;
}

