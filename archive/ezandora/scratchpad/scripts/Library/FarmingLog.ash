

Record FarmingLogState
{
	int [item] inventory;
	int meat;
};

FarmingLogState __farming_log_universal_state;


//FarmingLogStart()
//FarmingLogOutputDelta()

FarmingLogState FarmingLogStart(boolean replace_universal)
{
	FarmingLogState state;
	state.inventory = get_inventory();
	foreach it in $items[]
	{
		int amount = it.equipped_amount();
		if (amount > 0)
			state.inventory[it] += amount;
	}
	state.meat = my_meat();
	if (replace_universal)
		__farming_log_universal_state = state;
	return state;
}

FarmingLogState FarmingLogStart()
{
	return FarmingLogStart(true);
}

FarmingLogState FarmingLogComputeDelta(FarmingLogState old_state)
{
	FarmingLogState current_state = FarmingLogStart(false);
	FarmingLogState delta_state;
	
	foreach it in $items[]
	{
		int old_amount = old_state.inventory[it];
		int current_amount = current_state.inventory[it];
		if (current_amount == old_amount) continue;
		delta_state.inventory[it] = current_amount - old_amount;
	}
	delta_state.meat = current_state.meat - old_state.meat;
	return delta_state;
}

FarmingLogState FarmingLogComputeDelta()
{
	return FarmingLogComputeDelta(__farming_log_universal_state);
}

void FarmingLogOutputDelta(FarmingLogState delta_state, boolean show_negatives)
{
	if (delta_state.inventory.count() == 0 && delta_state.meat == 0) return;
	print("");
	print("Farming results:");
	if (delta_state.inventory.count() > 0)
	{
		int item_worth_total = 0;
		
		item [int] output_order;
		
		//Show the most expensive items last:
		foreach it in delta_state.inventory
		{
			output_order[output_order.count()] = it;
		}
		sort output_order by (value.historical_price() * delta_state.inventory[value]);
		
		foreach key, it in output_order
		{
			int amount = delta_state.inventory[it];
			if (!show_negatives && amount <= 0) continue;
			string line = (amount > 0 ? "+" : "") + amount + " " + it;
			
			if (it.tradeable)
			{
				line += " (" + (it.historical_price() * amount) + " meat)";
				item_worth_total += it.historical_price() * amount;
			}
			//line += " (" + it.id + ")";
			print(line);
		}
		if (item_worth_total > 0)
		{
			print("+" + item_worth_total + " meat item value.");
		}
	}
	if (delta_state.meat != 0)
	{
		print((delta_state.meat > 0 ? "+" : "") + delta_state.meat + " meat.");
	}
	print("");
}

void FarmingLogOutputDelta(boolean show_negatives)
{
	FarmingLogOutputDelta(FarmingLogComputeDelta(), show_negatives);
}

void FarmingLogOutputDelta()
{
	FarmingLogOutputDelta(false);
}