/obj/machinery/disease2/isolator/
	name = "Pathogenic Isolator"
	density = 1
	anchored = 1
	icon = 'virology.dmi'
	icon_state = "isolator"
	var/datum/disease2/disease/virus2 = null
	var/isolating = 0
	var/beaker = null

	ex_act(severity)
		switch(severity)
			if(1.0)
				del(src)
				return
			if(2.0)
				if (prob(50))
					del(src)
					return

	blob_act()
		if (prob(25))
			del(src)

	meteorhit()
		del(src)
		return

	attackby(var/obj/item/weapon/reagent_containers/glass/B as obj, var/mob/user as mob)
		if(!istype(B,/obj/item/weapon/reagent_containers/syringe))
			return

		if(src.beaker)
			user << "A syringe is already loaded into the machine."
			return

		src.beaker =  B
		user.drop_item()
		B.loc = src
		if(istype(B,/obj/item/weapon/reagent_containers/syringe))
			user << "You add the syringe to the machine!"
			src.updateUsrDialog()
			icon_state = "isolator_in"

	Topic(href, href_list)
		if(stat & BROKEN) return
		if(usr.stat || usr.restrained()) return
		if(!in_range(src, usr)) return

		usr.machine = src
		if(!beaker) return
//		var/datum/reagents/R = beaker:reagents

		if (href_list["isolate"])
//			var/datum/reagent/S = R.get_reagent(href_list["isolate"])
//			if(S:virus2)
//				virus2 = S:virus2
//				isolating = 100
			icon_state = "isolator_processing"
			src.updateUsrDialog()
			return

		else if (href_list["main"])
			attack_hand(usr)
			return
		else if (href_list["eject"])
			beaker:loc = src.loc
			beaker = null
			icon_state = "isolator"
			src.updateUsrDialog()
			return

	attack_hand(mob/user as mob)
		if(stat & BROKEN)
			return
		user.machine = src
		var/dat = ""
		if(!beaker)
			dat = "Please insert sample into the isolator.<BR>"
			dat += "<A href='?src=\ref[src];close=1'>Close</A>"
		else if(isolating)
			dat = "Isolating"
		else
			var/datum/reagents/R = beaker:reagents
			dat += "<A href='?src=\ref[src];eject=1'>Eject</A><BR><BR>"
			if(!R.total_volume)
				dat += "[beaker] is empty."
			else
				dat += "Contained reagents:<BR>"
				for(var/datum/reagent/blood/G in R.reagent_list)
					dat += "    [G.name]: <A href='?src=\ref[src];isolate=[G.id]'>Isolate</a>"
		user << browse("<TITLE>Pathogenic Isolator</TITLE>Isolator menu:<BR><BR>[dat]", "window=isolator;size=575x400")
		onclose(user, "isolator")
		return




	process()
		if(isolating > 0)
			isolating -= 1
			if(isolating == 0)
//				var/obj/item/weapon/virusdish/d = new /obj/item/weapon/virusdish(src.loc)
//				d.virus2 = virus2.getcopy()
//				virus2 = null
				icon_state = "isolator_in"



