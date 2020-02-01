#define SOLID 1
#define LIQUID 2
#define GAS 3

/obj/machinery/chem_dispenser/
	name = "chem dispenser"
	density = 1
	anchored = 1
	icon = 'chemical.dmi'
	icon_state = "dispenser"
	var/energy = 25
	var/max_energy = 25
	var/list/dispensable_reagents = list("water","oxygen","nitrogen","hydrogen","potassium","sodium","mercury","copper","sulfur","carbon","chlorine","fluorine","phosphorus","lithium","acid","radium","iron","aluminium","silicon","plasma","sugar","ethanol")




	proc
		recharge()
			if(stat & BROKEN) return
			if(energy != max_energy)
				energy++
				use_power(500)
			spawn(600) recharge()

	New()
		recharge()

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
		if(stat & BROKEN) return
		if(usr.stat || usr.restrained()) return
		if(!in_range(src, usr)) return

		usr.machine = src

		if (href_list["dispense"])
			if(!energy)
				var/dat = "Not enough energy.<BR><A href='?src=\ref[src];ok=1'>OK</A>"
				usr << browse("<TITLE>Chemical Dispenser</TITLE>Chemical dispenser:<BR>Energy = [energy]/[max_energy]<BR><BR>[dat]", "window=chem_dispenser")
				return
			var/id = href_list["dispense"]
			var/obj/item/weapon/reagent_containers/glass/dispenser/G = new/obj/item/weapon/reagent_containers/glass/dispenser(src.loc)
			switch(text2num(href_list["state"]))
				if(LIQUID)
					G.icon_state = "liquid"
				if(GAS)
					G.icon_state = "vapour"
				if(SOLID)
					G.icon_state = "solid"
			G.name += " ([lowertext(href_list["name"])])"
			G.reagents.add_reagent(id,30)
			energy--
			src.updateUsrDialog()
			return
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
		for(var/re in dispensable_reagents)
			for(var/da in typesof(/datum/reagent) - /datum/reagent)
				var/datum/reagent/temp = new da()
				if(temp.id == re)
					dat += "<A href='?src=\ref[src];dispense=[temp.id];state=[temp.reagent_state];name=[temp.name]'>[temp.name]</A><BR>"
//					dat += "[temp.description]<BR><BR>"
		user << browse("<TITLE>Chemical Dispenser</TITLE>Chemical dispenser:<BR>Energy = [energy]/[max_energy]<BR><BR>[dat]", "window=chem_dispenser")

		onclose(user, "chem_dispenser")
		return
/*
/obj/machinery/chem_dispenser/pharmacy
	name = "pharmaceutical dispenser"
	density = 1
	anchored = 1
	icon = 'chemical.dmi'
	icon_state = 'meddispenser'
	energy = 10
	max_energy = 10
	dispensable_reagents = list("water","oxygen","nitrogen","carbon","potassium","silicon","sodium","iron","sugar")
*/

/obj/machinery/Medicinereplicator
	name = "Medicine Replicator"
	density = 1
	anchored = 1
	icon = 'chemical.dmi'
	icon_state = "replicator"
	var/energy = 5
	var/max_energy = 5
	var/list/dispensable_reagents = list()
	var/beaker = null

	proc
		recharge()
			if(stat & BROKEN) return
			if(energy != max_energy)
				energy++
			spawn(1200) recharge()

	New()
		recharge()

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
		if(stat & BROKEN) return
		if(usr.stat || usr.restrained()) return
		if(!in_range(src, usr)) return

		usr.machine = src
		if (href_list["eject"])
			beaker:loc = src.loc
			beaker = null
			icon_state = "replicator"

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
					src.icon_state = "replicator"
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

	attack_ai(mob/user as mob)
		return src.attack_hand(user)

	attack_paw(mob/user as mob)
		return src.attack_hand(user)

	attack_hand(mob/user as mob)
		if(stat & BROKEN)
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


	attackby(var/obj/item/weapon/reagent_containers/glass/B as obj, var/mob/user as mob)
		if(!istype(B, /obj/item/weapon/reagent_containers/glass))
			return

		if(src.beaker)
			user << "A beaker is already loaded into the machine."
			return

		src.beaker =  B
		user.drop_item()
		B.loc = src
		user << "You add the beaker to the machine!"
		src.updateUsrDialog()
		icon_state = "replicatorB"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
/obj/machinery/VirusSplice
	name = "Disease Splicer"
	density = 1
	anchored = 1
	icon = 'chemical.dmi'
	icon_state = "replicator"
	var/energy = 5
	var/max_energy = 5
	var/list/dispensable_reagents = list()
	var/beaker = null
	var/wait
	var
	blob_act()
		if (prob(50))
			del(src)

	meteorhit()
		del(src)
		return

	Topic(href, href_list)
		if(stat & BROKEN) return
		if(usr.stat || usr.restrained()) return
		if(!in_range(src, usr)) return

		usr.machine = src
		if (href_list["eject"])
			beaker:loc = src.loc
			beaker = null
			icon_state = "replicator"

		if (href_list["add"])
			var/datum/reagents/R = beaker:reagents
			for(var/datum/reagent/G in R.reagent_list)
				if(G.medical)
					src.dispensable_reagents -= "[G.id]"
					spawn(2)
					src.dispensable_reagents += "[G.id]"
					usr << "Reagent has been added to the matrix."
					beaker:loc = src.loc
					beaker = null
					src.icon_state = "replicator"
					src.updateDialog()

		if (href_list["dispense"])
			if(!energy)
				var/dat = "Not enough energy.<BR><A href='?src=\ref[src];ok=1'>OK</A>"
				usr << browse("<TITLE>Disease Splicer</TITLE>Disease Splicer:<BR>Energy = [energy]/[max_energy]<BR><BR>[dat]", "window=chem_dispenser")
				return
			var/id = href_list["dispense"]
			var/obj/item/weapon/reagent_containers/glass/bottle/small/G = new/obj/item/weapon/reagent_containers/glass/bottle/small(src.loc)
			G.name = "[(href_list["name"])] bottle"
			G.reagents.add_reagent(id,15)
			energy--
			src.updateUsrDialog()
			return
		else if (href_list["create_virus_culture"])
			if(!wait)
				if(prob(50))
					var/obj/item/weapon/reagent_containers/glass/bottle/B = new/obj/item/weapon/reagent_containers/glass/bottle(src.loc)
					B.icon_state = "bottle3"
					var/type = text2path(href_list["create_virus_culture"])//the path is received as string - converting
					var/datum/disease/D = new type
					var/list/data = list("virus"=D)
					var/name = sanitize(input(usr,"Name:","Name the culture",D.name))
					if(!name || name == " ") name = D.name
					B.name = "[name] culture bottle"
					B.desc = "A small bottle. Contains Mutated [D.agent] culture in synthblood medium."
					B.reagents.add_reagent("blood",20,data)
					src.updateUsrDialog()
					wait = 1
					spawn(3000)
						src.wait = null
				else if(prob(50))
					var/obj/item/weapon/reagent_containers/glass/bottle/B = new/obj/item/weapon/reagent_containers/glass/bottle(src.loc)
					B.icon_state = "bottle3"
					var/type = text2path(href_list["create_virus_culture"])//the path is received as string - converting
					var/datum/disease/D = new type
					var/list/data = list("virus"=D)
					var/name = sanitize(input(usr,"Name:","Name the culture",D.name))
					if(!name || name == " ") name = D.name
					B.name = "[name] culture bottle"
					B.desc = "A small bottle. Contains Mutated [D.agent] culture in synthblood medium."
					B.reagents.add_reagent("blood",20,data)
					src.updateUsrDialog()
					wait = 1
					spawn(3000)
						src.wait = null
			else
				src.temphtml = "The replicator is not ready yet."
		else
			usr << browse(null, "window=chem_dispenser;size=500x700")
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

		else if(!beaker)
			dat += "Please insert beaker.<BR>"
			dat += "<A href='?src=\ref[src];close=1'>Close</A>"

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
				var/datum/disease/D = Blood.data["virus"]
				dat += "<b>Agent of disease:</b> [D?"[D.agent] - <A href='?src=\ref[src];create_virus_culture=[D.type]'>Attempt to mutate virus</A>":"none"]<BR>"
				if(D)
					dat += "<b>Common name:</b> [(D.name||"none")]<BR>"
					dat += "<b>Possible cure:</b> [(D.cure||"none")]<BR>"
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
			dat += "<A href='?src=\ref[src];close=1'>Close</A>"

		onclose(user, "chem_dispenser;size=500x700")
		return


	attackby(var/obj/item/weapon/reagent_containers/glass/B as obj, var/mob/user as mob)
		if(!istype(B, /obj/item/weapon/reagent_containers/glass))
			return

		if(src.beaker)
			user << "A beaker is already loaded into the machine."
			return

		src.beaker =  B
		user.drop_item()
		B.loc = src
		user << "You add the beaker to the machine!"
		src.updateUsrDialog()
		icon_state = "replicatorB"

*/
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
		var/datum/reagents/R = new/datum/reagents(50)
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
			user << "A container is already loaded into the machine."
			return

		src.beaker =  B
		user.drop_item()
		B.loc = src
		user << "You add the container to the machine!"
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
			if(prob(50))
				var/obj/item/weapon/reagent_containers/pill/P = new/obj/item/weapon/reagent_containers/pill(src.loc)
				reagents.trans_to(P,50)
				var/name = input(usr,"Name:","Name your pill!",P.reagents.get_master_reagent_name())
				if(!name || name == " ") name = P.reagents.get_master_reagent_name()
				P.name = "[name] pill"
				reagents.trans_to(P,50)
			else
				var/obj/item/weapon/reagent_containers/pill/long/P = new/obj/item/weapon/reagent_containers/pill/long(src.loc)
				reagents.trans_to(P,50)
				var/name = input(usr,"Name:","Name your pill!",P.reagents.get_master_reagent_name())
				if(!name || name == " ") name = P.reagents.get_master_reagent_name()
				P.name = "[name] pill"
				reagents.trans_to(P,50)

		else if (href_list["createbottle"])
			if(!condi)
				var/name = input(usr,"Name:","Name your bottle!",reagents.get_master_reagent_name())
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
				var/name = input(usr,"Name:","Name the vaccine",D.name)
				if(!name || name == " ") name = D.name
				B.name = "[name] vaccine bottle"
				B.reagents.add_reagent("vaccine",30,vaccine_type)
				del(D)
				wait = 1
				spawn(500)
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
				var/list/data = list("virus"=D)
				var/name = sanitize(input(usr,"Name:","Name the culture",D.name))
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
				var/datum/disease/D = Blood.data["virus"]
				dat += "<b>Agent of disease:</b> [D?"[D.agent] - <A href='?src=\ref[src];create_virus_culture=[D.type]'>Create virus culture bottle</A>":"none"]<BR>"
				if(D)
					dat += "<b>Common name:</b> [(D.name||"none")]<BR>"
					dat += "<b>Possible cure:</b> [(D.cure||"none")]<BR>"
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