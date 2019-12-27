
/obj/item/device/flash/attack(mob/living/carbon/M as mob, mob/user as mob)
	if ((usr.mutations & CLOWN) && prob(50))
		usr << "\red The Flash slips out of your hand."
		usr.drop_item()
		return
	if (src.shots > 0)
		M.attack_log += text("<font color='orange'>[world.time] - has been flashed (attempt) with [src.name]  by [user.name] ([user.ckey])</font>")
		user.attack_log += text("<font color='red'>[world.time] - has used the [src.name] to flash [M.name] ([M.ckey])</font>")

		var/safety = null
		if (istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if (istype(H.glasses, /obj/item/clothing/glasses/sunglasses))
				safety = 1
			if (istype(H.head, /obj/item/clothing/head/helmet/welding))
				if(!H.head:up)
					safety = 1
			if (istype(H.wear_mask, /obj/item/clothing/mask/gas/voice))
				safety = 1
		if (istype(M, /mob/living/carbon/alien))//So aliens don't get flashed (they have no external eyes)/N
			safety = 1
		if (isrobot(user))
			spawn(0)
				var/atom/movable/overlay/animation = new(user.loc)
				animation.layer = user.layer + 1
				animation.icon_state = "blank"
				animation.icon = 'mob.dmi'
				animation.master = user
				flick("blspell", animation)
				sleep(5)
				del(animation)
		if (!( safety ))
			if (M.client)//Probably here to prevent forced conversion of dced players. /N
				if (status == 0)
					user << "\red The bulb has been burnt out!"
					return
				if (!( safety ) && status == 1)
					playsound(src.loc, 'flash.ogg', 100, 1)
					if(!(M.mutations & HULK))  M.weakened = 10
					if (prob(10))
						status = 0
						user << "\red The bulb has burnt out!"
						return
					if ((M.eye_stat > 15 && prob(M.eye_stat + 50)))
						flick("e_flash", M.flash)
						M.eye_stat += rand(1, 2)
					else
						flick("flash", M.flash)
						M.eye_stat += rand(0, 2)
					if (M.eye_stat >= 20)
						M << "\red You eyes start to burn badly!"
						M.disabilities |= 1
						if (prob(M.eye_stat - 20 + 1))
							M << "\red You go blind!"
							M.sdisabilities |= 1
					if(/*ticker.mode.name == "revolution" && */ istype(M, /mob/living/carbon))
						if(user.mind in ticker.mode.head_revolutionaries)
							ticker.mode.add_revolutionary(M.mind)

					for(var/mob/O in viewers(user, null))
						if(status == 1)
							O.show_message(text("\red [] blinds [] with the flash!", user, M))
		else
			for(var/mob/O in viewers(user, null))
				if(status == 1)
					O.show_message(text("\blue [] fails to blind [] with the flash!", user, M))
	src.attack_self(user, 1)
	return

/obj/item/device/flash/attack_self(mob/living/carbon/user as mob, flag = 0, emp = 0)
	if (emp)

	else if ((usr.mutations & CLOWN) && prob(50))
		usr << "\red The Flash slips out of your hand."
		usr.drop_item()
		return
	else if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	if ( world.time > (src.l_time + 600))
		src.shots = 5
	if (src.shots < 1)
		user.show_message("\red *click* *click*", 2)
		return

	src.l_time = world.time
	add_fingerprint(user)
	src.shots--
	playsound(src.loc, 'flash.ogg', 100, 1)
	flick("flash2", src)
	if(isrobot(user))
		spawn(0)
			var/atom/movable/overlay/animation = new(user.loc)
			animation.layer = user.layer + 1
			animation.icon_state = "blank"
			animation.icon = 'mob.dmi'
			animation.master = user
			flick("blspell", animation)
			sleep(5)
			del(animation)
	if (!( flag ))
		for(var/mob/living/carbon/M in oviewers(3, null))
			if (prob(50))
				if (locate(/obj/item/weapon/cloaking_device, M))
					for(var/obj/item/weapon/cloaking_device/S in M)
						S.active = 0
						S.icon_state = "shield0"
			if (M.client)
				var/safety = null
				if (istype(M, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = M
					if (istype(H.glasses, /obj/item/clothing/glasses/sunglasses))
						safety = 1
					if (istype(H.head, /obj/item/clothing/head/helmet/welding))
						if(!H.head:up)
							safety = 1
				if (istype(M, /mob/living/carbon/alien))//So aliens don't see those annoying flash screens.
					safety = 1
				if (!( safety ))
					flick("flash", M.flash)

/obj/item/device/flash/emp_act(severity)
	src.attack_self(null,1,1)
	..()
