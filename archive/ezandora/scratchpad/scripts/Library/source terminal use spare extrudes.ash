int totalAvailable(item it)
{
	return it.item_amount() + it.storage_amount() + it.closet_amount() + it.shop_amount() + it.display_amount();
}
void main()
{
	int limit = 0;
	while (get_property("_sourceTerminalExtrudes").to_int() < 3 && limit < 3)
	{
		if ($item[hacked gibson].totalAvailable() < $item[browser cookie].totalAvailable())
			cli_execute("terminal extrude booze.ext");
		else
			cli_execute("terminal extrude food.ext");
		limit += 1;
	}
}