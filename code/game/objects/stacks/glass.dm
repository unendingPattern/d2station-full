/*
CONTAINS:
GLASS SHEET
REINFORCED GLASS SHEET
SHARDS

*/

/proc/construct_window(mob/usr as mob, obj/item/stack/sheet/src as obj)
	if (!( istype(usr.loc, /turf/simulated) ))
		return
	if ( ! (istype(usr, /mob/living/carbon/human) || \
			istype(usr, /mob/living/silicon) || \
			istype(usr, /mob/living/carbon/monkey) && ticker && ticker.mode.name == "monkey") )
		usr << "\red You don't have the dexterity to do this!"
		return 1
	var/reinf = istype(src, /obj/item/stack/sheet/rglass)
	var/title = reinf?"Sheet Reinf. Glass":"Sheet-Glass"
	title += " ([src.amount] sheet\s left)"
	switch(alert(title, "Would you like full tile glass or one direction?", "one direct", "full (2 sheets)", "cancel", null))
		if("one direct")
			if (src.amount < 1)
				return 1
			var/list/directions = new/list(cardinal)
			for (var/obj/window/win in usr.loc)
				directions-=win.dir
				if(!(win.ini_dir in cardinal))
					usr << "\red Can't let you do that."
					return 1
			var/dir_to_set = 2
			//yes, this could probably be done better but hey... it works...
			for(var/obj/window/WT in usr.loc)
				if (WT.dir == dir_to_set)
					dir_to_set = 4
			for(var/obj/window/WT in usr.loc)
				if (WT.dir == dir_to_set)
					dir_to_set = 1
			for(var/obj/window/WT in usr.loc)
				if (WT.dir == dir_to_set)
					dir_to_set = 8
			for(var/obj/window/WT in usr.loc)
				if (WT.dir == dir_to_set)
					dir_to_set = 2
			var/obj/window/W
			if(reinf)
				W = new /obj/window/reinforced( usr.loc, reinf )
				W.state = 0
			else
				W = new /obj/window/basic( usr.loc, reinf )
			W.dir = dir_to_set
			W.ini_dir = W.dir
			W.anchored = 0
			src.use(1)
		if("full (2 sheets)")
			if (src.amount < 2)
				return 1
			if (locate(/obj/window) in usr.loc)
				usr << "\red Can't let you do that."
				return 1
			var/obj/window/W
			if(reinf)
				W = new /obj/window/reinforced( usr.loc, reinf )
				W.state = 0
			else
				W = new /obj/window/basic( usr.loc, reinf )
			W.dir = SOUTHWEST
			W.ini_dir = SOUTHWEST
			W.anchored = 0
			src.use(2)
		else
			//do nothing
	return

// GLASS

/obj/item/stack/sheet/glass/attack_self(mob/user as mob)
	construct_window(usr, src)

/obj/item/stack/sheet/glass/attackby(obj/item/W, mob/user)
	..()
	if(istype(W,/obj/item/weapon/cable_coil))
		var/obj/item/weapon/cable_coil/CC = W
		if(CC.amount < 5)
			user << "\b There is not enough wire in this coil. You need 5 lengths."
		CC.amount -= 5
		amount -= 1
		user << "\blue You attach wire to the [name]."
		new/obj/item/stack/light_w(user.loc)
		if(CC.amount <= 0)
			user.u_equip(CC)
			del(CC)
		if(src.amount <= 0)
			user.u_equip(src)
			del(src)
	else if( istype(W, /obj/item/stack/rods) )
		var/obj/item/stack/rods/V  = W
		var/obj/item/stack/sheet/rglass/RG = new (user.loc)
		RG.add_fingerprint(user)
		RG.add_to_stacks(user)
		V.use(1)
		var/obj/item/stack/sheet/glass/G = src
		src = null
		var/replace = (user.get_inactive_hand()==G)
		G.use(1)
		if (!G && !RG && replace)
			user.put_in_hand(RG)
	else
		return ..()


// REINFORCED GLASS

/obj/item/stack/sheet/rglass/attack_self(mob/user as mob)
	construct_window(usr, src)






// SHARDS

/obj/item/weapon/shard/Bump()

	spawn( 0 )
		if (prob(20))
			src.force = 15
		else
			src.force = 4
		..()
		return
	return

/obj/item/weapon/shard/New()

	//****RM
	//world<<"New shard at [x],[y],[z]"

	src.icon_state = pick("large", "medium", "small")
	switch(src.icon_state)
		if("small")
			src.pixel_x = rand(1, 18)
			src.pixel_y = rand(1, 18)
		if("medium")
			src.pixel_x = rand(1, 16)
			src.pixel_y = rand(1, 16)
		if("large")
			src.pixel_x = rand(1, 10)
			src.pixel_y = rand(1, 5)
		else
	return

/obj/item/weapon/shard/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if ( istype(W, /obj/item/weapon/weldingtool) && W:welding )
		W:eyecheck(user)
		new /obj/item/stack/sheet/glass( user.loc )
		//SN src = null
		del(src)
		return
	return ..()

/obj/item/weapon/shard/HasEntered(AM as mob|obj)
	if(ismob(AM))
		var/mob/M = AM
		M << "\red <B>You step in the broken glass!</B>"
		playsound(src.loc, 'glass_step.ogg', 50, 1)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(!H.shoes)
				var/datum/organ/external/affecting = H.organs[pick("l_foot", "r_foot")]
				H.weakened = max(3, H.weakened)
				affecting.take_damage(5, 0)
				H.UpdateDamageIcon()
				H.updatehealth()
	..()

// MOLTEN GLASS

/obj/item/stack/sheet/molten_glass
	name = "molten glass"
	icon = 'scrap.dmi'
	icon_state = "moltenglass"
	force = 5.0
	throwforce = 5
	w_class = 3.0
	throw_speed = 3
	throw_range = 3
	origin_tech = "materials=1"
	perunit = 1750

/obj/item/stack/sheet/molten_glass/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/weapon/weldingtool) && W:welding)
		if(W:remove_fuel(0,user))
			var/obj/item/stack/sheet/glass/new_item = new(usr.loc)
			new_item.amount = src.amount
			for (var/mob/M in viewers(src))
				M.show_message("\red [src] is shaped into glass sheets by [user.name] with the weldingtool.", 3, "\red You hear welding.", 2)
			var/obj/item/stack/sheet/molten_glass/R = src
			src = null
			var/replace = (user.get_inactive_hand()==R)
			R.use(2)
			if (!R && replace)
				user.put_in_hand(new_item)
		return
	..()