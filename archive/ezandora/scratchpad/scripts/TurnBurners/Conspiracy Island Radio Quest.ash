import "relay/Guide/QuestState.ash";

void replyToRadio()
{
	visit_url("place.php?whichplace=airport_spooky&action=airport2_radio", false);
	visit_url("choice.php?whichchoice=984&option=1");
}

void GoreQuest()
{
	if (!QuestState("questESpGore").in_progress)
		return;
	
	if (get_property("goreCollected").to_int() >= 100)
	{
		replyToRadio();
		return;
	}
	
	cli_execute("familiar hobo monkey");
	cli_execute("maximize mainstat -hat -pants -acc1 -acc2 -acc3 -back -familiar -shirt -tie +equip gore bucket");
	cli_execute("maximize meat -tie +equip gore bucket -weapon");
	cli_execute("ccs helix fossil");
	
    set_property("_lord_helix_please_olfact_these_monsters", "super-sized Cola Wars soldier");
	while (get_property("goreCollected").to_int() < 100)
	{
		if ($item[Personal Ventilation Unit].equipped_amount() == 0 && $item[Personal Ventilation Unit].available_amount() > 0)
			equip($slot[acc3], $item[Personal Ventilation Unit]);
		if (can_interact())
		{
			if ($effect[trivia master].have_effect() == 0)
				cli_execute("up trivia master");
			if ($effect[Cock of the Walk].have_effect() == 0)
				cli_execute("use Connery's Elixir of Audacity");
		}
		cli_execute("restore hp");
		adv1($location[the secret government laboratory], 0, "");
		if ($effect[beaten up].have_effect() > 0) //we aren't gaining this effect...?
		{
			print("ow", "red");
			break;
		}
	}
    set_property("_lord_helix_please_olfact_these_monsters", "");
	
	replyToRadio();
	
}

void JunglePunsQuest()
{
	if (!QuestState("questESpJunglePun").in_progress)
		return;
	if (get_property("junglePuns").to_int() >= 11)
	{
		replyToRadio();
		return;
	}
	cli_execute("familiar scarecrow");
	cli_execute("mood junglepuns");
	cli_execute("mood execute");
	cli_execute("maximize myst -tie +equip encrypted micro-cassette recorder");
	cli_execute("equip familiar spangly mariachi pants");
	cli_execute("ccs helix fossil");
	
    set_property("_lord_helix_please_olfact_these_monsters", "bigface");
	while (get_property("junglePuns").to_int() < 11)
	{
		cli_execute("restore hp");
		adv1($location[the deep dark jungle], 0, "");
		if ($effect[beaten up].have_effect() > 0) //we aren't gaining this effect...?
		{
			print("ow", "red");
			break;
		}
	}
    set_property("_lord_helix_please_olfact_these_monsters", "");
	cli_execute("mood apathetic");
	
	replyToRadio();
}


void ClipperQuest()
{
	if (!QuestState("questESpClipper").in_progress)
		return;
	if (get_property("fingernailsClipped").to_int() >= 23)
	{
		replyToRadio();
		return;
	}
	cli_execute("equip acc3 navel ring");
	cli_execute("ccs helix fossil");
	cli_execute("fam none");
	
	while (get_property("fingernailsClipped").to_int() < 23)
	{
		cli_execute("restore hp");
		adv1($location[The Mansion of Dr. Weirdeaux], 0, "");
		if ($effect[beaten up].have_effect() > 0) //we aren't gaining this effect...?
		{
			print("ow", "red");
			break;
		}
	}
	
	replyToRadio();
}


void main()
{
	GoreQuest();
	JunglePunsQuest();
	ClipperQuest();
}