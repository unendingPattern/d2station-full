/mob/living/carbon/proc/toggle_throw_mode()
	if (src.in_throw_mode)
		throw_mode_off()
	else
		throw_mode_on()

/mob/living/carbon/proc/throw_mode_off()
	src.in_throw_mode = 0
	src.throw_icon.icon_state = "act_throw_off"

/mob/living/carbon/proc/throw_mode_on()
	src.in_throw_mode = 1
	src.throw_icon.icon_state = "act_throw_on"

/mob/living/carbon/proc/throw_item(atom/target)
	src.throw_mode_off()

	if(usr.stat)
		return
	if(target.type == /obj/screen) return

	var/atom/movable/item = src.equipped()

	if(!item) return

	if(istype(item,/obj/item))
		var/obj/item/IT = item
		if(IT.twohanded)
			if(IT.wielded)
				if(hand)
					var/obj/item/weapon/offhand/O = r_hand
					del O
				else
					var/obj/item/weapon/offhand/O = l_hand
					del O
			IT.name = initial(IT.name)


	u_equip(item)
	if(src.client)
		src.client.screen -= item
	item.loc = src.loc

	if (istype(item, /obj/item/weapon/grab))
		item = item:throw() //throw the person instead of the grab

	if(istype(item, /obj/item))
		item:dropped(src) // let it know it's been dropped

	//actually throw it!
	if (item)
		item.layer = initial(item.layer)
		src.visible_message("\red [src] has thrown [item].")

		if(istype(src.loc, /turf/space)) //they're in space, move em one space in the opposite direction
			src.inertia_dir = get_dir(target, src)
			step(src, inertia_dir)
		item.throw_at(target, item.throw_range, item.throw_speed)
		if(src.explodethrow == 1)
			explosion(target, 1, 2, 4, 3)
			//var/location = get_turf(target.my_atom)
			//var/datum/effects/system/reagents_explosion/e = new()
			//e.set_up(round (created_volume/10, 1), location, 0, 0)
			//e.start()



/proc/get_cardinal_step_away(atom/start, atom/finish) //returns the position of a step from start away from finish, in one of the cardinal directions
	//returns only NORTH, SOUTH, EAST, or WEST
	var/dx = finish.x - start.x
	var/dy = finish.y - start.y
	if(abs(dy) > abs (dx)) //slope is above 1:1 (move horizontally in a tie)
		if(dy > 0)
			return get_step(start, SOUTH)
		else
			return get_step(start, NORTH)
	else
		if(dx > 0)
			return get_step(start, WEST)
		else
			return get_step(start, EAST)

/atom/movable/proc/hit_check()
	if(src.throwing)
		for(var/atom/A in get_turf(src))
			if(A == src) continue
			if(istype(A,/mob/living))
				if(A:lying) continue
				src.throw_impact(A)
				src.throwing = 0
			if(isobj(A))
				if(A.density)				// **TODO: Better behaviour for windows
											// which are dense, but shouldn't always stop movement
					src.throw_impact(A)
					src.throwing = 0

/atom/proc/throw_impact(atom/hit_atom)
	if(istype(hit_atom,/mob/living))
		var/mob/living/M = hit_atom
		M.visible_message("\red [hit_atom] has been hit by [src].")
		if(src.vars.Find("throwforce"))
			M.take_organ_damage(src:throwforce)

	else if(isobj(hit_atom))
		var/obj/O = hit_atom
		if(!O.anchored)
			step(O, src.dir)
		O.hitby(src)

	else if(isturf(hit_atom))
		var/turf/T = hit_atom
		if(T.density)
			spawn(2)
				/*if (!istype(src, /obj/item/weapon/throwweapon/)
					step(src, turn(src.dir, 180))*/
				/*if (istype(src, /obj/item/weapon/throwweapon/)
					return
				else
					step(src, turn(src.dir, 180))*/

				step(src, turn(src.dir, 180))

				if (istype(T, /turf/simulated/wall))
					var/tforce = 0
					if(ismob(src))
						tforce = 40
					else
						tforce = src:throwforce
					for(var/mob/O in viewers(T, null))
						O.show_message(text("\red <B>[T] was hit by [src].</B>"), 1)


					playsound(src.loc, 'Genhit.ogg', 100, 1)
					T:health = max(0, T:health - tforce)
					T:update_health()
					..()

			if(istype(src,/mob/living))
				var/mob/living/M = src
				M.take_organ_damage(20)
	if(istype(src, /obj/item/weapon/reagent_containers/food/drinks/drinkingglass) || istype(src, /obj/item/weapon/reagent_containers/glass/large) || istype(src, /obj/item/weapon/reagent_containers/glass/bottle/) || istype(src, /obj/item/weapon/reagent_containers/glass/beaker))
		src:shatter(hit_atom)
	if(istype(src, /obj/item/weapon/melee/baton/))
		src:batonthrow(hit_atom)
	if(istype(src, /obj/item/weapon/reagent_containers/food/snacks/poo))
		src:poo_splat(hit_atom)
	if(istype(src, /obj/item/weapon/grab))
		src:throwperson(hit_atom)


//	if(istype(src, /obj/item/weapon/reagent_containers/food/snacks/grown/tomato))
//		src:tomatosplat(hit_atom)
	if(istype(src, /obj/item/weapon/reagent_containers/food/snacks/egg))
		src:eggsplat(hit_atom)

/*
/turf/simulated/wall/hitby(W as mob|obj)
	for(var/mob/O in viewers(src, null))
		O.show_message(text("\red <B>[src] was hit by [W].</B>"), 1)
	var/tforce = 0
	if(ismob(W))
		tforce = 40
	else
		tforce = W:throwforce
	playsound(src.loc, 'Genhit.ogg', 100, 1)
	src.health = max(0, src.health - tforce)
	update_health()
	..()
	return
*/



/atom/movable/Bump(atom/O)
	if(src.throwing)
		src.throw_impact(O)
		src.throwing = 0
	..()

/atom/movable/proc/throw_at(atom/target, range, speed)
	//use a modified version of Bresenham's algorithm to get from the atom's current position to that of the target
	src.throwing = 1
	if(target)
		var/dist_x = abs(target.x - src.x)
		var/dist_y = abs(target.y - src.y)

		var/dx
		if (target.x > src.x)
			dx = EAST
		else
			dx = WEST

		var/dy
		if (target.y > src.y)
			dy = NORTH
		else
			dy = SOUTH
		var/dist_travelled = 0
		var/dist_since_sleep = 0
		if(dist_x > dist_y)
			var/error = dist_x/2 - dist_y
			while (((((src.x < target.x && dx == EAST) || (src.x > target.x && dx == WEST)) && dist_travelled < range) || istype(src.loc, /turf/space)) && src.throwing && istype(src.loc, /turf))
				// only stop when we've gone the whole distance (or max throw range) and are on a non-space tile, or hit something, or hit the end of the map, or someone picks it up
				if(error < 0)
					var/atom/step = get_step(src, dy)
					if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
						break
					src.Move(step)
					hit_check()
					error += dist_x
					dist_travelled++
					dist_since_sleep++
					if(dist_since_sleep >= speed)
						dist_since_sleep = 0
						sleep(1)
				else
					var/atom/step = get_step(src, dx)
					if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
						break
					src.Move(step)
					hit_check()
					error -= dist_y
					dist_travelled++
					dist_since_sleep++
					if(dist_since_sleep >= speed)
						dist_since_sleep = 0
						sleep(1)
		else
			var/error = dist_y/2 - dist_x
			while (src &&((((src.y < target.y && dy == NORTH) || (src.y > target.y && dy == SOUTH)) && dist_travelled < range) || istype(src.loc, /turf/space)) && src.throwing && istype(src.loc, /turf))
				// only stop when we've gone the whole distance (or max throw range) and are on a non-space tile, or hit something, or hit the end of the map, or someone picks it up
				if(error < 0)
					var/atom/step = get_step(src, dx)
					if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
						break
					src.Move(step)
					hit_check()
					error += dist_y
					dist_travelled++
					dist_since_sleep++
					if(dist_since_sleep >= speed)
						dist_since_sleep = 0
						sleep(1)
				else
					var/atom/step = get_step(src, dy)
					if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
						break
					src.Move(step)
					hit_check()
					error -= dist_x
					dist_travelled++
					dist_since_sleep++
					if(dist_since_sleep >= speed)
						dist_since_sleep = 0
						sleep(1)

	//done throwing, either because it hit something or it finished moving
	src.throwing = 0
	if(isobj(src)) src:throw_impact(get_turf(src))


