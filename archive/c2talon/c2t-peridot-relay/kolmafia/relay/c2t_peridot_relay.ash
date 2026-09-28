//c2t takerSpace relay
//c2t


//returns modified page for the relay browser
string c2t_peridot_relay(string page) {
	buffer out = page;
	matcher mat = create_matcher('(name="bandersnatch" value="(\\d+)" />\\s*<input type="submit" class="button" value=")[^"]+(" />)',page);
	while (mat.find()) {
		monster mon = mat.group(2).to_monster();
		out.replace_string(mat.group(0),`{mat.group(1)}[{mon.id}] {mon.name}{mat.group(3)}`);
	}
	return out;
}


