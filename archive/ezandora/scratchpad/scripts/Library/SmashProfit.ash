boolean setting_take_into_account_drill_press = true;
boolean setting_auto_malus = true;

//x^p
float powf(float x, float p)
{
    return x ** p;
}

//Allows for fractional digits, not just whole numbers. Useful for preventing "+233.333333333333333% item"-type output.
//Outputs 3.0, 3.1, 3.14, etc.
float round(float v, int additional_fractional_digits)
{
	if (additional_fractional_digits < 1)
		return v.round().to_float();
	float multiplier = powf(10.0, additional_fractional_digits);
	return to_float(round(v * multiplier)) / multiplier;
}

//Similar to round() addition above, but also converts whole float numbers into integers for output
string roundForOutput(float v, int additional_fractional_digits)
{
	v = round(v, additional_fractional_digits);
	int vi = v.to_int();
	if (vi.to_float() == v)
		return vi.to_string();
	else
		return v.to_string();
}

void main(string item_name)
{
	item it = item_name.to_item();
	float total = 0.0;
	int [item] disintegrations = it.get_related("pulverize");
	
	foreach it2 in disintegrations
	{
		int price = it2.mall_price();
	}
	
	float [item] average_found;
	
	boolean [item] wads_eligible;
	foreach it2 in disintegrations
	{
		if ($items[twinkly wad,hot wad,cold wad,spooky wad,stench wad,sleaze wad] contains it2)
			wads_eligible[it2] = true;
		float found = disintegrations[it2].to_float() / 1000000.0;
		average_found[it2] = found;
	}
	
	if (wads_eligible.count() > 0)
	{
		float distributed_rate = 0.1 / to_float(wads_eligible.count());
		
		foreach wad in wads_eligible
		{
			average_found[wad] += distributed_rate;
		}
	}
	
	if (setting_auto_malus)
	{
		foreach element_type in $strings[twinkly,hot,cold,sleaze,spooky,stench,sewer]
		{
			item powder = to_item(element_type + " powder");
			item nugget = to_item(element_type + " nuggets");
			item wad = to_item(element_type + " wad");
			
			if (powder != $item[none] && nugget != $item[none] && average_found contains powder)
			{
				average_found[nugget] += average_found[powder] / 5.0;
				remove average_found[powder];
			}
			if (nugget != $item[none] && nugget != $item[none] && average_found contains nugget)
			{
				average_found[wad] += average_found[nugget] / 5.0;
				remove average_found[nugget];
			}
		}
	}
	
	
	string line = "Results of smashing " + it + ":";
	if (setting_auto_malus)
		line += " (auto malus)";
	print(line);
	foreach it2 in average_found
	{
		int price = it2.mall_price();
		float found = average_found[it2];
		float expected_value = price.to_float() * found;
		print("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + it2 + ": " + found.roundForOutput(3) + " (" + expected_value.roundForOutput(1) + " meat)");
		total += expected_value;
	}
	print("Total: " + total.roundForOutput(1));
}