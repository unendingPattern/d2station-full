/obj
	//var/datum/module/mod		//not used
	var/m_amt = 0	// metal
	var/g_amt = 0	// glass
	var/w_amt = 0	// waster amounts
	var/origin_tech = null	//Used by R&D to determine what research bonuses it grants.
	var/reliability = 100	//Used by SOME devices to determine how reliable they are.
	var/crit_fail = 0
	var/unacidable = 0 //universal "unacidabliness" var, here so you can use it in any obj.
	animate_movement = 2
	var/throwforce = 0
	proc
		handle_internal_lifeform(mob/lifeform_inside_me, breath_request)
			//Return: (NONSTANDARD)
			//		null if object handles breathing logic for lifeform
			//		datum/air_group to tell lifeform to process using that breath return
			//DEFAULT: Take air from turf to give to have mob process
			if(breath_request>0)
				return remove_air(breath_request)
			else
				return null

		initialize()

/obj/blob
		name = "magma"
		icon = 'blob.dmi'
		icon_state = "bloba0"
		var/health = 1
		density = 1
		opacity = 0
		anchored = 1

/obj/blob/idle
		name = "magma"
		desc = "it looks... tasty"
		icon_state = "blobidle0"

/obj/mark
		var/mark = ""
		icon = 'mark.dmi'
		icon_state = "blank"
		anchored = 1
		layer = 99
		mouse_opacity = 0
		unacidable = 1//Just to be sure.

/obj/admins
	name = "admins"
	var/rank = null
	var/owner = null
	var/state = 1
	//state = 1 for playing : default
	//state = 2 for observing

/obj/bhole
	name = "black hole"
	icon = 'objects.dmi'
	desc = "FUCK FUCK FUCK AAAHHH"
	icon_state = "bhole2"
	opacity = 0
	unacidable = 1
	density = 0
	anchored = 1
	var/datum/effects/system/harmless_smoke_spread/smoke

/obj/solarbeacon
	name = "Beacon"
	icon = 'device.dmi'
	icon_state = "solarbeacon"
	anchored = 1.0
	opacity = 0
	density = 0

/obj/solarbeacon/New()
	src.overlays += icon('device.dmi', "solarbeacon_led")

/obj/beam
	name = "beam"
	unacidable = 1//Just to be sure.
	var/def_zone

/obj/beam/a_laser
	name = "a laser"
	icon = 'projectiles.dmi'
	icon_state = "laser"
	density = 1
	var/yo = null
	var/xo = null
	var/current = null
	var/life = 50.0
	anchored = 1.0
	flags = TABLEPASS

/obj/beam/a_plasma
	name = "a plasma pulse"
	icon = 'projectiles.dmi'
	icon_state = "plasmawep"
	density = 1
	var/yo = null
	var/xo = null
	var/current = null
	var/life = 50.0
	anchored = 1.0
	flags = TABLEPASS

/obj/beam/i_beam
	name = "i beam"
	icon = 'projectiles.dmi'
	icon_state = "ibeam"
	var/obj/beam/i_beam/next = null
	var/obj/item/device/infra/master = null
	var/limit = null
	var/visible = 0.0
	var/left = null
	anchored = 1.0
	flags = TABLEPASS

/obj/bedsheetbin
	name = "linen bin"
	desc = "A bin for containing bedsheets."
	icon = 'items.dmi'
	icon_state = "bedbin"
	var/amount = 23.0
	anchored = 1.0

/obj/begin
	name = "begin"
	icon = 'stationobjs.dmi'
	icon_state = "begin"
	anchored = 1.0
	unacidable = 1

/obj/bullet
	name = "bullet"
	icon = 'projectiles.dmi'
	icon_state = "bullet"
	throwforce = 0.1 //an attempt to make it possible to shoot your way through space
	density = 1
	unacidable = 1//Just to be sure.
	var/yo = null
	var/xo = null
	var/current = null
	var/def_zone
	anchored = 1.0
	flags = TABLEPASS

/obj/bullet/weakbullet

/obj/bullet/electrode
	name = "electrode"
	icon_state = "spark"

/obj/bullet/teleshot
	name = "teleshot"
	icon_state = "spark"
	var/failchance = 5
	var/obj/item/target = null

/obj/bullet/cbbolt
	name = "crossbow bolt"
	icon_state = "cbbolt"

/obj/bullet/neurodart
	name = "acid"
	icon_state = "toxin"

/obj/datacore
	name = "datacore"
	var/list/medical = list(  )
	var/list/general = list(  )
	var/list/security = list(  )

/obj/equip_e
	name = "equip e"
	var/mob/source = null
	var/s_loc = null
	var/t_loc = null
	var/obj/item/item = null
	var/place = null

/obj/equip_e/human
	name = "human"
	var/mob/living/carbon/human/target = null

/obj/equip_e/monkey
	name = "monkey"
	var/mob/living/carbon/monkey/target = null

/obj/grille
	desc = "A piece of metal with evenly spaced gridlike holes in it. Blocks large object but lets small items, gas, or energy beams through."
	name = "grille"
	icon = 'structures.dmi'
	icon_state = "grille"
	density = 1
	var/health = 10.0
	var/destroyed = 0.0
	anchored = 1.0
	flags = FPRINT | CONDUCT
	pressure_resistance = 5*ONE_ATMOSPHERE
	layer = 3

/obj/sign
	icon = 'decals.dmi'
	icon_state = "securearea"
	anchored = 1.0
	opacity = 0
	density = 0

/obj/sign/library
	desc = "Library"
	name = "Library"
	icon_state = "library"

/obj/sign/kitchen
	desc = "Kitchen"
	name = "Kitchen"
	icon_state = "kitchen"

/obj/sign/bar
	desc = "Bar"
	name = "Bar"
	icon_state = "bar"

/obj/sign/medbay
	desc = "Medbay"
	name = "Medbay"
	icon_state = "medbay"

/obj/sign/hydroponics
	desc = "Hydroponics"
	name = "Hydroponics"
	icon_state = "hydroponics"

/obj/sign/engineering
	desc = "Engineering"
	name = "Engineering"
	icon_state = "engineering"

/obj/sign/bridge
	desc = "Bridge"
	name = "Bridge"
	icon_state = "bridge"

/obj/sign/brig
	desc = "Brig"
	name = "Brig"
	icon_state = "brig"

/obj/sign/atmos
	desc = "Atmospherics"
	name = "Atmospherics"
	icon_state = "atmos"

/obj/sign/crew
	desc = "Dormitory"
	name = "Dormitory"
	icon_state = "crew"

/obj/sign/silenceplease
	desc = "A sign which indicates 'Silence Please'"
	name = "Silence Please"
	icon_state = "silenceplease"

/obj/sign/noshitlers
	desc = "A sign which reads 'No shitlers allowed'"
	name = "No shitlers allowed"
	icon_state = "noshitlers"

/obj/sign/cleanhands
	desc = "A sign which reads 'Clean hands save lives'"
	name = "Clean hands save lives"
	icon_state = "cleanhands"

/obj/sign/nsm1
	desc = "Punch-out!!"
	name = "Punch-out!!"
	icon_state = "nsm1"

/obj/sign/nsm2
	desc = "Punch-out!!"
	name = "Punch-out!!"
	icon_state = "nsm2"

/obj/sign/sign_securearea
	desc = "A warning sign which reads 'SECURE AREA'"
	name = "SECURE AREA"
	icon_state = "securearea"

/obj/sign/sign_fire
	desc = "A warning sign which reads 'COMBUSTIBLE MATERIALS'"
	name = "COMBUSTIBLE MATERIALS"
	icon_state = "fire"

/obj/sign/sign_bio
	desc = "A warning sign which reads 'BIOLOGICAL HAZARD AREA'"
	name = "BIOLOGICAL HAZARD AREA"
	icon_state = "bio"

/obj/sign/redcross
	desc = "A sign that marks an area, Medical Bay in this case."
	name = "Medical"
	icon_state = "redcross"

/obj/sign/examroom
	desc = "A sign that marks an area, Exam Room in this case."
	name = "EXAM"
	icon = 'decals.dmi'
	icon_state = "examroom"
	anchored = 1.0
	opacity = 0
	density = 0

/obj/sign/goldenplaque
	desc = "To be Robust is not an action or a way of life, but a mental state. Only those with the force of Will strong enough to act during a crisis, saving friend from foe, are truly Robust. Stay Robust my friends."
	name = "The Most Robust Men Award for Robustness"
	icon_state = "goldenplaque"

/obj/item/weapon/plaque_assembly
	desc = "Put this on a wall and engrave an epitaph"
	name = "Plaque Assembly"
	icon = 'decals.dmi'
	icon_state = "goldenplaque"

/obj/item/weapon/plaque_assembly/afterattack(atom/A as mob|obj|turf|area, mob/user as mob)
	if(istype(A,/turf/simulated/wall) || istype(A,/turf/simulated/shuttle/wall) || istype(A,/turf/unsimulated/wall))
		var/epitaph = input("What would you like to engrave", null)
		if(epitaph)
			var/obj/sign/goldenplaque/gp = new/obj/sign/goldenplaque(A)
			gp.name = epitaph
			gp.layer = 2.9
			del(src)

/obj/sign/sign_shock
	desc = "A warning sign which reads 'ELECTRICAL HAZARD AREA'"
	name = "ELECTRICAL HAZARD AREA"
	icon_state = "shock"

/obj/sign/sign_nosmoking
	desc = "A warning sign which reads 'NO SMOKING'"
	name = "NO SMOKING"
	icon_state = "nosmoking"

/obj/sign/sign_nosmoking2
	desc = "A warning sign which reads 'NO SMOKING'"
	name = "NO SMOKING"
	icon_state = "nosmoking2"

/obj/sign/sign_space
	desc = "A warning sign which reads 'EXTERNAL ACCESS'"
	name = "EXTERNAL ACCESS"
	icon_state = "space"

/obj/sign/sign_restricted
	desc = "A warning sign which reads 'NO ACCESS'"
	name = "NO ACCESS"
	icon_state = "Restricted"

/obj/sign/sign_inputport
	desc = "A sign which indicates an air input port."
	name = "CANISTER INPUT"
	icon_state = "input_port"

/obj/sign/sign_outputport
	desc = "A sign which indicates an air output port."
	name = "CANISTER OUTPUT"
	icon_state = "output_port"

/obj/sign/pipemarker/no2
	desc = "A small marker that indicates the preferred content of a pipe line"
	name = "nitrous oxide pipeline"
	icon_state = "pipemark_no2"

/obj/sign/pipemarker/o2
	desc = "A small marker that indicates the preferred content of a pipe line"
	name = "oxygen pipeline"
	icon_state = "pipemark_o2"

/obj/sign/pipemarker/co2
	desc = "A small marker that indicates the preferred content of a pipe line"
	name = "carbon dioxide pipeline"
	icon_state = "pipemark_co2"

/obj/sign/pipemarker/pl
	desc = "A small marker that indicates the preferred content of a pipe line"
	name = "plasma pipeline"
	icon_state = "pipemark_pl"

/obj/sign/pipemarker/air
	desc = "A small marker that indicates the preferred content of a pipe line"
	name = "mixed-air pipeline"
	icon_state = "pipemark_air"

/obj/sign/pipemarker/n2
	desc = "A small marker that indicates the preferred content of a pipe line"
	name = "nitrogen pipeline"
	icon_state = "pipemark_n2"

/obj/sign/tutorial
	icon = 'tutorial.dmi'

/obj/sign/tutorial/wasd
	desc = "Use the directional keys to navigate."
	name = "Use the directional keys to navigate."
	icon_state = "wasd"

/obj/sign/tutorial/info
	desc = "Click me!"
	name = "Tutorial sign"
	icon_state = "tutsign"

/obj/showcase
	name = "Showcase"
	icon = 'stationobjs.dmi'
	icon_state = "showcase_1"
	desc = "A stand with the empty body of a cyborg bolted to it."
	density = 1
	anchored = 1
	unacidable = 1//temporary until I decide whether the borg can be removed. -veyveyr

/obj/hud
	name = "hud"
	unacidable = 1
	var/mob/mymob = null
	var/list/adding = null
	var/list/other = null
	var/list/intents = null
	var/list/mov_int = null
	var/list/mon_blo = null
	var/list/m_ints = null
	var/obj/screen/druggy = null
	var/vimpaired = null
	var/obj/screen/alien_view = null
	var/obj/screen/g_dither = null
	var/obj/screen/blurry = null
	var/obj/screen/gogglemeson = null
	var/obj/screen/gogglethermal = null
	var/obj/screen/ectoglasses = null
	var/list/darkMask = null
	var/obj/screen/station_explosion = null
	var/h_type = /obj/screen

/obj/item
	name = "item"
	icon = 'items.dmi'
	var/icon_old = null
	var/abstract = 0.0
	var/force = null
	var/item_state = null
	var/damtype = "brute"
	var/r_speed = 1.0
	var/health = null
	var/burn_point = null
	var/burning = null
	var/hitsound = null
	var/w_class = 3.0
	var/gay = 0
	var/moneyvalue = 0
	flags = FPRINT | TABLEPASS
	pressure_resistance = 50
	var/obj/item/master = null

/obj/item/device
	icon = 'device.dmi'

/obj/item/device/detective_scanner
	name = "Scanner"
	desc = "Used to scan objects for DNA and fingerprints"
	icon_state = "forensic0"
	var/amount = 20.0
	var/printing = 0.0
	w_class = 3.0
	item_state = "electronic"
	flags = FPRINT | TABLEPASS | ONBELT | CONDUCT | USEDELAY
	origin_tech = "materials=1;magnets=3"

/obj/item/device/flash
	name = "flash"
	icon_state = "flash"
	var/l_time = 1.0
	var/shots = 5.0
	throwforce = 5
	w_class = 1.0
	throw_speed = 4
	throw_range = 10
	flags = FPRINT | TABLEPASS| CONDUCT
	item_state = "electronic"
	var/status = 1
	origin_tech = "materials=1;magnets=1"
/obj/item/device/flashlight
	name = "flashlight"
	desc = "A hand-held emergency light."
	icon_state = "flight0"
	var/on = 0
	var/brightness_on = 4 //luminosity when on
	var/icon_on = "flight1"
	var/icon_off = "flight0"
	w_class = 2
	item_state = "flight"
	flags = FPRINT | ONBELT | TABLEPASS | CONDUCT
	m_amt = 50
	g_amt = 20
	origin_tech = "materials=1"
/obj/item/device/flashlight/pen
	name = "penlight"
	desc = "A pen-sized light."
	icon_state = "plight0"
	flags = FPRINT | TABLEPASS | CONDUCT
	item_state = ""
	icon_on = "plight1"
	icon_off = "plight0"
	brightness_on = 3
	origin_tech = "materials=1"
/obj/gloryhole
	name = "a hole"
	desc = "A strange hole of some sorts."
	icon = 'stationobjs.dmi'
	icon_state = "gloryhole"
	anchored = 1
	density = 0

/obj/gloryhole/cock
	name = "a hole"
	desc = "A strange hole of some sorts."
	icon = 'stationobjs.dmi'
	icon_state = "gloryhole_cockmove"

/obj/item/device/healthanalyzer
	name = "Health Analyzer"
	icon_state = "health"
	item_state = "analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	flags = FPRINT | ONBELT | TABLEPASS | CONDUCT
	throwforce = 3
	w_class = 1.0
	throw_speed = 5
	throw_range = 10
	m_amt = 200
	origin_tech = "materials=1;magnets=3;biotech=3"
/obj/item/device/Tricorder
	name = "Medical Tricorder"
	icon_state = "healthimproved"
	item_state = "analyzer"
	desc = "The medical tricorder is used by doctors to help diagnose diseases and collect bodily information about a patient."
	flags = FPRINT | ONBELT | TABLEPASS | CONDUCT
	throwforce = 3
	w_class = 1.0
	throw_speed = 5
	throw_range = 10
	m_amt = 200
	origin_tech = "materials=2;magnets=4;biotech=4"
/obj/item/device/igniter
	name = "igniter"
	desc = "A small electronic device able to ignite combustable substances."
	icon_state = "igniter"
	var/status = 1.0
	flags = FPRINT | TABLEPASS| CONDUCT
	item_state = "electronic"
	m_amt = 100
	throwforce = 5
	w_class = 1.0
	throw_speed = 3
	throw_range = 10
	origin_tech = "materials=2"

/obj/item/device/infra
	name = "Infrared Beam (Security)"
	desc = "Emits a visible or invisible beam and is triggered when the beam is interrupted."
	icon_state = "infrared0"
	var/obj/beam/i_beam/first = null
	var/state = 0.0
	var/visible = 0.0
	flags = FPRINT | TABLEPASS| CONDUCT
	w_class = 2.0
	item_state = "electronic"
	m_amt = 150
	origin_tech = "materials=2"
/obj/item/device/infra_sensor
	name = "Infrared Sensor"
	desc = "Scans for infrared beams in the vicinity."
	icon_state = "infra_sensor"
	var/passive = 1.0
	flags = FPRINT | TABLEPASS| CONDUCT
	item_state = "electronic"
	m_amt = 150
	origin_tech = "materials=2"
/obj/item/device/t_scanner
	name = "T-ray scanner"
	desc = "A terahertz-ray emitter and scanner used to detect underfloor objects such as cables and pipes."
	icon_state = "t-ray0"
	var/on = 0
	flags = FPRINT|ONBELT|TABLEPASS
	w_class = 2
	item_state = "electronic"
	m_amt = 150
	origin_tech = "materials=2;magnets=2"

/obj/item/device/multitool
	name = "multitool"
	icon_state = "multitool"
	flags = FPRINT | TABLEPASS| CONDUCT
	force = 5.0
	w_class = 2.0
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3
	desc = "You can use this on airlocks or APCs to try to hack them without cutting wires."
	m_amt = 50
	g_amt = 20
	origin_tech = "materials=2;magnets=2"

/obj/item/device/prox_sensor
	name = "Proximity Sensor"
	icon_state = "motion0"
	var/state = 0.0
	var/timing = 0.0
	var/time = null
	flags = FPRINT | TABLEPASS| CONDUCT
	w_class = 2.0
	item_state = "electronic"
	m_amt = 300
	origin_tech = "materials=2;magnets=2"

/obj/item/device/shield
	name = "shield"
	icon_state = "shield0"
	var/active = 0.0
	flags = FPRINT | TABLEPASS| CONDUCT
	item_state = "electronic"
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	origin_tech = "materials=2;magnets=5"

/obj/item/device/timer
	name = "timer"
	icon_state = "timer0"
	item_state = "electronic"
	var/timing = 0.0
	var/time = null
	flags = FPRINT | TABLEPASS| CONDUCT
	w_class = 2.0
	m_amt = 100
	origin_tech = "materials=1;magnets=1"

/obj/item/blueprints
	name = "station blueprints"
	desc = "Blueprints of the station. There's stamp \"Classified\" and several coffee stains on it."
	icon = 'items.dmi'
	icon_state = "blueprints"

/obj/item/apc_frame
	name = "APC frame"
	desc = "Used for repairing or building APCs"
	icon = 'apc_repair.dmi'
	icon_state = "apc_frame"
	flags = FPRINT | TABLEPASS| CONDUCT

/obj/landmark
	name = "landmark"
	icon = 'screen1.dmi'
	icon_state = "x2"
	anchored = 1.0
	unacidable = 1

/obj/landmark/alterations
	name = "alterations"

/obj/laser
	name = "laser"
	icon = 'projectiles.dmi'
	var/damage = 0.0
	var/range = 10.0

/obj/lattice
	desc = "A lightweight support lattice."
	name = "lattice"
	icon = 'structures.dmi'
	icon_state = "latticefull"
	density = 0
	anchored = 1.0
	layer = 2.3 //under pipes
	//	flags = 64.0

/obj/lattice/New()
	..()
	if(!(istype(src.loc, /turf/space)))
		del(src)
	for(var/obj/lattice/LAT in src.loc)
		if(LAT != src)
			del(LAT)
	icon_state = "latticeblank"
	updateOverlays()
	for (var/dir in cardinal)
		var/obj/lattice/L
		if(locate(/obj/lattice, get_step(src, dir)))
			L = locate(/obj/lattice, get_step(src, dir))
			L.updateOverlays()

/obj/lattice/Del()
	for (var/dir in cardinal)
		var/obj/lattice/L
		if(locate(/obj/lattice, get_step(src, dir)))
			L = locate(/obj/lattice, get_step(src, dir))
			L.updateOverlays(src.loc)
	..()

/obj/lattice/proc/updateOverlays()
	//if(!(istype(src.loc, /turf/space)))
	//	del(src)
	spawn(1)
		overlays = list()
		overlays += icon(icon,"lattice-middlebar") //the nw-se bar in the cneter
		for (var/dir in cardinal)
			if(locate(/obj/lattice, get_step(src, dir)))
				src.overlays += icon(icon,"lattice-[dir2text(dir)]")
			else
				src.overlays += icon(icon,"lattice-nc-[dir2text(dir)]") //t for turf
				if(!(istype(get_step(src, dir), /turf/space)))
					src.overlays += icon(icon,"lattice-t-[dir2text(dir)]") //t for turf

		//if ( !( (locate(/obj/lattice, get_step(src, SOUTH))) || (locate(/obj/lattice, get_step(src, EAST))) ))
		//	src.overlays += icon(icon,"lattice-c-se")
		if ( !( (locate(/obj/lattice, get_step(src, NORTH))) || (locate(/obj/lattice, get_step(src, WEST))) ))
			src.overlays += icon(icon,"lattice-c-nw")
		if ( !( (locate(/obj/lattice, get_step(src, NORTH))) || (locate(/obj/lattice, get_step(src, EAST))) ))
			src.overlays += icon(icon,"lattice-c-ne")
		if ( !( (locate(/obj/lattice, get_step(src, SOUTH))) || (locate(/obj/lattice, get_step(src, WEST))) ))
			src.overlays += icon(icon,"lattice-c-sw")

		if(!(overlays))
			icon_state = "latticefull"

/obj/list_container
	name = "list container"

/obj/list_container/mobl
	name = "mobl"
	var/master = null

	var/list/container = list(  )

/obj/m_tray
	name = "morgue tray"
	icon = 'stationobjs.dmi'
	icon_state = "morguet"
	density = 1
	layer = 2.0
	var/obj/morgue/connected = null
	anchored = 1.0

/obj/c_tray
	name = "crematorium tray"
	icon = 'stationobjs.dmi'
	icon_state = "cremat"
	density = 1
	layer = 2.0
	var/obj/crematorium/connected = null
	anchored = 1.0





/obj/cable
	level = 1
	anchored =1
	var/netnum = 0
	name = "power cable"
	desc = "A flexible superconducting cable for heavy-duty power transfer."
	icon = 'power_cond.dmi'
	icon_state = "0-1"
	var/d1 = 0
	var/d2 = 1
	layer = 2.5

/obj/manifest
	name = "manifest"
	icon = 'screen1.dmi'
	icon_state = "x"
	unacidable = 1//Just to be sure.

/obj/morgue
	name = "morgue"
	icon = 'stationobjs.dmi'
	icon_state = "morgue1"
	density = 1
	var/obj/m_tray/connected = null
	anchored = 1.0

/obj/crematorium
	name = "crematorium"
	desc = "A human incinerator."
	icon = 'stationobjs.dmi'
	icon_state = "crema1"
	density = 1
	var/obj/c_tray/connected = null
	anchored = 1.0
	var/cremating = 0
	var/id = 1
	var/locked = 0

/obj/mine
	name = "Mine"
	desc = "I Better stay away from that thing."
	density = 1
	anchored = 1
	layer = 3
	icon = 'weapons.dmi'
	icon_state = "uglymine"
	var/triggerproc = "explode" //name of the proc thats called when the mine is triggered
	var/triggered = 0

/obj/mine/dnascramble
	name = "Radiation Mine"
	icon_state = "uglymine"
	triggerproc = "triggerrad"

/obj/mine/plasma
	name = "Plasma Mine"
	icon_state = "uglymine"
	triggerproc = "triggerplasma"

/obj/mine/kick
	name = "Kick Mine"
	icon_state = "uglymine"
	triggerproc = "triggerkick"

/obj/mine/n2o
	name = "N2O Mine"
	icon_state = "uglymine"
	triggerproc = "triggern2o"

/obj/mine/stun
	name = "Stun Mine"
	icon_state = "uglymine"
	triggerproc = "triggerstun"

/obj/overlay
	name = "overlay"
	unacidable = 1

/obj/overlay/gas
	name = "particulate"
	unacidable = 1
	mouse_opacity = 0
	icon = 'tile_effects.dmi'

/obj/overlay/gas/plasma
	name = "particulate"
	icon_state = "plasma"

/obj/overlay/gas/sleeping_agent
	name = "particulate"
	icon_state = "sleeping_agent"

/obj/portal
	name = "portal"
	icon = 'stationobjs.dmi'
	icon_state = "portal"
	density = 1
	unacidable = 1//Can't destroy energy portals.
	var/failchance = 5
	var/obj/item/target = null
	var/creator = null
	anchored = 1.0

/obj/projection
	name = "Projection"
	anchored = 1.0

/obj/rack
	name = "rack"
	icon = 'objects.dmi'
	icon_state = "rack"
	density = 1
	flags = FPRINT
	anchored = 1.0

/obj/screen
	name = "screen"
	icon = 'screen1.dmi'
	layer = 20.0
	unacidable = 1
	var/id = 0.0
	var/obj/master

/obj/screen/close
	name = "close"
	master = null

/obj/screen/grab
	name = "grab"
	master = null

/obj/screen/storage
	name = "storage"
	master = null

/obj/screen/zone_sel
	name = "Damage Zone"
	icon = 'zone_sel.dmi'
	icon_state = "blank"
	var/selecting = "chest"
	screen_loc = "EAST+1,NORTH"

/obj/shut_controller
	name = "shut controller"
	var/moving = null
	var/list/parts = list(  )

/obj/landmark/start
	name = "start"
	icon = 'screen1.dmi'
	icon_state = "x"
	anchored = 1.0

/obj/stool
	name = "stool"
	icon = 'objects.dmi'
	icon_state = "stool"
	flags = FPRINT
	pressure_resistance = 3*ONE_ATMOSPHERE

/obj/stool/bed
	name = "bed"
	icon_state = "bed"
	desc = "Suprisingly it's more comfortable than sleeping on the floor."
	anchored = 1.0
	var/list/buckled_mobs = list(  )

/obj/stool/chair
	name = "chair"
	icon_state = "chair"
	var/status = 0.0
	anchored = 1.0
	var/list/buckled_mobs = list(  )

/obj/stool/chair/e_chair
	name = "electrified chair"
	icon_state = "e_chair0"
	var/atom/movable/overlay/overl = null
	var/on = 0.0
	var/obj/item/assembly/shock_kit/part1 = null
	var/last_time = 1.0

/obj/table
	name = "table"
	icon = 'structures.dmi'
	icon_state = "table"
	desc = "Some people actually put things on tables, did you know that?"
	density = 1
	anchored = 1.0

/obj/table/reinforced
	name = "reinforced table"
	icon_state = "reinf_table"
	var/status = 2

/obj/table/reinforcedb
	name = "reinforced table"
	icon_state = "reinf_tabledir1"
	var/status = 2

/obj/table/woodentable
	name = "wooden table"
	icon_state = "woodentable"

/obj/table/cheftable
	name = "reinforced table"
	icon_state = "reinf_cheftable"

/obj/mopbucket
	desc = "Fill it with water, but don't forget a mop!"
	name = "mop bucket"
	icon = 'janitor.dmi'
	icon_state = "mopbucket"
	density = 1
	flags = FPRINT
	pressure_resistance = ONE_ATMOSPHERE
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	var/amount_per_transfer_from_this = 5

/obj/kitchenspike
	name = "a meat spike"
	icon = 'kitchen.dmi'
	icon_state = "spike"
	desc = "A spike for collecting meat from animals"
	density = 1
	anchored = 1
	var/meat = 0
	var/occupied = 0
	var/meattype = 0 // 0 - Nothing, 1 - Monkey, 2 - Xeno

/obj/tree
	name = "tree"
	icon = 'trees.dmi'
	icon_state = "winterpine"
	desc = "A tree."
	density = 1
	anchored = 1
	opacity = 1
	pixel_x = -16
	layer = 6

/obj/datablade
	name = "datacore"
	icon = 'stationobjs.dmi'
	icon_state = "ai-ambience"
	density = 1
	anchored = 1
	opacity = 0

/obj/displaycase
	name = "Display Case"
	icon = 'stationobjs.dmi'
	icon_state = "glassbox1"
	desc = "A display case for prized possessions."
	density = 1
	anchored = 1
	unacidable = 1//Dissolving the case would also delete the gun.
	var/health = 30
	var/occupied = 1
	var/destroyed = 0

/obj/item/brain
	name = "brain"
	icon = 'surgery.dmi'
	icon_state = "brain2"
	flags = TABLEPASS
	force = 1.0
	w_class = 1.0
	throwforce = 1.0
	throw_speed = 3
	throw_range = 5
	origin_tech = "biotech=3"
	var/mob/living/carbon/human/owner = null
	var/mob/living/carbon/brain/brainmob = null

/obj/item/brain/New()
	..()
	spawn(5)
		if(src.owner)
			src.name = "[src.owner]'s brain"
			//Shifting the brain "mob" over to the brain object so it's easier to keep track of. --NEO
			brainmob = new /mob/living/carbon/brain
			brainmob.loc = src
			brainmob.name = owner.real_name
			brainmob.real_name = owner.real_name
			if(src.owner.mind)
				src.owner.mind.transfer_to(brainmob)
			brainmob.death() //the brain is dead until stuffed into an MMI. In which case it might still be dead if it's been beat up.
			if(brainmob.client)
				brainmob.client.screen.len = null //clear the hud
			brainmob << "\blue You might feel slightly disoriented."

/obj/item/brain/Del()
	if(src.brainmob)
		if(src.brainmob.client)
			var/mob/dead/observer/newmob
			newmob = new/mob/dead/observer
			newmob.loc = get_turf(src)
			src.brainmob:client:mob = newmob
			newmob:client:eye = newmob
	..()


/obj/noticeboard
	name = "Notice Board"
	icon = 'stationobjs.dmi'
	icon_state = "nboard00"
	flags = FPRINT
	desc = "A board for pinning important notices upon."
	density = 0
	anchored = 1
	var/notices = 0

/obj/priceboard
	name = "pricing board"
	icon = 'stationobjs.dmi'
	icon_state = "priceboard"
	flags = FPRINT
	desc = "A price board, click to view it."
	density = 0
	anchored = 1
	var/items = "none"

/obj/mapboard
	name = "Map of Space Station 13"
	icon = 'stationobjs.dmi'
	icon_state = "mapboard"
	flags = FPRINT
	desc = "A map of the station. Click to view it."
	density = 0
	anchored = 1

/obj/mapboard/New()
	name = "Map of [station_name]"
	desc = "A map of [station_name]. Click to view it."

/obj/deskclutter
	name = "desk clutter"
	icon = 'items.dmi'
	icon_state = "deskclutter"
	desc = "Some clutter the detective has accumalated over the years..."
	anchored = 1

/obj/item/mouse_drag_pointer = MOUSE_ACTIVE_POINTER

// TODO: robust mixology system! (and merge with beakers, maybe)
/obj/item/weapon/glass
	name = "empty glass"
	icon = 'kitchen.dmi'
	icon_state = "glass_empty"
	item_state = "beaker"
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	var/datum/substance/inside = null
	throwforce = 5
	g_amt = 100
	New()
		..()
		src.pixel_x = rand(-5, 5)
		src.pixel_y = rand(-5, 5)

/obj/item/weapon/storage/glassbox
	name = "Glassware Box"
	icon_state = "beakerbox"
	item_state = "syringe_kit"
	New()
		..()
		new /obj/item/weapon/glass( src )
		new /obj/item/weapon/glass( src )
		new /obj/item/weapon/glass( src )
		new /obj/item/weapon/glass( src )
		new /obj/item/weapon/glass( src )
		new /obj/item/weapon/glass( src )
		new /obj/item/weapon/glass( src )

/obj/item/weapon/storage/cupbox
	name = "Paper-cup Box"
	icon_state = "box"
	item_state = "syringe_kit"
	New()
		..()
		new /obj/item/weapon/reagent_containers/food/drinks/sillycup( src )
		new /obj/item/weapon/reagent_containers/food/drinks/sillycup( src )
		new /obj/item/weapon/reagent_containers/food/drinks/sillycup( src )
		new /obj/item/weapon/reagent_containers/food/drinks/sillycup( src )
		new /obj/item/weapon/reagent_containers/food/drinks/sillycup( src )
		new /obj/item/weapon/reagent_containers/food/drinks/sillycup( src )
		new /obj/item/weapon/reagent_containers/food/drinks/sillycup( src )

/obj/falsewall
	name = "wall"
	icon = 'walls.dmi'
	icon_state = ""
	density = 1
	opacity = 1
	anchored = 1

/obj/falserwall
	name = "r wall"
	icon = 'walls.dmi'
	icon_state = "r_wall"
	density = 1
	opacity = 1
	anchored = 1

/obj/item/stack
	var/singular_name
	var/amount = 1.0
	var/max_amount //also see stack recipes initialisation, param "max_res_amount" must be equal to this max_amount

/obj/item/stack/rods
	name = "metal rods"
	singular_name = "metal rod"
	icon_state = "rods"
	flags = FPRINT | TABLEPASS| CONDUCT
	w_class = 3.0
	force = 9.0
	throwforce = 15.0
	throw_speed = 5
	throw_range = 20
	m_amt = 1875
	max_amount = 60

/obj/item/stack/sheet
	name = "sheet"
//	var/const/length = 2.5 //2.5*1.5*0.01*100000 == 3750 == m_amt
//	var/const/width = 1.5
//	var/const/height = 0.01
	flags = FPRINT | TABLEPASS
	w_class = 3.0
	max_amount = 50
	var/perunit = 3750

/obj/item/stack/sheet/glass
	name = "glass"
	singular_name = "glass sheet"
	icon_state = "sheet-glass"
	force = 5.0
	g_amt = 3750
	throwforce = 5
	throw_speed = 3
	throw_range = 3

/obj/item/stack/sheet/rglass
	name = "reinforced glass"
	singular_name = "reinforced glass sheet"
	icon_state = "sheet-rglass"
	force = 6.0
	g_amt = 3750
	m_amt = 1875
	throwforce = 5
	throw_speed = 3
	throw_range = 3

/obj/item/stack/sheet/metal
	name = "metal"
	singular_name = "metal sheet"
	desc = "A heavy sheet of metal."
	icon_state = "sheet-metal"
	force = 5.0
	m_amt = 3750
	throwforce = 14.0
	throw_speed = 1
	throw_range = 4
	flags = FPRINT | TABLEPASS | CONDUCT

/obj/item/stack/sheet/r_metal
	name = "reinforced metal"
	singular_name = "reinforced metal sheet"
	desc = "A very heavy sheet of metal."
	icon_state = "sheet-r_metal"
	item_state = "sheet-metal"
	force = 5.0
	m_amt = 7500
	throwforce = 15.0
	throw_speed = 1
	throw_range = 4
	flags = FPRINT | TABLEPASS | CONDUCT

/obj/item/stack/tile
	name = "steel floor tile"
	singular_name = "steel floor tile"
	desc = "Those could work as a pretty decent throwing weapon"
	icon_state = "tile"
	w_class = 3.0
	force = 6.0
	m_amt = 937.5
	throwforce = 15.0
	throw_speed = 5
	throw_range = 20
	flags = FPRINT | TABLEPASS | CONDUCT
	max_amount = 20