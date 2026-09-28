string page;
string REST_URL = "campground.php?action=rest";

void dream(string rest)
{
	int a = index_of(rest, '<table  width=95%  cellspacing=0');
	int b = index_of(rest, '<table  width=95%  cellspacing=0 cellpadding=0><tr><td style="color: white;" align=center bgcolor=blue><b>Your Campsite');
	if(a >= 0) {
		if(b < 0) b = length(rest);
		rest = substring(rest, a, b);
		rest = rest.replace_string("<p>You lie back in your gauze hammock and rest.", "");
		rest = rest.replace_string("<p>Your Pagoda sends out groovy vibes, making your rest more restful.", "");
		if(length(rest) > 709) {
			print_html(rest);
			print(" ");
		}
	} else print("Resting failed?", "red");
}

#while ( my_adventures() > 0 && !page.contains_text( "dream of a dog" ) )
while ( my_adventures() > 0 && !page.contains_text( "a single letter glows" ) )
{
	cli_execute( "burn *" );
	if(my_mp() >= my_maxmp())
		cli_execute("cast * ocelot");
	try page = REST_URL.visit_url();
	finally dream(page);
}

print(page);
print_html(page);