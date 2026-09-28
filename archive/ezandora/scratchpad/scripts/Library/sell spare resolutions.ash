void main()
{
	int [item] resolutions;
	resolutions[$item[resolution: be feistier]] = 100;
	resolutions[$item[resolution: be luckier]] = 500;
	resolutions[$item[resolution: be sexier]] = 100;
	resolutions[$item[resolution: be smarter]] = 100;
	resolutions[$item[resolution: be stronger]] = 100;
	
	//Limits set ref: melange farming
	resolutions[$item[resolution: be happier]] = 1300; //+15% item
	resolutions[$item[resolution: be kinder]] = 1800; //+5 familiar weight
	resolutions[$item[resolution: be more adventurous]] = 5000; //2.5k MPA
	resolutions[$item[resolution: be wealthier]] = 1500; //+30% meat. worth 1500 meat to me
	
	int total = 0;
	foreach i in resolutions
	{
		//if (price == 100)
		//	continue;
		int min_price = resolutions[i];
		int selling_amount = max(0, available_amount(i));
		if (selling_amount == 0)
			continue;
		int price = mall_price(i);
		if (price < min_price) //hold onto them for now
			continue;
		total = total + price * selling_amount;
		//print(i + " @ " + (price * selling_amount));
		cli_execute("mallsell " + selling_amount + " " + i + " @ " + price);
	}
	print(total + " meat sold.");
}