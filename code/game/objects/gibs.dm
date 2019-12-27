//HUMANS

/proc/gibs(atom/location, var/list/viruses)
	new /obj/gibspawner/human(get_turf(location),viruses)

/proc/xgibs(atom/location, var/list/viruses)
	new /obj/gibspawner/xeno(get_turf(location),viruses)

/proc/robogibs(atom/location, var/list/viruses)
	new /obj/gibspawner/robot(get_turf(location),viruses)

/obj/gibspawner
	var/sparks = 0 //whether sparks spread on Gib()
	var/virusProb = 20 //the chance for viruses to spread on the gibs
	var/list/gibtypes = list()
	var/list/gibamounts = list()
	var/list/gibdirections = list() //of lists

	New(location, var/list/viruses)
		..()

		if(istype(loc,/turf)) //basically if a badmin spawns it
			Gib(loc,viruses)

	proc/Gib(atom/location, var/list/viruses = list())
		if(gibtypes.len != gibamounts.len || gibamounts.len != gibdirections.len)
			world << "\red Gib list length mismatch!"
			return

		var/obj/decal/cleanable/blood/gibs/gib = null
		for(var/datum/disease/D in viruses)
			if(D.spread_type == SPECIAL)
				del(D)

		if(sparks)
			var/datum/effects/system/spark_spread/s = new /datum/effects/system/spark_spread
			s.set_up(2, 1, location)
			s.start()

		for(var/i = 1, i<= gibtypes.len, i++)
			if(gibamounts[i])
				for(var/j = 1, j<= gibamounts[i], j++)
					var/gibType = gibtypes[i]
					gib = new gibType(location)

					if(viruses.len > 0)
						for(var/datum/disease/D in viruses)
							if(prob(virusProb))
								var/datum/disease/viruus = new D.type
								gib.viruses += viruus
								viruus.holder = gib
								viruus.spread_type = CONTACT_FEET
					var/list/directions = gibdirections[i]
					if(gib && directions && directions.len)
						gib.streak(directions)

		del(src)

/obj/gibspawner
	human
		gibtypes = list(/obj/decal/cleanable/blood/gibs/up,/obj/decal/cleanable/blood/gibs/down,/obj/decal/cleanable/blood/gibs,/obj/decal/cleanable/blood/gibs,/obj/decal/cleanable/blood/gibs/body,/obj/decal/cleanable/blood/gibs/limb,/obj/decal/cleanable/blood/gibs/core)
		gibamounts = list(1,1,1,1,1,1,1)

		New()
			gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), alldirs, alldirs, list())
			gibamounts[6] = pick(0,1,2)
			..()

	xeno
		gibtypes = list(/obj/decal/cleanable/xenoblood/xgibs/up,/obj/decal/cleanable/xenoblood/xgibs/down,/obj/decal/cleanable/xenoblood/xgibs,/obj/decal/cleanable/xenoblood/xgibs,/obj/decal/cleanable/xenoblood/xgibs/body,/obj/decal/cleanable/xenoblood/xgibs/limb,/obj/decal/cleanable/xenoblood/xgibs/core)
		gibamounts = list(1,1,1,1,1,1,1)

		New()
			gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), alldirs, alldirs, list())
			gibamounts[6] = pick(0,1,2)
			..()

	robot
		sparks = 1
		gibtypes = list(/obj/decal/cleanable/robot_debris/up,/obj/decal/cleanable/robot_debris/down,/obj/decal/cleanable/robot_debris,/obj/decal/cleanable/robot_debris,/obj/decal/cleanable/robot_debris,/obj/decal/cleanable/robot_debris/limb)
		gibamounts = list(1,1,1,1,1,1)

		New()
			gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), alldirs, alldirs)
			gibamounts[6] = pick(0,1,2)
			..()