/obj/item/weapon
	name = "weapon"
	icon = 'weapons.dmi'
	New()
		..()
		src.pixel_x = rand(-3.0, 3)
		src.pixel_y = rand(-3.0, 3)

/obj/item/weapon/offhand
	name = "Offhand"
	var/linked_weapon_name = ""
	w_class = 5.0
	icon_state = "offhand"
	item_state = "nothing"

/obj/item/weapon/shield
	name = "shield"

/obj/item/weapon/shield/riot
	name = "riot shield"
	desc = "A shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	icon = 'weapons.dmi'
	icon_state = "riot"
	flags = FPRINT | TABLEPASS| CONDUCT
	force = 5.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 4
	w_class = 4.0
	g_amt = 7500
	m_amt = 1000
	origin_tech = "materials=2"

/obj/item/weapon/match
	name = "Match"
	desc = "A simple match stick, used for lighting tobacco"
	icon = 'cigarettes.dmi'
	icon_state = "match_unlit"
	var/lit = 0
	var/smoketime = 5
	w_class = 1.0
	origin_tech = "materials=1"

/obj/item/weapon/storage/matchbox
	name = "Matchbox"
	desc = "A small box of Almost But Not Quite Plasma Premium Matches."
	icon = 'cigarettes.dmi'
	icon_state = "matchbox"
	item_state = "zippo"
	w_class = 1
	flags = ONBELT | TABLEPASS
	var/matchcount = 10
	w_class = 1.0

/obj/item/weapon/rcd
	name = "rapid-construction-device (RCD)"
	desc = "A device used to rapidly build walls/floor."
	icon = 'items.dmi'
	icon_state = "rcd"
	opacity = 0
	density = 0
	anchored = 0.0
	var/matter = 0
	var/working = 0
	var/mode = 1
	var/disabled = 0
	flags = FPRINT | TABLEPASS| CONDUCT
	force = 10.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	m_amt = 50000
	origin_tech = "engineering=4;materials=2"
	var/datum/effects/system/spark_spread/spark_system

/obj/item/weapon/rsf
	name = "Rapid-Service-Fabricator (RSF)"
	desc = "A device used to rapidly deploy service items."
	icon = 'items.dmi'
	icon_state = "rcd"
	opacity = 0
	density = 0
	anchored = 0.0
	var/matter = 0
	var/mode = 1
	flags = TABLEPASS
	w_class = 3.0

/obj/item/weapon/rcd_ammo
	name = "Compressed matter cartridge"
	desc = "Highly compressed matter for the RCD."
	icon = 'ammo.dmi'
	icon_state = "rcd"
	item_state = "rcdammo"
	opacity = 0
	density = 0
	anchored = 0.0
	origin_tech = "materials=2"
	m_amt = 30000
	g_amt = 15000



/obj/item/weapon/money
	name = "Space Cash"
	desc = "You can probably deposit this in the ATM!"
	icon = 'spacecash.dmi'
	icon_state = "5"
	opacity = 0
	density = 0
	anchored = 0.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 1
	throw_range = 2
	w_class = 1.0
	var/value = 0
	var/currency
	var/split = 5
	var/round = 0.01


/obj/item/weapon/money/proc/updatedesc()
	name = "[currency]"
	desc = "A pile of [currency][value]"

//	someone fix this pls -erika


	if(value >= 0 && value < 1)
		icon_state = "0"
	else if(value >= 1 && value < 2)
		icon_state = "1"
	else if(value >= 2 && value < 4)
		icon_state = "2"
	else if(value >= 5 && value < 9)
		icon_state = "5"
	else if(value >= 10 && value < 19)
		icon_state = "10"
	else if(value >= 20 && value < 49)
		icon_state = "20"
	else if(value >= 50 && value < 99)
		icon_state = "50"
	else if(value >= 100 && value < 199)
		icon_state = "100"
	else if(value >= 200 && value < 499)
		icon_state = "200"
	else if(value >= 500 && value < 999)
		icon_state = "500"
	else if(value >= 1000)
		icon_state = "1000"


/obj/item/weapon/money/New(var/nloc, var/nvalue=10,var/ncurrency  = "Space Cash")
	if(!value)
		value = nvalue
	if(!currency)
		currency = ncurrency
	split = round(value/2,round)
	updatedesc()
	return ..(nloc)

/*
/obj/item/weapon/money/attack_self(var/mob/user)
	interact(user)

/obj/item/weapon/money/proc/interact(var/mob/user)
	user.machine = src

	var/dat

	dat += "<BR>[value] [currency]"
	dat += "<BR>New pile:"

	dat += "<A href='?src=\ref[src];sd=5'>-</a>"
	dat += "<A href='?src=\ref[src];sd=1'>-</a>"
	if(round<=0.1)
		dat += "<A href='?src=\ref[src];sd=0.1'>-</a>"
		if(round<=0.01)
			dat += "<A href='?src=\ref[src];sd=0.01'>-</a>"
	dat += "[split]"
	if(round<=0.01)
		dat += "<A href='?src=\ref[src];su=0.01'>+</a>"
	if(round<=0.1)
		dat += "<A href='?src=\ref[src];su=0.1'>+</a>"
	dat += "<A href='?src=\ref[src];su=1'>+</a>"
	dat += "<A href='?src=\ref[src];su=5'>+</a>"
	dat += "<BR><A href='?src=\ref[src];split=1'>split</a>"


	user << browse(dat, "window=computer;size=400x500")

	onclose(user, "computer")
	return

/obj/item/weapon/money/Topic(href, href_list)
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.machine = src

		if (href_list["su"])
			var/samt = text2num(href_list["su"])
			if(split+samt<value)
				split+=samt
		if (href_list["sd"])
			var/samt = text2num(href_list["sd"])
			if(split-samt>0)
				split-=samt
		if(href_list["split"])
			new type(get_turf(src),split,currency)
			value-=split
			split = round(value/2,round)
			updatedesc()


		src.add_fingerprint(usr)
	src.updateUsrDialog()
	for (var/mob/M in viewers(1, src.loc))
		if (M.client && M.machine == src)
			src.attack_self(M)
	return


/obj/item/weapon/money/attackby(var/obj/I as obj, var/mob/user as mob)
	if(istype(I,/obj/item/weapon/money))
		var/mob/living/carbon/c = user
		if(!uppertext(I:currency)==uppertext(currency))
			c<<"You can't mix currencies!"
			return ..()
		else
			value+=I:value
			c<<"You combine the piles."
			updatedesc()
			del I
	return ..()
*/

/obj/item/weapon/money/pawnbucks
	name = "Pawn Bucks"
	desc = "100% genuine, bonified PAWN BUCKS! Real money not included."
	value = 10
	currency = "Pawn Bucks"

/obj/item/weapon/money/tickets
	name = "Tickets"
	desc = ""
	value = 5
	currency = "Tickets"
	round = 1

/*
/obj/item/weapon/ammo
	name = "ammo"
	icon = 'ammo.dmi'
	var/amount_left = 0.0
	flags = FPRINT | TABLEPASS| CONDUCT
	item_state = "syringe_kit"
	m_amt = 50000
	throwforce = 2
	w_class = 1.0
	throw_speed = 4
	throw_range = 20
	origin_tech = "materials=2;combat=1"

/obj/item/weapon/ammo/a357
	desc = "There are 7 rounds left!"
	name = "ammo-357"
	icon_state = "357-7"
	amount_left = 7.0

/obj/item/weapon/ammo/a45
	desc = "There are 10 rounds left!"
	name = "ammo-45"
	icon_state = "45-10"
	amount_left = 10.0

/obj/item/weapon/ammo/a763m
	desc = "There are 9 rounds left!"
	name = "ammo-7.63x25"
	icon_state = "7.63x25m-9"
	amount_left = 9.0

/obj/item/weapon/ammo/a9x19p
	desc = "There are 8 rounds left!"
	name = "ammo-9x19"
	icon_state = "9x19p-8"
	amount_left = 8.0

/obj/item/weapon/ammo/assaultmag
	desc = "There are 30 rounds left!"
	name = "5.56x45mm NATO"
	icon_state = "5.56"
	amount_left = 30.0

/obj/item/weapon/ammo/shell //easier to add new shell types. Like badmin laser/taser/pulse shells.
	desc = "Generic shell description."
	name = "Generic shell."
	icon_state = "blshell"
	m_amt = 9000
	New()
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/ammo/shell/beanbag
	desc = "A weak beanbag shell."
	name = "beanbag shell"
	icon_state = "bshell"
	m_amt = 10000

/obj/item/weapon/ammo/shell/gauge
	desc = "A 12gauge shell."
	name = "12 gauge shell"
	icon_state = "gshell"
	m_amt = 25000

/obj/item/weapon/ammo/shell/blank
	desc = "A blank shell."
	name = "blank shell"
	icon_state = "blshell"
	m_amt = 500

/obj/item/weapon/ammo/shell/dart
	desc = "A dart for use in shotguns.."
	name = "shotgun dart"
	icon_state = "blshell" //someone, draw the icon, please.
	m_amt = 50000 //because it's like, instakill.


/obj/item/weapon/ammo/a38
	desc = "A speedloader that contains 7 .38 Special rounds."
	name = "38-Special ammo"
	icon_state = "38-7"
	amount_left = 7.0
	m_amt = 10000
*/
/obj/item/device/mass_spectrometer
	desc = "A hand-held mass spectrometer which identifies trace chemicals in a blood sample."
	name = "mass-spectrometer"
	icon_state = "spectrometer"
	item_state = "analyzer"
	w_class = 2.0
	flags = FPRINT | TABLEPASS| CONDUCT | ONBELT | OPENCONTAINER
	throwforce = 5
	throw_speed = 4
	throw_range = 20
	m_amt = 30
	g_amt = 20
	origin_tech = "magnets=2;biotech=2"
	var
		details = 0
		recent_fail = 0

/obj/item/device/mass_spectrometer/adv
	name = "advanced mass-spectrometer"
	icon_state = "adv_spectrometer"
	details = 1
	origin_tech = "magnets=4;biotech=2"

/obj/item/weapon/asteroidcutter
	name = "Asteroid Cutter"
	icon = 'items.dmi'
	icon_state = "asteroidcutter"
	item_state = "acutter"
	desc = "A weldingtool on steroids"
	flags = FPRINT | TABLEPASS| CONDUCT | ONBELT
	force = 3.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	origin_tech = "combat=1;plasmatech=1"
	var/digspeed = 20
	var/processing = 0
	var/operating = 0
	var/lit = 0	//on or off
	var/obj/item/weapon/tank/plasma/loaded = null
	m_amt = 1500
	g_amt = 100

/obj/item/weapon/melee/baton
	name = "Stun Baton"
	desc = "A stun baton for hitting people with."
	icon_state = "stunbaton_active"
	item_state = "baton"
	flags = FPRINT | ONBELT | TABLEPASS
	force = 10
	throwforce = 7
	w_class = 3
	var/charges = 10.0
	var/maximum_charges = 10.0
	var/status = 1
	var/penis = 0
	origin_tech = "combat=2"
	dir = NORTH

/obj/item/weapon/melee/baton/proc/batonthrow(mob/target)
	if(ismob(target))
		if(src.status) // http://www.youtube.com/watch?v=kQvmCzILBfE -Deadsnipe
			if(src.charges >= 5) //was 5- no wait it's 5 again, but meant could only throw stun twice, then rending it into a bashing weapon oppose to a stunning weapon. -Nernums
				playsound(src.loc, 'Egloves.ogg', 50, 1, -1)
				target.weakened += rand(5,15)
				target.stunned += rand(5,15)
			//	target.paralysis += 50
				target << "\red The stun baton hits you! Argh!"
				if(prob(5))
					target << "\red You release your bodily fluids!"
					target.emote(pick("pee","poo","vomit","cum"))
				src.charges -= 5  //Was 5, see above. -Nernums
				for(var/mob/O in viewers(world.view, src))
					if(prob(5))
						O << sound('playball.ogg')



/obj/item/weapon/melee/energy
	var/active = 0

/obj/item/weapon/melee/energy/axe
	name = "Axe"
	desc = "An energised battle axe."
	icon_state = "axe0"
	force = 40.0
	throwforce = 25.0
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	flags = FPRINT | CONDUCT | NOSHIELD | TABLEPASS
	origin_tech = "combat=3"

/obj/item/weapon/melee/energy/sword
	var/color
	name = "energy sword"
	desc = "May the force be within you."
	icon_state = "sword0"
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	flags = FPRINT | TABLEPASS | NOSHIELD
	origin_tech = "magnets=3;syndicate=4"

/obj/item/weapon/melee/energy/sword/chainsword
	color = "chain"
	New()
		return

/obj/item/weapon/melee/energy/sword/pirate
	name = "energy cutlass"
	desc = "Arrrr matey."
	icon_state = "cutlass0"

/obj/item/weapon/melee/energy/blade
	name = "energy blade"
	desc = "A concentrated beam of energy in the shape of a blade. Very stylish... and lethal."
	icon_state = "blade"
	force = 70.0//Normal attacks deal very high damage.
	throwforce = 1//Throwing or dropping the item deletes it.
	throw_speed = 1
	throw_range = 1
	w_class = 4.0//So you can't hide it in your pocket or some such.
	flags = FPRINT | TABLEPASS | NOSHIELD
	var/datum/effects/system/spark_spread/spark_system

/obj/item/weapon/bananapeel
	name = "Banana Peel"
	desc = "A peel from a banana."
	icon = 'items.dmi'
	icon_state = "banana_peel"
	item_state = "banana_peel"
	w_class = 1.0
	throwforce = 0
	throw_speed = 4
	throw_range = 20

/obj/item/weapon/soap
	name = "Soap"
	desc = "A cheap bar of soap. Doesn't smell."
	icon = 'items.dmi'
	icon_state = "soap"
	w_class = 1.0
	throwforce = 0
	throw_speed = 4
	throw_range = 20

/obj/item/weapon/soap/nanotrasen
	desc = "A Nanotrasen brand bar of soap. Smells of plasma."
	icon_state = "soapnt"

/obj/item/weapon/soap/deluxe
	desc = "A deluxe Waffle Co. brand bar of soap. Smells of comdoms."
	icon_state = "soapdeluxe"

/obj/item/weapon/bedsheet
	name = "bedsheet"
	desc = "Nice, linen, bedsheet. Perfect to put on."
	icon = 'items.dmi'
	icon_state = "sheet"
	layer = 4.0
	item_state = "w_suit"
	throwforce = 1
	w_class = 1.0
	throw_speed = 2
	throw_range = 10

/obj/item/weapon/bikehorn
	name = "Bike Horn"
	desc = "A horn off of a bicycle."
	icon = 'items.dmi'
	icon_state = "bike_horn"
	item_state = "bike_horn"
	throwforce = 3
	w_class = 1.0
	throw_speed = 3
	throw_range = 15
	var/spam_flag = 0

/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'items.dmi'
	amount = 5
	max_amount = 5
	w_class = 1
	throw_speed = 4
	throw_range = 20
	var/heal_brute = 0
	var/heal_burn = 0

/obj/item/stack/medical/bruise_pack
	name = "bruise pack"
	singular_name = "bruise pack"
	desc = "A pack designed to treat blunt-force trauma."
	icon_state = "brutepack"
	heal_brute = 60
	origin_tech = "biotech=1"

/obj/item/stack/medical/ointment
	name = "ointment"
	desc = "Used to treat those nasty burns."
	singular_name = "ointment"
	icon_state = "ointment"
	heal_burn = 40
	origin_tech = "biotech=1"

/obj/item/weapon/c_tube
	name = "cardboard tube"
	desc = "A tube...of cardboard."
	icon = 'items.dmi'
	icon_state = "c_tube"
	throwforce = 1
	w_class = 1.0
	throw_speed = 4
	throw_range = 5

/obj/item/weapon/card
	name = "card"
	desc = "Does card things."
	icon = 'card.dmi'
	w_class = 1.0

	var/list/files = list(  )

/obj/item/weapon/card/data
	name = "data disk"
	desc = "A disk of data."
	icon_state = "data"
	var/function = "storage"
	var/data = "null"
	var/special = null
	item_state = "card-id"

/obj/item/weapon/card/data/clown
	name = "Coordinates to Clown Planet"
	icon_state = "data"
	item_state = "card-id"
	layer = 3
	level = 2
	desc = "This card contains coordinates to the fabled Clown Planet. Handle with care."

/obj/item/weapon/card/puzzlechamber/red
	desc = "A red electronic key."
	name = "red keycard"
	icon = 'items.dmi'
	icon_state = "keycard_red"
	item_state = "card-id"

/obj/item/weapon/card/puzzlechamber/green
	desc = "A green electronic key."
	name = "green keycard"
	icon = 'items.dmi'
	icon_state = "keycard_green"
	item_state = "card-id"

/obj/item/weapon/card/puzzlechamber/blue
	desc = "A blue electronic key."
	name = "blue keycard"
	icon = 'items.dmi'
	icon_state = "keycard_blue"
	item_state = "card-id"
	var/money = 0

/obj/item/weapon/card/emag
	desc = "It's a card with a magnetic strip attached to some circuitry."
	name = "cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = "magnets=2;syndicate=2"

/obj/item/weapon/card/id
	name = "identification card"
	icon_state = "id"
	item_state = "card-id"
	var/originalckey = null
	var/pincode = null
	var/access = list()
	var/registered = null
	var/assignment = null
	var/obj/item/weapon/photo/PHOTO = null
	var/money = 0
/obj/item/weapon/card/id/gold
	name = "identification card"
	icon_state = "gold"
	item_state = "gold_id"

/obj/item/weapon/card/id/captains_spare
	name = "Captain's spare ID"
	desc = "The spare ID of the High Lord himself."
	icon_state = "gold"
	item_state = "gold_id"
	registered = "Captain"
	assignment = "Captain"
	New()
		access = get_access("Captain")
		..()

/obj/item/weapon/card/id/syndicate
	name = "agent card"
	desc = "Shhhhh."
	access = list(access_maint_tunnels)
	origin_tech = "syndicate=2"

/obj/item/weapon/card/id/sci
	name = "identification card"
	icon_state = "id_sci"
	item_state = "card-id"

/obj/item/weapon/card/id/gene
	name = "identification card"
	icon_state = "id_gene"
	item_state = "card-id"

/obj/item/weapon/card/id/chem
	name = "identification card"
	icon_state = "id_chem"
	item_state = "card-id"

/obj/item/weapon/card/id/med
	name = "identification card"
	icon_state = "id_med"
	item_state = "card-id"

/obj/item/weapon/card/id/sci
	name = "identification card"
	icon_state = "id_sci"
	item_state = "card-id"

/obj/item/weapon/card/id/viro
	name = "identification card"
	icon_state = "id_viro"
	item_state = "card-id"

/obj/item/weapon/card/id/heatlab
	name = "identification card"
	icon_state = "id_heatlab"
	item_state = "card-id"

/obj/item/weapon/card/id/rd
	name = "identification card"
	icon_state = "id_rd"
	item_state = "card-id"

/obj/item/weapon/card/id/cmo
	name = "identification card"
	icon_state = "id_cmo"
	item_state = "card-id"

/obj/item/weapon/card/id/det
	name = "identification card"
	icon_state = "id_det"
	item_state = "card-id"

/obj/item/weapon/card/id/sec
	name = "identification card"
	icon_state = "id_sec"
	item_state = "card-id"

/obj/item/weapon/card/id/prison/guard
	name = "identification card"
	icon_state = "id_guard"
	item_state = "card-id"

/obj/item/weapon/card/id/prison/guard/afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
	if(!istype(target, /obj/machinery/door/airlock))
		return
	if(istype(target, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/A = target
		if(A.id_tag != "cell")
			return
		if(!A.locked)
			if(!src.density)
				A.close()
				sleep(5)
			A.locked = 1
			A.icon_state = "door_locked"
			user << "\red You lock the cell door"
		else if(A.locked)
			A.locked = 0
			A.icon_state = "door_closed"
			sleep(2)
			A.open()
			user << "\green You unlock the cell door"
/obj/item/weapon/card/id/hos
	name = "identification card"
	icon_state = "id_hos"
	item_state = "card-id"

/obj/item/weapon/card/id/hop
	name = "identification card"
	icon_state = "id_hop"
	item_state = "card-id"

/obj/item/weapon/card/id/ce
	name = "identification card"
	icon_state = "id_ce"
	item_state = "card-id"

/obj/item/weapon/card/id/engie
	name = "identification card"
	icon_state = "id_engie"
	item_state = "card-id"

/obj/item/weapon/card/id/atmos
	name = "identification card"
	icon_state = "id_atmos"
	item_state = "card-id"

/obj/item/weapon/card/id/qm
	name = "identification card"
	icon_state = "id_qm"
	item_state = "card-id"

/obj/item/weapon/card/id/hydro
	name = "identification card"
	icon_state = "id_hydro"
	item_state = "card-id"

/obj/item/weapon/card/id/chaplain
	name = "identification card"
	icon_state = "id_chaplain"
	item_state = "card-id"

/obj/item/weapon/card/id/black
	name = "identification card"
	icon_state = "id_black"
	item_state = "card-id"

/obj/item/weapon/card/id/dkgrey
	name = "identification card"
	icon_state = "id_dkgrey"
	item_state = "card-id"

/obj/item/weapon/card/id/ltgrey
	name = "identification card"
	icon_state = "id_ltgrey"
	item_state = "card-id"

/obj/item/weapon/card/id/white
	name = "identification card"
	icon_state = "id_white"
	item_state = "card-id"

/obj/item/weapon/card/id/blankwhite
	name = "identification card"
	icon_state = "id_blankwhite"
	item_state = "card-id"

/obj/item/weapon/card/id/sanderson
	name = "Paul Sanderson's ID Card (Security Officer)"
	icon_state = "id_sec"
	item_state = "card_id"
	registered = "Paul Sanderson"
	assignment = "Security Officer"
	New()
		access = get_access("Security Officer")
		..()

/obj/item/weapon/card/id/reiley
	name = "Ted Reiley's ID Card (NanoTrasen Engineer)"
	icon_state = "id_engie"
	item_state = "card-id"
	registered = "Ted Reiley"
	assignment = "NanoTrasen Engineer"
	New()
		access = get_access("Station Engineer")
		..()

/obj/item/weapon/card/id/erika
	name = "Erika's Room Key Card"
	icon_state = "key_erika"
	registered = "Erika Treial"

/obj/item/weapon/card/id/rebecca
	name = "Rebecca's Room Key Card"
	icon_state = "key_rebecca"
	registered = "Rebecca Pilcrow"

/obj/item/weapon/card/id/nori
	name = "Nori's Room Key Card"
	icon_state = "key_nori"
	registered = "Nori Taggart"

/obj/item/weapon/card/id/emily
	name = "Emily's Room Key Card"
	icon_state = "key_emily"
	registered = "Emily Guest"

/obj/item/weapon/card/id/centcom
	name = "CentCom ID"
	desc = "An ID straight from Cent. Com."
	icon_state = "centcom"
	registered = "Central Command"
	assignment = "General"
	New()
		access = get_all_centcom_access()
		..()

/obj/item/weapon/spraybottle
	desc = "Facilitates fast dispersal of chemical media!"
	icon = 'janitor.dmi'
	name = "spraybottle"
	icon_state = "cleanerempty"
	item_state = "cleaner"
	flags = ONBELT|TABLEPASS|OPENCONTAINER|FPRINT|USEDELAY
	throwforce = 3
	w_class = 2.0
	throw_speed = 2
	throw_range = 10
	var/main_reagent

/obj/item/weapon/spraybottle/cleaner
	desc = "Space Cleaner!"
	name = "space cleaner"
	icon_state = "cleaner"

/obj/item/weapon/clipboard
	name = "clipboard"
	desc = "Apply paper to this to write better. Can also hold pens."
	icon = 'items.dmi'
	icon_state = "clipboard00"
	var/obj/item/weapon/pen/pen = null
	item_state = "clipboard"
	throwforce = 0
	w_class = 2.0
	throw_speed = 3
	throw_range = 10

/obj/item/weapon/cloaking_device
	name = "cloaking device"
	desc = "Use this to become invisible to the human eyesocket."
	icon = 'device.dmi'
	icon_state = "shield0"
	var/active = 0.0
	flags = FPRINT | TABLEPASS| CONDUCT
	item_state = "electronic"
	throwforce = 10.0
	throw_speed = 2
	throw_range = 10
	w_class = 2.0
	origin_tech = "magnets=3;syndicate=4"

#define MAXCOIL 30
/obj/item/weapon/cable_coil
	name = "cable coil"
	icon = 'power.dmi'
	icon_state = "coil_red"
	var/amount = MAXCOIL
	var/color = "red"
	desc = "A coil of power cable."
	throwforce = 10
	w_class = 2.0
	throw_speed = 2
	throw_range = 5
	flags = TABLEPASS|USEDELAY|FPRINT|CONDUCT
	item_state = "coil_red"


/obj/item/weapon/cable_coil/cut
	item_state = "coil_red2"

/obj/item/weapon/cable_coil/yellow
	color = "yellow"
	icon_state = "coil_yellow"

/obj/item/weapon/cable_coil/pink
	color = "pink"
	icon_state = "coil_pink"

/obj/item/weapon/cable_coil/blue
	color = "blue"
	icon_state = "coil_blue"

/obj/item/weapon/cable_coil/green
	color = "green"
	icon_state = "coil_green"

/obj/item/weapon/crowbar
	name = "crowbar"
	desc = "Used to hit floors"
	icon = 'items.dmi'
	icon_state = "crowbar"
	flags = FPRINT | TABLEPASS| CONDUCT
	force = 5.0
	throwforce = 7.0
	hitsound = 'squish.ogg'
	item_state = "wrench"
	w_class = 2.0
	m_amt = 50
	origin_tech = "engineering=1"

/obj/item/weapon/crowbar/red
	icon = 'items.dmi'
	icon_state = "red_crowbar"

/obj/item/weapon/crowbar/tutorial
	icon = 'tutorial.dmi'
	icon_state = "crowbar"

/obj/item/weapon/crowbar/tutorial/attack_hand(mob/user as mob)
	var/obj/item/weapon/crowbar/tutorial/T = new /obj/item/weapon/crowbar/tutorial (src.loc)
	if (user.hand)
		user.l_hand = T
	else
		user.r_hand = T
	T.loc = user
	T.layer = 20

/obj/item/weapon/crowbar/tutorial/dropped(mob/user as mob)
	spawn(300)
		del(src)

/obj/item/weapon/fireaxe
	icon_state = "fireaxe0"
	name = "Fire axe"
	desc = "Truly, the tool of a madman. Who would possibly think to fight fire with an axe?"
	force = 5
	w_class = 4.0
	twohanded = 1
	hitsound = 'squish.ogg'
	force_unwielded = 5
	force_wielded = 30

/obj/item/weapon/fireaxe/regular
	icon_state = "axe0"
	name = "axe"
	desc = "Truly, the tool of a madman. Who would possibly think to fight trees with an axe?"
	force = 5
	w_class = 4.0

/obj/item/weapon/cane
	name = "cane"
	desc = "A cane used by a true gentlemen. Or a clown."
	icon = 'weapons.dmi'
	icon_state = "cane"
	flags = FPRINT | TABLEPASS| CONDUCT
	force = 5.0
	throwforce = 7.0
	item_state = "cane"
	w_class = 2.0
	m_amt = 50

/obj/item/weapon/cane/browncane
	name = " browncane"
	icon_state = "browncane"

/obj/item/weapon/disk
	name = "disk"
	icon = 'items.dmi'

/obj/item/weapon/disk/nuclear
	name = "Nuclear Authentication Disk"
	desc = "Better keep this safe."
	icon_state = "nucleardisk"
	item_state = "card-id"
	w_class = 1.0

/obj/item/weapon/dummy
	name = "dummy"
	invisibility = 101.0
	anchored = 1.0
	flags = 2.0

/obj/item/weapon/extinguisher
	name = "fire extinguisher"
	desc = "Contains water....dangit..."
	icon = 'items.dmi'
	icon_state = "fire_extinguisher0"
	var/last_use = 1.0
	var/safety = 1
	hitsound = 'smash.ogg'
	flags = FPRINT | USEDELAY | TABLEPASS | CONDUCT | OPENCONTAINER
	throwforce = 10
	w_class = 3.0
	throw_speed = 2
	throw_range = 10
	force = 10.0
	item_state = "fire_extinguisher"
	m_amt = 90

/obj/item/weapon/f_card
	name = "Finger Print Card"
	desc = "Used to take fingerprints."
	icon = 'card.dmi'
	icon_state = "fingerprint0"
	var/amount = 10.0
	item_state = "paper"
	throwforce = 1
	w_class = 1.0
	throw_speed = 3
	throw_range = 5


/obj/item/weapon/fcardholder
	name = "Finger Print Case"
	desc = "Apply finger print card."
	icon = 'items.dmi'
	icon_state = "fcardholder0"
	item_state = "clipboard"


/obj/item/weapon/flashbang //these suck, instead use the chemical versions as they work with mousetraps. /obj/item/weapon/chem_grenade/flashbang -Nernums
	desc = "It is set to detonate in 3 seconds."
	name = "flashbang"
	icon = 'grenade.dmi'
	icon_state = "flashbang"
	var/state = null
	var/det_time = 30.0
	w_class = 2.0
	item_state = "flashbang"
	throw_speed = 4
	throw_range = 20
	flags = FPRINT | TABLEPASS | CONDUCT | ONBELT
	origin_tech = "materials=2;combat=1"

/obj/item/weapon/empgrenade
	desc = "It is set to detonate in 5 seconds."
	name = "emp grenade"
	var/state = null
	var/det_time = 50.0
	w_class = 2.0
	icon = 'device.dmi'
	icon_state = "emp"
	item_state = "emp"
	throw_speed = 4
	throw_range = 20
	flags = FPRINT | TABLEPASS | CONDUCT | ONBELT
	origin_tech = "materials=2;magnets=3"

/obj/item/weapon/flasks
	name = "flask"
	icon = 'Cryogenic2.dmi'
	var/oxygen = 0.0
	var/plasma = 0.0
	var/coolant = 0.0

/obj/item/weapon/flasks/coolant
	name = "light blue flask"
	icon_state = "coolant-c"
	coolant = 1000.0

/obj/item/weapon/flasks/oxygen
	name = "blue flask"
	icon_state = "oxygen-c"
	oxygen = 500.0

/obj/item/weapon/flasks/plasma
	name = "orange flask"
	icon_state = "plasma-c"
	plasma = 500.0


/obj/item/weapon/game_kit
	name = "Gaming Kit"
	icon = 'items.dmi'
	icon_state = "game_kit"
	var/selected = null
	var/board_stat = null
	var/data = ""
	var/base_url = "http://svn.slurm.us/public/spacestation13/misc/game_kit"
	item_state = "sheet-metal"
	w_class = 5.0


/obj/item/weapon/gift
	name = "gift"
	desc = "A wrapped item."
	icon = 'items.dmi'
	icon_state = "gift3"
	var/size = 3.0
	var/obj/item/gift = null
	item_state = "gift"
	w_class = 4.0

/obj/item/weapon/grab
	name = "grab"
	icon = 'screen1.dmi'
	icon_state = "grabbed"
	var/obj/screen/grab/hud1 = null
	var/mob/affecting = null
	var/mob/assailant = null
	var/state = 1.0
	var/killing = 0.0
	var/allow_upgrade = 1.0
	var/last_suffocate = 1.0
	layer = 21
	abstract = 1.0
	item_state = "nothing"
	w_class = 5.0

/obj/item/weapon/grab/proc/throwperson(mob/target)
	var/obj/item/weapon/grab/G
	if(istype(G))
		if(ismob(G.affecting))
			if(ismob(target))
				playsound(src.loc, 'punch1.ogg', 50, 1, -1)
				target.weakened = 5
				target.stunned = 5
				target.paralysis = 5
				var/mob/GA = G.affecting
				target << "\red [GA.name] tumbles into you!"
				GA.paralysis = 5
				GA.stunned = 5
				GA.weakened = 5
				for (var/mob/V in viewers(usr))
					V.show_message("[GA.name] crashes into [target]!", 3)



/*
/obj/item/weapon/gun
	name = "gun"
	icon = 'gun.dmi'
	flags =  FPRINT | TABLEPASS | CONDUCT | ONBELT | USEDELAY
	item_state = "gun"
	m_amt = 2000
	throwforce = 5
	w_class = 2.0
	throw_speed = 4
	throw_range = 10
	origin_tech = "combat=1"

/obj/item/weapon/gun/shotgun
	name = "shotgun"
	icon_state = "shotgun"
	var/shellsmax
	var/shellsunlimited = 0
	var/index
	var/list/shells = list() //this is a list. All craftsmanship is of good quality. At least, it's better than two/eight vars, Uhangi! -- Barhandar //it is, thanks bro --uhangi
	w_class = 4.0 //dammit urist no
	force = 7.0
	flags =  FPRINT | TABLEPASS | CONDUCT | USEDELAY | ONBACK
	var/pumped = 0
	shellsmax = 2
	origin_tech = "combat=2"

/obj/item/weapon/gun/shotgun/combat
	name = "combat shotgun"
	icon_state = "cshotgun"
	w_class = 4.0
	force = 12.0
	flags =  FPRINT | TABLEPASS | CONDUCT | USEDELAY | ONBACK
	shellsmax = 8
	origin_tech = "combat=3"

/obj/item/weapon/gun/energy
	name = "energy"
	var/charges = 10.0
	var/maximum_charges = 10.0
	origin_tech = "combat=2;magnets=2"

/obj/item/weapon/gun/energy/taser_gun
	name = "taser gun"
	icon_state = "taser"
	w_class = 3.0
	item_state = "gun"
	force = 10.0
	throw_speed = 2
	throw_range = 10
	charges = 4
	maximum_charges = 4
	m_amt = 2000
	origin_tech = "combat=2;magnets=2"

/obj/item/weapon/gun/energy/teleport_gun
	name = "teleport gun"
	desc = "A hacked together combination of a taser and a handheld teleportation unit."
	icon_state = "taser"
	w_class = 3.0
	item_state = "gun"
	force = 10.0
	throw_speed = 2
	throw_range = 10
	charges = 4
	maximum_charges = 4
	m_amt = 2000
	var/failchance = 5
	var/obj/item/target = null
	origin_tech = "combat=2;magnets=2;bluespace=3"

/obj/item/weapon/gun/energy/crossbow // Laaazy
	name = "mini energy-crossbow"
	desc = "A weapon favored by many of the syndicates stealth specialists."
	icon_state = "crossbow"
	w_class = 2.0
	item_state = "crossbow"
	force = 4.0
	throw_speed = 2
	throw_range = 10
	charges = 3
	maximum_charges = 3
	m_amt = 2000
	origin_tech = "combat=2;magnets=2;syndicate=2"

/obj/item/weapon/gun/energy/laser_gun
	name = "laser gun"
	icon_state = "laser"
	w_class = 3.0
	throw_speed = 2
	throw_range = 10
	force = 7.0
	m_amt = 2000
	origin_tech = "combat=3;magnets=2"
	var/shot_delay = 0 //used for borg guns, adds that much in deciseconds delay between shots
	var/next_attack = 0 //used for the delay

/obj/item/weapon/gun/energy/laser_gun/captain
	icon_state = "caplaser"
	desc = "This is an antique laser gun. All craftsmanship is of the highest quality. It is decorated with assistant leather and chrome. The object menaces with spikes of energy. On the item is an image of Space Station 13. The station is exploding."
	force = 10
	origin_tech = null

/obj/item/weapon/gun/revolver
	desc = "There are 0 bullets left. Uses 357"
	name = "revolver"
	icon_state = "revolver"
	var/bullets = 0.0
	w_class = 3.0
	throw_speed = 2
	throw_range = 10
	force = 24.0
	m_amt = 2000
	origin_tech = "combat=3;materials=2"

/obj/item/weapon/gun/revolver/mateba
	desc = "There are 0 bullets left. Uses 357"
	name = "revolver"
	icon_state = "mateba"
	origin_tech = "combat=3;materials=2"

/obj/item/weapon/gun/c96
	desc = "There are 0 rounds left. Uses 7.63x25 Mauser"
	name = "c96"
	icon_state = "c96"
	var/obj/item/weapon/ammo/a763m/magazine
	w_class = 3.0
	throw_speed = 2
	throw_range = 10
	force = 12.0
	m_amt = 2000
//	origin_tech = "combat=2;materials=2"

/obj/item/weapon/gun/p08
	desc = "There are 0 rounds left. Uses 9x19 Parabellum"
	name = "p08"
	icon_state = "p08empty"
	var/obj/item/weapon/ammo/a9x19p/magazine
	w_class = 3.0
	throw_speed = 2
	throw_range = 10
	force = 16.0
	m_amt = 2000
//	origin_tech = "combat=2;materials=2"

/obj/item/weapon/gun/glock
	desc = "There are 0 rounds left. Uses .45 ACP"
	name = "glock"
	icon_state = "glock"
	var/obj/item/weapon/ammo/a45/magazine
	w_class = 3.0
	throw_speed = 2
	throw_range = 10
	force = 6.0
	m_amt = 2000
//	origin_tech = "combat=2;materials=2"

/obj/item/weapon/gun/m1911
	desc = "There are 0 rounds left. Uses .45 ACP"
	name = "m1911"
	icon_state = "m1911"
	var/obj/item/weapon/ammo/a45/magazine
	w_class = 3.0
	throw_speed = 2
	throw_range = 10
	force = 14.0
	m_amt = 2000
//	origin_tech = "combat=2;materials=2"

/obj/item/weapon/gun/carbine
	desc = "There are 0 rounds left. Uses 5.56x45mm NATO"
	name = "carbine"
	icon_state = "carbinenomag"
	var/obj/item/weapon/ammo/assaultmag/magazine
	flags =  FPRINT | TABLEPASS | CONDUCT | USEDELAY
	w_class = 4.0
	throw_speed = 2
	throw_range = 10
	force = 6.0
	m_amt = 2000
//	origin_tech = "combat=2;materials=2"

/obj/item/weapon/gun/ak331
	desc = "There are 0 rounds left. Uses 5.56x45mm NATO"
	name = "ak331"
	icon_state = "ak331nomag"
	var/obj/item/weapon/ammo/assaultmag/magazine
	flags =  FPRINT | TABLEPASS | CONDUCT | USEDELAY
	w_class = 4.0
	throw_speed = 2
	throw_range = 10
	force = 18.0
	m_amt = 2000
//	origin_tech = "combat=2;materials=2"

/obj/item/weapon/gun/detectiverevolver
	desc = "A cheap Martian knock-off of a Smith & Wesson Model 10. Uses .38-Special rounds."
	name = ".38 revolver"
	icon_state = "detective"
	var/bullets = 5.0
	w_class = 3.0
	throw_speed = 2
	throw_range = 10
	force = 14.0
	m_amt = 1000
	origin_tech = "combat=2;materials=2"
*/

/obj/item/weapon/hand_tele
	name = "hand tele"
	desc = "A portable item using blue-space technology."
	icon = 'device.dmi'
	icon_state = "hand_tele"
	item_state = "electronic"
	throwforce = 5
	w_class = 2.0
	throw_speed = 3
	throw_range = 5
	m_amt = 10000
	origin_tech = "magnets=1;bluespace=3"

/obj/item/weapon/handcuffs
	name = "handcuffs"
	desc = "Use this to keep prisoners in line."
	icon = 'items.dmi'
	icon_state = "handcuff"
	flags = FPRINT | TABLEPASS | CONDUCT | ONBELT
	throwforce = 5
	w_class = 2.0
	throw_speed = 2
	throw_range = 5
	m_amt = 500
	origin_tech = "materials=1"


/obj/item/weapon/implant
	name = "implant"
	var/implanted = null
	var/mob/imp_in = null
	var/color = "b"

/obj/item/weapon/implant/freedom
	name = "freedom"
	desc = "Use this to escape from those evil Red Shirts."
	var/uses = 1.0
	color = "r"
	var/activation_emote = "chuckle"

/obj/item/weapon/implant/tracking
	name = "tracking"
	desc = "Track with this."
	var/frequency = 1451
	var/id = 1.0

/obj/item/weapon/implant/explosive
	name = "explosive"
	desc = "And boom goes the weasel."

/obj/item/weapon/implant/chem
	name = "chem"

/obj/item/weapon/implant/nukeoperative
	name = "neutralization"
	desc = "Protects Syndicate assets."
	color = "r"

/obj/item/weapon/implant/securityweapons
	name = "security"
	desc = "Grants clearance to stationboard security."

/obj/item/weapon/implant/mercweapons
	name = "mercenary"
	desc = "Grants clearance to mercenary weapons."
	color = "r"

/obj/item/weapon/implantcase
	name = "Glass Case"
	desc = "A case containing an implant."
	icon_state = "implantcase-0"
	var/obj/item/weapon/implant/imp = null
	item_state = "implantcase"
	throw_speed = 1
	throw_range = 5
	w_class = 1.0

/obj/item/weapon/implantcase/tracking
	name = "Glass Case- 'Tracking'"
	desc = "A case containing a tracking implant."
	icon = 'items.dmi'
	icon_state = "implantcase-b"

/obj/item/weapon/implantcase/explosive
	name = "Glass Case- 'Explosive'"
	desc = "A case containing an explosive implant."
	icon = 'items.dmi'
	icon_state = "implantcase-r"

/obj/item/weapon/implantcase/chem
	name = "Glass Case- 'Chem'"
	desc = "A case containing a chemical implant."
	icon = 'items.dmi'
	icon_state = "implantcase-b"

/obj/item/weapon/implantcase/securityweapons
	name = "Glass Case- 'Security'"
	desc = "A case containing a security implant."
	icon = 'items.dmi'
	icon_state = "implantcase-b"

/obj/item/weapon/implantcase/mercweapons
	name = "Glass Case- 'Merc Weapons Unlock'"
	desc = "A case containing an implant."
	icon = 'items.dmi'
	icon_state = "implantcase-r"

/obj/item/weapon/implanter
	name = "implanter"
	icon = 'items.dmi'
	icon_state = "implanter0"
	var/obj/item/weapon/implant/imp = null
	item_state = "syringe_0"
	throw_speed = 1
	throw_range = 5
	w_class = 2.0

/obj/item/weapon/implantpad
	name = "implantpad"
	desc = "Used to modify implants."
	icon = 'items.dmi'
	icon_state = "implantpad-0"
	var/obj/item/weapon/implantcase/case = null
	var/broadcasting = null
	var/listening = 1.0
	item_state = "electronic"
	throw_speed = 1
	throw_range = 5
	w_class = 2.0


/obj/item/weapon/locator
	name = "locator"
	desc = "Used to track those with locater implants."
	icon = 'device.dmi'
	icon_state = "locator"
	var/temp = null
	var/frequency = 1451
	var/broadcasting = null
	var/listening = 1.0
	flags = FPRINT | TABLEPASS| CONDUCT
	w_class = 2.0
	item_state = "electronic"
	throw_speed = 4
	throw_range = 20
	m_amt = 400
	origin_tech = "magnets=1"



/obj/item/weapon/mop
	desc = "The world of janitalia wouldn't be complete without a mop."
	name = "mop"
	icon = 'janitor.dmi'
	icon_state = "mop"
	var/mopping = 0
	var/mopcount = 0
	force = 3.0
	throwforce = 10.0
	throw_speed = 5
	throw_range = 10
	w_class = 3.0
	flags = FPRINT | TABLEPASS

/obj/item/weapon/mop/shammy
	desc = "Can hold twenty times its weight in liquid!"
	icon_state = "shamwow"
	force = 1.0
	throwforce = 3.0
	w_class = 1.0

/obj/item/weapon/caution
	desc = "Caution! Wet Floor!"
	name = "wet floor sign"
	icon = 'janitor.dmi'
	icon_state = "caution"
	force = 1.0
	throwforce = 3.0
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	flags = FPRINT | TABLEPASS


/obj/item/weapon/paint
	name = "Paint Can"
	desc = "Used to recolor floors and walls. Can not be removed by the janitor."
	icon = 'items.dmi'
	icon_state = "paint_neutral"
	var/color = "neutral"
	item_state = "paintcan"
	w_class = 3.0

/obj/item/weapon/paper
	name = "Paper"
	desc = "It is made from wood."
	icon = 'items.dmi'
	icon_state = "paper"
	var/info = null
	throwforce = 0
	w_class = 1.0
	throw_speed = 3
	throw_range = 15
	layer = 4
	var/list/stamped
	var/see_face = 1
	var/body_parts_covered = HEAD
	var/protective_temperature = T0C + 10
	var/heat_transfer_coefficient = 0.99
	var/gas_transfer_coefficient = 1
	var/permeability_coefficient = 0.99
	var/siemens_coefficient = 0.80

/obj/item/weapon/directions
	name = "Crumpled Paper"
	desc = "This is a crumpled piece fo paper."
	icon = 'weapons.dmi'
	icon_state = "crumpled"
	throwforce = 0
	w_class = 1.0
	throw_speed = 3
	throw_range = 15
	//layer = 4

/obj/item/weapon/paper/Captains_log
	name = "paper- 'Last Captains log; for anyone who finds this'"
	info = "<b>Captains log:</b> Final Entry<BR><BR>The station was sent off course by a meteor hit to atmospherics and science. I've ordered all hands to abandon the station, we're trying to take anything of value but some sections are too damaged to enter. last I heard from engineering was that they'd repaired damage in the core, but power failed before a more detailed report was filed.<br>I worry for the safety of my crew; We've lost so many already, and rescue is days away, My only hope right now is that the ISE Event Horizon can reach us, as the ship was reported much closer to us than Centcom rescue crafts..If you've found this, and you're still on board after the evacuation, then there are some air canisters reportedly undamaged in Toxins Storage. There was reports of the singularity and station power net being remarkably undamaged if you need to regain power. There will also likely be a lot of supply crates, as any rescue will want to get out of this asteroid field. Do not attempt to open sealed fire doors, some of my fallen and heroic crew closed those doors, sacrificing themselves for the station they are likely to be the only thing keeping the station from being totally ripped apart<BR><br>Report Ends<BR>Captain Morris Branson, Nanotransen.<BR>"


/obj/item/weapon/paper/Internal
	name = "paper- 'Internal Atmosphere Operating Instructions'"
	info = "Equipment:<BR>\n\t1+ Tank(s) with appropriate atmosphere<BR>\n\t1 Gas Mask w regulator (standard issue)<BR>\n<BR>\nProcedure:<BR>\n\t1. Wear mask<BR>\n\t2. Attach oxygen tank pipe to regulater (automatic))<BR>\n\t3. Set internal!<BR>\n<BR>\nNotes:<BR>\n\tDon't forget to stop internal when tank is low by<BR>\n\tremoving internal!<BR>\n<BR>\n\tDo not use a tank that has a high concentration of toxins.<BR>\n\tThe filters shut down on internal mode!<BR>\n<BR>\n\tWhen exiting a high danger environment it is advised<BR>\n\tthat you exit through a decontamination zone!<BR>\n<BR>\n\tRefill a tank at a oxygen canister by equiping the tank (Double Click)<BR>\n\tthen 'attacking' the canister (Double Click the canister)."

/obj/item/weapon/paper/Court
	name = "paper- 'Judgement'"
	info = "For crimes against the station, the offender is sentenced to:<BR>\n<BR>\n"

/obj/item/weapon/paper/Map
	name = "paper- 'Station Blueprint'"
	var/map_graphic = 'map.png'
	info = {"<IMG SRC="ss13mapd.png">
<BR>
CQ: Crew Quarters<BR>
L: Lounge<BR>
CH: Chapel<BR>
ENG: Engine Area<BR>
EC: Engine Control<BR>
ES: Engine Storage<BR>
GR: Generator Room<BR>
MB: Medical Bay<BR>
MR: Medical Research<BR>
TR: Toxin Research<BR>
TS: Toxin Storage<BR>
AC: Atmospheric Control<BR>
SEC: Security<BR>
SB: Shuttle Bay
SA: Shuttle Airlock<BR>
S: Storage<BR>
CR: Control Room<BR>
EV: EVA Storage<BR>
AE: Aux. Engine<BR>
P: Podbay<BR>
NA: North Airlock<BR>
SC: Solar Control<BR>
ASC: Aux. Solar Control<BR>
"}

/obj/item/weapon/paper/Toxin
	name = "paper- 'Chemical Information'"
	info = "Known Onboard Toxins:<BR>\n\tGrade A Semi-Liquid Plasma:<BR>\n\t\tHighly poisonous. You cannot sustain concentrations above 15 units.<BR>\n\t\tA gas mask fails to filter plasma after 50 units.<BR>\n\t\tWill attempt to diffuse like a gas.<BR>\n\t\tFiltered by scrubbers.<BR>\n\t\tThere is a bottled version which is very different<BR>\n\t\t\tfrom the version found in canisters!<BR>\n<BR>\n\t\tWARNING: Highly Flammable. Keep away from heat sources<BR>\n\t\texcept in a enclosed fire area!<BR>\n\t\tWARNING: It is a crime to use this without authorization.<BR>\nKnown Onboard Anti-Toxin:<BR>\n\tAnti-Toxin Type 01P: Works against Grade A Plasma.<BR>\n\t\tBest if injected directly into bloodstream.<BR>\n\t\tA full injection is in every regular Med-Kit.<BR>\n\t\tSpecial toxin Kits hold around 7.<BR>\n<BR>\nKnown Onboard Chemicals (other):<BR>\n\tRejuvenation T#001:<BR>\n\t\tEven 1 unit injected directly into the bloodstream<BR>\n\t\t\twill cure paralysis and sleep toxins.<BR>\n\t\tIf administered to a dying patient it will prevent<BR>\n\t\t\tfurther damage for about units*3 seconds.<BR>\n\t\t\tit will not cure them or allow them to be cured.<BR>\n\t\tIt can be administeredd to a non-dying patient<BR>\n\t\t\tbut the chemicals disappear just as fast.<BR>\n\tSleep Toxin T#054:<BR>\n\t\t5 units wilkl induce precisely 1 minute of sleep.<BR>\n\t\t\tThe effects are cumulative.<BR>\n\t\tWARNING: It is a crime to use this without authorization"

/obj/item/weapon/paper/courtroom
	name = "paper- 'A Crash Course in Legal SOP on SS13'"
	info = "<B>Roles:</B><BR>\nThe Detective is basically the investigator and prosecutor.<BR>\nThe Staff Assistant can perform these functions with written authority from the Detective.<BR>\nThe Captain/HoP/Warden is ct as the judicial authority.<BR>\nThe Security Officers are responsible for executing warrants, security during trial, and prisoner transport.<BR>\n<BR>\n<B>Investigative Phase:</B><BR>\nAfter the crime has been committed the Detective's job is to gather evidence and try to ascertain not only who did it but what happened. He must take special care to catalogue everything and don't leave anything out. Write out all the evidence on paper. Make sure you take an appropriate number of fingerprints. IF he must ask someone questions he has permission to confront them. If the person refuses he can ask a judicial authority to write a subpoena for questioning. If again he fails to respond then that person is to be jailed as insubordinate and obstructing justice. Said person will be released after he cooperates.<BR>\n<BR>\nONCE the FT has a clear idea as to who the criminal is he is to write an arrest warrant on the piece of paper. IT MUST LIST THE CHARGES. The FT is to then go to the judicial authority and explain a small version of his case. If the case is moderately acceptable the authority should sign it. Security must then execute said warrant.<BR>\n<BR>\n<B>Pre-Pre-Trial Phase:</B><BR>\nNow a legal representative must be presented to the defendant if said defendant requests one. That person and the defendant are then to be given time to meet (in the jail IS ACCEPTABLE). The defendant and his lawyer are then to be given a copy of all the evidence that will be presented at trial (rewriting it all on paper is fine). THIS IS CALLED THE DISCOVERY PACK. With a few exceptions, THIS IS THE ONLY EVIDENCE BOTH SIDES MAY USE AT TRIAL. IF the prosecution will be seeking the death penalty it MUST be stated at this time. ALSO if the defense will be seeking not guilty by mental defect it must state this at this time to allow ample time for examination.<BR>\nNow at this time each side is to compile a list of witnesses. By default, the defendant is on both lists regardless of anything else. Also the defense and prosecution can compile more evidence beforehand BUT in order for it to be used the evidence MUST also be given to the other side.\nThe defense has time to compile motions against some evidence here.<BR>\n<B>Possible Motions:</B><BR>\n1. <U>Invalidate Evidence-</U> Something with the evidence is wrong and the evidence is to be thrown out. This includes irrelevance or corrupt security.<BR>\n2. <U>Free Movement-</U> Basically the defendant is to be kept uncuffed before and during the trial.<BR>\n3. <U>Subpoena Witness-</U> If the defense presents god reasons for needing a witness but said person fails to cooperate then a subpoena is issued.<BR>\n4. <U>Drop the Charges-</U> Not enough evidence is there for a trial so the charges are to be dropped. The FT CAN RETRY but the judicial authority must carefully reexamine the new evidence.<BR>\n5. <U>Declare Incompetent-</U> Basically the defendant is insane. Once this is granted a medical official is to examine the patient. If he is indeed insane he is to be placed under care of the medical staff until he is deemed competent to stand trial.<BR>\n<BR>\nALL SIDES MOVE TO A COURTROOM<BR>\n<B>Pre-Trial Hearings:</B><BR>\nA judicial authority and the 2 sides are to meet in the trial room. NO ONE ELSE BESIDES A SECURITY DETAIL IS TO BE PRESENT. The defense submits a plea. If the plea is guilty then proceed directly to sentencing phase. Now the sides each present their motions to the judicial authority. He rules on them. Each side can debate each motion. Then the judicial authority gets a list of crew members. He first gets a chance to look at them all and pick out acceptable and available jurors. Those jurors are then called over. Each side can ask a few questions and dismiss jurors they find too biased. HOWEVER before dismissal the judicial authority MUST agree to the reasoning.<BR>\n<BR>\n<B>The Trial:</B><BR>\nThe trial has three phases.<BR>\n1. <B>Opening Arguments</B>- Each side can give a short speech. They may not present ANY evidence.<BR>\n2. <B>Witness Calling/Evidence Presentation</B>- The prosecution goes first and is able to call the witnesses on his approved list in any order. He can recall them if necessary. During the questioning the lawyer may use the evidence in the questions to help prove a point. After every witness the other side has a chance to cross-examine. After both sides are done questioning a witness the prosecution can present another or recall one (even the EXACT same one again!). After prosecution is done the defense can call witnesses. After the initial cases are presented both sides are free to call witnesses on either list.<BR>\nFINALLY once both sides are done calling witnesses we move onto the next phase.<BR>\n3. <B>Closing Arguments</B>- Same as opening.<BR>\nThe jury then deliberates IN PRIVATE. THEY MUST ALL AGREE on a verdict. REMEMBER: They mix between some charges being guilty and others not guilty (IE if you supposedly killed someone with a gun and you unfortunately picked up a gun without authorization then you CAN be found not guilty of murder BUT guilty of possession of illegal weaponry.). Once they have agreed they present their verdict. If unable to reach a verdict and feel they will never they call a deadlocked jury and we restart at Pre-Trial phase with an entirely new set of jurors.<BR>\n<BR>\n<B>Sentencing Phase:</B><BR>\nIf the death penalty was sought (you MUST have gone through a trial for death penalty) then skip to the second part. <BR>\nI. Each side can present more evidence/witnesses in any order. There is NO ban on emotional aspects or anything. The prosecution is to submit a suggested penalty. After all the sides are done then the judicial authority is to give a sentence.<BR>\nII. The jury stays and does the same thing as I. Their sole job is to determine if the death penalty is applicable. If NOT then the judge selects a sentence.<BR>\n<BR>\nTADA you're done. Security then executes the sentence and adds the applicable convictions to the person's record.<BR>\n"

/obj/item/weapon/paper/hydroponics
	name = "paper- 'Greetings from Billy Bob'"
	info = "<B>Hey fellow botanist!</B><BR>\n<BR>\nI didn't trust the station folk so I left<BR>\na couple of weeks ago. But here's some<BR>\ninstructions on how to operate things here.<BR>\nYou can grow plants and each iteration they become<BR>\nstronger, more potent and have better yield, if you<BR>\nknow which ones to pick. Use your botanist's analyzer<BR>\nfor that. You can turn harvested plants into seeds<BR>\nat the seed extractor, and replant them for better stuff!<BR>\nSometimes if the weed level gets high in the tray<BR>\nmutations into different mushroom or weed species have<BR>\nbeen witnessed. On the rare occassion even weeds mutate!<BR>\n<BR>\nEither way, have fun!<BR>\n<BR>\nBest regards,<BR>\nBilly Bob Johnson.<BR>\n<BR>\nPS.<BR>\nHere's a few tips:<BR>\nIn nettles, potency = damage<BR>\nIn amanitas, potency = deadliness + side effects<BR>\nIn Liberty caps, potency = drug power + effects<BR>\nIn chilis, potency = heat<BR>\n<B>Nutrients keep mushrooms alive!</B><BR>\n<B>Water keeps weeds such as nettles alive!</B><BR>\n<B>All other plants need both.</B>"

/obj/item/weapon/paper/flag
	icon_state = "flag_neutral"
	item_state = "paper"
	anchored = 1.0

/obj/item/weapon/paper/jobs
	name = "paper- 'Job Information'"
	info = "Information on all formal jobs that can be assigned on Space Station 13 can be found on this document.<BR>\nThe data will be in the following form.<BR>\nGenerally lower ranking positions come first in this list.<BR>\n<BR>\n<B>Job Name</B>   general access>lab access-engine access-systems access (atmosphere control)<BR>\n\tJob Description<BR>\nJob Duties (in no particular order)<BR>\nTips (where applicable)<BR>\n<BR>\n<B>Research Assistant</B> 1>1-0-0<BR>\n\tThis is probably the lowest level position. Anyone who enters the space station after the initial job\nassignment will automatically receive this position. Access with this is restricted. Head of Personnel should\nappropriate the correct level of assistance.<BR>\n1. Assist the researchers.<BR>\n2. Clean up the labs.<BR>\n3. Prepare materials.<BR>\n<BR>\n<B>Staff Assistant</B> 2>0-0-0<BR>\n\tThis position assists the security officer in his duties. The staff assisstants should primarily br\npatrolling the ship waiting until they are needed to maintain ship safety.\n(Addendum: Updated/Elevated Security Protocols admit issuing of low level weapons to security personnel)<BR>\n1. Patrol ship/Guard key areas<BR>\n2. Assist security officer<BR>\n3. Perform other security duties.<BR>\n<BR>\n<B>Technical Assistant</B> 1>0-0-1<BR>\n\tThis is yet another low level position. The technical assistant helps the engineer and the statian\ntechnician with the upkeep and maintenance of the station. This job is very important because it usually\ngets to be a heavy workload on station technician and these helpers will alleviate that.<BR>\n1. Assist Station technician and Engineers.<BR>\n2. Perform general maintenance of station.<BR>\n3. Prepare materials.<BR>\n<BR>\n<B>Medical Assistant</B> 1>1-0-0<BR>\n\tThis is the fourth position yet it is slightly less common. This position doesn't have much power\noutside of the med bay. Consider this position like a nurse who helps to upkeep medical records and the\nmaterials (filling syringes and checking vitals)<BR>\n1. Assist the medical personnel.<BR>\n2. Update medical files.<BR>\n3. Prepare materials for medical operations.<BR>\n<BR>\n<B>Research Technician</B> 2>3-0-0<BR>\n\tThis job is primarily a step up from research assistant. These people generally do not get their own lab\nbut are more hands on in the experimentation process. At this level they are permitted to work as consultants to\nthe others formally.<BR>\n1. Inform superiors of research.<BR>\n2. Perform research alongside of official researchers.<BR>\n<BR>\n<B>Detective</B> 3>2-0-0<BR>\n\tThis job is in most cases slightly boring at best. Their sole duty is to\nperform investigations of crine scenes and analysis of the crime scene. This\nalleviates SOME of the burden from the security officer. This person's duty\nis to draw conclusions as to what happened and testify in court. Said person\nalso should stroe the evidence ly.<BR>\n1. Perform crime-scene investigations/draw conclusions.<BR>\n2. Store and catalogue evidence properly.<BR>\n3. Testify to superiors/inquieries on findings.<BR>\n<BR>\n<B>Station Technician</B> 2>0-2-3<BR>\n\tPeople assigned to this position must work to make sure all the systems aboard Space Station 13 are operable.\nThey should primarily work in the computer lab and repairing faulty equipment. They should work with the\natmospheric technician.<BR>\n1. Maintain SS13 systems.<BR>\n2. Repair equipment.<BR>\n<BR>\n<B>Atmospheric Technician</B> 3>0-0-4<BR>\n\tThese people should primarily work in the atmospheric control center and lab. They have the very important\njob of maintaining the delicate atmosphere on SS13.<BR>\n1. Maintain atmosphere on SS13<BR>\n2. Research atmospheres on the space station. (safely please!)<BR>\n<BR>\n<B>Engineer</B> 2>1-3-0<BR>\n\tPeople working as this should generally have detailed knowledge as to how the propulsion systems on SS13\nwork. They are one of the few classes that have unrestricted access to the engine area.<BR>\n1. Upkeep the engine.<BR>\n2. Prevent fires in the engine.<BR>\n3. Maintain a safe orbit.<BR>\n<BR>\n<B>Medical Researcher</B> 2>5-0-0<BR>\n\tThis position may need a little clarification. Their duty is to make sure that all experiments are safe and\nto conduct experiments that may help to improve the station. They will be generally idle until a new laboratory\nis constructed.<BR>\n1. Make sure the station is kept safe.<BR>\n2. Research medical properties of materials studied of Space Station 13.<BR>\n<BR>\n<B>Scientist</B> 2>5-0-0<BR>\n\tThese people study the properties, particularly the toxic properties, of materials handled on SS13.\nTechnically they can also be called Plasma Technicians as plasma is the material they routinly handle.<BR>\n1. Research plasma<BR>\n2. Make sure all plasma is properly handled.<BR>\n<BR>\n<B>Medical Doctor (Officer)</B> 2>0-0-0<BR>\n\tPeople working this job should primarily stay in the medical area. They should make sure everyone goes to\nthe medical bay for treatment and examination. Also they should make sure that medical supplies are kept in\norder.<BR>\n1. Heal wounded people.<BR>\n2. Perform examinations of all personnel.<BR>\n3. Moniter usage of medical equipment.<BR>\n<BR>\n<B>Security Officer</B> 3>0-0-0<BR>\n\tThese people should attempt to keep the peace inside the station and make sure the station is kept safe. One\nside duty is to assist in repairing the station. They also work like general maintenance personnel. They are not\ngiven a weapon and must use their own resources.<BR>\n(Addendum: Updated/Elevated Security Protocols admit issuing of weapons to security personnel)<BR>\n1. Maintain order.<BR>\n2. Assist others.<BR>\n3. Repair structural problems.<BR>\n<BR>\n<B>Head of Security</B> 4>5-2-2<BR>\n\tPeople assigned as Head of Security should issue orders to the security staff. They should\nalso carefully moderate the usage of all security equipment. All security matters should be reported to this person.<BR>\n1. Oversee security.<BR>\n2. Assign patrol duties.<BR>\n3. Protect the station and staff.<BR>\n<BR>\n<B>Head of Personnel</B> 4>4-2-2<BR>\n\tPeople assigned as head of personnel will find themselves moderating all actions done by personnel. \nAlso they have the ability to assign jobs and access levels.<BR>\n1. Assign duties.<BR>\n2. Moderate personnel.<BR>\n3. Moderate research. <BR>\n<BR>\n<B>Captain</B> 5>5-5-5 (unrestricted station wide access)<BR>\n\tThis is the highest position youi can aquire on Space Station 13. They are allowed anywhere inside the\nspace station and therefore should protect their ID card. They also have the ability to assign positions\nand access levels. They should not abuse their power.<BR>\n1. Assign all positions on SS13<BR>\n2. Inspect the station for any problems.<BR>\n3. Perform administrative duties.<BR>\n"

/obj/item/weapon/paper/photograph
	name = "photo"
	icon_state = "photo"
	var/photo_id = 0.0
	item_state = "paper"

/obj/item/weapon/paper/sop
	name = "paper- 'Standard Operating Procedure'"
	info = "Alert Levels:<BR>\nBlue- Emergency<BR>\n\t1. Caused by fire<BR>\n\t2. Caused by manual interaction<BR>\n\tAction:<BR>\n\t\tClose all fire doors. These can only be opened by reseting the alarm<BR>\nRed- Ejection/Self Destruct<BR>\n\t1. Caused by module operating computer.<BR>\n\tAction:<BR>\n\t\tAfter the specified time the module will eject completely.<BR>\n<BR>\nEngine Maintenance Instructions:<BR>\n\tShut off ignition systems:<BR>\n\tActivate internal power<BR>\n\tActivate orbital balance matrix<BR>\n\tRemove volatile liquids from area<BR>\n\tWear a fire suit<BR>\n<BR>\n\tAfter<BR>\n\t\tDecontaminate<BR>\n\t\tVisit medical examiner<BR>\n<BR>\nToxin Laboratory Procedure:<BR>\n\tWear a gas mask regardless<BR>\n\tGet an oxygen tank.<BR>\n\tActivate internal atmosphere<BR>\n<BR>\n\tAfter<BR>\n\t\tDecontaminate<BR>\n\t\tVisit medical examiner<BR>\n<BR>\nDisaster Procedure:<BR>\n\tFire:<BR>\n\t\tActivate sector fire alarm.<BR>\n\t\tMove to a safe area.<BR>\n\t\tGet a fire suit<BR>\n\t\tAfter:<BR>\n\t\t\tAssess Damage<BR>\n\t\t\tRepair damages<BR>\n\t\t\tIf needed, Evacuate<BR>\n\tMeteor Shower:<BR>\n\t\tActivate fire alarm<BR>\n\t\tMove to the back of ship<BR>\n\t\tAfter<BR>\n\t\t\tRepair damage<BR>\n\t\t\tIf needed, Evacuate<BR>\n\tAccidental Reentry:<BR>\n\t\tActivate fire alrms in front of ship.<BR>\n\t\tMove volatile matter to a fire proof area!<BR>\n\t\tGet a fire suit.<BR>\n\t\tStay secure until an emergency ship arrives.<BR>\n<BR>\n\t\tIf ship does not arrive-<BR>\n\t\t\tEvacuate to a nearby safe area!"

/obj/item/weapon/paper/engine
	name = "paper- 'Generator Startup Procedure'"
	info = {"<B>Thermo-Electric Generator Startup Procedure for Mark I Plasma-Fired Engines</B>
<HR>
<i>Warning!</i> Improper engine and generator operation may cause exposure to hazardous gasses, extremes of heat and cold, and dangerous electrical voltages.<BR>
Only trained personnel should operate station systems. Follow all procedures carefully. Wear correct personal protective equipment at all times.<BR>
Refer to your supervisor or Head of Personnel for procedure updates and additional information.
<HR>
Standard checklist for engine and generator cold-start.<BR>
<ol>
<li>Perform visual inspection of external (cooling) and internal (heating) heat-exchange pipe loops.
Refer any breaks or cracks in the pipe to Station Maintenance for repair before continuing.
<li>Connect a CO<sub>2</sub> canister to the external (cooling) loop connector, and release the contents. Check loop pressurization is stable.<BR>
<i>Note:</i> Observe standard canister safety procedures.<BR>
<i>Note:</i> Other gasses may be substituted as a medium in the external (cooling) loop in the event that CO<sub>2</sub> is not available.
<li>Connect a CO<sub>2</sub> canister to the internal (heating) loop connector, and release the contents. Check loop pressurization is stable.<BR>
<i>Note:</i> Observe standard canister safety procedures.<BR>
<i>Note:</i> Nitrogen may be substituted as a medium in the internal (heating) loop in the event that CO<sub>2</sub> is not available.
<i>Do not use plasma in the internal (heating) pipe loop as an unsafe condition may result.</i>
<li>Using the thermo-electric generator (TEG) master control panel, engage the internal and external loop circulator pumps at 1% maximum rate.<BR>
<li>Ignite the engine. Refer to document NTRSN-113-H9-12939 for proper engine preparation, ignition, and plasma-oxygen loading procedures.<BR>
<i>Note:</i> Exceeding recommended plasma-oxygen concentrations can cause engine damage and potential hazards.
<li>Monitor engine temperatures until stable operation is achieved.
<li>Increase internal and external circulator pumps to 10% of maximum rate. Monitor the generated power output on the TEG control panel.<BR>
<i>Note:</i> Consult appendix A for expected electrical generation rates.
<li>Adjust circulator rates until required electrical demand is met.<BR>
<i>Note:</i> Generation rate varies with internal and external loop temperatures, exchange media pressure, and engine geometry. Refer to Appendix B or your supervisor for locally determined optimal settings.<BR>
<i>Note:</i> Do not exceed safety ratings for station power cabling and electrical equipment.
<li>With the power generation rate stable, engage charging of the superconducting magnetic energy storage (SMES) devices.
Total SMES charging rate should not exceed total power generation rate, or an overload condition may occur.
"}

/obj/item/weapon/paper_bin
	name = "Paper Bin"
	desc = "This contains many papers."
	icon = 'items.dmi'
	icon_state = "paper_bin1"
	var/amount = 30.0
	item_state = "sheet-metal"
	throwforce = 1
	w_class = 3.0
	throw_speed = 3
	throw_range = 7

/obj/item/weapon/pen
	desc = "It's a normal black ink pen."
	name = "pen"
	icon = 'items.dmi'
	icon_state = "pen"
	flags = FPRINT | ONBELT | TABLEPASS
	throwforce = 0
	w_class = 1.0
	throw_speed = 7
	throw_range = 15
	m_amt = 10
	hitsound = 'squish.ogg'
	var/text_size = 2
	var/text_color = "#000000"
	var/text_bold = 0
	var/text_italic = 0
	var/text_underline = 0
	var/text_break = 0

/obj/item/weapon/banhammer
	desc = "A banhammer"
	name = "Banhammer"
	icon = 'items.dmi'
	icon_state = "toyhammer"
	flags = FPRINT | ONBELT | TABLEPASS
	throwforce = 0
	w_class = 1.0
	throw_speed = 7
	throw_range = 15

/obj/item/weapon/pen/sleepypen
	desc = "It's a normal black ink pen with a sharp point."
	flags = FPRINT | ONBELT | TABLEPASS | OPENCONTAINER
	origin_tech = "materials=2;biotech=1;syndicate=5"

/obj/item/weapon/rack_parts
	name = "rack parts"
	desc = "Parts of a rack."
	icon = 'items.dmi'
	icon_state = "rack_parts"
	flags = FPRINT | TABLEPASS| CONDUCT
	m_amt = 3750

/obj/item/weapon/rubber_chicken
	name = "Rubber Chicken"
	desc = "A rubber chicken, isn't that hilarious?"
	icon = 'items.dmi'
	icon_state = "rubber_chicken"
	item_state = "rubber_chicken"
	w_class = 2.0

/obj/item/weapon/screwdriver
	name = "screwdriver"
	desc = "You can be totally screwwy with this."
	icon = 'items.dmi'
	icon_state = "screwdriver"
	flags = FPRINT | TABLEPASS| CONDUCT
	force = 5.0
	w_class = 1.0
	hitsound = 'fleshstab.ogg'
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5

/obj/item/weapon/shard
	name = "shard"
	icon = 'shards.dmi'
	icon_state = "large"
	desc = "Could probably be used as ... a throwing weapon?"
	w_class = 3.0
	force = 5.0
	throwforce = 15.0
	item_state = "shard-glass"
	g_amt = 3750
	hitsound = 'squish.ogg'

/obj/item/weapon/syndicate_uplink
	name = "station bounced radio"
	desc = "Remain silent about this..."
	icon = 'radio.dmi'
	icon_state = "radio"
	var/temp = null
	var/uses = 10.0
	var/selfdestruct = 0.0
	var/traitor_frequency = 0.0
	var/mob/currentUser = null
	var/obj/item/device/radio/origradio = null
	flags = FPRINT | TABLEPASS | CONDUCT | ONBELT
	w_class = 2.0
	item_state = "radio"
	throw_speed = 4
	throw_range = 20
	m_amt = 100
	origin_tech = "magnets=2;syndicate=3"

/obj/item/weapon/SWF_uplink
	name = "station bounced radio"
	desc = "used to comunicate it appears."
	icon = 'radio.dmi'
	icon_state = "radio"
	var/temp = null
	var/uses = 4.0
	var/selfdestruct = 0.0
	var/traitor_frequency = 0.0
	var/obj/item/device/radio/origradio = null
	flags = FPRINT | TABLEPASS| CONDUCT | ONBELT
	item_state = "radio"
	throwforce = 5
	w_class = 2.0
	throw_speed = 4
	throw_range = 20
	m_amt = 100
	origin_tech = "magnets=1"

/obj/item/weapon/spellbook
	name = "Spell Book"
	desc = "The legendary book of spells of the wizard."
	icon = 'library.dmi'
	icon_state ="book"
	throw_speed = 1
	throw_range = 5
	w_class = 1.0
	flags = FPRINT | TABLEPASS
	var/uses = 4.0
	var/temp = null
	var/spell_type = "verb"
	var/max_uses = 5

/obj/item/weapon/spellbook/object_type_spells //used for giving out object spells as opposed to verb spells
	spell_type = "object"

/obj/item/weapon/staff
	name = "wizards staff"
	desc = "Apparently a staff used by the wizard."
	icon = 'wizard.dmi'
	icon_state = "staff"
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	flags = FPRINT | TABLEPASS | NOSHIELD


/obj/item/weapon/staff/stick
	name = "stick"
	desc = "A great tool to drag someone else's drinks across the bar."
	icon = 'weapons.dmi'
	icon_state = "stick"
	item_state = "stick"
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	flags = FPRINT | TABLEPASS | NOSHIELD

/obj/item/weapon/table_parts
	name = "table parts"
	desc = "Parts of a table. Poor table."
	icon = 'items.dmi'
	icon_state = "table_parts"
	m_amt = 3750
	flags = FPRINT | TABLEPASS| CONDUCT

/obj/item/weapon/table_parts/reinforced
	name = "reinforced table parts"
	desc = "Hard table parts. Well...harder..."
	icon = 'items.dmi'
	icon_state = "reinf_tableparts"
	m_amt = 7500
	flags = FPRINT | TABLEPASS| CONDUCT

/obj/item/weapon/table_parts/wood
	name = "wooden table parts"
	desc = "Keep away from fire."
	icon_state = "wood_tableparts"
	flags = null

/obj/item/weapon/tank
	name = "tank"
	icon = 'tank.dmi'

	var/datum/gas_mixture/air_contents = null
	var/distribute_pressure = ONE_ATMOSPHERE
	flags = FPRINT | TABLEPASS | CONDUCT | ONBACK

	pressure_resistance = ONE_ATMOSPHERE*5

	force = 5.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 4
	var/volume = 70
	var/startempty = 0
	hitsound = 'smash.ogg'

/obj/item/weapon/tank/anesthetic
	name = "Gas Tank (Sleeping Agent)"
	desc = "Seriously, who uses this anymore?"
	icon_state = "anesthetic"
	item_state = "an_tank"

/obj/item/weapon/tank/jetpack
	name = "Jetpack (Oxygen)"
	desc = "A pack of jets it appears."
	icon_state = "jetpack0"
	var/on = 0.0
	w_class = 4.0
	item_state = "jetpack"
	var/datum/effects/system/ion_trail_follow/ion_trail
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	//volume = 140 //jetpack sould be larger, but then it will never deplete -rastaf0

/obj/item/weapon/tank/jetpack/void_jetpack
	name = "Void Jetpack (oxygen)"
	desc = "It works well in a void."
	icon_state = "voidjetpack0"
	item_state =  "jetpack"

/obj/item/weapon/tank/jetpack/black_jetpack
	name = "Black Jetpack (oxygen)"
	desc = "A black model of jetpacks."
	icon_state = "black_jetpack0"
	item_state =  "black_jetpack"

/obj/item/weapon/tank/jetpack/screwballscape
	name = "Screwball Supercape"
	desc = "A fancy came which comes with space travelling powers."
	icon_state = "screwballcape0"
	item_state =  "screwballcape"

/obj/item/weapon/tank/oxygen
	name = "Gas Tank (Oxygen)"
	desc = "A tank of oxygen"
	icon_state = "oxygen"
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD

/obj/item/weapon/tank/oxygen/yellow
	name = "Gas Tank (Oxygen)"
	desc = "A tank of oxygen meant for firefighters."
	icon_state = "oxygen_f"

/obj/item/weapon/tank/oxygen/yellowempty
	name = "Gas Tank"
	desc = "An empty tank."
	icon_state = "oxygen_f"
	startempty = 1

/obj/item/weapon/tank/oxygen/red
	name = "Gas Tank (Oxygen)"
	desc = "A tank of oxygen meant for firefighters."
	icon_state = "oxygen_fr"

/obj/item/weapon/tank/air
	name = "Gas Tank (Air Mix)"
	desc = "Mixed anyone?"
	icon_state = "oxygen"

/obj/item/weapon/tank/plasma
	name = "Gas Tank (BIOHAZARD)"
	desc = "Contains dangerous plasma. Do not inhale."
	icon_state = "plasma"

/obj/item/weapon/tank/emergency_oxygen
	name = "Emergency Oxygen Tank"
	desc = "Used for emergencies. Contains very little oxygen, so try to conserve it until you actualy need it."
	icon_state = "emergency"
	flags = FPRINT | TABLEPASS | ONBELT | CONDUCT
	w_class = 2.0
	force = 4.0
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	volume = 8 //Tiny. Real life equivalents only have 21 breaths of oxygen in them. They're EMERGENCY tanks anyway -errorage (dangercon 2011)

/obj/item/weapon/tank/emergency_oxygen/engi
	icon_state = "emergency_engi"
	name = "Engineering Emergency Oxygen Tank"
	volume = 10 //Engineers are always superior. -errorage (dangercon 2011)

/obj/item/weapon/tank/emergency_oxygen/double
	icon_state = "emergency_double"
	name = "Double Emergency Oxygen Tank"
	volume = 10 //These have the same emoung of gas in them as air tanks, but can be worn on your belt -errorage (dangercon 2011)

/obj/item/weapon/teleportation_scroll
	name = "Teleportation Scroll"
	desc = "A scroll for moving around."
	icon = 'wizard.dmi'
	icon_state = "scroll"
	var/uses = 4.0
	flags = FPRINT | TABLEPASS
	w_class = 2.0
	item_state = "paper"
	throw_speed = 4
	throw_range = 20
	origin_tech = "bluespace=4"

/obj/item/weapon/wire
	desc = "This is just a simple piece of regular insulated wire."
	name = "wire"
	icon = 'power.dmi'
	icon_state = "item_wire"
	var/amount = 1.0
	var/laying = 0.0
	var/old_lay = null
	m_amt = 40

/obj/item/weapon/wirecutters
	name = "wirecutters"
	desc = "This cuts wires."
	icon = 'items.dmi'
	icon_state = "cutters"
	flags = FPRINT | TABLEPASS| CONDUCT
	force = 6.0
	throw_speed = 2
	throw_range = 9
	w_class = 2.0
	m_amt = 80
	origin_tech = "materials=1;engineering=1"

	New()
		if(prob(50))
			icon_state = "cutters-y"

/obj/item/weapon/wrapping_paper
	name = "wrapping paper"
	desc = "You can use this to wrap items in."
	icon = 'items.dmi'
	icon_state = "wrap_paper"
	var/amount = 20.0

/obj/item/weapon/wrench
	name = "wrench"
	desc = "A wrench with common uses. Can be found in your hand."
	icon = 'items.dmi'
	icon_state = "wrench"
	flags = FPRINT | TABLEPASS| CONDUCT
	force = 5.0
	throwforce = 7.0
	w_class = 2.0
	m_amt = 150
	origin_tech = "materials=1;engineering=1"

/obj/item/weapon/cell
	name = "power cell"
	desc = "A rechargable electrochemical power cell."
	icon = 'power.dmi'
	icon_state = "cell"
	item_state = "cell"
	origin_tech = "powerstorage=1"
	flags = FPRINT|TABLEPASS
	force = 5.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	w_class = 3.0
	pressure_resistance = 80
	var/charge = 0	// note %age conveted to actual charge in New
	var/maxcharge = 1000
	m_amt = 700
	g_amt = 50
	var/rigged = 0		// true if rigged to explode
	var/minor_fault = 0 //If not 100% reliable, it will build up faults.


/obj/item/weapon/cell/crap
	name = "Nanotrassen Brand Rechargable AA Battery"
	desc = "You can't top the plasma top." //TOTALLY TRADEMARK INFRINGEMENT
	origin_tech = "powerstorage=0"
	maxcharge = 500
	g_amt = 40

/obj/item/weapon/cell/verylow
	name = "Nanotrassen Brand Rechargable AA Battery"
	desc = "You can't top the plasma top." //TOTALLY TRADEMARK INFRINGEMENT
	origin_tech = "powerstorage=0"
	maxcharge = 100
	g_amt = 40

/obj/item/weapon/cell/high
	name = "high-capacity power cell"
	origin_tech = "powerstorage=2"
	maxcharge = 10000
	g_amt = 60

/obj/item/weapon/cell/super
	name = "super-capacity power cell"
	origin_tech = "powerstorage=3"
	maxcharge = 20000
	g_amt = 70

/obj/item/weapon/cell/hyper
	name = "hyper-capacity power cell"
	origin_tech = "powerstorage=6"
	maxcharge = 30000
	g_amt = 80

/obj/item/weapon/cell/infinite
	name = "infinite-capacity power cell!"
	origin_tech =  null
	maxcharge = 30000
	g_amt = 80
	use()
		return

/obj/item/weapon/cell/potato
	name = "Potato Battery"
	desc = "A rechargable starch based power cell."
	//icon = 'harvest.dmi' doesn't work don't bother
	//icon_state = "potato_battery"
	maxcharge = 100
	m_amt = 0
	g_amt = 0

/obj/item/weapon/camera_bug/attack_self(mob/usr as mob)
	var/list/cameras = new/list()
	for (var/obj/machinery/camera/C in machines)
		if (C.bugged && C.status)
			cameras.Add(C)
	if (length(cameras) == 0)
		usr << "\red No bugged functioning cameras found."
		return

	var/list/friendly_cameras = new/list()

	for (var/obj/machinery/camera/C in cameras)
		friendly_cameras.Add(C.c_tag)

	var/target = input("Select the camera to observe", null) as null|anything in friendly_cameras
	if (!target)
		return
	for (var/obj/machinery/camera/C in cameras)
		if (C.c_tag == target)
			target = C
			break
	if (usr.stat == 2) return

	usr.client.eye = target


/obj/item/weapon/module
	icon = 'module.dmi'
	icon_state = "std_module"
	w_class = 2.0
	item_state = "electronic"
	flags = FPRINT|TABLEPASS|CONDUCT
	var/mtype = 1						// 1=electronic 2=hardware

/obj/item/weapon/module/card_reader
	name = "card reader module"
	icon_state = "card_mod"
	desc = "An electronic module for reading data and ID cards."

/obj/item/weapon/module/power_control
	name = "power control module"
	icon_state = "power_mod"
	desc = "Heavy-duty switching circuits for power control."

/obj/item/weapon/module/id_auth
	name = "ID authentication module"
	icon_state = "id_mod"
	desc = "A module allowing secure authorization of ID cards."

/obj/item/weapon/module/cell_power
	name = "power cell regulator module"
	icon_state = "power_mod"
	desc = "A converter and regulator allowing the use of power cells."

/obj/item/weapon/module/cell_power
	name = "power cell charger module"
	icon_state = "power_mod"
	desc = "Charging circuits for power cells."


/obj/item/weapon/a_gift
	name = "gift"
	desc = "A gift it appears."
	icon = 'items.dmi'
	icon_state = "gift"
	item_state = "gift"
	pressure_resistance = 70


/obj/item/weapon/camera_bug
	name = "camera bug"
	icon = 'device.dmi'
	icon_state = "flash"
	w_class = 1.0
	item_state = "electronic"
	throw_speed = 4
	throw_range = 20


/obj/item/weapon/kitchen
	icon = 'kitchen.dmi'

/obj/item/weapon/kitchen/rollingpin
	name = "rolling pin"
	desc = "Used to knock out the Bartender."
	icon_state = "rolling_pin"
	force = 8.0
	throwforce = 10.0
	throw_speed = 2
	throw_range = 7
	w_class = 3.0

/obj/item/weapon/kitchenknife
	name = "Kitchen knife"
	icon = 'kitchen.dmi'
	icon_state = "knife"
	desc = "A general purpose Chef's Knife made by SpaceCook Incorporated. Guaranteed to stay sharp for years to come."
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 10.0
	w_class = 3.0
	throwforce = 6.0
	throw_speed = 3
	throw_range = 6
	m_amt = 12000
	origin_tech = "materials=1"

/obj/item/weapon/tray
	name = "Tray"
	icon = 'food.dmi'
	icon_state = "tray"
	desc = "A plastic tray to lay food on."
	//throwforce = 12.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	flags = FPRINT | TABLEPASS | CONDUCT
	m_amt = 3000
	var/food_total= 0
	var/burger_amt = 0
	var/cheese_amt = 0
	var/fries_amt = 0
	var/classyalcdrink_amt = 0
	var/alcdrink_amt = 0
	var/bottle_amt = 0
	var/soda_amt = 0
	var/carton_amt = 0
	var/pie_amt = 0
	var/meatbreadslice_amt = 0
	var/salad_amt = 0
	var/miscfood_amt = 0


/obj/item/weapon/kitchen/utensil
	force = 5.0
	w_class = 1.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	flags = FPRINT | TABLEPASS | CONDUCT
	origin_tech = "materials=1"


/obj/item/weapon/kitchen/utensil/fork
	name = "fork"
	desc = "Pointy."
	icon_state = "fork"


/obj/item/weapon/kitchen/utensil/razorblade
	name = "razorblade"
	desc = "Really sharp."
	icon_state = "razorblade"
	force = 1.0
	throwforce = 0

/obj/item/weapon/kitchen/utensil/knife
	name = "knife"
	desc = "Can cut through any food."
	icon_state = "knife"
	force = 10.0
	throwforce = 10.0

/obj/item/weapon/kitchen/utensil/spoon
	name = "spoon"
	desc = "SPOON!"
	icon_state = "spoon"

/obj/item/weapon/scalpel
	name = "scalpel"
	desc = "Cut, cut, and once more cut."
	icon = 'surgery.dmi'
	icon_state = "scalpel"
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 10.0
	w_class = 1.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	m_amt = 10000
	g_amt = 5000
	origin_tech = "materials=1;biotech=1"

/obj/item/weapon/retractor
	name = "retractor"
	desc = "Retracts stuff."
	icon = 'surgery.dmi'
	icon_state = "retractor"
	flags = FPRINT | TABLEPASS | CONDUCT
	w_class = 1.0
	origin_tech = "materials=1;biotech=1"

/obj/item/weapon/hemostat
	name = "hemostat"
	desc = "A hemostat is a vital surgical tool used in almost any surgical procedure."
	icon = 'surgery.dmi'
	icon_state = "hemostat"
	flags = FPRINT | TABLEPASS | CONDUCT
	w_class = 1.0
	origin_tech = "materials=1;biotech=1"

/obj/item/weapon/cautery
	name = "cautery"
	desc = "This stops bleeding."
	icon = 'surgery.dmi'
	icon_state = "cautery"
	flags = FPRINT | TABLEPASS | CONDUCT
	w_class = 1.0
	origin_tech = "materials=1;biotech=1"

/obj/item/weapon/surgicaldrill
	name = "surgical drill"
	desc = "You can drill using this item. You dig?"
	icon = 'surgery.dmi'
	icon_state = "drill"
	flags = FPRINT | TABLEPASS | CONDUCT
	w_class = 1.0
	origin_tech = "materials=1;biotech=1"

/obj/item/weapon/circular_saw
	name = "circular saw"
	desc = "For heavy duty cutting."
	icon = 'surgery.dmi'
	icon_state = "saw"
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 15.0
	w_class = 1.0
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	m_amt = 20000
	g_amt = 10000
	origin_tech = "materials=1;biotech=1"

/obj/item/weapon/surgicaltube
	name = "surgical tubing"
	desc = "A length of sterile tubing, used in various medical procedures. One end of it looks big enough to couple with a syringe."
	icon = 'chemical.dmi'
	icon_state = "surgicaltubecoil"
	item_state = "toxinbottle"
	flags = FPRINT | TABLEPASS | CONDUCT
	w_class = 1.0
	origin_tech = "biotech=1"
	var/cannula = 0

/obj/item/weapon/synthflesh
	name = "synthflesh"
	desc = "Meat that appears...strange..."
	icon = 'food.dmi'
	icon_state = "meat"
	flags = FPRINT | TABLEPASS | CONDUCT
	w_class = 1.0
	origin_tech = "biotech=2"

/obj/item/weapon/stamp
	desc = "A rubber stamp for stamping important documents."
	name = "rubber stamp"
	icon = 'items.dmi'
	icon_state = "stamp-qm"
	item_state = "stamp"
	flags = FPRINT | TABLEPASS
	throwforce = 0
	w_class = 1.0
	throw_speed = 7
	throw_range = 15
	m_amt = 60
	var/color = "green"

/obj/item/weapon/stamp/captain
	name = "captain's rubber stamp"
	icon_state = "stamp-cap"
	color = "blue"

/obj/item/weapon/stamp/hop
	name = "head of personnel's rubber stamp"
	icon_state = "stamp-hop"
	color = "blue"

/obj/item/weapon/stamp/hos
	name = "head of security's rubber stamp"
	icon_state = "stamp-hos"
	color = "red"

/obj/item/weapon/stamp/ce
	name = "chief engineer's rubber stamp"
	icon_state = "stamp-ce"
	color = "white"

/obj/item/weapon/stamp/rd
	name = "research director's rubber stamp"
	icon_state = "stamp-rd"
	color = "white"

/obj/item/weapon/stamp/cmo
	name = "chief medical officer's rubber stamp"
	icon_state = "stamp-cmo"
	color = "white"

/obj/item/weapon/stamp/denied
	name = "DENIED rubber stamp"
	icon_state = "stamp-qm"
	color = "red"

/obj/item/weapon/stamp/clown
	name = "clown's rubber stamp"
	icon_state = "stamp-clown"
	color = "pink"

/obj/item/weapon/storage/cigpack
	name = "Cigarette packet"
	desc = "The most popular brand of Space Cigarettes, sponsors of the Space Olympics."
	icon = 'cigarettes.dmi'
	icon_state = "cigpacket"
	item_state = "cigpacket"
	w_class = 1
	throwforce = 2
	var/cigcount = 6
	flags = ONBELT | TABLEPASS

/*
/obj/item/weapon/cigarpacket
	name = "Pete's Cuban Cigars"
	desc = "The most robust cigars on the planet."
	icon = 'cigarettes.dmi'
	icon_state = "cigarpacket"
	item_state = "cigarpacket"
	w_class = 1
	throwforce = 2
	var/cigarcount = 6
	flags = ONBELT | TABLEPASS */

/obj/item/weapon/cigbutt
	name = "Cigarette butt"
	desc = "A manky old cigarette butt."
	icon = 'cigarettes.dmi'
	icon_state = "cigbutt"
	w_class = 1
	throwforce = 1

/obj/item/weapon/cigarbutt
	name = "Cigar butt"
	desc = "A manky old cigar butt."
	icon = 'cigarettes.dmi'
	icon_state = "cigarbutt"
	w_class = 1
	throwforce = 1

/obj/item/weapon/zippo
	name = "Zippo lighter"
	desc = "The detective's zippo."
	icon = 'items.dmi'
	icon_state = "zippo"
	item_state = "zippo"
	w_class = 1
	throwforce = 4
	var/lit = 0
	flags = ONBELT | TABLEPASS | CONDUCT


/obj/item/weapon/mousetrap
	name = "mousetrap"
	desc = "A handy little spring-loaded trap for catching pesty rodents."
	icon = 'weapons.dmi'
	icon_state = "mousetrap"
	item_state = "mousetrap"
	w_class = 1
	force = null
	throwforce = null
	var/armed = 0
	var/obj/item/weapon/chem_grenade/nade
	origin_tech = "combat=1"

/obj/item/weapon/mousetrap/armed
	icon_state = "mousetraparmed"
	armed = 1

/obj/item/weapon/mousetrap/nade
	icon_state = "mousetrapnade"
	armed = 1

/obj/item/weapon/mousetrap/nade/cleaner
	New()
		nade = new /obj/item/weapon/chem_grenade/cleaner(src)

/obj/item/weapon/mousetrap/nade/incendiary
	New()
		nade = new /obj/item/weapon/chem_grenade/incendiary(src)

/obj/item/weapon/mousetrap/nade/lube
	New()
		nade = new /obj/item/weapon/chem_grenade/lube(src)

/obj/item/weapon/mousetrap/nade/poo
	New()
		nade = new /obj/item/weapon/chem_grenade/poo(src)

/obj/item/weapon/mousetrap/nade/poo2
	New()
		nade = new /obj/item/weapon/chem_grenade/poo2(src)

/obj/item/weapon/astronautfoodpacket
	name = "Astronaut Ration Packet"
	desc = "A compressed, dehydrated, enriched, artificially flavored, airtight packet of food."
	icon = 'food.dmi'
	icon_state = "astronautfood3"
	item_state = "rack_parts"
	w_class = 1.0
	throwforce = 1
	var/foodcount = 3
	flags = ONBELT | TABLEPASS


/obj/item/weapon/weaponassembly/battery
	name = "turnover battery"
	desc = "A power cell with a greatly increased output rating, at the cost of capacity. A vital component in most weapon systems."
	icon = 'weapon_assembly.dmi'
	icon_state = "battery"
	item_state = "rack_parts"
	w_class = 1.0
	g_amt = 100
	m_amt = 1000



/obj/item/weapon/weaponassembly/energhousing
	name = "energy gun housing"
	desc = "A lightweight housing for an energy gun's components."
	icon = 'weapon_assembly.dmi'
	icon_state = "nrg-gun_assembledhousing"
	item_state = "rack_parts"
	w_class = 1.0
	g_amt = 300
	m_amt = 2000

/obj/item/weapon/weaponassembly/fronthousing
	name = "energy gun housing"
	desc = "Half of a lightweight housing for an energy gun's components."
	icon = 'weapon_assembly.dmi'
	icon_state = "nrg-gun_fronthousing"
	item_state = "rack_parts"
	w_class = 1.0
	g_amt = 20
	m_amt = 550

/obj/item/weapon/weaponassembly/backhousing
	name = "energy gun housing"
	desc = "Half of a lightweight housing for an energy gun's components."
	icon = 'weapon_assembly.dmi'
	icon_state = "nrg-gun_backhousing"
	item_state = "rack_parts"
	w_class = 1.0
	g_amt = 30
	m_amt = 450

/obj/item/weapon/weaponassembly/grip
	name = "energy gun grip"
	desc = "A grip for an energy gun. It seems to be made out of artificial wood."
	icon = 'weapon_assembly.dmi'
	icon_state = "nrg-gun_grip"
	item_state = "rack_parts"
	w_class = 1.0
	g_amt = 0
	m_amt = 0

/obj/item/weapon/weaponassembly/indicator
	name = "energy gun charge indicator"
	desc = "A small screen designed to be used with standard energy guns. It shows the level of charge of the gun, in measured gradiations."
	icon = 'weapon_assembly.dmi'
	icon_state = "nrg-gun_indicator"
	item_state = "rack_parts"
	w_class = 1.0
	g_amt = 150
	m_amt = 60

/obj/item/weapon/weaponassembly/electronics
	name = "energy gun trigger system"
	desc = "A bundle of electronics and a trigger for a standard energy gun."
	icon = 'weapon_assembly.dmi'
	icon_state = "nrg_gun_electronics"
	item_state = "rack_parts"
	w_class = 1.0
	g_amt = 150
	m_amt = 150

/obj/item/weapon/dermalregenerator
	name = "Dermal regenerator"
	desc = "A cutting edge device used to heal minor cuts, bruises and burns."
	icon = 'device.dmi'
	icon_state = "dermal_regenerator"
	flags = FPRINT | ONBELT | TABLEPASS
	var/heal_brute = 5
	var/heal_burn = 5
	var/on = 0
	origin_tech = "magnets=2;biotech=2"

/obj/item/weapon/dermalregenerator/attack(mob/M as mob, mob/user as mob)

	if (on == 1)
		return
	if (M.health < -50)
		user << "\red [M.name] is too badly injured!"
		return
	if (M.health >= 100)
		user << "[M.name] is not injured."
		return

	if (!(istype(user, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		user << "\red You don't have the dexterity to do this!"
		return
	on = 1
	if (user)
		if (M != user)
			for (var/mob/O in viewers(M, null))
				O.show_message("\red [user] has used the [src] on [M]", 1)
				src.icon_state = "dermalr1"
		else
			var/t_himself = "itself"
			if (user.gender == MALE)
				t_himself = "himself"
			else if (user.gender == FEMALE)
				t_himself = "herself"

			for (var/mob/O in viewers(M, null))
				O.show_message("\red [M] used the [src] on [t_himself]", 1)
			src.icon_state = "dermalr1"

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/datum/organ/external/affecting = H.organs["chest"]

		if (istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/user2 = user
			var/t = user2.zone_sel.selecting

			if (t in list("eyes", "mouth"))
				t = "head"

			if (H.organs[t])
				affecting = H.organs[t]
		else
			if (!istype(affecting, /datum/organ/external) || affecting:burn_dam <= 0)
				affecting = H.organs["head"]
				if (!istype(affecting, /datum/organ/external) || affecting:burn_dam <= 0)
					affecting = H.organs["groin"]

		if (affecting.heal_damage(src.heal_brute, src.heal_burn))
			H.UpdateDamageIcon()
		else
			H.UpdateDamage()
	else
		M.bruteloss = max(0, M.bruteloss - (src.heal_brute/2))
		M.fireloss = max(0, M.fireloss - (src.heal_burn/2))

	sleep(10)
	src.icon_state = "dermal_regenerator"
	on = 0

/obj/item/weapon/dice // -- TLE
	name = "d6"
	desc = "A dice with six sides."
	var/sides = 6
	icon_state = "dice"
	item_state = "dice"

/obj/item/weapon/dice/d20 // -- TLE
	name = "d20"
	desc = "A dice with...hell that is many sides."
	sides = 20
	icon_state = "d20"
	item_state = "dice"

/obj/item/weapon/pai_cable
	desc = "A flexible coated cable with a universal jack on one end."
	desc = "Some spacey cable."
	name = "data cable"
	icon = 'power.dmi'
	icon_state = "wire1"
	var/obj/machinery/machine

/obj/item/weapon/plastique
	name = "Plastic Explosives"
	desc = "Used to put holes in specific areas without too much extra hole."
	icon = 'assemblies.dmi'
	icon_state = "plastic-explosive0"
	item_state = "plasticx"
	flags = FPRINT | TABLEPASS | USEDELAY
	w_class = 2.0
	origin_tech = "syndicate=2"
	var/timer = 10
	var/atom/target = null

///////////////////////////////////////Stock Parts /////////////////////////////////

/obj/item/weapon/stock_parts
	name = "stock part"
	desc = "What?"
	icon = 'stock_parts.dmi'
	var/rating = 1
	New()
		src.pixel_x = rand(-5.0, 5)
		src.pixel_y = rand(-5.0, 5)

//Rank 1

/obj/item/weapon/stock_parts/console_screen
	name = "Console Screen"
	desc = "Used in the construction of computers and other devices with a interactive console."
	icon_state = "screen"
	origin_tech = "materials=1"
	g_amt = 200

/obj/item/weapon/stock_parts/capacitor
	name = "Capacitor"
	desc = "A basic capacitor used in the construction of a variety of devices."
	icon_state = "capacitor"
	origin_tech = "powerstorage=1"
	m_amt = 50
	g_amt = 50

/obj/item/weapon/stock_parts/scanning_module
	name = "Scanning Module"
	desc = "A compact, high resolution scanning module used in the construction of certain devices."
	icon_state = "scan_module"
	origin_tech = "magnets=1"
	m_amt = 50
	g_amt = 20

/obj/item/weapon/stock_parts/manipulator
	name = "Micro-Manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "micro_mani"
	origin_tech = "materials=1;programming=1"
	m_amt = 30

/obj/item/weapon/stock_parts/micro_laser
	name = "Micro-laser"
	desc = "A tiny laser used in certain devices."
	icon_state = "micro_laser"
	origin_tech = "magnets=1"
	m_amt = 10
	g_amt = 20

/obj/item/weapon/stock_parts/matter_bin
	name = "Matter Bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "matter_bin"
	origin_tech = "materials=1"
	m_amt = 80

//Rank 2

/obj/item/weapon/stock_parts/capacitor/adv
	name = "Advanced Capacitor"
	desc = "An advanced capacitor used in the construction of a variety of devices."
	origin_tech = "powerstorage=3"
	rating = 2
	m_amt = 50
	g_amt = 50

/obj/item/weapon/stock_parts/scanning_module/adv
	name = "Advanced Scanning Module"
	desc = "A compact, high resolution scanning module used in the construction of certain devices."
	icon_state = "scan_module"
	origin_tech = "magnets=3"
	rating = 2
	m_amt = 50
	g_amt = 20

/obj/item/weapon/stock_parts/manipulator/nano
	name = "Nano-Manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "micro_mani"
	origin_tech = "materials=3,programming=2"
	rating = 2
	m_amt = 30

/obj/item/weapon/stock_parts/micro_laser/high
	name = "High-Power Micro-laser"
	desc = "A tiny laser used in certain devices."
	icon_state = "micro_laser"
	origin_tech = "magnets=3"
	rating = 2
	m_amt = 10
	g_amt = 20

/obj/item/weapon/stock_parts/matter_bin/adv
	name = "Advanced Matter Bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "matter_bin"
	origin_tech = "materials=3"
	rating = 2
	m_amt = 80

//Rating 3

/obj/item/weapon/stock_parts/capacitor/super
	name = "Super Capacitor"
	desc = "A super-high capacity capacitor used in the construction of a variety of devices."
	origin_tech = "powerstorage=5;materials=4"
	rating = 3
	m_amt = 50
	g_amt = 50

/obj/item/weapon/stock_parts/scanning_module/phasic
	name = "Phasic Scanning Module"
	desc = "A compact, high resolution phasic scanning module used in the construction of certain devices."
	origin_tech = "magnets=5"
	rating = 3
	m_amt = 50
	g_amt = 20

/obj/item/weapon/stock_parts/manipulator/pico
	name = "Pico-Manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	origin_tech = "materials=5,programming=2"
	rating = 3
	m_amt = 30

/obj/item/weapon/stock_parts/micro_laser/ultra
	name = "Ultra-High-Power Micro-laser"
	desc = "A tiny laser used in certain devices."
	origin_tech = "magnets=5"
	rating = 3
	m_amt = 10
	g_amt = 20

/obj/item/weapon/stock_parts/matter_bin/super
	name = "Super Matter Bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	origin_tech = "materials=5"
	rating = 3
	m_amt = 80

//barber crap
/obj/item/weapon/scissors
	name = "scissors"
	icon = 'surgery.dmi'
	icon_state = "scissors"
	flags = FPRINT | TABLEPASS | CONDUCT
	w_class = 1.0
	origin_tech = "materials=1"

/obj/item/weapon/dye
	name = "hairdye"
	icon = 'surgery.dmi'
	icon_state = "dye"
	flags = FPRINT | TABLEPASS | CONDUCT
	w_class = 1.0
	origin_tech = "materials=1"

/obj/item/weapon/bearddye
	name = "bearddye"
	icon = 'surgery.dmi'
	icon_state = "dye"
	flags = FPRINT | TABLEPASS | CONDUCT
	w_class = 1.0
	origin_tech = "materials=1"

/obj/item/weapon/comb
	name = "straight razor"
	icon = 'surgery.dmi'
	icon_state = "razor"
	flags = FPRINT | TABLEPASS | CONDUCT
	w_class = 1.0
	origin_tech = "materials=1"
//end barber crap