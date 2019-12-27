// GLASSES

/obj/item/clothing/glasses
	name = "glasses"
	icon = 'glasses.dmi'
	w_class = 2.0
	flags = GLASSESCOVERSEYES

/obj/item/clothing/glasses/blindfold
	name = "blindfold"
	desc = "Makes you like...blind."
	icon_state = "blindfold"
	item_state = "blindfold"

/obj/item/clothing/glasses/meson
	name = "Optical Meson Scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	item_state = "glasses"
	origin_tech = "magnets=2;engineering=2"

/obj/item/clothing/glasses/meson/sollux
	name = "Sollux' Glasses"
	desc = "One side red, one side blue!"
	icon_state = "sollux"
	item_state = "glasses"

/obj/item/clothing/glasses/night
	name = "Night Vision Goggles"
	desc = "You can totally see in the dark now!."
	icon_state = "night"
	item_state = "glasses"
	origin_tech = "magnets=2"

/obj/item/clothing/glasses/material
	name = "Optical Material Scanner"
	desc = "Very confusing glasses."
	icon_state = "material"
	item_state = "glasses"
	origin_tech = "magnets=3;engineering=3"

/obj/item/clothing/glasses/regular
	name = "Prescription Glasses"
	desc = "Made by Nerd. Co."
	icon_state = "glasses"
	item_state = "glasses"

/obj/item/clothing/glasses/gglasses
	name = "Green Glasses"
	desc = "Forest green glasses, like the kind you'd wear when hatching a nasty scheme."
	icon_state = "gglasses"
	item_state = "gglasses"

/obj/item/clothing/glasses/sunglasses
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Enhanced shielding blocks many flashes."
	name = "Sunglasses"
	icon_state = "sun"
	item_state = "sunglasses"
	protective_temperature = 1300
	var/already_worn = 0

/obj/item/clothing/glasses/thermal
	name = "Optical Thermal Scanner"
	desc = "Thermals in the shape of glasses."
	icon_state = "thermal"
	item_state = "glasses"
	origin_tech = "magnets=3"

/obj/item/clothing/glasses/thermal/monocle
	name = "Thermoncle"
	desc = "A monocle thermal."
	icon_state = "thermoncle"
	flags = null //doesn't protect eyes because it's a monocle, duh

/obj/item/clothing/glasses/opticlink
	name = "neuro-link visor"
	desc = "An artificial eye system for the blind."
	icon_state = "opticlink"
	item_state = "opticlink"
	origin_tech = "magnets=3"

/obj/item/clothing/glasses/ecto
	name = "Ecto Goggles"
	desc = "Experimental goggles that can track forces of life (and death)."
	icon_state = "gglasses"
	item_state = "gglasses"

/obj/item/clothing/glasses/thermal/eyepatch
	name = "Optical Thermal Eyepatch"
	desc = "An eyepatch with built-in thermal optics"
	icon_state = "eyepatch"
	item_state = "eyepatch"

/obj/item/clothing/glasses/hud
	name = "HUD"
	desc = "A heads-up display that provides important info in (almost) real time."
	flags = null //doesn't protect eyes because it's a monocle, duh

/obj/item/clothing/glasses/hud/health
	name = "Health Scanner HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their health status."
	icon_state = "healthhud"
	var/list/icon/current = list() //the current hud icons

/obj/item/clothing/glasses/hud/telepathic
	name = "Telepathic Amplifier"
	desc = "A psychic stimulator that amplifies telepathic powers inherent to the user. (Results may vary)"
	icon_state = "Telepathic"
	var/list/icon/current = list() //the current hud icons
	var/power = 500
	var/on = null
/*
/obj/item/clothing/glasses/hud/telepathic/process()
	if(on)
		if(power > 0)
			power--
		else
			on = 0
			for(var/mob/O in viewers(src, null))
				O.show_message("\red the [name] shuts down due to a lack of power", 1)
				for(var/mob/living/carbon/human/user in src.loc)
					user.takepowers()
					user.expandedmind = 0
		sleep(25)
	else
		power++
		sleep(25)

/obj/item/clothing/glasses/hud/telepathic/attack_self(mob/living/carbon/human/user as mob)
	if(on)
		on = 0
		user << "\blue You switch off the [name]"
		user.takepowers()
		user.expandedmind = 0

	else if(!on)
		on = 1
		user << "\blue You feel your mind expand as you turn on the [name]"
		user.grantpowers()
		user.expandedmind = 1*/

/obj/item/clothing/glasses/hud/security
	name = "Security HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their ID status."
	icon_state = "securityhud"
	var/list/icon/current = list() //the current hud icons

/proc/RoundHealth(health)
	switch(health)
		if(100 to INFINITY)
			return "health100"
		if(70 to 100)
			return "health80"
		if(50 to 70)
			return "health60"
		if(30 to 50)
			return "health40"
		if(20 to 30)
			return "health25"
		if(5 to 15)
			return "health10"
		if(1 to 5)
			return "health1"
		if(-99 to 0)
			return "health0"
		else
			return "health-100"
	return "0"