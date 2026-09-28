//WARNING: All listAppend functions are flawed.
//Specifically, there's a possibility of a hole that causes order to be incorrect.
//But, the only way to fix that is to traverse the list to determine the maximum key.
//That would take forever...

string listLastObject(string [int] list)
{
    if (list.count() == 0)
        return "";
    return list[list.count() - 1];
}

void listAppend(string [int] list, string entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppendList(string [int] list, string [int] entries)
{
	foreach key in entries
		list.listAppend(entries[key]);
}

string [int] listUnion(string [int] list, string [int] list2)
{
    string [int] result;
    foreach key, s in list
        result.listAppend(s);
    foreach key, s in list2
        result.listAppend(s);
    return result;
}

void listAppendList(boolean [item] destination, boolean [item] source)
{
    foreach it, value in source
        destination[it] = value;
}

void listAppendList(boolean [string] destination, boolean [string] source)
{
    foreach key, value in source
        destination[key] = value;
}

void listAppendList(boolean [skill] destination, boolean [skill] source)
{
    foreach key, value in source
        destination[key] = value;
}

void listAppend(item [int] list, item entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppendList(item [int] list, item [int] entries)
{
	foreach key in entries
        list.listAppend(entries[key]);
}



void listAppend(int [int] list, int entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(float [int] list, float entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(location [int] list, location entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(element [int] list, element entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppendList(location [int] list, location [int] entries)
{
	foreach key in entries
        list.listAppend(entries[key]);
}

void listAppend(effect [int] list, effect entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(skill [int] list, skill entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(familiar [int] list, familiar entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(monster [int] list, monster entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(phylum [int] list, phylum entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(buffer [int] list, buffer entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(slot [int] list, slot entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(thrall [int] list, thrall entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}





void listAppend(string [int][int] list, string [int] entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(skill [int][int] list, skill [int] entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(familiar [int][int] list, familiar [int] entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(int [int][int] list, int [int] entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(item [int][int] list, item [int] entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppend(skill [int] list, boolean [skill] entry)
{
    foreach v in entry
        list.listAppend(v);
}

void listAppend(item [int] list, boolean [item] entry)
{
    foreach v in entry
        list.listAppend(v);
}

void listPrepend(string [int] list, string entry)
{
	int position = 0;
	while (list contains position)
		position -= 1;
	list[position] = entry;
}

void listPrepend(skill [int] list, skill entry)
{
	int position = 0;
	while (list contains position)
		position -= 1;
	list[position] = entry;
}

void listAppendList(skill [int] list, skill [int] entries)
{
	foreach key in entries
        list.listAppend(entries[key]);
}

void listPrepend(location [int] list, location entry)
{
	int position = 0;
	while (list contains position)
		position -= 1;
	list[position] = entry;
}

void listPrepend(item [int] list, item entry)
{
    int position = 0;
    while (list contains position)
        position -= 1;
    list[position] = entry;
}


void listClear(string [int] list)
{
	foreach i in list
	{
		remove list[i];
	}
}

void listClear(int [int] list)
{
	foreach i in list
	{
		remove list[i];
	}
}

void listClear(item [int] list)
{
	foreach i in list
	{
		remove list[i];
	}
}

void listClear(location [int] list)
{
	foreach i in list
	{
		remove list[i];
	}
}

void listClear(monster [int] list)
{
	foreach i in list
	{
		remove list[i];
	}
}

void listClear(skill [int] list)
{
	foreach i in list
	{
		remove list[i];
	}
}


void listClear(boolean [string] list)
{
	foreach i in list
	{
		remove list[i];
	}
}


string [int] listMakeBlankString()
{
	string [int] result;
	return result;
}

item [int] listMakeBlankItem()
{
	item [int] result;
	return result;
}

skill [int] listMakeBlankSkill()
{
	skill [int] result;
	return result;
}

location [int] listMakeBlankLocation()
{
	location [int] result;
	return result;
}

monster [int] listMakeBlankMonster()
{
	monster [int] result;
	return result;
}

familiar [int] listMakeBlankFamiliar()
{
	familiar [int] result;
	return result;
}

int [int] listMakeBlankInt()
{
    int [int] result;
    return result;
}




string [int] listMake(string e1)
{
	string [int] result;
	result.listAppend(e1);
	return result;
}

string [int] listMake(string e1, string e2)
{
	string [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	return result;
}

string [int] listMake(string e1, string e2, string e3)
{
	string [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	return result;
}

string [int] listMake(string e1, string e2, string e3, string e4)
{
	string [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	result.listAppend(e4);
	return result;
}

string [int] listMake(string e1, string e2, string e3, string e4, string e5)
{
	string [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	result.listAppend(e4);
	result.listAppend(e5);
	return result;
}

string [int] listMake(string e1, string e2, string e3, string e4, string e5, string e6)
{
	string [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	result.listAppend(e4);
	result.listAppend(e5);
	result.listAppend(e6);
	return result;
}

int [int] listMake(int e1)
{
	int [int] result;
	result.listAppend(e1);
	return result;
}

int [int] listMake(int e1, int e2)
{
	int [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	return result;
}

int [int] listMake(int e1, int e2, int e3)
{
	int [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	return result;
}

int [int] listMake(int e1, int e2, int e3, int e4)
{
	int [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	result.listAppend(e4);
	return result;
}

int [int] listMake(int e1, int e2, int e3, int e4, int e5)
{
	int [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	result.listAppend(e4);
	result.listAppend(e5);
	return result;
}

item [int] listMake(item e1)
{
	item [int] result;
	result.listAppend(e1);
	return result;
}

item [int] listMake(item e1, item e2)
{
	item [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	return result;
}

item [int] listMake(item e1, item e2, item e3)
{
	item [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	return result;
}

item [int] listMake(item e1, item e2, item e3, item e4)
{
	item [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	result.listAppend(e4);
	return result;
}

item [int] listMake(item e1, item e2, item e3, item e4, item e5)
{
	item [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	result.listAppend(e4);
	result.listAppend(e5);
	return result;
}

skill [int] listMake(skill e1)
{
	skill [int] result;
	result.listAppend(e1);
	return result;
}

skill [int] listMake(skill e1, skill e2)
{
	skill [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	return result;
}

skill [int] listMake(skill e1, skill e2, skill e3)
{
	skill [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	return result;
}

skill [int] listMake(skill e1, skill e2, skill e3, skill e4)
{
	skill [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	result.listAppend(e4);
	return result;
}

skill [int] listMake(skill e1, skill e2, skill e3, skill e4, skill e5)
{
	skill [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	result.listAppend(e4);
	result.listAppend(e5);
	return result;
}


monster [int] listMake(monster e1)
{
	monster [int] result;
	result.listAppend(e1);
	return result;
}

monster [int] listMake(monster e1, monster e2)
{
	monster [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	return result;
}

monster [int] listMake(monster e1, monster e2, monster e3)
{
	monster [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	return result;
}

monster [int] listMake(monster e1, monster e2, monster e3, monster e4)
{
	monster [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	result.listAppend(e4);
	return result;
}

monster [int] listMake(monster e1, monster e2, monster e3, monster e4, monster e5)
{
	monster [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	result.listAppend(e4);
	result.listAppend(e5);
	return result;
}

monster [int] listMake(monster e1, monster e2, monster e3, monster e4, monster e5, monster e6)
{
	monster [int] result;
	result.listAppend(e1);
	result.listAppend(e2);
	result.listAppend(e3);
	result.listAppend(e4);
	result.listAppend(e5);
	result.listAppend(e6);
	return result;
}

string listJoinComponents(string [int] list, string joining_string, string and_string)
{
	buffer result;
	boolean first = true;
	int number_seen = 0;
	foreach i, value in list
	{
		if (first)
		{
			result.append(value);
			first = false;
		}
		else
		{
			if (!(list.count() == 2 && and_string != ""))
				result.append(joining_string);
			if (and_string != "" && number_seen == list.count() - 1)
			{
				result.append(" ");
				result.append(and_string);
				result.append(" ");
			}
			result.append(value);
		}
		number_seen = number_seen + 1;
	}
	return result.to_string();
}

string listJoinComponents(string [int] list, string joining_string)
{
	return listJoinComponents(list, joining_string, "");
}

string listJoinComponents(item [int] list, string joining_string, string and_string)
{
	//lazy:
	//convert items to strings, join that
	string [int] list_string;
	foreach key in list
		list_string.listAppend(list[key].to_string());
	return listJoinComponents(list_string, joining_string, and_string);
}

string listJoinComponents(item [int] list, string joining_string)
{
	return listJoinComponents(list, joining_string, "");
}

string listJoinComponents(monster [int] list, string joining_string, string and_string)
{
	string [int] list_string;
	foreach key in list
		list_string.listAppend(list[key].to_string());
	return listJoinComponents(list_string, joining_string, and_string);
}
string listJoinComponents(monster [int] list, string joining_string)
{
	return listJoinComponents(list, joining_string, "");
}

string listJoinComponents(effect [int] list, string joining_string, string and_string)
{
	string [int] list_string;
	foreach key in list
		list_string.listAppend(list[key].to_string());
	return listJoinComponents(list_string, joining_string, and_string);
}

string listJoinComponents(effect [int] list, string joining_string)
{
	return listJoinComponents(list, joining_string, "");
}


string listJoinComponents(familiar [int] list, string joining_string, string and_string)
{
	string [int] list_string;
	foreach key in list
		list_string.listAppend(list[key].to_string());
	return listJoinComponents(list_string, joining_string, and_string);
}

string listJoinComponents(familiar [int] list, string joining_string)
{
	return listJoinComponents(list, joining_string, "");
}



string listJoinComponents(location [int] list, string joining_string, string and_string)
{
	//lazy:
	//convert locations to strings, join that
	string [int] list_string;
	foreach key in list
		list_string.listAppend(list[key].to_string());
	return listJoinComponents(list_string, joining_string, and_string);
}

string listJoinComponents(location [int] list, string joining_string)
{
	return listJoinComponents(list, joining_string, "");
}

string listJoinComponents(phylum [int] list, string joining_string, string and_string)
{
	string [int] list_string;
	foreach key in list
		list_string.listAppend(list[key].to_string());
	return listJoinComponents(list_string, joining_string, and_string);
}

string listJoinComponents(phylum [int] list, string joining_string)
{
	return listJoinComponents(list, joining_string, "");
}



string listJoinComponents(skill [int] list, string joining_string, string and_string)
{
	string [int] list_string;
	foreach key in list
		list_string.listAppend(list[key].to_string());
	return listJoinComponents(list_string, joining_string, and_string);
}

string listJoinComponents(skill [int] list, string joining_string)
{
	return listJoinComponents(list, joining_string, "");
}

string listJoinComponents(int [int] list, string joining_string, string and_string)
{
	//lazy:
	//convert ints to strings, join that
	string [int] list_string;
	foreach key in list
		list_string.listAppend(list[key].to_string());
	return listJoinComponents(list_string, joining_string, and_string);
}

string listJoinComponents(int [int] list, string joining_string)
{
	return listJoinComponents(list, joining_string, "");
}


void listRemoveKeys(string [int] list, int [int] keys_to_remove)
{
	foreach i in keys_to_remove
	{
		int key = keys_to_remove[i];
		if (!(list contains key))
			continue;
		remove list[key];
	}
}

int listSum(int [int] list)
{
    int v = 0;
    foreach key in list
    {
        v += list[key];
    }
    return v;
}


string [int] listCopy(string [int] l)
{
    string [int] result;
    foreach key in l
        result[key] = l[key];
    return result;
}

int [int] listCopy(int [int] l)
{
    int [int] result;
    foreach key in l
        result[key] = l[key];
    return result;
}

monster [int] listCopy(monster [int] l)
{
    monster [int] result;
    foreach key in l
        result[key] = l[key];
    return result;
}

element [int] listCopy(element [int] l)
{
    element [int] result;
    foreach key in l
        result[key] = l[key];
    return result;
}

skill [int] listCopy(skill [int] l)
{
    skill [int] result;
    foreach key in l
        result[key] = l[key];
    return result;
}

boolean [monster] listCopy(boolean [monster] l)
{
    boolean [monster] result;
    foreach key in l
        result[key] = l[key];
    return result;
}

int [item] listCopy(int [item] l)
{
    int [item] result;
    foreach key in l
        result[key] = l[key];
    return result;
}

//Strict, in this case, means the keys start at 0, and go up by one per entry. This allows easy consistent access
boolean listKeysMeetStrictRequirements(string [int] list)
{
    int expected_value = 0;
    foreach key in list
    {
        if (key != expected_value)
            return false;
        expected_value += 1;
    }
    return true;
}
string [int] listCopyStrictRequirements(string [int] list)
{
    string [int] result;
    foreach key in list
        result.listAppend(list[key]);
    return result;
}

string [string] mapMake()
{
	string [string] result;
	return result;
}

string [string] mapMake(string key1, string value1)
{
	string [string] result;
	result[key1] = value1;
	return result;
}

string [string] mapMake(string key1, string value1, string key2, string value2)
{
	string [string] result;
	result[key1] = value1;
	result[key2] = value2;
	return result;
}

string [string] mapMake(string key1, string value1, string key2, string value2, string key3, string value3)
{
	string [string] result;
	result[key1] = value1;
	result[key2] = value2;
	result[key3] = value3;
	return result;
}

string [string] mapMake(string key1, string value1, string key2, string value2, string key3, string value3, string key4, string value4)
{
	string [string] result;
	result[key1] = value1;
	result[key2] = value2;
	result[key3] = value3;
	result[key4] = value4;
	return result;
}

string [string] mapMake(string key1, string value1, string key2, string value2, string key3, string value3, string key4, string value4, string key5, string value5)
{
	string [string] result;
	result[key1] = value1;
	result[key2] = value2;
	result[key3] = value3;
	result[key4] = value4;
	result[key5] = value5;
	return result;
}


string [string] mapMake(string key1, string value1, string key2, string value2, string key3, string value3, string key4, string value4, string key5, string value5, string key6, string value6)
{
	string [string] result;
	result[key1] = value1;
	result[key2] = value2;
	result[key3] = value3;
	result[key4] = value4;
	result[key5] = value5;
	result[key6] = value6;
	return result;
}

string [string] mapCopy(string [string] map)
{
    string [string] result;
    foreach key in map
        result[key] = map[key];
    return result;
}

boolean mapsAreEqual(string [string] map1, string [string] map2)
{
	if (map1.count() != map2.count())
	{
        //print_html("map1.c = " + map1.count() + " which is not " + map2.count());
		return false;
    }
	foreach key1, v in map1
	{
		if (!(map2 contains key1))
        {
        	//print_html("map2 lacks " + key1);
        	return false;
        }
        if (map2[key1] != v)
        {
            //print_html("map2 v(" + map2[key1] + " does not equal " + key1 + " (" + v + ")");
        	return false;
        }
	}
	return true;
}

boolean [string] listInvert(string [int] list)
{
	boolean [string] result;
	foreach key in list
	{
		result[list[key]] = true;
	}
	return result;
}


boolean [int] listInvert(int [int] list)
{
	boolean [int] result;
	foreach key in list
	{
		result[list[key]] = true;
	}
	return result;
}

boolean [location] listInvert(location [int] list)
{
	boolean [location] result;
	foreach key in list
	{
		result[list[key]] = true;
	}
	return result;
}

boolean [item] listInvert(item [int] list)
{
	boolean [item] result;
	foreach key in list
	{
		result[list[key]] = true;
	}
	return result;
}

boolean [monster] listInvert(monster [int] list)
{
	boolean [monster] result;
	foreach key in list
	{
		result[list[key]] = true;
	}
	return result;
}

boolean [familiar] listInvert(familiar [int] list)
{
	boolean [familiar] result;
	foreach key in list
	{
		result[list[key]] = true;
	}
	return result;
}

int [int] listConvertToInt(string [int] list)
{
	int [int] result;
	foreach key in list
		result[key] = list[key].to_int();
	return result;
}

item [int] listConvertToItem(string [int] list)
{
	item [int] result;
	foreach key in list
		result[key] = list[key].to_item();
	return result;
}

string listFirstObject(string [int] list)
{
    foreach key in list
        return list[key];
    return "";
}

//(I'm assuming maps have a consistent enumeration order, which may not be the case)
int listKeyForIndex(string [int] list, int index)
{
	int i = 0;
	foreach key in list
	{
		if (i == index)
			return key;
		i += 1;
	}
	return -1;
}

int listKeyForIndex(location [int] list, int index)
{
	int i = 0;
	foreach key in list
	{
		if (i == index)
			return key;
		i += 1;
	}
	return -1;
}

int listKeyForIndex(familiar [int] list, int index)
{
	int i = 0;
	foreach key in list
	{
		if (i == index)
			return key;
		i += 1;
	}
	return -1;
}

int listKeyForIndex(item [int] list, int index)
{
	int i = 0;
	foreach key in list
	{
		if (i == index)
			return key;
		i += 1;
	}
	return -1;
}

int listKeyForIndex(monster [int] list, int index)
{
	int i = 0;
	foreach key in list
	{
		if (i == index)
			return key;
		i += 1;
	}
	return -1;
}

int listKeyForIndex(int [int] list, int index)
{
    int i = 0;
    foreach key in list
    {
        if (i == index)
            return key;
        i += 1;
    }
    return -1;
}

int llistKeyForIndex(string [int][int] list, int index)
{
	int i = 0;
	foreach key in list
	{
		if (i == index)
			return key;
		i += 1;
	}
	return -1;
}

string listGetRandomObject(string [int] list)
{
    if (list.count() == 0)
        return "";
    if (list.count() == 1)
    	return list[listKeyForIndex(list, 0)];
    return list[listKeyForIndex(list, random(list.count()))];
}

item listGetRandomObject(item [int] list)
{
    if (list.count() == 0)
        return $item[none];
    if (list.count() == 1)
    	return list[listKeyForIndex(list, 0)];
    return list[listKeyForIndex(list, random(list.count()))];
}

location listGetRandomObject(location [int] list)
{
    if (list.count() == 0)
        return $location[none];
    if (list.count() == 1)
    	return list[listKeyForIndex(list, 0)];
    return list[listKeyForIndex(list, random(list.count()))];
}

familiar listGetRandomObject(familiar [int] list)
{
    if (list.count() == 0)
        return $familiar[none];
    if (list.count() == 1)
    	return list[listKeyForIndex(list, 0)];
    return list[listKeyForIndex(list, random(list.count()))];
}

monster listGetRandomObject(monster [int] list)
{
    if (list.count() == 0)
        return $monster[none];
    if (list.count() == 1)
    	return list[listKeyForIndex(list, 0)];
    return list[listKeyForIndex(list, random(list.count()))];
}

int listGetRandomObject(int [int] list)
{
    if (list.count() == 0)
        return -1;
    if (list.count() == 1)
        return list[listKeyForIndex(list, 0)];
    return list[listKeyForIndex(list, random(list.count()))];
}


boolean listContainsValue(monster [int] list, monster vo)
{
    foreach key, v2 in list
    {
        if (v2 == vo)
            return true;
    }
    return false;
}

string [int] listInvert(boolean [string] list)
{
    string [int] out;
    foreach m, value in list
    {
        if (value)
            out.listAppend(m);
    }
    return out;
}

int [int] listInvert(boolean [int] list)
{
    int [int] out;
    foreach m, value in list
    {
        if (value)
            out.listAppend(m);
    }
    return out;
}

skill [int] listInvert(boolean [skill] list)
{
    skill [int] out;
    foreach m, value in list
    {
        if (value)
            out.listAppend(m);
    }
    return out;
}

monster [int] listInvert(boolean [monster] monsters)
{
    monster [int] out;
    foreach m, value in monsters
    {
        if (value)
            out.listAppend(m);
    }
    return out;
}

location [int] listInvert(boolean [location] list)
{
    location [int] out;
    foreach k, value in list
    {
        if (value)
            out.listAppend(k);
    }
    return out;
}

familiar [int] listInvert(boolean [familiar] list)
{
    familiar [int] out;
    foreach k, value in list
    {
        if (value)
            out.listAppend(k);
    }
    return out;
}

item [int] listInvert(boolean [item] list)
{
    item [int] out;
    foreach k, value in list
    {
        if (value)
            out.listAppend(k);
    }
    return out;
}

skill [int] listConvertStringsToSkills(string [int] list)
{
    skill [int] out;
    foreach key, s in list
    {
        out.listAppend(s.to_skill());
    }
    return out;
}

monster [int] listConvertStringsToMonsters(string [int] list)
{
    monster [int] out;
    foreach key, s in list
    {
        out.listAppend(s.to_monster());
    }
    return out;
}

int [int] stringToIntIntList(string input, string delimiter)
{
	int [int] out;
	if (input == "")
		return out;
	foreach key, v in input.split_string(delimiter)
	{
		if (v == "") continue;
		out.listAppend(v.to_int());
	}
	return out;
}

int [int] stringToIntIntList(string input)
{
	return stringToIntIntList(input, ",");
}


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
		foreach it, amount in delta_state.inventory
		{
			if (!show_negatives && amount <= 0) continue;
			print((amount > 0 ? "+" : "") + amount + " " + it);
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

string __comb_beach_version = "2.0.7";


int [int] __most_recent_gameday_visited_for_minute_archive;


boolean [int] __beach_comb_spade_these_please;
int [int] __beach_comb_spade_these_please_linear;
string [int] __beach_comb_datafile_targeted_coordinates;

boolean __setting_linear_search_on = false; //only works in the context of spading directives
boolean __setting_skip_sandcastles = true; //we skip these because I don't think there's a benefit to them, and we want humans to have the pleasure of smashing someone else's hard work for themselves
boolean __setting_do_full_pass_over_minutes = true;

boolean __setting_output_spading_data = get_property("ezandoraCombBeachWriteSpadingInformation").to_boolean(); //do not enable this unless you want megabytes of HTML written to your session log

boolean __setting_spade_all_left = false;
boolean __setting_use_targeted_coordinates = false;
boolean __setting_experiment = false;
boolean __stop_now = false;
boolean __setting_only_complete_free_combs = false;

buffer visit_url_retry(string url, boolean a, boolean b)
{
	buffer page_text;
	int breakout = 10;
	while (page_text.length() == 0 && breakout > 0)
	{
		breakout -= 1;
		page_text = visit_url(url, a, b);
		if (page_text.length() == 0)
		{
			print(url + " didn't load, retrying...", "red");
			wait(30);
		}
	}
	return page_text;
}

buffer visit_url_retry(string url)
{
	return visit_url_retry(url, true, false);
}

void readArchive()
{
	file_to_map("comb_beach_visit_history.txt", __most_recent_gameday_visited_for_minute_archive);
	file_to_map("beach_comb_targeted_coordinates.txt", __beach_comb_datafile_targeted_coordinates);
	if (__setting_spade_all_left)
	{
		if (true)
			file_to_map("beach_comb_all_spade_these_please.txt", __beach_comb_spade_these_please);
		else
			file_to_map("beach_comb_spade_these_please.txt", __beach_comb_spade_these_please);
		if (__beach_comb_spade_these_please.count() <= my_adventures() && __beach_comb_spade_these_please.count() > 0)
			__setting_linear_search_on = true;
		foreach minute in __beach_comb_spade_these_please
			__beach_comb_spade_these_please_linear[__beach_comb_spade_these_please_linear.count()] = minute;
	}
}

void writeArchive()
{
	if (__most_recent_gameday_visited_for_minute_archive.count() == 0) return;
	map_to_file(__most_recent_gameday_visited_for_minute_archive, "comb_beach_visit_history.txt");
}

int daysSinceEncounteringMinute(int today, int minute)
{
	int days_since_encountering_minute = 96;
	if (__most_recent_gameday_visited_for_minute_archive contains minute)
	{
		days_since_encountering_minute = today - __most_recent_gameday_visited_for_minute_archive[minute];
		if (days_since_encountering_minute < 0) days_since_encountering_minute += 96;
		//clamp:
		if (days_since_encountering_minute < 0) days_since_encountering_minute = 96;
		if (days_since_encountering_minute > 96) days_since_encountering_minute = 96;
	}
	return days_since_encountering_minute;
}

int convertRawCoordinateToMinutes(string coordinate_raw)
{
	string y_coordinate_raw = coordinate_raw.split_string(",")[1];
	if (y_coordinate_raw == "") return -1;
	int y_coordinate = y_coordinate_raw.to_int();
	
	if (y_coordinate % 10 == 0)
		return y_coordinate / 10;
	else
		return ceil(to_float(y_coordinate) / 10.0);
}

int __pnm_last_spading_directive_index_tried = -1;
int pickNextMinute()
{
	int chosen_minute = -1;
	
	if (__setting_linear_search_on && __beach_comb_spade_these_please_linear.count() > 0)
	{
		__pnm_last_spading_directive_index_tried += 1;
		if (__pnm_last_spading_directive_index_tried >= __beach_comb_spade_these_please_linear.count())
		{
			print("Reached end, stopping...");
			__stop_now = true;
			return -1;
		}
		return __beach_comb_spade_these_please_linear[__pnm_last_spading_directive_index_tried];
	}
	
	if (__setting_use_targeted_coordinates && __beach_comb_datafile_targeted_coordinates.count() > 0)
	{
		int current_coordinate_index = get_property("ezandora_comb_beach_next_targeted_coordinate").to_int();
		if (current_coordinate_index >= __beach_comb_datafile_targeted_coordinates.count())
		{
			current_coordinate_index = 0;
			set_property("ezandora_comb_beach_next_targeted_coordinate", current_coordinate_index);
			print("reached wraparound point for targeted coordinates, stopping...");
			exit;
			//abort("reached wraparound point for targeted coordinates");
		}
		string coordinate_raw = __beach_comb_datafile_targeted_coordinates[current_coordinate_index];
		chosen_minute = convertRawCoordinateToMinutes(coordinate_raw);
		if (chosen_minute >= 0 && chosen_minute <= 10000) return chosen_minute;
	}
	
	if (__setting_do_full_pass_over_minutes && get_property("ezandora_comb_beach_next_full_pass_minute").to_int() < 10001 && my_id() == 1557284)
	{
		chosen_minute = get_property("ezandora_comb_beach_next_full_pass_minute").to_int();
		set_property("ezandora_comb_beach_next_full_pass_minute", chosen_minute + 1);
		return chosen_minute;
	}
	
	//Use __most_recent_gameday_visited_for_minute_archive, pick a minute we haven't visited in a while.
	//Inefficient and slow:
	int today = gameday_to_int();
	int maximum_days_observed = 0;
	//Scan for the most days observed:
	for minute from 1 to 10000
	{
		if (__beach_comb_spade_these_please.count() > 0 && !(__beach_comb_spade_these_please contains minute)) continue;
		int days_since_encountering_minute = daysSinceEncounteringMinute(today, minute);
		if (days_since_encountering_minute > maximum_days_observed)
			maximum_days_observed = days_since_encountering_minute;
		if (maximum_days_observed >= 96)
			break;
	}
	//Find all minutes that match the maximum day:
	int [int] possible_minutes;
	for minute from 1 to 10000
	{
		if (__beach_comb_spade_these_please.count() > 0 && !(__beach_comb_spade_these_please contains minute)) continue;
		int days_since_encountering_minute = daysSinceEncounteringMinute(today, minute);
		if (days_since_encountering_minute >= maximum_days_observed)
			possible_minutes[possible_minutes.count()] = minute;
	}
	
	if (possible_minutes.count() > 0)
	{
		return possible_minutes.listGetRandomObject();
	}
	//algorithm broke, use fallback:
	print("Next minute algorithm broke, picking random...", "red");
	return random(10000) + 1;
}
boolean __output_final_message_bottle = false;
buffer iteration(buffer last_page_text)
{
	buffer page_text = last_page_text;
	if (!page_text.contains_text("Comb the Beach"))
	{
		print("No comb...?", "red");
		__stop_now = true;
		return page_text;
	}
	if (page_text.contains_text("You grab your comb"))
	{
		if (__setting_only_complete_free_combs && !page_text.contains_text("free walks down the beach left today") && !page_text.contains_text("free walk down the beach left today"))
		{
			__stop_now = true;
			return page_text;
		}
		int chosen_minute = pickNextMinute();
		if (chosen_minute < 0)
			return page_text;
		page_text = visit_url_retry("choice.php?whichchoice=1388&option=1&minutes=" + chosen_minute);
	}
	
	string current_minutes_as_string = page_text.group_string("You walk for ([0123456789,]+) ")[0][1];
	if (__setting_output_spading_data)
		logprint("COMB_BEACH_SAVED_LAYOUT_1•" + page_text);
	int current_minutes = current_minutes_as_string.replace_string(",", "").to_string().to_int();
	if (current_minutes_as_string != "")
	{
		__most_recent_gameday_visited_for_minute_archive[current_minutes] = gameday_to_int();
		writeArchive();
	}
	if (current_minutes_as_string == "")
	{
		abort("Parse error with minutes.");
	}
	
	string [int][int] matches_1 = page_text.group_string("<button(.*?)</button>");
	
	string [int] eligible_twinkling_coordinates;
	string [int] eligible_simple_coordinates;
	string [int] eligible_complex_coordinates;
	string [int] eligible_extremely_interesting_coordinates;
	string [int] eligible_combed_coordinates;
	string [int] eligible_1_coordinates;
	string [int] eligible_slightly_better_coordinates;
	string [string] coordinate_mapping;
	foreach key in matches_1
	{
		string line = matches_1[key][1];
		string coordinate = line.group_string("value=\"(.*?)\"")[0][1];
		string alt = line.group_string("alt=\"(.*?)\"")[0][1];
		
		coordinate_mapping[coordinate] = alt;
		
		
		if (coordinate.contains_text("1,") && alt == "rough sand" && get_property("ezandoraCombBeach1CoordinatesForSpading").to_boolean())
		{
			eligible_1_coordinates[eligible_1_coordinates.count()] = coordinate;
		}
		else if (alt == "rough sand")
		{
			eligible_simple_coordinates[eligible_simple_coordinates.count()] = coordinate;
		}
		else if (alt == "combed sand")
		{
			eligible_combed_coordinates[eligible_combed_coordinates.count()] = coordinate;
		}
		else if (alt == "a beach head")
		{
			//ignore, doesn't give items
		}
		else if (alt == "rough sand with a twinkle")
		{
			eligible_twinkling_coordinates[eligible_twinkling_coordinates.count()] = coordinate;
		}
		else
		{
			print("Interesting: " + alt, "red");
			if (!(__setting_skip_sandcastles && alt == "a sand castle"))
				eligible_complex_coordinates[eligible_complex_coordinates.count()] = coordinate;
			if (alt != "a sand castle")
			{
				eligible_extremely_interesting_coordinates[eligible_extremely_interesting_coordinates.count()] = coordinate;
				print("Extremely interesting.", "purple");
			}
		}
		
		
	}
	string target_coordinate;
	if (eligible_extremely_interesting_coordinates.count() > 0)
	{
		target_coordinate = eligible_extremely_interesting_coordinates.listGetRandomObject();
	}
	else if (eligible_complex_coordinates.count() > 0)
	{
		target_coordinate = eligible_complex_coordinates.listGetRandomObject();
	}
	else if (eligible_twinkling_coordinates.count() > 0)
	{
		target_coordinate = eligible_twinkling_coordinates.listGetRandomObject();
	}
	else if (eligible_1_coordinates.count() > 0)
	{
		target_coordinate = eligible_1_coordinates.listGetRandomObject();
	}
	else if (eligible_slightly_better_coordinates.count() > 0)
	{
		target_coordinate = eligible_slightly_better_coordinates.listGetRandomObject();
	}
	else if (eligible_simple_coordinates.count() > 0)
	{
		target_coordinate = eligible_simple_coordinates.listGetRandomObject();
	}
	else if (eligible_combed_coordinates.count() > 0)
	{
		target_coordinate = eligible_combed_coordinates.listGetRandomObject();
	}
	else
		abort("Nothing to click on...?");
		
		
	if (__setting_use_targeted_coordinates && __beach_comb_datafile_targeted_coordinates.count() > 0)
	{
		int current_coordinate_index = get_property("ezandora_comb_beach_next_targeted_coordinate").to_int();
		string raw = __beach_comb_datafile_targeted_coordinates[current_coordinate_index];
		
		set_property("ezandora_comb_beach_next_targeted_coordinate", current_coordinate_index + 1);
		
		if (coordinate_mapping[raw] != "combed sand" && coordinate_mapping[raw] != "")
			target_coordinate = raw;
		else
			print("Skipping target coordinate " + raw + " because it's " + coordinate_mapping[raw]);
	}
		
	
	int previous_pearl_count = $item[rainbow pearl].item_amount();
	string option_text = coordinate_mapping[target_coordinate];
	if (option_text == "")
		abort("bad option text, what?");
	print("Visiting " + current_minutes + "•" + target_coordinate + "•" + option_text);
	buffer page_text_2 = visit_url_retry("choice.php?whichchoice=1388&option=4&coords=" + target_coordinate);
	if (__setting_output_spading_data)
		logprint("COMB_BEACH_SAVED_COMB_RESULTS_1•" + current_minutes + "•" + target_coordinate + "•" + option_text + "•" + page_text_2);
		
	if (page_text_2.contains_text("message"))
	{
		print("We found a message in the bottle! Here's the HTML, (written to your session log) post it on the forums or tell someone about it:", "red");
		print(page_text_2, "red");
		__output_final_message_bottle = true;
	}
	if ($item[rainbow pearl].item_amount() > previous_pearl_count)
	{
		print("We found a rainbow pearl? Here's the HTML, (written to your session log) post it on the forums or tell someone about it:", "red");
		print(page_text_2, "red");
		__output_final_message_bottle = true;
	}
	return page_text_2;
}

void outputHelp()
{
	print_html("Commands:");
	print_html("<b>free</b>: only use free combs");
	print_html("<b>all</b> / <b>farm</b>: spend all adventures");
	print_html("<b>[number]</b>: spend X adventures");
	print_html("");
	print_html("Examples:");
	print_html("<b>CombBeach free</b>: free combings only");
	print_html("<b>CombBeach all</b>: farming");
}

void main(string arguments)
{
	print("CombBeach v" + __comb_beach_version);
	FarmingLogStart();
	
	int adventures_to_use = 100000;
	foreach key, argument in arguments.split_string(" ")
	{
		if (argument == "") continue;
		if (argument == "free")
		{
			__setting_only_complete_free_combs = true;
		}
		if (argument == "all" || argument == "spadeall" || argument == "farm")
		{
			__setting_only_complete_free_combs = false;
			adventures_to_use = 100000;
		}
		if (is_integer(argument))
		{
			__setting_only_complete_free_combs = false;
			adventures_to_use = argument.to_int();
		}
		if (argument == "spadeall")
		{
			__setting_spade_all_left = true;
		}
		if (argument == "target" || argument == "targeted" || argument == "specific")
		{
			__setting_use_targeted_coordinates = true;
		}
		if (argument == "experiment")
		{
			__setting_experiment = true;
		}
		if (argument == "help")
		{
			outputHelp();
			return;
		}
	}
	if (arguments == "")
	{
		outputHelp();
		return;
	}
	
	readArchive();
	
	
	visit_url_retry("main.php?comb=1", false, false);
	buffer last_page_text = visit_url_retry("choice.php");
	
	int starting_turncount = my_turncount();
	int attempts_allowed = 1111;
	while (my_adventures() > 0 && attempts_allowed > 0 && my_turncount() - starting_turncount < adventures_to_use)
	{
		attempts_allowed -= 1;
		last_page_text = iteration(last_page_text);
		if (__stop_now)
		{
			break;
		}
	}
	visit_url_retry("choice.php?whichchoice=1388&option=5");
	FarmingLogOutputDelta();
	if (__output_final_message_bottle)
		print("You found something interesting! Go look for it in your session log and post it somewhere.", "red");
	print("Have a nice day."); //thank you
}