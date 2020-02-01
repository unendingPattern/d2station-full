


/area/Turbolift1/
	name = "Turbolift Sercurity"
	icon_state = "Turbo"
	requires_power = 1
	luminosity = 1
	sd_lighting = 0
	requires_power = 0

/area/replace/replace1
	name = "Turbolift Sercurity"
	icon_state = "Turbo"
	requires_power = 1
	luminosity = 1
	sd_lighting = 0
	requires_power = 0


/area/Turbolift2/
	name = "Turbolift HighSec"
	icon_state = "Turbo"
	requires_power = 1
	luminosity = 1
	sd_lighting = 0
	requires_power = 0

/area/replace/replace2
	name = "Turbolift Sercurity"
	icon_state = "Turbo"
	requires_power = 1
	luminosity = 1
	sd_lighting = 0
	requires_power = 0

/area/Turbolift3/
	name = "Turbolift Singularity"
	icon_state = "Turbo"
	requires_power = 1
	luminosity = 1
	sd_lighting = 0
	requires_power = 0

/area/replace/replace3
	name = "Turbolift Sercurity"
	icon_state = "Turbo"
	requires_power = 1
	luminosity = 1
	sd_lighting = 0
	requires_power = 0

/area/Turbolift4/
	name = "Turbolift Living Quaters"
	icon_state = "Turbo"
	requires_power = 1
	luminosity = 1
	sd_lighting = 0
	requires_power = 0

/area/replace/replace4
	name = "Turbolift Sercurity"
	icon_state = "Turbo"
	requires_power = 1
	luminosity = 1
	sd_lighting = 0
	requires_power = 0

/area/Turbolift5/
	name = "Turbolift Escape Hallway"
	icon_state = "Turbo"
	requires_power = 1
	luminosity = 1
	sd_lighting = 0
	requires_power = 0

/area/replace/replace5
	name = "Turbolift Sercurity"
	icon_state = "Turbo"
	requires_power = 1
	luminosity = 1
	sd_lighting = 0
	requires_power = 0

var/obj/machinery/computer/liftposition = 3

/obj/machinery/computer/Calllift
	name = "Call Turbolift Console"
	icon = 'stationobjs.dmi'
	icon_state = "gsensor1"
	req_access = 0
	/var/click = 1
	/var/power = 1
	/var/firsttime = 0
	var/id = 1.0

/obj/machinery/computer/Calllift/attack_paw()
	src.attack_hand()

/obj/machinery/computer/Calllift/attack_ai()
	src.attack_hand()

/obj/machinery/computer/Calllift/attack_hand()
	if(click == 1)
		sleep(50)
		view(15) << "<B>Please Mind the doors.</B>"
		var/area/start_location1 = locate(/area/Turbolift2)
		var/area/end_location1 = locate(/area/replace/replace2)
		var/area/start_location2 = locate(/area/Turbolift3)
		var/area/end_location2 = locate(/area/Turbolift2)
		var/area/start_location3 = locate(/area/replace/replace3)
		var/area/end_location3 = locate(/area/Turbolift3)
		spawn(1)
		start_location1.move_contents_to(end_location1)
		spawn(2)
		start_location2.move_contents_to(end_location2)
		spawn(3)
		start_location3.move_contents_to(end_location3)
		spawn(4)
		view(10) << "<B>Ding!</B>"
		click = 0
		return

	if(click == 0)
		liftposition = 2
		sleep(50)
		view(15) << "<B>Please Mind the doors.</B>"
		var/area/start_location1 = locate(/area/Turbolift3)
		var/area/end_location1 = locate(/area/replace/replace3)
		var/area/start_location2 = locate(/area/Turbolift2)
		var/area/end_location2 = locate(/area/Turbolift3)
		var/area/start_location3 = locate(/area/replace/replace2)
		var/area/end_location3 = locate(/area/Turbolift2)
		spawn(1)
		start_location1.move_contents_to(end_location1)
		spawn(2)
		start_location2.move_contents_to(end_location2)
		spawn(3)
		start_location3.move_contents_to(end_location3)
		spawn(4)
		view(10) << "<B>Ding!</B>"
		click = 1
		liftposition = 2
		return

/obj/machinery/computer/Selectlift
	name = "Destination Selector Panel"
	icon = 'stationobjs.dmi'
	icon_state = "gsensor1"
	/var/click1 = 1
	/var/postion = 3

/obj/machinery/computer/Selectlift/attack_paw()
	src.attack_hand()

/obj/machinery/computer/Selectlift/attack_ai()
	src.attack_hand()

/obj/machinery/computer/Selectlift/attack_hand()

	if(click == 1)
		liftposition = 2
		sleep(50)
		var/area/start_location1 = locate(/area/Turbolift2)
		var/area/end_location1 = locate(/area/replace/replace2)
		var/area/start_location2 = locate(/area/Turbolift3)
		var/area/end_location2 = locate(/area/Turbolift2)
		var/area/start_location3 = locate(/area/replace/replace3)
		var/area/end_location3 = locate(/area/Turbolift3)
		spawn(1)
		start_location1.move_contents_to(end_location1)
		spawn(2)
		start_location2.move_contents_to(end_location2)
		spawn(3)
		start_location3.move_contents_to(end_location3)
		spawn(4)
		view(10) << "<B>Ding!</B>"
		click = 0
		liftposition = 2
		return

	if(click == 0)
		liftposition = 2
		sleep(50)
		view(15) << "<B>Please Mind the doors.</B>"
		var/area/start_location1 = locate(/area/Turbolift3)
		var/area/end_location1 = locate(/area/replace/replace3)
		var/area/start_location2 = locate(/area/Turbolift2)
		var/area/end_location2 = locate(/area/Turbolift3)
		var/area/start_location3 = locate(/area/replace/replace2)
		var/area/end_location3 = locate(/area/Turbolift2)
		spawn(1)
		start_location1.move_contents_to(end_location1)
		spawn(2)
		start_location2.move_contents_to(end_location2)
		spawn(3)
		start_location3.move_contents_to(end_location3)
		spawn(4)
		view(10) << "<B>Ding!</B>"
		click = 1
		liftposition = 2
		return