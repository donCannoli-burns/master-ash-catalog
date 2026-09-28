
import "relay/Guide/Support/Strings.ash";
import "relay/Guide/Support/Math.ash"
import "scripts/RarelyUseful/Capital.ash"

string approximatePriceForOutput(int price)
{
	string out;
	if (price >= 1000000)
	{
		out = roundForOutput(to_float(price) / 1000000.0, 2) + "m";
	}
	else if (price >= 1000)
		out = roundForOutput(to_float(price) / 1000.0, 2) + "k";
	else
		out = price.to_string();
	
	
	if (out.stringHasSuffix(".0"))
		out = out.replace_string(".0", "");
	return out;
}

boolean item_is_pvp_stealable(item it)
{
	if (!it.tradeable)
		return false;
	if (!it.discardable)
		return false;
	if (it.quest)
		return false;
	if (it.gift)
		return false;
	return true;
}

void main()
{

	int [item] prices;
	item [int] items;
	foreach it in $items[]
	{
		if (!it.item_is_pvp_stealable()) continue;
		int price = it.historical_price();
		
		if (price < 0) price = 999999999;
		if (price < 25000) continue;
		price = it.minimumMallPrice(true); //it.historical_price();
		if (price < 0) price = 999999999;
		//if (price < 100000) continue;
		prices[it] = price;
		items[items.count()] = it;
	}
	
	print_html("Expensive PVP items as of " +now_to_string("MMMMM dd yyyy") + ":");
	print_html("");
	sort items by -prices[value];
	foreach key, it in items
	{
		int price = prices[it];
		if (price < 50000) continue;
		print_html(it + ": " + approximatePriceForOutput(price));
	}
	
	print_html("");
	print_html("Mirrorable items:");
	foreach key, it in items
	{
		if (!($slots[hat,weapon,off-hand,back,shirt,pants,acc1,acc2,acc3] contains it.to_slot())) continue;
		int price = prices[it];
		if (price < 25000) continue;
		print_html(it + ": " + approximatePriceForOutput(price));
	}
}