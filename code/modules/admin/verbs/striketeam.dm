var/const/commandos_possible = 6 //if more Commandos are needed in the future
var/global/sent_strike_team = 0
/client/proc/strike_team()
	set category = "Fun"
	set name = "Spawn Death Squad"
	set desc = "Spawns a squad of commandos in CentCom if you want to run an admin event."
	if(!src.authenticated || !src.holder)
		src << "Only administrators may use this command."
		return
	if(!ticker)
		alert("The game hasn't started yet!")
		return
	if(world.time < 6000)
		alert("Not so fast, buddy. Wait a few minutes until the game gets going. There are [(6000-world.time)/10] seconds remaining.")
		return
	if(sent_strike_team == 1)
		alert("CentCom is already sending a team, Mr. Dumbass.")
		return
	if(alert("Do you want to send in the CentCom death squad? Once enabled, this is irreversible.",,"Yes","No")=="No")
		return
	alert("This 'mode' will go on until everyone is dead or the station is destroyed. You may also admin-call the evac shuttle when appropriate. Spawned commandos have internals cameras which are viewable through a monitor inside the Spec. Ops. Office. Assigning the team's task is recommended from there.")

	TRYAGAIN

	var/input = input(usr, "Please specify which mission the death commando squad shall undertake.", "Specify Mission", "")
	if(!input)
		goto TRYAGAIN
	sent_strike_team = 1

	if (emergency_shuttle.direction == 1 && emergency_shuttle.online == 1)
		emergency_shuttle.recall()
		world << "\blue <B>Alert: The shuttle is going back!</B>"

	var/commando_number = 6 //for selecting a leader
	var/leader_selected = 0 //when the leader is chosen. The last person spawned.
	var/commando_leader_rank = pick("Lieutenant", "Captain", "Major")
	var/list/commando_names = dd_file2list("config/names/last.txt")

//Code for spawning a nuke auth code.
	var/nuke_code = "[rand(10000, 99999.0)]"

//Spawns commandos and equips them.

	for (var/obj/landmark/STARTLOC in world)
		if (STARTLOC.name == "Commando")
			var/mob/living/carbon/human/new_commando = new(STARTLOC.loc)
			var/commando_rank = pick("Corporal", "Sergeant", "Staff Sergeant", "Sergeant 1st Class", "Master Sergeant", "Sergeant Major")
			var/commando_name = pick(commando_names)
			new_commando.gender = pick(MALE, FEMALE)
			if (commando_number == 1)
				leader_selected = 1
			if (leader_selected == 0)
				new_commando.real_name = "[commando_rank] [commando_name]"
			else
				new_commando.real_name = "[commando_leader_rank] [commando_name]"
			if (leader_selected == 0)
				new_commando.age = rand(23,35)
			else
				new_commando.age = rand(35,45)
			new_commando.b_type = pick("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-")
			new_commando.dna.ready_dna(new_commando) //Creates DNA
			//Creates mind stuff.
			new_commando.mind = new
			new_commando.mind.current = new_commando
			new_commando.mind.assigned_role = "Death Commando"
			new_commando.mind.store_memory("<B>Nuke Code:</B> \red [nuke_code].")//So they don't forget their code or mission.
			new_commando.mind.store_memory("<B>Mission:</B> \red [input].")
			new_commando.resistances += "alien_embryo"

			del(STARTLOC)

			var/obj/machinery/camera/cam = new /obj/machinery/camera(new_commando) //Gives all the commandos internals cameras.
			cam.network = "CREED"
			cam.c_tag = new_commando.real_name

			var/obj/item/device/radio/R = new /obj/item/device/radio/headset(new_commando)
			R.set_frequency(1441)
			new_commando.equip_if_possible(R, new_commando.slot_ears)
			if (leader_selected == 0)
				new_commando.equip_if_possible(new /obj/item/clothing/under/color/green(new_commando), new_commando.slot_w_uniform)
			else
				new_commando.equip_if_possible(new /obj/item/clothing/under/rank/centcom_officer(new_commando), new_commando.slot_w_uniform)
			new_commando.equip_if_possible(new /obj/item/clothing/shoes/swat(new_commando), new_commando.slot_shoes)
			new_commando.equip_if_possible(new /obj/item/clothing/suit/armor/swat(new_commando), new_commando.slot_wear_suit)
			new_commando.equip_if_possible(new /obj/item/clothing/gloves/swat(new_commando), new_commando.slot_gloves)
			new_commando.equip_if_possible(new /obj/item/clothing/head/helmet/swat(new_commando), new_commando.slot_head)
			new_commando.equip_if_possible(new /obj/item/clothing/mask/gas/swat(new_commando), new_commando.slot_wear_mask)
			new_commando.equip_if_possible(new /obj/item/clothing/glasses/thermal(new_commando), new_commando.slot_glasses)

			new_commando.equip_if_possible(new /obj/item/weapon/storage/backpack(new_commando), new_commando.slot_back)

			new_commando.equip_if_possible(new /obj/item/weapon/ammo/a357(new_commando), new_commando.slot_in_backpack)
			new_commando.equip_if_possible(new /obj/item/weapon/storage/firstaid/regular(new_commando), new_commando.slot_in_backpack)
			new_commando.equip_if_possible(new /obj/item/weapon/storage/flashbang_kit(new_commando), new_commando.slot_in_backpack)
			new_commando.equip_if_possible(new /obj/item/device/flashlight(new_commando), new_commando.slot_in_backpack)
			if (leader_selected == 0)
				new_commando.equip_if_possible(new /obj/item/weapon/plastique(new_commando), new_commando.slot_in_backpack)
			else
				new_commando.equip_if_possible(new /obj/item/weapon/pinpointer(new_commando), new_commando.slot_in_backpack)
			if (leader_selected == 1)
				new_commando.equip_if_possible(new /obj/item/weapon/disk/nuclear(new_commando), new_commando.slot_in_backpack)

			new_commando.equip_if_possible(new /obj/item/weapon/sword(new_commando), new_commando.slot_l_store)
			new_commando.equip_if_possible(new /obj/item/weapon/flashbang(new_commando), new_commando.slot_r_store)
			new_commando.equip_if_possible(new /obj/item/weapon/tank/emergency_oxygen(new_commando), new_commando.slot_belt)

			var/obj/item/weapon/gun/revolver/GUN = new /obj/item/weapon/gun/revolver/mateba(new_commando)
			GUN.bullets = 7
			new_commando.equip_if_possible(GUN, new_commando.slot_s_store)
//			new_commando.equip_if_possible(new /obj/item/weapon/gun/energy/pulse_rifle(new_commando), new_commando.slot_l_hand)
/*Commented out because Commandos now have their rifles spawn in front of them, along with operation manuals.
Useful for copy pasta since I'm lazy.*/

			var/obj/item/weapon/card/id/W = new(new_commando)
			W.name = "[new_commando.real_name]'s ID Card"
			W.access = get_all_accesses()
			W.assignment = "Death Commando"
			W.registered = new_commando.real_name
			new_commando.equip_if_possible(W, new_commando.slot_wear_id)

			var/list/candidates = list() // Picks a random ghost for the role. Mostly a copy of alien burst code.
			for(var/mob/dead/observer/G in world)
				if(G.client)
					if(!G.client.holder && ((G.client.inactivity/10)/60) <= 5) //Whoever called/has the proc won't be added to the list.
//					if(((G.client.inactivity/10)/60) <= 5) //Removing it allows even the caller to jump in. Good for testing.
						candidates.Add(G)
			if(candidates.len)
				var/mob/dead/observer/G = pick(candidates)
				new_commando.mind.key = G.key//For mind stuff.
				new_commando.client = G.client
				del(G)
			else
				new_commando.key = "null"

			commando_number = commando_number-1

			if (leader_selected == 0)
				new_commando << "\blue \nYou are a Special Ops. commando in the service of Central Command. Check the table ahead for detailed instructions.\nYour current mission is: \red<B>[input]</B>"
			else
				new_commando << "\blue \nYou are a Special Ops. <B>LEADER</B> in the service of Central Command. Check the table ahead for detailed instructions.\nYour current mission is: \red<B>[input]</B>"

//Targets any nukes in the world and changes their auth code as needed.
//Bad news for Nuke operatives--or great news.
	for(var/obj/machinery/nuclearbomb/NUAK in world)
		if (NUAK.name == "Nuclear Fission Explosive")
			NUAK.r_code = nuke_code

	for (var/obj/landmark/MANUAL)
		if (MANUAL.name == "Commando_Manual")
			new /obj/item/weapon/gun/energy/pulse_rifle(MANUAL.loc)
			var/obj/item/weapon/paper/PAPER = new(MANUAL.loc)
			PAPER.info = "<p><b>Good morning soldier!</b>. This compact guide will familiarize you with standard operating procedure. There are three basic rules to follow:<br>#1 Work as a team.<br>#2 Accomplish your objective at all costs.<br>#3 Leave no witnesses.<br>You are fully equipped and stocked for your mission--before departing on the Spec. Ops. Shuttle due South, make sure that all operatives are ready. Actual mission objective will be relayed to you by Central Command through your headsets.<br>If deemed appropriate, Cent. Com will also allow members of your team to equip assault power-armor for the mission. You will find the armor storage due West of your position. Once you are ready to leave, utilize the Special Operations shuttle console and toggle the hull doors via the other console.</p><p>In the event that the team does not accomplish their assigned objective in a timely manner, or finds no other way to do so, attached below are instructions on how to operate a Nanotrasen Nuclear Device. Your operations <b>LEADER</b> is provided with a nuclear authentication disk and a pin-pointer for this reason. You may easily recognize them by their rank: Lieutenant, Captain, or Major. The nuclear device itself will be present somewhere on your destination.</p><p>Hello and thank you for choosing Nanotrasen for your nuclear information needs. Today's crash course will deal with the operation of a Fission Class Nanotrasen made Nuclear Device.<br>First and foremost, <b>DO NOT TOUCH ANYTHING UNTIL THE BOMB IS IN PLACE.</b> Pressing any button on the compacted bomb will cause it to extend and bolt itself into place. If this is done to unbolt it one must completely log in which at this time may not be possible.<br>To make the device functional:<br>#1 Place bomb in designated detonation zone<br> #2 Extend and anchor bomb (attack with hand).<br>#3 Insert Nuclear Auth. Disk into slot.<br>#4 Type numeric code into keypad ([nuke_code]).<br>Note: If you make a mistake press R to reset the device.<br>#5 Press the E button to log onto the device.<br>You now have activated the device. To deactivate the buttons at anytime, for example when you have already prepped the bomb for detonation, remove the authentication disk OR press the R on the keypad. Now the bomb CAN ONLY be detonated using the timer. A manual detonation is not an option.<br>Note: Toggle off the <b>SAFETY</b>.<br>Use the - - and + + to set a detonation time between 5 seconds and 10 minutes. Then press the timer toggle button to start the countdown. Now remove the authentication disk so that the buttons deactivate.<br>Note: <b>THE BOMB IS STILL SET AND WILL DETONATE</b><br>Now before you remove the disk if you need to move the bomb you can: Toggle off the anchor, move it, and re-anchor.</p><p>The nuclear authorization code is: <b>[nuke_code]</b></p><p><b>Good luck, soldier!</b></p>"
			PAPER.name = "Spec. Ops. Manual"

	for (var/obj/landmark/BOMB in world)
		if (BOMB.name == "Commando-Bomb")
			new /obj/spawner/newbomb/timer/syndicate(BOMB.loc)
			del(BOMB)

	message_admins("\blue [key_name_admin(usr)] has spawned a CentCom strike squad.", 1)
	log_admin("[key_name(usr)] used Spawn Death Squad.")