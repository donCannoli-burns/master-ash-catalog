
int [item] __minimum_amount_to_keep_around;
//Keep a bunch of effect extenders ready:
__minimum_amount_to_keep_around[$item[thyme jelly donut]] = 30;
__minimum_amount_to_keep_around[$item[Temps Tempranillo]] = 40;
__minimum_amount_to_keep_around[$item[box of Familiar Jacks]] = 10;
__minimum_amount_to_keep_around[$item[crystal skull]] = 5;
__minimum_amount_to_keep_around[$item[borrowed time]] = 4;
foreach it in $items[shining halo,furry halo,frosty halo,time halo]
	__minimum_amount_to_keep_around[it] = 1;


void burnClipartMethod1()
{
	//We don't do this anymore:
	if (!$skill[summon clip art].have_skill())
		return;
	item [9] summonables;
	summonables[0] = $item[borrowed time];
	summonables[1] = $item[bucket of wine];
	summonables[2] = $item[cold-filtered water];
	summonables[3] = $item[crystal skull];
	summonables[4] = $item[potion of the field gar];
	summonables[5] = $item[potion of the litterbox];
	summonables[6] = $item[ultrafondue];
	summonables[7] = $item[unbearable light];
	summonables[8] = $item[potion of punctual companionship];
	//summonables[9] = $item[holy bomb, batman];
	//summonables[10] = $item[the bomb];
	//summonables[10] = $item[Ur-Donut];
	//summonables[11] = $item[shining halo];
	//summonables[12] = $item[time halo];
	//summonables[13] = $item[box of Familiar Jacks]; //not useful
	//summonables[14] = $item[frosty halo];
	
	//Various items that will inevitably be useful in world events.

	item best;
	int best_price = 0;
	foreach i in summonables
	{
		item summonable = summonables[i];
		int price = mall_price(summonable);
		if (price > best_price)
		{
			best_price = price;
			best = summonable;
		}
	}
	boolean should_sell = true;
	item [int] summon_choices;
	foreach it, desired_amount in __minimum_amount_to_keep_around
	{
		if (it.available_amount() < desired_amount)
		{
			summon_choices[summon_choices.count()] = it;
		}
	}
	if (summon_choices.count() > 0)
	{
		//Randomise so we keep a semi-equal distribution of items we want:
		should_sell = false;
		if (summon_choices.count() == 1)
			best = summon_choices[0];
		else
			best = summon_choices[random(summon_choices.count())];
		best_price = best.historical_price();
	}
	if (should_sell)
		print("Best item to summon is the " + best + " for " + best_price);
	else
		print("Summoning " + best + " for inventory.");

	int i = 0;
	while (i <3 && get_property("_clipartSummons").to_int() < 3)
	{
		string text = visit_url("campground.php?preaction=summoncliparts").to_lower_case();
		if (text.contains_text("summoncliparts"))
		{
			cli_execute("create 1 " + best);
			if (should_sell)
				cli_execute("mallsell 1 " + best + " @ " + mall_price(best));
		}
		i = i + 1;
	}
}

void burnClipartMethod2()
{
	if (!$skill[summon clip art].have_skill())
		return;
	if (get_property("_clipartSummons").to_int() >= 3)
		return;
	if (!can_interact())
		return;
		
	
	
	boolean [item] summonables = $items[4:20 bomb,Beignet Milgranet,blammer,blunt cat claw,blunt icepick,bobcat grenade,boozebomb,Bordeaux Marteaux,borrowed time,box of Familiar Jacks,box of hammers,Bright Water,broken clock,broken glass grenade,bucket of wine,cheezburger,chocolate frosted sugar bomb,clock-cleaning hammer,cold-filtered water,cool cat claw,cool cat elixir,cool jelly donut,crystal skull,dethklok,fluorescent lightbulb,forbidden danish,Fromage Pinotage,frosty halo,frozen danish,furry halo,glacial clock,graveyard snowglobe,hammerus,holy bomb\, batman,Lumineux Limnio,Morto Moreto,Muschat,noxious gas grenade,occult jelly donut,oversized snowflake,potion of animal rage,potion of punctual companionship,potion of the captain's hammer,potion of the field gar,potion of the litterbox,potion of X-ray vision,shadowy cat claw,shining halo,shrapnel jelly donut,skull with a fuse in it,smashed danish,Temps Tempranillo,The Bomb,thyme jelly donut,time halo,toasted brie,too legit potion,ultrafondue,unbearable light,Ur-Donut]; //'
	
	boolean [item] keep_summon;
	
	int [item] summon_value;
	
	item [int] summons_ordered;
	
	foreach it in summonables
	{
		//it.mall_price();
		int value = it.historical_price();
		
		if (__minimum_amount_to_keep_around contains it && it.available_amount() < __minimum_amount_to_keep_around[it])
		{
			keep_summon[it] = true;
			value = 1073741824;
		}
		
		summon_value[it] = value;
		summons_ordered[summons_ordered.count()] = it;
	}
	sort summons_ordered by -summon_value[value];
	
	foreach key, it in summons_ordered
	{
		if (get_property("_clipartSummons").to_int() >= 3)
		{
			break;
		}
		print("BurnClipart.ash: summon " + it + ": " + summon_value[it]);
		cli_execute("create 1 " + it);
		if (!keep_summon[it] && it.item_amount() > 0)
		{
			put_shop(it.shop_price(), 0, 1, it);
		}
	}
}

void main()
{
	burnClipartMethod2();
}