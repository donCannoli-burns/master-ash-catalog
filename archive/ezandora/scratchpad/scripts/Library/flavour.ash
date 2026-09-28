/*
Flavour.ash - Auto-tunes flavour of magic to attack elemental monsters.

Type this in the Graphical CLI to setup this script:
	alias f => call flavour.ash
And also:
	alias flavour => call flavour.ash

Basic use:
	Just type "f l", or "flavour last" into your graphical CLI every time you want to retune flavour. This will always insure you have flavour running (peppermint/cold by default), and that it is tuned to whatever monster you fought last. It will only use mana if you have it available.
	"f element" will tune flavour to attack monsters of that element. "f hot" will tune flavour to attack hot-elemental monsters, etc.
	"f reset" or "f r" will tune flavour to be useful in most situations. (Spirit of Peppermint. Most monsters in the kingdom aren't cold-elemental)

Advanced use:
	Add "f last_no_restore;" to your Post-Adventure script in Preferences>Automation. This will auto-tune flavour for you, and only use MP when you have it available.



Commands:
	[last, l] - Tunes the flavor to whatever monster you fought last. If the monster was physical, does nothing if a flavour is active; if there aren't, it casts Spirit of Peppermint (cold element).
	[hot, spooky, cold, sleaze, stench] - Tunes the flavour to attack a monster of the given element. For example, "f set cold" casts Spirit of Cayenne (hot element)
	[reset, r] - Resets to attack with cold. Few monsters in the kingdom are cold elemental, so this works in most situations.
	
	none - Casts spirit of nothing, removing flavour of magic.
	set [hot, spooky, cold, sleaze, stench] - Casts the spirit corresponding to this element. For example, "f set cold" casts Spirit of Peppermint.
*/


void main(string argument)
{
	if (get_property("__disable_autotune").to_boolean())
		return;
	if (!have_skill($skill[Flavour of Magic]))
		return;
	string spell_name = "";
	string alternate_spell_name = "";
	
	if (argument == "last_no_restore" || argument == "lnr") //pre-revamp argument; kept for backwards compatibility
		argument = "last";
	
	if (argument == "last" || argument == "l")
	{
		if (my_location() == $location[Dreadsylvanian Woods] || my_location() == $location[Dreadsylvanian Village] || my_location() == $location[Dreadsylvanian Castle])
			return;
		element last_monster_element = last_monster().defense_element;
		if (last_monster_element == to_element("none"))
		{
			//Do we have flavour cast?
			if (have_effect($effect[Spirit of Peppermint]) > 0 || have_effect($effect[Spirit of Cayenne]) > 0 || have_effect($effect[Spirit of Wormwood]) > 0 || have_effect($effect[Spirit of Bacon Grease]) > 0 || have_effect($effect[Spirit of Garlic]) > 0)
				return;
			//No?
			argument = "reset";
		}
		else
			argument = last_monster_element;
	}
	if (my_location() == $location[through the spacegate])
		argument = "none";
	
	if (argument == "hot") //stench/sleaze, picking stench
	{
		spell_name = "Spirit of Garlic";
		alternate_spell_name = "Spirit of Bacon Grease";
	}
	else if (argument == "spooky") //hot/stench, picking hot
	{
		spell_name = "Spirit of Cayenne";
		alternate_spell_name = "Spirit of Garlic";
	}
	else if (argument == "cold") //hot/spooky, picking hot
	{
		spell_name = "Spirit of Cayenne";
		alternate_spell_name = "Spirit of Wormwood";
	}
	else if (argument == "sleaze") //cold/spooky, picking cold
	{
		spell_name = "Spirit of Peppermint";
		alternate_spell_name = "Spirit of Wormwood";
	}
	else if (argument == "stench") //sleaze/cold, picking cold
	{
		spell_name = "Spirit of Peppermint";
		alternate_spell_name = "Spirit of Bacon Grease";
	}
	else if (argument == "none") //not very useful
		spell_name = "Spirit of Nothing";
	else if (argument == "reset" || argument == "r") //default, not a lot of cold monsters in the game (in HC, lair of the ninja snowmen, icy peak, and dooks)
		spell_name = "Spirit of Peppermint";
	else if (argument == "set hot")
		spell_name = "Spirit of Cayenne";
	else if (argument == "set spooky")
		spell_name = "Spirit of Wormwood";
	else if (argument == "set cold")
		spell_name = "Spirit of Peppermint";
	else if (argument == "set sleaze")
		spell_name = "Spirit of Bacon Grease";
	else if (argument == "set stench")
		spell_name = "Spirit of Garlic";
	else if (argument == "tpain" || argument == "t-pain")
		print("I'm on a boat");
	
	if (spell_name == "")
		return;
	
	if (have_effect(to_effect(spell_name)) > 0 || have_effect(to_effect(alternate_spell_name)) > 0)
		return;

	cli_execute("cast " + spell_name);
}