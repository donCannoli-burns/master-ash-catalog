Record ArchivedEquipment
{
	item [slot] previous_equipment;
	familiar previous_familiar;
	familiar previous_enthroned_familiar;
	familiar previous_bjorned_familiar;
};

ArchivedEquipment __global_archived_equipment;

ArchivedEquipment ArchiveEquipment()
{
	ArchivedEquipment ae;
	
	foreach s in $slots[hat,weapon,off-hand,back,shirt,pants,acc1,acc2,acc3,familiar]
		ae.previous_equipment[s] = s.equipped_item();
	ae.previous_familiar = my_familiar();
	ae.previous_enthroned_familiar = my_enthroned_familiar();
	ae.previous_bjorned_familiar = my_bjorned_familiar();
	
	__global_archived_equipment = ae;
	return ae;
}


void RestoreArchivedEquipment(ArchivedEquipment ae)
{
	use_familiar(ae.previous_familiar);
	
	boolean skip_offhand_if_weapon = false;
	if (ae.previous_equipment contains $slot[weapon])
	{
		slot s = $slot[weapon];
		item it = ae.previous_equipment[s];
		if (s.equipped_item() != it)
		{
			if (it.available_amount() > 0)
				equip(s, it);
			else if (it == $item[none])
				equip(s, it);
		}
		if (s.equipped_item() != it)
		{
			skip_offhand_if_weapon = true;
		}
	}
	foreach s, it in ae.previous_equipment
	{
		if (s == $slot[weapon]) continue;
		if (skip_offhand_if_weapon && s == $slot[off-hand] && it.to_slot() == $slot[weapon]) continue; //something went wrong, skip
		if (s.equipped_item() != it)
		{
			if (it.available_amount() > 0)
				equip(s, it);
			else if (it == $item[none])
				equip(s, it);
		}
	}
	if ($item[crown of thrones].equipped_amount() > 0 && ae.previous_enthroned_familiar != $familiar[none])
		enthrone_familiar(ae.previous_enthroned_familiar);
	if ($item[buddy bjorn].equipped_amount() > 0 && ae.previous_bjorned_familiar != $familiar[none])
		bjornify_familiar(ae.previous_bjorned_familiar);
}

void RestoreArchivedEquipment()
{
	RestoreArchivedEquipment(__global_archived_equipment);
}