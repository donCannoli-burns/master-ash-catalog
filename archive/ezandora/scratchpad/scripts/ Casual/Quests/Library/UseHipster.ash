
void main()
{
	//return; //mafia is too buggy to use this
	if (get_property("_hipsterAdv") == 7)
	{
		if (my_familiar() != $familiar[fancypants scarecrow])
			cli_execute("uneqip familiar; familiar scarecrow");
		cli_execute("equip familiar pin-stripe slacks");
	}
	else
		cli_execute("familiar artistic goth kid");

}