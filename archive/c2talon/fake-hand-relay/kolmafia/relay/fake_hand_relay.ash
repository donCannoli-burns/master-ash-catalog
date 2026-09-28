//fake hand relay
//c2t

//used to compress display of fake hands into one line
//works for charsheet.php, inventory.php, and showplayer.php


buffer fake_hand_relay(buffer page) {
	int num = 0;
	string part = "<b>fake hand</b>";
	string row;

	switch (get_path()) {
		default:
			return page;
		case "inventory.php":
			row = `<tr><td[^>]*><a[^>]*>Off-Hand</a>:</td><td><img[^>]*></td><td><b>fake hand</b>\\s+<a[^>]*><font[^>]*>\\[unequip\\]</font></a></td></tr>`;
			break;
		case "charsheet.php":
		case "showplayer.php":
			row = `<tr><td[^>]*><img[^>]*></td><td[^>]*><b>fake hand</b></td></tr>`;
			break;
	}

	matcher m = create_matcher(part,page);

	while (m.find())
		num++;

	if (num == 0)
		return page;

	m = create_matcher(part,page);
	page = replace_first(m,`<b>fake hand ({num})</b>`).to_buffer();
	m = create_matcher(row,page);
	page = replace_all(m,"").to_buffer();

	return page;
}

buffer fake_hand_relay() {
	return fake_hand_relay(visit_url());
}

