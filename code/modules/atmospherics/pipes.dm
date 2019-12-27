obj/machinery/atmospherics/pipe

	var/datum/gas_mixture/air_temporary //used when reconstructing a pipeline that broke
	var/datum/pipeline/parent

	var/volume = 0
	var/force = 20

	layer = 2.4 //under wires with their 2.5

	var/alert_pressure = 80*ONE_ATMOSPHERE
		//minimum pressure before check_pressure(...) should be called

	proc/pipeline_expansion()
		return null

	proc/check_pressure(pressure)
		//Return 1 if parent should continue checking other pipes
		//Return null if parent should stop checking other pipes. Recall: del(src) will by default return null

		return 1

	return_air()
		if(!parent)
			parent = new /datum/pipeline()
			parent.build_pipeline(src)

		return parent.air

	build_network()
		if(!parent)
			parent = new /datum/pipeline()
			parent.build_pipeline(src)

		return parent.return_network()

	network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
		if(!parent)
			parent = new /datum/pipeline()
			parent.build_pipeline(src)

		return parent.network_expand(new_network, reference)

	return_network(obj/machinery/atmospherics/reference)
		if(!parent)
			parent = new /datum/pipeline()
			parent.build_pipeline(src)

		return parent.return_network(reference)

	Del()
		del(parent)
		if(air_temporary)
			loc.assume_air(air_temporary)

		..()

	simple
		icon = 'pipes.dmi'
		icon_state = "intact-f"

		name = "pipe"
		desc = "A one meter section of regular pipe"

		volume = 70

		dir = SOUTH
		initialize_directions = SOUTH|NORTH

		var/obj/machinery/atmospherics/node1
		var/obj/machinery/atmospherics/node2

		var/minimum_temperature_difference = 300
		var/thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT

		var/maximum_pressure = 100*ONE_ATMOSPHERE
		var/fatigue_pressure = 75*ONE_ATMOSPHERE
		alert_pressure = 75*ONE_ATMOSPHERE


		level = 1

		New()
			..()
			switch(dir)
				if(SOUTH || NORTH)
					initialize_directions = SOUTH|NORTH
				if(EAST || WEST)
					initialize_directions = EAST|WEST
				if(NORTHEAST)
					initialize_directions = NORTH|EAST
				if(NORTHWEST)
					initialize_directions = NORTH|WEST
				if(SOUTHEAST)
					initialize_directions = SOUTH|EAST
				if(SOUTHWEST)
					initialize_directions = SOUTH|WEST


		hide(var/i)
			if(level == 1 && istype(loc, /turf/simulated))
				invisibility = i ? 101 : 0
			update_icon()

		process()
			if(!parent) //This should cut back on the overhead calling build_network thousands of times per cycle
				..()

			if(!node1)
				parent.mingle_with_turf(loc, volume)
				if(!nodealert)
					//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
					nodealert = 1

			else if(!node2)
				parent.mingle_with_turf(loc, volume)
				if(!nodealert)
					//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
					nodealert = 1
			else if (nodealert)
				nodealert = 0


			else if(parent)
				var/environment_temperature = 0

				if(istype(loc, /turf/simulated/))
					if(loc:blocks_air)
						environment_temperature = loc:temperature
					else
						var/datum/gas_mixture/environment = loc.return_air()
						environment_temperature = environment.temperature

				else
					environment_temperature = loc:temperature

				var/datum/gas_mixture/pipe_air = return_air()

				if(abs(environment_temperature-pipe_air.temperature) > minimum_temperature_difference)
					parent.temperature_interact(loc, volume, thermal_conductivity)

		check_pressure(pressure)
			var/datum/gas_mixture/environment = loc.return_air()

			var/pressure_difference = pressure - environment.return_pressure()

			if(pressure_difference > maximum_pressure)
				burst()

			else if(pressure_difference > fatigue_pressure)
				//TODO: leak to turf, doing pfshhhhh
				if(prob(5))
					burst()

			else return 1

		proc/burst()
			src.visible_message("\red \bold [src] bursts!");
			playsound(src.loc, 'bang.ogg', 25, 1)
			var/datum/effects/system/harmless_smoke_spread/smoke = new
			smoke.set_up(1,0, src.loc, 0)
			smoke.start()
			del(src)

		proc/normalize_dir()
			if(dir==3)
				dir = 1
			else if(dir==12)
				dir = 4

		Del()
			if(node1)
				node1.disconnect(src)
			if(node2)
				node2.disconnect(src)

			..()

		pipeline_expansion()
			return list(node1, node2)

		update_icon()
			if(node1&&node2)
				var/C = ""
				switch(color)
					if ("red") C = "-r"
					if ("blue") C = "-b"
					if ("cyan") C = "-c"
					if ("green") C = "-g"
					if ("yellow") C = "-y"
				icon_state = "intact[C][invisibility ? "-f" : "" ]"

				//var/node1_direction = get_dir(src, node1)
				//var/node2_direction = get_dir(src, node2)

				//dir = node1_direction|node2_direction

			else
			//	if(!node1&&!node2)
					//removed delete
				var/have_node1 = node1?1:0
				var/have_node2 = node2?1:0
				icon_state = "exposed[have_node1][have_node2][invisibility ? "-f" : "" ]"


		initialize()
			normalize_dir()
			var/node1_dir
			var/node2_dir

			for(var/direction in cardinal)
				if(direction&initialize_directions)
					if (!node1_dir)
						node1_dir = direction
					else if (!node2_dir)
						node2_dir = direction

			for(var/obj/machinery/atmospherics/target in get_step(src,node1_dir))
				if(target.initialize_directions & get_dir(target,src))
					node1 = target
					break
			for(var/obj/machinery/atmospherics/target in get_step(src,node2_dir))
				if(target.initialize_directions & get_dir(target,src))
					node2 = target
					break


			var/turf/T = src.loc			// hide if turf is not intact
			hide(T.intact)
			update_icon()
			//update_icon()

		disconnect(obj/machinery/atmospherics/reference)
			if(reference == node1)
				if(istype(node1, /obj/machinery/atmospherics/pipe))
					del(parent)
				node1 = null

			if(reference == node2)
				if(istype(node2, /obj/machinery/atmospherics/pipe))
					del(parent)
				node2 = null

			update_icon()

			return null

	simple/scrubbers
		name="Scrubbers pipe"
		color="red"
		icon_state = ""

	simple/supply
		name="Air supply pipe"
		color="blue"
		icon_state = ""

	simple/general
		name="Pipe"
		icon_state = ""

	simple/oxygen
		name="Oxygen Fuel Line"
		icon_state = "green"
		icon_state = ""

	simple/plasma
		name="Plasma Fuel Line"
		icon_state = "yellow"
		icon_state = ""

	simple/plasma/visible
		level = 2
		icon_state = "intact-y"

	simple/plasma/hidden
		level = 1
		icon_state = "intact-y-f"

	simple/oxygen/visible
		level = 2
		icon_state = "intact-g"

	simple/oxygen/hidden
		level = 1
		icon_state = "intact-g-f"

	simple/scrubbers/visible
		level = 2
		icon_state = "intact-r"

	simple/scrubbers/hidden
		level = 1
		icon_state = "intact-r-f"

	simple/supply/visible
		level = 2
		icon_state = "intact-b"

	simple/supply/hidden
		level = 1
		icon_state = "intact-b-f"

	simple/general/visible
		level = 2
		icon_state = "intact"

	simple/general/hidden
		level = 1
		icon_state = "intact-f"



	simple/insulated
		icon = 'red_pipe.dmi'
		icon_state = "intact"

		minimum_temperature_difference = 70000
		thermal_conductivity = 0
		maximum_pressure = 295000
		fatigue_pressure = 200000
		alert_pressure = 195000

		level = 2


	simple/heat_exchanging/junction
		icon = 'junction.dmi'
		icon_state = "intact"
		level = 2
		minimum_temperature_difference = 300
		thermal_conductivity = 0.1
		New()
			switch(dir)
				if(NORTH)
					initialize_directions = SOUTH
				if(WEST)
					initialize_directions = EAST
				if(SOUTH)
					initialize_directions = NORTH
				if(EAST)
					initialize_directions = WEST

			initialize_directions_he = src.dir

			initialize()
		update_icon()
			if(node1&&node2)
				icon_state = "intact"
			else
				var/have_node1 = node1?1:0
				var/have_node2 = node2?1:0
				icon_state = "exposed[have_node1][have_node2]"
			if(!node1&&!node2)
				if(!node1)
					world << "no node1"
				if(!node1)
					world << "no node2"

		initialize()
			for(var/obj/machinery/atmospherics/target in get_step(src,initialize_directions))
				if(target.initialize_directions & get_dir(target,src))
					node1 = target
					break
			for(var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/target in get_step(src,initialize_directions_he))
				if(target.initialize_directions_he & get_dir(target,src))
					node2 = target
					break

			update_icon()

	simple/heat_exchanging
		icon = 'heat.dmi'
		icon_state = "intact"
		level = 2
		var/initialize_directions_he
		minimum_temperature_difference = 0
		thermal_conductivity = 1
		var/difference = 0
		var/oldtemp = 0
		process()
			..()
			var/datum/gas_mixture/env_air = loc.return_air()
			var/datum/gas_mixture/int_air = return_air()
			if(env_air.temperature != int_air.temperature)
				difference = env_air.temperature - int_air.temperature
				int_air.temperature += (difference*0.5)
			parent.temperature_interact(loc, volume, thermal_conductivity)
			oldtemp = int_air.temperature
		//	world << "[int_air.temperature] += [difference*0.8] (external temp = [env_air.temperature])"

		New()
			processing_items += src
			initialize_directions = 0
			switch(dir)
				if(SOUTH || NORTH)
					initialize_directions_he = SOUTH|NORTH
				if(EAST || WEST)
					initialize_directions_he = EAST|WEST
				if(NORTHEAST)
					initialize_directions_he = NORTH|EAST
				if(NORTHWEST)
					initialize_directions_he = NORTH|WEST
				if(SOUTHEAST)
					initialize_directions_he = SOUTH|EAST
				if(SOUTHWEST)
					initialize_directions_he = SOUTH|WEST
			initialize()

		initialize()
			normalize_dir()
			var/node1_dir
			var/node2_dir

			for(var/direction in cardinal)
				if(direction&initialize_directions_he)
					if (!node1_dir)
						node1_dir = direction
					else if (!node2_dir)
						node2_dir = direction

			for(var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/target in get_step(src,node1_dir))
				if(target.initialize_directions_he & get_dir(target,src))
					node1 = target
					break
			for(var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/target in get_step(src,node2_dir))
				if(target.initialize_directions_he & get_dir(target,src))
					node2 = target
					break

			update_icon()


	tank
		icon = 'pipe_tank.dmi'
		icon_state = "intact"

		name = "Pressure Tank"
		desc = "A large vessel containing pressurized gas."

		volume = 1620 //in liters, 0.9 meters by 0.9 meters by 2 meters

		dir = SOUTH
		initialize_directions = SOUTH
		density = 1

		var/obj/machinery/atmospherics/node1

		New()
			initialize_directions = dir
			..()

		process()
			..()
			if(!node1)
				parent.mingle_with_turf(loc, 200)
				if(!nodealert)
					//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
					nodealert = 1
			else if (nodealert)
				nodealert = 0

		carbon_dioxide
			name = "Pressure Tank (Carbon Dioxide)"

			New()
				air_temporary = new
				air_temporary.volume = volume
				air_temporary.temperature = T20C

				air_temporary.carbon_dioxide = (25*ONE_ATMOSPHERE)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature)

				..()

		toxins
			icon = 'orange_pipe_tank.dmi'
			name = "Pressure Tank (Plasma)"

			New()
				air_temporary = new
				air_temporary.volume = volume
				air_temporary.temperature = T20C

				air_temporary.toxins = (25*ONE_ATMOSPHERE)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature)

				..()

		oxygen_agent_b
			icon = 'red_orange_pipe_tank.dmi'
			name = "Pressure Tank (Oxygen + Plasma)"

			New()
				air_temporary = new
				air_temporary.volume = volume
				air_temporary.temperature = T0C

				var/datum/gas/oxygen_agent_b/trace_gas = new
				trace_gas.moles = (25*ONE_ATMOSPHERE)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature)

				air_temporary.trace_gases += trace_gas

				..()

		oxygen
			icon = 'blue_pipe_tank.dmi'
			name = "Pressure Tank (Oxygen)"

			New()
				air_temporary = new
				air_temporary.volume = volume
				air_temporary.temperature = T20C

				air_temporary.oxygen = (25*ONE_ATMOSPHERE)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature)

				..()

		nitrogen
			icon = 'red_pipe_tank.dmi'
			name = "Pressure Tank (Nitrogen)"

			New()
				air_temporary = new
				air_temporary.volume = volume
				air_temporary.temperature = T20C

				air_temporary.nitrogen = (25*ONE_ATMOSPHERE)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature)

				..()

		air
			icon = 'red_pipe_tank.dmi'
			name = "Pressure Tank (Air)"

			New()
				air_temporary = new
				air_temporary.volume = volume
				air_temporary.temperature = T20C

				air_temporary.oxygen = (25*ONE_ATMOSPHERE*O2STANDARD)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature)
				air_temporary.nitrogen = (25*ONE_ATMOSPHERE*N2STANDARD)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature)

				..()

		Del()
			if(node1)
				node1.disconnect(src)

			..()

		pipeline_expansion()
			return list(node1)

		update_icon()
			if(node1)
				icon_state = "intact"

				dir = get_dir(src, node1)

			else
				icon_state = "exposed"

		initialize()

			var/connect_direction = dir

			for(var/obj/machinery/atmospherics/target in get_step(src,connect_direction))
				if(target.initialize_directions & get_dir(target,src))
					node1 = target
					break

			update_icon()

		disconnect(obj/machinery/atmospherics/reference)
			if(reference == node1)
				if(istype(node1, /obj/machinery/atmospherics/pipe))
					del(parent)
				node1 = null

			update_icon()

			return null

		attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
			if (istype(W, /obj/item/device/analyzer) && get_dist(user, src) <= 1)
				for (var/mob/O in viewers(user, null))
					O << "\red [user] has used the analyzer on \icon[icon]"

				var/pressure = parent.air.return_pressure()
				var/total_moles = parent.air.total_moles()

				user << "\white Results of analysis of \icon[icon]"
				if (total_moles>0)
					var/o2_concentration = parent.air.oxygen/total_moles
					var/n2_concentration = parent.air.nitrogen/total_moles
					var/co2_concentration = parent.air.carbon_dioxide/total_moles
					var/plasma_concentration = parent.air.toxins/total_moles

					var/unknown_concentration =  1-(o2_concentration+n2_concentration+co2_concentration+plasma_concentration)

					user << "\white Pressure: [round(pressure,0.1)] kPa"
					user << "\white Nitrogen: [round(n2_concentration*100)]%"
					user << "\white Oxygen: [round(o2_concentration*100)]%"
					user << "\white CO2: [round(co2_concentration*100)]%"
					user << "\white Plasma: [round(plasma_concentration*100)]%"
					if(unknown_concentration>0.01)
						user << "\red Unknown: [round(unknown_concentration*100)]%"
					user << "\white Temperature: [round(parent.air.temperature-T0C)]&deg;C"
				else
					user << "\white Tank is empty!"

	vent
		icon = 'pipe_vent.dmi'
		icon_state = "intact"

		name = "Vent"
		desc = "A large air vent"

		level = 1

		volume = 250

		dir = SOUTH
		initialize_directions = SOUTH

		var/obj/machinery/atmospherics/node1
		New()
			initialize_directions = dir
			..()

		process()
			..()
			if(parent)
				parent.mingle_with_turf(loc, 250)

			if(!node1)
				if(!nodealert)
					//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
					nodealert = 1
			else if (nodealert)
				nodealert = 0

		Del()
			if(node1)
				node1.disconnect(src)

			..()

		pipeline_expansion()
			return list(node1)

		update_icon()
			if(node1)
				icon_state = "intact"

				dir = get_dir(src, node1)

			else
				icon_state = "exposed"

		initialize()
			var/connect_direction = dir

			for(var/obj/machinery/atmospherics/target in get_step(src,connect_direction))
				if(target.initialize_directions & get_dir(target,src))
					node1 = target
					break

			update_icon()

		disconnect(obj/machinery/atmospherics/reference)
			if(reference == node1)
				if(istype(node1, /obj/machinery/atmospherics/pipe))
					del(parent)
				node1 = null

			update_icon()

			return null

		hide(var/i) //to make the little pipe section invisible, the icon changes.
			if(node1)
				icon_state = "[i == 1 && istype(loc, /turf/simulated) ? "h" : "" ]intact"
				dir = get_dir(src, node1)
			else
				icon_state = "exposed"

	manifold
		icon = 'pipe_manifold.dmi'
		icon_state = "manifold-f"

		name = "pipe manifold"
		desc = "A manifold composed of regular pipes"

		volume = 105

		dir = SOUTH
		initialize_directions = EAST|NORTH|WEST

		var/obj/machinery/atmospherics/node1
		var/obj/machinery/atmospherics/node2
		var/obj/machinery/atmospherics/node3

		level = 1

		New()
			switch(dir)
				if(NORTH)
					initialize_directions = EAST|SOUTH|WEST
				if(SOUTH)
					initialize_directions = WEST|NORTH|EAST
				if(EAST)
					initialize_directions = SOUTH|WEST|NORTH
				if(WEST)
					initialize_directions = NORTH|EAST|SOUTH

			..()



		hide(var/i)
			if(level == 1 && istype(loc, /turf/simulated))
				invisibility = i ? 101 : 0
			update_icon()

		pipeline_expansion()
			return list(node1, node2, node3)

		process()
			..()

			if(!node1)
				parent.mingle_with_turf(loc, 70)
				if(!nodealert)
					//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
					nodealert = 1
			else if(!node2)
				parent.mingle_with_turf(loc, 70)
				if(!nodealert)
					//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
					nodealert = 1
			else if(!node3)
				parent.mingle_with_turf(loc, 70)
				if(!nodealert)
					//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
					nodealert = 1
			else if (nodealert)
				nodealert = 0

		Del()
			if(node1)
				node1.disconnect(src)
			if(node2)
				node2.disconnect(src)
			if(node3)
				node3.disconnect(src)

			..()

		disconnect(obj/machinery/atmospherics/reference)
			if(reference == node1)
				if(istype(node1, /obj/machinery/atmospherics/pipe))
					del(parent)
				node1 = null

			if(reference == node2)
				if(istype(node2, /obj/machinery/atmospherics/pipe))
					del(parent)
				node2 = null

			if(reference == node3)
				if(istype(node3, /obj/machinery/atmospherics/pipe))
					del(parent)
				node3 = null

			update_icon()

			..()

		update_icon()
			if(node1&&node2&&node3)
				var/C = ""
				switch(color)
					if ("red") C = "-r"
					if ("blue") C = "-b"
					if ("cyan") C = "-c"
					if ("green") C = "-g"
					if ("yellow") C = "-y"
				icon_state = "manifold[C][invisibility ? "-f" : ""]"

			else
				var/connected = 0
				var/unconnected = 0
				var/connect_directions = (NORTH|SOUTH|EAST|WEST)&(~dir)

				if(node1)
					connected |= get_dir(src, node1)
				if(node2)
					connected |= get_dir(src, node2)
				if(node3)
					connected |= get_dir(src, node3)

				unconnected = (~connected)&(connect_directions)

				icon_state = "manifold_[connected]_[unconnected]"

				if(!connected)
					del(src)

			return

		initialize()
			var/connect_directions = (NORTH|SOUTH|EAST|WEST)&(~dir)

			for(var/direction in cardinal)
				if(direction&connect_directions)
					for(var/obj/machinery/atmospherics/target in get_step(src,direction))
						if(target.initialize_directions & get_dir(target,src))
							node1 = target
							connect_directions &= ~direction
							break
					if (node1)
						break


			for(var/direction in cardinal)
				if(direction&connect_directions)
					for(var/obj/machinery/atmospherics/target in get_step(src,direction))
						if(target.initialize_directions & get_dir(target,src))
							node2 = target
							connect_directions &= ~direction
							break
					if (node2)
						break


			for(var/direction in cardinal)
				if(direction&connect_directions)
					for(var/obj/machinery/atmospherics/target in get_step(src,direction))
						if(target.initialize_directions & get_dir(target,src))
							node3 = target
							connect_directions &= ~direction
							break
					if (node3)
						break

			var/turf/T = src.loc			// hide if turf is not intact
			hide(T.intact)
			//update_icon()
			update_icon()

	manifold/scrubbers
		name="Scrubbers pipe"
		color="red"
		icon_state = ""

	manifold/oxygen
		name="Oxygen fuel line"
		color="green"
		icon_state = ""

	manifold/plasma
		name="Plasma fuel line"
		color="yellow"
		icon_state = ""

	manifold/supply
		name="Air supply pipe"
		color="blue"
		icon_state = ""

	manifold/general
		name="Air supply pipe"
		color="gray"
		icon_state = ""

	manifold/plasma/visible
		level = 2
		icon_state = "manifold-y"

	manifold/plasma/hidden
		level = 1
		icon_state = "manifold-y-f"

	manifold/oxygen/visible
		level = 2
		icon_state = "manifold-g"

	manifold/oxygen/hidden
		level = 1
		icon_state = "manifold-g-f"

	manifold/scrubbers/visible
		level = 2
		icon_state = "manifold-r"

	manifold/scrubbers/hidden
		level = 1
		icon_state = "manifold-r-f"

	manifold/supply/visible
		level = 2
		icon_state = "manifold-b"

	manifold/supply/hidden
		level = 1
		icon_state = "manifold-b-f"

	manifold/general/visible
		level = 2
		icon_state = "manifold"

	manifold/general/hidden
		level = 1
		icon_state = "manifold-f"

obj/machinery/atmospherics/pipe/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if (istype(src, /obj/machinery/atmospherics/pipe/tank))
		return ..()
	if (istype(src, /obj/machinery/atmospherics/pipe/vent))
		return ..()
	if (!istype(W, /obj/item/weapon/wrench))
		return ..()
	var/turf/T = src.loc
	if (level==1 && isturf(T) && T.intact)
		user << "\red You must remove the plating first."
		return 1
	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
		user << "\red You cannot unwrench this [src], it too exerted due to internal pressure."
		add_fingerprint(user)
		return 1
	playsound(src.loc, 'Ratchet.ogg', 50, 1)
	user << "\blue You begin to unfasten \the [src]..."
	if (do_after(user, 40))
		user.visible_message( \
			"[user] unfastens \the [src].", \
			"\blue You have unfastened \the [src].", \
			"You hear ratchet.")
		new /obj/item/pipe(loc, make_from=src)
		for (var/obj/machinery/meter/meter in T)
			if (meter.target == src)
				new /obj/item/pipe_meter(T)
				del(meter)
		del(src)