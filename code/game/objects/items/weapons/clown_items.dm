/*
CONTAINS:
NO MORE BANANA, NOW YOU CAN EAT IT. GO SEE OTHER FOOD STUFFS.
BANANA PEEL
BIKE HORN

*/

/obj/item/weapon/bananapeel/HasEntered(AM as mob|obj)
	if (istype(AM, /mob/living/carbon))
		var/mob/M =	AM
		if (istype(M, /mob/living/carbon/human) && (isobj(M:shoes) && M:shoes.flags&NOSLIP))
			return

		M.pulling = null
		M << "\blue You slipped on the banana peel!"
		playsound(src.loc, 'slip.ogg', 50, 1, -3)
		M.stunned = 8
		M.weakened = 5

/obj/item/weapon/bikehorn/attack_self(mob/user as mob)
	if (spam_flag == 0)
		spam_flag = 1
		playsound(src.loc, 'bikehorn.ogg', 50, 1)
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0
	return

/obj/item/weapon/clownvuvuzela/attack_self(mob/user as mob)
	if (spam_flag == 0)
		spam_flag = 1
		playsound(src.loc, 'AirHorn.ogg', 100, 1)
		for (var/mob/O in viewers(O, null))
			O << "<font color='red' size='7'>HONK</font>"
			O.sleeping = 0
			O.stuttering += 20
			O.ear_deaf += 30
			O.weakened = 3
			if(prob(30))
				O.stunned = 10
				O.paralysis += 4
			else
				O.make_jittery(500)
			spawn(50)
				spam_flag = 0