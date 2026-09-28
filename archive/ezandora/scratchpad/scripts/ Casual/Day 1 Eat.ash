void main()
{
	if (to_boolean(get_property("__user_casual_ascension_use_tatters")))
	{
		print("http://www.houeland.com/kol/diets?customvalue=4600&custompvpvalue=0&nightcap=no&itemsavailable=tuxedo&semirares=0&ismonday=no&foodspace=16&boozespace=15&spleenspace=15");
	}
	else
	{
		int available_spleen = spleen_limit() - my_spleen_use();
		if (available_spleen == 15)
		{
			//spleen:
			cli_execute("chew agua de vida; chew agua de vida; use mojo filter;");
		}
		available_spleen = spleen_limit() - my_spleen_use();
		if (available_spleen >= 8 && my_level() >= 11)
		{
			cli_execute("chew astral energy drink");
		}
		cli_execute("call scripts/Library/eat stuff.ash");		#consume drunk:		int available_drunkness = inebriety_limit() - my_inebriety();			if (available_drunkness == 14 && my_level() >= 6)		{				cli_execute("call scripts/Library/CastOde.ash 20");			if (false) //slightly more expensive, but more adventures~			{					cli_execute("maximize cold res -tie");				cli_execute("cast elemental saucesphere");				cli_execute("use csa bravery badge");				cli_execute("use pygmy pygment");				cli_execute("use fish-liver oil");				cli_execute("use philter of phorce");				cli_execute("restore hp");				cli_execute("buy 300 lunar isotope");				cli_execute("buy 3 frosty's frosty mug");				cli_execute("drink frosty's frosty mug; drink wrecked generator");				cli_execute("restore hp");				cli_execute("drink frosty's frosty mug; drink wrecked generator");				cli_execute("restore hp");				cli_execute("use synthetic dog hair");				cli_execute("drink frosty's frosty mug; drink wrecked generator");			}			else			{				//Slightly cheaper. We don't need the frosty adventures. (29 of them, I think)				cli_execute("buy 300 lunar isotope");				cli_execute("drink 2 wrecked generator");				cli_execute("use synthetic dog hair");				cli_execute("drink wrecked generator");			}			cli_execute("uneffect ode");		}
	}
}