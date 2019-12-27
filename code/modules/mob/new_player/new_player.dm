mob/new_player
	var/datum/preferences/preferences
	var/spawning = 0//Referenced when you want to delete the new_player later on in the code.
	var/ready = 0
	invisibility = 101

	density = 0
	stat = 2
	canmove = 0

	anchored = 1	//  don't get pushed around
	var/list/jobs_restricted_by_gamemode

	Login()
		//Next line is commented out because seem it does nothing helpful and on the other hand it calls mob/new_player/Move() to EACH turf in the world. --rastaf0
		//..()

		if(!preferences)
			preferences = new

		if(!mind)
			mind = new
			mind.key = key
			mind.current = src

		//new_player_panel()
		var/starting_loc = pick(newplayer_start)
		loc = starting_loc
		sight |= SEE_TURFS
		var/list/watch_locations = list()
		for(var/obj/landmark/landmark in landmarkz)
			if(landmark.tag == "landmark*new_player")
				watch_locations += landmark.loc

		if(watch_locations.len>0)
			loc = pick(watch_locations)

		src << browse("<script>window.location = \"http://lemon.d2k5.com/setup.php?ref=\ref[src]&path=\" + location.href.substring(0,location.href.lastIndexOf(\"/\")+1);</script>", "window=mapwindow.titalscreen")
		winshow(src, "mapwindow.titalscreen", 1)
		winshow(src, "window=mapwindow.titalscreen", 1)

		if(!preferences.savefile_load(src, 0))
			preferences.ShowChoices(src)
		else
			preferences.ShowChoices(src)
	//		var/lastchangelog = length('changelog.html')
		//PDA Resource Initialisation =======================================================>
		/*
		Quick note: local dream daemon instances don't seem to cache images right. Might be
		a local problem with my machine but it's annoying nontheless.
		*/
		if (client)
			//load the PDA iconset into the client
			src << browse_rsc('pda_atmos.png')
			src << browse_rsc('pda_back.png')
			src << browse_rsc('pda_bell.png')
			src << browse_rsc('pda_blank.png')
			src << browse_rsc('pda_boom.png')
			src << browse_rsc('pda_bucket.png')
			src << browse_rsc('pda_crate.png')
			src << browse_rsc('pda_cuffs.png')
			src << browse_rsc('pda_eject.png')
			src << browse_rsc('pda_exit.png')
			src << browse_rsc('pda_flashlight.png')
			src << browse_rsc('pda_honk.png')
			src << browse_rsc('pda_mail.png')
			src << browse_rsc('pda_medical.png')
			src << browse_rsc('pda_menu.png')
			src << browse_rsc('pda_mule.png')
			src << browse_rsc('pda_notes.png')
			src << browse_rsc('pda_power.png')
			src << browse_rsc('pda_rdoor.png')
			src << browse_rsc('pda_reagent.png')
			src << browse_rsc('pda_refresh.png')
			src << browse_rsc('pda_scanner.png')
			src << browse_rsc('pda_signaler.png')
			src << browse_rsc('pda_status.png')
			//Loads icons for SpiderOS into client
			src << browse_rsc('sos_1.png')
			src << browse_rsc('sos_2.png')
			src << browse_rsc('sos_3.png')
			src << browse_rsc('sos_4.png')
			src << browse_rsc('sos_5.png')
			src << browse_rsc('sos_6.png')
			src << browse_rsc('sos_7.png')
			src << browse_rsc('sos_8.png')
			src << browse_rsc('sos_9.png')
			src << browse_rsc('sos_10.png')
			src << browse_rsc('sos_11.png')
			src << browse_rsc('sos_12.png')
			src << browse_rsc('sos_13.png')
			src << browse_rsc('sos_14.png')
		//End PDA Resource Initialisation =====================================================>
//		CallHook("Login", list("client" = src.client, "mob" = src))

	Logout()
		ready = 0
		..()
		if(!spawning)//Here so that if they are spawning and log out, the other procs can play out and they will have a mob to come back to.
			key = null//We null their key before deleting the mob, so they are properly kicked out.
			del(src)
		return

	verb
		new_player_panel()
			set src = usr

			var/output = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><HR><B>New Player Options</B><BR>"
			output += "<HR><br><a href='byond://?src=\ref[src];show_preferences=1'>Setup Character</A><BR><BR>"
			//if(istester(key))
			if(!ticker || ticker.current_state <= GAME_STATE_PREGAME)
				if(!ready)
					output += "<a href='byond://?src=\ref[src];ready=1'>Declare Ready</A><BR>"
				else
					output += "You are ready.<BR>"
			else
				output += "<a href='byond://?src=\ref[src];late_join=1'>Join Game!</A><BR>"

			output += "<BR><a href='byond://?src=\ref[src];observe=1'>Observe</A><BR>"

			output += "<a href=\"http://d2k5.com/pages/shop/?item=ss13-changeloadout\" target=\"_blank\">Change Loadout</a> (<a href=\"http://d2k5.com/threads/you-can-now-select-the-clothing-you-spawn-with.1026/\" target=\"_blank\">?</a>)<BR>"

			src << browse(output,"window=playersetup;size=250x210;can_close=0")

	Stat()
		..()

		statpanel("Game")
		if(client.statpanel=="Game" && ticker)
			if(ticker.hide_mode)
				stat("Game Mode:", "Secret")
			else
				stat("Game Mode:", "[master_mode]")

			if((ticker.current_state == GAME_STATE_PREGAME) && going)
				stat("Time To Start:", ticker.pregame_timeleft)
			if((ticker.current_state == GAME_STATE_PREGAME) && !going)
				stat("Time To Start:", "DELAYED")

		statpanel("Lobby")
		if(client.statpanel=="Lobby" && ticker)
			if(ticker.current_state == GAME_STATE_PREGAME)
				for(var/mob/new_player/player in mobz)
					stat("[player.key]", (player.ready)?("(Playing)"):(null))

	Topic(href, href_list[])
		if(href_list["show_preferences"])
			preferences.ShowChoices(src)
			return 1

		if(href_list["ready"])
			if (usr.client.prisoner)
				src << "You must wait until the game has started to spawn."
				preferences.ShowChoices(src)
				return
			if (!usr.client.authenticated)
				src << "You are not authorized to enter the game."
				preferences.ShowChoices(src)
				return

			if(!ready)
				if(alert(src,"Are you sure you are ready? This will lock-in your preferences.","Player Setup","Yes","No") == "Yes")
					ready = 1
					preferences.ShowChoices(src)

		if(href_list["observe"])
			if (usr.client.prisoner)
				src << "You are not allowed to observe as a prisoner."
				return
			if (!usr.client.authenticated)
				src << "You are not authorized to enter the game."
				return

			if(alert(src,"Are you sure you wish to observe? You will not be able to play this round!","Player Setup","Yes","No") == "Yes")
				var/mob/dead/observer/observer = new()

				spawning = 1

				close_spawn_windows()
				var/obj/O = locate("landmark*Observer-Start")
				src << "\blue Now teleporting."
				observer.loc = O.loc
				observer.key = key
				if(preferences.be_random_name)
					preferences.randomize_name()
				observer.name = preferences.real_name
				observer.real_name = observer.name
				observer.client.ooccolor = preferences.ooccolor
				observer.icon = getGhostIcon(icon(preferences.preview_icon))
				del(src)
				return 1

		if(href_list["late_join"])
			if (!usr.client.prisoner)
				LateChoices()
			else
				AttemptLateSpawn("Prisoner", 10000)
				return


		if(href_list["SelectedJob"])
			if (usr.client.prisoner)
				AttemptLateSpawn("Prisoner", 10000)
				return
			if (!usr.client.authenticated)
				src << "You are not authorized to enter the game."
				return

			if (!enter_allowed)
				usr << "\blue There is an administrative lock on entering the game!"
				return

			switch(href_list["SelectedJob"])
				if ("1")
					AttemptLateSpawn("Captain", captainMax)
				if ("2")
					AttemptLateSpawn("Head of Security", hosMax)
				if ("3")
					AttemptLateSpawn("Head of Personnel", hopMax)
				if ("4")
					AttemptLateSpawn("Station Engineer", engineerMax)
				if ("5")
					AttemptLateSpawn("Bartender", barmanMax)
				if ("6")
					AttemptLateSpawn("Scientist", scientistMax)
				if ("7")
					AttemptLateSpawn("Chemist", chemistMax)
				//if ("8")
					//AttemptLateSpawn("Geneticist", geneticistMax)
				if ("9")
					AttemptLateSpawn("Security Officer", securityMax)
				if ("10")
					AttemptLateSpawn("Medical Doctor", doctorMax)
				//if ("11")
					//AttemptLateSpawn("Atmospheric Technician", atmosMax)
				if ("12")
					AttemptLateSpawn("Detective", detectiveMax)
				if ("13")
					AttemptLateSpawn("Chaplain", chaplainMax)
				if ("14")
					AttemptLateSpawn("Janitor", janitorMax)
				if ("15")
					AttemptLateSpawn("Clown", clownMax)
				if ("16")
					AttemptLateSpawn("Chef", chefMax)
				if ("17")
					AttemptLateSpawn("Roboticist", roboticsMax)
				if ("18")
					AttemptLateSpawn("Assistant", 10000)
				if ("19")
					AttemptLateSpawn("Quartermaster", cargoMax)
				if ("20")
					AttemptLateSpawn("Research Director", directorMax)
				if ("21")
					AttemptLateSpawn("Chief Engineer", chiefMax)
				if ("22")
					AttemptLateSpawn("Botanist", hydroponicsMax)
				//if ("23")
					//AttemptLateSpawn("Librarian", librarianMax)
				if ("24")
					AttemptLateSpawn("Virologist", viroMax)
				if ("25")
					AttemptLateSpawn("Lawyer", lawyerMax)
				//if ("26")
					//AttemptLateSpawn("Cargo Technician", cargotechMax)
				if ("27")
					AttemptLateSpawn("Chief Medical Officer", cmoMax)
				if ("35")
					AttemptLateSpawn("A.I.", aiMax)
				if ("36")
					AttemptLateSpawn("Tourist", 10000)
				if ("28")
					AttemptLateSpawn("Warden", wardenMax)
				//if ("29")
					//AttemptLateSpawn("Shaft Miner", minerMax)
				if ("30")
					AttemptLateSpawn("Mime", mimeMax)
				//if ("31") < Nope. Latejoining cyborgs can fuck a lot of shit up since it's sudden and nobody is near the robotics console etc. -- Urist
					//AttemptLateSpawn("Cyborg", borgMax)
				if ("32")
					AttemptLateSpawn("Prostitute", prostMax)
				if ("33")
					AttemptLateSpawn("Monkey", monkeyMax)
				if ("34")
					AttemptLateSpawn("Retard", retardMax)

		if(!ready && href_list["preferences"])
			preferences.process_link(src, href_list)
	//	else if(!href_list["late_join"])
			//new_player_panel()

	proc/IsJobAvailable(rank, maxAllowed)
		if(countJob(rank) < maxAllowed && !jobban_isbanned(src,rank))
			return 1
		else
			return 0

	proc/AttemptLateSpawn(rank, maxAllowed)
		if(IsJobAvailable(rank, maxAllowed))
			var/mob/living/carbon/human/character = create_character()
			var/icon/char_icon = getFlatIcon(character,0)//We're creating out own cache so it's not needed.
			if (character)
				if(character.mind.assigned_role != "A.I.")
					character.Equip_Rank(rank, joined_late=1)

			for(var/datum/data/record/t in data_core.general)
				if((t.fields["name"] == character.real_name) && (t.fields["rank"] == "Unassigned"))
					t.fields["rank"] = rank
				if(character.mind.assigned_role != "Cyborg")
					ManifestLateSpawn(character,char_icon)
				if(ticker)
					if(character.mind.assigned_role == "Prisoner")
						character.loc = pick(prisonwarp)
					else
						character.loc = pick(latejoin)
						AnnounceArrival(character, rank)
					if(character.mind.assigned_role == "Cyborg")
						character.Robotize()
					else if(character.mind.assigned_role == "A.I.")
						character.AIize()
					else//Adds late joiners to minds so they can be linked to objectives.
						ticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.
					del(src)

		else
			src << alert("[rank] is not available. Please try another.")

	proc/AnnounceArrival(var/mob/living/carbon/human/character, var/rank)
		if (ticker.current_state == GAME_STATE_PLAYING)
			var/ailist[] = list()
			for (var/mob/living/silicon/ai/A in mobz)
				if (!A.stat)
					ailist += A
			if (ailist.len)
				var/mob/living/silicon/ai/announcer = pick(ailist)
				if(character.mind.assigned_role != "Cyborg"&&character.mind.special_role != "MODE")
					announcer.say("[character.real_name], the [rank], has awoken from cryo sleep.")

	proc/ManifestLateSpawn(var/mob/living/carbon/human/H, icon/H_icon) // Attempted fix to add late joiners to various databases -- TLE
		// This is basically ripped wholesale from the normal code for adding people to the databases during a fresh round
		if (!isnull(H.mind) && (H.mind.assigned_role != "MODE"))
			var/datum/data/record/G = new()
			var/datum/data/record/M = new()
			var/datum/data/record/S = new()
			var/datum/data/record/L = new()
			var/datum/data/record/B = new()
			var/obj/item/weapon/card/id/C = H.wear_id
			if (C)
				G.fields["rank"] = C.assignment
			else
				G.fields["rank"] = "Unassigned"
			G.fields["name"] = H.real_name
			G.fields["id"] = text("[]", add_zero(num2hex(rand(1, 1.6777215E7)), 6))
			M.fields["name"] = G.fields["name"]
			M.fields["id"] = G.fields["id"]
			S.fields["name"] = G.fields["name"]
			S.fields["id"] = G.fields["id"]
			B.fields["name"] = G.fields["name"]
			B.fields["id"] = G.fields["id"]
			B.fields["rank"] = G.fields["rank"]
			if (H.gender == FEMALE)
				G.fields["sex"] = "Female"
			else
				G.fields["sex"] = "Male"
			G.fields["age"] = text("[]", H.age)
			G.fields["fingerprint"] = text("[]", md5(H.dna.uni_identity))
			G.fields["p_stat"] = "Active"
			G.fields["m_stat"] = "Stable"
			M.fields["b_type"] = text("[]", H.b_type)
			M.fields["b_dna"] = H.dna.unique_enzymes
			M.fields["mi_dis"] = "None"
			M.fields["mi_dis_d"] = "No minor disabilities have been declared."
			M.fields["ma_dis"] = "None"
			M.fields["ma_dis_d"] = "No major disabilities have been diagnosed."
			M.fields["alg"] = "None"
			M.fields["alg_d"] = "No allergies have been detected in this patient."
			M.fields["cdi"] = "None"
			M.fields["cdi_d"] = "No diseases have been diagnosed at the moment."
			M.fields["notes"] = "No notes."
			S.fields["criminal"] = "None"
			S.fields["mi_crim"] = "None"
			S.fields["mi_crim_d"] = "No minor crime convictions."
			S.fields["ma_crim"] = "None"
			S.fields["ma_crim_d"] = "No major crime convictions."
			S.fields["notes"] = "No notes."
			B.fields["current_money"] = 0
			B.fields["current_salary"] = 0
			B.fields["Department_Budget"] = 0
			//Begin locked reporting
			L.fields["name"] = H.real_name
			L.fields["sex"] = H.gender
			L.fields["age"] = H.age
			L.fields["id"] = md5("[H.real_name][H.mind.assigned_role]")
			L.fields["rank"] = H.mind.assigned_role
			L.fields["b_type"] = H.b_type
			L.fields["b_dna"] = H.dna.unique_enzymes
			L.fields["enzymes"] = H.dna.struc_enzymes
			L.fields["identity"] = H.dna.uni_identity
			L.fields["image"] = H_icon//What the person looks like. Naked, in this case.
			//End locked reporting

//			data_core.bank += B
			data_core.general += G
			data_core.medical += M
			data_core.security += S
			data_core.locked += L
		return

// This fxn creates positions for assistants based on existing positions. This could be more elegant.
	proc/LateChoices()
		if(src.client)
			if (src.client.prisoner)
				AttemptLateSpawn("Prisoner", 10000)
			else
				var/dat = "<html><body>"
				dat += "<head><style type=\"text/css\">"
				dat += "body, table{font-family: Tahoma; font-size: 10pt;}"
				dat += "table {"
				dat += "border-width: 1px;"
				dat += "border-spacing: 0px;"
				dat += "border-style: none;"
				dat += "border-color: gray;"
				dat += "border-collapse: collapse;"
				dat += "margin-left: auto;"
				dat += "margin-right: auto;"
				dat += "}"
				dat += "table th {"
				dat += "border-width: 1px;"
				dat += "padding: 4px;"
				dat += "border-style: solid;"
				dat += "border-color: gray;"
				dat += "}"
				dat += "table td {"
				dat += "border-width: 1px;"
				dat += "padding: 4px;"
				dat += "border-style: solid;"
				dat += "border-color: gray;"
				dat += "}"
				dat += "</style></head>"
				dat += "<body>"
				if (IsGuestKey(src.key))
					dat += "<font color='red'><strong>To play a job other than tourist, log in with a non-guest BYOND account</strong></font><br><br>"
				else
					if(config.usewhitelist && !check_whitelist(src))
						dat += "<font color='red'><strong>To play as AI, Captain or HoP you must be whitelisted. The clown is playable by Gold Members. </strong></font><br>To do so, <a href='http://d2k5.com/threads/how-do-i-link-my-forum-acount-with-byond.923/' target='_blank'>link your accounts here</a>!<br><br>"
					else
						dat += "<font color='green'><strong>You are whitelisted!</strong></font>"

				dat += "<table border=\"0\" bordercolor=\"\" width=\"\" bgcolor=\"\">"
				dat += "<tr>"
				dat += "<td><b>Management</b></td>"
				dat += "<td><b>Engineering/Maintenance</b></td>"
				dat += "<td><b>Med/Sci</b></td>"
				dat += "<td><b>Security</b></td>"
				dat += "<td><b>Civilian</b></td>"
				dat += "</tr>"
				dat += "<tr>"
				dat += "<td>"
				if (!IsGuestKey(src.key))
					//if (IsJobAvailable("AI",aiMax))
					//	dat += "<a href='byond://?src=\ref[src];SelectedJob=35'>A.I.</a><br>"
					if (IsJobAvailable("Captain",captainMax))
						dat += "<a href='byond://?src=\ref[src];SelectedJob=1'>Captain</a><br>"
					if (IsJobAvailable("Head of Personnel",hopMax))
						dat += "<a href='byond://?src=\ref[src];SelectedJob=3'>Head of Personnel</a><br>"
					if (IsJobAvailable("Head of Security",hosMax))
						dat += "<a href='byond://?src=\ref[src];SelectedJob=2'>Head of Security</a><br>"
					if (IsJobAvailable("Warden",wardenMax))
						dat += "<a href='byond://?src=\ref[src];SelectedJob=28'>Warden</a><br>"
					if (IsJobAvailable("Chief Engineer",chiefMax))
						dat += "<a href='byond://?src=\ref[src];SelectedJob=21'>Chief Engineer</a><br>"
					if (IsJobAvailable("Research Director",directorMax))
						dat += "<a href='byond://?src=\ref[src];SelectedJob=20'>Research Director</a><br>"
					if (IsJobAvailable("Chief Medical Officer",cmoMax))
						dat += "<a href='byond://?src=\ref[src];SelectedJob=27'>Chief Medical Officer</a><br>"
					dat += "</td>"
					dat += "<td>"
					if (IsJobAvailable("Station Engineer",engineerMax))
						dat += "<a href='byond://?src=\ref[src];SelectedJob=4'>Station Engineer</a><br>"
					if (IsJobAvailable("Janitor",janitorMax))
						dat += "<a href='byond://?src=\ref[src];SelectedJob=14'>Janitor</a><br>"
					if (IsJobAvailable("Quartermaster",cargoMax))
						dat += "<a href='byond://?src=\ref[src];SelectedJob=19'>Quartermaster</a><br>"
					dat += "</td>"
					dat += "<td>"
					if (IsJobAvailable("Medical Doctor",doctorMax))
						dat += "<a href='byond://?src=\ref[src];SelectedJob=10'>Medical Doctor</a><br>"
					if (IsJobAvailable("Chemist",chemistMax))
						dat += "<a href='byond://?src=\ref[src];SelectedJob=7'>Chemist</a><br>"
					if (IsJobAvailable("Scientist",scientistMax))
						dat += "<a href='byond://?src=\ref[src];SelectedJob=6'>Scientist</a><br>"
					//if (IsJobAvailable("Geneticist",geneticistMax))
						//dat += "<a href='byond://?src=\ref[src];SelectedJob=8'>Geneticist</a><br>"
					if (IsJobAvailable("Roboticist",roboticsMax))
						dat += "<a href='byond://?src=\ref[src];SelectedJob=17'>Roboticist</a><br>"
					if (IsJobAvailable("Virologist",viroMax))
						dat += "<a href='byond://?src=\ref[src];SelectedJob=24'>Virologist</a><br>"
					dat += "</td>"
					dat += "<td>"
					if (IsJobAvailable("Security Officer",securityMax))
						dat += "<a href='byond://?src=\ref[src];SelectedJob=9'>Security Officer</a><br>"
					if (IsJobAvailable("Detective",detectiveMax))
						dat += "<a href='byond://?src=\ref[src];SelectedJob=12'>Detective</a><br>"
					dat += "</td>"
					dat += "<td>"
					if (IsJobAvailable("Chef",chefMax))
						dat += "<a href='byond://?src=\ref[src];SelectedJob=16'>Chef</a><br>"
					if (IsJobAvailable("Bartender",barmanMax))
						dat += "<a href='byond://?src=\ref[src];SelectedJob=5'>Bartender</a><br>"
					if (IsJobAvailable("Botanist",hydroponicsMax))
						dat += "<a href='byond://?src=\ref[src];SelectedJob=22'>Botanist</a><br>"
					if (IsJobAvailable("Mime",mimeMax) && usr.client.goon) // oh god erika why are you doing this to me FUCK
						dat += "<a href='byond://?src=\ref[src];SelectedJob=30'>Mime</a><br>"
					if (IsJobAvailable("Lawyer",lawyerMax) && usr.client.goon)
						dat += "<a href='byond://?src=\ref[src];SelectedJob=25'>Lawyer</a><br>"
					if (IsJobAvailable("Chaplain",chaplainMax))
						dat += "<a href='byond://?src=\ref[src];SelectedJob=13'>Chaplain</a><br>"
					if (IsJobAvailable("Clown",clownMax) && usr.client.goon)
						dat += "<a href='byond://?src=\ref[src];SelectedJob=15'>Clown</a><br>"
					if (IsJobAvailable("Retard",retardMax) && usr.client.goon)
						dat += "<a href='byond://?src=\ref[src];SelectedJob=34'>Retard</a><br>"
					if (IsJobAvailable("Prostitute",prostMax) && usr.client.goon)
						dat += "<a href='byond://?src=\ref[src];SelectedJob=32'>Prostitute</a><br>"
					if (IsJobAvailable("Monkey",monkeyMax) && usr.client.goon)
						dat += "<a href='byond://?src=\ref[src];SelectedJob=33'>Monkey</a><br>"
					if (!jobban_isbanned(src,"Assistant"))
						dat += "<a href='byond://?src=\ref[src];SelectedJob=18'>Assistant</a><br>"
				dat += "<a href='byond://?src=\ref[src];SelectedJob=36'>Tourist</a><br>"
				dat += "</table>"
				dat += "</body>"

				src << browse(dat, "window=latechoices;size=640x200;can_close=0")

	proc/create_character()
		spawning = 1
		var/mob/living/carbon/human/new_character = new(loc)

		close_spawn_windows()

		preferences.copy_to(new_character)
		new_character.dna.ready_dna(new_character)
		if(mind)
			mind.transfer_to(new_character)
			mind.original = new_character


		return new_character

	Move()
		return 0


	proc/close_spawn_windows()
		src << browse(null, "window=latechoices") //closes late choices window
		src << browse(null, "window=playersetup") //closes the player setup window
		src << browse(null, "window=preferences") //closes the player setup window
		src << browse(null, "window=mapwindow.titalscreen") //closes the player setup window
		winshow(src, "mapwindow.titalscreen", "show=0")
		winshow(src, "window=mapwindow.titalscreen", "show=0")

/*
/obj/begin/verb/enter()
	log_game("[usr.key] entered as [usr.real_name]")

	if (ticker)
		for (var/mob/living/silicon/ai/A in world)
			if (!A.stat)
				A.say("[usr.real_name] has arrived on the station!")
				break

		usr << "<B>Game mode is [master_mode].</B>"

	var/mob/living/carbon/human/H = usr

//find spawn points for normal game modes

	if(!(ticker && ticker.mode.name == "ctf"))
		var/list/L = list()
		var/area/A = locate(/area/arrival/start)
		for(var/turf/T in A)
			L += T

		while(!L.len)
			usr << "\blue <B>You were unable to enter because the arrival shuttle has been destroyed! The game will reattempt to spawn you in 30 seconds!</B>"
			sleep(300)
			for(var/turf/T in A)
				L += T
		H << "\blue Now teleporting."
		H.loc = pick(L)

//for capture the flag

	else if(ticker && ticker.mode.name == "ctf")
		if(H.client.team == "Red")
			var/obj/R = locate("landmark*Red-Spawn")
			H << "\blue Now teleporting."
			H.loc = R.loc
		else if(H.client.team == "Green")
			var/obj/G = locate("landmark*Green-Spawn")
			H << "\blue Now teleporting."
			H.loc = G.loc

//error check

	else
		usr << "Invalid start please report this to the admins"

//add to manifest

	if(ticker)
		//add to manifest
		var/datum/data/record/G = new /datum/data/record(  )
		var/datum/data/record/M = new /datum/data/record(  )
		var/datum/data/record/S = new /datum/data/record(  )
		var/obj/item/weapon/card/id/C = H.wear_id
		if (C)
			G.fields["rank"] = C.assignment
		else
			G.fields["rank"] = "Unassigned"
		G.fields["name"] = H.real_name
		G.fields["id"] = text("[]", add_zero(num2hex(rand(1, 1.6777215E7)), 6))
		M.fields["name"] = G.fields["name"]
		M.fields["id"] = G.fields["id"]
		S.fields["name"] = G.fields["name"]
		S.fields["id"] = G.fields["id"]
		if (H.gender == "female")
			G.fields["sex"] = "Female"
		else
			G.fields["sex"] = "Male"
		G.fields["age"] = text("[]", H.age)
		G.fields["fingerprint"] = text("[]", md5(H.dna.uni_identity))
		G.fields["p_stat"] = "Active"
		G.fields["m_stat"] = "Stable"
		M.fields["b_type"] = text("[]", H.b_type)
		M.fields["mi_dis"] = "None"
		M.fields["mi_dis_d"] = "No minor disabilities have been declared."
		M.fields["ma_dis"] = "None"
		M.fields["ma_dis_d"] = "No major disabilities have been diagnosed."
		M.fields["alg"] = "None"
		M.fields["alg_d"] = "No allergies have been detected in this patient."
		M.fields["cdi"] = "None"
		M.fields["cdi_d"] = "No diseases have been diagnosed at the moment."
		M.fields["notes"] = "No notes."
		S.fields["criminal"] = "None"
		S.fields["mi_crim"] = "None"
		S.fields["mi_crim_d"] = "No minor crime convictions."
		S.fields["ma_crim"] = "None"
		S.fields["ma_crim_d"] = "No minor crime convictions."
		S.fields["notes"] = "No notes."
		for(var/obj/datacore/D in world)
			D.general += G
			D.medical += M
			D.security += S
//DNA!
		reg_dna[H.dna.unique_enzymes] = H.real_name
//Other Stuff
		if(ticker.mode.name == "sandbox")
			H.CanBuild()

*/
/*
	say(var/message)
		message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))

		if (!message)
			return

		log_say("[key] : [message]")

		if (muted)
			return

		. = say_dead(message)
*/