//SUPPLY PACKS
//NOTE: only secure crate types use the access var (and are lockable)
//NOTE: hidden packs only show up when the computer has been hacked.

/datum/supply_packs/specialops
	name = "Special Ops supplies"
	contains = list("/obj/item/weapon/storage/emp_kit",
					"/obj/item/weapon/smokebomb",
					"/obj/item/weapon/smokebomb",
					"/obj/item/weapon/smokebomb",
					"/obj/item/weapon/pen/sleepypen",
					"/obj/item/weapon/chem_grenade/incendiary")
	cost = 20
	containertype = "/obj/crate"
	containername = "Special Ops crate"
	hidden = 1

/datum/supply_packs/wizard
	name = "Wizard costume"
	contains = list("/obj/item/weapon/staff",
					"/obj/item/clothing/suit/wizrobe/fake",
					"/obj/item/clothing/shoes/sandal",
					"/obj/item/clothing/head/wizard/fake")
	cost = 20
	containertype = "/obj/crate"
	containername = "Wizard costume crate"

/datum/supply_packs/metal50
	name = "50 Metal Sheets"
	contains = list("/obj/item/stack/sheet/metal")
	amount = 50
	cost = 15
	containertype = "/obj/crate"
	containername = "Metal sheets crate"

/datum/supply_packs/glass50
	name = "50 Glass Sheets"
	contains = list("/obj/item/stack/sheet/glass")
	amount = 50
	cost = 15
	containertype = "/obj/crate"
	containername = "Glass sheets crate"

/datum/supply_packs/internals
	name = "Internals crate"
	contains = list("/obj/item/clothing/mask/gas",
					"/obj/item/clothing/mask/gas",
					"/obj/item/clothing/mask/gas",
					"/obj/item/weapon/tank/air",
					"/obj/item/weapon/tank/air",
					"/obj/item/weapon/tank/air")
	cost = 10
	containertype = "/obj/crate/internals"
	containername = "Internals crate"

/datum/supply_packs/food
	name = "Food crate"
	contains = list("/obj/item/weapon/reagent_containers/food/snacks/flour",
					"/obj/item/weapon/reagent_containers/food/snacks/flour",
					"/obj/item/weapon/reagent_containers/food/snacks/flour",
					"/obj/item/weapon/reagent_containers/food/snacks/faggot",
					"/obj/item/weapon/reagent_containers/food/snacks/faggot",
					"/obj/item/weapon/reagent_containers/food/snacks/faggot",
					"/obj/item/kitchen/egg_box",
					"/obj/item/weapon/storage/condimentbottles",
					"/obj/item/weapon/reagent_containers/food/snacks/banana",
					"/obj/item/weapon/reagent_containers/food/snacks/banana",
					"/obj/item/weapon/reagent_containers/food/snacks/banana")
	cost = 5
	containertype = "/obj/crate/freezer"
	containername = "Food crate"

/datum/supply_packs/meat
	name = "Meat crate"
	contains = list("/obj/item/weapon/reagent_containers/food/snacks/monkeymeat",
					"/obj/item/weapon/reagent_containers/food/snacks/monkeymeat",
					"/obj/item/weapon/reagent_containers/food/snacks/monkeymeat",
					"/obj/item/weapon/reagent_containers/food/snacks/monkeymeat",
					"/obj/item/weapon/reagent_containers/food/snacks/monkeymeat",
					"/obj/item/weapon/reagent_containers/food/snacks/monkeymeat",
					"/obj/item/weapon/reagent_containers/food/snacks/monkeymeat",
					"/obj/item/weapon/reagent_containers/food/snacks/monkeymeat",
					"/obj/item/weapon/reagent_containers/food/snacks/monkeymeat")
	cost = 10
	containertype = "/obj/crate/freezer"
	containername = "Meat crate"

/* DO NOT UNCOMMENT THIS, ORDERING THEM WILL BREAK THE SHUTTLE
/datum/supply_packs/monkey
	name = "Monkey crate"
	contains = list("/mob/living/carbon/monkey",
					"/mob/living/carbon/monkey",
					"/mob/living/carbon/monkey",
					"/mob/living/carbon/monkey",
					"/mob/living/carbon/monkey")
	cost = 20
	containertype = "/obj/crate/freezer"
	containername = "Monkey crate" */

/datum/supply_packs/engineering
	name = "Engineering crate"
	contains = list("/obj/item/weapon/storage/toolbox/electrical",
					"/obj/item/weapon/storage/toolbox/electrical",
					"/obj/item/clothing/head/helmet/welding",
					"/obj/item/clothing/head/helmet/welding",
					"/obj/item/weapon/cell",
					"/obj/item/weapon/cell",
					"/obj/item/clothing/gloves/yellow",
					"/obj/item/clothing/gloves/yellow")
	cost = 5
	containertype = "/obj/crate"
	containername = "Engineering crate"

/datum/supply_packs/engine
	name = "Emitter crate"
	contains = list("/obj/machinery/emitter",
					"/obj/machinery/emitter",)
	cost = 10
	containertype = "/obj/crate/secure"
	containername = "Emitter crate"
	access = access_heads

/datum/supply_packs/engine/field_gen
	name = "Field Generator crate"
	contains = list("/obj/machinery/field_generator",
					"/obj/machinery/field_generator",)
	containername = "Field Generator crate"

/datum/supply_packs/engine/sing_gen
	name = "Singularity Generator crate"
	contains = list("/obj/machinery/the_singularitygen")
	containername = "Singularity Generator crate"

/datum/supply_packs/engine/collector
	name = "Collector crate"
	contains = list("/obj/machinery/power/rad_collector")
	containername = "Collector crate"

/datum/supply_packs/engine/PA
	name = "Particle Accelerator crate"
	cost = 40
	contains = list("/obj/particle_accelerator/fuel_chamber",
					"/obj/machinery/particle_accelerator/control_box",
					"/obj/particle_accelerator/particle_emitter/center",
					"/obj/particle_accelerator/particle_emitter/left",
					"/obj/particle_accelerator/particle_emitter/right",
					"/obj/particle_accelerator/power_box",
					"/obj/particle_accelerator/end_cap")
	containername = "Particle Accelerator crate"

/datum/supply_packs/medical
	name = "Medical crate"
	contains = list("/obj/item/weapon/storage/firstaid/regular",
					"/obj/item/weapon/storage/firstaid/fire",
					"/obj/item/weapon/storage/firstaid/toxin",
					"/obj/item/weapon/storage/firstaid/oxydep",
					"/obj/item/weapon/reagent_containers/glass/bottle/antitoxin",
					"/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline",
					"/obj/item/weapon/reagent_containers/glass/bottle/stoxin",
					"/obj/item/weapon/storage/firstaid/hypospray",
					"/obj/item/weapon/storage/firstaid/syringes")
	cost = 10
	containertype = "/obj/crate/medical"
	containername = "Medical crate"


/datum/supply_packs/virus
	name = "Virus crate"
	contains = list("/obj/item/weapon/reagent_containers/glass/bottle/flu_virion",
					"/obj/item/weapon/reagent_containers/glass/bottle/bird_flu_virion",
					"/obj/item/weapon/reagent_containers/glass/bottle/swine_flu_virion",
					"/obj/item/weapon/reagent_containers/glass/bottle/cold",
					"/obj/item/weapon/reagent_containers/glass/bottle/tvirus",
					"/obj/item/weapon/reagent_containers/glass/bottle/plague",
					"/obj/item/weapon/reagent_containers/glass/bottle/alzheimers",
					"/obj/item/weapon/reagent_containers/glass/bottle/ebola",
					"/obj/item/weapon/reagent_containers/glass/bottle/inhalational_anthrax",
					"/obj/item/weapon/reagent_containers/glass/bottle/beesease",
					"/obj/item/weapon/storage/firstaid/syringes",
					"/obj/item/weapon/storage/beakerbox")
	cost = 20
	containertype = "/obj/crate/secure/weapon"
	containername = "Virus crate"
	access = access_heads


/datum/supply_packs/janitor
	name = "Janitorial supplies"
	contains = list("/obj/item/weapon/reagent_containers/glass/bucket",
					"/obj/item/weapon/reagent_containers/glass/bucket",
					"/obj/item/weapon/reagent_containers/glass/bucket",
					"/obj/item/weapon/mop",
					"/obj/item/weapon/caution",
					"/obj/item/weapon/caution",
					"/obj/item/weapon/caution",
					"/obj/item/weapon/cleaner",
					"/obj/item/weapon/chem_grenade/cleaner",
					"/obj/item/weapon/chem_grenade/cleaner",
					"/obj/item/weapon/chem_grenade/cleaner",
					"/obj/mopbucket")
	cost = 10
	containertype = "/obj/crate"
	containername = "Janitorial supplies"

/obj/item/weapon/storage/lightbox/tubes

/datum/supply_packs/lightbulbs
	name = "Replacement lights"
	contains = list("/obj/item/weapon/storage/lightbox/tubes",
					"/obj/item/weapon/storage/lightbox/tubes",
					"/obj/item/weapon/storage/lightbox/tubes",
					"/obj/item/weapon/storage/lightbox/tubes",
					"/obj/item/weapon/storage/lightbox",
					"/obj/item/weapon/storage/lightbox",
					"/obj/item/weapon/storage/lightbox",
					"/obj/item/weapon/storage/lightbox")
	cost = 10
	containertype = "/obj/crate"
	containername = "Replacement lights"

/datum/supply_packs/plasma
	name = "Plasma assembly crate"
	contains = list("/obj/item/weapon/tank/plasma",
					"/obj/item/weapon/tank/plasma",
					"/obj/item/weapon/tank/plasma",
					"/obj/item/device/igniter",
					"/obj/item/device/igniter",
					"/obj/item/device/igniter",
					"/obj/item/device/prox_sensor",
					"/obj/item/device/prox_sensor",
					"/obj/item/device/prox_sensor",
					"/obj/item/device/timer",
					"/obj/item/device/timer",
					"/obj/item/device/timer")
	cost = 10
	containertype = "/obj/crate/secure/plasma"
	containername = "Plasma assembly crate"
	access = access_tox

/datum/supply_packs/weapons
	name = "Weapons crate"
	contains = list("/obj/item/weapon/baton",
					"/obj/item/weapon/baton",
					"/obj/item/weapon/gun/energy/laser_gun",
					"/obj/item/weapon/gun/energy/laser_gun",
					"/obj/item/weapon/gun/energy/taser_gun",
					"/obj/item/weapon/gun/energy/taser_gun",
					"/obj/item/weapon/storage/flashbang_kit",
					"/obj/item/weapon/storage/flashbang_kit")
	cost = 20
	hidden = 1
	containertype = "/obj/crate/secure/weapon"
	containername = "Weapons crate"
	access = access_security

/datum/supply_packs/eweapons
	name = "Experimental weapons crate"
	contains = list("/obj/item/weapon/flamethrower",
					"/obj/item/weapon/tank/plasma",
					"/obj/item/weapon/tank/plasma",
					"/obj/item/weapon/tank/plasma",
					"/obj/item/weapon/chem_grenade/incendiary",
					"/obj/item/weapon/chem_grenade/incendiary",
					"/obj/item/weapon/chem_grenade/incendiary",
					"/obj/item/clothing/gloves/stungloves")
	cost = 25
	hidden = 1
	containertype = "/obj/crate/secure/weapon"
	containername = "Experimental weapons crate"
	access = access_heads

/datum/supply_packs/riot
	name = "Riot crate"
	contains = list("/obj/item/weapon/baton",
					"/obj/item/weapon/baton",
					"/obj/item/weapon/shield/riot",
					"/obj/item/weapon/shield/riot",
					"/obj/item/weapon/storage/flashbang_kit",
					"/obj/item/weapon/storage/flashbang_kit",
					"/obj/item/weapon/handcuffs",
					"/obj/item/weapon/handcuffs")
	cost = 30
	containertype = "/obj/crate/secure/gear"
	containername = "Riot crate"
	access = access_security

/datum/supply_packs/evacuation
	name = "Emergency equipment"
	contains = list("/obj/machinery/bot/floorbot",
	"/obj/machinery/bot/floorbot",
	"/obj/machinery/bot/floorbot",
	"/obj/machinery/bot/floorbot",
	"/obj/item/weapon/tank/air",
	"/obj/item/weapon/tank/air",
	"/obj/item/weapon/tank/air",
	"/obj/item/weapon/tank/air",
	"/obj/item/weapon/tank/air",
	"/obj/item/clothing/mask/gas",
	"/obj/item/clothing/mask/gas",
	"/obj/item/clothing/mask/gas",
	"/obj/item/clothing/mask/gas",
	"/obj/item/clothing/mask/gas")
	cost = 35
	containertype = "/obj/crate/internals"
	containername = "Emergency Crate"

/datum/supply_packs/party
	name = "Party equipment"
	contains = list("/obj/item/weapon/reagent_containers/food/drinks/beer",
	"/obj/item/weapon/reagent_containers/food/drinks/beer",
	"/obj/item/weapon/reagent_containers/food/drinks/beer",
	"/obj/item/weapon/reagent_containers/food/drinks/beer",
	"/obj/item/weapon/reagent_containers/food/drinks/beer",
	"/obj/item/weapon/reagent_containers/food/drinks/beer",
	"/obj/item/weapon/reagent_containers/food/drinks/beer",
	"/obj/item/weapon/reagent_containers/food/drinks/beer")
	cost = 20
	containertype = "/obj/crate"
	containername = "Party equipment"

/datum/supply_packs/hats
	name = "Clown Gear"
	contains = list("/obj/item/weapon/clownvuvuzela",
	"/obj/item/clothing/head/butt",
	"/obj/item/weapon/bananapeel",
	"/obj/item/weapon/bananapeel",
	"/obj/item/weapon/bikehorn")
	cost = 20
	containertype = "/obj/crate"
	containername = "Clown Gear"


/datum/supply_packs/mule
	name = "MULEbot Crate"
	contains = list("/obj/machinery/bot/mulebot")
	cost = 20
	containertype = "/obj/crate"
	containername = "MULEbot Crate"

/datum/supply_packs/robotics
	name = "Robotics Assembly Crate"
	contains = list("/obj/item/device/prox_sensor",
	"/obj/item/device/prox_sensor",
	"/obj/item/device/prox_sensor",
	"/obj/item/weapon/storage/toolbox/electrical",
	"/obj/item/device/flash",
	"/obj/item/device/flash",
	"/obj/item/device/flash",
	"/obj/item/device/flash",
	"/obj/item/weapon/cell/high",
	"/obj/item/weapon/cell/high")
	cost = 10
	containertype = /obj/crate/secure/gear
	containername = "Robotics Assembly"
	access = access_robotics

/datum/supply_packs/hydroponics // -- Skie
	name = "Hydroponics Supply Crate"
	contains = list("/obj/item/weapon/plantbgone",
	"/obj/item/weapon/plantbgone",
	"/obj/item/weapon/plantbgone",
	"/obj/item/weapon/plantbgone",
	"/obj/item/weapon/weedspray",
	"/obj/item/weapon/weedspray",
	"/obj/item/weapon/pestspray",
	"/obj/item/weapon/pestspray",
	"/obj/item/weapon/minihoe",
	"/obj/item/device/analyzer/plant_analyzer",
	"/obj/item/clothing/gloves/latex",
	"/obj/item/clothing/gloves/latex") // For handling nettles etc
	cost = 10
	containertype = /obj/crate/hydroponics
	containername = "Hydroponics crate"
	access = access_hydroponics

/datum/supply_packs/seeds
	name = "Seeds Crate"
	contains = list("/obj/item/seeds/chiliseed",
	"/obj/item/seeds/berryseed",
	"/obj/item/seeds/eggplantseed",
	"/obj/item/seeds/tomatoseed",
	"/obj/item/seeds/soyaseed",
	"/obj/item/seeds/wheatseed",
	"/obj/item/seeds/carrotseed",
	"/obj/item/seeds/chantermycelium",
	"/obj/item/seeds/cannabisseed",
	"/obj/item/seeds/tobacco",
	"/obj/item/seeds/poppyseed",
	"/obj/item/seeds/potatoseed")
	cost = 10
	containertype = /obj/crate/hydroponics
	containername = "Seeds crate"
	access = access_hydroponics

/*/datum/supply_packs/mecha_ripley
	name = "APLU \"Ripley\" Exosuit Assembly Crate"
	contains = list("/obj/mecha_chassis/ripley",
	"/obj/item/mecha_parts/part/ripley_torso",
	"/obj/item/mecha_parts/part/ripley_left_arm",
	"/obj/item/mecha_parts/part/ripley_right_arm",
	"/obj/item/mecha_parts/part/ripley_left_leg",
	"/obj/item/mecha_parts/part/ripley_right_leg",
	"/obj/item/weapon/disk/circuit_disk/mecha/ripley/main",
	"/obj/item/weapon/disk/circuit_disk/mecha/ripley/peripherals",
	"/obj/item/weapon/book/manual/ripley_build_and_repair")
	cost = 40
	containertype = "/obj/crate/secure"
	containername = "ARLU \"Ripley\" Exosuit Assembly"
	access = access_heads*/

/datum/supply_packs/exoticseeds
	name = "Exotic Seeds Crate"
	contains = list("/obj/item/seeds/nettleseed",
	"/obj/item/seeds/plumpmycelium",
	"/obj/item/seeds/libertymycelium",
	"/obj/item/seeds/amanitamycelium",
	"/obj/item/seeds/eggyseed")
	cost = 15
	containertype = /obj/crate/hydroponics
	containername = "Exotic Seeds crate"
	access = access_hydroponics

/datum/supply_packs/securitybarriers
	name = "Security Barriers"
	contains = list("/obj/machinery/deployable/barrier",
	"/obj/machinery/deployable/barrier",
	"/obj/machinery/deployable/barrier",
	"/obj/machinery/deployable/barrier")
	cost = 20
	containertype = "/obj/crate/secure/gear"
	containername = "Secruity Barriers crate"
	access = access_security


//SUPPLY PACKS