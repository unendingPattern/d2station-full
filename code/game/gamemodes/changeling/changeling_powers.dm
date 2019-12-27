/mob/proc/make_lesser_changeling()
	src.verbs += /client/proc/changeling_lesser_transform
	src.verbs += /client/proc/changeling_fakedeath

//	src.verbs += /client/proc/changeling_blind_sting
//	src.verbs += /client/proc/changeling_deaf_sting
//	src.verbs += /client/proc/changeling_silence_sting

	src.changeling_level = 1
	return

/mob/proc/make_changeling()
	src.verbs += /client/proc/changeling_absorb_dna
	src.verbs += /client/proc/changeling_transform
	src.verbs += /client/proc/changeling_lesser_form
	src.verbs += /client/proc/changeling_fakedeath

//	src.verbs += /client/proc/changeling_deaf_sting
//	src.verbs += /client/proc/changeling_blind_sting
//	src.verbs += /client/proc/changeling_paralysis_sting
//	src.verbs += /client/proc/changeling_silence_sting
//	src.verbs += /client/proc/changeling_transformation_sting
//	src.verbs += /client/proc/changeling_boost_range

	src.changeling_level = 2
	if (!src.absorbed_dna)
		src.absorbed_dna = list()
	if (src.absorbed_dna.len == 0)
		src.absorbed_dna[src.real_name] = src.dna
	return

/mob/proc/make_greater_changeling()
	src.make_changeling()
	//This is a test function for the new changeling powers.  Grants all of them.
	return

/mob/proc/remove_changeling_powers()
	src.verbs -= /client/proc/changeling_absorb_dna
	src.verbs -= /client/proc/changeling_transform
	src.verbs -= /client/proc/changeling_lesser_form
	src.verbs -= /client/proc/changeling_lesser_transform
	src.verbs -= /client/proc/changeling_fakedeath

//	src.verbs -= /client/proc/changeling_deaf_sting
//	src.verbs -= /client/proc/changeling_blind_sting
//	src.verbs -= /client/proc/changeling_paralysis_sting
//	src.verbs -= /client/proc/changeling_silence_sting
//	src.verbs -= /client/proc/changeling_boost_range
//	usr.verbs -= /client/proc/changeling_transformation_sting

/client/proc/changeling_absorb_dna()
	set category = "Changeling"
	set name = "Absorb DNA"

	if(usr.stat)
		usr << "\red Not when we are incapacitated."
		return

	if (!istype(usr.equipped(), /obj/item/weapon/grab))
		usr << "\red We must be grabbing a creature in our active hand to absorb them."
		return

	var/obj/item/weapon/grab/G = usr.equipped()
	var/mob/M = G.affecting

	if (!ishuman(M))
		usr << "\red This creature is not compatible with our biology."
		return

	if (!G.killing)
		usr << "\red We must have a tighter grip to absorb this creature."
		return

	usr.chem_charges += 5

	var/mob/living/carbon/human/T = M

	usr << "\blue This creature is compatible. We must hold still..."

	if (!do_mob(usr, T, 150))
		usr << "\red Our absorption of [T] has been interrupted!"
		return

	usr << "\blue We extend a proboscis."
	usr.visible_message(text("\red <B>[usr] extends a proboscis!</B>"))

	if (!do_mob(usr, T, 150))
		usr << "\red Our absorption of [T] has been interrupted!"
		return

	usr << "\blue We stab [T] with the proboscis."
	usr.visible_message(text("\red <B>[usr] stabs [T] with the proboscis!</B>"))
	T << "\red <B>You feel a sharp stabbing pain!</B>"
	T.take_overall_damage(40)

	if (!do_mob(usr, T, 150))
		usr << "\red Our absorption of [T] has been interrupted!"
		return

	usr << "\blue We have absorbed [T]!"
	usr.visible_message(text("\red <B>[usr] sucks some cells from [T]!</B>"))
	T << "\red <B>You have been infected by the thing!</B>"

	usr.absorbed_dna[T.real_name] = T.dna
	if(usr.nutrition < 400) usr.nutrition = min((usr.nutrition + T.nutrition), 400)
	usr.chem_charges += 5

	T.death(0)

//	T.canmove = 0
//	T.make_changeling()
//	new /obj/decal/cleanable/blood(usr.loc)
//	var/obj/decal/cleanable/blood/B = new /obj/decal/cleanable/blood(usr.loc)
//	var/obj/decal/cleanable/blood/C = new /obj/decal/cleanable/blood(usr.loc)
//	var/obj/decal/cleanable/blood/D = new /obj/decal/cleanable/blood(usr.loc)
//	var/obj/decal/cleanable/blood/E = new /obj/decal/cleanable/blood(usr.loc)
//	step_rand(B)
//	step_rand(C)
//	step_rand(D)
//	step_rand(E)
//	var/atom/movable/overlay/animation = new /atom/movable/overlay( T.loc )
	for(var/obj/item/W in T)
		T.drop_from_slot(W)
	spawn(1)
//	T.loc = animation
//	animation.name = "freaky looking horror"
//	animation.layer = 4
//	animation.icon_state = "thething"
//	animation.icon = 'mob.dmi'
//	animation.master = T
//	src.verbs += /client/proc/changeling_paralysis_sting
//	sleep(380)
//	T.loc = animation.loc
//	new /obj/decal/cleanable/blood(usr.loc)
//	del(animation)
//	T.canmove = 1
//	src.verbs -= /client/proc/changeling_paralysis_sting
	//make blood and ripped clothes
	T.real_name = "Unknown"
	T.mutations |= HUSK
	T.update_body()
	return

/client/proc/changeling_transform()
	set category = "Changeling"
	set name = "Transform (5)"
	if(usr.stat)
		usr << "\red Not when we are incapacitated."
		return

	if (usr.absorbed_dna.len <= 0)
		usr << "\red We have not yet absorbed any compatible DNA."
		return

	if(usr.chem_charges < 5)
		usr << "\red We don't have enough stored chemicals to do that!"
		return

	var/S = input("Select the target DNA: ", "Target DNA", null) in usr.absorbed_dna

	if (S == null)
		return

	usr.chem_charges -= 5

	usr.visible_message(text("\red <B>[usr] transforms!</B>"))
	usr.canmove = 0
	var/atom/movable/overlay/animation = new /atom/movable/overlay( usr.loc )
	for(var/obj/item/W in usr)
		usr.drop_from_slot(W)
	spawn(1)
	usr.loc = animation
	animation.layer = 4
	animation.icon_state = "blank"
	animation.icon = 'mob.dmi'
	animation.master = src
	flick("humantohuman-h", animation)
	sleep(10)
	usr.loc = animation.loc
	new /obj/decal/cleanable/blood(usr.loc)
	del(animation)
	usr.dna = usr.absorbed_dna[S]
	usr.real_name = S
	updateappearance(usr, usr.dna.uni_identity)
	usr.invisibility = null
	domutcheck(usr, null)
	usr.canmove = 1

	usr.verbs -= /client/proc/changeling_transform

	spawn(10)
		usr.verbs += /client/proc/changeling_transform

	return

/client/proc/changeling_lesser_form()
	set category = "Changeling"
	set name = "Lesser Form (1)"

	if(usr.stat)
		usr << "\red Not when we are incapacitated."
		return

	if(usr.chem_charges < 1)
		usr << "\red We don't have enough stored chemicals to do that!"
		return

	usr.chem_charges--

	usr.remove_changeling_powers()

	usr.visible_message(text("\red <B>[usr] transforms!</B>"))

	var/list/implants = list() //Try to preserve implants.
	for(var/obj/item/weapon/W in usr)
		if (istype(W, /obj/item/weapon/implant))
			implants += W

	for(var/obj/item/W in usr)
		usr.drop_from_slot(W)

	usr.update_clothing()
	usr.monkeyizing = 1
	usr.canmove = 0
	usr.icon = null
	usr.invisibility = 101
	var/atom/movable/overlay/animation = new /atom/movable/overlay( usr.loc )
	animation.icon_state = "blank"
	animation.icon = 'mob.dmi'
	animation.master = src
	flick("h2monkey", animation)
	sleep(48)
	del(animation)

	var/mob/living/carbon/monkey/O = new /mob/living/carbon/monkey(src)
	O.dna = usr.dna
	usr.dna = null
	O.absorbed_dna = usr.absorbed_dna

	for(var/obj/T in usr)
		del(T)
	//for(var/R in usr.organs) //redundant, let's give garbage collector work to do --rastaf0
	//	del(usr.organs[text("[]", R)])

	O.loc = usr.loc

	O.name = text("monkey ([])",copytext(md5(usr.real_name), 2, 6))
	O.toxloss = usr.toxloss
	O.bruteloss = usr.bruteloss
	O.oxyloss = usr.oxyloss
	O.fireloss = usr.fireloss
	O.stat = usr.stat
	O.a_intent = "hurt"
	for (var/obj/item/weapon/implant/I in implants)
		I.loc = O
		I.implanted = O
		continue

	if(usr.mind)
		usr.mind.transfer_to(O)

	O.make_lesser_changeling()

	del(usr)
	return

/client/proc/changeling_lesser_transform()
	set category = "Changeling"
	set name = "Transform (1)"

	if(usr.stat)
		usr << "\red Not when we are incapacitated."
		return

	if (usr.absorbed_dna.len <= 0)
		usr << "\red We have not yet absorbed any compatible DNA."
		return

	if(usr.chem_charges < 1)
		usr << "\red We don't have enough stored chemicals to do that!"
		return

	var/S = input("Select the target DNA: ", "Target DNA", null) in usr.absorbed_dna

	if (S == null)
		return

	usr.chem_charges -= 1

	usr.remove_changeling_powers()

	usr.visible_message(text("\red <B>[usr] transforms!</B>"))

	usr.dna = usr.absorbed_dna[S]

	var/list/implants = list()
	for (var/obj/item/weapon/implant/I in usr) //Still preserving implants
		implants += I

	for(var/obj/item/W in usr)
		usr.u_equip(W)
		if (usr.client)
			usr.client.screen -= W
		if (W)
			W.loc = usr.loc
			W.dropped(usr)
			W.layer = initial(W.layer)

	usr.update_clothing()
	usr.monkeyizing = 1
	usr.canmove = 0
	usr.icon = null
	usr.invisibility = 101
	var/atom/movable/overlay/animation = new /atom/movable/overlay( usr.loc )
	animation.icon_state = "blank"
	animation.icon = 'mob.dmi'
	animation.master = src
	flick("monkey2h", animation)
	sleep(48)
	del(animation)

	var/mob/living/carbon/human/O = new /mob/living/carbon/human( src )
	if (isblockon(getblock(usr.dna.uni_identity, 11,3),11))
		O.gender = FEMALE
	else
		O.gender = MALE
	O.dna = usr.dna
	usr.dna = null
	O.absorbed_dna = usr.absorbed_dna
	O.real_name = S

	for(var/obj/T in usr)
		del(T)

	O.loc = usr.loc

	updateappearance(O,O.dna.uni_identity)
	domutcheck(O, null)
	O.toxloss = usr.toxloss
	O.bruteloss = usr.bruteloss
	O.oxyloss = usr.oxyloss
	O.fireloss = usr.fireloss
	O.stat = usr.stat
	for (var/obj/item/weapon/implant/I in implants)
		I.loc = O
		I.implanted = O
		continue

	if(usr.mind)
		usr.mind.transfer_to(O)

	O.make_changeling()

	del(usr)
	return

/client/proc/changeling_fakedeath()
	set category = "Changeling"
	set name = "Regenerative Stasis (20)"

	if(usr.stat == 2)
		usr << "\red We are dead."
		return

	if(usr.chem_charges < 20)
		usr << "\red We don't have enough stored chemicals to do that!"
		return

	usr.chem_charges -= 20

	usr << "\blue We will regenerate our form."

	usr.lying = 1
	usr.canmove = 0
	usr.changeling_fakedeath = 1
	usr.remove_changeling_powers()

	usr.emote("gasp")

	spawn(550)
		if (usr.stat != 2)
			//usr.fireloss = 0
			usr.toxloss = 0
			//usr.bruteloss = 0
			usr.oxyloss = 0
			usr.paralysis = 0
			usr.stunned = 0
			usr.weakened = 0
			usr.radiation = 0
			//usr.health = 100
			//usr.updatehealth()
			var/mob/living/M = src
			M.heal_overall_damage(1000, 1000)
			usr.reagents.clear_reagents()
			usr.lying = 0
			usr.canmove = 1
			usr << "\blue We have regenerated."
			usr.visible_message(text("\red <B>[usr] appears to wake from the dead, having healed all wounds.</B>"))

		usr.changeling_fakedeath = 0
		if (usr.changeling_level == 1)
			usr.make_lesser_changeling()
		else if (usr.changeling_level == 2)
			usr.make_changeling()

	return

/client/proc/changeling_boost_range()
	set category = "Changeling"
	set name = "Ranged Sting (10)"
	set desc="Your next sting ability can be used against targets 3 squares away."

	if(usr.stat)
		usr << "\red Not when we are incapacitated."
		return

	if(usr.chem_charges < 10)
		usr << "\red We don't have enough stored chemicals to do that!"
		return

	usr.chem_charges -= 10

	usr << "\blue Your throat adjusts to launch the sting."
	usr.sting_range = 3

	usr.verbs -= /client/proc/changeling_boost_range

	spawn(5)
		usr.verbs += /client/proc/changeling_boost_range

	return

/client/proc/changeling_silence_sting(mob/T as mob in oview(usr.sting_range))
	set category = "Changeling"
	set name = "Silence sting (10)"
	set desc="Sting target"

	if(usr.stat)
		usr << "\red Not when we are incapacitated."
		return

	if(usr.chem_charges < 10)
		usr << "\red We don't have enough stored chemicals to do that!"
		return

	usr.chem_charges -= 10
	usr.sting_range = 1

	usr << "\blue We stealthily sting [T]."
	T << "You feel a small prick and a burning sensation in your throat."

	T.silent += 30

	usr.verbs -= /client/proc/changeling_silence_sting

	spawn(5)
		usr.verbs += /client/proc/changeling_silence_sting

	return

/client/proc/changeling_blind_sting(mob/T as mob in oview(usr.sting_range))
	set category = "Changeling"
	set name = "Blind sting (20)"
	set desc="Sting target"

	if(usr.stat)
		usr << "\red Not when we are incapacitated."
		return

	if(usr.chem_charges < 20)
		usr << "\red We don't have enough stored chemicals to do that!"
		return

	usr.chem_charges -= 20
	usr.sting_range = 1

	usr << "\blue We stealthily sting [T]."

	var/obj/overlay/B = new /obj/overlay( T.loc )
	B.icon_state = "blspell"
	B.icon = 'wizard.dmi'
	B.name = "spell"
	B.anchored = 1
	B.density = 0
	B.layer = 4
	T.canmove = 0
	spawn(5)
		del(B)
		T.canmove = 1
	T << text("\blue Your eyes cry out in pain!")
	T.disabilities |= 1
	spawn(300)
		T.disabilities &= ~1
	T.eye_blind = 10
	T.eye_blurry = 20

	usr.verbs -= /client/proc/changeling_blind_sting

	spawn(5)
		usr.verbs += /client/proc/changeling_blind_sting

	return

/client/proc/changeling_deaf_sting(mob/T as mob in oview(usr.sting_range))
	set category = "Changeling"
	set name = "Deaf sting (5)"
	set desc="Sting target:"

	if(usr.stat)
		usr << "\red Not when we are incapacitated."
		return

	if(usr.chem_charges < 5)
		usr << "\red We don't have enough stored chemicals to do that!"
		return

	usr.chem_charges -= 5
	usr.sting_range = 1

	usr << "\blue We stealthily sting [T]."

	T.sdisabilities |= 4
	spawn(300)
		T.sdisabilities &= ~4

	usr.verbs -= /client/proc/changeling_deaf_sting

	spawn(5)
		usr.verbs += /client/proc/changeling_deaf_sting

	return

/client/proc/changeling_paralysis_sting(mob/T as mob in oview(usr.sting_range))
	set category = "Changeling"
	set name = "Paralysis sting (30)"
	set desc="Sting target"

	if(usr.stat)
		usr << "\red Not when we are incapacitated."
		return

	if(usr.chem_charges < 30)
		usr << "\red We don't have enough stored chemicals to do that!"
		return

	usr.chem_charges -= 30
	usr.sting_range = 1

	usr << "\blue We stealthily sting [T]."
	T << "You feel a small prick and a burning sensation."

	if (T.reagents)
		T.reagents.add_reagent("zombiepowder", 20)

	usr.verbs -= /client/proc/changeling_paralysis_sting

	spawn(5)
		usr.verbs += /client/proc/changeling_paralysis_sting

	return

/client/proc/changeling_transformation_sting(mob/T as mob in oview(usr.sting_range))
	set category = "Changeling"
	set name = "Transformation sting (30)"
	set desc="Sting target"

	if(usr.stat)
		usr << "\red Not when we are incapacitated."
		return

	if(usr.chem_charges < 30)
		usr << "\red We don't have enough stored chemicals to do that!"
		return

	if(T.stat != 2 || (T.mutations & HUSK) || (!ishuman(T) && !ismonkey(T)))
		usr << "\red We can't transform that target!"
		return

	var/S = input("Select the target DNA: ", "Target DNA", null) in usr.absorbed_dna

	if (S == null)
		return

	usr.chem_charges -= 30
	usr.sting_range = 1

	usr << "\blue We stealthily sting [T]."

	T.visible_message(text("\red <B>[T] transforms!</B>"))

	T.dna = usr.absorbed_dna[S]
	T.real_name = S
	updateappearance(T, T.dna.uni_identity)
	domutcheck(T, null)

	usr.verbs -= /client/proc/changeling_transformation_sting

	spawn(5)
		usr.verbs += /client/proc/changeling_transformation_sting

	return