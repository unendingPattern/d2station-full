/obj/machinery
	name = "machinery"
	icon = 'stationobjs.dmi'
	var
		stat = 0

		use_power = 0
		//0 = dont run the auto
		//1 = run auto, use idle
		//2 = run auto, use active
		idle_power_usage = 0
		active_power_usage = 0
		power_channel = EQUIP
		//EQUIP,ENVIRON or LIGHT
		list/component_parts = null //list of all the parts used to build it, if made from certain kinds of frames.
		uid
		manual = 0
		global
			gl_uid = 1


/obj/machinery/autolathe
	name = "Autolathe"
	icon_state = "autolathe"
	density = 1
	var/m_amount = 0.0
	var/g_amount = 0.0
	var/operating = 0.0
	var/opened = 0.0
	//var/temp = null
	anchored = 1.0
	var/list/L = list()
	var/list/LL = list()
	var/list/LLL = list()
	var/hacked = 0
	var/disabled = 0
	var/shocked = 0
	var/list/wires = list()
	var/hack_wire
	var/disable_wire
	var/shock_wire
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 100

/obj/machinery/camera
	name = "Security Camera"
	icon = 'monitors.dmi'
	icon_state = "camera"
	var/network = "SS13"
	layer = 5
	var/c_tag = null
	var/c_tag_order = 999
	var/status = 1.0
	anchored = 1.0
	var/invuln = null
	var/bugged = 0
	use_power = 2
	idle_power_usage = 5
	active_power_usage = 500
	var/state = "off"
	var/slave_holo = null

/obj/machinery/oven
	name = "oven"
	desc = ""
	icon = 'kitchen.dmi'
	icon_state = "ovenstove"
	flags =  FPRINT
	anchored = 1.0
	density = 1
	var/cooking = 0
	var/ingred1
	var/ingred2
	var/ingred3
	var/ingred4
	var/ingred1disp
	var/ingred2disp
	var/ingred3disp
	var/ingred4disp
	var/timedial = 0
	var/list/available_ovenrecipes = list() // List of the recipes you can use
	var/obj/being_cooked = null // The item being cooked
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 10

/obj/machinery/dispenser
	desc = "A simple yet bulky one-way storage device for gas tanks. Holds 10 plasma and 10 oxygen tanks."
	name = "Tank Storage Unit"
	icon = 'objects.dmi'
	icon_state = "dispenser"
	density = 1
	var/o2tanks = 10.0
	var/pltanks = 10.0
	anchored = 1.0
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 10

/obj/machinery/dna_scanner
	name = "DNA Scanner/Implanter"
	icon = 'Cryogenic2.dmi'
	icon_state = "scanner_0"
	density = 1
	var/locked = 0.0
	var/mob/occupant = null
	anchored = 1.0
	use_power = 1
	idle_power_usage = 50
	active_power_usage = 300

/obj/machinery/dna_scannernew
	name = "DNA Modifier"
	icon = 'Cryogenic2.dmi'
	icon_state = "scanner_0"
	density = 1
	var/locked = 0.0
	var/mob/occupant = null
	anchored = 1.0
	use_power = 1
	idle_power_usage = 50
	active_power_usage = 300

/obj/machinery/firealarm
	name = "Fire Alarm"
	icon = 'monitors.dmi'
	icon_state = "fire0"
	var/detecting = 1.0
	var/working = 1.0
	var/time = 10.0
	var/timing = 0.0
	var/lockdownbyai = 0
	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = ENVIRON

/obj/machinery/partyalarm
	name = "Party Button"
	icon = 'monitors.dmi'
	icon_state = "fire0"
	var/detecting = 1.0
	var/working = 1.0
	var/time = 10.0
	var/timing = 0.0
	var/lockdownbyai = 0
	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 6

/obj/machinery/hologram_proj
	name = "Hologram Projector"
	icon = 'stationobjs.dmi'
	icon_state = "hologram0"
	var/atom/projection = null
	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 5

/obj/machinery/hologram_ai
	name = "Hologram Projector Platform"
	icon = 'stationobjs.dmi'
	icon_state = "hologram0"
	var/atom/projection = null
	var/temp = null
	var/lumens = 0.0
	var/h_r = 245.0
	var/h_g = 245.0
	var/h_b = 245.0
	anchored = 1.0
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 10

/obj/machinery/igniter
	name = "igniter"
	icon = 'stationobjs.dmi'
	icon_state = "igniter1"
	var/id = null
	var/on = 1.0
	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4

/obj/machinery/injector
	name = "injector"
	icon = 'stationobjs.dmi'
	icon_state = "injector"
	density = 1
	anchored = 1.0
	flags = ON_BORDER
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4

/obj/machinery/mech_assemb
	name = "Assembly Unit"
	icon_state = "mech_assemb"
	anchored = 1.0
	use_power = 1
	idle_power_usage = 4
	active_power_usage = 50

/obj/machinery/mass_driver
	name = "mass driver"
	icon = 'stationobjs.dmi'
	icon_state = "mass_driver"
	var/power = 1.0
	var/code = 1.0
	var/id = 1.0
	anchored = 1.0
	var/drive_range = 50 //this is mostly irrelevant since current mass drivers throw into space, but you could make a lower-range mass driver for interstation transport or something I guess.
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 50

/obj/machinery/meter
	name = "meter"
	icon = 'meter.dmi'
	icon_state = "meterX"
	var/obj/machinery/atmospherics/pipe/target = null
	anchored = 1.0
	var/frequency = 0
	var/id
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4

/obj/machinery/nuclearbomb
	desc = "Uh oh."
	name = "Nuclear Fission Explosive"
	icon = 'stationobjs.dmi'
	icon_state = "nuclearbomb0"
	density = 1
	var/deployable = 0.0
	var/extended = 0.0
	var/timeleft = 60.0
	var/timing = 0.0
	var/r_code = "ADMIN"
	var/code = ""
	var/yes_code = 0.0
	var/safety = 1.0
	var/obj/item/weapon/disk/nuclear/auth = null
	flags = FPRINT
	use_power = 0

/obj/machinery/nuclearbombdisarmed
	desc = "The disk slot looks a bit burnt."
	name = "Nuclear Fission Explosive"
	icon = 'stationobjs.dmi'
	icon_state = "nuclearbomb0"
	density = 1
	var/deployable = 0.0
	var/extended = 0.0
	var/timeleft = -1.0
	var/timing = 0.0
	var/r_code = "LOLNO"
	var/code = ""
	var/yes_code = 0.0
	var/safety = 1.0
	flags = FPRINT
	use_power = 0

/obj/machinery/optable
	name = "Operating Table"
	icon = 'surgery.dmi'
	icon_state = "table2-idle"
	density = 1
	anchored = 1.0
	var/mob/living/carbon/human/victim = null
	var/strapped = 0.0
	var/obj/machinery/computer/operating/computer = null
	var/id = 0.0
	use_power = 1
	idle_power_usage = 1
	active_power_usage = 5

/obj/machinery/vehicle
	name = "Vehicle Pod"
	icon = 'escapepod.dmi'
	icon_state = "podfire"
	density = 1
	flags = FPRINT
	anchored = 1.0
	var/speed = 10.0
	var/maximum_speed = 10.0
	var/can_rotate = 1
	var/can_maximize_speed = 0
	var/one_person_only = 0
	use_power = 0

/obj/machinery/vehicle/pod
	name = "Escape Pod"
	icon = 'escapepod.dmi'
	icon_state = "pod"
	can_rotate = 0
	var/id = 1.0

/obj/machinery/vehicle/recon
	name = "Reconaissance Pod"
	icon = 'escapepod.dmi'
	icon_state = "recon"
	speed = 1.0
	maximum_speed = 30.0
	can_maximize_speed = 1
	one_person_only = 1

/obj/machinery/restruct
	name = "DNA Physical Restructurization Accelerator"
	icon = 'Cryogenic2.dmi'
	icon_state = "restruct_0"
	density = 1
	var/locked = 0.0
	var/mob/occupant = null
	anchored = 1.0
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 600

/obj/machinery/scan_console
	name = "DNA Scanner Access Console"
	icon = 'computer.dmi'
	icon_state = "scanner"
	density = 1
	var/obj/item/weapon/card/data/scan = null
	var/func = ""
	var/data = ""
	var/special = ""
	var/status = null
	var/prog_p1 = null
	var/prog_p2 = null
	var/prog_p3 = null
	var/prog_p4 = null
	var/temp = null
	var/obj/machinery/dna_scanner/connected = null
	anchored = 1.0
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 400

/obj/machinery/scan_consolenew
	name = "DNA Modifier Access Console"
	icon = 'computer.dmi'
	icon_state = "scanner"
	density = 1
	var/uniblock = 1.0
	var/strucblock = 1.0
	var/subblock = 1.0
	var/status = null
	var/radduration = 2.0
	var/radstrength = 1.0
	var/radacc = 1.0
	var/buffer1 = null
	var/buffer2 = null
	var/buffer3 = null
	var/buffer1owner = null
	var/buffer2owner = null
	var/buffer3owner = null
	var/buffer1label = null
	var/buffer2label = null
	var/buffer3label = null
	var/buffer1type = null
	var/buffer2type = null
	var/buffer3type = null
	var/buffer1iue = 0
	var/buffer2iue = 0
	var/buffer3iue = 0
	var/delete = 0
	var/injectorready = 1
	var/temphtml = null
	var/obj/machinery/dna_scanner/connected = null
	var/obj/item/weapon/disk/data/diskette = null
	anchored = 1.0
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 400

/obj/machinery/sec_lock
	name = "Security Pad"
	icon = 'stationobjs.dmi'
	icon_state = "sec_lock"
	var/obj/item/weapon/card/id/scan = null
	var/a_type = 0.0
	var/obj/machinery/door/d1 = null
	var/obj/machinery/door/d2 = null
	anchored = 1.0
	req_access = list(access_brig)
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4

/obj/machinery/door_control
	name = "Remote Door Control"
	icon = 'stationobjs.dmi'
	icon_state = "doorctrl0"
	desc = "A remote control switch for a door."
	var/id = null
	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4

/obj/machinery/door_control/Door_lock
	name = "Remote Door Control"
	icon = 'stationobjs.dmi'
	icon_state = "doorctrl0"
	desc = "A remote control switch for a door."
	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4


/obj/machinery/driver_button
	name = "Mass Driver Button"
	icon = 'objects.dmi'
	icon_state = "launcherbtt"
	desc = "A remote control switch for a Mass Driver."
	var/id = null
	var/active = 0
	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4

/obj/machinery/ignition_switch
	name = "Ignition Switch"
	icon = 'objects.dmi'
	icon_state = "launcherbtt"
	desc = "A remote control switch for a mounted igniter."
	var/id = null
	var/active = 0
	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4

/obj/machinery/shuttle
	name = "shuttle"
	icon = 'shuttle.dmi'
	use_power = 0

/obj/machinery/shuttle/engine
	name = "engine"
	density = 1
	anchored = 1.0

/obj/machinery/shuttle/engine/heater
	name = "heater"
	icon_state = "heater"

/obj/machinery/shuttle/engine/platform
	name = "platform"
	icon_state = "platform"

/obj/machinery/shuttle/engine/propulsion
	name = "propulsion"
	icon_state = "propulsion"
	opacity = 1

/obj/machinery/shuttle/engine/propulsion/burst
	name = "burst"

/obj/machinery/shuttle/engine/propulsion/burst/left
	name = "left"
	icon_state = "burst_l"

/obj/machinery/shuttle/engine/propulsion/burst/right
	name = "right"
	icon_state = "burst_r"

/obj/machinery/shuttle/engine/router
	name = "router"
	icon_state = "router"

/obj/machinery/teleport
	name = "teleport"
	icon = 'stationobjs.dmi'
	density = 1
	anchored = 1.0
	var/lockeddown = 0

/obj/machinery/teleport/hub
	name = "hub"
	icon_state = "tele0"
	var/accurate = 0
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 2000

/obj/machinery/teleport/station
	name = "station"
	icon_state = "controller"
	var/active = 0
	var/engaged = 0
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 2000

/obj/machinery/wire
	name = "wire"
	icon = 'power_cond.dmi'
	use_power = 1
	idle_power_usage = 0
	active_power_usage = 1

/obj/machinery/power
	name = null
	icon = 'power.dmi'
	anchored = 1.0
	var/datum/powernet/powernet = null
	var/netnum = 0
	var/directwired = 1		// by default, power machines are connected by a cable in a neighbouring turf
							// if set to 0, requires a 0-X cable on this turf
	use_power = 0
	idle_power_usage = 0
	active_power_usage = 0

/obj/machinery/power/terminal
	name = "terminal"
	icon_state = "term"
	desc = "An underfloor wiring terminal for power equipment"
	level = 1
	var/obj/machinery/power/master = null
	anchored = 1
	directwired = 0		// must have a cable on same turf connecting to terminal

/obj/machinery/power/generator
	name = "generator"
	desc = "A high efficiency thermoelectric generator."
	icon_state = "teg"
	anchored = 1
	density = 1

	var/obj/machinery/atmospherics/binary/circulator/circ1
	var/obj/machinery/atmospherics/binary/circulator/circ2

	var/lastgen = 0
	var/lastgenlev = -1

/obj/machinery/power/generator_type2
	name = "generator"
	desc = "A high efficiency thermoelectric generator."
	icon_state = "teg"
	anchored = 1
	density = 1

	var/obj/machinery/atmospherics/unary/generator_input/input1
	var/obj/machinery/atmospherics/unary/generator_input/input2

	var/lastgen = 0
	var/lastgenlev = -1

/obj/machinery/power/monitor
	name = "Power Monitoring Computer"
	icon = 'computer.dmi'
	icon_state = "power"
	density = 1
	anchored = 1
	use_power = 2
	idle_power_usage = 20
	active_power_usage = 80

/obj/machinery/power/solar
	name = "solar panel"
	desc = "A solar electrical generator."
	icon = 'power.dmi'
	icon_state = "sp_base"
	anchored = 1
	density = 1
	directwired = 1
	var/health = 10.0
	var/id = 1
	var/obscured = 0
	var/sunfrac = 0
	var/adir = SOUTH
	var/ndir = SOUTH
	var/turn_angle = 0
	var/obj/machinery/power/solar_control/control
	use_power = 0
	idle_power_usage = 0
	active_power_usage = 0

/obj/machinery/power/solar_control
	name = "solar panel control"
	desc = "A controller for solar panel arrays."
	icon = 'computer.dmi'
	icon_state = "solar"
	anchored = 1
	density = 1
	directwired = 1
	var/id = 1
	var/cdir = 0
	var/gen = 0
	var/lastgen = 0
	var/track = 2			// 0= off  1=timed  2=auto (tracker)
	var/trackrate = 600		// 300-900 seconds
	var/trackdir = 1		// 0 =CCW, 1=CW
	var/nexttime = 0
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 20

/obj/machinery/cell_charger
	name = "cell charger"
	desc = "A charging unit for power cells."
	icon = 'power.dmi'
	icon_state = "ccharger0"
	var/obj/item/weapon/cell/charging = null
	var/chargelevel = -1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 60

/obj/machinery/light_switch
	desc = "A light switch"
	name = null
	icon = 'power.dmi'
	icon_state = "light1"
	anchored = 1.0
	var/on = 1
	var/area/area = null
	var/otherarea = null
	//	luminosity = 1

/obj/machinery/crema_switch
	desc = "Burn baby burn!"
	name = "crematorium igniter"
	icon = 'power.dmi'
	icon_state = "crema_switch"
	anchored = 1.0
	req_access = list(access_crematorium)
	var/on = 0
	var/area/area = null
	var/otherarea = null
	var/id = 1

/obj/machinery/shapedcharge
	name = "shaped charge"
	icon = 'stationobjs.dmi'
	icon_state = "c4"
	anchored = 1.0

/obj/machinery/shapedcharge/attack_hand(mob/user as mob)
	for (var/mob/C in viewers(src))
		C.show_message("\blue [src] emits a soft beeping noise.", 3)
	flick("c4_armed",src)
	spawn(20)
		del(src)
		return

/obj/machinery/shapedcharge/Del()
	for(var/obj/mountainwall/T in world)
		del(T)
	..()

/obj/machinery/microwave
	name = "Microwave"
	icon = 'kitchen.dmi'
	icon_state = "mw"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 100
	var/egg_amount = 0 //Current number of eggs inside
	var/flour_amount = 0 //Current amount of flour inside
	var/water_amount = 0 //Current amount of water inside
	var/monkeymeat_amount = 0
	var/cheese_amount = 0
	var/humanmeat_amount = 0
	var/donkpocket_amount = 0
	var/xenomeat_amount = 0
	var/milk_amount = 0
	var/hotsauce_amount = 0
	var/coldsauce_amount = 0
	var/soysauce_amount = 0
	var/ketchup_amount = 0
	var/tofu_amount = 0
	var/berryjuice_amount = 0
	var/carpmeat_amount = 0
	var/humanmeat_name = ""
	var/humanmeat_job = ""
	var/operating = 0 // Is it on?
	var/dirty = 0 // Does it need cleaning?
	var/broken = 0 // How broken is it???
	var/list/available_recipes = list() // List of the recipes you can use
	var/obj/item/weapon/reagent_containers/food/snacks/being_cooked = null // The item being cooked
	var/obj/item/extra_item = null// One non food item that can be added
	flags = OPENCONTAINER									//Temporary holder while it counts what's in it.
	New()													//	Stuff can be added but not removed without destroying it.
		var/datum/reagents/R = new/datum/reagents(100)
		reagents = R
		R.my_atom = src

/obj/machinery/processor
	name = "Food Processor"
	icon = 'kitchen.dmi'
	icon_state = "processor"
	density = 1
	anchored = 1
	var/broken = 0
	var/processing = 0
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 50

/obj/machinery/gibber
	name = "Gibber"
	desc = "The name isn't descriptive enough?"
	icon = 'kitchen.dmi'
	icon_state = "grinder"
	density = 1
	anchored = 1
	var/operating = 0 //Is it on?
	var/dirty = 0 // Does it need cleaning?
	var/gibtime = 40 // Time from starting until meat appears
	var/mob/occupant // Mob who has been put inside
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 50

/obj/machinery/holopad
	name = "holopad"
	desc = "A floor-mounted device for projecting AI holograms, uses extreme amounts of energy."
	icon_state = "holopad0"
	anchored = 1
	var/state = "off"
	var/slave_holo = null
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 100000