
void main()
{	int available_drunkness = inebriety_limit() - my_inebriety();	if (available_drunkness == 19)
	{
		if (available_amount($item[wrecked generator]) <3 )
		{
			print("You need more wrecked generators", "red");
			return;
		}
		cli_execute("call scripts/Library/CastOde.ash 20");
		cli_execute("maximize cold res -tie");
		cli_execute("cast elemental saucesphere");
		cli_execute("use csa bravery badge");
		cli_execute("use pygmy pygment");
		cli_execute("use philter of phorce");
		cli_execute("restore hp");
		cli_execute("buy 3 frosty's frosty mug");
		cli_execute("buy 300 lunar isotope");
		cli_execute("drink frosty's frosty mug; drink wrecked generator");
		cli_execute("restore hp");
		cli_execute("drink frosty's frosty mug; drink wrecked generator");
		cli_execute("restore hp");
		cli_execute("drink frosty's frosty mug; drink wrecked generator");
		cli_execute("drink 1 pumpkin beer");
		cli_execute("uneffect ode");
		cli_execute("call Outfit experience");
	}
	cli_execute("call Day 2 Prepare.ash");
}