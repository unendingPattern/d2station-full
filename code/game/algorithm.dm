/world/New()
	..()

	diary = file("data/logs/[time2text(world.realtime, "YYYY/MM-Month/DD-Day")].log")
	diary << ""
	diary << ""
	diary << "Starting up. [time2text(world.timeofday, "hh:mm.ss")]"
	diary << "---------------------"
	diary << ""

	jobban_loadbanfile()
	jobban_updatelegacybans()
	goon_loadfile()
	beta_tester_loadfile()
	LoadBans()
	process_teleport_locs() //Sets up the wizard teleport locations
	process_ghost_teleport_locs() //Sets up ghost teleport locations.

	spawn(30)
		//EXPERIMENTAL
		Optimize()
		sleep_offline = 1
		//EXPERIMENTAL

	spawn(0)
		SetupOccupationsList()
		return


/// EXPERIMENTAL STUFF
var/opt_inactive = null
/world/proc/Optimize()
	if(!opt_inactive) opt_inactive  = world.timeofday

	if(world.timeofday - opt_inactive >= 600)
		KickInactiveClients()
		opt_inactive = world.timeofday

	spawn(100) Optimize()

/world/proc/KickInactiveClients()
	for(var/client/C)
		if(!C.holder && ((C.inactivity/10)/60) >= 10) // Used to be 15 -- TLE
			C << "\red You have been inactive for more than 10 minutes and have been disconnected."
			/*
			if(C.mob)
				if(!istype(C.mob, /mob/dead/))
					C << "\red Your character has also been killed to save on server resources."
					C.mob.death(0) // Added to lighten the load they take on the server -- TLE
			del(C)
			*/

/// EXPERIMENTAL STUFF

// This function counts a passed job.
proc/countJob(rank)
	var/jobCount = 0
	for(var/mob/H in world)
		if(H.mind && H.mind.assigned_role == rank)
			jobCount++
	return jobCount

/mob/living/carbon/human/var/const
	slot_back = 1
	slot_wear_mask = 2
	slot_handcuffed = 3
	slot_l_hand = 4
	slot_r_hand = 5
	slot_belt = 6
	slot_wear_id = 7
	slot_ears = 8
	slot_glasses = 9
	slot_gloves = 10
	slot_head = 11
	slot_shoes = 12
	slot_wear_suit = 13
	slot_w_uniform = 14
	slot_l_store = 15
	slot_r_store = 16
	slot_s_store = 17
	slot_in_backpack = 18
	slot_h_store = 19

/mob/living/carbon/human/proc/equip_if_possible(obj/item/weapon/W, slot) // since byond doesn't seem to have pointers, this seems like the best way to do this :/
	//warning: icky code
	var/equipped = 0
	if((slot == l_store || slot == r_store || slot == belt || slot == wear_id) && !src.w_uniform)
		del(W)
		return
	if(slot == s_store && !src.wear_suit)
		del(W)
		return
	if(slot == h_store && !src.head)
		del(W)
		return
	switch(slot)
		if(slot_back)
			if(!src.back)
				src.back = W
				equipped = 1
		if(slot_wear_mask)
			if(!src.wear_mask)
				src.wear_mask = W
				equipped = 1
		if(slot_handcuffed)
			if(!src.handcuffed)
				src.handcuffed = W
				equipped = 1
		if(slot_l_hand)
			if(!src.l_hand)
				src.l_hand = W
				equipped = 1
		if(slot_r_hand)
			if(!src.r_hand)
				src.r_hand = W
				equipped = 1
		if(slot_belt)
			if(!src.belt)
				src.belt = W
				equipped = 1
		if(slot_wear_id)
			if(!src.wear_id)
				src.wear_id = W
				equipped = 1
		if(slot_ears)
			if(!src.ears)
				src.ears = W
				equipped = 1
		if(slot_glasses)
			if(!src.glasses)
				src.glasses = W
				equipped = 1
		if(slot_gloves)
			if(!src.gloves)
				src.gloves = W
				equipped = 1
		if(slot_head)
			if(!src.head)
				src.head = W
				equipped = 1
		if(slot_shoes)
			if(!src.shoes)
				src.shoes = W
				equipped = 1
		if(slot_wear_suit)
			if(!src.wear_suit)
				src.wear_suit = W
				equipped = 1
		if(slot_w_uniform)
			if(!src.w_uniform)
				src.w_uniform = W
				equipped = 1
		if(slot_l_store)
			if(!src.l_store)
				src.l_store = W
				equipped = 1
		if(slot_r_store)
			if(!src.r_store)
				src.r_store = W
				equipped = 1
		if(slot_s_store)
			if(!src.s_store)
				src.s_store = W
				equipped = 1
		if(slot_in_backpack)
			if (src.back && istype(src.back, /obj/item/weapon/storage/backpack))
				var/obj/item/weapon/storage/backpack/B = src.back
				if(B.contents.len < 7 && W.w_class <= 3)
					W.loc = B
					equipped = 1
		if(slot_h_store)
			if(!src.h_store)
				src.h_store = W
				equipped = 1

	if(equipped)
		W.layer = 20
	else
		del(W)

/proc/AutoUpdateAI(obj/subject)
	if (subject!=null)
		for(var/mob/living/silicon/ai/M in world)
			if ((M.client && M.machine == subject))
				subject.attack_ai(M)
