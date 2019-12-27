/obj/decal/New()
	..()
	src.pixel_x = rand(-3.0, 3)
	src.pixel_y = rand(-3.0, 3)

//Poo
/obj/decal/cleanable/poo
	name = "poo"
	desc = "It's a poo stain..."
	density = 0
	anchored = 1
	layer = 2
	icon = 'pooeffect.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7", "floor8")
//	var/datum/disease/virus = null
	var/dried = 0
	decaltype = "poo"
//	blood_DNA = null
//	blood_type = null

/obj/decal/cleanable/poo/New()
	src.icon = 'pooeffect.dmi'
	src.icon_state = pick(src.random_icon_states)
//	spawn(5) src.reagents.add_reagent("poo",5)
	spawn(400)
		src.dried = 1

/obj/decal/cleanable/poo/tracks
	icon_state = "tracks"
	random_icon_states = null

/obj/decal/cleanable/poo/drip
	name = "drips of poo"
	desc = "It's brown."
	density = 0
	anchored = 1
	layer = 2
	icon = 'pooeffect.dmi'
	icon_state = "drip1"
	random_icon_states = list("drip1", "drip2", "drip3", "drip4", "drip5")
//	blood_DNA = null
//	blood_type = null

/obj/decal/cleanable/poo/proc/streak(var/list/directions)
	spawn (0)
		var/direction = pick(directions)
		for (var/i = 0, i < pick(1, 200; 2, 150; 3, 50; 4), i++)
			sleep(3)
			//if (i > 0)
			//	var/obj/decal/cleanable/poo/b = new /obj/decal/cleanable/poo(src.loc)
			//	if (src.virus)
			//		b.virus = src.virus
			if (step_to(src, get_step(src, direction), 0))
				break

/obj/decal/cleanable/poo/HasEntered(AM as mob|obj)
	if (istype(AM, /mob/living/carbon) && src.dried == 0)
		var/mob/M =	AM
		if ((istype(M, /mob/living/carbon/human) && istype(M:shoes, /obj/item/clothing/shoes/galoshes)) || M.m_intent == "walk")
			return

		M.pulling = null
		M << "\blue You slipped on the wet poo stain!"
		M.achievement_give("Oh Shit!", 68)
		playsound(src.loc, 'slip.ogg', 50, 1, -3)
		M.stunned = 6
		M.weakened = 5

/obj/decal/cleanable/poo/tracks/HasEntered(AM as mob|obj)
	return

/obj/decal/cleanable/poo/drip/HasEntered(AM as mob|obj)
	return

//Urine
/obj/decal/cleanable/urine
	name = "Urine puddle"
	desc = "Someone couldn't hold it.."
	density = 0
	anchored = 1
	layer = 2
	icon = 'pooeffect.dmi'
	icon_state = "pee1"
	random_icon_states = list("pee1", "pee2", "pee3")
//	var/datum/disease/virus = null
	decaltype = "urine"
//	blood_DNA = null
//	blood_type = null

/obj/decal/cleanable/urine/HasEntered(AM as mob|obj)
	if (istype(AM, /mob/living/carbon))
		var/mob/M =	AM
		if ((istype(M, /mob/living/carbon/human) && istype(M:shoes, /obj/item/clothing/shoes/galoshes)) || M.m_intent == "walk")
			return

		M.pulling = null
		M << "\blue You slipped in the urine puddle!"
		M.achievement_give("Pissed!", 69)
		playsound(src.loc, 'slip.ogg', 50, 1, -3)
		M.stunned = 8
		M.weakened = 5

/obj/decal/cleanable/urine/New()
	src.icon_state = pick(src.random_icon_states)
//	spawn(10) src.reagents.add_reagent("urine",5)
//	..()
	spawn(800)
		del(src)

//Cum
/obj/decal/cleanable/cum
	name = "cum"
	desc = "Uh oh, better clean this up..."
	density = 0
	anchored = 1
	layer = 2
	icon = 'blood.dmi'
	icon_state = "cum1"
	random_icon_states = list("cum1", "cum2", "cum3", "cum4", "cum5")
//	var/datum/disease/virus = null
	decaltype = "cum"
//	blood_DNA = null
//	blood_type = null

/obj/decal/cleanable/cum/New()
	src.icon_state = pick(src.random_icon_states)
//	spawn(10) src.reagents.add_reagent("urine",5)
//	..()
//	spawn(800)
//		del(src)


//Chemical Spill
/obj/decal/cleanable/chemical
	name = "spill"
	desc = "A chemical spill."
	density = 0
	anchored = 1
	layer = 2
	icon = 'effects.dmi'
	icon_state = "blankicon"
	var/datum/reagent/reagent_primary
	var/datum/reagent/reagent_secondary
	var/age = 0.0

/obj/decal/cleanable/chemical/New()
	spawn(10)
		var/datum/reagents/R = new/datum/reagents(100)
		reagents = R
		R.my_atom = src
		if(reagents)
			if(reagents.total_volume)
				update_icon()
				process()
			else
				del(src)

/obj/decal/cleanable/chemical/proc/process()
	if(reagents)
		if(reagents.total_volume)
			reagent_primary = reagents.get_master_reagent_reference()
			if(reagents.reagent_list.len > 1)
				reagent_secondary = reagents.get_secondary_reagent_reference()
				var/obj/decal/cleanable/chemical/C = new /obj/decal/cleanable/chemical
				C.loc = loc
				reagents.trans_id_to(C, reagent_secondary, reagent_secondary.volume)
			for(var/obj/decal/cleanable/chemical/S in src.loc)
				if(type == S.type)
					if(reagents.get_master_reagent_name() == S.reagents.get_master_reagent_name())
						S.reagents.trans_to(src, S.reagents.total_volume)
						del(S)
			if(isturf(src.loc))
				temperature_expose(null, src.loc:temperature, null)
				update_icon()
			spawn(20)
				checkevaporation()
				if(src)
					process()
		else
			del(src)

/obj/decal/cleanable/chemical/proc/checkevaporation()
	age += 10
	if(reagent_primary.reagent_state == SOLID)
		return
	if((reagent_primary.reagent_state == LIQUID) && age >= 600)
		del(src)
	if((reagent_primary.reagent_state == GAS) && age >= 60)
		del(src)
	else
		del(src)

/obj/decal/cleanable/chemical/update_icon()
	if(reagent_primary.reagent_state == SOLID)
		icon_state = "chemicalsolid"
	if(reagent_primary.reagent_state == LIQUID)
		icon_state = "chemicalliquid"
	if(reagent_primary.reagent_state == GAS)
		icon_state = "chemicalgas"

/obj/decal/cleanable/chemical/attackby(var/obj/item/I as obj, var/mob/user as mob)
	if(istype(I, /obj/item/weapon/reagent_containers/))
		if(reagent_primary.reagent_state == SOLID)
			if(reagents.total_volume)
				reagents.trans_to(I, src.reagents.total_volume)
				for(var/mob/O in viewers(world.view, src))
					O.show_message(text("\blue [user] scoops up the [src.name] with the [I.name]!"), 1)
				if(!reagents.total_volume)
					del(src)