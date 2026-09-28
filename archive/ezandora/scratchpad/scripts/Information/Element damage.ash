void main()
{
	string [element] colours_for_elements;
	colours_for_elements[$element[cold]] = "blue";
	colours_for_elements[$element[hot]] = "red";
	colours_for_elements[$element[spooky]] = "gray";
	colours_for_elements[$element[stench]] = "green";
	colours_for_elements[$element[sleaze]] = "purple";
	foreach e in $elements[cold,hot,spooky,stench,sleaze]
	{
		string element_html = e;
		if (colours_for_elements contains e)
		{
			element_html = "<font color=\"" + colours_for_elements[e] + "\">" + e + "</font>";
		}
		print_html(element_html + " damage is " + numeric_modifier(e.to_string() + " damage") + " and " + element_html + " spell damage is " + numeric_modifier(e.to_string() + " spell damage"));
	}
}