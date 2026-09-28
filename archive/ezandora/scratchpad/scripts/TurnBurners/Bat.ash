void main()
{
	item minimum_item;
	foreach it in $items[The Plumber's mushroom stew,The Mad Liquor,Doc Clock's thyme cocktail,Mr. Burnsger]
	{
		if (minimum_item == $item[none] || minimum_item.available_amount() > it.available_amount())
			minimum_item = it;
	}
	if ($item[The Inquisitor's unidentifiable object].available_amount() == 0) //'
		minimum_item = $item[The Inquisitor's unidentifiable object]; //'
	print("Farming for " + minimum_item);
	set_property("_batfellow_desired_item", minimum_item);
	
	if ($item[special edition Batfellow comic].available_amount() > 0)
	{
		set_property("choiceAdventure1133", 1);
		use(1, $item[special edition Batfellow comic]);
		cli_execute("call scripts/Destiny Ascension/Destiny Ascension.ash");
	}
}