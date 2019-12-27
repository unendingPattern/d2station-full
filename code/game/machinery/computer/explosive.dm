/obj/machinery/computer/prisoner
	name = "Prisoner Management"
	icon = 'computer.dmi'
	icon_state = "explosive"
	req_access = list(access_armory)

	var/id = 0.0
	var/temp = null
	var/status = 0
	var/timeleft = 60
	var/stop = 0.0
	var/screen = 0 // 0 - No Access Denied, 1 - Access allowed
	var/malf_access = 0

/obj/machinery/computer/prisoner/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/weapon/screwdriver))
		playsound(src.loc, 'Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			if (src.stat & BROKEN)
				user << "\blue The broken glass falls out."
				var/obj/computerframe/A = new /obj/computerframe( src.loc )
				new /obj/item/weapon/shard( src.loc )
				var/obj/item/weapon/circuitboard/prisoner/M = new /obj/item/weapon/circuitboard/prisoner( A )
				for (var/obj/C in src)
					C.loc = src.loc
				M.id = src.id
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = 1
				del(src)
			else
				user << "\blue You disconnect the monitor."
				var/obj/computerframe/A = new /obj/computerframe( src.loc )
				var/obj/item/weapon/circuitboard/prisoner/M = new /obj/item/weapon/circuitboard/prisoner( A )
				for (var/obj/C in src)
					C.loc = src.loc
				M.id = src.id
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = 1
				del(src)

	//else
	src.attack_hand(user)
	return

/obj/machinery/computer/prisoner/attack_ai(var/mob/user as mob)
	user << "\red Access Denied"
	if(user.icon_state == "ai-malf" && malf_access == 0)
		user << "\red BZZZZZZ..."
		spawn(20)
			user << "\red ...ZZZZZZ *BEEP*"
			sleep(10)
			user << "\red You now have access to Prisoner Management console"
			malf_access = 1
	if(malf_access == 1)
		return src.attack_hand(user)
	else
		return

/obj/machinery/computer/prisoner/attack_paw(var/mob/user as mob)
	return

/obj/machinery/computer/prisoner/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.machine = src
	var/dat
	dat += "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><B>Prisoner Implant Manager System</B><BR>"
	if(screen == 0)
		dat += "<HR><A href='?src=\ref[src];lock=1'>Unlock Console</A>"
	else if(screen == 1)
		dat += "<HR>Chemical Implants<BR>"
		for(var/obj/item/weapon/implant/chem/C in world)
			if(!C.implanted) continue
			dat += "[C.imp_in.name] | Remaining Units: [C.reagents.total_volume] | Inject: "
			dat += "<A href='?src=\ref[src];inject1=\ref[C]'>(<font color=red>(1)</font>)</A>"
			dat += "<A href='?src=\ref[src];inject5=\ref[C]'>(<font color=red>(5)</font>)</A>"
			dat += "<A href='?src=\ref[src];inject10=\ref[C]'>(<font color=red>(10)</font>)</A><BR>"
		dat += "<HR>Tracking Implants<BR>"
		for(var/obj/item/weapon/implant/tracking/T in world)
			if(!T.implanted) continue
			var/loc_display = "Unknown"
			var/mob/living/carbon/M = T.imp_in
			if(M.z == 1 && !istype(M.loc, /turf/space))
				var/turf/mob_loc = get_turf_loc(M)
				loc_display = mob_loc.loc
			dat += "ID: [T.id] | Location: [loc_display]<BR>"
		dat += "<HR><A href='?src=\ref[src];lock=1'>Lock Console</A>"

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/computer/prisoner/process()
	if(stat & (NOPOWER|BROKEN))
		return
	use_power(500)
	src.updateDialog()
	return

/obj/machinery/computer/prisoner/Topic(href, href_list)
	if(..())
		return
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.machine = src
		if (href_list["killimplant"])
			var/obj/item/weapon/implant/I = locate(href_list["killimplant"])
			var/mob/living/carbon/R = I.imp_in
			if(R)
				var/choice = null
				if(istype(usr, /mob/living/silicon))
					choice = input("Using this command is in violation of default laws.") in list("Continue", "Abort")
				if(choice != "Abort")
					choice = input("Are you certain you wish to detonate [R.name]?") in list("Confirm", "Abort")
				if(choice == "Confirm")
					R << "You hear quiet beep from the base of your skull."
					if(prob(95))
						R.gib()
						message_admins("\blue [key_name_admin(usr)] killswitched [R.name]")
						log_game("[key_name(usr)] killswitched [R.name]")
					else
						R << "\blue you hear a click as the implant fails to detonate and disintegrates."

		else if (href_list["disable"])
			var/choice = strip_html(input("Are you certain you wish to deactivate the implant?")) in list("Confirm", "Abort")
			if(choice == "Confirm")
				var/obj/item/weapon/implant/I = locate(href_list["disable"])
				var/mob/living/carbon/R = I.imp_in
				R << "You hear quiet beep from the base of your skull."
				if(prob(1))
					message_admins("\blue [key_name_admin(usr)] attempted to disarm [R.name]' implant but it glitched. Oops.")
					R.gib()
				else
					R << "\blue you hear a click as the implant disintegrates."
					del(I)

		else if (href_list["inject1"])
			var/obj/item/weapon/implant/I = locate(href_list["inject1"])
			var/mob/living/carbon/R = I.imp_in
			I.reagents.trans_to(R, 1)
			if(!I.reagents.total_volume)
				R << "You hear a faint click from your chest."
				del(I)

		else if (href_list["inject5"])
			var/obj/item/weapon/implant/I = locate(href_list["inject5"])
			var/mob/living/carbon/R = I.imp_in
			I.reagents.trans_to(R, 5)
			if(!I.reagents.total_volume)
				R << "You hear a faint click from your chest."
				del(I)

		else if (href_list["inject10"])
			var/obj/item/weapon/implant/I = locate(href_list["inject10"])
			var/mob/living/carbon/R = I.imp_in
			I.reagents.trans_to(R, 10)
			if(!I.reagents.total_volume)
				R << "You hear a faint click from your chest."
				del(I)

		else if (href_list["lock"])
			if(src.allowed(usr))
				screen = !screen
			else
				usr << "Unauthorized Access."

		else if (href_list["warn"])
			var/warning = strip_html(input(usr,"Message:","Enter your message here!",""))
			var/obj/item/weapon/implant/I = locate(href_list["warn"])
			var/mob/living/carbon/R = I.imp_in
			R << "\green You hear a voice in your head saying: '[warning]'"

		src.add_fingerprint(usr)
	src.updateUsrDialog()
	return


