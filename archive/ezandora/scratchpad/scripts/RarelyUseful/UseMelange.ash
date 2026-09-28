void main()
{
	if (my_fullness() < 3 || my_inebriety() < 3) return;
	if (get_property("spiceMelangeUsed").to_boolean()) return;
	if (!can_interact()) return;
	int melange_price = $item[spice melange].mall_price();
	if (melange_price >= 500000)
	{
		return;
	}
	if ($item[spice melange].available_amount() == 0)
	{
		cli_execute("buy 1 spice melange @ " + MIN(500000, melange_price + 10000));
	}
	cli_execute("use spice melange");
	cli_execute("consume default");
}