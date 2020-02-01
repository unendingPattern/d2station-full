/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME 	(you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = "ICON FILENAME" 			(defaults to areas.dmi)
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = 0 				(defaults to 1)
	music = "music/music.ogg"		(defaults to "music/music.ogg")

*/


/area
	var/fire = null
	var/atmos = 1
	var/poweralm = 1
	var/party = null
	level = null
	name = "Space"
	icon = 'areas.dmi'
	icon_state = "unknown"
	layer = 10
	mouse_opacity = 0
	var/lightswitch = 1

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



//These are shuttle areas, they must contain two areas in a subgroup if you want to move a shuttle from one
//place to another. Look at escape shuttle for example.

/area/shuttle //DO NOT TURN THE SD_LIGHTING STUFF ON FOR SHUTTLES. IT BREAKS THINGS.
	requires_power = 0
	luminosity = 1
	sd_lighting = 0

/area/shuttle/arrival
	name = "Arrival Shuttle"

/area/shuttle/arrival/pre_game
	icon_state = "shuttle2"

/area/shuttle/arrival/station
	icon_state = "shuttle"

/area/shuttle/heatengine/dock
	icon_state = "shuttle5"

/area/shuttle/heatengine/satellite
	icon_state = "shuttle5"

/area/shuttle/dock2
	icon_state = "shuttle6"

/area/shuttle/escape
	name = "Emergency Shuttle"
	music = "music/escape.ogg"

/area/shuttle/escape/station
	icon_state = "shuttle2"

/area/shuttle/escape/centcom
	icon_state = "shuttle"

/area/shuttle/nori/
	name = "Nori's Shuttle"

/area/shuttle/nori/norishuttle
	icon_state = "shuttle5"

/area/shuttle/prison/
	name = "Prison Shuttle"

/area/shuttle/prison/station
	icon_state = "shuttle"

/area/shuttle/prison/prison
	icon_state = "shuttle2"

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
// === Trying to remove these areas:

/area/airtunnel1/      // referenced in airtunnel.dm:759

/area/dummy/           // Referenced in engine.dm:261

/area/start            // will be unused once kurper gets his login interface patch done
	name = "start area"
	icon_state = "start"

// === end remove


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

/area/medical/robotics
	name = "Robotics"
	icon_state = "medresearch"

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

//

/area/centcom
	name = "Centcom"
	icon_state = "purple"
	requires_power = 0

/area/atmos
 	name = "Atmospherics"
 	icon_state = "atmos"


/area/maintenance/fpmaint
	name = "Fore Port Maintenance"
	icon_state = "fpmaint"


/area/maintenance/fsmaint
	name = "Fore Starboard Maintenance"
	icon_state = "fsmaint"


/area/maintenance/asmaint
	name = "Aft Starboard Maintenance"
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

/area/maintenance/forebeta
	name = "Fore Maintenance"
	icon_state = "fmaintbeta"

/area/maintenance/bathroom
	name = "Bathroom"
	icon_state = "bathroom"


/area/maintenance/starboard
	name = "Starboard Maintenance"
	icon_state = "smaint"


/area/maintenance/port
	name = "Port Maintenance"
	icon_state = "pmaint"

/area/maintenance/aft
	name = "Aft Maintenance"
	icon_state = "amaint"


/area/maintenance/starboardsolar
	name = "Starboard Solar Maintenance"
	icon_state = "SolarcontrolS"

/area/maintenance/portsolar
	name = "Port Solar Maintenance"
	icon_state = "SolarcontrolP"


/area/maintenance/storage
	name = "Atmospherics"
	icon_state = "green"


/area/maintenance/disposal
	name = "Waste Disposal"
	icon_state = "disposal"


/area/hallway/primary/fore
	name = "Fore Primary Hallway"
	icon_state = "hallF"

/area/hallway/primary/forebeta
	name = "Fore Primary Hallway"
	icon_state = "hallBeta"


/area/hallway/primary/starboard
	name = "Starboard Primary Hallway"
	icon_state = "hallS"


/area/hallway/primary/aft
	name = "Aft Primary Hallway"
	icon_state = "hallA"

/area/hallway/primary/northquad
	name = "North hall way"
	icon_state = "hallNorth"

/area/hallway/primary/northeastquad
	name = "North East hall way"
	icon_state = "hallW"


/area/hallway/primary/port
	name = "Port Primary Hallway"
	icon_state = "hallP"


/area/hallway/primary/central
	name = "Central Primary Hallway"
	icon_state = "hallC"


/area/hallway/secondary/exit
	name = "Escape Shuttle Hallway"
	icon_state = "escape"

/area/hallway/secondary/docking
	name = "Shuttle Docking Area"
	icon_state = "docking"

/area/hallway/secondary/construction
	name = "Construction Area"
	icon_state = "construction"


/area/hallway/secondary/entry
	name = "Arrival Shuttle Hallway"
	icon_state = "entry"


/area/bridge
	name = "Bridge"
	icon_state = "bridge"
	music = "signal"


/area/crew_quarters/locker
	name = "Locker Room"
	icon_state = "locker"

/area/crew_quarters/crew
	name = "Crew Quarters"
	icon_state = "crewqrtrs"

/area/crew_quarters/fitness
	name = "Fitness Room"
	icon_state = "fitness"

/area/crew_quarters/pool
	name = "Pool"
	icon_state = "pool"
	var/sound/mysound = null

	New()
		..()
		var/sound/S = new/sound()
		mysound = S
		S.file = 'shore.ogg'
		S.repeat = 1
		S.wait = 0
		S.channel = 123
		S.volume = 100
		S.priority = 255
		S.status = SOUND_UPDATE
		process()

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
		if(prob(25))
			S = sound(file=pick('seag1.ogg','seag2.ogg','seag3.ogg'), volume=100)
			sound_delay = rand(0, 50)

		for(var/mob/living/carbon/human/H in src)
			if(H.s_tone > -55)
				H.s_tone--
				H.update_body()
			if(H.client)
				mysound.status = SOUND_UPDATE
				H << mysound
				if(S)
					spawn(sound_delay)
						H << S

		spawn(60) .()

/area/crew_quarters/captain
	name = "Captain's Quarters"
	icon_state = "captain"


/area/crew_quarters/cafeteria
	name = "Cafeteria"
	icon_state = "cafeteria"


/area/crew_quarters/kitchen
	name = "Kitchen"
	icon_state = "kitchen"


/area/crew_quarters/bar
	name= "Bar"
	icon_state = "bar"


/area/crew_quarters/heads
	name = "Head of Staff's Quarters"
	icon_state = "head_quarters"


/area/crew_quarters/hor
	name = "Head of Research's Office"
	icon_state = "head_quarters"


/area/crew_quarters/chief
	name = "Chief Engineer's Office"
	icon_state = "head_quarters"



/area/crew_quarters/courtroom
	name = "Courtroom"
	icon_state = "courtroom"


/area/engine/engine_smes
	name = "Engine SMES Room"
	icon_state = "engine"


/area/engine/engine_walls
	name = "Engine Walls"
	icon_state = "engine"

/area/engine/engine_gas_storage
	name = "Engine Storage"
	icon_state = "engine_gas_storage"


/area/engine/engine_hallway
	name = "Engine Hallway"
	icon_state = "engine_hallway"

/area/engine/heat_engine
	name = "Heat Distribution Engine"
	icon_state = "heatengine"

/area/engine/engine_mon
	name = "Engine Monitoring"
	icon_state = "engine_monitoring"


/area/engine/combustion
	name = "Engine Combustion Chamber"
	icon_state = "engine"
	music = "signal"


/area/engine/engine_control
	name = "Engine Control"
	icon_state = "engine_control"

/area/engine/launcher
	name = "Engine Launcher Room"
	icon_state = "engine_monitoring"


/area/teleporter
	name = "Teleporter"
	icon_state = "teleporter"
	music = "signal"


/area/AIsattele
	name = "AI Satellite Teleporter Room"
	icon_state = "teleporter"
	music = "signal"

/area/eventhorizon/bridge
	name = "Bridge of the Event Horizon"
	icon_state = "bridge"
	music = "signal"
	requires_power = 1


/area/eventhorizon/hallway
	name = "Main Hallway Event Horizon"
	icon_state = "hallC"
	music = "signal"
	requires_power = 1


/area/eventhorizon/teleporter
	name = "Teleporter Event Horizon"
	icon_state = "teleporter"
	music = "signal"
	requires_power = 1


/area/eventhorizon/storage
	name = "Storage Event Horizon"
	icon_state = "teleporter"
	music = "signal"
	requires_power = 1


/area/eventhorizon/Engineering.
	name = "Engineering and Atmospherics Event Horizon"
	icon_state = "teleporter"
	music = "signal"
	requires_power = 1

/area/eventhorizon/cryo.
	name = "Cryogenics Event Horizon"
	icon_state = "teleporter"
	music = "signal"
	requires_power = 1


/area/eventhorizon/medical.
	name = "medical Event Horizon"
	icon_state = "medresearch"
	music = "signal"
	requires_power = 1

/area/tdome
	name = "Thunderdome"
	icon_state = "medbay"
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

/area/medical/medbay
	name = "Medbay"
	icon_state = "medbay"
	music = 'signal.ogg'


/area/medical/research
	name = "Medical Research"
	icon_state = "medresearch"

/area/medical/alpharesearch
	name = "Alpha Medical Research"
	icon_state = "medresearch"



/area/medical/morgue
	name = "Morgue"
	icon_state = "morgue"


/area/security/main
	name = "Security"
	icon_state = "security"


/area/security/checkpoint
	name = "Security Checkpoint"
	icon_state = "checkpoint1"


/area/security/checkpoint2
	name = "Security Checkpoint"
	icon_state = "checkpoint2"

/area/security/checkpoint3
	name = "Security Checkpoint"
	icon_state = "checkpoint3"

/area/security/brig
	name = "Brig"
	icon_state = "brig"

/area/security/weaponlabS
	name = "Weapon Lab Sercurity Checkpoint"
	icon_state = "weaponlabS"

/area/security/BetaSercurity
	name = "Beta Hall Sercurity Checkpoint"
	icon_state = "BetaS"

/area/security/BetaSercurity1
	name = "Beta Hall Sercurity Checkpoint 2"
	icon_state = "BetaS"

/area/security/detectives_office
	name = "Detectives Office"
	icon_state = "detective"

/area/solar
	requires_power = 0
	luminosity = 1
	sd_lighting = 0

/area/solar/fore
	name = "Fore Solar Array"
	icon_state = "yellow"


/area/solar/aft
	name = "Aft Solar Array"
	icon_state = "aft"


/area/solar/starboard
	name = "Starboard Solar Array"
	icon_state = "panelsS"


/area/solar/port
	name = "Port Solar Array"
	icon_state = "panelsP"

/area/solar/derelict_starboard
	name = "Derelict Starboard Solar Array"
	icon_state = "panelsS"

/area/solar/derelict_aft
	name = "Derelict Aft Solar Array"
	icon_state = "aft"

/area/syndicate_station
	name = "Syndicate Station"
	icon_state = "yellow"
	requires_power = 0

/area/wizard_station
	name = "Wizard's Den"
	icon_state = "yellow"
	requires_power = 0


/area/quartermaster/office
	name = "Quartermaster's Office"
	icon_state = "quartoffice"


/area/quartermaster/storage
	name = "Quartermaster's Storage"
	icon_state = "quartstorage"


/area/quartermaster/
	name = "Quartermasters"
	icon_state = "quart"

/area/janitor/
	name = "Janitors Closet"
	icon_state = "janitor"


/area/chemistry
	name = "Chemistry"
	icon_state = "chem"

/area/Qplab
	name = "Quantum Physics"
	icon_state = "chem"


/area/Qplab2
	name = "Quarentine hanger"
	icon_state = "qhang"

/area/QplabdangerAI
	name = "dangerous AI"
	icon_state = "shodan"

/area/QplabdangerAI2
	name = "Recreation area"
	icon_state = "RA"

/area/hydroponics
	name = "Hydroponics"
	icon_state = "hydro"

/area/science/weaponlab
	name = "Weapons Lab"
	icon_state = "weaponlab"

/area/science/medicalalpha
	name = "Medlab Alpha"
	icon_state = "medicalalpha"


/area/science/physlab
	name = "Physics Lab"
	icon_state = "physicslab"

/area/science/Alphalab
	name = "Science Lab Alpha"
	icon_state = "SciAlpha"

/area/science/Ateleporter
	name = "High Sercurity Reseach Teleporter"
	icon_state = "AlphaTele"

/area/science/Asolar
	name = "High Sercurity Solar generator"
	icon_state = "AlphaSolar"

/area/science/viral_lab
	name = "Virology"
	icon_state = "viral_lab"

/area/toxins/lab
	name = "Toxin Lab"
	icon_state = "toxlab"

/area/toxins/heatlab
	name = "Heated Environment Lab"
	icon_state = "heatlab"

/area/toxins/storage
	name = "Toxin Storage"
	icon_state = "toxstorage"


/area/toxins/test_area
	name = "Toxin Test Area"
	icon_state = "toxtest"


/area/toxins/mixing
	name = "Toxin Mixing Room"
	icon_state = "toxmix"


/area/chapel/main
	name = "Chapel"
	icon_state = "chapel"


/area/chapel/office
	name = "Chapel Office"
	icon_state = "chapeloffice"


/area/storage/tools
	name = "Tool Storage"
	icon_state = "storage"


/area/storage/primary
	name = "Primary Tool Storage"
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

/area/derelict
	name = "Derelict Station"
	icon_state = "storage"

/area/derelict/hallway/primary
	name = "Derelict Primary Hallway"
	icon_state = "hallP"

/area/derelict/hallway/secondary
	name = "Derelict Secondary Hallway"
	icon_state = "hallS"

/area/derelict/arrival
	name = "Arrival Centre"
	icon_state = "yellow"

/area/derelict/storage/equipment
	name = "Derelict Equipment Storage"

/area/derelict/storage/storage_access
	name = "Derelict Storage Access"

/area/derelict/storage/engine_storage
	name = "Derelict Engine Storage"
	icon_state = "green"

/area/derelict/bridge
	name = "Control Room"
	icon_state = "bridge"

/area/derelict/bridge/access
	name = "Control Room Access"
	icon_state = "auxstorage"

/area/derelict/bridge/ai_upload
	name = "Ruined Computer Core"
	icon_state = "ai"

/area/derelict/solar_control
	name = "Solar Control"
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

/area/ai_monitored/storage/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/ai_monitored/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

/area/ai_monitored/storage/emergency
	name = "Emergency Storage"
	icon_state = "storage"

/area/ai_monitored/storage/AiHall
	name = "AI Hallway"
	icon_state = "AIHall"

/area/turret_protected/ai_upload
	name = "AI Upload Chamber"
	icon_state = "ai_upload"

/area/turret_protected/ai_upload_foyer
	name = "AI Upload Foyer"
	icon_state = "ai_foyer"

/area/turret_protected/ai
	name = "AI Chamber"
	icon_state = "ai_chamber"

/area/turret_protected/aisat
	name = "AI Satellite"
	icon_state = "ai"

/area/turret_protected/aisat_interior
	name = "AI Satellite"
	icon_state = "ai"

/area/turret_protected/AIsatextFP
	name = "AI Sat Ext"
	icon_state = "storage"

/area/turret_protected/AIsatextFS
	name = "AI Sat Ext"
	icon_state = "storage"

/area/turret_protected/AIsatextAS
	name = "AI Sat Ext"
	icon_state = "storage"

/area/turret_protected/AIsatextAP
	name = "AI Sat Ext"
	icon_state = "storage"


/area/asteroid					// -- TLE
	name = "Asteroid"
	icon_state = "asteroid"
	requires_power = 0

/area/asteroid/cave				// -- TLE
	name = "Asteroid - Underground"
	icon_state = "cave"
	requires_power = 0

/area/library
 	name = "Library"
 	icon_state = "library"

/area/lawoffice
	name = "Law Office"
	icon_state = "law"