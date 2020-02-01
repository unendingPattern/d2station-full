/datum/disease/appendicitis
	form = "Condition"
	name = "Appendicitis"
	max_stages = 3
	spread = "Acute"
	cure = "Surgery"
	affected_species = list("Human")
	affected_species2 = list(/mob/living/carbon/human)
	permeability_mod = 1
	contagious_period = 9001 //slightly hacky, but hey! whatever works, right?
	desc = "If left untreated the subject will become very weak, and may vomit often."
	severity = "Medium"
	longevity = 1000
	hidden = list(0, 1)
	why_so_serious = 2
/datum/disease/appendicitis/stage_act()
	..()
	switch(stage)
		if(1)
			if(prob(5)) affected_mob.emote("cough")
		if(2)
			if(prob(3))
				affected_mob << "\red You feel a stabbing pain in your abdomen!"
				affected_mob.stunned = rand(2,3)
				affected_mob.toxloss += 1
		if(3)
			if(prob(1))
				if (affected_mob.nutrition > 100)
					affected_mob.stunned = rand(4,6)
					affected_mob << "\red You throw up!"
				//	var/turf/location = affected_mob.loc
				//	if (istype(location, /turf/simulated))
			//			location.add_vomit_floor(affected_mob)
					affected_mob.nutrition -= 95
					affected_mob:toxloss = max(affected_mob:toxloss-1,0)
				else
					affected_mob << "\red You gag as you want to throw up, but there's nothing in your stomach!"
					affected_mob.weakened += 10
					affected_mob.toxloss += 3