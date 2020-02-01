/***************************************************************
**						Design Datums						  **
**	All the data for building stuff and tracking reliability. **
***************************************************************/
/*
For the materials datum, it assumes you need reagents unless specified otherwise. To designate a material that isn't a reagent,
you use one of the material IDs below. These are NOT ids in the usual sense (they aren't defined in the object or part of a datum),
they are simply references used as part of a "has materials?" type proc. They all start with a $ to denote that they aren't reagents.
The currently supporting non-reagent materials:
- $metal (/obj/item/stack/metal). One sheet = 3750 units.
- $glass (/obj/item/stack/glass). One sheet = 3750 units.
- $plasma (/obj/item/stack/plasma). One sheet = 3750 units.
- $silver (/obj/item/stack/silver). One sheet = 3750 units.
- $gold (/obj/item/stack/gold). One sheet = 3750 units.
- $uranium (/obj/item/stack/uranium). One sheet = 3750 units.
- $diamond (/obj/item/stack/diamond). One sheet = 3750 units.
- $clown (/obj/item/stack/clown). One sheet = 3750 units. ("Bananium")
(Insert new ones here)

Don't add new keyword/IDs if they are made from an existing one (such as rods which are made from metal). Only add raw materials.

Design Guidlines
- The reliability formula for all R&D built items is reliability_base (a fixed number) + total tech levels required to make it +
reliability_mod (starts at 0, gets improved through experimentation). Example: PACMAN generator. 79 base reliablity + 6 tech
(3 plasmatech, 3 powerstorage) + 0 (since it's completely new) = 85% reliability. Reliability is the chance it works CORRECTLY.
- When adding new designs, check rdreadme.dm to see what kind of things have already been made and where new stuff is needed.
- A single sheet of anything is 3750 units of material. Materials besides metal/glass require help from other jobs (mining for
other types of metals and chemistry for reagents).
- Add the AUTOLATHE tag to


*/
#define	IMPRINTER	1	//For circuits. Uses glass/chemicals.
#define PROTOLATHE	2	//New stuff. Uses glass/metal/chemicals
#define	AUTOLATHE	4	//Uses glass/metal only.
#define CRAFTLATHE	8	//Uses fuck if I know. For use eventually.
#define MECHFAB		16
//Note: More then one of these can be added to a design but imprinter and lathe designs are incompatable.

datum
	design						//Datum for object designs, used in construction
		var
			name = "Name"					//Name of the created object.
			desc = "Desc"					//Description of the created object.
			id = "id"						//ID of the created object for easy refernece. Alphanumeric, lower-case, no symbols
			list/req_tech = list()			//IDs of that techs the object originated from and the minimum level requirements.
			reliability_mod = 0				//Reliability modifier of the device at it's starting point.
			reliability_base = 100			//Base reliability of a device before modifiers.
			reliability = 100				//Reliability of the device.
			build_type = null				//Flag as to what kind machine the design is built in. See defines.
			list/materials = list()			//List of materials. Format: "id" = amount.
			build_path = ""					//The file path of the object that gets created

		proc
			//A proc to calculate the reliability of a design based on tech levels and innate modifiers.
			//Input: A list of /datum/tech; Output: The new reliabilty.
			CalcReliability(var/list/temp_techs)
				var/new_reliability = reliability_mod + reliability_base
				for(var/datum/tech/T in temp_techs)
					if(T.id in req_tech)
						new_reliability += T.level
				new_reliability = between(reliability_base, new_reliability, 100)
				reliability = new_reliability
				return


///////////////////Computer Boards///////////////////////////////////

		seccamera
			name = "Circuit Design (Security)"
			desc = "Allows for the construction of circuit boards used to build security camera computers."
			id = "seccamera"
			req_tech = list("programming" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/security"

		aicore
			name = "Circuit Design (AI Core)"
			desc = "Allows for the construction of circuit boards used to build new AI cores."
			id = "aicore"
			req_tech = list("programming" = 4, "biotech" = 3)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/aicore"

		aiupload
			name = "Circuit Design (AI Upload)"
			desc = "Allows for the construction of circuit boards used to build an AI Upload Console."
			id = "aiupload"
			req_tech = list("programming" = 4)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/aiupload"

		med_data
			name = "Circuit Design (Medical Records)"
			desc = "Allows for the construction of circuit boards used to build a medical records console."
			id = "med_data"
			req_tech = list("programming" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/med_data"

		pandemic
			name = "Circuit Design (PanD.E.M.I.C. 2200)"
			desc = "Allows for the construction of circuit boards used to build a PanD.E.M.I.C. 2200 console."
			id = "pandemic"
			req_tech = list("programming" = 2, "biotech" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/pandemic"

		scan_console
			name = "Circuit Design (DNA Machine)"
			desc = "Allows for the construction of circuit boards used to build a new DNA scanning console."
			id = "scan_console"
			req_tech = list("programming" = 2, "biotech" = 3)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/machinery/scan_consolenew"

		comconsole
			name = "Circuit Design (Communications)"
			desc = "Allows for the construction of circuit boards used to build a communications console."
			id = "comconsole"
			req_tech = list("programming" = 2, "magnets" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/communications"

		idcardconsole
			name = "Circuit Design (ID Computer)"
			desc = "Allows for the construction of circuit boards used to build an ID computer."
			id = "idcardconsole"
			req_tech = list("programming" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/card"

		teleconsole
			name = "Circuit Design (Teleporter Console)"
			desc = "Allows for the construction of circuit boards used to build a teleporter control console."
			id = "teleconsole"
			req_tech = list("programming" = 3, "bluespace" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/teleporter"

		secdata
			name = "Circuit Design (Security Records Console)"
			desc = "Allows for the construction of circuit boards used to build a security records console."
			id = "secdata"
			req_tech = list("programming" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/secure_data"

		atmosalerts
			name = "Circuit Design (Atmosphere Alerts Console)"
			desc = "Allows for the construction of circuit boards used to build an atmosphere alert console.."
			id = "atmosalerts"
			req_tech = list("programming" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/atmosphere/alerts"

		air_management
			name = "Circuit Design (Atmospheric Monitor)"
			desc = "Allows for the construction of circuit boards used to build an Atmospheric Monitor."
			id = "air_management"
			req_tech = list("programming" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/general_air_control"

/*		general_alert
			name = "Circuit Design (General Alert Console)"
			desc = "Allows for the construction of circuit boards used to build a General Alert console."
			id = "general_alert"
			req_tech = list("programming" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/general_alert"

		robocontrol
			name = "Circuit Design (Robotics Control Console)"
			desc = "Allows for the construction of circuit boards used to build a Robotics Control console."
			id = "robocontrol"
			req_tech = list("programming" = 4)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/robotics"

		clonecontrol
			name = "Circuit Design (Cloning Machine Console)"
			desc = "Allows for the construction of circuit boards used to build a new Cloning Machine console."
			id = "clonecontrol"
			req_tech = list("programming" = 3, "biotech" = 3)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/cloning"
*/
		arcademachine
			name = "Circuit Design (Arcade Machine)"
			desc = "Allows for the construction of circuit boards used to build a new arcade machine."
			id = "arcademachine"
			req_tech = list("programming" = 1)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/arcade"

		powermonitor
			name = "Circuit Design (Power Monitor)"
			desc = "Allows for the construction of circuit boards used to build a new power monitor"
			id = "powermonitor"
			req_tech = list("programming" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/powermonitor"
/*
		prisonmanage
			name = "Circuit Design (Prisoner Management Console)"
			desc = "Allows for the construction of circuit boards used to build a prisoner management console."
			id = "prisonmanage"
			req_tech = list("programming" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/prisoner"

		mechacontrol
			name = "Circuit Design (Exosuit Control Console)"
			desc = "Allows for the construction of circuit boards used to build an exosuit control console."
			id = "mechacontrol"
			req_tech = list("programming" = 3)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/mecha_control"
*/
///////////////////////////////////
//////////AI Module Disks//////////
///////////////////////////////////
		safeguard_module
			name = "Module Design (Safeguard)"
			desc = "Allows for the construction of a Safeguard AI Module."
			id = "safeguard_module"
			req_tech = list("programming" = 3)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20, "$gold" = 100)
			build_path = "/obj/item/weapon/aiModule/safeguard"

		onehuman_module
			name = "Module Design (OneHuman)"
			desc = "Allows for the construction of a OneHuman AI Module."
			id = "onehuman_module"
			req_tech = list("programming" = 4)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20, "$diamond" = 100)
			build_path = "/obj/item/weapon/aiModule/oneHuman"

		protectstation_module
			name = "Module Design (ProtectStation)"
			desc = "Allows for the construction of a ProtectStation AI Module."
			id = "protectstation_module"
			req_tech = list("programming" = 3)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20, "$gold" = 100)
			build_path = "/obj/item/weapon/aiModule/protectStation"

		notele_module
			name = "Module Design (TeleporterOffline Module)"
			desc = "Allows for the construction of a TeleporterOffline AI Module."
			id = "notele_module"
			req_tech = list("programming" = 3)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20, "$gold" = 100)
			build_path = "/obj/item/weapon/aiModule/teleporterOffline"

		quarantine_module
			name = "Module Design (Quarantine)"
			desc = "Allows for the construction of a Quarantine AI Module."
			id = "quarantine_module"
			req_tech = list("programming" = 3, "biotech" = 2, "$gold" = 100)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/aiModule/quarantine"

		oxygen_module
			name = "Module Design (OxygenIsToxicToHumans)"
			desc = "Allows for the construction of a Safeguard AI Module."
			id = "oxygen_module"
			req_tech = list("programming" = 3, "biotech" = 2, "$gold" = 100)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/aiModule/oxygen"

		freeform_module
			name = "Module Design (Freeform)"
			desc = "Allows for the construction of a Freeform AI Module."
			id = "freeform_module"
			req_tech = list("programming" = 4)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20, "$gold" = 100)
			build_path = "/obj/item/weapon/aiModule/freeform"

		reset_module
			name = "Module Design (Reset)"
			desc = "Allows for the construction of a Reset AI Module."
			id = "reset_module"
			req_tech = list("programming" = 3)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20, "$gold" = 100)
			build_path = "/obj/item/weapon/aiModule/reset"

		purge_module
			name = "Module Design (Purge)"
			desc = "Allows for the construction of a Purge AI Module."
			id = "purge_module"
			req_tech = list("programming" = 4)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20, "$diamond" = 100)
			build_path = "/obj/item/weapon/aiModule/purge"

		freeformcore_module
			name = "Core Module Design (Freeform)"
			desc = "Allows for the construction of a Freeform AI Core Module."
			id = "freeformcore_module"
			req_tech = list("programming" = 4)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20, "$diamond" = 100)
			build_path = "/obj/item/weapon/aiModule/freeformcore"

		asimov
			name = "Core Module Design (Asimov)"
			desc = "Allows for the construction of a Asimov AI Core Module."
			id = "asimov_module"
			req_tech = list("programming" = 3)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20, "$diamond" = 100)
			build_path = "/obj/item/weapon/aiModule/asimov"

		paladin_module
			name = "Core Module Design (P.A.L.A.D.I.N.)"
			desc = "Allows for the construction of a P.A.L.A.D.I.N. AI Core Module."
			id = "paladin_module"
			req_tech = list("programming" = 4)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20, "$diamond" = 100)
			build_path = "/obj/item/weapon/aiModule/paladin"

		tyrant_module
			name = "Core Module Design (T.Y.R.A.N.T.)"
			desc = "Allows for the construction of a T.Y.R.A.N.T. AI Module."
			id = "tyrant_module"
			req_tech = list("programming" = 4, "syndicate" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20, "$diamond" = 100)
			build_path = "/obj/item/weapon/aiModule/tyrant"


///////////////////////////////////
/////Non-Board Computer Stuff//////
///////////////////////////////////

		intellicard
			name = "Intellicard AI Transportation System"
			desc = "Allows for the construction of an intellicard."
			id = "intellicard"
			req_tech = list("programming" = 4)
			build_type = PROTOLATHE
			materials = list("$glass" = 1000, "$gold" = 200)
			build_path = "/obj/item/device/aicard"


///////////////////////////////////
//////////Mecha Module Disks///////
///////////////////////////////////

		ripley_main
			name = "Circuit Design (APLU \"Ripley\" Central Control module)"
			desc = "Allows for the construction of a \"Ripley\" Central Control module."
			id = "ripley_main"
			req_tech = list("programming" = 3, "materials" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/mecha_parts/circuitboard/ripley/main"

		ripley_peri
			name = "Circuit Design (APLU \"Ripley\" Peripherals Control module)"
			desc = "Allows for the construction of a  \"Ripley\" Peripheral Control module."
			id = "ripley_peri"
			req_tech = list("programming" = 3, "materials" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/mecha_parts/circuitboard/ripley/peripherals"

		gygax_main
			name = "Circuit Design (\"Gygax\" Central Control module)"
			desc = "Allows for the construction of a \"Gygax\" Central Control module."
			id = "gygax_main"
			req_tech = list("programming" = 4, "materials" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/mecha_parts/circuitboard/gygax/main"

		gygax_peri
			name = "Circuit Design (\"Gygax\" Peripherals Control module)"
			desc = "Allows for the construction of a \"Gygax\" Peripheral Control module."
			id = "gygax_peri"
			req_tech = list("programming" = 4, "materials" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/mecha_parts/circuitboard/gygax/peripherals"

		gygax_targ
			name = "Circuit Design (\"Gygax\" Weapons & Targeting Control module)"
			desc = "Allows for the construction of a \"Gygax\" Weapons & Targeting Control module."
			id = "gygax_targ"
			req_tech = list("programming" = 4, "materials" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/mecha_parts/circuitboard/gygax/targeting"

		durand_main
			name = "Circuit Design (\"Durand\" Central Control module)"
			desc = "Allows for the construction of a \"Durand\" Central Control module."
			id = "durand_main"
			req_tech = list("programming" = 4, "materials" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/mecha_parts/circuitboard/durand/main"

		durand_peri
			name = "Circuit Design (\"Durand\" Peripherals Control module)"
			desc = "Allows for the construction of a \"Durand\" Peripheral Control module."
			id = "durand_peri"
			req_tech = list("programming" = 4, "materials" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/mecha_parts/circuitboard/durand/peripherals"

		durand_targ
			name = "Circuit Design (\"Durand\" Weapons & Targeting Control module)"
			desc = "Allows for the construction of a \"Durand\" Weapons & Targeting Control module."
			id = "durand_targ"
			req_tech = list("programming" = 4, "materials" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/mecha_parts/circuitboard/durand/targeting"


		honker_main
			name = "Circuit Design (\"H.O.N.K\" Central Control module)"
			desc = "Allows for the construction of a \"H.O.N.K\" Central Control module."
			id = "honker_main"
			req_tech = list("programming" = 3, "materials" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/mecha_parts/circuitboard/honker/main"

		honker_peri
			name = "Circuit Design (\"H.O.N.K\" Peripherals Control module)"
			desc = "Allows for the construction of a \"H.O.N.K\" Peripheral Control module."
			id = "honker_peri"
			req_tech = list("programming" = 3, "materials" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/mecha_parts/circuitboard/honker/peripherals"

		honker_targ
			name = "Circuit Design (\"H.O.N.K\" Weapons & Targeting Control module)"
			desc = "Allows for the construction of a \"H.O.N.K\" Weapons & Targeting Control module."
			id = "honker_targ"
			req_tech = list("programming" = 3, "materials" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/mecha_parts/circuitboard/honker/targeting"


////////////////////////////////////////
/////////// Mecha Equpment /////////////
////////////////////////////////////////

		mech_scattershot
			name = "Exosuit Weapon Design (LBX AC 10 \"Scattershot\")"
			desc = "Allows for the construction of LBX AC 10."
			id = "mech_scattershot"
			build_type = MECHFAB
			req_tech = list("combat" = 4)
			build_path = "/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot"

		mech_laser
			name = "Exosuit Weapon Design (CH-PS \"Immolator\" Laser)"
			desc = "Allows for the construction of CH-PS Laser."
			id = "mech_laser"
			build_type = MECHFAB
			req_tech = list("combat" = 2)
			build_path = "/obj/item/mecha_parts/mecha_equipment/weapon/laser"

		mech_grenade_launcher
			name = "Exosuit Weapon Design (SGL-6 Grenade Launcher)"
			desc = "Allows for the construction of SGL-6 Grenade Launcher."
			id = "mech_grenade_launcher"
			build_type = MECHFAB
			req_tech = list("combat" = 3)
			build_path = "/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flashbang"

		mech_wormhole_gen
			name = "Exosuit Module Design (Localized Wormhole Generator)"
			desc = "An exosuit module that allows generating of small quasi-stable wormholes."
			id = "mech_wormhole_gen"
			build_type = MECHFAB
			req_tech = list("bluepace" = 4)
			build_path = "/obj/item/mecha_parts/mecha_equipment/wormhole_generator"

		mech_teleporter
			name = "Exosuit Module Design (Teleporter Module)"
			desc = "An exosuit module that allows exosuits to teleport to any position in view."
			id = "mech_teleporter"
			build_type = MECHFAB
			req_tech = list("bluespace" = 10)
			build_path = "/obj/item/mecha_parts/mecha_equipment/teleporter"

		mech_rcd
			name = "Exosuit Module Design (RCD Module)"
			desc = "An exosuit-mounted Rapid Construction Device."
			id = "mech_rcd"
			build_type = MECHFAB
			req_tech = list("materials" = 4, "bluespace" = 4, "magnets" = 4, "powerstorage"=4)
			build_path = "/obj/item/mecha_parts/mecha_equipment/tool/rcd"

		mech_gravcatapult
			name = "Exosuit Module Design (Gravitational Catapult Module)"
			desc = "An exosuit mounted Gravitational Catapult."
			id = "mech_gravcatapult"
			build_type = MECHFAB
			req_tech = list("bluespace" = 1, "magnets" = 3)
			build_path = "/obj/item/mecha_parts/mecha_equipment/gravcatapult"


////////////////////////////////////////
//////////Disk Construction Disks///////
////////////////////////////////////////
		design_disk
			name = "Design Storage Disk"
			desc = "Produce additional disks for storing device designs."
			id = "design_disk"
			req_tech = list("programming" = 1)
			build_type = PROTOLATHE | AUTOLATHE
			materials = list("$metal" = 30, "$glass" = 10)
			build_path = "/obj/item/weapon/disk/design_disk"

		tech_disk
			name = "Technology Data Storage Disk"
			desc = "Produce additional disks for storing technology data."
			id = "tech_disk"
			req_tech = list("programming" = 1)
			build_type = PROTOLATHE | AUTOLATHE
			materials = list("$metal" = 30, "$glass" = 10)
			build_path = "/obj/item/weapon/disk/tech_disk"

////////////////////////////////////////
/////////////Stock Parts////////////////
////////////////////////////////////////

		basic_capacitor
			name = "Basic Capacitor"
			desc = "A stock part used in the construction of various devices."
			id = "basic_capacitor"
			req_tech = list("powerstorage" = 1)
			build_type = PROTOLATHE | AUTOLATHE
			materials = list("$metal" = 50, "$glass" = 50)
			build_path = "/obj/item/weapon/stock_parts/capacitor"

		basic_sensor
			name = "Basic Sensor Module"
			desc = "A stock part used in the construction of various devices."
			id = "basic_sensor"
			req_tech = list("magnets" = 1)
			build_type = PROTOLATHE | AUTOLATHE
			materials = list("$metal" = 50, "$glass" = 20)
			build_path = "/obj/item/weapon/stock_parts/scanning_module"

		micro_mani
			name = "Micro Manipulator"
			desc = "A stock part used in the construction of various devices."
			id = "micro_mani"
			req_tech = list("materials" = 1, "programming" = 1)
			build_type = PROTOLATHE | AUTOLATHE
			materials = list("$metal" = 30)
			build_path = "/obj/item/weapon/stock_parts/manipulator"

		basic_micro_laser
			name = "Basic Micro-Laser"
			desc = "A stock part used in the construction of various devices."
			id = "basic_micro_laser"
			req_tech = list("magnets" = 1)
			build_type = PROTOLATHE | AUTOLATHE
			materials = list("$metal" = 10, "$glass" = 20)
			build_path = "/obj/item/weapon/stock_parts/micro_laser"

		basic_matter_bin
			name = "Basic Matter Bin"
			desc = "A stock part used in the construction of various devices."
			id = "basic_matter_bin"
			req_tech = list("materials" = 1)
			build_type = PROTOLATHE | AUTOLATHE
			materials = list("$metal" = 80)
			build_path = "/obj/item/weapon/stock_parts/matter_bin"

		adv_capacitor
			name = "Advanced Capacitor"
			desc = "A stock part used in the construction of various devices."
			id = "adv_capacitor"
			req_tech = list("powerstorage" = 3)
			build_type = PROTOLATHE
			materials = list("$metal" = 50, "$glass" = 50)
			build_path = "/obj/item/weapon/stock_parts/capacitor/adv"

		adv_sensor
			name = "Advanced Sensor Module"
			desc = "A stock part used in the construction of various devices."
			id = "adv_sensor"
			req_tech = list("magnets" = 3)
			build_type = PROTOLATHE
			materials = list("$metal" = 50, "$glass" = 20)
			build_path = "/obj/item/weapon/stock_parts/scanning_module/adv"

		nano_mani
			name = "Nano Manipulator"
			desc = "A stock part used in the construction of various devices."
			id = "nano_mani"
			req_tech = list("materials" = 3, "programming" = 2)
			build_type = PROTOLATHE
			materials = list("$metal" = 30)
			build_path = "/obj/item/weapon/stock_parts/manipulator/nano"

		high_micro_laser
			name = "High-Power Micro-Laser"
			desc = "A stock part used in the construction of various devices."
			id = "high_micro_laser"
			req_tech = list("magnets" = 3)
			build_type = PROTOLATHE
			materials = list("$metal" = 10, "$glass" = 20)
			build_path = "/obj/item/weapon/stock_parts/micro_laser/high"

		adv_matter_bin
			name = "Advanced Matter Bin"
			desc = "A stock part used in the construction of various devices."
			id = "adv_matter_bin"
			req_tech = list("materials" = 3)
			build_type = PROTOLATHE
			materials = list("$metal" = 80)
			build_path = "/obj/item/weapon/stock_parts/matter_bin/adv"

		super_capacitor
			name = "Super Capacitor"
			desc = "A stock part used in the construction of various devices."
			id = "super_capacitor"
			req_tech = list("powerstorage" = 5, "materials" = 4)
			build_type = PROTOLATHE
			reliability_base = 71
			materials = list("$metal" = 50, "$glass" = 50, "$gold" = 20)
			build_path = "/obj/item/weapon/stock_parts/capacitor/super"

		phasic_sensor
			name = "Phasic Sensor Module"
			desc = "A stock part used in the construction of various devices."
			id = "phasic_sensor"
			req_tech = list("magnets" = 5, "materials" = 3)
			build_type = PROTOLATHE
			materials = list("$metal" = 50, "$glass" = 20, "$silver" = 10)
			reliability_base = 72
			build_path = "/obj/item/weapon/stock_parts/scanning_module/phasic"

		pico_mani
			name = "Pico Manipulator"
			desc = "A stock part used in the construction of various devices."
			id = "pico_mani"
			req_tech = list("materials" = 5, "programming" = 2)
			build_type = PROTOLATHE
			materials = list("$metal" = 30)
			reliability_base = 73
			build_path = "/obj/item/weapon/stock_parts/manipulator/pico"

		ultra_micro_laser
			name = "Ultra-High-Power Micro-Laser"
			desc = "A stock part used in the construction of various devices."
			id = "ultra_micro_laser"
			req_tech = list("magnets" = 5, "materials" = 5)
			build_type = PROTOLATHE
			materials = list("$metal" = 10, "$glass" = 20, "$uranium" = 10)
			reliability_base = 70
			build_path = "/obj/item/weapon/stock_parts/micro_laser/ultra"

		super_matter_bin
			name = "Super Matter Bin"
			desc = "A stock part used in the construction of various devices."
			id = "super_matter_bin"
			req_tech = list("materials" = 5)
			build_type = PROTOLATHE
			materials = list("$metal" = 80)
			reliability_base = 75
			build_path = "/obj/item/weapon/stock_parts/matter_bin/super"

////////////////////////////////////////
//////////////////Power/////////////////
////////////////////////////////////////

		basic_cell
			name = "Basic Power Cell"
			desc = "A basic power cell that holds 1000 units of energy"
			id = "basic_cell"
			req_tech = list("powerstorage" = 1)
			build_type = PROTOLATHE | AUTOLATHE
			materials = list("$metal" = 700, "$glass" = 50)
			build_path = "/obj/item/weapon/cell"

		high_cell
			name = "High-Capacity Power Cell"
			desc = "A power cell that holds 10000 units of energy"
			id = "high_cell"
			req_tech = list("powerstorage" = 2)
			build_type = PROTOLATHE | AUTOLATHE
			materials = list("$metal" = 700, "$glass" = 60)
			build_path = "/obj/item/weapon/cell/high"

		super_cell
			name = "Super-Capacity Power Cell"
			desc = "A power cell that holds 20000 units of energy"
			id = "super_cell"
			req_tech = list("powerstorage" = 3, "materials" = 2)
			reliability_base = 75
			build_type = PROTOLATHE
			materials = list("$metal" = 700, "$glass" = 70)
			build_path = "/obj/item/weapon/cell/super"

////////////////////////////////////////
//////////////MISC Boards///////////////
////////////////////////////////////////

		destructive_analyzer
			name = "Destructive Analyzer Board"
			desc = "The circuit board for a destructive analyzer."
			id = "destructive_analyzer"
			req_tech = list("materials" = 2, "magnets" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/destructive_analyzer"

		protolathe
			name = "Protolathe Board"
			desc = "The circuit board for a protolathe."
			id = "protolathe"
			req_tech = list("materials" = 3)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/protolathe"

		circuit_imprinter
			name = "Circuit Imprinter Board"
			desc = "The circuit board for a circuit imprinter."
			id = "circuit_imprinter"
			req_tech = list("materials" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/circuit_imprinter"

		autolathe
			name = "Autolathe Board"
			desc = "The circuit board for a autolathe."
			id = "autolathe"
			req_tech = list("materials" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/autolathe"

		rdservercontrol
			name = "R&D Server Control Console Board"
			desc = "The circuit board for a R&D Server Control Console"
			id = "rdservercontrol"
			req_tech = list("programming" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/rdservercontrol"

		rdserver
			name = "R&D Server Board"
			desc = "The circuit board for an R&D Server"
			id = "rdserver"
			req_tech = list("programming" = 2)
			build_type = IMPRINTER
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/rdserver"

/////////////////////////////////////////
////////////Power Stuff//////////////////
/////////////////////////////////////////

		pacman
			name = "PACMAN-type Generator Board"
			desc = "The circuit board that for a PACMAN-type portable generator."
			id = "pacman"
			req_tech = list("plasmatech" = 3, "powerstorage" = 3)
			build_type = IMPRINTER
			reliability_base = 79
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/pacman"

		superpacman
			name = "SUPERPACMAN-type Generator Board"
			desc = "The circuit board that for a SUPERPACMAN-type portable generator."
			id = "superpacman"
			req_tech = list("materials" = 5, "powerstorage" = 4)
			build_type = IMPRINTER
			reliability_base = 76
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/pacman/super"

		mrspacman
			name = "MRSPACMAN-type Generator Board"
			desc = "The circuit board that for a MRSPACMAN-type portable generator."
			id = "mrspacman"
			req_tech = list("materials" = 6, "powerstorage" = 5)
			build_type = IMPRINTER
			reliability_base = 74
			materials = list("$glass" = 2000, "acid" = 20)
			build_path = "/obj/item/weapon/circuitboard/pacman/mrs"


/////////////////////////////////////////
////////////Medical Tools////////////////
/////////////////////////////////////////

		mass_spectrometer
			name = "Mass-Spectrometer"
			desc = "A device for analyzing chemicals in the blood."
			id = "mass_spectrometer"
			req_tech = list("biotech" = 2, "magnets" = 2)
			build_type = PROTOLATHE
			materials = list("$metal" = 30, "$glass" = 20)
			reliability_base = 76
			build_path = "/obj/item/device/mass_spectrometer"

		adv_mass_spectrometer
			name = "Advanced Mass-Spectrometer"
			desc = "A device for analyzing chemicals in the blood and their quantities."
			id = "adv_mass_spectrometer"
			req_tech = list("biotech" = 2, "magnets" = 4)
			build_type = PROTOLATHE
			materials = list("$metal" = 30, "$glass" = 20)
			reliability_base = 74
			build_path = "/obj/item/device/mass_spectrometer/adv"

		hypospray
			name = "Medical Hypospray"
			desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
			id = "hypospray"
			req_tech = list("biotech" = 4, "materials" = 2)
			build_type = PROTOLATHE
			materials = list("$metal" = 30)
			reliability_base = 74
			build_path = "/obj/item/weapon/reagent_containers/hypospray"

		hyposprayvial
			name = "Hypospray Vial"
			desc = "A small vial that contains chemicals for a hypospray."
			id = "hyposprayvial"
			req_tech = list("biotech" = 4, "materials" = 2)
			build_type = PROTOLATHE
			materials = list("$metal" = 1)
			reliability_base = 74
			build_path = "/obj/item/weapon/reagent_containers/glass/hyposprayvial"

		dermalregenerator
			name = "Dermal Regenerator"
			desc = "A small vial that contains chemicals for a hypospray."
			id = "dermalregenerator"
			req_tech = list("biotech" = 4, "magnets" = 4)
			build_type = PROTOLATHE
			materials = list("$metal" = 1)
			reliability_base = 74
			build_path = "/obj/item/weapon/dermalregenerator"


		tricorder
			name = "Medical Tricorder"
			desc = "The medical tricorder is used by doctors to help diagnose diseases and collect bodily information about a patient."
			id = "Tricorder"
			req_tech = list("biotech" = 4, "magnets" = 4)
			build_type = PROTOLATHE
			materials = list("$metal" = 30, "$glass" = 20)
			reliability_base = 74
			build_path = "/obj/item/device/Tricorder"

/*		mmi
			name = "Man-Machine Interface"
			desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity."
			id = "mmi"
			req_tech = list("biotech" = 3)
			build_type = PROTOLATHE | MECHFAB
			materials = list("$metal" = 1000, "$glass" = 500)
			reliability_base = 76
			build_path = "/obj/item/device/mmi"
*/
/////////////////////////////////////////
/////////////////Weapons/////////////////
/////////////////////////////////////////

		nuclear_gun
			name = "Advanced Energy Gun"
			desc = "An energy gun with an experimental miniaturized reactor."
			id = "nuclear_gun"
			req_tech = list("combat" = 3, "materials" = 5, "powerstorage" = 3)
			build_type = PROTOLATHE
			materials = list("$metal" = 5000, "$glass" = 1000, "$uranium" = 500)
			reliability_base = 76
			build_path = "/obj/item/weapon/gun/energy/general/nuclear"

/*		large_grenade
			name = "Large Grenade"
			desc = "A grenade that affects a larger area and use larger containers."
			id = "large_Grenade"
			req_tech = list("combat" = 3, "materials" = 3)
			build_type = PROTOLATHE
			materials = list("$metal" = 3000)
			reliability_base = 79
			build_path = "/obj/item/weapon/chem_grenade/large"*/

		ak331
			name = "AK-331"
			desc = "An automatic machine gun."
			id = "ak331"
			req_tech = list("combat" = 3, "materials" = 6)
			build_type = PROTOLATHE
			materials = list("$metal" = 6000)
			reliability_base = 79
			build_path = "/obj/item/weapon/gun/ak331"

		carbine
			name = "Carbine"
			desc = "An automatic machine gun."
			id = "carbine"
			req_tech = list("combat" = 3, "materials" = 3)
			build_type = PROTOLATHE
			materials = list("$metal" = 6000)
			reliability_base = 79
			build_path = "/obj/item/weapon/gun/carbine"

		laser_gun
			name = "Laser Gun"
			desc = "Replica of the Mark 1 Laser Gun."
			id = "plasma_pistol"
			req_tech = list("combat" = 4, "materials" = 3, "powerstorage" = 3)
			build_type = PROTOLATHE
			materials = list("$metal" = 2000, "$plasma" = 2000)
			reliability_base = 79
			build_path = "/obj/item/weapon/gun/energy/laser_gun/captain"

		plasma_pistol
			name = "Plasma Pistol"
			desc = "Pre-Production version of the Mark 1 Plasma Pistol."
			id = "plasma_pistol"
			req_tech = list("combat" = 4, "materials" = 3, "plasmatech" = 2, "powerstorage" = 2)
			build_type = PROTOLATHE
			materials = list("$metal" = 3000, "$plasma" = 3000)
			reliability_base = 79
			build_path = "/obj/item/weapon/gun/energy/Research/plasma_pistol"

		Plasma_Rifle
			name = "Plasma Rifle"
			desc = "Pre-Production version of the Mark 1 Plasma Rifle."
			id = "Plasma_Rifle"
			req_tech = list("combat" = 4, "materials" = 3, "plasmatech" = 3, "powerstorage" = 2)
			build_type = PROTOLATHE
			materials = list("$metal" = 6000, "$plasma" = 6000)
			reliability_base = 79
			build_path = "/obj/item/weapon/gun/energy/Research/Plasma_Rifle"

		Heavy_Plasma
			name = "Heavy Plasma Rifle"
			desc = "Pre-Production version of the Mark 1 Plasma Pistol."
			id = "Heavy_Plasma"
			req_tech = list("combat" = 5, "materials" = 5, "plasmatech" = 5,  "powerstorage" = 3)
			build_type = PROTOLATHE
			materials = list("$metal" = 9000, "$plasma" = 9000)
			reliability_base = 79
			build_path = "/obj/item/weapon/gun/energy/Research/Heavy_Plasma"

		pulse_rifle
			name = "Pulse Rifle"
			desc = "A heavy-duty, pulse-based energy weapon preferred by front-line combat personnel."
			id = "pulse_rifle"
			req_tech = list("combat" = 7, "materials" = 5,  "powerstorage" = 5, "magnets" =5)
			build_type = PROTOLATHE
			materials = list("$metal" = 19000, "$uranium" = 4000 )
			reliability_base = 79
			build_path = "/obj/item/weapon/gun/energy/pulse_rifle"


/////////////////////////////////////////
/////////////////Mining//////////////////
/////////////////////////////////////////

		pick_silver
			name = "Silver Pickaxe"
			desc = "This makes no metallurgic sense."
			id = "pick_silver"
			req_tech = list("materials" = 3)
			build_type = PROTOLATHE
			materials = list("$silver" = 3000)
			reliability_base = 79
			build_path = "/obj/item/weapon/pickaxe/silver"

		pick_gold
			name = "Golden Pickaxe"
			desc = "This makes no metallurgic sense."
			id = "pick_gold"
			req_tech = list("materials" = 4)
			build_type = PROTOLATHE
			materials = list("$gold" = 3000)
			reliability_base = 79
			build_path = "/obj/item/weapon/pickaxe/gold"

		pick_diamond
			name = "Diamond Pickaxe"
			desc = "This makes no metallurgic sense."
			id = "pick_diamond"
			req_tech = list("materials" = 6)
			build_type = PROTOLATHE
			materials = list("$diamond" = 3000)
			reliability_base = 79
			build_path = "/obj/item/weapon/pickaxe/diamond"

/////////////////////////////////////////
//////////////Blue Space/////////////////
/////////////////////////////////////////

		bag_holding
			name = "Bag of Holding"
			desc = "A backpack that opens into a localized pocket of Blue Space."
			id = "bag_holding"
			req_tech = list("bluespace" = 4)
			build_type = PROTOLATHE
			materials = list("$gold" = 3000, "$diamond" = 1500, "$uranium" = 250)
			reliability_base = 80
			build_path = "/obj/item/weapon/storage/backpack/holding"

/////////////////////////////////////////
//////////////////Test///////////////////
/////////////////////////////////////////

	/*	test
			name = "Test Design"
			desc = "A design to test the new protolathe."
			id = "protolathe_test"
			build_type = PROTOLATHE
			req_tech = list("materials" = 1)
			materials = list("$gold" = 3000, "iron" = 15, "copper" = 10, "$silver" = 2500)
			build_path = "/obj/item/weapon/banhammer" */

////////////////////////////////////////
//Disks for transporting design datums//
////////////////////////////////////////

/obj/item/weapon/disk/design_disk
	name = "Component Design Disk"
	desc = "A disk for storing device design data for construction in lathes."
	icon = 'cloning.dmi'
	icon_state = "datadisk2"
	item_state = "card-id"
	w_class = 1.0
	m_amt = 30
	g_amt = 10
	var/datum/design/blueprint
	New()
		src.pixel_x = rand(-5.0, 5)
		src.pixel_y = rand(-5.0, 5)


