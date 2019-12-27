/datum/game_mode
	var/list/datum/mind/changelings = list()


/datum/game_mode/changeling
	name = "changeling"
	config_tag = "changeling"

	var
		const
			prob_int_murder_target = 50 // intercept names the assassination target half the time
			prob_right_murder_target_l = 25 // lower bound on probability of naming right assassination target
			prob_right_murder_target_h = 50 // upper bound on probability of naimg the right assassination target

			prob_int_item = 50 // intercept names the theft target half the time
			prob_right_item_l = 25 // lower bound on probability of naming right theft target
			prob_right_item_h = 50 // upper bound on probability of naming the right theft target

			prob_int_sab_target = 50 // intercept names the sabotage target half the time
			prob_right_sab_target_l = 25 // lower bound on probability of naming right sabotage target
			prob_right_sab_target_h = 50 // upper bound on probability of naming right sabotage target

			prob_right_killer_l = 25 //lower bound on probability of naming the right operative
			prob_right_killer_h = 50 //upper bound on probability of naming the right operative
			prob_right_objective_l = 25 //lower bound on probability of determining the objective correctly
			prob_right_objective_h = 50 //upper bound on probability of determining the objective correctly
/*
			laser = 1
			hand_tele = 2
			plasma_bomb = 3
			jetpack = 4
			captain_card = 5
			captain_suit = 6

			destroy_plasma = 1
			destroy_ai = 2
			kill_monkeys = 3
			cut_power = 4

			percentage_plasma_destroy = 70 // what percentage of the plasma tanks you gotta destroy
			percentage_station_cut_power = 80 // what percentage of the tiles have to have power cut
			percentage_station_evacuate = 80 // what percentage of people gotta leave - you also gotta change the objective in the traitor menu
*/
			waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
			waittime_h = 1800 //upper bound on time before intercept arrives (in tenths of seconds)

		changelingdeathtime //timestamp when last changeling was killed
		const/TIME_TO_GET_REVIVED = 3000
		changelingdeath = 0

/datum/game_mode/changeling/announce()
	world << "<B>The current game mode is - Changeling!</B>"
	world << "<B>There is an alien changeling on the station. Do not let the changeling succeed!</B>"

/datum/game_mode/changeling/can_start()
	for(var/mob/new_player/P in mobz)
		if(P.client && P.ready && !jobban_isbanned(P, "Syndicate"))
			return 1
	return 0

/datum/game_mode/changeling/pre_setup()
	var/list/datum/mind/possible_changelings = get_players_for_role(BE_CHANGELING)
	if(possible_changelings.len>0)
		var/datum/mind/changeling = pick(possible_changelings)
		//possible_changelings-=changeling
		changelings += changeling
		var/mob/new_player/player = changeling.current
		player.jobs_restricted_by_gamemode = nonhuman_positions
		modePlayer += changelings
		return 1
	else
		return 0

/datum/game_mode/changeling/post_setup()
	for(var/datum/mind/changeling in changelings)
		grant_changeling_powers(changeling.current)
		changeling.special_role = "Changeling"
		forge_changeling_objectives(changeling)
		greet_changeling(changeling)

	spawn (rand(waittime_l, waittime_h))
		send_intercept()
	..()
	return


/datum/game_mode/proc/forge_changeling_objectives(var/datum/mind/changeling)
	//OBJECTIVES - Always absorb 5 genomes, plus random traitor objectives.
	//If they have two objectives as well as absorb, they must survive rather than escape
	//No escape alone because changelings aren't suited for it and it'd probably just lead to rampant robusting
	//If it seems like they'd be able to do it in play, add a 10% chance to have to escape alone

	var/datum/objective/absorb/absorb_objective = new
	absorb_objective.owner = changeling
	absorb_objective.gen_amount_goal()
	changeling.objectives += absorb_objective

	switch(rand(1,100))
		if(1 to 45)

			var/datum/objective/assassinate/kill_objective = new
			kill_objective.owner = changeling
			kill_objective.find_target()
			changeling.objectives += kill_objective

			if (!(locate(/datum/objective/escape) in changeling.objectives))
				var/datum/objective/escape/escape_objective = new
				escape_objective.owner = changeling
				changeling.objectives += escape_objective

		if(46 to 90)

			var/datum/objective/steal/steal_objective = new
			steal_objective.owner = changeling
			steal_objective.find_target()
			changeling.objectives += steal_objective

			if (!(locate(/datum/objective/escape) in changeling.objectives))
				var/datum/objective/escape/escape_objective = new
				escape_objective.owner = changeling
				changeling.objectives += escape_objective

		else

			var/datum/objective/assassinate/kill_objective = new
			kill_objective.owner = changeling
			kill_objective.find_target()
			changeling.objectives += kill_objective

			var/datum/objective/steal/steal_objective = new
			steal_objective.owner = changeling
			steal_objective.find_target()
			changeling.objectives += steal_objective

			if (!(locate(/datum/objective/survive) in changeling.objectives))
				var/datum/objective/survive/survive_objective = new
				survive_objective.owner = changeling
				changeling.objectives += survive_objective
	return

/datum/game_mode/proc/greet_changeling(var/datum/mind/changeling, var/you_are=1)
	if (you_are)
		changeling.current << "<B>\red You are a changeling!</B>"
	changeling.current << "<B>You must complete the following tasks:</B>"
	var/obj_count = 1
	for(var/datum/objective/objective in changeling.objectives)
		changeling.current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
		obj_count++
	return

/datum/game_mode/changeling/check_finished()
	var/changelings_alive = 0
	for(var/datum/mind/changeling in changelings)
		if(!istype(changeling.current,/mob/living/carbon))
			continue
		if(changeling.current.stat==2)
			continue
		changelings_alive++

	if (changelings_alive)
		changelingdeath = 0
		return ..()
	else
		if (!changelingdeath)
			changelingdeathtime = world.time
			changelingdeath = 1
		if(world.time-changelingdeathtime > TIME_TO_GET_REVIVED)
			return 1
		else
			return ..()

/datum/game_mode/proc/grant_changeling_powers(mob/living/carbon/human/changeling_mob)
	if (!istype(changeling_mob))
		return
	changeling_mob.make_changeling()

/datum/game_mode/proc/auto_declare_completion_changeling()
	for(var/datum/mind/changeling in changelings)
		var/changelingwin = 1
		var/changeling_name
		var/totalabsorbed = 0
		if (changeling.current)
			totalabsorbed = changeling.current.absorbed_dna.len - 1

		if(changeling.current)
			changeling_name = "[changeling.current.real_name] (played by [changeling.key])"
		else
			changeling_name = "[changeling.key] (character destroyed)"

		world << "<B>The changeling was [changeling_name]</B>"
		world << "<B>Genomes absorbed: [totalabsorbed]</B>"

		var/count = 1
		for(var/datum/objective/objective in changeling.objectives)
			if(objective.check_completion())
				world << "<B>Objective #[count]</B>: [objective.explanation_text] \green <B>Success</B>"
			else
				world << "<B>Objective #[count]</B>: [objective.explanation_text] \red Failed"
				changelingwin = 0
			count++

		if(changelingwin)
			world << "<B>The changeling was successful!<B>"
			if(totalabsorbed >= 1)
				var/extrapayment = totalabsorbed * 20
				var/changelingpayment = 100 + extrapayment + text2num(src.getInflation())
				if(changeling.current.client.goon)
					changelingpayment += 75
				if(src.doTransaction(changeling.current.ckey,"[changelingpayment]","Successful changeling.") != 1)
					src << "\blue Unfortunately you lack a bank account and didn't get paid for being a successful changeling."
				else
					src << "\blue You got �[changelingpayment] for being a successful changeling!"
		else
			world << "<B>The changeling has failed!<B>"
	return 1
