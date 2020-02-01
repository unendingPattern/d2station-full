//Separate dm because it relates to two types of atoms + ease of removal in case it's needed.
//Also assemblies.dm for falsewall checking for this when used.
//I should really make the shuttle wall check run every time it's moved, but centcom uses unsimulated floors so !effort

/atom/proc/relativewall() //atom because it should be useable both for walls and false walls

	var/junction = 0 //will be used to determine from which side the wall is connected to other walls

	if(!istype(src,/turf/simulated/shuttle/wall)) //or else we'd have wacky shuttle merging with walls action
		for(var/turf/simulated/wall/W in orange(src,1))
			if((!istype(W,/turf/simulated/wall/bumpwall_invis)) || (!istype(W,/turf/simulated/wall/bumpwall_vis)) || (!istype(W,/turf/simulated/wall/bumpwall_vis_false)) || (!istype(W,/turf/simulated/wall/r_wall)))
				if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
					junction |= get_dir(src,W)
		for(var/obj/falsewall/W in orange(src,1))
			if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
				junction |= get_dir(src,W)

/* Commenting this out for now until we figure out what to do with shuttle smooth walls, if anything.
   As they are now, they sort of work screwy and may need further coding. Or just be scrapped.*/
	else
		for(var/turf/simulated/shuttle/wall/W in orange(src,1))
			if((!istype(W,/turf/simulated/wall/bumpwall_invis)) || (!istype(W,/turf/simulated/wall/bumpwall_vis)) || (!istype(W,/turf/simulated/wall/bumpwall_vis_false)) || (!istype(W,/turf/simulated/wall/r_wall)))
				if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
					junction |= get_dir(src,W)
		for(var/obj/machinery/shuttle/W in orange(src,1)) //stuff like engine and propulsion should merge with walls
			if(abs(src.x-W.x)-abs(src.y-W.y))
				junction |= get_dir(src,W)
		for(var/obj/machinery/door/W in orange(src,1)) //doors should not result in diagonal walls, it just looks ugly. checking if area is shuttle so it won't merge with the station
			if((abs(src.x-W.x)-abs(src.y-W.y)) && (istype(W.loc.loc,/area/shuttle) || istype(W.loc.loc,/area/supply)))
				junction |= get_dir(src,W)
		for(var/obj/grille/W in orange(src,1)) //same for grilles. checking if area is shuttle so it won't merge with the station
			if((abs(src.x-W.x)-abs(src.y-W.y)) && (istype(W.loc.loc,/area/shuttle) || istype(W.loc.loc,/area/supply)))
				junction |= get_dir(src,W)
/*
	if(istype(src,/turf/simulated/wall/r_wall) || istype(src,/obj/falserwall))
		src.icon_state = "rwall[junction]"
	else if(istype(src,/turf/simulated/wall) || istype(src,/obj/falsewall) || istype(src,/obj/falserwall))
		src.icon_state = "wall[junction]"
	else if(istype(src,/turf/simulated/shuttle/wall))
		if(junction!=5 && junction!=6 && junction!=9 && junction!=10) //if it's not diagonal, all is well, no additional calculations needed
			src.icon_state = "swall[junction]"
		else //if it's diagonal, we need to figure out if we're using the floor diagonal or the space diagonal sprite
			var/is_floor = 0
			for(var/turf/simulated/floor/F in orange(src,1))
				if(abs(src.x-F.x)-abs(src.y-F.y))
					if((15-junction) & get_dir(src,F)) //if there's a floor in at least one of the empty space directions, return 1
						is_floor = 1
			for(var/turf/simulated/shuttle/floor/F in orange(src,1))
				if(abs(src.x-F.x)-abs(src.y-F.y))
					if((15-junction) & get_dir(src,F)) //if there's a floor in at least one of the empty space directions, return 1
						is_floor = 1
			if(is_floor) //if is_floor = 1, we use the floor diagonal sprite
				src.icon_state = "swall_f[junction]"
			else //otherwise, the space one
				src.icon_state = "swall_s[junction]"

	return
*/

/turf/simulated/wall/New()

	for(var/turf/simulated/wall/W in range(src,1))
		if((!istype(W,/turf/simulated/wall/bumpwall_invis)) || (!istype(W,/turf/simulated/wall/bumpwall_vis)) || (!istype(W,/turf/simulated/wall/bumpwall_vis_false)) || (!istype(W,/turf/simulated/wall/r_wall)))
			W.relativewall()

	for(var/obj/falsewall/W in range(src,1))
		W.relativewall()

	..()

/obj/falsewall/New()

	for(var/turf/simulated/wall/W in range(src,1))
		W.relativewall()

	for(var/obj/falsewall/W in range(src,1))
		W.relativewall()

	..()
/*
/turf/simulated/shuttle/wall/New()

	spawn(20) //testing if this will make /obj/machinery/shuttle and /door count - It does, it stays.
		if(src.icon_state in list("wall1", "wall", "diagonalWall", "wall_floor", "wall_space")) //so wizard den, syndie shuttle etc will remain black
			for(var/turf/simulated/shuttle/wall/W in range(src,1))
				W.relativewall()

	..()
*/
/turf/simulated/wall/Del()

	var/temploc = src.loc

	spawn(10)
		for(var/turf/simulated/wall/W in range(temploc,1))
			if((!istype(W,/turf/simulated/wall/bumpwall_invis)) || (!istype(W,/turf/simulated/wall/bumpwall_vis)) || (!istype(W,/turf/simulated/wall/bumpwall_vis_false)) || (!istype(W,/turf/simulated/wall/r_wall)))
				W.relativewall()

		for(var/obj/falsewall/W in range(temploc,1))
			W.relativewall()

	..()

/obj/falsewall/Del()

	var/temploc = src.loc

	spawn(10)
		for(var/turf/simulated/wall/W in range(temploc,1))
			W.relativewall()

		for(var/obj/falsewall/W in range(temploc,1))
			W.relativewall()

	..()
/*
/turf/simulated/shuttle/wall/Del()

	var/temploc = src.loc

	spawn(10)
		for(var/turf/simulated/shuttle/wall/W in range(temploc,1))
			W.relativewall()

	..()
*/