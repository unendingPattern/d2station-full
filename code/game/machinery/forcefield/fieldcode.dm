////////FORCE FIELD
/obj/machinery/field_generator/ehprison1
	name = "Field Generator"
	desc = "Projects an energy field when active"
	icon = 'objects.dmi'
	icon_state = "shieldoff"
	opacity = 0
	var/max_power = 8000
	var/frequency = 0

/obj/machinery/field_generator/ehprison1/attack_hand(mob/user as mob)
	if(src.anchored == 0)
		user << "Setting up field emitter"
		sleep(5)
		src.overlays += image('assemblies.dmi', "sheild2")
		user << "Field emitter has been attached."
		src.anchored = 1
	else
		user << "Detaching field emitter"
		sleep(5)
		src.overlays -= image('assemblies.dmi', "sheild2")
		user << "Field emitter has been detached."
		src.active = 0
		spawn(1)
			src.cleanup1(1)
		spawn(1)
			src.cleanup1(2)
		spawn(1)
			src.cleanup1(4)
		spawn(1)
			src.cleanup1(8)
		src.overlays -= icon('effects.dmi', "shieldsparkles")
		src.anchored = 0


/obj/machinery/shieldbeam
	name = "shield"
	desc = "An energy shield."
	icon = 'effects.dmi'
	icon_state = "shieldsparkles"
	density = 1
	opacity = 0
	anchored = 1
	unacidable = 1
	var/active = 0
	var/power = 10
	var/delay = 5
	var/last_active
	var/mob/U
	var/obj/machinery/field_generator/gen_primary
	var/obj/machinery/field_generator/gen_secondary


//////////////force Field START


/obj/machinery/shieldbeam/New(var/obj/machinery/field_generator/A, var/obj/machinery/field_generator/B)
	..()
	src.gen_primary = A
	src.gen_secondary = B
	spawn(1)
		src.sd_SetLuminosity(5)

/obj/machinery/shieldbeam/attack_hand(mob/user as mob)
	return


/obj/machinery/shieldbeam/process()
	if(isnull(gen_primary)||isnull(gen_secondary))
		del(src)
		return

	if(!(gen_primary.active)||!(gen_secondary.active))
		del(src)
		return

	if(prob(01))
		gen_primary.power -= 1
	else
		gen_secondary.power -= 1


/obj/machinery/shieldbeam/proc/shock(mob/user as mob)
	if(isnull(gen_primary))
		del(src)
		return
	if(isnull(gen_secondary))
		del(src)
		return

/obj/machinery/shieldbeam/HasProximity(atom/movable/AM as mob|obj)
	if(istype(AM,/mob/living/carbon) && prob(10))
		shock(AM)
		return



/obj/machinery/field_generator/ehprison1/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/device/pda))
		if(stat & (NOPOWER|BROKEN))
			return
		if(!src.anchored)
			return
		else
			if(!src.locked)
				if(src.active >= 1)
					for(var/mob/M in viewers(src))
						M.show_message("\red The [src.name] shuts down.")
					src.overlays -= icon('effects.dmi', "shieldsparkles")
					src.active = 0
					spawn(1)
						src.cleanup1(1)
					spawn(1)
						src.cleanup1(2)
					spawn(1)
						src.cleanup1(4)
					spawn(1)
						src.cleanup1(8)
				else
					src.active = 1
					use_power(5000)
					src.overlays += icon('effects.dmi', "shieldsparkles")
					user << "You turn on the force field generator."
			else
				user << "The controls are locked!"
	if(istype(W, /obj/item/weapon/card/emag))
		var/datum/effects/system/spark_spread/s = new /datum/effects/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		src.overlays = null
		src.active = 0
		spawn(1)
			src.cleanup1(1)
		spawn(1)
			src.cleanup1(2)
		spawn(1)
			src.cleanup1(4)
		spawn(1)
			src.cleanup1(8)

	else
		return

/obj/machinery/field_generator/ehprison1/process()
	if(src.active <= 0)
		if(stat & (NOPOWER|BROKEN))
			if(src.anchored)
				src.overlays = null
			else
				src.overlays = null
		else
			if(src.anchored)
				src.overlays += image('assemblies.dmi', "sheild2")
			else
				src.overlays = null
	if(src.Varedit_start == 1)
		if(src.active == 0)
			src.active = 1
			src.state = 3
			src.power = 250
			src.anchored = 1
			icon_state = "Field_Geneh"
			src.overlays += icon('assemblies.dmi', "sheild2")
		Varedit_start = 0


	if(src.active == 1)
		src.overlays += icon('assemblies.dmi', "sheild2")
		if(!src.state == 3)
			src.active = 0
			return
		spawn(1)
			ehsetup1_field(1)
		spawn(2)
			ehsetup1_field(2)
		spawn(3)
			ehsetup1_field(4)
		spawn(4)
			ehsetup1_field(8)
		src.active = 2
	if(src.power < 0)
		src.power = 0
	if(src.power > src.max_power)
		src.power = src.max_power
	if(src.active >= 1)
		src.power -= 1
		if(Varpower == 0)
			if(stat & (NOPOWER|BROKEN))
				for(var/mob/M in viewers(src))
					M.show_message("\red The [src.name] shuts down due to lack of power!")
				src.overlays = null
				src.active = 0
				spawn(1)
					src.cleanup1(1)
				spawn(1)
					src.cleanup1(2)
				spawn(1)
					src.cleanup1(4)
				spawn(1)
					src.cleanup1(8)


/obj/machinery/field_generator/ehprison1/proc/ehsetup1_field(var/NSEW = 0)
	var/turf/T = src.loc
	var/turf/T2 = src.loc
	var/obj/machinery/field_generator/ehprison1/G
	var/steps = 0
	var/oNSEW = 0

	if(!NSEW)//Make sure its ran right
		return

	if(NSEW == 1)
		oNSEW = 2
	else if(NSEW == 2)
		oNSEW = 1
	else if(NSEW == 4)
		oNSEW = 8
	else if(NSEW == 8)
		oNSEW = 4

	for(var/dist = 0, dist <= 3, dist += 1) // checks out to 1 tile away for another generator
		T = get_step(T2, NSEW)
		T2 = T
		steps += 1
		if(locate(/obj/machinery/field_generator/ehprison1) in T)
			G = (locate(/obj/machinery/field_generator/ehprison1) in T)
			steps -= 1
			if(!G.active)
				return
			G.cleanup1(oNSEW)
			break
	if(isnull(G))
		return

	T2 = src.loc

	for(var/dist = 0, dist < steps, dist += 1) // creates each field tile
		var/field_dir = get_dir(T2,get_step(T2, NSEW))
		T = get_step(T2, NSEW)
		T2 = T
		var/obj/machinery/shieldbeam/CF = new/obj/machinery/shieldbeam/(src, G) //(ref to this gen, ref to connected gen)
		CF.loc = T
		CF.dir = field_dir


/obj/machinery/field_generator/proc/cleanup1(var/NSEW)
	var/obj/machinery/shieldbeam/F
	var/obj/machinery/field_generator/ehprison1/G
	var/turf/T = src.loc
	var/turf/T2 = src.loc

	for(var/dist = 0, dist <= 3, dist += 1) // checks out to 8 tiles away for fields
		T = get_step(T2, NSEW)
		T2 = T
		if(locate(/obj/machinery/shieldbeam) in T)
			F = (locate(/obj/machinery/shieldbeam) in T)
			del(F)

		if(locate(/obj/machinery/field_generator/ehprison1) in T)
			G = (locate(/obj/machinery/field_generator/ehprison1) in T)
			if(!G.active)
				break


