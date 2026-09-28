//c2t choices ook
//c2t

void main (int id,string page) {
	string [int] choices = available_choice_options(true);
	int num = 0;
	buffer buf;

	switch (id) {
		//Ook the Mook
		case 954:
			//tracking progress of the choice adventure chain
			//stage 0: go to first time
			//stage 1: teach paper
			//stage 2: teach scissors
			//stage 3: play RPS
			//stage 4: RPS won; Dan available to fight at A Cave
			if (get_property("c2t_ttt_ookTheMookCurrentAscension").to_int() < my_ascensions()
				|| get_property("c2t_ttt_ookTheMookStage").to_int() >= 4
			) {
				set_property("c2t_ttt_ookTheMookStage","0");
				set_property("c2t_ttt_ookTheMookCurrentAscension",my_ascensions());
			}

			run_choice(1);//ask about password
			switch (get_property("c2t_ttt_ookTheMookStage").to_int()) {
				//game of chance
				default:
				case 0:
				case 3:
					print("Ook: playing RPS");
					run_choice(2);//game of chance
					//self-correcting
					foreach i,x in available_choice_options()
						if (x == "Paper" || x == "Scissors")
							num++;
					if (num == 2)
						set_property("c2t_ttt_ookTheMookStage","3");
					else
						set_property("c2t_ttt_ookTheMookStage",1+num);

					//play RPS
					if (get_property("c2t_ttt_ookTheMookStage").to_int() > 1) {
						buf = run_choice(random(3)+1);
						while (available_choice_options()[1] == "Ugh, fine.") {
							print("Ook: didn't win RPS, but will play again");
							run_choice(1);
							buf = run_choice(random(3)+1);
						}
						if (buf.contains_text("swordfish")) {
							print("Ook: won RPS; Cavaman Dan available to fight");
							set_property("c2t_ttt_ookTheMookStage","4");
						}
						else
							print("Ook: need to teach paper or scissors");
					}
					else {
						run_choice(1);//pick rock
						run_choice(2);//leave
						print("Ook: need to teach paper and scissors");
					}
					break;
				//teach paper and scissors
				case 1:
				case 2:
					print("Ook: teaching paper or scissors");
					run_choice(1);//offer trade
					//self-correcting
					if (!(available_choice_options() contains 3))
						set_property("c2t_ttt_ookTheMookStage","2");
					if (available_choice_options() contains 2) {
						run_choice(2);//teach paper or scissors
						set_property("c2t_ttt_ookTheMookStage",get_property("c2t_ttt_ookTheMookStage").to_int()+1);
					}
					else {//something broke? only fire to teach
						print("Ook: only fire was available to teach; should do RPS next");
						run_choice(1);
						set_property("c2t_ttt_ookTheMookStage","3");
					}
					break;
			}
			break;

		//Time Cave. Period.
		//1: fight adventurer echo
		//2: get twitching time capsule
		//3: ook the mook
		case 955:
			if (choices contains 3)
				run_choice(3);
			break;
	}
}

