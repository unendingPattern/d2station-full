/obj/machinery/computer
	name = "computer"
	icon = 'computer.dmi'
	density = 1
	anchored = 1.0
	var/ScreenColorRed = 1
	var/ScreenColorGreen = 1
	var/ScreenColorBlue = 1

/*
/obj/machinery/computer/airtunnel
	name = "Air Tunnel Control"
	icon = 'airtunnelcomputer.dmi'
	icon_state = "console00"
*/

/obj/machinery/computer/operating
	name = "Operating Computer"
	density = 1
	anchored = 1.0
	icon = 'computer.dmi'
	icon_state = "comm"

	var/mob/living/carbon/human/victim = null

	var/obj/machinery/optable/table = null
	var/id = 0.0

/*
 *	Arcade -- An arcade cabinet.
 */

/obj/machinery/computer/arcade
	name = "arcade machine"
	desc = "Does not support Pinball."
	icon = 'computer.dmi'
	icon_state = "arcade"
	var/enemy_name = "Space Villian"
	var/temp = "Winners Don't Use Spacedrugs" //Temporary message, for attack messages, etc
	var/player_hp = 30 //Player health/attack points
	var/player_mp = 10
	var/enemy_hp = 45 //Enemy health/attack points
	var/enemy_mp = 20
	var/gameover = 0
	var/blocked = 0 //Player cannot attack/heal while set
	ScreenColorRed = 0
	ScreenColorGreen = 0.3
	ScreenColorBlue = 0

/obj/machinery/computer/arcadepuzzle
	name = "arcade machine"
	desc = "Does not support Pinball."
	icon = 'computer.dmi'
	icon_state = "arcade"
	var/enemy_name = "Space Villian"
	var/temp = "Winners Don't Use Spacedrugs" //Temporary message, for attack messages, etc
	var/player_hp = 30 //Player health/attack points
	var/player_mp = 10
	var/enemy_hp = 45 //Enemy health/attack points
	var/enemy_mp = 20
	var/gameover = 0
	var/blocked = 0 //Player cannot attack/heal while set

/obj/machinery/computer/aiupload
	name = "AI Upload"
	desc = "It is said that you can upload silly laws to AI's with this."
	icon_state = "command"
	var/mob/living/silicon/ai/current = null
	var/opened = 0
	ScreenColorRed = 0
	ScreenColorGreen = 0.3
	ScreenColorBlue = 0

/obj/machinery/computer/borgupload
	name = "Cyborg Upload"
	desc = "Used for uploading responsible laws to a Cyborg. Right..."
	icon_state = "command"
	var/mob/living/silicon/robot/current = null

/obj/machinery/computer/atmosphere
	name = "atmos"
	desc = "A computer for Atmospherics."

/obj/machinery/computer/station_alert
	name = "Station Alert Computer"
	desc = "Alert. Alert. ALERT!!!"
	icon_state = "alert:0"
	var/alarms = list("Fire"=list(), "Atmosphere"=list(), "Power"=list())

/obj/machinery/computer/atmos_alert
	name = "Atmospheric Alert Computer"
	desc = "Used to detect where they messed up this time."
	icon_state = "alert:0"
	var/list/priority_alarms = list()
	var/list/minor_alarms = list()
	var/oldalerts
	var/receive_frequency = 1437
	var/alertonce
/obj/machinery/computer/atmosphere/siphonswitch
	name = "Area Air Control"
	desc = "Nanotrasen provided this, barely."
	icon_state = "atmos"
	var/otherarea
	var/area/area

/obj/machinery/computer/atmosphere/siphonswitch/mastersiphonswitch
	name = "Master Air Control"

/obj/machinery/computer/card
	name = "Identification Computer"
	desc = "You can use this to change ID's. YOU ARE GOD!"
	icon_state = "id"
	var/obj/item/weapon/card/id/scan = null
	var/obj/item/weapon/card/id/modify = null
	var/authenticated = 0.0
	var/mode = 0.0
	var/printing = null
	req_access = list(access_change_ids)
	ScreenColorRed = 0
	ScreenColorGreen = 0
	ScreenColorBlue = 0.3
/*
/obj/machinery/computer/PDACart
	name = "PDA Cartridge Creation Computer"
	desc = "You can use this to create new PDA cartridges"
	icon_state = "PDA"
	var/printing = null
*/
//ID changing computer for CentCom.
/obj/machinery/computer/card/centcom
	name = "CentCom Identification Computer"
	desc = "You are the Gods's God."
	req_access = list(access_cent_captain)

/obj/machinery/computer/communications
	name = "Communications Console"
	desc = "This can be used for various important functions. What kind? Nobody knows."
	icon_state = "comm"
	req_access = list(access_heads)
	var/prints_intercept = 1
	var/authenticated = 0
	var/list/messagetitle = list()
	var/list/messagetext = list()
	var/currmsg = 0
	var/aicurrmsg = 0
	var/state = STATE_DEFAULT
	var/aistate = STATE_DEFAULT
	var/const
		STATE_DEFAULT = 1
		STATE_CALLSHUTTLE = 2
		STATE_CANCELSHUTTLE = 3
		STATE_MESSAGELIST = 4
		STATE_VIEWMESSAGE = 5
		STATE_DELMESSAGE = 6
		STATE_STATUSDISPLAY = 7

	var/status_display_freq = "1435"
	var/stat_msg1
	var/stat_msg2
	ScreenColorRed = 0
	ScreenColorGreen = 0.3
	ScreenColorBlue = 0

/obj/machinery/radiotransmitter
	name = "Radio Transmitter"
	icon = 'computer.dmi'
	icon_state = "radiotransm"
	var/transmitteron = 1
	var/messagedisplayed = 0

/obj/machinery/computer/data
	name = "data"
	icon_state = "aiupload"

	var/list/topics = list(  )

/obj/machinery/computer/data/weapon
	name = "weapon"

/obj/machinery/computer/data/weapon/info
	name = "Research Computer"

/obj/machinery/computer/data/weapon/log
	name = "Log Computer"

/obj/machinery/computer/dna
	name = "DNA operations computer"
	desc = "A Computer used to advanced DNA stuff."
	icon_state = "dna"
	var/obj/item/weapon/card/data/scan = null
	var/obj/item/weapon/card/data/modify = null
	var/obj/item/weapon/card/data/modify2 = null
	var/mode = null
	var/temp = null
	ScreenColorRed = 0
	ScreenColorGreen = 0.3
	ScreenColorBlue = 0

/obj/machinery/computer/hologram_comp
	name = "Hologram Computer"
	desc = "Rumoured to control holograms."
	icon = 'stationobjs.dmi'
	icon_state = "holo_console0"
	var/obj/machinery/hologram/projector/projector = null
	var/temp = null
	var/lumens = 0.0
	var/h_r = 245.0
	var/h_g = 245.0
	var/h_b = 245.0

/obj/machinery/computer/med_data
	name = "Medical Records"
	desc = "This can be used to check medical records."
	icon_state = "computer_med_data2"
	req_access = list(access_medical)
	var/obj/item/weapon/card/id/scan = null
	var/authenticated = null
	var/rank = null
	var/screen = null
	var/datum/data/record/active1 = null
	var/datum/data/record/active2 = null
	var/a_id = null
	var/temp = null
	var/printing = null
	ScreenColorRed = 0
	ScreenColorGreen = 0.3
	ScreenColorBlue = 0

/obj/machinery/computer/med_data/laptop
	name = "Medical Laptop"
	desc = "Cheap Nanotrasen Laptop."
	icon_state = "medlaptop"

/obj/machinery/computer/pod
	name = "Pod Launch Control"
	desc = "A control for launching pods. Some people prefer firing Mechas."
	icon_state = "computer_generic"
	var/id = 1.0
	var/obj/machinery/mass_driver/connected = null
	var/timing = 0.0
	var/time = 30.0

/obj/machinery/computer/pod/old
	icon_state = "old"
	name = "DoorMex Control Computer"

/obj/machinery/computer/pod/old/syndicate
	name = "ProComp Executive IIc"
	desc = "The Syndicate operate on a tight budget. Operates external airlocks."

/obj/machinery/computer/pod/old/swf
	name = "Magix System IV"
	desc = "An arcane artifact that holds much magic. Running E-Knock 2.2: Sorceror's Edition"

/obj/machinery/computer/secure_data
	name = "Security Records"
	desc = "Beepsky. ARREST!!!"
	icon_state = "security"
	req_access = list(access_security)
	var/obj/item/weapon/card/id/scan = null
	var/authenticated = null
	var/rank = null
	var/screen = null
	var/datum/data/record/active1 = null
	var/datum/data/record/active2 = null
	var/a_id = null
	var/temp = null
	var/printing = null
	var/can_change_id = 0
	ScreenColorRed = 0.3
	ScreenColorGreen = 0
	ScreenColorBlue = 0

/obj/machinery/computer/secure_data/detective_computer
	icon = 'computer.dmi'
	icon_state = "messyfiles"

/obj/machinery/computer/security
	name = "Security Cameras"
	desc = "Better than Television."
	icon_state = "cameras"
	var/obj/machinery/camera/current = null
	var/last_pic = 1.0
	var/network = "SS13"
	var/maplevel = 1

/obj/machinery/computer/security/telescreen
	name = "Telescreen"
	desc = "Used for watching an empty arena."
	icon = 'stationobjs.dmi'
	icon_state = "telescreen"
	network = "thunder"
	density = 0

/obj/machinery/computer/security/wooden_tv
	name = "Security Cameras"
	desc = "Nanotrasen gave the detective this for Noir feeling."
	icon_state = "security_det"

/obj/machinery/computer/security/mining
	name = "Outpost Status Display"
	desc = "It's better than reality TV."
	icon_state = "miningcameras"
	network = "MINE"

/obj/machinery/computer/shuttle
	name = "Shuttle"
	desc = "For shuttle control."
	icon_state = "shuttle"
	var/auth_need = 3.0
	var/list/authorized = list(  )

/obj/machinery/computer/teleporter
	name = "Teleporter"
	desc = "Use this to set your destination...hopefully."
	icon_state = "teleport"
	var/obj/item/locked = null
	var/id = null

/obj/machinery/computer/teleporter/security
	name = "Teleporter"
	desc = "Use this to set your destination...hopefully."
	icon_state = "teleport"
	locked = null
	id = null