void adv1(location place)
{
	adv1(place, -1, "");
}

void main()
{
	item machete = $item[none];
	foreach it in $items[antique machete,Machetito,Muculent machete,Papier-m&acirc;ch&eacute;te]
	{
		if (it.available_amount() > 0 && it.can_equip())
			machete = it;
	}
	if (machete == $item[none])
	{
		print("No equippable machete available.");
		return;
	}
	item old_weapon = $slot[weapon].equipped_item();
	item old_offhand = $slot[off-hand].equipped_item();
	equip(machete);
	if ($item[thor's pliers].available_amount() > 0 && $skill[double-fisted skull smashing].have_skill())
		equip($slot[off-hand], $item[thor's pliers]);
	
	string [string] desired_values;
	desired_values["choiceAdventure781"] = 1;
	desired_values["choiceAdventure783"] = 1;
	desired_values["choiceAdventure785"] = 1;
	desired_values["choiceAdventure787"] = 1;
	desired_values["choiceAdventure791"] = 6; //ziggurat
	
	string [string] old_property_values;
	foreach property in desired_values
	{
		old_property_values[property] = get_property(property);
		set_property(property, desired_values[property]);
	}
	
	foreach l in $locations[a massive ziggurat,An Overgrown Shrine (Northeast),An Overgrown Shrine (Southeast),An Overgrown Shrine (Northwest),An Overgrown Shrine (Southwest)]
	{
		for i from 1 to 4
		{
			adv1(l);
		}
	}
	
	if (old_weapon.can_equip())
		equip(old_weapon);
	if (old_offhand.can_equip())
		equip($slot[off-hand], old_offhand);
	foreach property in old_property_values
	{
		set_property(property, old_property_values[property]);
	}
}