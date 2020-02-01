

/obj/spaceship/testship
	name = "testship"
	icon = 'spaceships.dmi'
	var/list/turf/spaceship/filler/parts = list()
	var/list/mob/passengers = list()
	var/list/cargo = list()
	var/id_tag = ""

/obj/spaceship/testship/New()
	for(var/turf/spaceship/filler/F in world)
		if(F.id_tag == id_tag)
			parts += F


/turf/spaceship/filler
	density = 1
	opacity = 1
	var/id_tag = ""