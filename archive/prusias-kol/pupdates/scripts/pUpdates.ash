script "pUpdates";
notify Coolfood;

void pInitUpdates(string script);
void pAddUpdate(string script, string update);
void pCheckUpdate(string script);

string filePrefix = "data/pUpdates/prusias_pUpdates_";

void goldHTMLprint(string text) {
    print_html("<font color=eda800>" + text + "</font>");
}

void printHelp(){
    goldHTMLprint("<b>Welcome to pUpdates Updates Library/b>");
    print_html("<b>init (scriptname)</b> - Initializes pUpdates to work with a script. Must be run before any other functions will work.");
    print("scriptname must have no spaces", "red");
    print_html("<b>add (scriptname) (update)</b> - Adds update to scriptname. Update can include spaces");
    print_html("<b>check (scriptname)</b> - Lists new updates if there are new updates for specified script.");
    print("Will not print anything if there are no new updates.");
    
}

void main(string option) {
    string [int] commands = option.split_string("\\s+");
    for(int i = 0; i < commands.count(); ++i){
        switch(commands[i]){
            case "check":
                if(i + 1 < commands.count())
                {
                    i+=1;
                    pCheckUpdate(commands[i]);
                } else {
                    print("Please provide a script name", "red");
                }
                return;
            case "add":
                if(i + 2 < commands.count())
                {
                    i+=1;
                    string script = commands[i];
                    i+=1;
                    string update = "";
                    while (i < commands.count()) {
                        update += commands[i] + " ";
                        i+=1;
                    }
                    pAddUpdate(script, update);
                } else {
                    print("Please provide a script name and update", "red");
                }
                return;
            case "init":
                if(i + 1 < commands.count())
                {
                    i+=1;
                    pInitUpdates(commands[i]);
                } else {
                    print("Please provide a script name", "red");
                }
                return;
            default:
                printHelp();
                return;
        }
    }
}

void pInitUpdates(string script) {

    string fileName = filePrefix + script + ".txt";
    string[int] updates;
    updates[-1] = "" + 0;
    updates[0] = "pUpdates for " + script + " are now installed";
    if (map_to_file(updates, fileName))
        print("pUpdate successfully initialized.", "teal");
    else
        print("Error, file was not saved.");
}

void pAddUpdate(string script, string update) {
    
    string fileName = filePrefix + script + ".txt";
    string[int] updates;
    file_to_map(fileName, updates);
    int version = updates[-1].to_int() + 1;
    updates[-1] = "" + version;
    updates[version] = update;
    if (map_to_file(updates, fileName))
        print("new update successfully saved.", "teal");
    else
        print("Error, file was not saved.");
}

void pCheckUpdate(string script) {
    string property = "prusias_pUpdates_" + script + "_localVersion";
    //initialize
    if (get_property(property) == "")
        set_property(property, "-1");
    //get data
    string fileName = filePrefix + script + ".txt";
    string[int] updates;
    file_to_map(fileName, updates);
    int version = updates[-1].to_int();
    //print updates
    if (get_property(property).to_int() != version) {
        print_html("<font color=eda800><b>----" + script + "'s latest updates----</b></font>");
        int lastUpdated = get_property(property).to_int();
        for i from (lastUpdated+1) to (version) {
            print_html(i + " - " + updates[i]);
        }
        print_html("<font color=eda800>---------------</font>");
        set_property(property, version);
    }
}
