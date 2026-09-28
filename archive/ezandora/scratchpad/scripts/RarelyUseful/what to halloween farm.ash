//This script is in the public domain.
//Also, it's missing a bunch of outfits.

void listAppend(item [int] list, item entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

item [int] missing_outfit_components(string outfit_name)
{
    item [int] outfit_pieces = outfit_pieces(outfit_name);
    item [int] missing_components;
    foreach key in outfit_pieces
    {
        item it = outfit_pieces[key];
        if (it.available_amount() == 0)
            missing_components.listAppend(it);
    }
    return missing_components;
}

//have_outfit() will tell you if you have an outfit, but only if you pass stat checks. This does not stat check:
boolean have_outfit_components(string outfit_name)
{
    return (outfit_name.missing_outfit_components().count() == 0);
}

record item_drop
{
	item i;
	int price;
	string outfit;
};

item_drop item_drop_make(item i, int price, string outfit)
{
	item_drop result;
	result.i = i;
	result.price = price;
	result.outfit = outfit;
	return result;
}
void main()
{		
	string [string] outfits_and_their_items;
	
	
	outfits_and_their_items["8-Bit Finery"] = "pixellated candy heart";
	outfits_and_their_items["Animelf Apparel"] = "blind-packed capsule toy";
	outfits_and_their_items["Antique Arms And Armor"] = "Bit O' Ectoplasm";
	outfits_and_their_items["Arboreal Raiment"] = "sugar-coated pine cone";
	outfits_and_their_items["Arrrbor Day Apparrrrrel"] = "Everlasting Deckswabber";
	outfits_and_their_items["Bits o' Honey"] = "honey stick";
	outfits_and_their_items["Blasphemous Bedizenment"] = "Pain Dip";
	outfits_and_their_items["Bounty-Hunting Rig"] = "chocolate filthy lucre";
	outfits_and_their_items["Bow Tux"] = "candy cane";
	outfits_and_their_items["BRICKOfig Outfit"] = "BRICKO brick";
	outfits_and_their_items["Bugbear Costume"] = "cog, sprocket, and spring";
	outfits_and_their_items["Cloaca-Cola Uniform"] = "Dyspepsi grenade";
	outfits_and_their_items["Clockwork Apparatus"] = "Sugar Cog";
	outfits_and_their_items["Clothing of Loathing"] = "fudge-shaped hole in space-time";
	outfits_and_their_items["Cool Irons"] = "ironic mint";
	outfits_and_their_items["Crappy Mer-kin Disguise"] = "Mer-kin rocksalt";
	outfits_and_their_items["Crimbo Duds"] = "fruitcake";
	outfits_and_their_items["Crimborg Assault Armor"] = "nanite-infested candy cane";
	outfits_and_their_items["Cursed Zombie Pirate Costume"] = "piece of after eight";
	outfits_and_their_items["Dark Bro's Vestments"] = "Necbro wafers";
	outfits_and_their_items["Dead Sexy (effect)"] = "Gummy Brains";
	outfits_and_their_items["Dire Drifter Duds"] = "strawberry-flavored Hob-O";
	outfits_and_their_items["Dreadful Bugbear Suit"] = "Bugbearclaw Donut";
	outfits_and_their_items["Dreadful Ghost Suit"] = "8-bit banana";
	outfits_and_their_items["Dreadful Pajamas"] = "Tallowcreme Halloween Pumpkin";
	outfits_and_their_items["Dreadful Skeleton Suit"] = "bone bons";
	outfits_and_their_items["Dreadful Vampire Suit"] = "vial of blood simple syrup";
	outfits_and_their_items["Dreadful Werewolf Suit"] = "little red jam";
	outfits_and_their_items["Dreadful Zombie Suit"] = "Whenchamacallit bar";
	outfits_and_their_items["Dwarvish War Uniform"] = "dwarf bread";
	outfits_and_their_items["Dyspepsi-Cola Uniform"] = "Cloaca grenade";
	outfits_and_their_items["El Vibrato Relics"] = "abandoned candy";
	outfits_and_their_items["Encephalic Ensemble"] = "candy brain";
	outfits_and_their_items["eXtreme Cold-Weather Gear"] = "Wint-O-Fresh mints";
	outfits_and_their_items["Fancy Tux"] = "chocolate-covered caviar";
	outfits_and_their_items["Filthy Hippy Disguise"] = "herb brownies";
	outfits_and_their_items["Floaty Fatigues"] = "packets of Rock Pops";
	outfits_and_their_items["Frat Boy Ensemble"] = "bottle of booze";
	outfits_and_their_items["Frat Warrior Fatigues"] = "shots of schnapps";
	outfits_and_their_items["Frigid Northlands Garb"] = "Northern pemmican";
	outfits_and_their_items["Furry Suit"] = "Tasty Fun Good rice candy";
	outfits_and_their_items["Glad Bag Glad Rags"] = "alphabet gum";
	outfits_and_their_items["Gnauga Hides"] = "Gummi-Gnauga";
	outfits_and_their_items["Grass Guise"] = "foie gras";
	outfits_and_their_items["Grimy Reaper's Vestments"] = "children of the candy corn";
	outfits_and_their_items["Hateful Habiliment"] = "worst candy";
	outfits_and_their_items["Haunting Looks (effect)"] = "Rattlin' Chains";
	outfits_and_their_items["Hodgman's Regal Frippery"] = "roll of Hob-Os";
	outfits_and_their_items["Hot and Cold Running Ninja Suit"] = "Cold Hots candy";
	outfits_and_their_items["Hot Daub Ensemble"] = "daub-breaker";
	outfits_and_their_items["Hyperborean Hobo Habiliments"] = "Frostbite-flavored Hob-O";
	outfits_and_their_items["Knight's Armor"] = "pawn cookie";
	outfits_and_their_items["Knob Goblin Elite Guard Uniform"] = "Knob Goblin steroids";
	outfits_and_their_items["Knob Goblin Harem Girl Disguise"] = "Knob Goblin love potion";
	outfits_and_their_items["Legendary Regalia of the Chelonian Overlord"] = "chocolate turtle totem";
	outfits_and_their_items["Legendary Regalia of the Groovelord"] = "chocolate disco ball";
	outfits_and_their_items["Legendary Regalia of the Master Squeezeboxer"] = "chocolate stolen accordion";
	outfits_and_their_items["Legendary Regalia of the Pasta Master"] = "chocolate pasta spoon";
	outfits_and_their_items["Legendary Regalia of the Saucemaestro"] = "chocolate saucepan";
	outfits_and_their_items["Legendary Regalia of the Seal Crusher"] = "chocolate seal-clubbing club";
	outfits_and_their_items["Luniform"] = "Comet Drop";
	outfits_and_their_items["Mer-kin Gladiatorial Gear"] = "Mer-kin saltmint";
	outfits_and_their_items["Mer-kin Scholar's Vestments"] = "Mer-kin saltsquid";
	outfits_and_their_items["Mining Gear"] = "dwarf bread";
	outfits_and_their_items["Mutant Couture"] = "Gummi-DNA";
	outfits_and_their_items["Oil Rig"] = "crude cruditŽs";
	outfits_and_their_items["OK Lumberjack Outfit"] = "maple syrup";
	outfits_and_their_items["Palmist Paraphernalia"] = "bit-o-cactus or honey-dipped locust";
	outfits_and_their_items["Paperclippery"] = "elderly jawbreaker";
	outfits_and_their_items["Pinata Provisions"] = "pile of candy";
	outfits_and_their_items["Pork Elf Prizes"] = "Elvish delight";
	outfits_and_their_items["Pyretic Panhandler Paraphernalia"] = "sterno-flavored Hob-O";
	outfits_and_their_items["Raiments of the Final Boss"] = "Boss Drops";
	outfits_and_their_items["Roy Orbison Disguise"] = "fruitfilm";
	outfits_and_their_items["Seafaring Suit"] = "candy crayons";
	outfits_and_their_items["Slimesuit"] = "Good 'n' Slimy";
	outfits_and_their_items["Smoked Pottery"] = "volcanic ash";
	outfits_and_their_items["Snowman Suit"] = "snowball";
	outfits_and_their_items["Star Garb"] = "Senior Mints";
	outfits_and_their_items["Sucker Samurai Suit"] = "Atomic Pop";
	outfits_and_their_items["Swashbuckling Getup"] = "bottle of rum";
	outfits_and_their_items["Tapered Threads"] = "Angry Farmer's Wife Candy";
	outfits_and_their_items["Tawdry Tramp Togs"] = "fry-oil-flavored Hob-O";
	outfits_and_their_items["Terrifying Clown Suit"] = "brick";
	outfits_and_their_items["Terrycloth Tackle"] = "toothbrush";
	outfits_and_their_items["The Bone Us Round (effect)"] = "Sweet Sword";
	outfits_and_their_items["Thousandth Birthday Suit"] = "candy skeleton";
	outfits_and_their_items["Time Trappings"] = "Now and Earlier";
	outfits_and_their_items["Transparent Trappings"] = "PlexiPips";
	outfits_and_their_items["Tropical Crimbo Duds"] = "orange and black Crimboween candy";
	outfits_and_their_items["Unblemished Uniform"] = "Wax Flask";
	outfits_and_their_items["Uncle Hobo's Rags"] = "holly-flavored Hob-O";
	outfits_and_their_items["Vampin' (effect)"] = "Blood 'n' Plenty";
	outfits_and_their_items["Vestments of the Treeslayer"] = "ribbon candy";
	outfits_and_their_items["Vile Vagrant Vestments"] = "garbage-juice-flavored Hob-O";
	outfits_and_their_items["Violent Vestments"] = "violent pastilles";
	outfits_and_their_items["War Hippy Fatigues"] = "Steal This Candy";
	outfits_and_their_items["Wax Wardrobe"] = "Drizzlersª Black Licorice";
	outfits_and_their_items["Wumpus-Hair Wardrobe"] = "dubious peppermint";
	outfits_and_their_items["Yendorian Finery"] = "candied kobold";
	outfits_and_their_items["Yiffable You (effect)"] = "Lobos Mints";

	item_drop [item] drops;
	
	foreach outfit_name in outfits_and_their_items
	{
		item drop = to_item(outfits_and_their_items[outfit_name]);
		int price = mall_price(drop);
		
		drops[drop] = item_drop_make(drop, price, outfit_name);
	}

	/*item i = $item[Lobos Mints];
	drops[i] = item_drop_make(i, mall_price(i) * .4 - mall_price($item[Whisker pencil]) / 30, "Yiffable You (effect)");

	i = $item[Blood 'n' Plenty];
	drops[i] = item_drop_make(i, mall_price(i) * .4 - mall_price($item[Bite-me-red lipstick]) / 30, "Vampin' (effect)");

	i = $item[Gummy Brains];
	drops[i] = item_drop_make(i, mall_price(i) * .4 - mall_price($item[Necrotizing body spray]) / 30, "Dead Sexy (effect)");

	i = $item[Rattlin' Chains];
	drops[i] = item_drop_make(i, mall_price(i) * .4 - mall_price($item[Ghostly body paint]) / 30, "Haunting Looks (effect)");

	i = $item[Sweet Sword];
	drops[i] = item_drop_make(i, mall_price(i) * .4 - mall_price($item[Press-on ribs]) / 30, "The Bone Us Round (effect)");*/
	


	sort drops by value.price;

	foreach key in drops
	{
		item_drop id = drops[key];
		//string outfit = outfits[key];
		string colour = "black";
		if (!have_outfit_components(id.outfit) || !have_outfit(id.outfit))
			colour = "gray";
		print(id.price + " meat for item " + id.i + " with outfit " + id.outfit, colour);
	}
	
	//print("Best option: " + max_item + " at " + max_price + " meat/adventure");
	
}