/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME 	(you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = "ICON FILENAME" 			(defaults to areas.dmi)
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = 0 				(defaults to 1)
	music = "music/music.ogg"		(defaults to "music/music.ogg")

NOTE: there are two lists of areas in the end of this file: centcom and station itself. Please maintain these lists valid. --rastaf0
buttes
*/


/area
	var/fire = null
	var/atmos = 1
	var/atmosalm = 0
	var/poweralm = 1
	var/party = null
	var/air_doors_activated = 0
	var/air_door_close_delay = 0
	level = null
	name = "\proper space"
	icon = 'areas.dmi'
	icon_state = "unknown"
	layer = 10
	mouse_opacity = 0
	var/lightswitch = 1
	var/smell = 0
	var/redalert = 0
	var/applyalertstatus = 1

	var/eject = null

	var/requires_power = 1
	var/power_equip = 1
	var/power_light = 1
	var/power_environ = 1
	var/music = null
	var/used_equip = 0
	var/used_light = 0
	var/used_environ = 0


	var/no_air = null
	var/area/master				// master area used for power calcluations
								// (original area before splitting due to sd_DAL)
	var/list/related			// the other areas of the same type as this
	var/list/lights				// list of all lights on this area

	var/list/alldoors         // Doors which are not in the area, but should still be closed in case of emergency.
	var/auxdoors = list()		//Added by Strumpetplaya - Alarm Change - Contains a list of doors adjacent to this area

	New()
		..()
		areaz -= src
		areaz += src

/*Adding a wizard area teleport list because motherfucking lag -- Urist*/
/*I am far too lazy to make it a proper list of areas so I'll just make it run the usual telepot routine at the start of the game*/
var/list/teleportlocs = list()

proc/process_teleport_locs()
	for(var/area/AR in world)
		if(istype(AR, /area/shuttle) || istype(AR, /area/syndicate_station) || istype(AR, /area/wizard_station)) continue
		if(teleportlocs.Find(AR.name)) continue
		var/turf/picked = pick(get_area_turfs(AR.type))
		if (picked.z == 1)
			teleportlocs += AR.name
			teleportlocs[AR.name] = AR

	var/not_in_order = 0
	do
		not_in_order = 0
		if(teleportlocs.len <= 1)
			break
		for(var/i = 1, i <= (teleportlocs.len - 1), i++)
			if(sorttext(teleportlocs[i], teleportlocs[i+1]) == -1)
				teleportlocs.Swap(i, i+1)
				not_in_order = 1
	while(not_in_order)

var/list/ghostteleportlocs = list()

proc/process_ghost_teleport_locs()
	for(var/area/AR in world)
		if(ghostteleportlocs.Find(AR.name)) continue
		if(istype(AR, /area/))
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR
		var/turf/picked = pick(get_area_turfs(AR.type))
		if (picked.z == 1 || picked.z == 5)
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR

	var/not_in_order = 0
	do
		not_in_order = 0
		if(ghostteleportlocs.len <= 1)
			break
		for(var/i = 1, i <= (ghostteleportlocs.len - 1), i++)
			if(sorttext(ghostteleportlocs[i], ghostteleportlocs[i+1]) == -1)
				ghostteleportlocs.Swap(i, i+1)
				not_in_order = 1
	while(not_in_order)


/*-----------------------------------------------------------------------------*/

/area/engine/

/area/turret_protected/

/area/arrival
	requires_power = 0

/area/arrival/start
	name = "Arrival Area"
	icon_state = "start"

/area/admin
	name = "Admin room"
	icon_state = "start"

/area/shieldgen
	name = "Shield Generation"
	icon_state = "shield"
	music = 'hiss.ogg'

//These are shuttle areas, they must contain two areas in a subgroup if you want to move a shuttle from one
//place to another. Look at escape shuttle for example.
//All shuttles show now be under shuttle since we have smooth-wall code.

/area/shuttle //DO NOT TURN THE SD_LIGHTING STUFF ON FOR SHUTTLES. IT BREAKS THINGS.
	requires_power = 0
	luminosity = 1
//	sd_lighting = 0
	ul_Lighting = 0

/area/spawn
	requires_power = 0
	luminosity = 1
//	sd_lighting = 0
	ul_Lighting = 0
	icon_state = "shuttle2"


/area/shuttle/arrival
	name = "Arrival Shuttle"

/area/shuttle/arrival/pre_game
	icon_state = "shuttle2"

/area/shuttle/arrival/station
	icon_state = "shuttle"

/area/shuttle/escape
	name = "Emergency Shuttle"
	music = "music/escape.ogg"

/area/shuttle/escape/station
	icon_state = "shuttle2"

/area/shuttle/escape/centcom
	icon_state = "shuttle"

/area/shuttle/mining
	name = "Mining Shuttle"
	music = "music/escape.ogg"

/area/shuttle/mining/station
	icon_state = "shuttle2"

/area/shuttle/mining/outpost
	icon_state = "shuttle"

/area/shuttle/transport1/centcom
	icon_state = "shuttle"
	name = "Transport Shuttle Centcom"

/area/shuttle/transport1/station
	icon_state = "shuttle"
	name = "Transport Shuttle"

/area/shuttle/transport2/centcom
	icon_state = "shuttle"

/area/shuttle/prison/
	name = "Prison Shuttle"

/area/shuttle/prison/station
	icon_state = "shuttle"

/area/shuttle/prison/prison
	icon_state = "shuttle2"

/area/shuttle/prison/transit
	icon_state = "shuttle2"

/area/shuttle/derelict
	icon_state = "shuttle6"

/area/shuttle/derelict/station
	icon_state = "shuttle6"

/area/shuttle/derelict/derelict
	icon_state = "shuttle6"

/area/shuttle/derelict/transit
	icon_state = "shuttle6"

/area/shuttle/specops/centcom
	name = "Special Ops Shuttle"
	icon_state = "shuttlered"

/area/shuttle/specops/station
	name = "Special Ops Shuttle"
	icon_state = "shuttlered2"

/area/shuttle/administration/centcom
	name = "Administration Shuttle Centcom"
	icon_state = "shuttlered"

/area/shuttle/administration/station
	name = "Administration Shuttle"
	icon_state = "shuttlered2"

/area/shuttle/thunderdome
	name = "honk"

/area/shuttle/thunderdome/grnshuttle
	name = "Thunderdome GRN Shuttle"
	icon_state = "green"

/area/shuttle/thunderdome/grnshuttle/dome
	name = "GRN Shuttle"
	icon_state = "shuttlegrn"

/area/shuttle/thunderdome/grnshuttle/station
	name = "GRN Station"
	icon_state = "shuttlegrn2"

/area/shuttle/thunderdome/redshuttle
	name = "Thunderdome RED Shuttle"
	icon_state = "red"

/area/shuttle/thunderdome/redshuttle/dome
	name = "RED Shuttle"
	icon_state = "shuttlered"

/area/shuttle/thunderdome/redshuttle/station
	name = "RED Station"
	icon_state = "shuttlered2"

/area/shuttle/rdsat/station
	icon_state = "shuttle5"

/area/shuttle/rdsat/transit
	icon_state = "shuttle5"

/area/shuttle/rdsat/satellite
	icon_state = "shuttle5"

/area/shuttle/mining
	name = "Mining Shuttle"
	icon_state = "miningshuttlestat"

/area/shuttle/mining/asteroid
	name = "Mining Shuttle"
	icon_state = "miningshuttlestat"

/area/shuttle/mining/station
	name = "Mining Shuttle"
	icon_state = "miningshuttledock"

/area/shuttle/mining/transit
	name = "Mining Shuttle"
	icon_state = "miningshuttlestat"

/area/shuttle/nori/
	name = "Nori's Shuttle"

/area/shuttle/nori/norishuttle
	icon_state = "shuttle5"

// === Trying to remove these areas:

/area/airtunnel1/      // referenced in airtunnel.dm:759

/area/dummy/           // Referenced in engine.dm:261

/area/start            // will be unused once kurper gets his login interface patch done
	name = "start area"
	icon_state = "start"

// === end remove

/area/puzzlechamber
	name = "Puzzle Area"
	icon_state = "puzzle"

// CENTCOM

/area/centcom
	name = "Centcom"
	icon_state = "centcom"
	requires_power = 0

/area/centcom/clown
	name = "Clownstation"

/area/centcom/control
	name = "Centcom Control"

/area/centcom/evac
	name = "Centcom Emergency Shuttle"

/area/centcom/suppy
	name = "Centcom Supply Shuttle"

/area/centcom/ferry
	name = "Centcom Transport Shuttle"

/area/centcom/shuttle
	name = "Centcom Administration Shuttle"

/area/centcom/test
	name = "Centcom Testing Facility"

/area/centcom/living
	name = "Centcom Living Quarters"

/area/centcom/specops
	name = "Centcom Special Ops"

/area/centcom/creed
	name = "Creed's Office"

/area/centcom/holding
	name = "Holding Facility"

//EXTRA

/area/asteroid					// -- TLE
	name = "Asteroid"
	icon_state = "asteroid"
	requires_power = 0

/area/asteroid/cave				// -- TLE
	name = "Asteroid - Underground"
	icon_state = "cave"
	requires_power = 0

/area/planet/clown
	name = "Clown Planet"
	icon_state = "honk"
	requires_power = 0

/area/tdome
	name = "Thunderdome"
	icon_state = "thunder"
	requires_power = 0

/area/tdome/tdome1
	name = "Thunderdome (Team 1)"
	icon_state = "green"

/area/tdome/tdome2
	name = "Thunderdome (Team 2)"
	icon_state = "yellow"

/area/tdome/tdomeadmin
	name = "Thunderdome (Admin.)"
	icon_state = "purple"

/area/tdome/tdomeobserve
	name = "Thunderdome (Observer.)"
	icon_state = "purple"

//ENEMY

/area/syndicate_station
	name = "Syndicate Station"
	icon_state = "yellow"
	requires_power = 0
	luminosity = 1
	ul_Lighting = 0

/area/syndicate_station/start
	name = "Syndicate Station Start"
	icon_state = "yellow"

/area/syndicate_station/one
	name = "Syndicate Station Location 1"
	icon_state = "green"

/area/syndicate_station/two
	name = "Syndicate Station Location 2"
	icon_state = "green"

/area/syndicate_station/three
	name = "Syndicate Station Location 3"
	icon_state = "green"

/area/syndicate_station/four
	name = "Syndicate Station Location 4"
	icon_state = "green"

/area/wizard_station
	name = "Wizard's Den"
	icon_state = "yellow"
	requires_power = 0

//PRISON

/area/prison/arrival_airlock
	name = "Prison Station Airlock"
	icon_state = "green"
	requires_power = 0

/area/prison/control
	name = "Prison Security Checkpoint"
	icon_state = "security"

/area/prison/crew_quarters
	name = "Prison Security Quarters"
	icon_state = "security"

/area/prison/rec_room
	name = "Prison Rec Room"
	icon_state = "green"

/area/prison/closet
	name = "Prison Supply Closet"
	icon_state = "dk_yellow"

/area/prison/hallway/fore
	name = "Prison Fore Hallway"
	icon_state = "yellow"

/area/prison/hallway/aft
	name = "Prison Aft Hallway"
	icon_state = "yellow"

/area/prison/hallway/port
	name = "Prison Port Hallway"
	icon_state = "yellow"

/area/prison/hallway/starboard
	name = "Prison Starboard Hallway"
	icon_state = "yellow"

/area/prison/morgue
	name = "Prison Morgue"
	icon_state = "morgue"

/area/prison/medical_research
	name = "Prison Genetic Research"
	icon_state = "medresearch"

/area/prison/medical
	name = "Prison Medbay"
	icon_state = "medbay"

/area/prison/solar
	name = "Prison Solar Array"
	icon_state = "storage"
	requires_power = 0

/area/prison/podbay
	name = "Prison Podbay"
	icon_state = "dk_yellow"

/area/prison/solar_control
	name = "Prison Solar Array Control"
	icon_state = "dk_yellow"

/area/prison/solitary
	name = "Solitary Confinement"
	icon_state = "brig"

/area/prison/cell_block/A
	name = "Prison Cell Block A"
	icon_state = "brig"

/area/prison/cell_block/B
	name = "Prison Cell Block B"
	icon_state = "brig"

/area/prison/cell_block/C
	name = "Prison Cell Block C"
	icon_state = "brig"

/area/prison/cell_block/D
	name = "Prison Cell Block D"
	icon_state = "brig"
//STATION13

/area/commsat
	name = "Communications Satellite"
	icon_state = "commsat"
	requires_power = 1

/area/commsat/solar
	name = "Communications Sattelite"
	icon_state = "yellow"
	requires_power = 0

/area/atmos
 	name = "Atmospherics"
 	icon_state = "atmos"

/area/store
	name = "General Store"
	icon_state = "store"

/area/store/gasstation
	name = "Gas Station"
	icon_state = "store"

/area/store/repairs
	name = "Repair Shop"
	icon_state = "store"

//Maintenance

/area/maintenance/fpmaint
	name = "Fore Port Maintenance"
	icon_state = "fpmaint"

/area/maintenance/fpmaint2
	name = "Secondary Fore Port Maintenance"
	icon_state = "fpmaint"

/area/maintenance/fsmaint
	name = "Fore Starboard Maintenance"
	icon_state = "fsmaint"

/area/maintenance/asmaint
	name = "Aft Starboard Maintenance"
	icon_state = "asmaint"

/area/maintenance/asmaint2
	name = "Secondary Aft Starboard Maintenance"
	icon_state = "asmaint"

/area/maintenance/apmaint
	name = "Aft Port Maintenance"
	icon_state = "apmaint"

/area/maintenance/maintcentral
	name = "Central Maintenance"
	icon_state = "maintcentral"

/area/maintenance/fore
	name = "Fore Maintenance"
	icon_state = "fmaint"

/area/maintenance/starboard
	name = "Starboard Maintenance"
	icon_state = "smaint"

/area/maintenance/port
	name = "Port Maintenance"
	icon_state = "pmaint"

/area/maintenance/aft
	name = "Aft Maintenance"
	icon_state = "amaint"

/area/maintenance/storage
	name = "Atmospherics"
	icon_state = "green"

/area/maintenance/incinerator
	name = "Incinerator"
	icon_state = "disposal"

/area/maintenance/disposal
	name = "Waste Disposal"
	icon_state = "disposal"

//Hallway

/area/hallway/fore1
	name = "Fore Primary Hallway part 1"
	icon_state = "A1"

/area/hallway/fore2
	name = "Fore Primary Hallway part 2"
	icon_state = "A2"

/area/hallway/fore3
	name = "Fore Primary Hallway part 3"
	icon_state = "A3"

/area/hallway/fore4
	name = "Fore Primary Hallway part 4"
	icon_state = "A4"

/area/hallway/fore5
	name = "Fore Primary Hallway part 5"
	icon_state = "B1"

/area/hallway/fore6
	name = "Fore Primary Hallway part 6"
	icon_state = "B2"

/area/hallway/cent1
	name = "Central Primary Hallway part 1"
	icon_state = "B3"

/area/hallway/cent4
	name = "Central Primary Hallway part 2"
	icon_state = "B4"

/area/hallway/starboard
	name = "Starboard Primary Hallway"
	icon_state = "hallS"

/area/hallway/aft
	name = "Aft Primary Hallway"
	icon_state = "hallA"

/area/hallway/RD
	name = "R&D Primary Hallway"
	icon_state = "hallA"

/area/hallway/port
	name = "Port Primary Hallway"
	icon_state = "hallP"

/area/hallway/central
	name = "Central Primary Hallway"
	icon_state = "hallC"

/area/hallway/exit
	name = "Escape Shuttle Hallway"
	icon_state = "escape"

/area/hallway/construction
	name = "Construction Area"
	icon_state = "construction"

/area/hallway/bridgeentry
	name = "Bridge Entry"
	icon_state = "construction"

/area/hallway/entry
	name = "Arrival Shuttle Hallway"
	icon_state = "entry"

/area/hallway/docking
	name = "Shuttle Docking Area"
	icon_state = "docking"

/area/hallway/entryagora
	name = "Shuttle Agora"
	icon_state = "entry"

/area/hallway/entrycheckpoint
	name = "Arrival Shuttle Checkpoint"
	icon_state = "entrycheckpoint"

//Command

/area/bridge
	name = "Bridge"
	icon_state = "bridge"
	music = "signal"

/area/crew_quarters/captain
	name = "Captain's Quarters"
	icon_state = "captain"

/area/crew_quarters/courtroom
	name = "Courtroom"
	icon_state = "courtroom"

/area/crew_quarters/heads
	name = "Head of Personnel's Quarters"
	icon_state = "head_quarters"

/area/crew_quarters/hor
	name = "Research Director's Office"
	icon_state = "head_quarters"

/area/crew_quarters/chief
	name = "Chief Engineer's Office"
	icon_state = "head_quarters"

/area/mint
	name = "Mint"
	icon_state = "green"

//Crew

/area/crew_quarters
	name = "Dormitory"
	icon_state = "Sleep"

/area/crew_quarters/toilet
	name = "Dormitory Toilets"
	icon_state = "toilet"

/area/crew_quarters/sleep_male
	name = "Male Dorm"
	icon_state = "Sleep"

/area/crew_quarters/sleep_male/toilet_male
	name = "Male Toilets"
	icon_state = "toilet"

/area/crew_quarters/sleep_female
	name = "Female Dorm"
	icon_state = "Sleep"

/area/crew_quarters/sleep_female/toilet_female
	name = "Female Toilets"
	icon_state = "toilet"

/area/crew_quarters/locker
	name = "Locker Room"
	icon_state = "locker"

/area/crew_quarters/locker/locker_toilet
	name = "Locker Toilets"
	icon_state = "toilet"

/area/crew_quarters/fitness
	name = "Fitness Room"
	icon_state = "fitness"

/area/crew_quarters/miners
	name = "Miner's Quarters"
	icon_state = "miners"

/area/crew_quarters/cafeteria
	name = "Cafeteria"
	icon_state = "cafeteria"

/area/crew_quarters/mess_hall
	name = "Mess Hall"
	icon_state = "cafeteria"

/area/crew_quarters/kitchen
	name = "Kitchen"
	icon_state = "kitchen"

/area/crew_quarters/houses/house1
	name = "House #1"
	icon_state = "courtroom"

/area/crew_quarters/houses/house2
	name = "House #2"
	icon_state = "courtroom"

/area/crew_quarters/houses/house3
	name = "House #3"
	icon_state = "courtroom"

/area/crew_quarters/houses/house4
	name = "House #4"
	icon_state = "courtroom"

/area/crew_quarters/houses/house5
	name = "House #5"
	icon_state = "courtroom"

/area/crew_quarters/houses/house6
	name = "House #6"
	icon_state = "courtroom"

/area/crew_quarters/houses/house7
	name = "House #7"
	icon_state = "courtroom"

/area/crew_quarters/houses/house8
	name = "House #8"
	icon_state = "courtroom"

/area/crew_quarters/houses/house9
	name = "House #9"
	icon_state = "courtroom"

/area/crew_quarters/houses/house10
	name = "House #10"
	icon_state = "courtroom"

//Markets

/area/market
	name = "Market"
	icon_state = "market"

/* dicks */

/area/market/a

/area/market/b

	name = "Ice Cream Parlor"

/area/market/c

/area/market/d


//hi guys smell code
/*
/datum/hook_handler/areasmell
	proc
		HookMobAreaChange(var/list/args)
			var/mob/M = args["mob"]
			var/list/L = list()
			var/itemcount = 0
			world << "command ran"
			if(ismob(M))
				world << "command ran 2"
				if(M:client)
					world << "command ran 3"
					for(var/obj/I in src)
						world << I:name
						L += I
						itemcount++
					M << "This area smells like [L]"
					world << "This area smells like [L]"

			..()
*/


/*
/area/crew_quarters/bar
	name = "Bar"
	icon_state = "bar"
	var/sound/mysound = null

	New()
		..()
		var/sound/S = new/sound()
		mysound = S
		S.repeat = 0
		S.wait = 0
		S.channel = 250
		S.volume = 50
		S.priority = 255
		S.status = SOUND_UPDATE

		process()


	//failed attempt at doing synchtube
	//the reason behind is the fact byond uses internet explorer 5 controls and this happens: http://s1.d2k5.com/Erika1/Screenshot-2012-01-03_00.21.03.jpgo
	//Entered(atom/movable/Obj,atom/OldLoc)
	//	if(ismob(Obj))
	//		var/synchtube = "<meta HTTP-EQUIV=\"REFRESH\" content=\"0; url=http://vps.d2k5.com/synchlube.php\">Loading SynchTube..."
	//		Obj << browse(synchtube, "window=rpane.hosttracker")
	//	return

	//Exited(atom/movable/Obj)
	//	if(ismob(Obj))
	//		if(Obj:client)
	//			Obj << browse("about:blank", "window=rpane.hosttracker")
	//failed attempt at doing synchtube

 	Entered(atom/movable/Obj,atom/OldLoc)
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_UPDATE
				Obj << mysound
		return

	Exited(atom/movable/Obj)
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_PAUSED | SOUND_UPDATE
				Obj << mysound

	proc/process()
		set background = 1

		var/sound/S = null
		var/sound_delay = 0

		mysound.file = pick('diner (1).ogg','diner (2).ogg','diner (3).ogg','diner (4).ogg','diner (5).ogg','diner (6).ogg','diner (7).ogg','diner (8).ogg','diner (9).ogg','diner (10).ogg','diner (11).ogg','diner (12).ogg','diner (13).ogg','diner (14).ogg','diner (15).ogg','diner (16).ogg')

		for(var/mob/living/carbon/human/H in src)
			if(H.client)
				mysound.status = SOUND_UPDATE
				if(mysound.status == SOUND_PAUSED)
					mysound.file = pick('diner (1).ogg','diner (2).ogg','diner (3).ogg','diner (4).ogg','diner (5).ogg','diner (6).ogg','diner (7).ogg','diner (8).ogg','diner (9).ogg','diner (10).ogg','diner (11).ogg','diner (12).ogg','diner (13).ogg','diner (14).ogg','diner (15).ogg','diner (16).ogg')
					mysound.status = SOUND_UPDATE
				H << mysound
				if(S)
					spawn(sound_delay)
						H << S
		spawn(60) .()


*/
/area/crew_quarters/bar
	name = "Bar"
	icon_state = "bar"
	var/currentsong


/area/crew_quarters/theatre
	name = "Theatre"
	icon_state = "Theatre"

/area/library
 	name = "Library"
 	icon_state = "library"

/area/chapel/main
	name = "Chapel"
	icon_state = "chapel"

/area/chapel/office
	name = "Chapel Office"
	icon_state = "chapeloffice"

/area/lawoffice
	name = "Law Office"
	icon_state = "law"

//Engineering

/area/engine/engine_smes
	name = "Engineering SMES"
	icon_state = "engine_smes"
	requires_power = 0//This area only covers the batteries and they deal with their own power

/area/engine/engineering/centre
	name = "Engineering"
	icon_state = "engine"

/area/engine/engineering/west
	name = "Engineering"
	icon_state = "engine"

/area/engine/engineering/controlroom
	name = "Engineering Control Room"
	icon_state = "engine"

/area/engine/engineering/east
	name = "Engineering"
	icon_state = "engine"

/area/engine/singularty
	name = "Singularty Research"
	icon_state = "engine"

/area/engine/chiefs_office
	name = "Chief Engineers office"
	icon_state = "engine_control"

/area/engine/heat_engine
	name = "Heat Distribution Engine"
	icon_state = "heatengine"

/area/engine/heat_engine/Port
	name = "Port Heat Distribution Engine"
	icon_state = "heatengine"

/area/engine/heat_engine/Starboard
	name = "Starboard Heat Distribution Engine"
	icon_state = "heatengine"

/area/engine/engine_hallway
	name = "Auxiliary power control room"
	icon_state = "enginehall"

/area/engine/engine_mon
	name = "Engine Storage"
	icon_state = "enginemon"

/area/engine/engine_eva
	name = "Engine EVA"
	icon_state = "engineeva"

/area/engine/combustion
	name = "Engine Core"
	icon_state = "engine"
	music = "signal"


//Solars

/area/solar
	requires_power = 0
	luminosity = 1
//	sd_lighting = 0
	ul_Lighting = 0

	auxport
		name = "Port Auxiliary Solar Array"
		icon_state = "panelsA"

	bridge
		name = "Bridge Solar Array"
		icon_state = "yellow"

	auxstarboard
		name = "Starboard Auxiliary Solar Array"
		icon_state = "panelsA"

	fore
		name = "Fore Solar Array"
		icon_state = "yellow"

	aft
		name = "Aft Solar Array"
		icon_state = "aft"

	mining
		name = "Mining Station Solar Array"
		icon_state = "yellow"

	starboard
		name = "Starboard Solar Array"
		icon_state = "panelsS"

	port
		name = "Port Solar Array"
		icon_state = "panelsP"

/area/maintenance/auxsolarport
	name = "Port Auxiliary Solar Maintenance"
	icon_state = "SolarcontrolA"

/area/maintenance/auxsolarfore
	name = "Fore Auxiliary Solar Maintenance"
	icon_state = "SolarcontrolA"

/area/maintenance/starboardsolar
	name = "Starboard Solar Maintenance"
	icon_state = "SolarcontrolS"

/area/maintenance/portsolar
	name = "Port Solar Maintenance"
	icon_state = "SolarcontrolP"

/area/maintenance/auxsolarstarboard
	name = "Starboard Auxiliary Solar Maintenance"
	icon_state = "SolarcontrolA"


/area/assembly/chargebay
	name = "Recharging Bay"
	icon_state = "mechbay"

/area/assembly/showroom
	name = "Robotics Showroom"
	icon_state = "showroom"

/area/assembly/assembly_line
	name = "Assembly Line"
	icon_state = "ass_line"

/area/miningasteroid
	name = "Mining Satellite"
	icon_state = "mine"

//Teleporter

/area/teleporter/alpha
	name = "Teleporter"
	icon_state = "teleporter"
	music = "signal"

/area/teleporter/beta
	name = "Teleporter"
	icon_state = "teleporter"
	music = "signal"

/area/AIsattele
	name = "AI Satellite Teleporter Room"
	icon_state = "teleporter"
	music = "signal"

//MedBay

/area/medical/medbay
	name = "Medbay"
	icon_state = "medbay"
	music = 'signal.ogg'

/area/medical/medbaylobby
	name = "Medbay Reception"
	icon_state = "medbay"
	music = 'signal.ogg'

/area/medical/medbaystorage
	name = "Medbay Storage"
	icon_state = "medbay"
	music = 'signal.ogg'

area/medical/medbaystorage2
	name = "Medbay Blood Bank"
	icon_state = "medbay"
	music = 'signal.ogg'

/area/medical/patients_rooms
	name = "Patients Rooms"
	icon_state = "patients"

/area/medical/cmo
	name = "Chief Medical Officer's office"
	icon_state = "CMO"

/area/medical/robotics
	name = "Robotics"
	icon_state = "medresearch"

/area/medical/research
	name = "Medical Research"
	icon_state = "medresearch"

/area/medical/virology
	name = "Virology"
	icon_state = "virology"

/area/medical/morgue
	name = "DEAD NIGGER STORAGE"
	icon_state = "morgue"

/area/medical/chemistry
	name = "Chemistry"
	icon_state = "chem"

/area/medical/surgery
	name = "Surgery"
	icon_state = "surgery"

/area/medical/cryo
	name = "Cryo"
	icon_state = "cryo"

/area/medical/exam_room
	name = "Exam Room"
	icon_state = "exam_room"

/area/medical/genetics
	name = "Genetics"
	icon_state = "genetics"

/area/medical/oproom
	name = "Operating Room"
	icon_state = "operroom"

/area/medical/patientroom
	name = "Operating Room"
	icon_state = "patientroom"

//Security

/area/security/main
	name = "Security"
	icon_state = "security"

/area/security/brig
	name = "Brig"
	icon_state = "brig"

/area/security/brig/cell1
	name = "Cell 1"
	icon_state = "cell1"

/area/security/brig/cell2
	name = "Cell 2"
	icon_state = "cell2"

/area/security/brig/cell3
	name = "Cell 3"
	icon_state = "cell3"

/area/security/brig/cell4
	name = "Cell 4"
	icon_state = "cell4"

/area/security/brig/cell5
	name = "Cell 5"
	icon_state = "cell5"

/area/security/brig/cell6
	name = "Cell 6"
	icon_state = "cell6"

/area/security/armory
	name = "Armory"
	icon_state = "brig"

/area/security/warden
	name = "Warden"
	icon_state = "Warden"

/area/security/hos
	name = "Head of Security"
	icon_state = "security"

/area/security/guardquarters
	name = "Guard's Quarters"
	icon_state = "security"

/area/security/detectives_office
	name = "Detectives Office"
	icon_state = "detective"

/*
	New()
		..()

		spawn(10) //let objects set up first
			for(var/turf/turfToGrayscale in src)
				if(turfToGrayscale.icon)
					var/icon/newIcon = icon(turfToGrayscale.icon)
					newIcon.GrayScale()
					turfToGrayscale.icon = newIcon
				for(var/obj/objectToGrayscale in turfToGrayscale) //1 level deep, means tables, apcs, locker, etc, but not locker contents
					if(objectToGrayscale.icon)
						var/icon/newIcon = icon(objectToGrayscale.icon)
						newIcon.GrayScale()
						objectToGrayscale.icon = newIcon
*/

/area/security/nuke_storage
	name = "Vault"
	icon_state = "nuke_storage"

/area/security/checkpoint
	name = "Security Checkpoint"
	icon_state = "checkpoint1"

/area/security/checkpoint2
	name = "Security Checkpoint"
	icon_state = "security"

/area/security/vacantoffice
	name = "Vacant Office"
	icon_state = "security"

/area/quartermaster
	name = "Quartermasters"
	icon_state = "quart"

///////////WORK IN PROGRESS//////////

/area/quartermaster/sorting
	name = "Delivery Office"
	icon_state = "quartstorage"

////////////WORK IN PROGRESS//////////

/area/quartermaster/office
	name = "Cargo Office"
	icon_state = "quartoffice"

/area/quartermaster/storage
	name = "Cargo Bay"
	icon_state = "quartstorage"

/area/quartermaster/qm
	name = "Quartermaster's Office"
	icon_state = "quart"

/area/quartermaster/miningdock
	name = "Mining Dock"
	icon_state = "mining"

/area/quartermaster/miningstorage
	name = "Mining Storage"
	icon_state = "green"

/area/quartermaster/mechbay
	name = "Mech Bay"
	icon_state = "yellow"

/area/janitor
	name = "Janitors Closet"
	icon_state = "janitor"


/area/laundromat
	name = "Laundromat"
	icon_state = "janitor"

/area/janitorr
	name = "Janitors Room"
	icon_state = "janitor"

/area/hydroponics
	name = "Hydroponics"
	icon_state = "hydro"

/area/science/weaponlab
	name = "Weapons Lab"
	icon_state = "weaponlab"

/area/science/weaponscanner
	name = "Weapons Lab"
	icon_state = "security"

/area/science/viral_lab
	name = "Virology"
	icon_state = "viral_lab"

/area/science/secret_lab
	name = "Secret Lab"
	icon_state = "viral_lab"
//Toxins

/area/toxins/lab
	name = "Science Lab 1"
	icon_state = "toxlab"

/area/toxins/lab2
	name = "Science Lab 2"
	icon_state = "toxlab"

/area/toxins/xenobiology
	name = "Xenobiology Lab"
	icon_state = "toxlab"

/area/toxins/storage
	name = "Toxin Storage"
	icon_state = "toxstorage"

/area/toxins/materialstorage
	name = "Material Storage"
	icon_state = "toxstorage"

/area/toxins/test_area
	name = "Toxin Test Area"
	icon_state = "toxtest"

/area/toxins/mixing
	name = "Toxin Mixing Room"
	icon_state = "toxmix"

/area/toxins/crystalcore
	name = "Crystal Testing Room"
	icon_state = "toxmix"

/area/toxins/server
	name = "Server Room"
	icon_state = "server"


//prison rip off
/area/prison/hallway
	name = "Research Satellite"
	icon_state = "hallF"

/area/prison/hallway/docking
	name = "Shuttle Docking Area"
	icon_state = "docking"

/area/prison/quarters
	name = "Scientists' Quarters"
	icon_state = "crewqrtrs"

/area/prison/kitchen
	name = "Scientists' Kitchen"
	icon_state = "kitchen"

//Research Satellite
/area/rdsat/hallway
	name = "Research Satellite"
	icon_state = "hallF"

/area/rdsat/hallway/docking
	name = "Shuttle Docking Area"
	icon_state = "docking"

/area/rdsat/toxins
	name = "Toxin Research"
	icon_state = "toxlab"

/area/rdsat/tele
	name = "Science Station - Teleporter Room"
	icon_state = "teleporter"

/area/rdsat/gasstorage
	name = "Toxin Research Storage"
	icon_state = "toxstorage"

/area/rdsat/viral_lab
	name = "Viral Research"
	icon_state = "viral_lab"

/area/rdsat/chemistry
	name = "Chemical Research"
	icon_state = "chem"

/area/rdsat/server
	name = "RD Server Core"
	icon_state = "storage"

/area/rdsat/matstorage
	name = "Materials Storage"
	icon_state = "storage"

/area/rdsat/kitchen
	name = "Scientists' Kitchen"
	icon_state = "kitchen"

/area/rdsat/research
	name = "Materials Research"
	icon_state = "research"

/area/rdsat/artifact
	name = "Artifact Research"
	icon_state = "research"

/area/rdsat/quarters
	name = "Scientists' Quarters"
	icon_state = "crewqrtrs"

/area/rdsat/solar
	name = "Research Satellite Solars"
	icon_state = "yellow"
	requires_power = 0

//Storage

/area/storage/tools
	name = "Tool Storage"
	icon_state = "storage"

/area/storage/tools_mirror
	name = "Tool Storage"
	icon_state = "storage"

/area/storage/primary
	name = "Primary Tool Storage"
	icon_state = "primarystorage"

/area/storage/engineeringstools
	name = "Engineering Tool Storage"
	icon_state = "primarystorage"

/area/storage/autolathe
	name = "Autolathe Storage"
	icon_state = "storage"

/area/storage/auxillary
	name = "Auxillary Storage"
	icon_state = "auxstorage"

/area/storage/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/storage/evasecondary
	name = "Secondary EVA Storage"
	icon_state = "eva"

/area/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

/area/storage/emergency
	name = "Emergency Storage A"
	icon_state = "emergencystorage"

/area/storage/emergency2
	name = "Emergency Storage B"
	icon_state = "emergencystorage"

/area/storage/tech
	name = "Technical Storage"
	icon_state = "auxstorage"

/area/storage/testroom
	requires_power = 0
	name = "Test Room"
	icon_state = "storage"

/area/storage/medical_storage
	name = "Medical Storage"
	icon_state = "storage"

/area/lounge/
	name = "The Gentleman's Lounge"
	icon_state = "DJ"

//DJSTATION

/area/djstation
	name = "Ruskie DJ Station"
	icon_state = "DJ"

/area/djstation/solars
	name = "DJ Station Solars"
	icon_state = "DJ"

//DERELICT

/area/derelict
	name = "Derelict Station"
	icon_state = "storage"

/area/derelict/hallway/primary
	name = "Derelict Primary Hallway"
	icon_state = "hallP"

/area/derelict/hallway/secondary
	name = "Derelict Secondary Hallway"
	icon_state = "hallS"
/area/derelict/hallway/engine
	name = "Derelict Engine Hallway"
	icon_state = "hallS"

/area/derelict/arrival
	name = "Derelict Arrival Centre"
	icon_state = "yellow"

/area/derelict/storage/equipment
	name = "Derelict Equipment Storage"

/area/derelict/storage/storage_access
	name = "Derelict Storage Access"

/area/derelict/storage/engine_storage
	name = "Derelict Engine Storage"
	icon_state = "green"

/area/derelict/bridge
	name = "Derelict Control Room"
	icon_state = "bridge"

/area/derelict/secret
	name = "Derelict Secret Room"
	icon_state = "library"

/area/derelict/bridge/access
	name = "Derelict Control Room Access"
	icon_state = "auxstorage"

/area/derelict/sec
	name = "Derelict Security and Brig"
	icon_state = "auxstorage"

/area/derelict/bridge/ai_upload
	name = "Derelict Ruined Computer Core"
	icon_state = "ai"

/area/derelict/solar_control
	name = "Derelict Solar Control"
	icon_state = "engine"

/area/derelict/crew_quarters
	name = "Derelict Crew Quarters"
	icon_state = "fitness"

/area/derelict/medical
	name = "Derelict Medbay"
	icon_state = "medbay"

/area/derelict/medical/morgue
	name = "Derelict Morgue"
	icon_state = "morgue"

/area/derelict/medical/chapel
	name = "Derelict Chapel"
	icon_state = "chapel"

/area/derelict/teleporter
	name = "Derelict Teleporter"
	icon_state = "teleporter"

/area/derelict/eva
	name = "Derelict EVA Storage"
	icon_state = "eva"

/area/derelict/ship
	name = "Abandoned ship"
	icon_state = "yellow"

/area/derelict/science
	name = "Derelict Science"
	icon_state = "yellow"


/area/derelict/Courtroom
	name = "Derelict Courtroom"
	icon_state = "yellow"

/area/solar/derelict_starboard
	name = "Derelict Starboard Solar Array"
	icon_state = "panelsS"

/area/solar/derelict_aft
	name = "Derelict Aft Solar Array"
	icon_state = "aft"

/area/derelict/singularity_engine
	name = "Derelict Singularity Engine"
	icon_state = "engine"

//Construction

/area/construction
	name = "Construction Area"
	icon_state = "yellow"

/area/construction/supplyshuttle
	name = "Supply Shuttle"
	icon_state = "yellow"

/area/construction/quarters
	name = "Engineer's Quarters"
	icon_state = "yellow"

/area/construction/qmaint
	name = "Maintenance"
	icon_state = "yellow"

/area/construction/hallway
	name = "Hallway"
	icon_state = "yellow"

/area/construction/solars
	name = "Solar Panels"
	icon_state = "yellow"

/area/construction/solarscontrol
	name = "Solar Panel Control"
	icon_state = "yellow"

/area/construction/Storage
	name = "Construction Site Storage"
	icon_state = "yellow"

/area/construction/depot
	name = "Construction Depot"
	icon_state = "yellow"

/area/construction/mech
	name = "Mech Bay"
	icon_state = "yellow"

//AI

/area/ai_monitored/storage/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/ai_monitored/upload/uploadentry
	name = "AI upload Outer Door"
	icon_state = "ai_foyer"

/area/ai_monitored/virology/virologyentry
	name = "Virology Airlock"
	icon_state = "ai_foyer"

/area/ai_monitored/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

/area/ai_monitored/storage/emergency
	name = "Emergency Storage"
	icon_state = "storage"

/area/turret_protected/ai_upload
	name = "AI Upload Chamber"
	icon_state = "ai_upload"

/area/turret_protected/ai_upload_foyer
	name = "AI Upload Foyer"
	icon_state = "ai_foyer"

/area/turret_protected/ai
	name = "AI Chamber"
	icon_state = "ai_chamber"

/area/turret_protected/aifoyer
	name = "AI Chamber Foyer"
	icon_state = "ai_chamber"

/area/turret_protected/aisat
	name = "AI Satellite"
	icon_state = "ai"

/area/turret_protected/aisat_interior
	name = "AI Satellite"
	icon_state = "ai"

/area/turret_protected/cannoncontrols
	name = "Laser Cannon Controls"
	icon_state = "ai"

/area/turret_protected/AIsatextFP
	name = "AI Sat Ext"
	icon_state = "storage"
	luminosity = 1
//	sd_lighting = 0
	ul_Lighting = 0

/area/turret_protected/AIsatextFS
	name = "AI Sat Ext"
	icon_state = "storage"
	luminosity = 1
//	sd_lighting = 0
	ul_Lighting = 0

/area/turret_protected/AIsatextAS
	name = "AI Sat Ext"
	icon_state = "storage"
	luminosity = 1
//	sd_lighting = 0
	ul_Lighting = 0

/area/turret_protected/AIsatextAP
	name = "AI Sat Ext"
	icon_state = "storage"
	luminosity = 1
//	sd_lighting = 0
	ul_Lighting = 0

/area/turret_protected/NewAIMain
	name = "AI Main New"
	icon_state = "storage"

/area/turret_protected/weaplab
	name = "Weapons Lab"
	icon_state = "weaponlabT"

//AI Satellite areas not covered with turret_protected

/area/AISat/porthallwayN
	name = "Port Hallway North"
	icon_state = "storage"

/area/AISat/porthallwayS
	name = "Port Hallway South"
	icon_state = "storage"

/area/AISat/starboardhallwayN
	name = "Starboard Hallway North"
	icon_state = "storage"

/area/AISat/starboardhallwayS
	name = "Starboard Hallway South"
	icon_state = "storage"

/area/AISat/atmosA
	name = "Atmospherics A"
	icon_state = "docking"

/area/AISat/atmosB
	name = "Atmospherics B"
	icon_state = "docking"

/area/AISat/bar
	name = "McPubbies' Bar and Grill"
	icon_state = "green"

/area/AISat/barhydro
	name = "McPubbies' Hydroponics"
	icon_state = "green"

/area/AISat/barkitchen
	name = "McPubbies' Kitchen"
	icon_state = "green"

/area/AISat/maint
	name = "Satellite Maintenance"
	icon_state = "yellow"
	requires_power = 0 //two reasons for this: designing it would be a nightmare and it's only batteries and such crap anyway

/area/AISat/cyborgbayp
	name = "Cyborg Bay Port"
	icon_state = "auxstorage"

/area/AISat/cyborgbays
	name = "Cyborg Bay Starboard"
	icon_state = "auxstorage"

/area/AISat/auxstoragep
	name = "Auxiliary Storage Port"
	icon_state = "auxstorage"

/area/AISat/auxstorages
	name = "Auxiliary Storage Starboard"
	icon_state = "auxstorage"

/area/AISat/engineering
	name = "Engineering"
	icon_state = "engine"


/////////////////////////////////////////////////////////////////////
/*
 Lists of areas to be used with is_type_in_list.
 Used in gamemodes code at the moment. --rastaf0
*/

// CENTCOM
var/list/centcom_areas = list (
	/area/centcom,
	/area/shuttle/escape/centcom,
	/area/shuttle/transport1/centcom,
	/area/shuttle/transport2/centcom,
	/area/shuttle/administration/centcom,
	/area/shuttle/specops/centcom,
)

//SPACE STATION 13
var/list/the_station_areas = list (
	/area/shuttle/arrival,
	/area/shuttle/escape/station,
	/area/shuttle/mining/station,
	/area/shuttle/transport1/station,
	// /area/shuttle/transport2/station,
	/area/shuttle/prison/station,
	/area/shuttle/administration/station,
	/area/shuttle/specops/station,
	/area/atmos,
	/area/maintenance,
	/area/hallway,
	/area/bridge,
	/area/crew_quarters,
	/area/mint,
	/area/library,
	/area/chapel,
	/area/lawoffice,
	/area/engine,
	/area/solar,
	/area/assembly,
	/area/teleporter,
	/area/medical,
	/area/security,
	/area/quartermaster,
	/area/janitor,
	/area/hydroponics,
	/area/toxins,
	/area/storage,
	/area/construction,
	/area/ai_monitored/storage/eva, //do not try to simplify to "/area/ai_monitored" --rastaf0
	/area/ai_monitored/storage/secure,
	/area/ai_monitored/storage/emergency,
	/area/turret_protected/ai_upload, //do not try to simplify to "/area/turret_protected" --rastaf0
	/area/turret_protected/ai_upload_foyer,
	/area/turret_protected/ai,
)


/area/beach
	name = "Keelin's private beach"
	icon_state = "null"
	luminosity = 1
//	sd_lighting = 0
	ul_Lighting = 0
	requires_power = 0

/area/FTLship
 	name = "unknown location"
 	icon_state = "atmos"

/area/FTLship/tele
 	name = "Teleporter Room (unknown location)"
 	icon_state = "atmos"

/area/FTLship/bridge
 	name = "Bridge (unknown location)"
 	icon_state = "atmos"

/area/FTLship/hallways
 	name = "Hallway (unknown location)"
 	icon_state = "atmos"

/area/FTLship/engineroom
 	name = "Engine Room (unknown location)"
 	icon_state = "atmos"

/area/FTLship/Sciencelab1
 	name = "Science Lab 1 (unknown location)"
 	icon_state = "atmos"

/area/FTLship/Sciencelab2
 	name = "Science Lab 2 (unknown location)"
 	icon_state = "atmos"

/area/FTLship/medical
 	name = "Medbay (unknown location)"
 	icon_state = "storage"