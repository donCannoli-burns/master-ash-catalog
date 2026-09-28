import "scripts/Library/ArchiveEquipment.ash";
import "scripts/Helix Fossil/Helix Fossil Interface.ash"


item __target_item;
location __target_location;
void checkQuestLog()
{
	buffer page_text = visit_url("questlog.php?which=7");
	
	string desired_item_name = page_text.group_string("<p><b>Doctor, Doctor</b><br> Take a (.*?) to the patient")[0][1];
	if (desired_item_name == "")
		desired_item_name = page_text.group_string("<p><b>Doctor, Doctor</b><br> Take an (.*?) to the patient")[0][1];
	if (desired_item_name == "")
	{
		desired_item_name = page_text.group_string("<p><b>Doctor, Doctor</b><br> Acquire an (.*?)\\.")[0][1];
		if (desired_item_name != "") cli_execute("refresh inventory");
	}
	if (desired_item_name == "")
	{
		desired_item_name = page_text.group_string("<p><b>Doctor, Doctor</b><br> Acquire a (.*?)\\.")[0][1];
		if (desired_item_name != "") cli_execute("refresh inventory");
	}
	__target_item = desired_item_name.to_item();
	if (__target_item != $item[none] && __target_item.item_amount() == 0)
	{
		retrieve_item(1, __target_item);
		page_text = visit_url("questlog.php?which=7");
	}
	
	//<p><b>Doctor, Doctor</b><br> Take a cast to the patient in <a href=place.php?whichplace=giantcastle class=nounder target=mainpane><b>The Castle in the Clouds in the Sky (Ground Floor)</b></a>
	string [int][int] matches = page_text.group_string("<p><b>Doctor, Doctor</b><br> Take .*? to the patient in <a href=.*? class=nounder target=mainpane><b>(.*?)</b></a>");
	string place = matches[0][1];
	
	

	__target_location = place.to_location();
	if (__target_location != $location[none] && __target_item == $item[none]) abort("could not parse item " + __target_item);
}

void main()
{
	if (my_inebriety() > inebriety_limit()) return; //not right now
	ArchivedEquipment ae = ArchiveEquipment();
	checkQuestLog();
	if (__target_location == $location[none]) return;
	
	slot next_accessory_slot = $slot[acc1];
	foreach it in $items[Kramco Sausage-o-Matic&trade;,Lil' Doctor&trade; bag,navel ring of navel gazing,mafia thumb ring] //'
	{
		if (it.equipped_amount() > 0) continue;
		if (it.available_amount() == 0) continue;
		if (it.to_slot() == $slot[acc1])
		{
			equip(next_accessory_slot, it);
			if (next_accessory_slot == $slot[acc1])
				next_accessory_slot = $slot[acc2];
			else
				next_accessory_slot = $slot[acc3];
		}
		else
			equip(it);
	}
	HelixResetSettings();
	foreach key, m in __target_location.get_monsters()
	{
		__helix_settings.monsters_to_run_away_from[m] = true;
	}
	HelixWriteSettings();
	while (my_adventures() > 0)
	{
		checkQuestLog();
		if (__target_item != $item[none])
			retrieve_item(1, __target_item);
		if (__target_location == $location[none]) break;
		adv1(__target_location, 0, "");
	}
	HelixResetSettings();
	HelixWriteSettings();
	RestoreArchivedEquipment(ae);
}