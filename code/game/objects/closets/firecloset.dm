/obj/closet/firecloset/New()
	..()

	if (prob (1))
		del(src)
		return

	new /obj/item/clothing/mask/gas(src)
	new /obj/item/weapon/tank/emergency_oxygen(src)
	new /obj/item/weapon/extinguisher(src)
	new /obj/item/clothing/suit/fire/firefighter(src)

	/*switch (pickweight(list("nothing" = 5, "bare-bones" = 35, "basic" = 40, "pickpocketed" = 10, "untouched" = 10)))
		if ("nothing")
			//better luck next time
		if ("bare-bones")
			new /obj/item/weapon/extinguisher(src)
		if ("basic")
			new /obj/item/clothing/mask/breath(src)
			new /obj/item/weapon/tank/emergency_oxygen(src)
			new /obj/item/weapon/extinguisher(src)
		if ("pickpocketed")   //suit got stolen
			new /obj/item/clothing/mask/breath(src)
			new /obj/item/weapon/tank/oxygen(src)
			new /obj/item/weapon/extinguisher(src)
			new /obj/item/clothing/head/helmet/hardhat(src)
		if ("untouched")
			new /obj/item/clothing/mask/breath(src)
			new /obj/item/weapon/tank/oxygen(src)
			new /obj/item/weapon/extinguisher(src)
			new /obj/item/clothing/suit/fire/firefighter(src)
			new /obj/item/clothing/head/helmet/hardhat(src)*/

/obj/closet/firecloset_withaxe/New()
	..()

	if (prob (1))
		del(src)
		return

	new /obj/item/clothing/mask/gas(src)
	new /obj/item/weapon/tank/emergency_oxygen(src)
	new /obj/item/weapon/extinguisher(src)
	new /obj/item/weapon/fireaxe(src)
	new /obj/item/clothing/suit/fire/firefighter(src)

	/*switch (pickweight(list("nothing" = 5, "bare-bones" = 35, "basic" = 40, "pickpocketed" = 10, "untouched" = 10)))
		if ("nothing")
			//better luck next time
		if ("bare-bones")
			new /obj/item/weapon/extinguisher(src)
		if ("basic")
			new /obj/item/clothing/mask/breath(src)
			new /obj/item/weapon/tank/emergency_oxygen(src)
			new /obj/item/weapon/extinguisher(src)
		if ("pickpocketed")   //suit got stolen
			new /obj/item/clothing/mask/breath(src)
			new /obj/item/weapon/tank/oxygen(src)
			new /obj/item/weapon/extinguisher(src)
			new /obj/item/clothing/head/helmet/hardhat(src)
		if ("untouched")
			new /obj/item/clothing/mask/breath(src)
			new /obj/item/weapon/tank/oxygen(src)
			new /obj/item/weapon/extinguisher(src)
			new /obj/item/clothing/suit/fire/firefighter(src)
			new /obj/item/clothing/head/helmet/hardhat(src)*/