//insertSelect2
//c2t

//makes select elements searchable with select2 by inserting things where needed to make that happen
//see select2.org for details on select2

//page is the html of the page to be modified
//options is used to tweak select2-specific options in case the default isn't adequate; omitting or passing an empty string uses select2 defaults
//returns the page modified with select2 inserted where needed
string insertSelect(string page);
string insertSelect(string page,string options);

/*implementations*/

string insertSelect2(string page,string options) {
	string out = page;
	matcher m;
	int count;

	//only insert things once
	if (out.contains_text("jQuery_3_7_1('.searchable-select').select2("))
		return out;

	//insert class into existing class in select
	m = create_matcher(`<select([^>]*class=["'])([^"']*)(["'][^>]*)>`,out);
	if (m.find()) {
		out = replace_all(m,'<select$1$2 searchable-select$3>');
		count++;
	}

	//insert class into select if no class exists
	m = create_matcher('<select(((?!class=)[^>])*)>',out);
	if (m.find()) {
		out = replace_all(m,'<select class="searchable-select"$1>');
		count++;
	}

	//insert scripts and CSS so the above changes actually do something, but only if something was changed
	if (count > 0)
		out = out.replace_string('</head>',`<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script><link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" /><script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script><script type="text/javascript">var jQuery_3_7_1 = $.noConflict(true);jQuery_3_7_1(document).ready(function() \{jQuery_3_7_1('.searchable-select').select2(\{{options}\});\});</script></head>`);

	return out;
}

string insertSelect2(string page) {
	return insertSelect2(page,"");
}

