/*
Ol' Scratch's  Ash can
Ol' Scratch's ol' Britches
Ol' Scratch's  Stovepipe Hat
Ol' Scratch's Infernal Pitchfork
Ol' Scratch's Manacles
Ol' Scratch's Stove Door
Frosty's Old Silk Hat
Frosty's Nailbat
Frosty's Carrot
Frosty's Iceball
Frosty's Arm
Frosty's Snowball Sack
Oscus's Dumpster Waders
Oscus's Pelt
Wand of Oscus
Oscus's Flypaper Pants
Oscus's Garbage Can Lid
Oscus's Neverending Soda
Zombo's Grievous Greaves
Zombo's Shield
Zombo's Skullcap
Zombo's Empty Eye
Zombo's Shoulder Blade
Zombo's Skull Ring
Chester's Bag of Candy
Chester's Cutoffs
Chester's Moustache
Chester's Aquarius Medallion
Chester's Muscle Shirt
Chester's Sunglasses
Hodgman's Bow Tie
Hodgman's Porkpie Hat
Hodgman's Lobsterskin Pants
Hodgman's Almanac
Hodgman's Lucky Sock
Hodgman's Metal Detector
Hodgman's Varcolac Paw
Hodgman's Harmonica
Hodgman's Garbage Sticker
Hodgman's Cane
Hodgman's Whackin' Stick
Hodgman's Disgusting Technicolor Overcoat
Hodgman's Imaginary Hamster

Great Wolf's Headband	Great Wolf's Right Paw	Great Wolf's Left Paw	Great Wolf's lice	Great Wolf's rocket launcher	Great Wolf's beastly trousers	Drapes-You-Regally	Warms-Your-Tush	Covers-Your-Head	Protects-Your-Junk	Quiets-Your-Steps	Helps-You-Sleep	Mayor Ghost's Cloak	Mayor Ghosts's Khakis	Mayor Ghost's Toupee	Mayor Ghost's Scissors	Mayor Ghost's sash	Mayor Ghost's gavel	Zombie Mariachi Hat	Zombie Accordion	Zombie Mariachi Pants	HOA regulation book	HOA zombie eyes	HOA citation pad	Unkillable Skeleton's Skullcap	Unkillable Skeleton's Shinguards	Unkillable Skeleton's Breastplate	Unkillable Skeleton's shield	Unkillable Skeleton's sawsword	Unkillable Skeleton's restless leg	Thunkula's Drinking Cap	Drunkula's Silky Pants	Drunkula's Cape	Drunkula's ring of haze	Drunkula's wineglass	Drunkula's bell



The Necbromancer's Hat	The Necbromancer's Shorts	The Necbromancer's Stein	The Necbromancer's Wizard Staff	Necbronomicon

hardened slime belt	hardened slime hat	hardened slime pants	slime-soaked brain	slime-soaked hypophysis	slime-soaked sweat gland	Caustic slime nodule	Squirming Slime larva
*/

void listAppend(item [int] list, item entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}


item [int] listMakeBlankItem()
{
	item [int] result;
	return result;
}

//Display case, etc
//WARNING: Does not take into account your shop. Conceptually, the shop is things you're getting rid of... and they might be gone already.
int item_amount_almost_everywhere(item it)
{
    return it.closet_amount() + it.display_amount() + it.equipped_amount() + it.item_amount() + it.storage_amount();
}


void main()
{
	item [string][int] dungeon_items;
	
	dungeon_items["Hobopolis"] = listMakeBlankItem();
	dungeon_items["Slimetube"] = listMakeBlankItem();
	dungeon_items["Haunted House"] = listMakeBlankItem();
	dungeon_items["Library"] = listMakeBlankItem();
	dungeon_items["Dreadyslvania"] = listMakeBlankItem();
	foreach it in $items[Ol' Scratch's ash can,Ol' Scratch's ol' Britches,Ol' Scratch's stovepipe hat,Ol' Scratch's Infernal Pitchfork,Ol' Scratch's Manacles,Ol' Scratch's Stove Door,Frosty's Old Silk Hat,Frosty's Nailbat,Frosty's Carrot,Frosty's Iceball,Frosty's Arm,Frosty's Snowball Sack,Oscus's Dumpster Waders,Oscus's Pelt,Wand of Oscus,Oscus's Flypaper Pants,Oscus's Garbage Can Lid,Oscus's Neverending Soda,Zombo's Grievous Greaves,Zombo's Shield,Zombo's Skullcap,Zombo's Empty Eye,Zombo's Shoulder Blade,Zombo's Skull Ring,Chester's Bag of Candy,Chester's Cutoffs,Chester's Moustache,Chester's Aquarius Medallion,Chester's Muscle Shirt,Chester's Sunglasses,Hodgman's Bow Tie,Hodgman's Porkpie Hat,Hodgman's Lobsterskin Pants,Hodgman's Almanac,Hodgman's Lucky Sock,Hodgman's Metal Detector,Hodgman's Varcolac Paw,Hodgman's Harmonica,Hodgman's Garbage Sticker,Hodgman's Cane,Hodgman's Whackin' Stick,Hodgman's Disgusting Technicolor Overcoat,Hodgman's Imaginary Hamster]
		dungeon_items["Hobopolis"].listAppend(it);
	foreach it in $items[Great Wolf's Headband,Great Wolf's Right Paw,Great Wolf's Left Paw,Great Wolf's lice,Great Wolf's rocket launcher,Great Wolf's beastly trousers,Drapes-You-Regally,Warms-Your-Tush,Covers-Your-Head,Protects-Your-Junk,Quiets-Your-Steps,Helps-You-Sleep,Mayor Ghost's Cloak,Mayor Ghost's Khakis,Mayor Ghost's Toupee,Mayor Ghost's Scissors,Mayor Ghost's sash,Mayor Ghost's gavel,Zombie Mariachi Hat,Zombie Accordion,Zombie Mariachi Pants,HOA regulation book,HOA zombie eyes,HOA citation pad,Unkillable Skeleton's Skullcap,Unkillable Skeleton's Shinguards,Unkillable Skeleton's Breastplate,Unkillable Skeleton's shield,Unkillable Skeleton's sawsword,Unkillable Skeleton's restless leg,Thunkula's Drinking Cap,Drunkula's Silky Pants,Drunkula's Cape,Drunkula's ring of haze,Drunkula's wineglass,Drunkula's bell]
		dungeon_items["Dreadyslvania"].listAppend(it);
	
	foreach it in $items[The Necbromancer's Hat,The Necbromancer's Shorts,The Necbromancer's Stein,The Necbromancer's Wizard Staff]
		dungeon_items["Haunted House"].listAppend(it);
	if (!$skill[Summon "Boner Battalion"].have_skill())
		dungeon_items["Haunted House"].listAppend($item[The Necbronomicon]);
	
	//FIXME support slime-soaked brain, slime-soaked hypophysis, slime-soaked sweat gland
	
	foreach it in $items[hardened slime belt,hardened slime hat,hardened slime pants,baneful bandolier,corroded breeches,corrosive cowl,diabolical crossbow,grisly shield,malevolent medallion,pernicious cudgel,villainous scythe]
		dungeon_items["Slimetube"].listAppend(it);
	if (!$familiar[slimeling].have_familiar())
		dungeon_items["Slimetube"].listAppend($item[Squirming Slime larva]);
	
	foreach dungeon_type in dungeon_items
	{
		item [int] items_have;
		item [int] items_lack;
		foreach key, it in dungeon_items[dungeon_type]
		{
			int amount = it.item_amount_almost_everywhere();
			if (amount <= 0)
				items_lack.listAppend(it);
			else
				items_have.listAppend(it);
			
		}
		
		print_html(dungeon_type + ":");
		foreach key, it in items_lack
		{
			int amount = it.item_amount_almost_everywhere();
			string colour = "red";
			
			print_html("&nbsp;&nbsp;&nbsp;&nbsp;</span><span style=\"color:" + colour + ";\">" + it + ": " + amount + "</span>");
		}
		foreach key, it in items_have
		{
			int amount = it.item_amount_almost_everywhere();
			string colour = "black";
			
			print_html("&nbsp;&nbsp;&nbsp;&nbsp;<span style=\"color:" + colour + ";\">" + it + ": " + amount + "</span>");
		}
	}
	
}