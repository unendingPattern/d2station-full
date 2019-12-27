/*
CONTAINS:
SWORD
BLADE
AXE
STUN BATON
*/




// SWORD
/obj/item/weapon/sword/attack(mob/target as mob, mob/user as mob)
	if(istype(target, /mob/living))
		target:fireloss += 20
		if(ishuman(target) && prob(40))
			target:removePart(pick("hand_right", "hand_left", "arm_right", "arm_left", "leg_right", "leg_left", "foot_right", "foot_left", "head"))
			target.visible_message("\red <B>[user] lops a limb from [target]!</B>")
	..()

/obj/item/weapon/melee/energy/sword/New()
	color = pick("red","blue","green","purple")

/obj/item/weapon/melee/energy/sword/attack_self(mob/living/user as mob)
	if ((user.mutations & CLOWN) && prob(50))
		user << "\red You accidentally cut yourself with [src]."
		user.take_organ_damage(5,5)
	active = !active
	if (active)
		force = 30
		if(istype(src,/obj/item/weapon/melee/energy/sword/pirate))
			icon_state = "cutlass1"
		else
			icon_state = "sword[color]"
		w_class = 4
		playsound(user, 'saberon.ogg', 50, 1)
		user << "\blue [src] is now active."
	else
		force = 3
		if(istype(src,/obj/item/weapon/melee/energy/sword/pirate))
			icon_state = "cutlass0"
		else
			icon_state = "sword0"
		w_class = 2
		playsound(user, 'saberoff.ogg', 50, 1)
		user << "\blue [src] can now be concealed."
	add_fingerprint(user)
	return

/obj/item/weapon/melee/energy/sword/green
	New()
		color = "green"

/obj/item/weapon/melee/energy/sword/red
	New()
		color = "red"


// BLADE
//Most of the other special functions are handled in their own files.

/obj/item/weapon/melee/energy/blade/New()
	spark_system = new /datum/effects/system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	return

/obj/item/weapon/melee/energy/blade/dropped()
	del(src)
	return

/obj/item/weapon/melee/energy/blade/proc/throw()
	del(src)
	return

// AXE

/obj/item/weapon/melee/energy/axe/attack(target as mob, mob/user as mob)
	..()

/obj/item/weapon/melee/energy/axe/attack_self(mob/user as mob)
	src.active = !( src.active )
	if (src.active)
		user << "\blue The axe is now energised."
		src.force = 150
		src.icon_state = "axe1"
		src.w_class = 5
	else
		user << "\blue The axe can now be concealed."
		src.force = 40
		src.icon_state = "axe0"
		src.w_class = 5
	src.add_fingerprint(user)
	return

// STUN BATON

/obj/item/weapon/melee/baton/update_icon()
	if(src.status)
		if(src.penis)
			icon_state = "dildobaton_active"
		else
			icon_state = "stunbaton_active"
	else
		if(src.penis)
			icon_state = "dildobaton"
		else
			icon_state = "stunbaton"

/obj/item/weapon/melee/baton/attack_self(mob/user as mob)
	src.status = !( src.status )
	if ((usr.mutations & CLOWN) && prob(50))
		usr << "\red You grab the stunbaton on the wrong side."
		usr.paralysis += 60
		if(prob(5))
			usr.emote(pick("pee","poo","vomit","cum"))
		return
	if (src.status)
		user << "\blue The baton is now on."
		playsound(src.loc, "sparks", 75, 1, -1)
	else
		user << "\blue The baton is now off."
		playsound(src.loc, "sparks", 75, 1, -1)

	update_icon()
	src.add_fingerprint(user)
	return

/obj/item/weapon/melee/baton/attackby(obj/item/weapon/storage/cock/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/storage/cock))
		src.penis = 1
		src.name = "double ended dildo"
		update_icon()
		del(W)
	return

/obj/item/weapon/melee/baton/attack(mob/M as mob, mob/user as mob)
	if ((usr.mutations & CLOWN) && prob(50))
		usr << "\red You grab the stunbaton on the wrong side."
		if(prob(5))
			usr << "\red You release your bodily fluids!"
			usr.emote(pick("pee","poo","vomit","cum"))
		usr.weakened += 30
		return
	src.add_fingerprint(user)
	var/mob/living/carbon/human/H = M

	M.attack_log += text("<font color='orange'>[world.time] - has been attacked with [src.name] by [user.name] ([user.ckey])</font>")
	user.attack_log += text("<font color='red'>[world.time] - has used the [src.name] to attack [M.name] ([M.ckey])</font>")


	if (status == 0 || (status == 1 && charges ==0))
		if(user.a_intent == "hurt")
			if(!..()) return
			/*if (!istype(H:r_hand, /obj/item/weapon/shield/riot) && prob(40))
				for(var/mob/O in viewers(M, null))
					if (O.client)	O.show_message(text("\red <B>[] has blocked []'s stun baton with the riot shield!</B>", M, user), 1, "\red You hear a cracking sound", 2)
				return
			if (!istype(H:l_hand, /obj/item/weapon/shield/riot) && prob(40))
				for(var/mob/O in viewers(M, null))
					if (O.client)	O.show_message(text("\red <B>[] has blocked []'s stun baton with the riot shield!</B>", M, user), 1, "\red You hear a cracking sound", 2)
				return*/
			if (M.weakened < 5 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
				M.weakened = 5
			for(var/mob/O in viewers(M))
				user:harmbatons++
				if (user:harmbatons <= 3)
					//user:gib()
					//message_admins("[key_name(user)] got autogibbed for being quality security!", 1)
					message_admins("[key_name(user)] is being shitcurity!", 1) //while it was a good idea to punish people Soyuz, gibbing unsuspecting assistants who are beating down security is not the way to go. -Nernums
				if (O.client)	O.show_message("\red <B>[M] has been beaten with the stun baton by [user]!</B>", 1)
				if(prob(5))
					O << "\red You release your bodily fluids!"
					O.emote(pick("pee","poo","vomit","cum"))
				if(prob(2))
					user.turnedon = 1
					user.emote(pick("blush", "moan"))
			if(status == 1 && charges == 0)
				user << "\red Not enough charge"
			return
		else
			for(var/mob/O in viewers(M))
				if (O.client)	O.show_message("\red <B>[M] has been prodded with the stun baton by [user]! Luckily it was off.</B>", 1)
			M << "\red You release your bodily fluids!"
			M.emote(pick("pee","poo","vomit","cum"))
			if(prob(2))
				user.turnedon = 1
				user.emote(pick("blush", "moan"))
			if(status == 1 && charges == 0)
				user << "\red Not enough charge"
			return
	if((charges > 0 && status == 1) && (istype(H, /mob/living/carbon)))

		flick("baton_active", src)
		if (user.a_intent == "hurt")
			if(!..()) return
		/*	if (!istype(H:r_hand, /obj/item/weapon/shield/riot) && prob(40))
				for(var/mob/O in viewers(M, null))
					if (O.client)	O.show_message(text("\red <B>[] has blocked []'s stun baton with the riot shield!</B>", M, user), 1, "\red You hear a cracking sound", 2)
				return
			if (!istype(H:l_hand, /obj/item/weapon/shield/riot) && prob(40))
				for(var/mob/O in viewers(M, null))
					if (O.client)	O.show_message(text("\red <B>[] has blocked []'s stun baton with the riot shield!</B>", M, user), 1, "\red You hear a cracking sound", 2)
				return*/
			playsound(src.loc, 'Genhit.ogg', 50, 1, -1)
			if(isrobot(user))
				var/mob/living/silicon/robot/R = user
				R.cell.charge -= 20
			else
				charges--
			if (M.weakened < 1 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
				M.weakened += 35
			if (M.stuttering < 1 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
				M.stuttering += 35
			if (M.stunned < 1 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
				M.stunned += 35
		else
		/*	if (!istype(H:r_hand, /obj/item/weapon/shield/riot) && prob(40))
				for(var/mob/O in viewers(M, null))
					if (O.client)	O.show_message(text("\red <B>[] has blocked []'s stun baton with the riot shield!</B>", M, user), 1, "\red You hear a cracking sound", 2)
				return
			if (!istype(H:l_hand, /obj/item/weapon/shield/riot) && prob(40))
				for(var/mob/O in viewers(M, null))
					if (O.client)	O.show_message(text("\red <B>[] has blocked []'s stun baton with the riot shield!</B>", M, user), 1, "\red You hear a cracking sound", 2)
				return*/
			playsound(src.loc, 'Egloves.ogg', 50, 1, -1)
			if(isrobot(user))
				var/mob/living/silicon/robot/R = user
				R.cell.charge -= 20
			else
				charges--
			if (M.weakened < 10 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
				M.weakened += 45
			if (M.stuttering < 10 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
				M.stuttering += 45
			if (M.stunned < 10 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
				M.stunned += 45
			user.lastattacked = M
			M.lastattacker = user
		for(var/mob/O in viewers(M))
			if (O.client)	O.show_message("\red <B>[M] has been stunned with the stun baton by [user]!</B>", 1, "\red You hear someone fall", 2)
		if(prob(5))
			M.emote(pick("pee","poo","vomit","cum"))
			usr << "\red You release your bodily fluids!"
		if(prob(2))
			user.turnedon = 1
			user.emote(pick("blush", "moan"))

/obj/item/weapon/melee/baton/emp_act(severity)
	switch(severity)
		if(1)
			src.charges = 0
		if(2)
			charges -= 5

/obj/item/weapon/melee/classic_baton/attack(mob/M as mob, mob/living/user as mob)
	if ((user.mutations & CLOWN) && prob(50))
		user << "\red You club yourself over the head."
		user.weakened = max(3 * force, user.weakened)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.TakeDamage("head", 2 * force, 0)
		else
			user.take_organ_damage(2*force)
		return
	src.add_fingerprint(user)

	M.attack_log += text("<font color='orange'>[world.time] - has been attacked with [src.name] by [user.name] ([user.ckey])</font>")
	user.attack_log += text("<font color='red'>[world.time] - has used the [src.name] to attack [M.name] ([M.ckey])</font>")

	if (user.a_intent == "hurt")
		if(!..()) return
		playsound(src.loc, "swing_hit", 50, 1, -1)
		if (M.weakened < 8 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
			M.weakened = 8
		if (M.stuttering < 8 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
			M.stuttering = 8
		if (M.stunned < 8 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
			M.stunned = 8
		for(var/mob/O in viewers(M))
			if (O.client)	O.show_message("\red <B>[M] has been beaten with the police baton by [user]!</B>", 1, "\red You hear someone fall", 2)
	else
		playsound(src.loc, 'Genhit.ogg', 50, 1, -1)
		if (M.weakened < 5 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
			M.weakened = 5
		if (M.stunned < 5 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
			M.stunned = 5
		for(var/mob/O in viewers(M))
			if (O.client)	O.show_message("\red <B>[M] has been stunned with the police baton by [user]!</B>", 1, "\red You hear someone fall", 2)
