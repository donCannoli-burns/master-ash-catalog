
void main()
{
	foreach letter in $strings[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,-]
	{
		string [int][int] monster_name_matches = visit_url("questlog.php?which=6&vl=" + letter + "&filter=0").group_string("<td rowspan=4 valign=top class=small><b><font size=\\+2>(.*?)</font></b>");
		foreach key in monster_name_matches
		{
			string monster_name_canonical = monster_name_matches[key][1];
			monster m = monster_name_canonical.to_monster();
			if (m == $monster[none])
			{
				print_html("Unknown monster \"" + monster_name_canonical + "\"");
				continue;
			}
			string monster_name_mafia = m.to_string();
			if (monster_name_canonical != monster_name_mafia)
			{
				print_html("Mafia believes monster is \"" + monster_name_mafia.entity_encode() + "\", but it is \"" + monster_name_canonical.entity_encode() + "\"");
			}
			//print_html(monster_name_canonical);
		}
	}
}