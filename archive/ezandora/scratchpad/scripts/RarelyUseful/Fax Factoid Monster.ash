import "relay/Guide/Support/List.ash"

void main()
{
	if ($item[photocopied monster].available_amount() > 0 || get_property("_photocopyUsed").to_boolean())
		return;
	
	if (!get_property("_fax_factoid_monster_loaded_manuel").to_boolean())
	{
		print_html("Loading manuel...");
		foreach s in $strings[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,-]
			visit_url("questlog.php?which=6&vl=" + s + "&filter=0");
		set_property("_fax_factoid_monster_loaded_manuel", true);
		print_html("Done loading manuel.");
	}
	monster [int] monster_options;
	foreach m in $monsters[]
	{
		int factoids = monster_factoids_available(m, true);
		if (factoids >= 3)
			continue;
		if ($monsters[Bailey's Beetle,War Hippy Elite Fire Spinner,reanimated baboon skeleton,reanimated bat skeleton,reanimated demon skeleton,reanimated giant spider skeleton,reanimated serpent skeleton,reanimated wyrm skeleton,Witchess Bishop,Witchess King,Witchess Knight,Witchess Ox,Witchess Pawn,Witchess Queen,Witchess Rook,Witchess Witch] contains m) //'
			continue;
		if (can_faxbot(m))
		{
			monster_options[monster_options.count()] = m;
		}
	}
	print_html("Can fax for factoids " + monster_options.to_json());
	monster monster_faxing = monster_options.listGetRandomObject();
	if (monster_faxing != $monster[none])
	{
		print_html("Chose " + monster_faxing + " which has " + monster_factoids_available(monster_faxing, true) + " factoids.");
		boolean ignore = faxbot(monster_faxing);
	}
}

//Can fax for factoids { "0" : "actual orcish frat boy", "1" : "amateur elf", "2" : "ancient temple guardian", "3" : "angry raccoon puppet", "4" : "Arc-Welding Elfborg", "5" : "auteur elf", "6" : "Bad ASCII Art", "7" : "Black Crayon Spiraling Shape", "8" : "Black-and-White-Ops Penguin", "9" : "borg a-beeping", "10" : "bow-making mummy", "11" : "Box of Crafty Dinner", "12" : "C. H. U. M. chieftain", "13" : "Cement Cobbler Penguin", "14" : "Cookie-baking Thing from Beyond Time", "15" : "deadwood tree", "16" : "death ray in a pear tree", "17" : "Decal-Applying Elfborg", "18" : "emaciated Knott Yeti", "19" : "fiendish zombie can of asparagus", "20" : "flint-scraping cave elf", "21" : "four skeleton invaders", "22" : "fudge oyster", "23" : "fudge vulture", "24" : "gang of hobo muggers", "25" : "giant pair of tweezers", "26" : "gift-wrapping vampire", "27" : "golden ring", "28" : "goose a-laying", "29" : "Happy, the Reindeer", "30" : "Hobelf", "31" : "hunter-gatherer cave elf", "32" : "ice skate", "33" : "jailbait orquette", "34" : "juvenile delinquent orquette", "35" : "Knob Goblin Elite Guardsman", "36" : "Knob Goblin Embezzler", "37" : "laser lancing", "38" : "Mesmerizing Penguin", "39" : "Mob Penguin Arsonist", "40" : "Mob Penguin hitpenguin", "41" : "Mob Penguin psychopath", "42" : "Mob Penguin Soprano", "43" : "Mob Penguin Thug", "44" : "mutant circuit-soldering elf", "45" : "mutant cookie-baking elf", "46" : "mutant doll-dressing elf", "47" : "mutant gift-wrapping elf", "48" : "mutant saguaro", "49" : "orcish juvenile delinquent", "50" : "Possessed Can of Creepy Pasta", "51" : "provocateur elf", "52" : "pufferfish", "53" : "Red Fox", "54" : "rock homunculus", "55" : "rock-banging cave elf", "56" : "rockfish", "57" : "Rudolph the Red", "58" : "Servant of Lord Flameface", "59" : "sexy sorority ghost", "60" : "sexy sorority werewolf", "61" : "sexy sorority zombie", "62" : "sinew-stretching cave elf", "63" : "skeletal reindeer", "64" : "smooth jazz scabie", "65" : "Sneezy, the Reindeer", "66" : "stocking-stuffing zombie", "67" : "stomper stomping", "68" : "Striking Factory-Worker Elf", "69" : "Striking Gift-Wrapper Elf", "70" : "Striking Middle-Management Elf", "71" : "Striking Pencil-Pusher Elf", "72" : "Striking Stocking-Stuffer Elf", "73" : "swarm a-swarming", "74" : "swarm of mutant fire ants", "75" : "Swiss hen", "76" : "taco-clad Crimbo elf", "77" : "towering construct", "78" : "turtle mech", "79" : "two skeleton invaders", "80" : "Undercover Penguin", "81" : "unholy diver", "82" : "water spider", "83" : "Zombie eXtreme Snowboarding Orc", "84" : "zombie frat boy", "85" : "zombie Gnollish crossdresser", "86" : "Zombie Goth Giant", "87" : "zombie hippy", "88" : "Zombie Knob Goblin Assistant Chef", "89" : "Zombie Quiet Healer", "90" : "zombie zmobie" }