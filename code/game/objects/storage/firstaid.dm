
/obj/item/weapon/storage/firstaid/fire/New()
	..()
	if (empty) return
	new /obj/item/device/healthanalyzer( src )
	new /obj/item/weapon/reagent_containers/syringe/inaprovaline( src )
	new /obj/item/stack/medical/ointment( src )
	new /obj/item/stack/medical/ointment( src )
	new /obj/item/weapon/reagent_containers/pill/kelotane( src )
	new /obj/item/weapon/reagent_containers/pill/kelotane( src )
	new /obj/item/weapon/reagent_containers/pill/kelotane( src ) //Replaced ointment with these since they actually work --Errorage
	return

/obj/item/weapon/storage/firstaid/hypospray/New()
	..()
	new /obj/item/weapon/reagent_containers/glass/hyposprayvial( src )
	new /obj/item/weapon/reagent_containers/glass/hyposprayvial( src )
	new /obj/item/weapon/reagent_containers/glass/hyposprayvial( src )
	new /obj/item/weapon/reagent_containers/glass/hyposprayvial( src )
	new /obj/item/weapon/reagent_containers/glass/hyposprayvial( src )
	new /obj/item/weapon/reagent_containers/glass/hyposprayvial( src )
	new /obj/item/weapon/reagent_containers/glass/hyposprayvial( src )
	return

/obj/item/weapon/storage/syringes/New()
	..()
	new /obj/item/weapon/reagent_containers/syringe( src )
	new /obj/item/weapon/reagent_containers/syringe( src )
	new /obj/item/weapon/reagent_containers/syringe( src )
	new /obj/item/weapon/reagent_containers/syringe( src )
	new /obj/item/weapon/reagent_containers/syringe( src )
	new /obj/item/weapon/reagent_containers/syringe( src )
	new /obj/item/weapon/reagent_containers/syringe( src )
	return

/obj/item/weapon/storage/firstaid/regular/New()

	..()
	if (empty) return
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/weapon/reagent_containers/syringe/inaprovaline( src )
	return

/obj/item/weapon/storage/firstaid/toxin/New()

	..()
	if (empty) return
	new /obj/item/weapon/reagent_containers/syringe/antitoxin( src )
	new /obj/item/weapon/reagent_containers/syringe/antitoxin( src )
	new /obj/item/weapon/reagent_containers/syringe/antitoxin( src )
	new /obj/item/weapon/reagent_containers/pill/antitox( src )
	new /obj/item/weapon/reagent_containers/pill/antitox( src )
	new /obj/item/weapon/reagent_containers/pill/antitox( src )
	new /obj/item/device/healthanalyzer( src )
	return

/obj/item/weapon/storage/firstaid/o2/New()

	..()
	if (empty) return
	new /obj/item/weapon/reagent_containers/pill/dexalin( src )
	new /obj/item/weapon/reagent_containers/pill/dexalin( src )
	new /obj/item/weapon/reagent_containers/pill/dexalin( src )
	new /obj/item/weapon/reagent_containers/pill/dexalin( src )
	new /obj/item/weapon/reagent_containers/syringe/inaprovaline( src )
	new /obj/item/weapon/reagent_containers/syringe/inaprovaline( src )
	new /obj/item/device/healthanalyzer( src )
	return

/obj/item/weapon/storage/firstaid/addiction/New()
	..()
	if (empty) return
	new /obj/item/weapon/reagent_containers/pill/fixer( src )
	new /obj/item/weapon/reagent_containers/pill/fixer( src )
	new /obj/item/weapon/reagent_containers/pill/fixer( src )
	new /obj/item/weapon/reagent_containers/pill/fixer( src )
	new /obj/item/device/healthanalyzer( src )
	return

/obj/item/weapon/storage/pill_bottle/kelotane
	name = "Pill bottle (kelotane)"
	desc = "Contains pills used to treat burns."

/obj/item/weapon/storage/pill_bottle/kelotane/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/kelotane( src )
	new /obj/item/weapon/reagent_containers/pill/kelotane( src )
	new /obj/item/weapon/reagent_containers/pill/kelotane( src )
	new /obj/item/weapon/reagent_containers/pill/kelotane( src )
	new /obj/item/weapon/reagent_containers/pill/kelotane( src )
	new /obj/item/weapon/reagent_containers/pill/kelotane( src )
	new /obj/item/weapon/reagent_containers/pill/kelotane( src )

/obj/item/weapon/storage/pill_bottle/orlistat
	name = "Diet Pills"
	desc = "Contains anti-obseity pills"

/obj/item/weapon/storage/pill_bottle/orlistat/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/orlistat( src )
	new /obj/item/weapon/reagent_containers/pill/orlistat( src )
	new /obj/item/weapon/reagent_containers/pill/orlistat( src )
	new /obj/item/weapon/reagent_containers/pill/orlistat( src )
	new /obj/item/weapon/reagent_containers/pill/orlistat( src )
	new /obj/item/weapon/reagent_containers/pill/orlistat( src )
	new /obj/item/weapon/reagent_containers/pill/orlistat( src )


/obj/item/weapon/storage/pill_bottle/sildenafil
	name = "Viagra Pills"
	desc = "Contains viagra pills"

/obj/item/weapon/storage/pill_bottle/sildenafil/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/sildenafil( src )
	new /obj/item/weapon/reagent_containers/pill/sildenafil( src )
	new /obj/item/weapon/reagent_containers/pill/sildenafil( src )
	new /obj/item/weapon/reagent_containers/pill/sildenafil( src )
	new /obj/item/weapon/reagent_containers/pill/sildenafil( src )
	new /obj/item/weapon/reagent_containers/pill/sildenafil( src )
	new /obj/item/weapon/reagent_containers/pill/sildenafil( src )

/obj/item/weapon/storage/pill_bottle/antitox
	name = "Pill bottle (Anti-toxin)"
	desc = "Contains pills used to counter toxins."

/obj/item/weapon/storage/pill_bottle/antitox/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/antitox( src )
	new /obj/item/weapon/reagent_containers/pill/antitox( src )
	new /obj/item/weapon/reagent_containers/pill/antitox( src )
	new /obj/item/weapon/reagent_containers/pill/antitox( src )
	new /obj/item/weapon/reagent_containers/pill/antitox( src )
	new /obj/item/weapon/reagent_containers/pill/antitox( src )
	new /obj/item/weapon/reagent_containers/pill/antitox( src )

/obj/item/weapon/storage/pill_bottle/inaprovaline
	name = "Pill bottle (inaprovaline)"
	desc = "Contains pills used to stabilize patients."

/obj/item/weapon/storage/pill_bottle/inaprovaline/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/inaprovaline( src )
	new /obj/item/weapon/reagent_containers/pill/inaprovaline( src )
	new /obj/item/weapon/reagent_containers/pill/inaprovaline( src )
	new /obj/item/weapon/reagent_containers/pill/inaprovaline( src )
	new /obj/item/weapon/reagent_containers/pill/inaprovaline( src )
	new /obj/item/weapon/reagent_containers/pill/inaprovaline( src )
	new /obj/item/weapon/reagent_containers/pill/inaprovaline( src )

