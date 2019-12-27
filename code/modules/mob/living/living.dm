/mob/living/verb/succumb()
	set hidden = 1

	if ((src.health < 0 && src.health > -95.0))
		src.oxyloss += src.health + 200
		src.health = 100 - src.oxyloss - src.toxloss - src.fireloss - src.bruteloss
		src.updatehealth()
		src.death()
		src.updatehealth()
		src << "\blue You have given up life and succumbed to death."


/mob/living/bullet_act(var/obj/item/projectile/Proj)
	if(src:nodamage) return
	for(var/i = 1, i<= Proj.mobdamage.len, i++)

		switch(i)
			if(1)
				if (istype(src, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = src
					var/dam_zone = pick("chest", "chest", "chest", "groin", "head")
					if (H.organs[text("[]", dam_zone)])
						var/datum/organ/external/affecting = H.organs[text("[]", dam_zone)]
						if (affecting.take_damage(Proj.mobdamage[BRUTE], 0))
							H.UpdateDamageIcon()
						else
							H.UpdateDamage()
					src.updatehealth()

				else
					if(!nodamage)  src.take_organ_damage(Proj.mobdamage[BRUTE])

			if(2)
				var/d = Proj.mobdamage[BURN]
				if(!Proj.nodamage) fireloss += d
				updatehealth()
			if(3)
				var/d = Proj.mobdamage[TOX]
				if(!Proj.nodamage) toxloss += d
				updatehealth()
			if(4)
				var/d = Proj.mobdamage[OXY]
				if(!Proj.nodamage) oxyloss += d
				updatehealth()
			if(5)
				var/d = Proj.mobdamage[CLONE]
				if(!Proj.nodamage) cloneloss += d
				updatehealth()

	if(Proj.effects["stun"] && prob(Proj.effectprob["stun"]))
		if(Proj.effectmod["stun"] == SET)
			stunned = Proj.effects["stun"]
		else
			stunned += Proj.effects["stun"]


	if(Proj.effects["weak"] && prob(Proj.effectprob["weak"]))
		if(Proj.effectmod["weak"] == SET)
			weakened = Proj.effects["weak"]
		else
			weakened += Proj.effects["weak"]

	if(Proj.effects["paralysis"] && prob(Proj.effectprob["paralysis"]))
		if(Proj.effectmod["paralysis"] == SET)
			paralysis = Proj.effects["paralysis"]
		else
			paralysis += Proj.effects["paralysis"]

	if(Proj.effects["stutter"] && prob(Proj.effectprob["stutter"]))
		if(Proj.effectmod["stutter"] == SET)
			stuttering = Proj.effects["stutter"]
		else
			stuttering += Proj.effects["stutter"]

	if(Proj.effects["drowsyness"] && prob(Proj.effectprob["drowsyness"]))
		if(Proj.effectmod["drowsyness"] == SET)
			drowsyness = Proj.effects["drowsyness"]
		else
			drowsyness += Proj.effects["drowsyness"]

	if(Proj.effects["radiation"] && prob(Proj.effectprob["radiation"]))
		if(Proj.effectmod["radiation"] == SET)
			radiation = Proj.effects["radiation"]
		else
			radiation += Proj.effects["radiation"]

	if(Proj.effects["eyeblur"] && prob(Proj.effectprob["eyeblur"]))
		if(Proj.effectmod["eyeblur"] == SET)
			eye_blurry = Proj.effects["eyeblur"]
		else
			eye_blurry += Proj.effects["eyeblur"]


/mob/living/proc/updatehealth()
	if (!src.nodamage)
		if(organStructure && organStructure.chest)
			health = organStructure.chest.maxHealth - oxyloss - toxloss - fireloss - bruteloss
		else
			src.health = 100 - src.oxyloss - src.toxloss - src.fireloss - src.bruteloss
	else
		src.health = 100
		src.stat = 0

//sort of a legacy burn method for /electrocute, /shock, and the e_chair
/mob/living/proc/burn_skin(burn_amount)
	if(istype(src, /mob/living/carbon/human))
		if(src:nodamage) return
		//world << "DEBUG: burn_skin(), mutations=[mutations]"
		if (src.mutations & COLD_RESISTANCE) //fireproof
			return 0
		var/mob/living/carbon/human/H = src	//make this damage method divide the damage to be done among all the body parts, then burn each body part for that much damage. will have better effect then just randomly picking a body part
		var/divided_damage = (burn_amount)/(H.organs.len)
		var/datum/organ/external/affecting = null
		var/extradam = 0	//added to when organ is at max dam
		for(var/A in H.organs)
			if(!H.organs[A])	continue
			affecting = H.organs[A]
			if(!istype(affecting, /datum/organ/external))	continue
			if(affecting.take_damage(0, divided_damage+extradam))
				extradam = 0
			else
				extradam += divided_damage
		H.UpdateDamageIcon()
		H.updatehealth()
		return 1
	else if(istype(src, /mob/living/carbon/monkey))
		if (src.mutations & COLD_RESISTANCE) //fireproof
			return 0
		var/mob/living/carbon/monkey/M = src
		M.fireloss += burn_amount
		M.updatehealth()
		return 1
	else if(istype(src, /mob/living/silicon/ai))
		return 0

/mob/living/proc/adjustBodyTemp(actual, desired, incrementboost)
	var/temperature = actual
	var/difference = abs(actual-desired)	//get difference
	var/increments = difference/10 //find how many increments apart they are
	var/change = increments*incrementboost	// Get the amount to change by (x per increment)

	// Too cold
	if(actual < desired)
		temperature += change
		if(actual > desired)
			temperature = desired
	// Too hot
	if(actual > desired)
		temperature -= change
		if(actual < desired)
			temperature = desired
//	if(istype(src, /mob/living/carbon/human))
//		world << "[src] ~ [src.bodytemperature] ~ [temperature]"
	return temperature


/mob/living/proc/get_contents()
	var/list/L = list()
	L += src.contents
	for(var/obj/item/weapon/storage/S in src.contents)
		L += S.return_inv()
	for(var/obj/item/weapon/gift/G in src.contents)
		L += G.gift
		if (istype(G.gift, /obj/item/weapon/storage))
			L += G.gift:return_inv()
	return L

/mob/living/proc/check_contents_for(A)
	var/list/L = list()
	L += src.contents
	for(var/obj/item/weapon/storage/S in src.contents)
		L += S.return_inv()
	for(var/obj/item/weapon/gift/G in src.contents)
		L += G.gift
		if (istype(G.gift, /obj/item/weapon/storage))
			L += G.gift:return_inv()

	for(var/obj/B in L)
		if(B.type == A)
			return 1
	return 0


/mob/living/proc/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0)
	  return 0 //only carbon liveforms have this proc

/mob/living/emp_act(severity)
	var/list/L = src.get_contents()
	for(var/obj/O in L)
		O.emp_act(severity)
	..()

/mob/living/proc/get_organ_target()
	var/mob/shooter = src
	var/t = shooter:zone_sel.selecting
	if ((t in list( "eyes", "mouth" )))
		t = "head"
	var/datum/organ/external/def_zone = ran_zone(t)
	return def_zone


// heal ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/heal_organ_damage(var/brute, var/burn)
	bruteloss = max(0, bruteloss-brute)
	fireloss = max(0, fireloss-burn)
	src.updatehealth()

// damage ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/take_organ_damage(var/brute, var/burn)
	if(src:nodamage) return
	bruteloss += brute
	fireloss += burn
	src.updatehealth()

// heal MANY external organs, in random order
/mob/living/proc/heal_overall_damage(var/brute, var/burn)
	bruteloss = max(0, bruteloss-brute)
	fireloss = max(0, fireloss-burn)
	src.updatehealth()

// damage MANY external organs, in random order
/mob/living/proc/take_overall_damage(var/brute, var/burn)
	if(src:nodamage) return
	bruteloss += brute
	fireloss += burn
	src.updatehealth()

/mob/living/proc/revive()
	//src.fireloss = 0
	src.toxloss = 0
	//src.bruteloss = 0
	src.oxyloss = 0
	src.paralysis = 0
	src.stunned = 0
	src.weakened =0
	//src.health = 100
	src.heal_overall_damage(1000, 1000)
	src.flaming = 0
	src.buckled = initial(src.buckled)
	src.handcuffed = initial(src.handcuffed)
	if(src.stat > 1) src.stat=0
	..()
	return