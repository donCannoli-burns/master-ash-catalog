

void main()
{
	item [20] cards;
	cards[0] = $item[Alice's Army Alchemist];	cards[1] = $item[Alice's Army Bowman];	cards[2] = $item[Alice's Army Cleric];	cards[3] = $item[Alice's Army Coward];	cards[4] = $item[Alice's Army Dervish];	cards[5] = $item[Alice's Army Guard];	cards[6] = $item[Alice's Army Halberder];	cards[7] = $item[Alice's Army Hammerman];	cards[8] = $item[Alice's Army Horseman];	cards[9] = $item[Alice's Army Lanceman];	cards[10] = $item[Alice's Army Mad Bomber];	cards[11] = $item[Alice's Army Martyr];	cards[12] = $item[Alice's Army Ninja];	cards[13] = $item[Alice's Army Nurse];	cards[14] = $item[Alice's Army Page];	cards[15] = $item[Alice's Army Shieldmaiden];	cards[16] = $item[Alice's Army Sniper];	cards[17] = $item[Alice's Army Spearsman];	cards[18] = $item[Alice's Army Swordsman];	cards[19] = $item[Alice's Army Wallman];

	int value = 0;
	foreach i in cards
	{
		item card = cards[i];
		int price = mall_price(card) * available_amount(card);
		value += price;
	}
	print("Collection value is " + value + " meat.");
}