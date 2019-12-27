#define SOLID 1
#define LIQUID 2
#define GAS 3

/obj/machinery/chem_dispenser/
	name = "chem dispenser"
	density = 1
	anchored = 1
	icon = 'chemical.dmi'
	icon_state = "dispenser"
	var/energy = 50
	var/max_energy = 50
	var/beaker = null
	var/possible_transfer_amounts = list(5,10,15,20,25,30,35,40,45,50)
	var/transferamount = 5
	var/list/dispensable_reagents = list("hydrogen","lithium","carbon","nitrogen","oxygen","fluorine","sodium","aluminum","silicon","phosphorus","sulfur","chlorine","potassium","iron","copper","mercury","radium","ethanol","sugar","acid",)
	proc
		recharge()
			if(stat & BROKEN) return
			if(energy != max_energy)
				energy++
				use_power(50)
			spawn(600) recharge()

	New()
		if (!possible_transfer_amounts)
			src.verbs -= /obj/reagent_dispensers/verb/set_APTFT
		recharge()

	verb/set_APTFT() //set amount_per_transfer_from_this
		set name = "Set transfer amount"
		set src in view(1)
		var/N = input("Amount per transfer from this:","[src]") as null|anything in possible_transfer_amounts
		if (N)
			transferamount = N

	ex_act(severity)
		switch(severity)
			if(1.0)
				del(src)
				return
			if(2.0)
				if (prob(50))
					del(src)
					return

	blob_act()
		if (prob(50))
			del(src)

	meteorhit()
		del(src)
		return

	attackby(var/obj/item/weapon/reagent_containers/glass/B as obj, var/mob/user as mob)
		if(!istype(B, /obj/item/weapon/reagent_containers/glass))
			return

		if(src.beaker)
			user << "The beaker is already loaded!"
			return

		src.beaker =  B
		user.drop_item()
		B.loc = src
		user << "You add the [B.name] to the machine!"
		if(istype(B, /obj/item/weapon/reagent_containers/glass/large/iv_bag))
			user << "\blue The [B.name] falls out of the machine!"
			B.loc = src.loc
			beaker = null
			return
		src.updateUsrDialog()

	Topic(href, href_list)
		if(stat & BROKEN) return
		if(usr.stat || usr.restrained()) return
		if(!in_range(src, usr)) return

		usr.machine = src
		if(!beaker)
			var/dat = "<TITLE>Chemical Dispenser</TITLE>No beaker loaded.<BR><A href='?src=\ref[src];ok=1'>OK</A>"
			usr << browse("[dat]")
			return

		if (href_list["dispense"])
			if(!beaker)
				usr << "\red Please insert a beaker."
			if(beaker:reagents.total_volume >= beaker:reagents.maximum_volume)
				usr << "\red [beaker] is full."
				return
			if(energy < 1)
				var/dat = "Not enough energy.<BR><A href='?src=\ref[src];ok=1'>OK</A>"
				usr << browse("<TITLE>Chemical Dispenser</TITLE>Chemical dispenser:<BR>Energy = [energy]/[max_energy]<BR><BR>[dat]", "window=chem_dispenser")
				return
			var/id = href_list["dispense"]
			beaker:reagents.add_reagent(id,transferamount)
			beaker:reagents.handle_reactions()
			usr << "\blue You add [transferamount] units of [href_list["dispense"]] to the beaker."
			energy = energy
			src.updateUsrDialog()
			return
		else if (href_list["eject"])
			beaker:loc = src.loc
			beaker = null
			src.updateUsrDialog()
		else
			usr << browse(null, "window=chem_dispenser")
			return

		src.add_fingerprint(usr)
		return

	attack_ai(mob/user as mob)
		return src.attack_hand(user)

	attack_paw(mob/user as mob)
		return src.attack_hand(user)

	attack_hand(mob/user as mob)
		if(stat & BROKEN)
			return
		user.machine = src
		var/dat = ""
		if(beaker)
			dat += "<A href='?src=\ref[src];eject=1'>Eject beaker</A><BR><BR>"
			var/datum/reagents/R = beaker:reagents
			if(!R.total_volume)
				dat += "Beaker is empty."
			else
				dat += "Beaker:<BR>"
				for(var/datum/reagent/G in R.reagent_list)
					dat += "[G.name] , [G.volume] Units<BR>"
			dat += "<BR><BR>"
		else
			dat += "Please insert beaker<BR><BR>"
		for(var/re in dispensable_reagents)
			for(var/da in typesof(/datum/reagent) - /datum/reagent)
				var/datum/reagent/temp = new da()
				if(temp.id == re)
					dat += "<A href='?src=\ref[src];dispense=[temp.id];state=[temp.reagent_state];name=[temp.name]'>[temp.name]</A><BR>"
		user << browse("<TITLE>Chemical Dispenser</TITLE>Chemical dispenser:<BR>Energy = [energy]/[max_energy]<BR><BR>[dat]", "window=chem_dispenser")

		onclose(user, "chem_dispenser")
		return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/chem_master/
	name = "ChemMaster 3000"
	density = 1
	anchored = 1
	icon = 'chemical.dmi'
	icon_state = "mixer0"
	var/beaker = null
	var/mode = 0
	var/condi = 0

	New()
		var/datum/reagents/R = new/datum/reagents(100)
		reagents = R
		R.my_atom = src

	ex_act(severity)
		switch(severity)
			if(1.0)
				del(src)
				return
			if(2.0)
				if (prob(50))
					del(src)
					return

	blob_act()
		if (prob(50))
			del(src)

	meteorhit()
		del(src)
		return

	attackby(var/obj/item/weapon/reagent_containers/glass/B as obj, var/mob/user as mob)
		if(!istype(B, /obj/item/weapon/reagent_containers/glass))
			return

		if(src.beaker)
			user << "The machine is already loaded!"
			return

		src.beaker =  B
		user.drop_item()
		B.loc = src
		user << "You add the [B.name] to the machine!"
		if(istype(B, /obj/item/weapon/reagent_containers/glass/large/iv_bag))
			user << "\blue The [B.name] falls out of the machine!"
			B.loc = src.loc
			beaker = null
			return
		src.updateUsrDialog()
		icon_state = "mixer1"

	Topic(href, href_list)
		if(stat & BROKEN) return
		if(usr.stat || usr.restrained()) return
		if(!in_range(src, usr)) return

		usr.machine = src
		if(!beaker) return
		var/datum/reagents/R = beaker:reagents

		if (href_list["analyze"])
			var/dat = ""
			if(!condi)
				dat += "<TITLE>Chemmaster 3000</TITLE>Chemical infos:<BR><BR>Name:<BR>[href_list["name"]]<BR><BR>Description:<BR>[href_list["desc"]]<BR><BR><BR><A href='?src=\ref[src];main=1'>(Back)</A>"
			else
				dat += "<TITLE>Condimaster 3000</TITLE>Condiment infos:<BR><BR>Name:<BR>[href_list["name"]]<BR><BR>Description:<BR>[href_list["desc"]]<BR><BR><BR><A href='?src=\ref[src];main=1'>(Back)</A>"
			usr << browse(dat, "window=chem_master;size=575x400")
			return
		else if (href_list["add1"])
			R.remove_reagent(href_list["add1"], 1) //Remove/add used instead of trans_to since we're moving a specific reagent.
			reagents.add_reagent(href_list["add1"], 1)
		else if (href_list["add5"])
			R.remove_reagent(href_list["add5"], 5)
			reagents.add_reagent(href_list["add5"], 5)
		else if (href_list["add10"])
			R.remove_reagent(href_list["add10"], 10)
			reagents.add_reagent(href_list["add10"], 10)
		else if (href_list["addall"])
			var/temp_amt = R.get_reagent_amount(href_list["addall"])
			reagents.add_reagent(href_list["addall"], temp_amt)
			R.del_reagent(href_list["addall"])
		else if (href_list["remove1"])
			reagents.remove_reagent(href_list["remove1"], 1)
			if(mode) R.add_reagent(href_list["remove1"], 1)
		else if (href_list["remove5"])
			reagents.remove_reagent(href_list["remove5"], 5)
			if(mode) R.add_reagent(href_list["remove5"], 5)
		else if (href_list["remove10"])
			reagents.remove_reagent(href_list["remove10"], 10)
			if(mode) R.add_reagent(href_list["remove10"], 10)
		else if (href_list["removeall"])
			if(mode)
				var/temp_amt = reagents.get_reagent_amount(href_list["removeall"])
				R.add_reagent(href_list["removeall"], temp_amt)
			reagents.del_reagent(href_list["removeall"])
		else if (href_list["toggle"])
			if(mode)
				mode = 0
			else
				mode = 1
		else if (href_list["main"])
			attack_hand(usr)
			return
		else if (href_list["eject"])
			beaker:loc = src.loc
			beaker = null
			reagents.clear_reagents()
			icon_state = "mixer0"
		else if (href_list["createpill"])
			var/obj/item/weapon/reagent_containers/pill/P = new/obj/item/weapon/reagent_containers/pill(src.loc)
			var/name = strip_html(input(usr,"Name:","Name your pill!",reagents.get_master_reagent_name()))
			if(!name || name == " ") name = reagents.get_master_reagent_name()
			P.name = "[name] pill"
			reagents.trans_to(P,50)
		else if (href_list["createbottle"])
			if(!condi)
				var/name = strip_html(input(usr,"Name:","Name your bottle!",reagents.get_master_reagent_name()))
				var/obj/item/weapon/reagent_containers/glass/bottle/P = new/obj/item/weapon/reagent_containers/glass/bottle(src.loc)
				if(!name || name == " ") name = reagents.get_master_reagent_name()
				P.name = "[name] bottle"
				reagents.trans_to(P,30)
			else
				var/obj/item/weapon/reagent_containers/food/condiment/P = new/obj/item/weapon/reagent_containers/food/condiment(src.loc)
				reagents.trans_to(P,50)
		else
			usr << browse(null, "window=chem_master")
		src.updateUsrDialog()
		src.add_fingerprint(usr)
		return

	attack_ai(mob/user as mob)
		return src.attack_hand(user)

	attack_paw(mob/user as mob)
		return src.attack_hand(user)

	attack_hand(mob/user as mob)
		if(stat & BROKEN)
			return
		user.machine = src
		var/dat = ""
		if(!beaker)
			dat = "Please insert beaker.<BR>"
			dat += "<A href='?src=\ref[src];close=1'>Close</A>"
		else
			var/datum/reagents/R = beaker:reagents
			dat += "<A href='?src=\ref[src];eject=1'>Eject beaker and Clear Buffer</A><BR><BR>"
			if(!R.total_volume)
				dat += "Beaker is empty."
			else
				dat += "Add to buffer:<BR>"
				for(var/datum/reagent/G in R.reagent_list)
					dat += "[G.name] , [G.volume] Units - "
					dat += "<A href='?src=\ref[src];analyze=1;desc=[G.description];name=[G.name]'>(Analyze)</A> "
					dat += "<A href='?src=\ref[src];add1=[G.id]'>(1)</A> "
					if(G.volume >= 5) dat += "<A href='?src=\ref[src];add5=[G.id]'>(5)</A> "
					if(G.volume >= 10) dat += "<A href='?src=\ref[src];add10=[G.id]'>(10)</A> "
					dat += "<A href='?src=\ref[src];addall=[G.id]'>(All)</A><BR>"
			if(!mode)
				dat += "<HR>Transfer to <A href='?src=\ref[src];toggle=1'>disposal:</A><BR>"
			else
				dat += "<HR>Transfer to <A href='?src=\ref[src];toggle=1'>beaker:</A><BR>"
			if(reagents.total_volume)
				for(var/datum/reagent/N in reagents.reagent_list)
					dat += "[N.name] , [N.volume] Units - "
					dat += "<A href='?src=\ref[src];analyze=1;desc=[N.description];name=[N.name]'>(Analyze)</A> "
					dat += "<A href='?src=\ref[src];remove1=[N.id]'>(1)</A> "
					if(N.volume >= 5) dat += "<A href='?src=\ref[src];remove5=[N.id]'>(5)</A> "
					if(N.volume >= 10) dat += "<A href='?src=\ref[src];remove10=[N.id]'>(10)</A> "
					dat += "<A href='?src=\ref[src];removeall=[N.id]'>(All)</A><BR>"
			else
				dat += "Empty<BR>"
			if(!condi)
				dat += "<HR><BR><A href='?src=\ref[src];createpill=1'>Create pill (50 units max)</A><BR>"
				dat += "<A href='?src=\ref[src];createbottle=1'>Create bottle (30 units max)</A>"
			else
				dat += "<A href='?src=\ref[src];createbottle=1'>Create bottle (50 units max)</A>"
		if(!condi)
			user << browse("<TITLE>Chemmaster 3000</TITLE>Chemmaster menu:<BR><BR>[dat]", "window=chem_master;size=575x400")
		else
			user << browse("<TITLE>Condimaster 3000</TITLE>Condimaster menu:<BR><BR>[dat]", "window=chem_master;size=575x400")
		onclose(user, "chem_master")
		return


/obj/machinery/chem_master/condimaster
	name = "CondiMaster 3000"
	condi = 1

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

/obj/machinery/computer/pandemic
	name = "PanD.E.M.I.C 2200"
	density = 1
	anchored = 1
	icon = 'chemical.dmi'
	icon_state = "mixer0"
	var/temphtml = ""
	var/wait = null
	var/obj/item/weapon/reagent_containers/glass/beaker = null


	set_broken()
		icon_state = (src.beaker?"mixer1_b":"mixer0_b")
		stat |= BROKEN


	power_change()

		if(stat & BROKEN)
			icon_state = (src.beaker?"mixer1_b":"mixer0_b")

		else if(powered())
			icon_state = (src.beaker?"mixer1":"mixer0")
			stat &= ~NOPOWER

		else
			spawn(rand(0, 15))
				src.icon_state = (src.beaker?"mixer1_nopower":"mixer0_nopower")
				stat |= NOPOWER


	Topic(href, href_list)
		if(stat & (NOPOWER|BROKEN)) return
		if(usr.stat || usr.restrained()) return
		if(!in_range(src, usr)) return

		usr.machine = src
		if(!beaker) return

		if (href_list["create_vaccine"])
			if(!src.wait)
				var/obj/item/weapon/reagent_containers/glass/bottle/B = new/obj/item/weapon/reagent_containers/glass/bottle(src.loc)
				var/vaccine_type = text2path(href_list["create_vaccine"])//the path is received as string - converting
				var/datum/disease/D = new vaccine_type
				var/name = strip_html(input(usr,"Name:","Name the vaccine",D.name))
				if(!name || name == " ") name = D.name
				B.name = "[name] vaccine bottle"
				B.reagents.add_reagent("vaccine",15,vaccine_type)
				score_researchdone++
				del(D)
				wait = 1
				spawn(1200)
					src.wait = null
			else
				src.temphtml = "The replicator is not ready yet."
			src.updateUsrDialog()
			return
		else if (href_list["create_virus_culture"])
			if(!wait)
				var/obj/item/weapon/reagent_containers/glass/bottle/B = new/obj/item/weapon/reagent_containers/glass/bottle(src.loc)
				B.icon_state = "bottle3"
				var/type = text2path(href_list["create_virus_culture"])//the path is received as string - converting
				var/datum/disease/D = new type
				var/list/data = list("viruses"=list(D))
				var/name = strip_html(input(usr,"Name:","Name the culture",D.name))
				if(!name || name == " ") name = D.name
				B.name = "[name] culture bottle"
				B.desc = "A small bottle. Contains [D.agent] culture in synthblood medium."
				B.reagents.add_reagent("blood",20,data)
				src.updateUsrDialog()
				wait = 1
				spawn(3000)
					src.wait = null
			else
				src.temphtml = "The replicator is not ready yet."
			src.updateUsrDialog()
			return
		else if (href_list["empty_beaker"])
			beaker.reagents.clear_reagents()
			src.updateUsrDialog()
			return
		else if (href_list["eject"])
			beaker:loc = src.loc
			beaker = null
			icon_state = "mixer0"
			src.updateUsrDialog()
			return
		else if(href_list["clear"])
			src.temphtml = ""
			src.updateUsrDialog()
			return
		else
			usr << browse(null, "window=pandemic")
			src.updateUsrDialog()
			return

		src.add_fingerprint(usr)
		return

	attack_ai(mob/user as mob)
		return src.attack_hand(user)

	attack_paw(mob/user as mob)
		return src.attack_hand(user)

	attack_hand(mob/user as mob)
		if(stat & (NOPOWER|BROKEN))
			return
		user.machine = src
		var/dat = ""
		if(src.temphtml)
			dat = "[src.temphtml]<BR><BR><A href='?src=\ref[src];clear=1'>Main Menu</A>"
		else if(!beaker)
			dat += "Please insert beaker.<BR>"
			dat += "<A href='?src=\ref[user];mach_close=pandemic'>Close</A>"
		else
			var/datum/reagents/R = beaker.reagents
			var/datum/reagent/blood/Blood = null
			for(var/datum/reagent/blood/B in R.reagent_list)
				if(B)
					Blood = B
					break
			if(!R.total_volume||!R.reagent_list.len)
				dat += "The beaker is empty<BR>"
			else if(!Blood)
				dat += "No blood sample found in beaker"
			else
				dat += "<h3>Blood sample data:</h3>"
				dat += "<b>Blood DNA:</b> [(Blood.data["blood_DNA"]||"none")]<BR>"
				dat += "<b>Blood Type:</b> [(Blood.data["blood_type"]||"none")]<BR>"


				if(Blood.data["viruses"])
					var/list/vir = Blood.data["viruses"]
					if(vir.len)
						for(var/datum/disease/D in Blood.data["viruses"])
							if(!D.hidden[PANDEMIC])
								if(!(D.mutated))
									dat += "<b>Disease Agent:</b> [D?"[D.agent] - <A href='?src=\ref[src];create_virus_culture=[D.type]'>Create virus culture bottle</A>":"none"]<BR>"
								else
									dat += "<b>Disease Agent:</b> [D.agent] - Cannot Replicate<BR>"
								dat += "<b>Common name:</b> [(D.name||"none")]<BR>"
								dat += "<b>Description: </b> [(D.desc||"none")]<BR>"
				dat += "<b>Contains antibodies to:</b> "
				if(Blood.data["resistances"])
					var/list/res = Blood.data["resistances"]
					if(res.len)
						dat += "<ul>"
						for(var/type in Blood.data["resistances"])
							var/datum/disease/DR = new type
							dat += "<li>[DR.name] - <A href='?src=\ref[src];create_vaccine=[type]'>Create vaccine bottle</A></li>"
							del(DR)
						dat += "</ul><BR>"
					else
						dat += "nothing<BR>"
				else
					dat += "nothing<BR>"
			dat += "<BR><A href='?src=\ref[src];eject=1'>Eject beaker</A>[((R.total_volume&&R.reagent_list.len) ? "-- <A href='?src=\ref[src];empty_beaker=1'>Empty beaker</A>":"")]<BR>"
			dat += "<A href='?src=\ref[user];mach_close=pandemic'>Close</A>"

		user << browse("<TITLE>[src.name]</TITLE><BR>[dat]", "window=pandemic;size=575x400")
		onclose(user, "pandemic")
		return

	attackby(var/obj/I as obj, var/mob/user as mob)
		if(istype(I, /obj/item/weapon/screwdriver))
			playsound(src.loc, 'Screwdriver.ogg', 50, 1)
			if(do_after(user, 20))
				if (src.stat & BROKEN)
					user << "\blue The broken glass falls out."
					var/obj/computerframe/A = new /obj/computerframe(src.loc)
					new /obj/item/weapon/shard(src.loc)
					var/obj/item/weapon/circuitboard/pandemic/M = new /obj/item/weapon/circuitboard/pandemic(A)
					for (var/obj/C in src)
						C.loc = src.loc
					A.circuit = M
					A.state = 3
					A.icon_state = "3"
					A.anchored = 1
					del(src)
				else
					user << "\blue You disconnect the monitor."
					var/obj/computerframe/A = new /obj/computerframe( src.loc )
					var/obj/item/weapon/circuitboard/pandemic/M = new /obj/item/weapon/circuitboard/pandemic(A)
					for (var/obj/C in src)
						C.loc = src.loc
					A.circuit = M
					A.state = 4
					A.icon_state = "4"
					A.anchored = 1
					del(src)
		else if(istype(I, /obj/item/weapon/reagent_containers/glass))
			if(stat & (NOPOWER|BROKEN)) return
			if(src.beaker)
				user << "A beaker is already loaded into the machine."
				return

			src.beaker =  I
			user.drop_item()
			I.loc = src
			user << "You add the beaker to the machine!"
			src.updateUsrDialog()
			icon_state = "mixer1"

		else
			..()
		return
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
/obj/machinery/reagentgrinder
	name = "Reagent Grinder"
	icon = 'kitchen.dmi'
	icon_state = "juicer1"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 100
	var/obj/item/weapon/reagent_containers/beaker = null
	var/global/list/allowed_items = list (
		/obj/item/stack/sheet/plasma = "plasma",
		/obj/item/stack/sheet/uranium = "uranium",
		/obj/item/stack/sheet/clown = "banana",
		/obj/item/stack/sheet/silver = "silver",
		/obj/item/stack/sheet/gold = "gold",
		/obj/item/weapon/reagent_containers/food/snacks/grown/banana = "banana",
		/obj/item/weapon/reagent_containers/food/snacks/grown/carrot = "imidazoline",
		/obj/item/weapon/reagent_containers/food/snacks/grown/corn = "cornoil",
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/libertycap = "psilocybin",
		/obj/item/weapon/reagent_containers/food/snacks/grown/chili = "capsaicin",
		/obj/item/weapon/reagent_containers/food/snacks/grown/icepepper = "frostoil",
		/obj/item/weapon/grown/nettle = "acid",
		/obj/item/weapon/grown/deathnettle = "pacid",
	)

/obj/machinery/reagentgrinder/New()
	..()
	beaker = new /obj/item/weapon/reagent_containers/glass/large(src)
	return

/obj/machinery/reagentgrinder/update_icon()
	icon_state = "juicer"+num2text(!isnull(beaker))
	return


/obj/machinery/reagentgrinder/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if (istype(O,/obj/item/weapon/reagent_containers/glass) || \
		istype(O,/obj/item/weapon/reagent_containers/food/drinks/drinkingglass))
		if (beaker)
			return 1
		else
			user.before_take_item(O)
			O.loc = src
			beaker = O
			src.verbs += /obj/machinery/reagentgrinder/verb/detach
			update_icon()
			src.updateUsrDialog()
			return 0
	if (!is_type_in_list(O, allowed_items))
		user << "Cannot refine into a reagent."
		return 1
	user.before_take_item(O)
	O.loc = src
	src.updateUsrDialog()
	return 0

/obj/machinery/reagentgrinder/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/reagentgrinder/attack_ai(mob/user as mob)
	return 0

/obj/machinery/reagentgrinder/attack_hand(mob/user as mob)
	user.machine = src
	interact(user)

/obj/machinery/reagentgrinder/proc/interact(mob/user as mob) // The microwave Menu
	var/is_chamber_empty = 0
	var/is_beaker_ready = 0
	var/processing_chamber = ""
	var/beaker_contents = ""

	for (var/i in allowed_items)
		for (var/obj/item/O in src.contents)
			if (!istype(O,i))
				continue
			processing_chamber+= "some <B>[O]</B><BR>"
			break
	if (!processing_chamber)
		is_chamber_empty = 1
		processing_chamber = "Nothing."
	if (!beaker)
		beaker_contents = "\The [src] has no beaker attached."
	else if (!beaker.reagents.total_volume)
		beaker_contents = "\The [src]  has attached an empty beaker."
		is_beaker_ready = 1
	else if (beaker.reagents.total_volume < beaker.reagents.maximum_volume)
		beaker_contents = "\The [src]  has attached a beaker with something."
		is_beaker_ready = 1
	else
		beaker_contents = "\The [src]  has attached a beaker and the beaker is full!"

	var/dat = {"
<b>Processing chamber contains:</b><br>
[processing_chamber]<br>
[beaker_contents]<hr>
"}
	if (is_beaker_ready && !is_chamber_empty && !(stat & (NOPOWER|BROKEN)))
		dat += "<A href='?src=\ref[src];action=grind'>Turn on!<BR>"
	if (beaker)
		dat += "<A href='?src=\ref[src];action=detach'>Detach the beaker!<BR>"
	user << browse("<HEAD><TITLE>Reagent Grinder</TITLE></HEAD><TT>[dat]</TT>", "window=reagentgrinder")
	onclose(user, "reagentgrinder")
	return


/obj/machinery/reagentgrinder/Topic(href, href_list)
	if(..())
		return
	usr.machine = src
	switch(href_list["action"])
		if ("grind")
			grind()

		if ("detach")
			detach()
	src.updateUsrDialog()
	return

/obj/machinery/reagentgrinder/verb/detach()
	set category = "Object"
	set name = "Detach Beaker from the grinder"
	set src in oview(1)
	if (usr.stat != 0)
		return
	if (!beaker)
		return
	src.verbs -= /obj/machinery/reagentgrinder/verb/detach
	beaker.loc = src.loc
	beaker = null
	update_icon()

/obj/machinery/reagentgrinder/proc/get_juice_id(var/obj/item/weapon/reagent_containers/food/snacks/grown/O)
	for (var/i in allowed_items)
		if (istype(O, i))
			return allowed_items[i]

/obj/machinery/reagentgrinder/proc/get_juice_amount(var/obj/item/weapon/reagent_containers/food/snacks/grown/O)
	if (!istype(O))
		return 5
	else if (O.potency == -1)
		return 5
	else
		return round(O.potency / 5)

/obj/machinery/reagentgrinder/proc/get_grownweapon_id(var/obj/item/weapon/grown/O)
	for (var/i in allowed_items)
		if (istype(O, i))
			return allowed_items[i]

/obj/machinery/reagentgrinder/proc/get_grownweapon_amount(var/obj/item/weapon/grown/O)
	if (!istype(O))
		return 5
	else if (O.potency == -1)
		return 5
	else
		return round(O.potency)

/obj/machinery/reagentgrinder/proc/get_grind_id(var/obj/item/stack/sheet/O)
	for (var/i in allowed_items)
		if (istype(O, i))
			return allowed_items[i]

/obj/machinery/reagentgrinder/proc/get_grind_amount(var/obj/item/stack/sheet/O)
	return 20

/obj/machinery/reagentgrinder/proc/grind()
	power_change()
	if(stat & (NOPOWER|BROKEN))
		return
	if (!beaker || beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
		return
	playsound(src.loc, 'juicer.ogg', 20, 1)
	for (var/obj/item/weapon/reagent_containers/food/snacks/O in src.contents)
		var/r_id = get_juice_id(O)
		beaker.reagents.add_reagent(r_id,get_juice_amount(O))
		del(O)
		if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break
	for (var/obj/item/stack/sheet/O in src.contents)
		var/g_id = get_grind_id(O)
		beaker.reagents.add_reagent(g_id,get_grind_amount(O))
		del(O)
		if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break
	for (var/obj/item/weapon/grown/O in src.contents)
		var/g_id = get_grownweapon_id(O)
		beaker.reagents.add_reagent(g_id,get_grownweapon_amount(O))
		del(O)
		if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break


//////////////////////////////////
//			Hotplate			//
//////////////////////////////////
/*        COMMENTED OUT UNTIL R.distribute_temperature_changes IS FIXED
/obj/machinery/hotplate/
	name = "hotplate"
	density = 0
	anchored = 1
	icon = 'chemical.dmi'
	icon_state = "hotplate"
	var/temperature = 290
	var/target_temp = 290
	var/obj/item/weapon/reagent_containers/glass/beaker = null
	var/icon/beakeroverlay
	proc
		adjust_temperature()
			if(temperature != target_temp)
				if(temperature > target_temp)
					temperature -= 3
				else
					if(stat & NOPOWER) return
					temperature += 3
					use_power(8)
				src.updateUsrDialog()
			if(beaker)
				if(beaker.reagents.total_volume)
					for(var/datum/reagent/R in beaker.reagents.reagent_list)
						R.distribute_temperature_changes(temperature)
			spawn(10) adjust_temperature()

	New()
		spawn(20)
		adjust_temperature()

	update_icon()
		if(beaker)
			beakeroverlay = beaker
			overlays += beakeroverlay
		else
			overlays -= beakeroverlay
			overlays = null		//Will remove once fully polished

	ex_act(severity)
		switch(severity)
			if(1.0)
				del(src)
				return
			if(2.0)
				if (prob(50))
					del(src)
					return

	blob_act()
		if (prob(50))
			del(src)

	meteorhit()
		del(src)
		return

	Topic(href, href_list)
		if(usr.stat || usr.restrained()) return
		if (((get_dist(src, usr) <= 1) && istype(src.loc, /turf)))

			usr.machine = src

			if (href_list["temp_add"])
				var/tdiff = text2num(href_list["temp_add"])
				if(tdiff)
					target_temp += tdiff
				if(target_temp < 290)
					target_temp = 290
				if(target_temp > 950)
					target_temp = 950
			if (href_list["temp_sub"])
				var/sdiff = text2num(href_list["temp_sub"])
				if(sdiff)
					target_temp -= sdiff
				if(target_temp < 290)
					target_temp = 290
				if(target_temp > 950)
					target_temp = 950
			if (href_list["eject"])
				beaker:loc = src.loc
				beaker = null
				update_icon()
			src.updateUsrDialog()
			src.add_fingerprint(usr)
			update_icon()
		else
			usr << browse(null, "window=hotplate")
			return
		return

	attack_ai(mob/user as mob)
		return src.attack_hand(user)

	attack_paw(mob/user as mob)
		return src.attack_hand(user)

	attack_hand(mob/user as mob)
		user.machine = src
		var/dat = {"<B>Beaker Hotplate</B><BR>
			Target temperature: <A href='?src=\ref[src];temp_sub=50.0'>-</A> <A href='?src=\ref[src];temp_sub=10.0'>-</A> <A href='?src=\ref[src];temp_sub=5.0'>-</A> <A href='?src=\ref[src];temp_sub=1.0'>-</A> [target_temp]&deg;K <A href='?src=\ref[src];temp_add=1.0'>+</A> <A href='?src=\ref[src];temp_add=5.0'>+</A> <A href='?src=\ref[src];temp_add=10.0'>+</A> <A href='?src=\ref[src];temp_add=50.0'>+</A><BR>
			Burner temperature: [temperature]&deg;K<BR>
			<HR>
			<A href='?src=\ref[src];eject=1'>Eject beaker</A><BR>
			<A href='?src=\ref[user];mach_close=hotplate'>Close</A><BR>
			"}
		user << browse(dat, "window=hotplate;size=300x150")
		onclose(user, "hotplate")
		return

	attackby(var/obj/item/I as obj, var/mob/user as mob)
		if(istype(I, /obj/item/weapon/reagent_containers/glass/thermometer))
			if(beaker)
				I.afterattack(beaker, user, null)
				return
		if(istype(I, /obj/item/weapon/reagent_containers/glass))
			if(beaker)
				user << "The [src.name] already has a beaker on it."
				return

			beaker =  I
			user.drop_item()
			I.loc = src
			user << "You set the [I.name] on the [src.name]!"
			update_icon()
			updateUsrDialog()
		if(istype(I, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = I
			for(var/mob/O in viewers(world.view, src))
				O.show_message(text("\red <B>[user] presses [G.affecting.name]'s face onto the [src.name]!"), 1)
			G.affecting:handle_temperature_damage(HEAD, temperature, 1)

/obj/machinery/coldplate/
	name = "coldplate"
	density = 0
	anchored = 1
	icon = 'chemical.dmi'
	icon_state = "hotplate"
	var/temperature = 290
	var/target_temp = 290
	var/obj/item/weapon/reagent_containers/glass/beaker = null
	var/icon/beakeroverlay
	proc
		adjust_temperature()
			if(temperature != target_temp)
				if(temperature > target_temp)
					temperature -= 3
				else
					if(stat & NOPOWER) return
					temperature += 3
					use_power(8)
				src.updateUsrDialog()
			if(beaker)
				if(beaker.reagents.total_volume)
					for(var/datum/reagent/R in beaker.reagents.reagent_list)
						R.distribute_temperature_changes(temperature)
			spawn(10) adjust_temperature()

	New()
		spawn(20)
		adjust_temperature()

	update_icon()
		if(beaker)
			beakeroverlay = beaker
			overlays += beakeroverlay
		else
			overlays -= beakeroverlay
			overlays = null		//Will remove once fully polished

	ex_act(severity)
		switch(severity)
			if(1.0)
				del(src)
				return
			if(2.0)
				if (prob(50))
					del(src)
					return

	blob_act()
		if (prob(50))
			del(src)

	meteorhit()
		del(src)
		return

	Topic(href, href_list)
		if(usr.stat || usr.restrained()) return
		if (((get_dist(src, usr) <= 1) && istype(src.loc, /turf)))

			usr.machine = src

			if (href_list["temp_add"])
				var/tdiff = text2num(href_list["temp_add"])
				if(tdiff)
					target_temp += tdiff
				if(target_temp > 290)
					target_temp = 290
				if(target_temp < 10)
					target_temp = 10
			if (href_list["temp_sub"])
				var/sdiff = text2num(href_list["temp_sub"])
				if(sdiff)
					target_temp -= sdiff
				if(target_temp > 290)
					target_temp = 290
				if(target_temp < 10)
					target_temp = 10
			if (href_list["eject"])
				beaker:loc = src.loc
				beaker = null
				update_icon()
			src.updateUsrDialog()
			src.add_fingerprint(usr)
			update_icon()
		else
			usr << browse(null, "window=coldplate")
			return
		return

	attack_ai(mob/user as mob)
		return src.attack_hand(user)

	attack_paw(mob/user as mob)
		return src.attack_hand(user)

	attack_hand(mob/user as mob)
		user.machine = src
		var/dat = {"<B>Beaker Coldplate</B><BR>
			Target temperature: <A href='?src=\ref[src];temp_sub=50.0'>-</A> <A href='?src=\ref[src];temp_sub=10.0'>-</A> <A href='?src=\ref[src];temp_sub=5.0'>-</A> <A href='?src=\ref[src];temp_sub=1.0'>-</A> [target_temp]&deg;K <A href='?src=\ref[src];temp_add=1.0'>+</A> <A href='?src=\ref[src];temp_add=5.0'>+</A> <A href='?src=\ref[src];temp_add=10.0'>+</A> <A href='?src=\ref[src];temp_add=50.0'>+</A><BR>
			Burner temperature: [temperature]&deg;K<BR>
			<HR>
			<A href='?src=\ref[src];eject=1'>Eject beaker</A><BR>
			<A href='?src=\ref[user];mach_close=hotplate'>Close</A><BR>
			"}
		user << browse(dat, "window=coldplate;size=300x150")
		onclose(user, "coldplate")
		return

	attackby(var/obj/item/I as obj, var/mob/user as mob)
		if(istype(I, /obj/item/weapon/reagent_containers/glass/thermometer))
			if(beaker)
				I.afterattack(beaker, user, null)
				return
		if(istype(I, /obj/item/weapon/reagent_containers/glass))
			if(beaker)
				user << "The [src.name] already has a beaker on it."
				return

			beaker =  I
			user.drop_item()
			I.loc = src
			user << "You set the [I.name] on the [src.name]!"
			update_icon()
			updateUsrDialog()
		if(istype(I, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = I
			for(var/mob/O in viewers(world.view, src))
				O.show_message(text("\red <B>[user] presses [G.affecting.name]'s face onto the [src.name]!"), 1)
			G.affecting:handle_temperature_damage(HEAD, temperature, 1)
*/


// Old Chemical Replicator

/obj/machinery/Medicinereplicator
	name = "Medicine Replicator"
	density = 1
	anchored = 1
	icon = 'chemical.dmi'
	icon_state = "replicator01"
	var/energy = 0
	var/max_energy = 3
	var/list/dispensable_reagents = list()
	var/beaker = null
	var/obj/item/weapon/cell/cell = null
	var/state = 0 // 1 on / 2 off/  3 open off / 4 open on
	var/on = 0

/obj/machinery/microscope
	name = "Microscope"
	density = 1
	anchored = 1
	icon = 'chemical.dmi'
	icon_state = "umm0"
	var/energy = 0
	var/max_energy = 3
	var/list/dispensable_reagents = list()
	var/beaker = null
	var/obj/item/weapon/cell/cell = null
	var/state = 0 // 1 on / 2 off/  3 open off / 4 open on
	var/on = 0
	New()
		var/datum/reagents/R = new/datum/reagents(100)
		reagents = R
		R.my_atom = src

	ex_act(severity)
		switch(severity)
			if(1.0)
				del(src)
				return
			if(2.0)
				if (prob(50))
					del(src)
					return

	blob_act()
		if (prob(50))
			del(src)

	meteorhit()
		del(src)
		return

	attackby(var/obj/item/weapon/reagent_containers/glass/beaker/petri/B as obj, var/mob/user as mob)
		if(!istype(B, /obj/item/weapon/reagent_containers/glass/beaker/petri))
			return

		if(src.beaker)
			user << "The machine is already loaded!"
			return
		src.beaker =  B
		user.drop_item()
		B.loc = src
		user << "You add the [B.name] to the machine!"
//		if(istype(B, /obj/item/weapon/reagent_containers/glass/beaker/petri))
//			user << "\blue The [B.name] falls out of the machine!"
//			B.loc = src.loc
//			beaker = null
//			return
		icon_state = "umm1"

	attack_ai(mob/user as mob)
		return src.attack_hand(user)

	attack_paw(mob/user as mob)
		return src.attack_hand(user)

	attack_hand(mob/user as mob)

		if(usr.stat || usr.restrained()) return
		if(!in_range(src, usr)) return
		usr.machine = src
		if(!beaker) return
		var/datum/reagents/R = beaker:reagents
		if(R.reagent_list.len < 1)
			user << "The dish is empty"
			beaker:loc = src.loc
			beaker = null
			icon_state = "umm0"

		for(var/datum/reagent/G in R.reagent_list)
			if(prob(85))
				user << "\blue Seems to be [G.name]."
				sleep(12)
				beaker:loc = src.loc
				beaker = null
				icon_state = "umm0"
			else
				user << "\red You have failed to identify the chemical."
				sleep(12)
				beaker:loc = src.loc
				beaker = null
				icon_state = "umm0"


/obj/machinery/Medicinereplicator/process()
	recharge()
	updateicon()
	if(cell && state == 1)


	else
		on = 0

/obj/machinery/Medicinereplicator/proc/recharge()
	if(stat & BROKEN)
		if(energy != max_energy)
			energy++
			cell.charge -= 2500
	else
		if(energy != max_energy)
			energy++
			var/added = cell.give(2500)
			use_power(added / CELLRATE)

/obj/machinery/Medicinereplicator/proc/updateicon()
	if(beaker)
		icon_state = "replicatorB[on][state]"
	else
		icon_state = "replicator[on][state]"

	if(beaker)
		icon_state = "replicatorB[on][state]"
	else
		icon_state = "replicator[on][state]"

/obj/machinery/Medicinereplicator/New()
	recharge()

/obj/machinery/Medicinereplicator/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(50))
				del(src)
				return

/obj/machinery/Medicinereplicator/blob_act()
	if (prob(50))
		del(src)

/obj/machinery/Medicinereplicator/meteorhit()
	del(src)
	return

/obj/machinery/Medicinereplicator/Topic(href, href_list)
	if(stat & BROKEN) return
	if(usr.stat || usr.restrained()) return
	if(!in_range(src, usr)) return
	usr.machine = src
	if (href_list["eject"])
		beaker:loc = src.loc
		beaker = null
		updateicon()

	if (href_list["add"])
		var/datum/reagents/R = beaker:reagents
		for(var/datum/reagent/G in R.reagent_list)
			if(G.medical)
				src.dispensable_reagents -= "[G.id]"
				spawn(2)
				src.dispensable_reagents += "[G.id]"
				usr << "Reagent has been added to the matrix."
				G = null
				beaker:loc = src.loc
				beaker = null
				updateicon()
				src.updateDialog()

	if (href_list["dispense"])
		if(!energy)
			var/dat = "Not enough energy.<BR><A href='?src=\ref[src];ok=1'>OK</A>"
			usr << browse("<TITLE>Medicine Replicator</TITLE>Medicine Replicator:<BR>Energy = [energy]/[max_energy]<BR><BR>[dat]", "window=chem_dispenser")
			return
		var/id = href_list["dispense"]
		var/obj/item/weapon/reagent_containers/glass/bottle/small/G = new/obj/item/weapon/reagent_containers/glass/bottle/small(src.loc)
		G.name = "[(href_list["name"])] bottle"
		G.reagents.add_reagent(id,15)
		energy--
		src.updateUsrDialog()
		return
	else
		usr << browse(null, "window=chem_dispenser;size=500x700")
		return

	src.add_fingerprint(usr)
	return

/obj/machinery/Medicinereplicator/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/Medicinereplicator/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/Medicinereplicator/attack_hand(mob/user as mob)
	if(state == 1 && cell)
		usr.put_in_hand(cell)
		cell.add_fingerprint(user)
		cell.updateicon()
		src.cell = null
		user.visible_message("[user] removes the cell from the Medicine replicator.", "You remove the cell from the Medicine replicator.")
		updateicon()
		return

	if(!cell)
		user.visible_message("There is no power cell in the Medicine Replicator.")
		return

	if(cell.charge <= 100)
		user.visible_message("Medicine replicator tries to power up then goes silent and inactive.", "the Medicine replicator has no power.")
		cell.charge = 0
		on = 0
		return

	if(src.beaker)
		user.machine = src
		var/ej = "<A href='?src=\ref[src];eject=1'>Eject Beaker</A>"
		var/dat = ""
		var/datum/reagents/R = beaker:reagents
		for(var/datum/reagent/G in R.reagent_list)
			dat += "Structural analysis:<BR><B>[G.name]</B><BR></A><BR>"
			dat += "[G.description]<BR><BR>"
			if(G.medical == 1)
				dat += "<A href='?src=\ref[src];add=1'>Add to creation matrix</A><br><br>"
			else
				dat += "<font color=\"darkred\">This chemical serves no medical purpose.</font></A><BR><br>"
		user << browse("<TITLE>Medicine Replicator</TITLE>Medicine Replicator:<BR>Energy = [energy]/[max_energy]<BR><BR>[dat]<br>[ej]", "window=chem_dispenser")
		onclose(user, "chem_dispenser;size=500x700")
	else
		user.machine = src
		var/dat = ""
		for(var/re in dispensable_reagents)
			for(var/da in typesof(/datum/reagent) - /datum/reagent)
				var/datum/reagent/temp = new da()
				if(temp.id == re)
					dat += "<A href='?src=\ref[src];dispense=[temp.id];state=[temp.reagent_state];name=[temp.name]'>[temp.name]</A><BR>"
					dat += "[temp.description]<BR><BR>"
		user << browse("<TITLE>Medicine Replicator</TITLE>Medicine Replicator:<BR>Energy = [energy]/[max_energy]<BR><BR>[dat]<br>", "window=chem_dispenser")

	onclose(user, "chem_dispenser;size=500x700")
	return


/obj/machinery/Medicinereplicator/attackby(var/obj/item/weapon/reagent_containers/glass/B as obj, var/mob/user as mob)
	if(istype(B, /obj/item/weapon/crowbar) && state == 0)
		on = 0
		state = 1
		updateicon()

	if(!(istype(B, /obj/item/weapon/reagent_containers/glass) || !(istype(B, /obj/item/weapon/cell))))
		return

	if(istype(B, /obj/item/weapon/cell) && !cell)
		cell = B
		B.loc = src
		state = 0
		on = 1
		updateicon()
		return

	if(src.beaker && istype(B, /obj/item/weapon/reagent_containers/glass))
		user << "A beaker is already loaded into the machine."

	else if(istype(B, /obj/item/weapon/reagent_containers/glass))
		src.beaker =  B
		user.drop_item()
		B.loc = src
		user << "You add the beaker to the machine!"
		src.updateUsrDialog()
		updateicon()