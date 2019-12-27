/mob/living/carbon/Move(NewLoc, direct)
	. = ..()
	if(.)
		if(src.nutrition && src.stat != 2)
			src.nutrition -= HUNGER_FACTOR/10
			if(src.m_intent == "run")
				src.nutrition -= HUNGER_FACTOR/10
		if(src.mutations & FAT && src.m_intent == "run" && src.bodytemperature <= 360)
			src.bodytemperature += 2

/mob/living/carbon/relaymove(var/mob/user, direction)
	if(user in src.stomach_contents)
		if(prob(40))
			for(var/mob/M in hearers(4, src))
				if(M.client)
					M.show_message(text("\red You hear something rumbling inside [src]'s stomach..."), 2)
			var/obj/item/I = user.equipped()
			if(I && I.force)
				var/d = rand(round(I.force / 4), I.force)
				if(istype(src, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = src
					var/organ = H.organs["chest"]
					if (istype(organ, /datum/organ/external))
						var/datum/organ/external/temp = organ
						temp.take_damage(d, 0)
					H.UpdateDamageIcon()
					H.updatehealth()
				else
					src.take_organ_damage(d)
				for(var/mob/M in viewers(user, null))
					if(M.client)
						M.show_message(text("\red <B>[user] attacks [src]'s stomach wall with the [I.name]!"), 2)
				playsound(user.loc, 'attackblob.ogg', 50, 1)

				if(prob(src.bruteloss - 50))
					src.gib()

/mob/living/carbon/gib(give_medal)
	for(var/mob/M in src)
		if(M in src.stomach_contents)
			src.stomach_contents.Remove(M)
		M.loc = src.loc
		for(var/mob/N in viewers(src, null))	/* BRUTAL ANAL RAPE */
			if(N.client)
				N.show_message(text("\red <B>[M] bursts out of [src]!</B>"), 2)
	. = ..(give_medal)

/mob/living/carbon/attack_hand(mob/M as mob)
	if(!istype(M, /mob/living/carbon)) return

	for(var/datum/disease/D in viruses)
		var/s_spread_type
		if(D.spread_type!=SPECIAL && D.spread_type!=AIRBORNE)
			s_spread_type = D.spread_type
			D.spread_type = CONTACT_HANDS
			M.contract_disease(D)
			D.spread_type = s_spread_type

	for(var/datum/disease/D in M.viruses)
		var/s_spread_type
		if(D.spread_type!=SPECIAL && D.spread_type!=AIRBORNE)
			s_spread_type = D.spread_type
			D.spread_type = CONTACT_HANDS
			contract_disease(D)
			D.spread_type = s_spread_type

	/*		// old code: doesn't support multiple viruses
	if(src.virus || M.virus)
		var/s_spread_type
		if(src.virus && src.virus.spread_type!=SPECIAL && src.virus.spread_type!=AIRBORNE)
			s_spread_type = src.virus.spread_type
			src.virus.spread_type = CONTACT_HANDS
			M.contract_disease(src.virus)
			src.virus.spread_type = s_spread_type

		if(M.virus && M.virus.spread_type!=SPECIAL && M.virus.spread_type!=AIRBORNE)
			s_spread_type = M.virus.spread_type
			M.virus.spread_type = CONTACT_GENERAL
			src.contract_disease(M.virus)
			M.virus.spread_type = s_spread_type
	*/
	return


/mob/living/carbon/attack_paw(mob/M as mob)
	if(!istype(M, /mob/living/carbon)) return


	for(var/datum/disease/D in viruses)
		var/s_spread_type
		if(D.spread_type!=SPECIAL && D.spread_type!=AIRBORNE)
			s_spread_type = D.spread_type
			D.spread_type = CONTACT_HANDS
			M.contract_disease(D)
			D.spread_type = s_spread_type

	for(var/datum/disease/D in M.viruses)
		var/s_spread_type
		if(D.spread_type!=SPECIAL && D.spread_type!=AIRBORNE)
			s_spread_type = D.spread_type
			D.spread_type = CONTACT_HANDS
			contract_disease(D)
			D.spread_type = s_spread_type

	/*

	if(src.virus || M.virus)
		var/s_spread_type
		if(src.virus && src.virus.spread_type!=SPECIAL && src.virus.spread_type!=AIRBORNE)
			s_spread_type = src.virus.spread_type
			src.virus.spread_type = CONTACT_HANDS
			M.contract_disease(src.virus)
			src.virus.spread_type = s_spread_type

		if(M.virus && M.virus.spread_type!=SPECIAL && M.virus.spread_type!=AIRBORNE)
			s_spread_type = M.virus.spread_type
			M.virus.spread_type = CONTACT_GENERAL
			src.contract_disease(M.virus)
			M.virus.spread_type = s_spread_type
	*/
	return

/mob/living/carbon/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0)
	if(src:nodamage) return
	shock_damage *= siemens_coeff
	if (shock_damage<1)
		return 0
	if(src:mutations & 16384)
		src.heal_overall_damage(shock_damage,shock_damage)
		src << "\blue <b>Aaaaaaah! You feel much better!"
		return

	src.take_overall_damage(0,shock_damage)
	//src.burn_skin(shock_damage)
	//src.fireloss += shock_damage //burn_skin will do this for us
	//src.updatehealth()
	src.visible_message(
		"\red [src] was shocked by the [source]!", \
		"\red <B>You feel a powerful shock course through your body!</B>", \
		"\red You hear a heavy electrical crack." \
	)
	if(src.stunned < shock_damage)	src.stunned = shock_damage
	if(src.weakened < 20*siemens_coeff)	src.weakened = 20*siemens_coeff

	return shock_damage


/mob/living/carbon/proc/swap_hand()
	var/obj/item/item_in_hand = src.get_active_hand()
	if(item_in_hand) //this segment checks if the item in your hand is twohanded.
		if(item_in_hand.twohanded == 1)
			if(item_in_hand.wielded == 1)
				usr << text("Your other hand is too busy holding the []",item_in_hand.name)
				return
	src.hand = !( src.hand )
	if (!( src.hand ))
		src.hands.dir = NORTH
	else
		src.hands.dir = SOUTH
	return

/mob/living/carbon/proc/help_shake_act(mob/living/carbon/M)
	if (src.health > 0)
		var/t_him = "it"
		if (src.gender == MALE)
			t_him = "him"
		else if (src.gender == FEMALE)
			t_him = "her"
		if (istype(src,/mob/living/carbon/human) && src:w_uniform)
			var/mob/living/carbon/human/H = src
			H.w_uniform.add_fingerprint(M)
		src.sleeping = 0
		src.resting = 0
		if (src.paralysis >= 3) src.paralysis -= 3
		if (src.stunned >= 3) src.stunned -= 3
		if (src.weakened >= 3) src.weakened -= 3
		playsound(src.loc, 'thudswoosh.ogg', 50, 1, -1)
		if (src.paralysis || src.stunned || src.weakened || src.sleeping || src.resting)
			for(var/mob/O in viewers(src, null))
				O.show_message("\blue [M.name] shakes [src.name] trying to wake [t_him] up!", 1)
		else
			if(src.stat == 2)
				M << "\red [src.name] is dead!"
			else
				for(var/mob/O in viewers(src, null))
					O.show_message("\blue [M.name] gently caresses [src.name].", 1)
				if(prob(5))
					if(prob(5))
						src.emote("blush")
				if(prob(3))
					if(prob(7)) // let's get it on
						if(M.gender == "male" && M.homosexual && src.gender == "male")
							src.turnedon = 1
							src.emote("moan")
						if(M.gender == "male" && src.gender == "male" && M.homosexual)
							src.turnedon = 1
							src.emote("moan")
						if(M.gender == "female" && src.gender == "female" && M.homosexual)
							src.turnedon = 1
							src.emote("moan")
						if(M.gender == "female" && src.gender != "female" && !M.homosexual)
							src.turnedon = 1
							src.emote("moan")

