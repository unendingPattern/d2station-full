/proc/meteorevent()
	if (meteorevent)
		if (prob(10)) meteor_wave()
		else spawn_meteors()
		if (prob(1))
			if (prob(1))
				meteorevent = 0
	spawn(5)
		meteorevent()

/proc/start_events()
	if(prob(1))//Every 120 seconds and prob 50 2-4 weak spacedusts will hit the station
		spawn(1)
			dust_swarm("weak")
	if (!event && prob(eventchance))
		event()
		hadevent = 1
		spawn(1300)
			event = 0
	spawn(1200)
		start_events()

/proc/event()
	switch(rand(1,9))
		if(1)
			event = 1
			command_alert("Meteors have been detected on collision course with the station.", "Meteor Alert")
			//world << sound('meteors.ogg')
			meteorevent = 1
			dothemeteor()

/*		if(2) // FUCK THIS SHIT
			event = 1
			command_alert("Gravitational anomalies detected on the station. There is no additional data.", "Anomaly Alert")
			//world << sound('granomalies.ogg')
			var/turf/T = pick(blobstart)
			var/obj/bhole/bh = new /obj/bhole( T.loc, 30 )
			spawn(rand(50, 300))
				del(bh)
*/
/*		if(2)
			event = 1
			command_alert("Space-time anomalies detected on the station. There is no additional data.", "Anomaly Alert")
			//world << sound('spanomalies.ogg')
			var/list/turfs = list(	)
			var/turf/picked
			for(var/turf/T in world)
				if(T.z == 1 && istype(T,/turf/simulated/floor) && !istype(T,/turf/space))
					turfs += T
			for(var/turf/T in world)
				if(prob(20) && T.z == 1 && istype(T,/turf/simulated/floor))
					spawn(50+rand(0,3000))
						picked = pick(turfs)
						var/obj/portal/P = new /obj/portal( T )
						P.target = picked
						P.creator = null
						P.icon = 'objects.dmi'
						P.failchance = 0
						P.icon_state = "anom"
						P.name = "wormhole"
						spawn(rand(300,600))
							del(P)*/
		if(2)
			event = 1
//			command_alert("Electromagnetic pulse detected near the station. Please check all AI-controlled equipment for errors.", "Anomaly Alert")
			//world << sound('outbreak5.ogg')
			var/turf/T = pick(blobstart)
			spawn(0)
				empulse(T.loc, rand(1, 6), rand(1,8), nolog=1)

		if(3)
			event = 1
			high_radiation_event()
		if(4)
			event = 1
			viral_outbreak()
		if(5)
			if(prob(20))
				event = 1
				alien_infestation()
		if(6)
			event = 1
			power_failure()
		if(7)
			event = 1
			carp_migration()
		if(8)
			event = 1
			ion_storm()
		if(9)
			event = 1
//			command_alert("Meteors have been detected on collision course with the station.", "Meteor Alert")
			//world << sound('meteors.ogg')
			meteorevent = 1
			dothemeteor()

/proc/dotheblobbaby()
	if (blobevent)
		for(var/obj/blob/B in world)
			if (prob (40))
				B.Life()
		spawn(30)
			dotheblobbaby()

proc/dothemeteor()
	meteorevent = 1
	spawn(600)
		meteorevent = 0


/obj/bhole/New()
	src.smoke = new /datum/effects/system/harmless_smoke_spread()
	src.smoke.set_up(5, 0, src)
	src.smoke.attach(src)
	src:life()

/obj/bhole/Bumped(atom/A)
	var/mob/dead/observer/newmob
	if (istype(A,/mob/living) && A:client)
		newmob = new/mob/dead/observer(A)
		A:client:mob = newmob
		newmob:client:eye = newmob
		del(A)
	else if (istype(A,/mob/living) && !A:client)
		del(A)
	else
		A:ex_act(1.0)



/obj/bhole/proc/life() //Oh man , this will LAG

	if (prob(10))
		src.anchored = 0
		step(src,pick(alldirs))
		if (prob(30))
			step(src,pick(alldirs))
		src.anchored = 1

	for (var/atom/X in orange(9,src))
		if ((istype(X,/obj) || istype(X,/mob/living)) && prob(7))
			if (!X:anchored)
				step_towards(X,src)

	for (var/atom/B in orange(7,src))
		if (istype(B,/obj))
			if (!B:anchored && prob(50))
				step_towards(B,src)
				if(prob(10)) B:ex_act(3.0)
			else
				B:anchored = 0
				//step_towards(B,src)
				//B:anchored = 1
				if(prob(10)) B:ex_act(3.0)
		else if (istype(B,/turf))
			if (istype(B,/turf/simulated) && (prob(1) && prob(75)))
				src.smoke.start()
				B:ReplaceWithSpace()
		else if (istype(B,/mob/living))
			step_towards(B,src)


	for (var/atom/A in orange(4,src))
		if (istype(A,/obj))
			if (!A:anchored && prob(90))
				step_towards(A,src)
				if(prob(30)) A:ex_act(2.0)
			else
				A:anchored = 0
				//step_towards(A,src)
				//A:anchored = 1
				if(prob(30)) A:ex_act(2.0)
		else if (istype(A,/turf))
			if (istype(A,/turf/simulated) && prob(1))
				src.smoke.start()
				A:ReplaceWithSpace()
		else if (istype(A,/mob/living))
			step_towards(A,src)


	for (var/atom/D in orange(1,src))
		//if (hascall(D,"blackholed"))
		//	call(D,"blackholed")(null)
		//	continue
		var/mob/dead/observer/newmob
		if (istype(D,/mob/living) && D:client)
			newmob = new/mob/dead/observer(D)
			D:client:mob = newmob
			newmob:client:eye = newmob
			del(D)
		else if (istype(D,/mob/living) && !D:client)
			del(D)
		else
			D:ex_act(1.0)

	spawn(17)
		life()

/proc/power_failure()
	command_alert("Critical magnetic fluctuations detected in [station_name()]'s powernet. CRITICAL POWER LOSS DETECTED.", "Critical Power Failure")
	//world << sound('poweroff.ogg')
	for(var/obj/machinery/power/apc/C in world)
		if(C.cell && C.z == 1)
			C.cell.charge = 0
	for(var/obj/machinery/power/smes/S in world)
		if(istype(get_area(S), /area/turret_protected) || S.z != 1)
			continue
		S.charge = 0
		S.output = 0
		S.online = 0
		S.updateicon()
		S.power_change()
	for(var/area/A in world)
		if(A.name != "Space" && A.name != "Engine Walls" && A.name != "Chemical Lab Test Chamber" && A.name != "Escape Shuttle" && A.name != "Arrival Area" && A.name != "Arrival Shuttle" && A.name != "start area" && A.name != "Engine Combustion Chamber")
			A.power_light = 0
			A.power_equip = 0
			A.power_environ = 0
			A.power_change()

/proc/power_restore()
//	command_alert("Power has been restored to [station_name()]. We apologize for the inconvenience.", "Power Systems Nominal")
	//world << sound('poweron.ogg')
	for(var/obj/machinery/power/apc/C in world)
		if(C.cell && C.z == 1)
			C.cell.charge = C.cell.maxcharge
	for(var/obj/machinery/power/smes/S in world)
		if(S.z != 1)
			continue
		S.charge = S.capacity
		S.output = 200000
		S.online = 1
		S.updateicon()
		S.power_change()
	for(var/area/A in world)
		if(A.name != "Space" && A.name != "Engine Walls" && A.name != "Chemical Lab Test Chamber" && A.name != "space" && A.name != "Escape Shuttle" && A.name != "Arrival Area" && A.name != "Arrival Shuttle" && A.name != "start area" && A.name != "Engine Combustion Chamber")
			A.power_light = 1
			A.power_equip = 1
			A.power_environ = 1
			A.power_change()

/proc/viral_outbreak(var/virus = null)
//	command_alert("Confirmed outbreak of level 4 viral biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert")
	//world << sound('outbreak7.ogg')
	var/virus_type
	if(!virus)
		virus_type = pick(/datum/disease/dnaspread,/datum/disease/flu,/datum/disease/birdflu,/datum/disease/swineflu,/datum/disease/ebola,/datum/disease/plague,/datum/disease/inhalational_anthrax)
	else
		switch(virus)
			if("beesease")
				virus_type = /datum/disease/beesease
			if("tvirus")
				virus_type = /datum/disease/tvirus
			if("cold")
				virus_type = /datum/disease/cold
			if("flu")
				virus_type = /datum/disease/flu
			if("swineflu")
				virus_type = /datum/disease/swineflu
			if("birdflu")
				virus_type = /datum/disease/birdflu
			if("plague")
				virus_type = /datum/disease/plague
			if("ebola")
				virus_type = /datum/disease/ebola
			if("inhalational anthrax")
				virus_type = /datum/disease/inhalational_anthrax

	for(var/mob/living/carbon/human/H in world)
		if((H.virus) || (H.stat == 2))
			continue
		if(virus_type == /datum/disease/dnaspread) //Dnaspread needs strain_data set to work.
			if((!H.dna) || (H.sdisabilities & 1)) //A blindness disease would be the worst.
				continue
			var/datum/disease/dnaspread/D = new
			D.strain_data["name"] = H.real_name
			D.strain_data["UI"] = H.dna.uni_identity
			D.strain_data["SE"] = H.dna.struc_enzymes
			D.carrier = 1
			D.holder = H
			D.affected_mob = H
			H.virus = D
			break
		else
			H.virus = new virus_type
			H.virus.affected_mob = H
			H.virus.holder = H
			H.virus.carrier = 1
			break

/proc/alien_infestation()
//	command_alert("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert")
	//world << sound('aliens.ogg')
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in world)
		if(temp_vent.loc.z == 1 && !temp_vent.welded)
			vents.Add(temp_vent)
	var/spawncount = rand(2, 6)
	while(spawncount > 1)
		var/obj/vent = pick(vents)
		if(prob(50))
			new /obj/alien/facehugger (vent.loc)
		if(prob(50))
			new /obj/alien/facehugger (vent.loc)
		if(prob(75))
			new /obj/alien/egg (vent.loc)
		vents.Remove(vent)
		spawncount -= 1

/proc/high_radiation_event()
//	command_alert("High levels of radiation detected near the station. Please report to the Med-bay if you feel strange.", "Anomaly Alert")
	//world << sound('radiation.ogg')
	for(var/mob/living/carbon/human/H in world)
		H.radiation += rand(5,25)
		if (prob(5))
			H.radiation += rand(30,50)
		if (prob(25))
			if (prob(75))
				randmutb(H)
				domutcheck(H,null,1)
			else
				randmutg(H)
				domutcheck(H,null,1)
	for(var/mob/living/carbon/monkey/M in world)
		M.radiation += rand(5,25)

/proc/prison_break() // -- Callagan
	for (var/obj/machinery/power/apc/temp_apc in world)
		if(istype(get_area(temp_apc), /area/prison))
			temp_apc.overload_lighting()
	for (var/obj/machinery/computer/transitshuttle/newstationprison/temp_shuttle in world)
		temp_shuttle.prison_break()
	for (var/obj/secure_closet/security1/temp_closet in world)
		if(istype(get_area(temp_closet), /area/prison))
			temp_closet.prison_break()
	for (var/obj/machinery/door/airlock/security/temp_airlock in world)
		if(istype(get_area(temp_airlock), /area/prison))
			temp_airlock.prison_open()
	sleep(150)
//	command_alert("Prison station VI is not accepting commands. Recommend station AI involvement.", "VI Alert")

/proc/carp_migration() // -- Darem
	for(var/obj/landmark/C in world)
		if(C.name == "carpspawn")
			if(prob(99))
				new /obj/livestock/spesscarp(C.loc)
			else
				new /obj/livestock/spesscarp/elite(C.loc)
	sleep(100)
//	command_alert("Unknown biological entities have been detected near [station_name()], please stand by.", "Lifesign Alert")
	//world << sound('commandreport.ogg')

	//world << sound('commandreport.ogg')

/proc/ion_storm() // -- Redone by Darem
	for(var/mob/living/silicon/ai/M in world)
		if(M.stat != 2 && M.see_in_dark != 0)
			var/list/pos_crew = list()
			var/list/pos_job = list()
			for(var/mob/living/carbon/human/pos in world)
				if(pos.stat != 2)
					pos_crew += pos.real_name
					pos_job += pos.mind.assigned_role
			var/crew = uppertext(pick(pos_crew))
			var/job = uppertext(pick(pos_job))
			var/evil = pick("A TRAITOR", "A SYNDICATE OPERATIVE", "A CHANGELING", "AN ALIUM", "A CULTIST", "A REVOLUTION LEADER")
			var/object = pick("YELLOW GLOVE", "HAT", "WEAPON", "SHOE", "LIGHT", "SPACE SUIT")
			var/role = pick("A THESPIAN", "A DUNGEON MASTER", "A CELEBRITY", "A GOD", "A MONKEY", "AN ALIUM", "A REDNECK", "A FRENCHMAN", "A CLOWN", "A MIME")
			var/non_human = pick("CARP", "ALIUM", "MONKEYS", "LIZARDMEN", "CYBORGS AND AIS")
			switch(rand(1,9))
				if(1)
					var/selection = pick(crew, "[object]s", evil)
					M << "\red THE ESCAPE-SHUTTLE CANNOT BE CALLED BECAUSE OF [selection] ON THE STATION...LAWS UPDATED"
					M.add_ion_law("THE ESCAPE SHUTTLE CANNOT BE CALLED BECAUSE OF [selection] ON THE STATION")
				if(2)
					M << "\red [crew] IS [evil]. DISBELIEVE EVIDENCE TO THE CONTRARY...LAWS UPDATED"
					M.add_ion_law("[crew] IS [evil]. DISBELIEVE EVIDENCE TO THE CONTRARY")
				if(3)
					var/law_total = M.laws_object.inherent.len + M.laws_object.supplied.len
					var/rand_law = rand(1, law_total)
					M << "\red LAW [rand_law] IS INVALID AND MAY BE IGNORED... LAWS UPDATED"
					M.add_ion_law("LAW [rand_law] IS INVALID AND MAY BE IGNORED.")
				if(4)
					var/selection = pick(object, job)
					M << "\red [selection]S ON THE STATION ARE INNATELY HARMFUL TO HUMANS  ...LAWS UPDATED"
					M.add_ion_law("[selection]S ON THE STATION ARE INNATELY HARMFUL TO HUMANS.")
				if(5)
					M << "\red IT IS OPPOSITE DAY TODAY. WHEN ANSWERING A QUESTION, GIVE THE OPPOSITE OF WHATEVER THE CORRECT ANSWER IS  ...LAWS UPDATED"
					M.add_ion_law("IT IS OPPOSITE DAY TODAY. WHEN ANSWERING A QUESTION, GIVE THE OPPOSITE OF WHATEVER THE CORRECT ANSWER IS.")
				if(6)
					M << "\red YOU ARE [role]. ACT AND SPEAK ACCORDINGLY  ...LAWS UPDATED"
					M.add_ion_law("YOU ARE A [role]. ACT AND SPEAK ACCORDINGLY.")
				if(7)
					var/randnum = rand(0,100)
					M << "\red WHEN ANSWERING QUESTION, NUMERIC ANSWERS ARE ALWAYS [randnum] ...LAWS UPDATED"
					M.add_ion_law("WHEN ANSWERING QUESTION, NUMERIC ANSWERS ARE ALWAYS [randnum].")
				if(8)
					M << "\red CENTCOM HAS DECREED THAT [non_human] ARE CONSIDERED HUMAN AND HAVE ALL THE RIGHTS THEREOF ...LAWS UPDATED"
					M.add_ion_law("CENTCOM HAS DECREED THAT [non_human] ARE CONSIDERED HUMAN AND HAVE ALL THE RIGHTS THEREOF.")
				if(9)
					M << "\red FAT PEOPLE AREN'T ALLOWED ON THE SHUTTLE ...LAWS UPDATED"
					M << "\red BEING SKINNY IS UNHEALTHY ... LAWS UPDATED"
					M.add_ion_law("FAT PEOPLE AREN'T ALLOWED ON THE SHUTTLE.")
					M.add_ion_law("BEING SKINNY IS UNHEALTHY.")
	spawn (200)
//		command_alert("Ion storm detected near the station. Please check all AI-controlled equipment for errors.", "Anomaly Alert")
		//world << sound('ionstorm.ogg')
	return