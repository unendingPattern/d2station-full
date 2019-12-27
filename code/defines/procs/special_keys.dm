/proc/apply_cluwne()
	for(var/mob/living/carbon/human/M in mobz)
		if(check_cluwnelist(M))
		//	M:brainloss = 60
			M:spawnId("[pick("CAPTIAN", "hed of speshul stuf", "monkie keepr", "sekurity ofiser")] (scribbled in crayon)")
			var/obj/item/clothing/mask/gas/clown_hat/clownmask = new /obj/item/clothing/mask/gas/clown_hat(M)
			var/obj/item/clothing/shoes/clown_shoes/clownshoes = new /obj/item/clothing/shoes/clown_shoes(M)
			var/obj/item/clothing/under/rank/clown/clownsuit = new /obj/item/clothing/under/rank/clown(M)
			clownsuit.canremove = 0
			clownshoes.canremove = 0
			clownmask.canremove = 0

			M:equip_if_possible(clownshoes, M:slot_shoes)
			M:equip_if_possible(clownmask, M:slot_wear_mask)
			M:equip_if_possible(clownsuit, M:slot_w_uniform)
	return


/mob/proc/apply_loadouts(M)

	if((M:key == "-faggqt") && (M:name == "Erika Treial") || (M:name == "Elena Vorobyova"))
		//Nazi
		var/obj/item/clothing/under/nazi/sgirl = new /obj/item/clothing/under/nazi(M)
		var/obj/item/clothing/shoes/jackboots/boots = new /obj/item/clothing/shoes/jackboots(M)
		//var/obj/item/clothing/suit/nazicoat/erika/coat = new /obj/item/clothing/suit/nazicoat/erika(M)
		var/obj/item/clothing/glasses/regular/rglasses = new /obj/item/clothing/glasses/hipster(M)

		M:equip_if_possible(boots, M:slot_shoes)
		M:equip_if_possible(glasses, M:slot_glasses)
		M:equip_if_possible(sgirl, M:slot_w_uniform)
		//M:equip_if_possible(coat, M:slot_wear_suit)

	if((M:key == "SofiaHurr"))
		//Kitty
		var/obj/item/clothing/under/vriska/sgirl = new /obj/item/clothing/under/vriska(M)
		var/obj/item/clothing/shoes/brown/shoes = new /obj/item/clothing/shoes/brown(M)
		var/obj/item/clothing/head/kitty/kittyears = new /obj/item/clothing/head/kitty(M)
		var/obj/item/clothing/glasses/regular/hipster/glasses = new /obj/item/clothing/glasses/regular/hipster(M)

		M:equip_if_possible(shoes, M:slot_shoes)
		M:equip_if_possible(glasses, M:slot_glasses)
		M:equip_if_possible(sgirl, M:slot_w_uniform)
		M:equip_if_possible(kittyears, M:slot_head)

/*
	//PERMA LOADOUTS DONE HERE
	var/gethead = world.Export("http://78.47.53.54/requester.php?url=http://178.63.153.81/emauth.php@vals@ckey=[M:ckey]@and@getLoadout@and@head")
	if(gethead)
		gethead = file2text(gethead["CONTENT"])
	if((gethead) && (gethead != "NA") && (gethead != "0"))
		var/equip = gethead
		M:equip_if_possible(new equip(M), M:slot_head)

	var/getsuit = world.Export("http://78.47.53.54/requester.php?url=http://178.63.153.81/emauth.php@vals@ckey=[M:ckey]@and@getLoadout@and@suit")
	if(getsuit)
		getsuit = file2text(getsuit["CONTENT"])
	if((getsuit) && (getsuit != "NA") && (getsuit != "0"))
		var/equip = getsuit
		M:equip_if_possible(new equip(M), M:slot_wear_suit)

	var/getuniform = world.Export("http://78.47.53.54/requester.php?url=http://178.63.153.81/emauth.php@vals@ckey=[M:ckey]@and@getLoadout@and@uniform")
	if(getuniform)
		getuniform = file2text(getuniform["CONTENT"])
	if((getuniform) && (getuniform != "NA") && (getuniform != "0"))
		var/equip = getuniform
		M:equip_if_possible(new equip(M), M:slot_w_uniform)

	var/geteyes = world.Export("http://78.47.53.54/requester.php?url=http://178.63.153.81/emauth.php@vals@ckey=[M:ckey]@and@getLoadout@and@eyes")
	if(geteyes)
		geteyes = file2text(geteyes["CONTENT"])
	if((geteyes) && (geteyes != "NA") && (geteyes != "0"))
		var/equip = geteyes
		M:equip_if_possible(new equip(M), M:slot_glasses)

	var/getgloves = world.Export("http://78.47.53.54/requester.php?url=http://178.63.153.81/emauth.php@vals@ckey=[M:ckey]@and@getLoadout@and@gloves")
	if(getgloves)
		getgloves = file2text(getgloves["CONTENT"])
	if((getgloves) && (getgloves != "NA") && (getgloves != "0"))
		var/equip = getgloves
		M:equip_if_possible(new equip(M), M:slot_gloves)

	var/getshoes = world.Export("http://78.47.53.54/requester.php?url=http://178.63.153.81/emauth.php@vals@ckey=[M:ckey]@and@getLoadout@and@shoes")
	if(getshoes)
		getshoes = file2text(getshoes["CONTENT"])
	if((getshoes) && (getshoes != "NA") && (getshoes != "0"))
		var/equip = getshoes
		M:equip_if_possible(new equip(M), M:slot_shoes)
*/


	if((M:name == "Rainbow Dash") || (M:name == "Pinkie Pie") || (M:name == "Derpy Hooves")  || (M:name == "Apple Jack") || (M:name == "Twilight Sparkle") || (M:name == "Princess Celestia") || (M:name == "Big Mac") || (M:name == "Fluttershy") || (M:name == "Flutter Shy")|| (M:name == "Sweetie Belle") || (M:name == "Big Macintosh") || (M:name == "Cup Cake") || (M:name == "Filthy Rich") || (M:name == "Granny Smith") || (M:name == "Hoity Toity") || (M:name == "Photo Finish") || (M:name == "Sapphire Shoes") || (M:name == "Flutter Shy") || (M:name == "Flutter Shy") || (M:name == "Daring Do") || (M:name == "Princess Cadance") || (M:name == "Princess Celestia") || (M:name == "Princess Luna") || (M:name == "Prince Blueblood") || (M:name == "Shining Armor"))
		//M:mutantrace = "brony"
		M:name = pick("reinbow doeash", "ponkkie pei", "durpy huve", "appelo jack", "tweligh spekrle", "princceqs cresltestia", "chicken nuggets", "flotaer shit")
		//M << sound('browny.ogg')
	return