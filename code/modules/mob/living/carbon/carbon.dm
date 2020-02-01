/mob/living/carbon/Move(NewLoc, direct)
	. = ..()
	if(.)
		if(src.mutations & 32 && src.m_intent == "run" && src.bodytemperature <= 360)
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
					src.bruteloss += d
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
		for(var/mob/N in viewers(src, null))
			if(N.client)
				N.show_message(text("\red <B>[M] bursts out of [src]!</B>"), 2)
	. = ..(give_medal)


/mob/living/carbon/attack_hand(mob/M as mob)
	if(!istype(M, /mob/living/carbon)) return
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
	return


/mob/living/carbon/attack_paw(mob/M as mob)
	if(!istype(M, /mob/living/carbon)) return
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
	return

/mob/living/carbon/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0)
	shock_damage *= siemens_coeff
	if (shock_damage<1)
		return 0
	src.burn_skin(shock_damage)
	//src.fireloss += shock_damage //burn_skin will do this for us
	//src.updatehealth()
	src.visible_message(
		"\red [src] was shocked by the [source]!", \
		"\red <B>You feel a powerful shock course through your body!</B>", \
		"\red You hear a heavy electrical crack." \
	)
	if(prob(1))
		new /obj/decal/cleanable/urine(src.loc)
		src.achievement_give("Danger Danger! High Voltage!", 16, 70)
	if(src.stunned < shock_damage)	src.stunned = shock_damage
	if(src.weakened < 20*siemens_coeff)	src.weakened = 20*siemens_coeff

	return shock_damage