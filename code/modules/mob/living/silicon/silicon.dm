/mob/living/silicon/proc/cancelAlarm()
	return

/mob/living/silicon/proc/triggerAlarm()
	return

/mob/living/silicon/proc/show_laws()
	return

/mob/living/silicon/emp_act(severity)
	src.fireloss += 25
	flick("noise", src:flash)
	src << "\red <B>*BZZZT*</B>"
	src << "\red Warning: Electromagnetic pulse detected."
	..()

/mob/living/silicon/proc/damage_mob(var/brute = 0, var/fire = 0, var/tox = 0)
	return

/mob/living/silicon/pai/proc/medicalHUD()
	if(client)
		var/icon/tempHud = 'hud.dmi'
		var/turf/T = get_turf_or_move(src.loc)
		for(var/mob/living/carbon/human/patient in view(T))

			var/foundVirus = 0
			for(var/datum/disease/D in patient.virus) foundVirus = 1

			client.images += image(tempHud,patient,"hud[RoundHealth(patient.health)]")
			if(patient.stat == 2)
				client.images += image(tempHud,patient,"huddead")
			else if(patient.alien_egg_flag)
				client.images += image(tempHud,patient,"hudxeno")
			else if(foundVirus)
				client.images += image(tempHud,patient,"hudill")
			else
				client.images += image(tempHud,patient,"hudhealthy")