void main()
{
	set_property("hpAutoRecovery", 0.8);
	set_property("hpAutoRecoveryTarget", 1.0);
	set_property("mpAutoRecovery", 0.15);
	set_property("mpAutoRecoveryTarget", 0.2);
	if (my_meat() < 1000000)
	{
		int storage_meat = my_storage_meat();
		storage_meat = MAX(storage_meat, 2000000); //hakc
		int taking = MIN(2000000, storage_meat);
		if (taking > 0)
			visit_url("storage.php?amt=" + taking + "&action=takemeat");
	}
	
	foreach it in $items[donated candy,donated booze,donated food, government food shipment,government booze shipment,government candy shipment]
	{
		cli_execute("pull * " + it);
	}
	//cli_execute("acquire 11 spray paint");
	cli_execute("call scripts/Utility/Delete Lady Spookyraven Kmails.ash");
	if (hippy_stone_broken()) //might as well do it now. could save time not equipping things, but...
		cli_execute("call scripts/PVP/Prepare to PVP.ash");
	cli_execute("refresh all"); //why is astral pet sweater and scripting so dumb
	cli_execute("gc");
}