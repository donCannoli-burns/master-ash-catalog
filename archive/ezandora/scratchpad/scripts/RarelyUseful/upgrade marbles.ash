

void main()
{		item [11] marbles;	marbles[0] = $item[green peawee marble];	marbles[1] = $item[brown crock marble];	marbles[2] = $item[red China marble];	marbles[3] = $item[lemonade marble];	marbles[4] = $item[bumblebee marble];	marbles[5] = $item[jet bennie marble];	marbles[6] = $item[beige clambroth marble];	marbles[7] = $item[steely marble];	marbles[8] = $item[beach ball marble];	marbles[9] = $item[black catseye marble];	marbles[10] = $item[big bumboozer marble];			//for (i = 0; i < 10; i = i + 1)
	for i from 0 to 9	{		item marble = marbles[i];		item next_marble = marbles[i + 1];				int amount = item_amount(marble);		if (amount < 3)
			continue;		amount = amount - 1;		int creatable = amount / 2;		if (creatable < 1)
			continue;		cli_execute("make " + creatable + " " + next_marble);	}
}