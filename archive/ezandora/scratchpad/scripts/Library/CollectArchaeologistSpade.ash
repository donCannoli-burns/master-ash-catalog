void main()
{
	if ($item[Archaeologist's Spade].item_amount() == 0 && $item[Archaeologist's Spade].available_amount() > 0)
		retrieve_item($item[Archaeologist's Spade]);
	if ($item[Archaeologist's Spade].item_amount() == 0) return; //'
	if (get_property("_archSpadeDigs").to_int() >= 11) return;
	
	int breakout = 11;
	visit_url("inv_use.php?whichitem=12184");
	while (breakout > 0 && get_property("_archSpadeDigs").to_int() < 11)
	{
		breakout -= 1;
		visit_url("choice.php?whichchoice=1596&option=2");
	}
	visit_url("choice.php?whichchoice=1596&option=4");
}