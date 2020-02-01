/obj/item/proc/process()
	processing_items.Remove(src)

	return null

/obj/item/proc/attack_self()
	return

/obj/item/proc/talk_into(mob/M as mob, text)
	return

/obj/item/proc/moved(mob/user as mob, old_loc as turf)
	return

/obj/item/proc/dropped(mob/user as mob)
	return

// called just as an item is picked up (loc is not yet changed)
/obj/item/proc/pickup(mob/user)
	return

// called after an item is placed in an equipment slot
// user is mob that equipped it
// slot is text of slot type e.g. "head"
// for items that can be placed in multiple slots
// note this isn't called during the initial dressing of a player
/obj/item/proc/equipped(var/mob/user, var/slot)
	return
//
// ***TODO: implement unequipped()
//

/obj/item/proc/afterattack()
	return

/obj/item/weapon/dummy/ex_act()
	return

/obj/item/weapon/dummy/blob_act()
	return

/obj/item/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(50))
				del(src)
				return
		if(3.0)
			if (prob(5))
				del(src)
				return
		else
	return

/obj/item/blob_act()
	return

/obj/item/verb/move_to_top()
	set name = "Move To Top"
	set category = "Object"
	set src in oview(1)

	if(!istype(src.loc, /turf) || usr.stat || usr.restrained() )
		return

	var/turf/T = src.loc

	src.loc = null

	src.loc = T

/obj/item/examine()
	set src in view()

	var/t
	switch(src.w_class)
		if(1.0)
			t = "tiny"
		if(2.0)
			t = "small"
		if(3.0)
			t = "normal-sized"
		if(4.0)
			t = "bulky"
		if(5.0)
			t = "huge"
		else
	if ((usr.mutations & 16) && prob(50)) t = "funny-looking"
	usr << text("This is []\icon[][]. It is a [] item.", !src.blood_DNA ? "" : "bloody ",src, src.name, t)
	usr << src.desc
	return

/obj/item/attack_hand(mob/user as mob)
	if (!user) return
	if (istype(src.loc, /obj/item/weapon/storage))
		for(var/mob/M in range(1, src.loc))
			if (M.s_active == src.loc)
				if (M.client)
					M.client.screen -= src
	src.throwing = 0
	if (src.loc == user)
		if(istype(src, /obj/item/clothing) && src:cursed)
			if(!user.r_hand == src || !user.l_hand == src)
				user << "The [src.name] will not come off!"
				return
		else
			user.u_equip(src)
	else
		src.pickup(user)
	if (user.hand)
		user.l_hand = src
	else
		user.r_hand = src
	src.loc = user
	src.layer = 20
	add_fingerprint(user)
	user.update_clothing()
	return


/obj/item/attack_paw(mob/user as mob)

	if(isalien(user))
		if(!user:has_fine_manipulation) // -- defaults to 0, only changes due to badminnery -- Urist
			user << "Your claws aren't capable of such fine manipulation."
			return

//	if(istype(src, /obj/item/weapon/gun)) //Temporary fix until I figure out what's going with monkey/add_blood code./N
//		user << "Sorry Mr. Monkey, guns aren't for you."
//		return

	if (istype(src.loc, /obj/item/weapon/storage))
		for(var/mob/M in range(1, src.loc))
			if (M.s_active == src.loc)
				if (M.client)
					M.client.screen -= src
	src.throwing = 0
	if (src.loc == user)
		if(istype(src, /obj/item/clothing) && src:cursed)
			if(!user.r_hand == src || !user.l_hand == src)
				user << "The [src.name] will not come off!"
				return
		else
			user.u_equip(src)
	if (user.hand)
		user.l_hand = src
	else
		user.r_hand = src
	src.loc = user
	src.layer = 20
	user.update_clothing()
	return

/obj/item/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/packageWrap))
		var/obj/item/weapon/packageWrap/O = W
		if (O.amount > 1)
			var/obj/item/smallDelivery/P = new /obj/item/smallDelivery(get_turf(src.loc))
			P.wrapped = src

			src.loc = P
			O.amount -= 1

/obj/item/proc/attack(mob/M as mob, mob/user as mob, def_zone)
	M.ai_target = user

	if(!M.client)
		if(M.ai_active == 1 && ((istype(M, /mob/living/carbon/human) && M.brainloss >= 20) || istype(M, /mob/living/carbon/monkey)))
			spawn(1)
			M:ai_state = 2
			M:ai_target = user
			if(istype(M, /mob/living/carbon/human))
				M.say(pick("[user] attacked me!", "Security help me [user] is attacking me!!", "Security to [M.loc.loc] [user] is killing me!", "[user] is griefing me in [M.loc.loc]!", "need help in [M.loc.loc]!!"))

	if (!M) // not sure if this is the right thing...
		return

	var/messagesource = M
//	if (istype(M,/mob/living/carbon/brain))
//		messagesource = M:container

	if (src.hitsound)
		playsound(src.loc, hitsound, 50, 1, -1)
	/////////////////////////
	user.lastattacked = M
	M.lastattacker = user
	//spawn(1800)            // this wont work right
	//	M.lastattacker = null
	/////////////////////////
	if(!istype(M, /mob/living/carbon/human))
		for(var/mob/O in viewers(messagesource, null))
			O.show_message(text("\red <B>[] has been attacked with [][] </B>", M, src, (user ? text(" by [].", user) : ".")), 1)
			if(prob(3))
				O.horny = 0
	var/power = src.force
	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if (ishuman(user) || isrobot(user) || ishivebot(user) || ismonkey(user) || isalien(user))
			if (!( def_zone ))
				var/mob/user2 = user
				var/t = user2:zone_sel.selecting
				if ((t in list( "eyes", "mouth" )))
					t = "head"
				def_zone = ran_zone(t)
		var/datum/organ/external/affecting
		if (H.organs[text("[]", def_zone)])
			affecting = H.organs[text("[]", def_zone)]
		var/hit_area = parse_zone(def_zone)
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red <B>[] has been attacked in the [] with [][] </B>", M, hit_area, src, (user ? text(" by [].", user) : ".")), 1)
		if (istype(affecting, /datum/organ/external))
			var/b_dam = (src.damtype == "brute" ? src.force : 0)
			var/f_dam = (src.damtype == "fire" ? src.force : 0)
			if (M.mutations & 2)
				f_dam = 0
			if (def_zone == "head")
				if (b_dam && (istype(H.head, /obj/item/clothing/head/helmet/) && H.head.body_parts_covered & HEAD) && prob(80 - src.force))
					if (prob(20))
						affecting.take_damage(power, 0)
					else
						H.show_message("\red You have been protected from a hit to the head.")
					return
				if ((b_dam && prob(src.force + affecting.brute_dam + affecting.burn_dam)))
					var/time = rand(10, 120)
					if (prob(90))
						if (H.paralysis < time)
							H.paralysis = time
					else
						if (H.weakened < time)
							H.weakened = time
					if(H.stat != 2)	H.stat = 1
					for(var/mob/O in viewers(M, null))
						O.show_message(text("\red <B>[] has been knocked unconscious!</B>", H), 1, "\red You hear someone fall.", 2)
					if (prob(50))
						if (ticker.mode.name == "revolution" && M != user)
							ticker.mode:remove_revolutionary(H.mind)
				if (b_dam && prob(25 + (b_dam * 2)))
					src.add_blood(H)
					if (prob(33))
						var/turf/location = H.loc
						if (istype(location, /turf/simulated))
							location.add_blood(H)
					if (H.wear_mask)
						H.wear_mask.add_blood(H)
					if (H.head)
						H.head.add_blood(H)
					if (H.glasses && prob(33))
						H.glasses.add_blood(H)
					if (istype(user, /mob/living/carbon/human))
						var/mob/living/carbon/human/user2 = user
						if (user2.gloves)
							user2.gloves.add_blood(H)
						else
							user2.add_blood(H)
						if (prob(15))
							if (user2.wear_suit)
								user2.wear_suit.add_blood(H)
							else if (user2.w_uniform)
								user2.w_uniform.add_blood(H)
				affecting.take_damage(b_dam, f_dam)
			else if (def_zone == "chest")
				if (b_dam && ((istype(H.wear_suit, /obj/item/clothing/suit/armor/)) && H.wear_suit.body_parts_covered & UPPER_TORSO) && prob(90 - src.force))
					H.show_message("\red You have been protected from a hit to the chest.")
					return
				if (b_dam && ((istype(H.r_hand, /obj/item/weapon/shield/riot))) && prob(90 - src.force))
					H.show_message("\red You have been protected from a hit to the chest.")
					return
				if (b_dam && ((istype(H.l_hand, /obj/item/weapon/shield/riot))) && prob(90 - src.force))
					H.show_message("\red You have been protected from a hit to the chest.")
					return
				if ((b_dam && prob(src.force + affecting.brute_dam + affecting.burn_dam)))
					if (prob(50))
						if (H.weakened < 5)
							H.weakened = 5
						for(var/mob/O in viewers(H, null))
							O.show_message(text("\red <B>[] has been knocked down!</B>", H), 1, "\red You hear someone fall.", 2)
					else
						if (H.stunned < 2)
							H.stunned = 2
						for(var/mob/O in viewers(H, null))
							O.show_message(text("\red <B>[] has been stunned!</B>", H), 1)
					if(H.stat != 2)	H.stat = 1
				if (b_dam && prob(25 + (b_dam * 2)))
					src.add_blood(H)
					if (prob(33))
						var/turf/location = H.loc
						if (istype(location, /turf/simulated))
							location.add_blood(H)
					if (H.wear_suit)
						H.wear_suit.add_blood(H)
					if (H.w_uniform)
						H.w_uniform.add_blood(H)
					if (istype(user, /mob/living/carbon/human))
						var/mob/living/carbon/human/user2 = user
						if (user2.gloves)
							user2.gloves.add_blood(H)
						else
							user2.add_blood(H)
						if (prob(15))
							if (user2.wear_suit)
								user2.wear_suit.add_blood(H)
							else if (user2.w_uniform)
								user2.w_uniform.add_blood(H)
				affecting.take_damage(b_dam, f_dam)
			else if (def_zone == "groin")
				if (b_dam && (istype(H.wear_suit, /obj/item/clothing/suit/armor/) && H.wear_suit.body_parts_covered & LOWER_TORSO) && prob(90 - src.force))
					H.show_message("\red You have been protected from a hit to the groin (phew).")
					return
				if (b_dam && ((istype(H.r_hand, /obj/item/weapon/shield/riot))) && prob(90 - src.force))
					H.show_message("\red You have been protected from a hit to the groin (phew).")
					return
				if (b_dam && ((istype(H.l_hand, /obj/item/weapon/shield/riot))) && prob(90 - src.force))
					H.show_message("\red You have been protected from a hit to the groin (phew).")
					return
				if ((b_dam && prob(30)))
					if (prob(50))
						if (H.weakened < 5)
							H.weakened = 5
			//				M.achievement_give("Ow My Balls!", 25, 30)
						for(var/mob/O in viewers(H, null))
							O.show_message(text("\red <B>[] has been knocked down!</B>", H), 1, "\red You hear someone fall.", 2)
					else
						if (H.stunned < 2)
							H.stunned = 2
			//				M.achievement_give("Ow My Balls!", 25, 30)
						for(var/mob/O in viewers(H, null))
							O.show_message(text("\red <B>[] has been stunned!</B>", H), 1)
						if(H.stat != 2)	H.stat = 1
					if (b_dam && prob(25 + (b_dam * 2)))
						src.add_blood(H)
						if (prob(33))
							var/turf/location = H.loc
							if (istype(location, /turf/simulated))
								location.add_blood(H)
						if (H.wear_suit)
							H.wear_suit.add_blood(H)
						if (H.w_uniform)
							H.w_uniform.add_blood(H)
						if (istype(user, /mob/living/carbon/human))
							var/mob/living/carbon/human/user2 = user
							if (user2.gloves)
								user2.gloves.add_blood(H)
							else
								user2.add_blood(H)
							if (prob(15))
								if (user2.wear_suit)
									user2.wear_suit.add_blood(H)
								else if (user2.w_uniform)
									user2.w_uniform.add_blood(H)
					affecting.take_damage(b_dam, f_dam)
			else
				if (b_dam && prob(25 + (b_dam * 2)))
					src.add_blood(H)
					if (prob(33))
						var/turf/location = H.loc
						if (istype(location, /turf/simulated))
							location.add_blood(H)
					if (H.wear_suit)
						H.wear_suit.add_blood(H)
					if (H.w_uniform)
						H.w_uniform.add_blood(H)
					if (istype(user, /mob/living/carbon/human))
						var/mob/living/carbon/human/user2 = user
						if (user2.gloves)
							user2.gloves.add_blood(H)
						else
							user2.add_blood(H)
						if (prob(15))
							if (user2.wear_suit)
								user2.wear_suit.add_blood(H)
							else if (user2.w_uniform)
								user2.w_uniform.add_blood(H)
				affecting.take_damage(b_dam, f_dam)
		H.UpdateDamageIcon()
	else
		switch(src.damtype)
			if("brute")
				M.bruteloss += power
				if (prob(33)) // Added blood for whacking non-humans too
					var/turf/location = M.loc
					if (istype(location, /turf/simulated))
						location.add_blood_floor(M)
			if("fire")
				if (!(M.mutations & 2))
					M.fireloss += power
					M << "Aargh it burns!"
		M.updatehealth()
	src.add_fingerprint(user)
	return 1



