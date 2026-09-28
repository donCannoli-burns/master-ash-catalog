
void trade_in_spares(item i, int limit)
{
	int count = available_amount(i);
	int amount_to_trade_in = count - limit;
	if (amount_to_trade_in < 1)
		return;
	sell($coinmaster[game shoppe], amount_to_trade_in, i);
}


void main()
{
	//return; //no reason to now
	int limit = 11;
	trade_in_spares($item[alice's army alchemist], limit);
	trade_in_spares($item[alice's army bowman], limit);
	trade_in_spares($item[alice's army cleric], limit);
	trade_in_spares($item[alice's army coward], limit);
	trade_in_spares($item[alice's army dervish], limit);
	trade_in_spares($item[alice's army guard], limit);
	trade_in_spares($item[alice's army halberder], limit);
	trade_in_spares($item[alice's army hammerman], limit);
	trade_in_spares($item[alice's army horseman], limit);
	trade_in_spares($item[alice's army lanceman], limit);
	trade_in_spares($item[alice's army mad bomber], limit);
	trade_in_spares($item[alice's army martyr], limit);
	trade_in_spares($item[alice's army ninja], limit);
	trade_in_spares($item[alice's army nurse], limit);
	trade_in_spares($item[alice's army page], limit);
	trade_in_spares($item[alice's army shieldmaiden], limit);
	trade_in_spares($item[alice's army sniper], limit);
	trade_in_spares($item[alice's army spearsman], limit);
	trade_in_spares($item[alice's army swordsman], limit);
	trade_in_spares($item[alice's army wallman], limit);
}