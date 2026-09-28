void outputForCoinmaster(coinmaster c)
{
	item token = c.item;
	foreach it in $items[]
	{
		if (!c.sells_item(it))
			continue;
		if (!it.tradeable)
			continue;
		int token_price = c.sell_price(it);
		int mall_price = it.mall_price();
		
		float meat_per_token = mall_price.to_float() / token_price.to_float();
		print_html(it + ": " + meat_per_token.round() + " meat/" + token);
	}
}

void main()
{
	outputForCoinmaster($coinmaster[wal-mart]);
}