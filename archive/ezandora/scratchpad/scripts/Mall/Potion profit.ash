import "scripts/RarelyUseful/Capital.ash"
import "scripts/Destiny Ascension/Destiny Ascension/Support/Library.ash";

void main()
{
	refresh_shop();
	item [int] potions;
	float [item] potions_creation_prices;
	int [item] potions_mall_prices;
	float [item] potions_price_delta;
	int assumed_reagent_price = 1898;
	foreach potion in $items[]
	{
		if (!potion.tradeable) continue;
		if (!potion.craft_type().contains_text("Saucecrafting")) continue;
		if (potion.shop_amount() > 0) continue;
		
		int [item] ingredients = potion.get_ingredients();
		
		boolean unmakeable = false;
		foreach it, amount in ingredients
		{
			if (!it.tradeable)
			{
				unmakeable = true;
				break;
			}
		}
		if (unmakeable)
		{
			print_html("Skipping " + potion + " because it's unmakeable");
			continue;
		}
		int mall_price = potion.minimumMallPrice(false, true);
		if (mall_price * 3.0 < 100 + MAX(assumed_reagent_price, $item[scrumptious reagent].minimumMallPrice(false, true)) && ingredients[$item[scrumptious reagent]] > 0)
			continue;
		
		float price_to_create = 0.0;
		foreach it, amount in ingredients
		{
			int price = 0;
			if (it.is_npc_item())
				price = it.npc_price();
			else
				price = MAX(it.minimumMallPrice(false, true), it.cost_to_acquire());
			if (it == $item[scrumptious reagent])
				price = MAX(price, assumed_reagent_price); //FIXME hardcoded
			price_to_create += price * amount;
		}
		price_to_create = price_to_create / 3.0 + $item[chef-in-the-box].cost_to_acquire().to_float() / 90.0;
		if (mall_price > price_to_create + 400.0)
		{
			potions[potions.count()] = potion;
			potions_creation_prices[potion] = price_to_create;
			potions_mall_prices[potion] = mall_price;
			potions_price_delta[potion] = mall_price - price_to_create;
		}
	}
	sort potions by -potions_price_delta[value];
	string [item] potion_descriptions;
	foreach key, potion in potions
	{
		potion_descriptions[potion] = potions_price_delta[potion].to_int() + " (" + potions_mall_prices[potion] + " could be " + potions_creation_prices[potion].to_int() + ", " + potion.get_ingredients().to_json() + ")";
		print(potion + ": " + potion_descriptions[potion]);
	}
	foreach key, potion in potions
	{
		if (potions_price_delta[potion] < 1000.0)
			continue;
		
		float selling_price = MIN(potions_creation_prices[potion] * 2.0, potions_creation_prices[potion] + 1000.0);
		if (selling_price >= potions_mall_prices[potion])
			continue;
		boolean yes = user_confirm("Make and sell " + potion + "?\r\r" + potion_descriptions[potion]);
		if (!yes) break;
		
		int price_limit = 500000;
		
		int amount_to_make = 50;
		amount_to_make = MIN(500, MAX(50, price_limit.to_float() / potions_creation_prices[potion]));
		int starting_meat = my_meat();
		cli_execute("make " + amount_to_make + " " + potion);
		int ending_meat = my_meat();
		float delta = (ending_meat - starting_meat) / to_float(amount_to_make);
		print("delta = " + delta);
		selling_price = MAX(selling_price, delta * 2.0);
		cli_execute("mallsell * " + potion + " @ " + selling_price);
	}
}