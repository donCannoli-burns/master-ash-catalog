
string __setting_file_base_path = "Quest Log History/Quest Log ";

string shrinkQuestLog(string html)
{
    int body_position = html.index_of("<body>");
    if (body_position != -1)
        return html.substring(body_position);
    return html;
}

void main()
{
	if (!get_property("__savequestlog_autorun").to_boolean())
	{
		print("To enable:");
		print("set __savequestlog_autorun=true");
	}
	
	string [string] records;
	//file_to_map(__setting_file_name, records);
	
	string quest_log_2 = shrinkQuestLog(visit_url("questlog.php?which=2"));
	string quest_log_1 = shrinkQuestLog(visit_url("questlog.php?which=1"));
	
	records["ascension"] = my_ascensions();
	records["turn"] = my_turncount();
	records["quest log 1"] = quest_log_1;
	records["quest log 2"] = quest_log_2;
	
	string file_name = __setting_file_base_path;
	
	int quest_log_count = get_property("savequestlog_last_log_saved").to_int() + 1;
	set_property("savequestlog_last_log_saved", quest_log_count);
	
	file_name += quest_log_count;
	file_name += ".txt";
	
	map_to_file(records, file_name, false);
	
	/*string [int,int,int,string] records;
	file_to_map(__setting_file_name, records);
	
	string quest_log_2 = shrinkQuestLog(visit_url("questlog.php?which=2"));
	string quest_log_1 = shrinkQuestLog(visit_url("questlog.php?which=1"));
	
	string [int,int,string] line;
	
	line[my_ascensions(),my_turncount(), quest_log_1] = quest_log_2;
	
	records[records.count()] = line;
	
	map_to_file(records, __setting_file_name, false);*/
}