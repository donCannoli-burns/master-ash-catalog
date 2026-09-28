
void main(int target_trinket_count)
{
	cli_execute("acquire 1 hermit permit");

	if (target_trinket_count < 0)
	{
		int current_count = item_amount($item[worthless trinket]) + item_amount($item[worthless gewgaw]) + item_amount($item[worthless knick-knack]);
		target_trinket_count = -target_trinket_count - current_count;
	}
	if (target_trinket_count < 0)
		return;
	if (target_trinket_count > 1000)
		return;

	int trinkets_gotten = 0;
	int safety = target_trinket_count * 20 + 200;
	if (safety > 10000)
		safety = 10000;
	while (trinkets_gotten < target_trinket_count && safety > 0)
	{
		cli_execute("closet put * worthless trinket; closet put * worthless gewgaw; closet put * worthless knick-knack");
		cli_execute("use chewing gum on a string");
		
		safety = safety - 1;
		trinkets_gotten = trinkets_gotten + item_amount($item[worthless trinket]) + item_amount($item[worthless gewgaw]) + item_amount($item[worthless knick-knack]);
	}
	cli_execute("closet take * worthless trinket; closet take * worthless gewgaw; closet take * worthless knick-knack");
}