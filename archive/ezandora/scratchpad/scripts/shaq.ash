//shaq => ashq
void main(string script)
{
	if (script != "")
		cli_execute("ashq " + script);
	else
		print_html("<img src=\"http://www.zillow.com/blog/files//files/2008/06/shaq.png\">");
}