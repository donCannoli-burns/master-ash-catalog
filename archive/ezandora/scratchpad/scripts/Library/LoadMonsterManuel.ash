void main()
{
	if (get_property("_ezandoraDidLoadManuel").to_boolean()) return;
	print_html("Loading manuel...");
	foreach s in $strings[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,-]
		visit_url("questlog.php?which=6&vl=" + s + "&filter=0");
	set_property("_ezandoraDidLoadManuel", true);
}