
var/global/datum/controller/game_controller/master_controller //Set in world.New()
var/global/controllernum = "no"


datum/controller/game_controller
	var/processing = 1

	proc
		setup()
		setup_objects()
		process()

	setup()
		if(master_controller && (master_controller != src))
			del(src)
			//There can be only one master.

		if(!air_master)
			air_master = new /datum/controller/air_system()
			air_master.setup()

		world.tick_lag = 0.7			//LET'S TURN THIS SHIT DOWN TO 0.1

		setup_objects()

		setupgenetics()

		setupcorpses()

		emergency_shuttle = new /datum/shuttle_controller/emergency_shuttle()

		if(!ticker)
			ticker = new /datum/controller/gameticker()

		spawn
			ticker.pregame()

	setup_objects()
		world << "\red \b Initializing objects"
		sleep(-1)

		for(var/obj/object in world)
			object.initialize()

		world << "\red \b Initializing pipe networks"
		sleep(-1)

		for(var/obj/machinery/atmospherics/machine in world)
			machine.build_network()

		/*world << "\red \b Initializing atmos machinery"
		sleep(-1)

		find_air_alarms()*/

		world << "\red \b Initializations complete."


	process()

		if(!processing)
			return 0
		//world << "Processing"
		controllernum = "yes"
		spawn (100) controllernum = "no"

		var/start_time = world.timeofday

		air_master.process()

		sleep(1)

		sun.calc_position()

		sleep(-1)

		for(var/mob/M in world)
			if (M.metabslow)
				if (air_master.current_cycle%10==1) // For everyone who has their metabolism slowed, make updates not so frequently
					M.Life()
			else
				M.Life()
			if (M && M.mind) //I think it will be better if author place this under mob/Life()
				if (M.mind.special_role == "Changeling")
					M.chem_charges = between(0, (max((0.9 - (M.chem_charges / 50)), 0.1) + M.chem_charges), 50)
		sleep(-1)

		for(var/datum/disease/D in active_diseases)
			D.process()

		for(var/obj/machinery/machine in machines)
			if(machine)
				machine.process()
				if(machine && machine.use_power)
					machine.auto_use_power()

		sleep(-1)
		sleep(1)

		for(var/obj/item/item in processing_items)
			item.process()

		for(var/datum/pipe_network/network in pipe_networks)
			network.process()

		for(var/datum/powernet/P in powernets)
			P.reset()

		sleep(-1)

		ticker.process()

		sleep(world.timeofday+10-start_time)

		spawn process()

		return 1