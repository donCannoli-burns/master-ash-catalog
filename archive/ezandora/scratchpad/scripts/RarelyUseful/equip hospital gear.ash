boolean want_to_banish_orderlies_with_pantsgiving = true;

void main()
{
	foreach it in $items[surgical apron,bloodied surgical dungarees,surgical mask,head mirror,half-size scalpel]
	{
		if (want_to_banish_orderlies_with_pantsgiving && !$monster[pygmy orderlies].is_banished() && $item[pantsgiving].equipped_amount() > 0 && it == $item[bloodied surgical dungarees]) //not until then
			continue;
		if (it.available_amount() == 0)
			continue;
		if (!it.can_equip())
			continue;
		if (it.equipped_amount() == 0)
			equip(it);
	}
}