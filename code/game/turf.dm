/turf/DblClick()
	if(istype(usr, /mob/living/silicon/ai))
		return move_camera_by_click()
	if(usr.stat || usr.restrained() || usr.lying)
		return ..()

	if(usr.hand && istype(usr.l_hand, /obj/item/weapon/flamethrower))
		var/turflist = getline(usr,src)
		var/obj/item/weapon/flamethrower/F = usr.l_hand
		F.flame_turf(turflist)
		..()
	else if(!usr.hand && istype(usr.r_hand, /obj/item/weapon/flamethrower))
		var/turflist = getline(usr,src)
		var/obj/item/weapon/flamethrower/F = usr.r_hand
		F.flame_turf(turflist)
		..()
	//else

	return ..()

/turf/New()
	..()
	for(var/atom/movable/AM as mob|obj in src)
		spawn( 0 )
			src.Entered(AM)
			return
	return

/turf/Enter(atom/movable/mover as mob|obj, atom/forget as mob|obj|turf|area)
	if (!mover || !isturf(mover.loc))
		return 1


	//First, check objects to block exit that are not on the border
	for(var/obj/obstacle in mover.loc)
		if((obstacle.flags & ~ON_BORDER) && (mover != obstacle) && (forget != obstacle))
			if(!obstacle.CheckExit(mover, src))
				mover.Bump(obstacle, 1)
				return 0

	//Now, check objects to block exit that are on the border
	for(var/obj/border_obstacle in mover.loc)
		if((border_obstacle.flags & ON_BORDER) && (mover != border_obstacle) && (forget != border_obstacle))
			if(!border_obstacle.CheckExit(mover, src))
				mover.Bump(border_obstacle, 1)
				return 0

	//Next, check objects to block entry that are on the border
	for(var/obj/border_obstacle in src)
		if(border_obstacle.flags & ON_BORDER)
			if(!border_obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != border_obstacle))
				mover.Bump(border_obstacle, 1)
				return 0

	//Then, check the turf itself
	if (!src.CanPass(mover, src))
		mover.Bump(src, 1)
		return 0

	//Finally, check objects/mobs to block entry that are not on the border
	for(var/atom/movable/obstacle in src)
		if(obstacle.flags & ~ON_BORDER)
			if(!obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != obstacle))
				mover.Bump(obstacle, 1)
				return 0
	return 1 //Nothing found to block so return success!


/turf/Entered(atom/movable/M as mob|obj)
	if(ismob(M) && !istype(src, /turf/space))
		var/mob/tmob = M
		tmob.inertia_dir = 0
	..()
	// Clowns have it rough enough, disabling their slipping -- TLE
	/*
	if(prob(1) && ishuman(M))
		var/mob/living/carbon/human/tmob = M
		if (!tmob.lying && istype(tmob.shoes, /obj/item/clothing/shoes/clown_shoes))
			if(istype(tmob.head, /obj/item/clothing/head/helmet))
				tmob << "\red You stumble and fall to the ground. Thankfully, that helmet protected you."
				tmob.weakened = max(rand(1,2), tmob.weakened)
			else
				tmob << "\red You stumble and hit your head."
				tmob.weakened = max(rand(3,10), tmob.weakened)
				tmob.stuttering = max(rand(0,3), tmob.stuttering)
				tmob.make_dizzy(150)
	*/

	// Kitties have it rough enough, disabling their slipping -- erika (also I removed all the kitty ears from the store and the ones in the swagomatic are expensive as FUCK)
	// no they don't --soyuz

	if(prob(1) && ishuman(M))
		var/mob/living/carbon/human/tmob = M
		if (!tmob.lying && istype(tmob.head, /obj/item/clothing/head/kitty))
			M.reagents:add_reagent("impedrezene", 2)
			if(istype(tmob.head, /obj/item/clothing/head/kitty))
				tmob << "\red Silly kitty get off the floor!"
				tmob.weakened = max(rand(1,2), tmob.weakened)
			else
				tmob << "\red THISDOESNOTHING."




	if(prob(60) && ishuman(M))
		var/mob/living/carbon/human/tmob = M
		if (istype(tmob.wear_suit, /obj/item/clothing/suit/space/emergency))
			tmob.wear_suit:health -= 1
			if(tmob.wear_suit:health < 1 && tmob.wear_suit.icon_state != "emergencysuit_ripped")
				tmob << "\red The [tmob.wear_suit.name] rips open!"
				tmob.wear_suit.icon_state = "emergencysuit_ripped"
				tmob.wear_suit.item_state = "emergencysuit_ripped"
				tmob.wear_suit.gas_transfer_coefficient = 0.80
				tmob.wear_suit.permeability_coefficient = 1
				tmob.wear_suit.flags = FPRINT | TABLEPASS
				tmob.wear_suit.body_parts_covered = LOWER_TORSO|LEGS|FEET|ARMS|HANDS
				tmob.wear_suit.armor = list(melee = 0, bullet = 0, laser = 2, taser = 2, bomb = 0, bio = 0, rad = 10)
	for(var/atom/A as mob|obj|turf|area in src)
		spawn( 0 )
			if ((A && M))
				A.HasEntered(M, 1)
			return
	for(var/atom/A as mob|obj|turf|area in range(1))
		spawn( 0 )
			if ((A && M))
				A.HasProximity(M, 1)
			return
	return


/turf/proc/levelupdate()
	for(var/obj/O in src)
		if(O.level == 1)
			O.hide(src.intact)
	ul_Recalculate()

// override for space turfs, since they should never hide anything
/turf/space/levelupdate()
	for(var/obj/O in src)
		if(O.level == 1)
			O.hide(0)

/turf/proc/ReplaceWithFloor()
	var/prior_icon = icon_old
	var/old_dir = dir

	var/turf/simulated/floor/W = new /turf/simulated/floor( locate(src.x, src.y, src.z) )

	W.dir = old_dir
	if(prior_icon) W.icon_state = prior_icon
	else W.icon_state = "floor"
	W.opacity = 1
	W.ul_SetOpacity(0)
	W.levelupdate()
	return W

/turf/proc/ReplaceWithPlating()
	var/prior_icon = icon_old
	var/old_dir = dir

	var/turf/simulated/floor/plating/W = new /turf/simulated/floor/plating( locate(src.x, src.y, src.z) )

	W.dir = old_dir
	if(prior_icon) W.icon_state = prior_icon
	else W.icon_state = "plating"
	W.opacity = 1
	W.ul_SetOpacity(0)
	W.levelupdate()
	return W

/turf/proc/ReplaceWithEngineFloor()
	var/old_dir = dir

	var/turf/simulated/floor/engine/E = new /turf/simulated/floor/engine( locate(src.x, src.y, src.z) )

	E.dir = old_dir
	E.icon_state = "engine"

//entered turf that makes clown shoes, normal shoes and butt sounds
/turf/simulated/Entered(atom/A, atom/OL)
	var/footstepsound
	if (istype(A,/mob/living/carbon))
		var/mob/living/carbon/M = A
		if(M.lying)
			return
		if(istype(M, /mob/living/carbon/human))			// Split this into two seperate if checks, when non-humans were being checked it would throw a null error -- TLE
			if(M.cumonstep == 1)
				new /obj/decal/cleanable/cum(M:loc)
			if(M.pooonstep == 1)
				new /obj/decal/cleanable/poo(M:loc)
			if(M.pissonstep == 1)
				new /obj/decal/cleanable/urine(M:loc)


			//clown shoes
			if(istype(M:shoes, /obj/item/clothing/shoes/clown_shoes))
				if(M.m_intent == "run")
					if(M.footstep >= 2)
						M.footstep = 0
					else
						M.footstep++
					if(M.footstep == 0)
						playsound(src, "clownstep", 30, 1) // this will get annoying very fast.
				else
					playsound(src, "clownstep", 10, 1)


			//shoes
			if(istype(src, /turf/simulated/floor/spacedome/grass))
				footstepsound = "grassfootsteps"
			else if(istype(src, /turf/simulated/floor/spacedome/sand))
				footstepsound = "sandfootsteps"
			else if(istype(src, /turf/simulated/floor/spacedome/water))
				footstepsound = "waterfootsteps"
			else if(istype(src, /turf/simulated/floor/spacedome/concrete))
				footstepsound = "concretefootsteps"
			else
				footstepsound = "erikafootsteps"

			if(istype(M:shoes, /obj/item/clothing/shoes))
				if(M.m_intent == "run")
					if(M.footstep >= 2)
						M.footstep = 0
					else
						M.footstep++
					if(M.footstep == 0)
						playsound(src, footstepsound, 30, 1) // this will get annoying very fast.
				else
					playsound(src, footstepsound, 10, 1)

			//butt
			if(istype(M:head, /obj/item/clothing/head/butt))
				if(M.m_intent == "run")
					if(M.footstep >= 2)
						M.footstep = 0
					else
						M.footstep++
					if(M.footstep == 0)
						playsound(src, "buttstep", 50, 1) // this will get annoying very fast.
				else
					playsound(src, "buttstep", 30, 1)

			if(M:key == "lordslowpoke" && prob(15))
				if(M.m_intent == "run")
					if(M.footstep >= 2)
						M.footstep = 0
					else
						M.footstep++
					if(M.footstep == 0 && prob(15))
						playsound(src, "buttstep", 50, 1) // a big fuck you to soyuz and everything he stands for
				else
					playsound(src, "buttstep", 30, 1)


		switch (src.wet)
			if(1)
				if (istype(M, /mob/living/carbon/human)) // Added check since monkeys don't have shoes
					if ((M.m_intent == "run") && !(istype(M:shoes, /obj/item/clothing/shoes) && M:shoes.flags&NOSLIP))
						M.pulling = null
						step(M, M.dir)
						M << "\blue You slipped on the wet floor!"
						M.achievement_give("I Just Cleaned That!", 71)
						playsound(src.loc, 'slip.ogg', 50, 1, -3)
						M.stunned = 1
						M.weakened = 1
					else
						M.inertia_dir = 0
						return
				else if(!istype(M, /mob/living/carbon/metroid))
					if (M.m_intent == "run")
						M.pulling = null
						step(M, M.dir)
						M << "\blue You slipped on the wet floor!"
						M.achievement_give("I Just Cleaned That!", 71)
						playsound(src.loc, 'slip.ogg', 50, 1, -3)
						M.stunned = 8
						M.weakened = 5
					else
						M.inertia_dir = 0
						return
			if(2) //lube
				if(!istype(M, /mob/living/carbon/metroid))
					M.pulling = null
					step(M, M.dir)
					spawn(1) step(M, M.dir)
					spawn(2) step(M, M.dir)
					spawn(3) step(M, M.dir)
					spawn(4) step(M, M.dir)
					M.take_organ_damage(2) // Was 5 -- TLE
					M << "\blue You slipped on the floor!"
					playsound(src.loc, 'slip.ogg', 50, 1, -3)
					M.weakened = 10
			if(3) //honk
				if(!istype(M, /mob/living/carbon/metroid))
					M.pulling = null
					step(M, M.dir)
					spawn(1) step(M, M.dir)
					spawn(2) step(M, M.dir)
					spawn(3) step(M, M.dir)
					spawn(4) step(M, M.dir)
					M << "\blue You honked on the floor!"
					playsound(src.loc, 'bikehorn.ogg', 50, 1, -3)

	..()

/turf/proc/ReplaceWithSpace()
	/*var/old_dir = dir
	var/turf/space/S = new /turf/space( locate(src.x, src.y, src.z) )
	S.dir = old_dir*/
	return 0

/turf/proc/ReplaceWithLattice()
	var/old_dir = dir
	var/turf/space/S = new /turf/space( locate(src.x, src.y, src.z) )
	S.dir = old_dir
	new /obj/lattice( locate(src.x, src.y, src.z) )
	return S

/turf/proc/ReplaceWithWall()
	var/old_icon = icon_state
	var/turf/simulated/wall/S = new /turf/simulated/wall( locate(src.x, src.y, src.z) )
	S.icon_old = old_icon
	S.opacity = 0
	S.ul_SetOpacity(1)
//	Shields.RemoveShield(S)
	return S

/turf/proc/ReplaceWithRWall()
	var/old_icon = icon_state
	var/turf/simulated/wall/r_wall/S = new /turf/simulated/wall/r_wall( locate(src.x, src.y, src.z) )
	S.icon_old = old_icon
	S.opacity = 0
	S.ul_SetOpacity(1)
//	Shields.RemoveShield(S)
	return S

/turf/simulated/wall/New()
	..()

/turf/simulated/wall/proc/dismantle_wall(devastated=0)
	if(istype(src,/turf/simulated/wall/r_wall))
		if(!devastated)
			playsound(src.loc, 'Welder.ogg', 100, 1)
			new /obj/structure/girder/reinforced(src)
			new /obj/item/stack/sheet/r_metal( src )
		else
			new /obj/item/stack/sheet/metal( src )
			new /obj/item/stack/sheet/metal( src )
			new /obj/item/stack/sheet/r_metal( src )
	else
		if(!devastated)
			playsound(src.loc, 'Welder.ogg', 100, 1)
			new /obj/structure/girder(src)
			new /obj/item/stack/sheet/metal( src )
			new /obj/item/stack/sheet/metal( src )
		else
			new /obj/item/stack/sheet/metal( src )
			new /obj/item/stack/sheet/metal( src )
			new /obj/item/stack/sheet/metal( src )

//	Shields.AddShield(src)
	ReplaceWithFloor()

/turf/simulated/wall/examine()
	set src in oview(1)

	usr << "It looks like a regular wall."
	return

/turf/simulated/wall/ex_act(severity)

	switch(severity)
		if(1.0)
			//SN src = null
			src.ReplaceWithSpace()
			//del(src)
			return
		if(2.0)
			if (prob(50))
				dismantle_wall()
			else
				dismantle_wall(devastated=1)
		if(3.0)
			var/proba
			if (istype(src, /turf/simulated/wall/r_wall))
				proba = 15
			else
				proba = 40
			if (prob(proba))
				dismantle_wall()
		else
	return

/turf/simulated/wall/blob_act()
	if(prob(50))
		dismantle_wall()

/turf/simulated/wall/attack_paw(mob/user as mob)
	if ((user.mutations & HULK))
		if (prob(40))
			usr << text("\blue You smash through the wall.")
			dismantle_wall(1)
			return
		else
			usr << text("\blue You punch the wall.")
			return

	return src.attack_hand(user)

/turf/simulated/wall/attack_hand(mob/user as mob)
	if ((user.mutations & HULK))
		if (prob(40))
			usr << text("\blue You smash through the wall.")
			dismantle_wall(1)
			return
		else
			usr << text("\blue You punch the wall.")
			return

	user << "\blue You push the wall but nothing happens!"
	playsound(src.loc, 'Genhit.ogg', 25, 1)
	src.add_fingerprint(user)
	return

/turf/simulated/wall/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return

	if (istype(W, /obj/item/weapon/weldingtool) && W:welding)
		var/turf/T = get_turf(user)
		if (!( istype(T, /turf) ))
			return

		if (thermite)
			var/obj/overlay/O = new/obj/overlay( src )
			O.name = "Thermite"
			O.desc = "Looks hot."
			O.icon = 'fire.dmi'
			O.icon_state = "2"
			O.anchored = 1
			O.density = 1
			O.layer = 5
			var/turf/simulated/floor/F = ReplaceWithFloor()
			F.burn_tile()
			F.icon_state = "wall_thermite"
			user << "\red The thermite melts the wall."
			spawn(100) del(O)
			levelupdate()
			return

		if (W:remove_fuel(0,user))
			W:welding = 2
			user << "\blue Now disassembling the outer wall plating."
			playsound(src.loc, 'Welder.ogg', 100, 1)
			sleep(100)
			if (istype(src, /turf/simulated/wall))
				if ((get_turf(user) == T && user.equipped() == W))
					user << "\blue You disassembled the outer wall plating."
					dismantle_wall()
			W:welding = 1
		else
			user << "\blue You need more welding fuel to complete this task."
			return

	else if (istype(W, /obj/item/weapon/tgpickaxe/plasmacutter) || (istype(W, /obj/item/weapon/asteroidcutter) && W:lit))
		var/turf/T = user.loc
		if (!( istype(T, /turf) ))
			return

		if (thermite)
			var/obj/overlay/O = new/obj/overlay( src )
			O.name = "Thermite"
			O.desc = "Looks hot."
			O.icon = 'fire.dmi'
			O.icon_state = "2"
			O.anchored = 1
			O.density = 1
			O.layer = 5
			var/turf/simulated/floor/F = ReplaceWithFloor()
			F.burn_tile()
			F.icon_state = "wall_thermite"
			user << "\red The thermite melts the wall."
			spawn(100) del(O)
			levelupdate()
			return

		else
			user << "\blue Now disassembling the outer wall plating."
			playsound(src.loc, 'Welder.ogg', 100, 1)
			sleep(60)
			if (istype(src, /turf/simulated/wall))
				if ((get_turf(user) == T && user.equipped() == W))
					user << "\blue You disassembled the outer wall plating."
					dismantle_wall()
					for(var/mob/O in viewers(user, 5))
						O.show_message(text("\blue The wall was sliced apart by []!", user), 1, text("\red You hear metal being sliced apart."), 2)
		return

	else if(istype(W, /obj/item/weapon/tgpickaxe/diamonddrill))
		var/turf/T = user.loc
		user << "\blue Now drilling through wall."
		sleep(60)
		if ((user.loc == T && user.equipped() == W))
			dismantle_wall(1)
			for(var/mob/O in viewers(user, 5))
				O.show_message(text("\blue The wall was drilled apart by []!", user), 1, text("\red You hear metal being drilled appart."), 2)
		return

	else if(istype(W, /obj/item/weapon/melee/energy/blade))
		var/turf/T = user.loc
		user << "\blue Now slicing through wall."
		W:spark_system.start()
		playsound(src.loc, "sparks", 50, 1)
		sleep(70)
		if ((user.loc == T && user.equipped() == W))
			W:spark_system.start()
			playsound(src.loc, "sparks", 50, 1)
			playsound(src.loc, 'blade1.ogg', 50, 1)
			dismantle_wall(1)
			for(var/mob/O in viewers(user, 5))
				O.show_message(text("\blue The wall was sliced apart by []!", user), 1, text("\red You hear metal being sliced and sparks flying."), 2)
		return

	else if(istype(W,/obj/item/apc_frame))
		var/obj/item/apc_frame/AH = W
		AH.try_build(src)
	else
		var/aforce = W.force
		src.health = max(0, src.health - aforce)
		playsound(src.loc, 'Genhit.ogg', 75, 1)
		user << "\blue You attack the wall!"
		update_health()
	return


/turf/simulated/wall/r_wall/attackby(obj/item/W as obj, mob/user as mob)

	if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return

	if (istype(W, /obj/item/weapon/weldingtool) && W:welding)
		W:eyecheck(user)
		var/turf/T = user.loc
		if (!( istype(T, /turf) ))
			return

		if (thermite)
			var/obj/overlay/O = new/obj/overlay( src )
			O.name = "Thermite"
			O.desc = "Looks hot."
			O.icon = 'fire.dmi'
			O.icon_state = "2"
			O.anchored = 1
			O.density = 1
			O.layer = 5
			var/turf/simulated/floor/F = ReplaceWithFloor()
			F.burn_tile()
			F.icon_state = "wall_thermite"
			user << "\red The thermite melts the wall."
			spawn(100) del(O)
			levelupdate()
			return

		if (src.d_state == 2)
			W:welding = 2
			user << "\blue Slicing metal cover."
			playsound(src.loc, 'Welder.ogg', 100, 1)
			sleep(60)
			if ((user.loc == T && user.equipped() == W))
				src.d_state = 3
				user << "\blue You removed the metal cover."
			W:welding = 1

		else if (src.d_state == 5)
			W:welding = 2
			user << "\blue Removing support rods."
			playsound(src.loc, 'Welder.ogg', 100, 1)
			sleep(100)
			if ((user.loc == T && user.equipped() == W))
				src.d_state = 6
				new /obj/item/stack/rods( src )
				user << "\blue You removed the support rods."
			W:welding = 1

	else if(istype(W, /obj/item/weapon/tgpickaxe/plasmacutter) || (istype(W, /obj/item/weapon/asteroidcutter) && W:lit))
		var/turf/T = user.loc
		if (!( istype(T, /turf) ))
			return

		if (thermite)
			var/obj/overlay/O = new/obj/overlay( src )
			O.name = "Thermite"
			O.desc = "Looks hot."
			O.icon = 'fire.dmi'
			O.icon_state = "2"
			O.anchored = 1
			O.density = 1
			O.layer = 5
			var/turf/simulated/floor/F = ReplaceWithFloor()
			F.burn_tile()
			F.icon_state = "wall_thermite"
			user << "\red The thermite melts the wall."
			spawn(100) del(O)
			levelupdate()
			return

		if (src.d_state == 2)
			user << "\blue Slicing metal cover."
			playsound(src.loc, 'Welder.ogg', 100, 1)
			sleep(40)
			if ((user.loc == T && user.equipped() == W))
				src.d_state = 3
				user << "\blue You removed the metal cover."

		else if (src.d_state == 5)
			user << "\blue Removing support rods."
			playsound(src.loc, 'Welder.ogg', 100, 1)
			sleep(70)
			if ((user.loc == T && user.equipped() == W))
				src.d_state = 6
				new /obj/item/stack/rods( src )
				user << "\blue You removed the support rods."

	else if(istype(W, /obj/item/weapon/melee/energy/blade))
		user << "\blue This wall is too thick to slice through. You will need to find a different path."
		return

	else if (istype(W, /obj/item/weapon/wrench))
		if (src.d_state == 4)
			var/turf/T = user.loc
			user << "\blue Detaching support rods."
			playsound(src.loc, 'Ratchet.ogg', 100, 1)
			sleep(40)
			if ((user.loc == T && user.equipped() == W))
				src.d_state = 5
				user << "\blue You detach the support rods."

	else if (istype(W, /obj/item/weapon/wirecutters))
		if (src.d_state == 0)
			playsound(src.loc, 'Wirecutter.ogg', 100, 1)
			src.d_state = 1
			new /obj/item/stack/rods( src )

	else if (istype(W, /obj/item/weapon/screwdriver))
		if (src.d_state == 1)
			var/turf/T = user.loc
			playsound(src.loc, 'Screwdriver.ogg', 100, 1)
			user << "\blue Removing support lines."
			sleep(40)
			if ((user.loc == T && user.equipped() == W))
				src.d_state = 2
				user << "\blue You removed the support lines."

	else if (istype(W, /obj/item/weapon/crowbar))

		if (src.d_state == 3)
			var/turf/T = user.loc
			user << "\blue Prying cover off."
			playsound(src.loc, 'Crowbar.ogg', 100, 1)
			sleep(100)
			if ((user.loc == T && user.equipped() == W))
				src.d_state = 4
				user << "\blue You removed the cover."

		else if (src.d_state == 6)
			var/turf/T = user.loc
			user << "\blue Prying outer sheath off."
			playsound(src.loc, 'Crowbar.ogg', 100, 1)
			sleep(100)
			if ((user.loc == T && user.equipped() == W))
				user << "\blue You removed the outer sheath."
				dismantle_wall()
				return

	else if (istype(W, /obj/item/weapon/tgpickaxe/diamonddrill))
		var/turf/T = user.loc
		user << "\blue You begin to drill though, this will take some time."
		sleep(200)
		if ((user.loc == T && user.equipped() == W))
			user << "\blue Your drill tears though the reinforced plating."
			dismantle_wall()
			return

	else if ((istype(W, /obj/item/stack/sheet/metal)) && (src.d_state))
		var/turf/T = user.loc
		user << "\blue Repairing wall."
		sleep(100)
		if ((user.loc == T && user.equipped() == W))
			src.d_state = 0
			src.icon_state = initial(src.icon_state)
			user << "\blue You repaired the wall."
			if (W:amount > 1)
				W:amount--
			else
				del(W)

	if(istype(W,/obj/item/apc_frame))
		var/obj/item/apc_frame/AH = W
		AH.try_build(src)
		return

	if(src.d_state > 0)
		src.icon_state = "r_wall-[d_state]"

	else
		return attack_hand(user)
	return

/turf/simulated/wall/meteorhit(obj/M as obj)
	if (M.icon_state == "flaming")
		dismantle_wall()
	return 0


//This is so damaged or burnt tiles or platings don't get remembered as the default tile
var/list/icons_to_ignore_at_floor_init = list("damaged1","damaged2","damaged3","damaged4",
				"damaged5","panelscorched","floorscorched1","floorscorched2","platingdmg1","platingdmg2",
				"platingdmg3","plating","light_on","light_on_flicker1","light_on_flicker2",
				"light_on_clicker3","light_on_clicker4","light_on_clicker5","light_broken",
				"light_on_broken","light_off","wall_thermite","grass1","grass2","grass3","grass4",
				"asteroid","asteroid_dug",
				"asteroid0","asteroid1","asteroid2","asteroid3","asteroid4",
				"asteroid5","asteroid6","asteroid7","asteroid8",
				"burning","oldburning","light-on-r","light-on-y","light-on-g","light-on-b")

var/list/plating_icons = list("plating","platingdmg1","platingdmg2","platingdmg3","asteroid","asteroid_dug")

/turf/simulated/floor

	//Note to Robustmins, the 'intact' var can no longer be used to determine if the floor is a plating or not.
	//Use the is_plating(), is_sttel_floor() and is_light_floor() procs instead. --Errorage
	name = "floor"
	icon = 'floors.dmi'
	icon_state = "floor"
	var/icon_regular_floor = "floor" //used to remember what icon the tile should have by default
	var/icon_plating = "plating"
	thermal_conductivity = 0.040
	heat_capacity = 10000
	var/broken = 0
	var/burnt = 0
	var/obj/item/stack/tile/floor_tile = new/obj/item/stack/tile/steel

	newfloors
		icon = 'floors_new.dmi'

	airless
		icon_state = "floor"
		name = "airless floor"
		oxygen = 0.01
		nitrogen = 0.01
		temperature = TCMB

		New()
			..()
			name = "floor"

	light
		name = "Light floor"
		luminosity = 5
		icon_state = "light_on"
		floor_tile = new/obj/item/stack/tile/light

		New()
			floor_tile.New() //I guess New() isn't run on objects spawned without the definition of a turf to house them, ah well.
			var/n = name //just in case commands rename it in the ..() call
			..()
			spawn(4)
				update_icon()
				name = n

	grass
		name = "Grass patch"
		icon_state = "grass1"
		floor_tile = new/obj/item/stack/tile/grass

		New()
			floor_tile.New() //I guess New() isn't run on objects spawned without the definition of a turf to house them, ah well.
			icon_state = "grass[pick("1","2","3","4")]"
			..()
			spawn(4)
				update_icon()
				for(var/direction in cardinal)
					if(istype(get_step(src,direction),/turf/simulated/floor))
						var/turf/simulated/floor/FF = get_step(src,direction)
						FF.update_icon() //so siding get updated properly

	puzzlechamber
		name = "floor"
		icon_state = "largetile2"

	puzzlechamber/water
		name = "water"
		icon_state = "water"

	puzzlechamber/fire
		name = "fire floor"
		icon_state = "burning"

	puzzlechamber/ice
		name = "ice floor"
		icon_state = "icefloor"

	puzzlechamber/superconveyor
		name = "conveyor floor"
		icon_state = "superconveyor"

	puzzlechamber/newwall
		name = "floor"
		icon_state = "largetile2"

	puzzlechamber/itemthief
		name = "item confiscation field"
		icon_state = "itemthief"

/turf/simulated/floor/vault
	icon_state = "rockvault"

	New(location,type)
		..()
		icon_state = "[type]vault"

/turf/simulated/wall/vault
	icon_state = "rockvault"

	New(location,type)
		..()
		icon_state = "[type]vault"

/turf/simulated/floor/neptune
	name = "Pluto Surface"
	thermal_conductivity = 0.025
	heat_capacity = 325000
	New()
		..()
		var/datum/gas_mixture/adding = new
		var/datum/gas/sleeping_agent/trace_gas = new

		trace_gas.moles = 60
		adding.trace_gases += trace_gas
		adding.temperature = 150

		assume_air(adding)


/turf/simulated/floor/engine
	name = "reinforced floor"
	icon_state = "engine"
	thermal_conductivity = 0.025
	heat_capacity = 325000

/turf/simulated/floor/engine/shieldmarker
	name = "Energy plating"
	icon_state = "engine"


/turf/simulated/floor/engine/n20
	New()
		..()
		var/datum/gas_mixture/adding = new
		var/datum/gas/sleeping_agent/trace_gas = new

		trace_gas.moles = 2000
		adding.trace_gases += trace_gas
		adding.temperature = T20C

		assume_air(adding)

/turf/simulated/floor/engine/vacuum
	name = "vacuum floor"
	icon_state = "engine"
	oxygen = 0
	nitrogen = 0.001
	temperature = TCMB


/turf/simulated/floor/plating
	name = "plating"
	icon_state = "plating"
	floor_tile = null
	intact = 0

/turf/simulated/floor/plating/attack_hand()
	return

/turf/simulated/floor/plating/glassfloor
	icon_state = "glassfloorlattice"

/turf/simulated/floor/plating/airless
	icon_state = "plating"
	name = "airless plating"
	oxygen = 0.01
	nitrogen = 0.01
	temperature = TCMB

	New()
		..()
		name = "plating"

/turf/simulated/floor/grid
	icon = 'floors.dmi'
	icon_state = "circuit"

/turf/simulated/floor/tutorial
	icon = 'tutorial.dmi'
	icon_state = "vfloor_tiles"

/turf/simulated/floor/tutorial/crowbar
	icon = 'tutorial.dmi'
	icon_state = "vfloor_tiles_blue"

/turf/simulated/floor/New()
	..()
	if(icon_state in icons_to_ignore_at_floor_init) //so damaged/burned tiles or plating icons aren't saved as the default
		icon_regular_floor = "floor"
	else
		icon_regular_floor = icon_state

/turf/simulated/floor/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if ((istype(mover, /obj/machinery/vehicle) && !(src.burnt)))
		if (!( locate(/obj/machinery/mass_driver, src) ))
			return 0
	return ..()

/turf/simulated/floor/ex_act(severity)
	//set src in oview(1)
	switch(severity)
		if(3.0)
			if(prob(98))
				src.break_tile()
				src.hotspot_expose(1000,CELL_VOLUME)
				if(prob(33)) new /obj/item/stack/sheet/metal(src)
			else
				src.break_tile_to_plating()
				if(prob(33)) new /obj/item/stack/sheet/metal(src)
		if(2.0)
			switch(pick(1,2;75,3))
				if (1)
					if(prob(90))
						src.break_tile_to_plating()
					else
						if(prob(33)) new /obj/item/stack/sheet/metal(src)
				if(2)
					if(prob(90))
						src.break_tile_to_plating()
					else
						src.ReplaceWithSpace()
						if(prob(33)) new /obj/item/stack/sheet/metal(src)
				if(3)
					if(prob(80))
						src.break_tile_to_plating()
					else
						src.break_tile()
						src.hotspot_expose(1000,CELL_VOLUME)
						if(prob(33)) new /obj/item/stack/sheet/metal(src)
		if(1.0)
			if(prob(80))
				src.break_tile_to_plating()
			else
				src.ReplaceWithSpace()
				if(prob(33)) new /obj/item/stack/sheet/metal(src)
	return

/turf/simulated/floor/blob_act()
	return

turf/simulated/floor/proc/update_icon()
	if(is_steel_floor())
		if(!broken && !burnt)
			icon_state = icon_regular_floor
	if(is_plating())
		if(!broken && !burnt)
			icon_state = icon_plating //Because asteroids are 'platings' too.
	if(is_light_floor())
		var/obj/item/stack/tile/light/T = floor_tile
		if(T.on)
			switch(T.state)
				if(0)
					icon_state = "light_on"
					ul_SetLuminosity(5)
				if(1)
					var/num = pick("1","2","3","4")
					icon_state = "light_on_flicker[num]"
					ul_SetLuminosity(5)
				if(2)
					icon_state = "light_on_broken"
					ul_SetLuminosity(5)
				if(3)
					icon_state = "light_off"
					ul_SetLuminosity(0)
		else
			ul_SetLuminosity(0)
			icon_state = "light_off"
	if(is_grass_floor())
		if(!broken && !burnt)
			if(!(icon_state in list("grass1","grass2","grass3","grass4")))
				icon_state = "grass[pick("1","2","3","4")]"
	spawn(1)
		if(istype(src,/turf/simulated/floor)) //Was throwing runtime errors due to a chance of it changing to space halfway through.
			if(air)
				update_visuals(air)

turf/simulated/floor/return_siding_icon_state()
	..()
	if(is_grass_floor())
		var/dir_sum = 0
		for(var/direction in cardinal)
			var/turf/T = get_step(src,direction)
			if(!(T.is_grass_floor()))
				dir_sum += direction
		if(dir_sum)
			return "wood_siding[dir_sum]"
		else
			return 0


/turf/simulated/floor/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/turf/simulated/floor/attack_hand(mob/user as mob)
	if (is_light_floor())
		var/obj/item/stack/tile/light/T = floor_tile
		T.on = !T.on
	update_icon()
	if ((!( user.canmove ) || user.restrained() || !( user.pulling )))
		return
	if (user.pulling.anchored)
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		var/mob/t = M.pulling
		M.pulling = null
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.pulling = t
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return

/turf/simulated/floor/engine/attackby(obj/item/weapon/C as obj, mob/user as mob)
	if(!C)
		return
	if(!user)
		return
	if(istype(C, /obj/item/weapon/wrench))
		user << "\blue Removing rods..."
		playsound(src.loc, 'Ratchet.ogg', 80, 1)
		if(do_after(user, 30))
			new /obj/item/stack/rods(src, 2)
			ReplaceWithFloor()
			var/turf/simulated/floor/F = src
			F.make_plating()
			return

/turf/simulated/floor/proc/gets_drilled()
	return

/turf/simulated/floor/proc/break_tile_to_plating()
	if(!is_plating())
		make_plating()
	break_tile()

/turf/simulated/floor/is_steel_floor()
	if(istype(floor_tile,/obj/item/stack/tile/steel))
		return 1
	else
		return 0

/turf/simulated/floor/is_light_floor()
	if(istype(floor_tile,/obj/item/stack/tile/light))
		return 1
	else
		return 0

/turf/simulated/floor/is_grass_floor()
	if(istype(floor_tile,/obj/item/stack/tile/grass))
		return 1
	else
		return 0

/turf/simulated/floor/is_plating()
	if(!floor_tile)
		return 1
	return 0

/turf/simulated/floor/proc/break_tile()
	if(istype(src,/turf/simulated/floor/engine)) return
	if(broken) return
	if(is_steel_floor())
		src.icon_state = "damaged[pick(1,2,3,4,5)]"
		broken = 1
	else if(is_steel_floor())
		src.icon_state = "light_broken"
		broken = 1
	else if(is_plating())
		src.icon_state = "platingdmg[pick(1,2,3)]"
		broken = 1
	else if(is_grass_floor())
		src.icon_state = "sand[pick("1","2","3")]"
		broken = 1

/turf/simulated/floor/proc/burn_tile()
	if(istype(src,/turf/simulated/floor/engine)) return
	if(broken || burnt) return
	if(is_steel_floor())
		src.icon_state = "damaged[pick(1,2,3,4,5)]"
		burnt = 1
	else if(is_steel_floor())
		src.icon_state = "floorscorched[pick(1,2)]"
		burnt = 1
	else if(is_plating())
		src.icon_state = "panelscorched"
		burnt = 1
	else if(is_grass_floor())
		src.icon_state = "sand[pick("1","2","3")]"
		burnt = 1

//This proc will delete the floor_tile and the update_iocn() proc will then change the icon_state of the turf
//This proc auto corrects the grass tiles' siding.
/turf/simulated/floor/proc/make_plating()
	if(istype(src,/turf/simulated/floor/engine)) return

	if(is_grass_floor())
		for(var/direction in cardinal)
			if(istype(get_step(src,direction),/turf/simulated/floor))
				var/turf/simulated/floor/FF = get_step(src,direction)
				FF.update_icon() //so siding get updated properly

	if(!floor_tile) return
	del(floor_tile)
	icon_plating = "plating"
	ul_SetLuminosity(0)
	floor_tile = null
	intact = 0
	broken = 0
	burnt = 0

	update_icon()
	levelupdate()

//This proc will make the turf a steel floor tile. The expected argument is the tile to make the turf with
//If none is given it will make a new object. dropping or unequipping must be handled before or after calling
//this proc.
/turf/simulated/floor/proc/make_steel_floor(var/obj/item/stack/tile/steel/T = null)
	broken = 0
	burnt = 0
	intact = 1
	ul_SetLuminosity(0)
	if(T)
		if(istype(T,/obj/item/stack/tile/steel))
			floor_tile = T
			if (icon_regular_floor)
				icon_state = icon_regular_floor
			else
				icon_state = "floor"
				icon_regular_floor = icon_state
			update_icon()
			levelupdate()
			return
	//if you gave a valid parameter, it won't get thisf ar.
	floor_tile = new/obj/item/stack/tile/steel
	icon_state = "floor"
	icon_regular_floor = icon_state

	update_icon()
	levelupdate()

//This proc will make the turf a light floor tile. The expected argument is the tile to make the turf with
//If none is given it will make a new object. dropping or unequipping must be handled before or after calling
//this proc.
/turf/simulated/floor/proc/make_light_floor(var/obj/item/stack/tile/light/T = null)
	broken = 0
	burnt = 0
	intact = 1
	if(T)
		if(istype(T,/obj/item/stack/tile/light))
			floor_tile = T
			update_icon()
			levelupdate()
			return
	//if you gave a valid parameter, it won't get thisf ar.
	floor_tile = new/obj/item/stack/tile/light

	update_icon()
	levelupdate()

//This proc will make a turf into a grass patch. Fun eh? Insert the grass tile to be used as the argument
//If no argument is given a new one will be made.
/turf/simulated/floor/proc/make_grass_floor(var/obj/item/stack/tile/grass/T = null)
	broken = 0
	burnt = 0
	intact = 1
	if(T)
		if(istype(T,/obj/item/stack/tile/grass))
			floor_tile = T
			update_icon()
			levelupdate()
			return
	//if you gave a valid parameter, it won't get thisf ar.
	floor_tile = new/obj/item/stack/tile/grass

	update_icon()
	levelupdate()

/turf/simulated/floor/attackby(obj/item/C as obj, mob/user as mob)

	if(!C || !user)
		return 0

	if(istype(C,/obj/item/weapon/light/bulb)) //only for light tiles
		if(is_light_floor())
			var/obj/item/stack/tile/light/T = floor_tile
			if(T.state)
				user.u_equip(C)
				del(C)
				T.state = C //fixing it by bashing it with a light bulb, fun eh?
				update_icon()
				user << "\blue You replace the light bulb."
			else
				user << "\blue The lightbulb seems fine, no need to replace it."

	if(istype(C, /obj/item/weapon/crowbar) && (!(is_plating())))
		if(istype(src, /turf/simulated/floor/tutorial) && icon_state == "vfloor_tiles_blue")
			user << "\blue You pry the floor tiles loose!"
			playsound(src.loc, 'Crowbar.ogg', 80, 1)
			src.icon_state = "vfloor_blue"
			src.name = "plating"
			spawn(300)
				src.icon_state = "vfloor_tiles_blue"
				src.name = "floor"

		if(broken || burnt)
			user << "\red You remove the broken plating."
		else
			user << "\red You remove the [floor_tile.name]."
			new floor_tile.type(src)

		make_plating()
		playsound(src.loc, 'Crowbar.ogg', 80, 1)

		return

	if(istype(C, /obj/item/stack/rods))
		if (is_plating())
			if (C:amount >= 2)
				user << "\blue Reinforcing the floor..."
				if(do_after(user, 30) && C && C:amount >= 2 && is_plating())
					ReplaceWithEngineFloor()
					playsound(src.loc, 'Deconstruct.ogg', 80, 1)
					C:use(2)
					return
			else
				user << "\red You need more rods."
		else
			user << "\red You must remove the plating first."
		return

	if(istype(C, /obj/item/stack/tile))
		if(is_plating())
			var/obj/item/stack/tile/T = C
			floor_tile = new T.type
			intact = 1
			if(istype(T,/obj/item/stack/tile/light))
				floor_tile:state = T:state
				floor_tile:on = T:on
			if(istype(T,/obj/item/stack/tile/grass))
				for(var/direction in cardinal)
					if(istype(get_step(src,direction),/turf/simulated/floor))
						var/turf/simulated/floor/FF = get_step(src,direction)
						FF.update_icon() //so siding get updated properly
			T.use(1)
			update_icon()
			levelupdate()
			playsound(src.loc, 'Genhit.ogg', 50, 1)
		else
			user << "\blue This section already has a tile on it. Use a crowbar to pry it off."


	if(istype(C, /obj/item/weapon/cable_coil))
		if(is_plating())
			var/obj/item/weapon/cable_coil/coil = C
			coil.turf_place(src, user)
		else
			user << "\red You must remove the plating first."

	if(istype(C, /obj/item/weapon/shovel))
		if(is_grass_floor())
			new /obj/item/weapon/ore/glass(src)
			new /obj/item/weapon/ore/glass(src) //Make some sand if you shovel grass
			user << "\blue You shovel the grass."
			make_plating()
		else
			user << "\red You cannot shovel this."

/turf/unsimulated/floor/attack_paw(user as mob)
	return src.attack_hand(user)

/turf/unsimulated/floor/attack_hand(var/mob/user as mob)
	if ((!( user.canmove ) || user.restrained() || !( user.pulling )))
		return
	if (user.pulling.anchored)
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		var/mob/t = M.pulling
		M.pulling = null
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.pulling = t
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return







//				Puzzlechamber floors
/turf/simulated/floor/puzzlechamber/fire/Entered(mob/living/carbon/M as mob)
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(!istype(H.shoes, /obj/item/clothing/shoes/fireboots))
			H.inertia_dir = 0
			H.weakened = max(rand(3,4), H.weakened)
			H.fireloss += 49
			H << "\red You burn your feet on the floor!"
		..()

/turf/simulated/floor/puzzlechamber/water/Entered(mob/living/carbon/M as mob)
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(!istype(H.shoes, /obj/item/clothing/shoes/flippers))
			H.inertia_dir = 0
			H.weakened = max(rand(3,4), H.weakened)
			H.oxyloss += 49
			H << "\red You splash around in the water, but it's too deep to swim unaided in! You fill your lungs with water!"
		..()

/turf/simulated/floor/puzzlechamber/superconveyor/Entered(atom/A, atom/OL)
	if (istype(A,/mob/living/carbon))
		var/mob/M = A
		if(M.lying)
			return
		if (istype(M, /mob/living/carbon/human))
			if (!istype(M:shoes, /obj/item/clothing/shoes/magboots))
				spawn(2) step(M, src.dir)
			else
				M.inertia_dir = 0
				return
	..()

/turf/simulated/floor/puzzlechamber/ice/Entered(atom/A, atom/OL)
	if (istype(A,/mob/living/carbon))
		var/mob/M = A
		if(M.lying)
			return
		if (istype(M, /mob/living/carbon/human))
			if (!istype(M:shoes, /obj/item/clothing/shoes/skates))
				M.canmove = 0
				playsound(src.loc, 'slip.ogg', 50, 1, -3)
				spawn(1) step(M, M.dir)
				M.stunned = 1
	..()

/turf/simulated/floor/puzzlechamber/newwall/Entered(atom/A, atom/OL)
	if (istype(A,/mob/living/carbon))
		var/mob/M = A
		if (istype(M, /mob/living/carbon/human))
			src.name = "wall"
			src.density = 1
			src.icon = 'walls.dmi'
			src.icon_state = ""
	..()


/turf/simulated/floor/puzzlechamber/entranceteleporter/Entered(atom/A, atom/OL)
	if (istype(A,/mob/living))
		var/mob/M = A
		if (istype(M,/mob/living/carbon/human))
			M << "*Thump!*"
			M.paralysis += 10
			sleep(15)
			M.loc = pick(puzzlechamberescape)
			for(var/obj/item/W in M)
				if (istype(W,/obj/item))
					M.u_equip(W)
					if (M.client)
						M.client.screen -= W
					if (W)
						W.loc = M.loc
						W.dropped(M)
						W.layer = initial(W.layer)
			M.loc = pick(puzzlechambersubject)
			var/mob/living/carbon/human/puzzlesubject = M
			puzzlesubject.equip_if_possible(new /obj/item/clothing/under/subjectsuit(puzzlesubject), puzzlesubject.slot_w_uniform)
			puzzlesubject.equip_if_possible(new /obj/item/clothing/shoes/brown(puzzlesubject), puzzlesubject.slot_shoes)
			spawn(115)
				M << "\red You suddenly come back to consciousness. Where the hell are you?"
	..()

/turf/simulated/floor/puzzlechamber/escapeteleporter/Entered(atom/A, atom/OL)
	if (istype(A,/mob/living))
		var/mob/M = A
		if (istype(M,/mob/living/carbon/human))
			flick("circuiteh2",src)
			M << "[M] falls over."
			M.paralysis += 10
			sleep(15)
			M.loc = pick(puzzlechamberescape)
			spawn(115)
				M << "\red You suddenly come back to consciousness."
	..()

/turf/simulated/floor/puzzlechamber/itemthief/Entered(atom/A, atom/OL)
	if (istype(A,/mob/living/carbon/human))
		var/mob/living/carbon/human/M = A
		for(var/obj/item/clothing/shoes/S in M)
			del(S)
		M.equip_if_possible(new /obj/item/clothing/shoes/brown(M), M.slot_shoes)
	if (istype(A,/obj/item/clothing/shoes)) //In case they try to throw them through the field or something
		del(A)
	..()

// Transit space

/turf/simulated/floor/plating/airless/transitspace/Entered(atom/A, atom/OL)
	if (istype(A,/mob/living/carbon))
		var/mob/M = A
		if (istype(M, /mob/living/carbon/human))
			if(!doublestrength)
				spawn(2) step(M, src.dir)
			else
				spawn(1)
				step(M, src.dir)
				step(M, src.dir)
				step(M, src.dir)
	..()


// imported from space.dm

/turf/space/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/turf/space/attack_hand(mob/user as mob)
	if ((user.restrained() || !( user.pulling )))
		return
	if (user.pulling.anchored)
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		var/t = M.pulling
		M.pulling = null
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.pulling = t
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return

/turf/space/attackby(obj/item/C as obj, mob/user as mob)

	if (istype(C, /obj/item/stack/rods))
		user << "\blue Constructing support lattice ..."
		playsound(src.loc, 'Genhit.ogg', 50, 1)
		ReplaceWithLattice()
		C:use(1)
		return

	if (istype(C, /obj/item/stack/tile/steel))
		var/obj/lattice/L = locate(/obj/lattice, src)
		if(L)
			del(L)
			playsound(src.loc, 'Genhit.ogg', 50, 1)
			C:build(src)
			C:use(1)
			return
		else
			user << "\red The plating is going to need some support."
	return


// Ported from unstable r355

/turf/space/Entered(atom/movable/A as mob|obj)
	..()
	if ((!(A) || src != A.loc || istype(null, /obj/beam)))
		return

	if (!(A.last_move))
		return

//	if (locate(/obj/movable, src))
//		return 1

	if ((istype(A, /mob/) && src.x > 2 && src.x < (world.maxx - 1) && src.y > 2 && src.y < (world.maxy-1)))
		var/mob/M = A
		if ((!( M.handcuffed) && M.canmove))
			var/prob_slip = 5
			var/mag_eq = 0
			if(istype(M, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(istype(H.shoes, /obj/item/clothing/shoes/magboots) && H.shoes.flags&NOSLIP)
					mag_eq = 1

			if (locate(/obj/grille, oview(1, M)) || locate(/obj/lattice, oview(1, M)) )
				if(mag_eq)
					prob_slip = 0
				else
					if (!( M.l_hand ))
						prob_slip -= 2
					else if (M.l_hand.w_class <= 2)
						prob_slip -= 1

					if (!( M.r_hand ))
						prob_slip -= 2
					else if (M.r_hand.w_class <= 2)
						prob_slip -= 1
			else if (locate(/turf/unsimulated, oview(1, M)) || locate(/turf/simulated, oview(1, M)))
				if(mag_eq)
					prob_slip = 0
				else
					if (!( M.l_hand ))
						prob_slip -= 1
					else if (M.l_hand.w_class <= 2)
						prob_slip -= 0.5

					if (!( M.r_hand ))
						prob_slip -= 1
					else if (M.r_hand.w_class <= 2)
						prob_slip -= 0.5
			prob_slip = round(prob_slip)

			if (prob_slip < 5) //next to something, but they might slip off
				if (prob(prob_slip) )
					M << "\blue <B>You slipped!</B>"
					M.inertia_dir = M.last_move
					step(M, M.inertia_dir)
					return
				else
					M.inertia_dir = 0 //no inertia
			else //not by a wall or anything, they just keep going
				spawn(5)
					if ((A && !( A.anchored ) && A.loc == src))
						if(M.inertia_dir) //they keep moving the same direction
							step(M, M.inertia_dir)
						else
							M.inertia_dir = M.last_move
							step(M, M.inertia_dir)
		else //can't move, they just keep going (COPY PASTED CODE WOO)
			spawn(5)
				if ((A && !( A.anchored ) && A.loc == src))
					if(M.inertia_dir) //they keep moving the same direction
						step(M, M.inertia_dir)
					else
						M.inertia_dir = M.last_move
						step(M, M.inertia_dir) //TODO: DEFERRED
	if(ticker && ticker.mode)
		if(ticker.mode.name == "nuclear emergency")
			return

		else if(ticker.mode.name == "extended"||ticker.mode.name == "sandbox")

			var/cur_x
			var/cur_y
			var/next_x
			var/next_y
			var/target_z
			var/list/y_arr

			if(src.x <= 1)
				if(istype(A, /obj/meteor)||istype(A, /obj/space_dust))
					del(A)
					return

				var/list/cur_pos = src.get_global_map_pos()
				if(!cur_pos) return
				cur_x = cur_pos["x"]
				cur_y = cur_pos["y"]
				next_x = (--cur_x||global_map.len)
				y_arr = global_map[next_x]
				target_z = y_arr[cur_y]
/*
				//debug
				world << "Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]"
				world << "Target Z = [target_z]"
				world << "Next X = [next_x]"
				//debug
*/
				if(target_z)
					A.z = target_z
					A.x = world.maxx - 2
					spawn (0)
						if ((A && A.loc))
							A.loc.Entered(A)
			else if (src.x >= world.maxx)
				if(istype(A, /obj/meteor))
					del(A)
					return

				var/list/cur_pos = src.get_global_map_pos()
				if(!cur_pos) return
				cur_x = cur_pos["x"]
				cur_y = cur_pos["y"]
				next_x = (++cur_x > global_map.len ? 1 : cur_x)
				y_arr = global_map[next_x]
				target_z = y_arr[cur_y]
/*
				//debug
				world << "Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]"
				world << "Target Z = [target_z]"
				world << "Next X = [next_x]"
				//debug
*/
				if(target_z)
					A.z = target_z
					A.x = 3
					spawn (0)
						if ((A && A.loc))
							A.loc.Entered(A)
			else if (src.y <= 1)
				if(istype(A, /obj/meteor))
					del(A)
					return
				var/list/cur_pos = src.get_global_map_pos()
				if(!cur_pos) return
				cur_x = cur_pos["x"]
				cur_y = cur_pos["y"]
				y_arr = global_map[cur_x]
				next_y = (--cur_y||y_arr.len)
				target_z = y_arr[next_y]
/*
				//debug
				world << "Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]"
				world << "Next Y = [next_y]"
				world << "Target Z = [target_z]"
				//debug
*/
				if(target_z)
					A.z = target_z
					A.y = world.maxy - 2
					spawn (0)
						if ((A && A.loc))
							A.loc.Entered(A)

			else if (src.y >= world.maxy)
				if(istype(A, /obj/meteor)||istype(A, /obj/space_dust))
					del(A)
					return
				var/list/cur_pos = src.get_global_map_pos()
				if(!cur_pos) return
				cur_x = cur_pos["x"]
				cur_y = cur_pos["y"]
				y_arr = global_map[cur_x]
				next_y = (++cur_y > y_arr.len ? 1 : cur_y)
				target_z = y_arr[next_y]
/*
				//debug
				world << "Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]"
				world << "Next Y = [next_y]"
				world << "Target Z = [target_z]"
				//debug
*/
				if(target_z)
					A.z = target_z
					A.y = 3
					spawn (0)
						if ((A && A.loc))
							A.loc.Entered(A)
			return


		else

			if (src.x <= 2)
				if(istype(A, /obj/meteor)||istype(A, /obj/space_dust))
					del(A)
					return

				var/move_to_z_str = pickweight(accessable_z_levels)

				var/move_to_z = text2num(move_to_z_str)

				if(!move_to_z)
					return

				A.z = move_to_z
				A.x = world.maxx - 2
				spawn (0)
					if ((A && A.loc))
						A.loc.Entered(A)
			else if (A.x >= (world.maxx - 1))
				if(istype(A, /obj/meteor)||istype(A, /obj/space_dust))
					del(A)
					return

				var/move_to_z_str = pickweight(accessable_z_levels)

				var/move_to_z = text2num(move_to_z_str)

				if(!move_to_z)
					return

				A.z = move_to_z
				A.x = 3
				spawn (0)
					if ((A && A.loc))
						A.loc.Entered(A)
			else if (src.y <= 2)
				if(istype(A, /obj/meteor)||istype(A, /obj/space_dust))
					del(A)
					return

				var/move_to_z_str = pickweight(accessable_z_levels)

				var/move_to_z = text2num(move_to_z_str)

				if(!move_to_z)
					return

				A.z = move_to_z
				A.y = world.maxy - 2
				spawn (0)
					if ((A && A.loc))
						A.loc.Entered(A)

			else if (A.y >= (world.maxy - 1))
				if(istype(A, /obj/meteor)||istype(A, /obj/space_dust))
					del(A)
					return

				var/move_to_z_str = pickweight(accessable_z_levels)

				var/move_to_z = text2num(move_to_z_str)

				if(!move_to_z)
					return

				A.z = move_to_z
				A.y = 3
				spawn (0)
					if ((A && A.loc))
						A.loc.Entered(A)

/obj/vaultspawner
	var/maxX = 6
	var/maxY = 6
	var/minX = 2
	var/minY = 2

/obj/vaultspawner/New(turf/location as turf,lX = minX,uX = maxX,lY = minY,uY = maxY,var/type = null)
	if(!type)
		type = pick("sandstone","rock","alien")

	var/lowBoundX = location.x
	var/lowBoundY = location.y

	var/hiBoundX = location.x + rand(lX,uX)
	var/hiBoundY = location.y + rand(lY,uY)

	var/z = location.z

	for(var/i = lowBoundX,i<=hiBoundX,i++)
		for(var/j = lowBoundY,j<=hiBoundY,j++)
			if(i == lowBoundX || i == hiBoundX || j == lowBoundY || j == hiBoundY)
				new /turf/simulated/wall/vault(locate(i,j,z),type)
			else
				new /turf/simulated/floor/vault(locate(i,j,z),type)

	del(src)

/turf/proc/kill_creatures(mob/U = null)//Will kill people/creatures and damage mechs./N
//Useful to batch-add creatures to the list.
	for(var/mob/living/M in src)
		if(M==U)	continue//Will not harm U. Since null != M, can be excluded to kill everyone.
		spawn(0)
			M.gib()
	for(var/obj/alien/facehugger/M in src)//These really need to be mobs.
		spawn(0)
			M.death()
	for(var/obj/livestock/M in src)
		spawn(0)
			M.gib()