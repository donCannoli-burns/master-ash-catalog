void main()
{
	int [item] item_quarter_amount;
	
    item_quarter_amount[$item[hippy protest button]] = 1;
    item_quarter_amount[$item[Lockenstock&trade; sandals]] = 2;
    item_quarter_amount[$item[didgeridooka]] = 2;
    item_quarter_amount[$item[bullet-proof corduroys]] = 1;
    item_quarter_amount[$item[round purple sunglasses]] = 1;
    item_quarter_amount[$item[wicker shield]] = 2;
    item_quarter_amount[$item[oversized pipe]] = 1;
    item_quarter_amount[$item[reinforced beaded headband]] = 1;
    item_quarter_amount[$item[fire poi]] = 3;
    item_quarter_amount[$item[communications windchimes]] = 2;
	item_quarter_amount[$item[Gaia beads]] = 2;
    item_quarter_amount[$item[pink clay bead]] = 1;
    item_quarter_amount[$item[purple clay bead]] = 3;
    item_quarter_amount[$item[green clay bead]] = 5;
    item_quarter_amount[$item[hippy medical kit]] = 3;
    item_quarter_amount[$item[flowing hippy skirt]] = 2;
    item_quarter_amount[$item[round green sunglasses]] = 3;
    
    
    item [int] sorting;
    float [item] sorting_value;
    foreach it, quarter in item_quarter_amount
    {
    	int price = it.mall_price();
    	if (!it.tradeable)
    		price = -1;
    	float meat_per_quarter = to_float(price) / to_float(quarter);
    	sorting[sorting.count()] = it;
    	sorting_value[it] = meat_per_quarter;
    	cli_execute("pull * " + it);
    }
    sort sorting by sorting_value[value];
    foreach key, it in sorting
    {
    	float meat_per_quarter = sorting_value[it];
    	int true_price = meat_per_quarter * 4;
    	int total_quarters_possible = it.available_amount() * item_quarter_amount[it];
    	int boomboxes_possible = total_quarters_possible / 4;
    	print_html(it + ": " + meat_per_quarter + ", " + it.available_amount() + " (converts into " + boomboxes_possible + " boomboxes, price equivalent " + true_price + ")");
    }
}