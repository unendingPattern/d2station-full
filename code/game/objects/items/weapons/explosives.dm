/obj/item/weapon/plastique/attack_self(mob/user as mob)
	var/newtime = input(usr, "Please set the timer.", "Timer", 10)
	src.timer = newtime
	user << "Timer set for [src.timer] seconds."

/obj/item/weapon/plastique/afterattack(atom/target as obj|turf, mob/user as mob, flag)
	if (!flag)
		return
	if (istype(target, /turf/unsimulated) || istype(target, /turf/simulated/shuttle))
		return
	user << "Planting explosives..."
	if(do_after(user, 50) && get_dist(user, target) <= 1)
		user.drop_item()
		src.target = target
		src.loc = null
		var/location
		if (isturf(target)) location = target
		if (isobj(target)) location = target.loc
		target.overlays += image('assemblies.dmi', "plastic-explosive2")
		user << "Bomb has been planted. Timer counting down from [src.timer]."
		spawn(src.timer*10)
			if(target)
				explosion(location, -1, -1, 1, 2)
				if (istype(src.target, /turf/simulated/wall)) src.target:dismantle_wall(1)
				if (istype(src.target, /obj/machinery)) del(src.target)
				else src.target.ex_act(1)
				if (isobj(src.target))
					if (src.target)
						del(src.target)
				if (src)
					del(src)

/obj/item/weapon/plastique/attack(mob/M as mob, mob/user as mob, def_zone)
	return