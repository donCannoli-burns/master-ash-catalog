//Warning: will punch open all of your calendar.
void main()
{
	string [int, int] parsed = visit_url("campground.php?action=advent").group_string("=campground.php.preaction=openadvent&whichadvent=([0-9]*)>");
	
	foreach key in parsed
	{
		string id = parsed[key][1];
		if (id.is_integer())
			visit_url("campground.php?preaction=openadvent&whichadvent=" + id);
	}
}