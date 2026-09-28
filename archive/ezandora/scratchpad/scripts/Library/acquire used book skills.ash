//This script is in the public domain.

record SkillBook
{
	skill learned_skill;
	item book;
	class class_requirement;
};

SkillBook SkillBookMake(skill learned_skill, item book, class class_requirement)
{
	SkillBook result;
	result.learned_skill = learned_skill;
	result.book = book;
	result.class_requirement = class_requirement;
	return result;
}

SkillBook SkillBookMake(skill learned_skill, item book)
{
	return SkillBookMake(learned_skill, book, $class[none]);
}

void listAppend(SkillBook [int] list, SkillBook entry)
{
	int position = count(list);
	while (list contains position)
		position = position + 1;
	list[position] = entry;
}

void main()
{
	SkillBook [int] books;

	//Crimbo 2009:
	books.listAppend(SkillBookMake($skill[holiday weight gain], $item[A Crimbo Carol, Ch. 1 (used)]));
	books.listAppend(SkillBookMake($skill[Jingle Bells], $item[A Crimbo Carol, Ch. 2 (used)]));
	books.listAppend(SkillBookMake($skill[Candyblast], $item[A Crimbo Carol, Ch. 3 (used)]));
	books.listAppend(SkillBookMake($skill[Surge of Icing], $item[A Crimbo Carol, Ch. 4 (used)]));
	books.listAppend(SkillBookMake($skill[Stealth Mistletoe], $item[A Crimbo Carol, Ch. 5 (used)]));
	books.listAppend(SkillBookMake($skill[Cringle's Curative Carol], $item[A Crimbo Carol, Ch. 6 (used)])); //'

	//Crimbo 2010:
	books.listAppend(SkillBookMake($skill[Fashionably Late], $item[CRIMBCO Employee Handbook (chapter 1) (used)]));
	books.listAppend(SkillBookMake($skill[Executive Narcolepsy], $item[CRIMBCO Employee Handbook (chapter 2) (used)]));
	books.listAppend(SkillBookMake($skill[Lunch Break], $item[CRIMBCO Employee Handbook (chapter 3) (used)]));
	books.listAppend(SkillBookMake($skill[Offensive Joke], $item[CRIMBCO Employee Handbook (chapter 4) (used)]));
	books.listAppend(SkillBookMake($skill[Managerial Manipulation], $item[CRIMBCO Employee Handbook (chapter 5) (used)]));
	
	//Travelling trader:
	books.listAppend(SkillBookMake($skill[Iron Palm Technique], $item[The Art of Slapfighting (used)], $class[Seal Clubber]));
	books.listAppend(SkillBookMake($skill[Curiosity of Br'er Tarrypin], $item[Uncle Romulus (used)], $class[Turtle Tamer])); //'
	books.listAppend(SkillBookMake($skill[Stringozzi Serpent], $item[A Beginner's Guide to Charming Snakes (used)], $class[Pastamancer])); //'
	books.listAppend(SkillBookMake($skill[K&auml;seso&szlig;esturm], $item[Zu Mannk&auml;se Dienen (used)], $class[Sauceror]));
	books.listAppend(SkillBookMake($skill[Kung Fu Hustler], $item[Autobiography Of Dynamite Superman Jones (used)], $class[Disco Bandit]));
	books.listAppend(SkillBookMake($skill[Inigo's Incantation of Inspiration], $item[Inigo's Incantation of Inspiration (crumpled)], $class[Accordion Thief]));
	
	//Unearthed volcanic meteoroid intentionally missing.
	
	books.listAppend(SkillBookMake($skill[Unaccompanied Miner], $item[Ellsbury's journal (used)])); //'
	books.listAppend(SkillBookMake($skill[Toynado], $item[Tales of a Kansas Toymaker (used)]));
	books.listAppend(SkillBookMake($skill[Wassail], $item[The Joy of Wassailing (used)]));
	
	//Events:
	books.listAppend(SkillBookMake($skill[Summon &quot;Boner Battalion&quot;], $item[The Necbronomicon (used)]));
	books.listAppend(SkillBookMake($skill[Frigidalmatian], $item[Hjodor's Guide to Arctic Dalmatians (used)])); //'
	books.listAppend(SkillBookMake($skill[Natural Born Skeleton Killer], $item[Field Guide to Skeletal Anatomy (shredded)]));
	books.listAppend(SkillBookMake($skill[Silent Slam], $item[Record of infuriating silence (used)]));
	books.listAppend(SkillBookMake($skill[Silent Slice], $item[Record of menacing silence (used)]));
	books.listAppend(SkillBookMake($skill[Silent Squirt], $item[Record of tranquil silence (used)]));
	books.listAppend(SkillBookMake($skill[shrap], $item[warbear metalworking primer (used)]));
	books.listAppend(SkillBookMake($skill[Psychokinetic Hug], $item[warbear empathy chip (used)]));


	foreach key in books
	{
		SkillBook book = books[key];
		
		if (book.book.tradeable)
		{
			print("Internal error - book " + book.book + " is not a used copy");
			continue;
		}
		
		if (book.class_requirement != $class[none] && book.class_requirement != my_class())
			continue;
		
		if (have_skill(book.learned_skill))
			continue;
		if (available_amount(book.book) == 0)
			continue;
			
		
		use(1, book.book);
	}
}