import "relay/Guide/Support/LocationAvailable.ash"
import "relay/Guide/Support/Library.ash"

void main()
{
	if (my_id() != 2456416)
		return;
	initialiseLocationCombatRates();
	while (my_adventures() > 0)
	{
		int starting_turncount = my_turncount();
		foreach l in $locations[]
		{
			if (__location_combat_rates[l] > 0 && __location_combat_rates[l] < 100 && !($locations[the spooky forest,the castle in the clouds in the sky (basement),the castle in the clouds in the sky (ground floor), the castle in the clouds in the sky (top floor),The Haunted Library,The Haunted Billiards Room,The Haunted Gallery,the haunted ballroom,the outskirts of cobb's knob,The Poop Deck,Twin Peak,The Penultimate Fantasy Airship] contains l)) //'
			{
				//print_html(l);
				continue;
			}
			if (l.get_monsters().count() <= 1) continue;
			//continue;
		
			if ($effect[ultrahydrated].have_effect() == 0 && l == $location[the oasis]) continue;
			if ($locations[oil peak,The Primordial Soup,Seaside Megalopolis,The Boss Bat's Lair,The Daily Dungeon,Cobb's Knob Barracks,The Laugh Floor,The Bat Hole Entrance,Cobb's Knob Treasury,The Skeleton Store,Madness Bakery,The Overgrown Lot,The Thinknerd Warehouse] contains l) continue; //'
		
			boolean allowed = true;
			if (!l.locationAvailable())
			{
				allowed = false;
			}
			if ($locations[8-Bit Realm,The Thinknerd Warehouse,the hole in the sky] contains l)
				allowed = true;
			if ($locations[Next to that Barrel with Something Burning in it,Near an Abandoned Refrigerator,Over Where the Old Tires Are,Out by that Rusted-Out Car] contains l)
				allowed = true;
			if (!allowed)
			{
				//print_html("What's all this? " + l);
				continue;
			}
			//continue;
		
			//print_html(l);
			adv1(l, 0, "");
			if (get_property("lastEncounter").replace_string("The ", "").to_monster() != last_monster() || last_monster() == $monster[screambat] || last_monster() == $monster[blackberry bush]) //again
				adv1(l, 0, "");
		
			if (starting_turncount != my_turncount())
			{
				abort("they hurt me");
			}
		}
		//break;
		if (starting_turncount == my_turncount())
		{
			if ($effect[ultrahydrated].have_effect() == 0)
				adv1($location[the oasis], 0, "");
			else
				adv1($location[the limerick dungeon], 0, "");
		}
	}
}