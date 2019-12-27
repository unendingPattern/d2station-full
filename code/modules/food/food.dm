
//////////////////////////////////////////////////
////////////////////////////////////////////Snacks
//////////////////////////////////////////////////
//Items in the "Snacks" subcategory are food items that people actually eat. The key points are that they are created
//	already filled with reagents and are destroyed when empty. Additionally, they make a "munching" noise when eaten.

//Notes by Darem: Food in the "snacks" subtype can hold a maximum of 50 units Generally speaking, you don't want to go over 40
//	total for the item because you want to leave space for extra condiments. If you want effects besides healing, add a reagent for
//	it. Try to stick to existing reagents when possible (so if you want a stronger healing effect, just use Tricordrazine). On use
//	effects (such as the old officer eating a donut code) requires a unique reagent (unless you can figure out a better way).

//The nutriment reagent and bitesize variable replace the old heal_amt and amount variables. Each unit of nutriment is equal to
//	2 of the old heal_amt variable. Bitesize is the rate at which the reagents are consumed. So if you have 6 nutriment and a
//	bitesize of 2, then it'll take 3 bites to eat. Unlike the old system, the contained reagents are evenly spread among all
//	the bites. No more contained reagents = no more bites.

//Here is an example of the new formatting for anyone who wants to add more food items.
///obj/item/weapon/reagent_containers/food/snacks/xenoburger			//Identification path for the object.
//	name = "Xenoburger"													//Name that displays in the UI.
//	desc = "Smells caustic. Tastes like heresy."						//Duh
//	icon_state = "xburger"												//Refers to an icon in food.dmi
//	New()																//Don't mess with this.
//		..()															//Same here.
//		reagents.add_reagent("xenomicrobes", 10)						//This is what is in the food item. you may copy/paste
//		reagents.add_reagent("nutriment", 2)							//	this line of code for all the contents.
//		bitesize = 3													//This is the amount each bite consumes.

/obj/item/weapon/reagent_containers/food/snacks/candy
	name = "candy"
	desc = "Nougat love it or hate it."
	icon_state = "candy"
	New()
		..()
		reagents.add_reagent("nutriment", 1)
		reagents.add_reagent("sugar", 3)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/candy_corn
	name = "candy corm" //Not a typo
	desc = "It's a handful of candy corm. Can be stored in a detective's hat."
	icon_state = "candy_corn"
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		reagents.add_reagent("sugar", 2)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/chips
	name = "chips"
	desc = "Commander Riker's What-The-Crisps"
	icon_state = "chips"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/chocolatebar
	name = "Chocolate Bar"
	desc = "Such, sweet, fattening food."
	icon_state = "chocolatebar"
	New()
		..()
		reagents.add_reagent("nutriment", 2)
		reagents.add_reagent("sugar", 2)
		reagents.add_reagent("coco", 2)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/donut
	name = "donut"
	desc = "Goes great with Robust Coffee."
	icon_state = "donut1"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("sprinkles", 1)
		src.bitesize = 3
		if(prob(30))
			src.icon_state = "donut2"
			src.name = "frosted donut"
			reagents.add_reagent("sprinkles", 2)

/obj/item/weapon/reagent_containers/food/snacks/egg
	name = "egg"
	desc = "An egg!"
	icon_state = "egg"
	New()
		..()
		reagents.add_reagent("egg", 1)

	proc/eggsplat(atom/target)
		if(reagents.total_volume)
			if(ismob(target))
				src.reagents.reaction(target, TOUCH)
			if(isturf(target))
				src.reagents.reaction(get_turf(target))
			if(isobj(target))
				src.reagents.reaction(target, TOUCH)
		spawn(5) src.reagents.clear_reagents()
		playsound(src.loc, "squish.ogg", 40, 1)
		del(src)

/obj/item/weapon/reagent_containers/food/snacks/flour
	name = "flour"
	desc = "A bag of flour"
	icon_state = "flour"
	New()
		..()
		reagents.add_reagent("nutriment", 15)

/obj/item/weapon/reagent_containers/food/snacks/sugar
	name = "sugar"
	desc = "A bag of sugar. Don't eat it all at once!"
	icon_state = "sugar"
	New()
		..()
		reagents.add_reagent("sugar", 20)

/obj/item/weapon/reagent_containers/food/snacks/sugardoughball
	name = "sugar dough blob"
	desc = "The result of combining some water with some flour, with some sugar. Not that good for you, as-is."
	icon_state = "sugardoughball"
	New()
		..()
		reagents.add_reagent("toxin", 1)
		reagents.add_reagent("nutriment", 6)

/obj/item/weapon/reagent_containers/food/snacks/doughball
	name = "dough blob"
	desc = "The result of combining some water with some flour. Not that good for you, as-is."
	icon_state = "doughball"
	New()
		..()
		reagents.add_reagent("toxin", 2)
		reagents.add_reagent("nutriment", 6)

/obj/item/weapon/reagent_containers/food/snacks/breaddoughball
	name = "bread dough blob"
	desc = "The result of combining some water with some flour, with an egg. Not that good for you, as-is."
	icon_state = "breaddoughball"
	New()
		..()
		reagents.add_reagent("toxin", 2)
		reagents.add_reagent("nutriment", 6)

/obj/item/weapon/reagent_containers/food/snacks/pizzadough
	name = "flattened dough"
	desc = "The first step in the creation of a pizza."
	icon_state = "pizzadough"
	var/sauce = 0
	var/cheese = 0
	var/meat = 0
	var/xenomeat = 0
	New()
		..()
		reagents.add_reagent("toxin", 2)
		reagents.add_reagent("nutriment", 6)

/obj/item/weapon/reagent_containers/food/snacks/doughball/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/kitchen/rollingpin))
		new /obj/item/weapon/reagent_containers/food/snacks/pizzadough(get_turf(src))
		user << "\blue You flatten out the dough to make a pizza base!"
		del(src)
	if (istype(W, /obj/item/weapon/reagent_containers/food/snacks/egg))
		new /obj/item/weapon/reagent_containers/food/snacks/breaddoughball(get_turf(src))
		user << "\blue You mix an egg into the dough. This is the proper dough for breaded foodstuffs."
		del(W)
		del(src)
	if (istype(W, /obj/item/weapon/reagent_containers/food/snacks/sugar))
		new /obj/item/weapon/reagent_containers/food/snacks/sugardoughball(get_turf(src))
		user << "\blue You mix sugar into the dough. This is the proper dough for pastries and cakes."
		del(W)
		del(src)

/obj/item/weapon/reagent_containers/food/snacks/pizzadough/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/reagent_containers/food/snacks/grown/tomato))
		del(src)
		src.name = "decorated pizza dough"
		src.overlays += icon('food.dmi', "pizzadough_sauce")
		user << "\blue You smother the pizza dough with a good helping of tomato sauce."
		src.sauce = 1
	if (istype(W, /obj/item/weapon/reagent_containers/food/snacks/cheesewedge) && src.sauce == 1)
		src.cheese = 1
		src.overlays += icon('food.dmi', "pizzadough_cheese")
		user << "\blue You sprinkle chunks of the cheese wedge onto the pizza."
		src.cheese = 1
	if (istype(W, /obj/item/weapon/reagent_containers/food/snacks/meat/human) && src.sauce == 1 && src.cheese == 1 || istype(W, /obj/item/weapon/reagent_containers/food/snacks/meat/monkey) && src.sauce == 1 && src.cheese == 1)
		src.meat = 1
		src.overlays += icon('food.dmi', "pizzadough_meat")
		user << "\blue You lay chunks of the meat onto the pizza."
		src.meat = 1
	if (istype(W, /obj/item/weapon/reagent_containers/food/snacks/xenomeat) && src.sauce == 1 && src.cheese == 1)
		src.xenomeat = 1
		src.overlays += icon('food.dmi', "pizzadough_xenomeat")
		user << "\blue You lay chunks of the meat onto the pizza."
		src.xenomeat = 1


/obj/item/weapon/reagent_containers/food/snacks/undecoratedpizza
	name = "cooked pizza dough"
	desc = "Might as well just have a tortilla. Sheesh."
	icon_state = "pizzadough_cooked"
	New()
		..()
		reagents.add_reagent("nutriment", 5)

/obj/item/weapon/reagent_containers/food/snacks/saucepizza
	name = "sauce pizza"
	desc = "Toppings? Who needs 'em!"
	icon_state = "saucepizza_cooked"
	New()
		..()
		reagents.add_reagent("nutriment", 6)

/obj/item/weapon/reagent_containers/food/snacks/cheesepizza
	name = "cheese pizza"
	desc = "A rather plain, yet elegant pizza."
	icon_state = "cheese_pizza_cooked"
	New()
		..()
		reagents.add_reagent("nutriment", 13)

/obj/item/weapon/reagent_containers/food/snacks/meatpizza
	name = "meat pizza"
	desc = "A traditional pizza featuring both red meat, and cheese."
	icon_state = "meat_pizza_cooked"
	New()
		..()
		reagents.add_reagent("nutriment", 14)

/obj/item/weapon/reagent_containers/food/snacks/xenomeatpizza
	name = "xeno-meat pizza"
	desc = "A pizza fulfilling the needs of the adventurous meat connoisseur."
	icon_state = "xenomeat_pizza_cooked"
	New()
		..()
		reagents.add_reagent("nutriment", 14)

/obj/item/weapon/reagent_containers/food/snacks/meatloverspizza
	name = "mixed-meat pizza"
	desc = "The choice pizza of the station's meat lovers."
	icon_state = "meatlovers_pizza_cooked"
	New()
		..()
		reagents.add_reagent("nutriment", 15)

/obj/item/weapon/reagent_containers/food/snacks/meat
	name = "meat"
	desc = "A slab of meat"
	icon_state = "meat"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		src.bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/meat/human
	name = "-meat"
	var/subjectname = ""
	var/subjectjob = null

/obj/item/weapon/reagent_containers/food/snacks/meat/monkey
	//same as plain meat

/obj/item/weapon/reagent_containers/food/snacks/tofu
	name = "Tofu"
	icon_state = "tofu"
	desc = "We all love tofu."
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		src.bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/icecream
	name = "Ice Cream"
	icon_state = "vanillaicecream"
	desc = "We all scream for ice cream."
	New()
		..()
		reagents.add_reagent("nutriment", 9)
		src.bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/richicecream
	name = "Rich Ice Cream"
	icon_state = "richvanillaicecream"
	desc = "This entire establishment is shrieking in bliss at the mere visage of frozen dairy products."
	New()
		..()
		reagents.add_reagent("nutriment", 12)
		src.bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/tofuicecream
	name = "Vegan Ice Cream"
	icon_state = "tofuicecream"
	desc = "Only vegans scream for this ice cream."
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		src.bitesize = 2

///obj/item/weapon/reagent_containers/food/snacks/pooicecream
//	name = "Chocolate Ice Cream"
//	icon_state = "chocolateicecream"
//	desc = "Poopy Pooperson brand Ice cream."
//	New()
//		..()
//		reagents.add_reagent("poo", 15)
//		src.bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/carpmeat
	name = "carp fillet"
	desc = "A fillet of spess carp meat"
	icon_state = "fishfillet"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("carpotoxin", 3)
		src.bitesize = 6

/obj/item/weapon/reagent_containers/food/snacks/hugemushroomslice
	name = "huge mushroom slice"
	desc = "A slice from a huge mushroom."
	icon_state = "hugemushroomslice"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("psilocybin", 3)
		src.bitesize = 6

/obj/item/weapon/reagent_containers/food/snacks/tomatomeat
	name = "tomato slice"
	desc = "A slice from a huge tomato"
	icon_state = "tomatomeat"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		src.bitesize = 6

/obj/item/weapon/reagent_containers/food/snacks/bearmeat
	name = "bear meat"
	desc = "A very manly slab of meat."
	icon_state = "bearmeat"
	New()
		..()
		reagents.add_reagent("nutriment", 12)
		reagents.add_reagent("hyperzine", 5)
		src.bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/xenomeat
	name = "meat"
	desc = "A slab of meat"
	icon_state = "xenomeat"
	New()
		..()
		reagents.add_reagent("xenomicrobes", 6)
		src.bitesize = 6

/obj/item/weapon/reagent_containers/food/snacks/faggot
	name = "Faggot"
	desc = "A great meal all round. Not a cord of wood."
	icon_state = "faggot"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		bitesize = 2


/obj/item/weapon/reagent_containers/food/snacks/dongpocket
	name = "Dong-pocket"
	desc = "The food of choice for the extra-seasoned traitor."
	icon_state = "dongpocket"
	New()
		..()
		reagents.add_reagent("nutriment", 8)

	var/warm = 0
	proc/cooltime()
		if (src.warm)
			src.reagents.add_reagent("syndicream", 12)
			spawn( 4200 )
				src.warm = 0
				src.reagents.remove_reagent("syndicream", 12)
				src.name = "dong-pocket"
		return

/obj/item/weapon/reagent_containers/food/snacks/donkpocket
	name = "Donk-pocket"
	desc = "The food of choice for the seasoned traitor."
	icon_state = "donkpocket"
	New()
		..()
		reagents.add_reagent("nutriment", 4)

	var/warm = 0
	proc/cooltime()
		if (src.warm)
			spawn( 4200 )
				src.warm = 0
				src.reagents.add_reagent("syndicream", 3)
				src.name = "donk-pocket"
		return

/obj/item/weapon/reagent_containers/food/snacks/rationcube
	name = "food ration"
	desc = "A compressed, dehydrated, enriched, artificially flavored block of food."
	icon_state = "astronautfoodcube"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/poo
	name = "poo"
	desc = "It's a poo..."
	icon = 'poop.dmi'
	icon_state = "poop2"
	item_state = "poop"
	random_icon_states = list("poop1", "poop2", "poop3", "poop4", "poop5", "poop6", "poop7")
	New()
		..()
		icon_state = pick(random_icon_states)
		reagents.add_reagent("poo", 10)
		bitesize = 3

	proc/poo_splat(atom/target)
		if(reagents.total_volume)
			if(ismob(target))
				src.reagents.reaction(target, TOUCH)
			if(isturf(target))
				src.reagents.reaction(get_turf(target))
			if(isobj(target))
				src.reagents.reaction(target, TOUCH)
		spawn(5) src.reagents.clear_reagents()
		playsound(src.loc, "squish.ogg", 40, 1)
		del(src)

/obj/item/weapon/reagent_containers/food/snacks/faileddish
	name = "Failed Dish"
	desc = "I can't even tell what somebody tried to cook to make this..."
	icon_state = "faileddish"
	New()
		..()
		reagents.add_reagent("poo", 1)
		reagents.add_reagent("nutriment", 4)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/brainburger
	name = "brainburger"
	desc = "A strange looking burger. It looks almost sentient."
	icon_state = "brainburger"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/assburger
	name = "assburger"
	desc = "This burger gives off an air of awkwardness."
	icon_state = "hburger" //missing assburger icon
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		reagents.add_reagent("poo", 2)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/penisburger
	name = "penisburger"
	desc = "This burger gives off an air of awkwardness."
	icon_state = "hburger" //missing penisburger icon
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		reagents.add_reagent("cum", 2)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/human
	var/hname = ""
	var/job = null

/obj/item/weapon/reagent_containers/food/snacks/human/burger
	name = "-burger"
	desc = "A bloody burger."
	icon_state = "hburger"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/monkeyburger
	name = "burger"
	desc = "The cornerstone of every nutritious breakfast."
	icon_state = "hburger"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/fishburger
	name = "Fillet -o- Carp Sandwich"
	desc = "Almost like a carp is yelling somewhere... Give me back that fillet -o- carp, give me that carp."
	icon_state = "fishburger"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("carpotoxin", 3)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/tofuburger
	name = "Tofu Burger"
	desc = "What.. is that meat?"
	icon_state = "tofuburger"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/roburger
	name = "roburger"
	desc = "The lettuce is the only organic component. Beep."
	icon_state = "roburger"
	New()
		..()
		reagents.add_reagent("nutriment", 2)
		reagents.add_reagent("nanites", 10)
		bitesize = 3


/obj/item/weapon/reagent_containers/food/snacks/roburgerbig
	name = "roburger"
	desc = "This massive patty looks like poison. Beep."
	icon_state = "roburger"
	volume = 100
	New()
		..()
		reagents.add_reagent("nanites", 100)
		bitesize = 0.1

/obj/item/weapon/reagent_containers/food/snacks/xenoburger
	name = "xenoburger"
	desc = "Smells caustic. Tastes like heresy."
	icon_state = "xburger"
	New()
		..()
		reagents.add_reagent("xenomicrobes", 10)
		reagents.add_reagent("nutriment", 2)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/clownburger
	name = "Clown Burger"
	desc = "This tastes funny..."
	icon_state = "clownburger"
	New()
		..()
/*
		var/datum/disease/F = new /datum/disease/pierrot_throat(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 4, data)
*/
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/mimeburger
	name = "Mime Burger"
	desc = "It's taste defies language."
	icon_state = "mimeburger"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/omelette
	name = "Omelette Du Fromage"
	desc = "That's all you can say!"
	icon_state = "omelette"
	//var/herp = 0
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 1
	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W,/obj/item/weapon/kitchen/utensil/fork))
			if (W.icon_state == "forkloaded")
				user << "\red You already have omelette on your fork."
				return
			//W.icon = 'kitchen.dmi'
			W.icon_state = "forkloaded"
			/*if (herp)
				world << "[user] takes a piece of omelette with his fork!"*/
				//Why this unecessary check? Oh I know, because I'm bad >:C
				// Yes, you are. You griefing my badmin toys. --rastaf0
			user.visible_message( \
				"[user] takes a piece of omelette with their fork!", \
				"\blue You take a piece of omelette with your fork!" \
			)
			reagents.remove_reagent("nutriment", 1)
			if (reagents.total_volume <= 0)
				del(src)
/*
 * Unsused.
/obj/item/weapon/reagent_containers/food/snacks/omeletteforkload
	name = "Omelette Du Fromage"
	desc = "That's all you can say!"
	New()
		..()
		reagents.add_reagent("nutriment", 1)
*/

/obj/item/weapon/reagent_containers/food/snacks/muffin
	name = "Muffin"
	desc = "A delicious and spongy little cake"
	icon_state = "muffin"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/pie
	name = "Banana Cream Pie"
	desc = "Just like back home, on clown planet! HONK!"
	icon_state = "pie"
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		reagents.add_reagent("banana",5)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/berryclafoutis
	name = "Berry Clafoutis"
	desc = "No black birds, this is a good sign."
	icon_state = "berryclafoutis"
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		reagents.add_reagent("berryjuice", 5)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/waffles
	name = "waffles"
	desc = "Mmm, waffles"
	icon_state = "waffles"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/eggplantparm
	name = "Eggplant Parmigiana"
	desc = "The only good recipe for eggplant."
	icon_state = "eggplantparm"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/jellydonut
	name = "Jelly Donut"
	desc = "Oh so gooey on the inside."
	icon_state = "jdonut1"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("sprinkles", 1)
		reagents.add_reagent("berryjuice", 5)
		bitesize = 5
		if(prob(30))
			src.icon_state = "jdonut2"
			src.name = "Frosted Jelly Donut"
			reagents.add_reagent("sprinkles", 2)

/obj/item/weapon/reagent_containers/food/snacks/soylentgreen
	name = "Soylent Green"
	desc = "Not made of people. Honest." //Totally people.
	icon_state = "soylent"
	New()
		..()
		reagents.add_reagent("nutriment", 14)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/soylenviridians
	name = "Soylen Virdians"
	desc = "Not made of people. Honest." //Actually honest for once.
	icon_state = "soylent"
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/humeatpie
	name = "Meat-pie"
//	var/hname = "" //TODO: need some way to find out that facts for the characters.
//	var/job = null
	icon_state = "meatpie"
	desc = "The best meatpies on station."
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/momeatpie
	name = "Meat-pie"
	icon_state = "meatpie"
	desc = "A delicious meatpie."
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/tofupie
	name = "Tofu-pie"
	icon_state = "meatpie"
	desc = "A delicious tofu pie."
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/amanita_pie
	name = "amanita pie"
	desc = "Sweet and tasty poison pie."
	icon_state = "amanita_pie"
	New()
		..()
		reagents.add_reagent("nutriment", 5)
		reagents.add_reagent("amatoxin", 3)
		reagents.add_reagent("psilocybin", 1)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/plump_pie
	name = "plump pie"
	desc = "I bet you love stuff made out of plump helmets!"
	icon_state = "plump_pie"
	New()
		..()
		if(prob(10))
			name = "exceptional plump pie"
			desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump pie!"
			reagents.add_reagent("nutriment", 15)
			bitesize = 2
		else
			reagents.add_reagent("nutriment", 10)
			bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/xemeatpie
	name = "Xeno-pie"
	icon_state = "xenomeatpie"
	desc = "A delicious meatpie. Probably heretical."
	New()
		..()
		reagents.add_reagent("nutriment", 2)
		reagents.add_reagent("xenomicrobes", 10)
		bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/wingfangchu
	name = "Wing Fang Chu"
	desc = "A savory dish of alien wing wang in soy."
	icon_state = "wingfangchu"
	New()
		..()
		reagents.add_reagent("nutriment", 1)
		reagents.add_reagent("xenomicrobes", 5)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/chaosdonut
	name = "Chaos Donut"
	desc = "Like life, it never quite tastes the same."
	icon_state = "donut1"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		bitesize = 2
		if(prob(30))
			src.icon_state = "donut2"
			src.name = "Frosted Chaos Donut"
			reagents.add_reagent("sprinkles", 3)
		reagents.add_reagent(pick("capsaicin", "frostoil", "nutriment"), 3)

/obj/item/weapon/reagent_containers/food/snacks/human/kabob
	name = "-kabob"
	icon_state = "kabob"
	desc = "A delicious kabob"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2
	On_Consume()
		if(!reagents.total_volume)
			var/mob/M = usr
			var/obj/item/stack/rods/W = new /obj/item/stack/rods( M )
			M << "\blue You lick clean the rod."
			M.put_in_hand(W)

/obj/item/weapon/reagent_containers/food/snacks/monkeykabob
	name = "Meat-kabob"
	icon_state = "kabob"
	desc = "A delicious kabob"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2
	On_Consume()
		if(!reagents.total_volume)
			var/mob/M = usr
			var/obj/item/stack/rods/W = new /obj/item/stack/rods( M )
			M << "\blue You lick clean the rod."
			M.put_in_hand(W)

/obj/item/weapon/reagent_containers/food/snacks/tofukabob
	name = "Tofu-kabob"
	icon_state = "kabob"
	desc = "A delicious kabob"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2
	On_Consume()
		if(!reagents.total_volume)
			var/mob/M = usr
			var/obj/item/stack/rods/W = new /obj/item/stack/rods( M )
			M << "\blue You lick clean the rod."
			M.put_in_hand(W)

/obj/item/weapon/reagent_containers/food/snacks/cubancarp
	name = "Cuban Carp"
	desc = "A grifftastic sandwich that burns your tongue and then leaves it numb!"
	icon_state = "cubancarp"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("carpotoxin", 3)
		reagents.add_reagent("capsaicin", 3)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/popcorn
	name = "Popcorm" //not a typo
	desc = "Now let's find some cinema."
	icon_state = "popcorn"
	var/unpopped = 0
	New()
		..()
		unpopped = rand(1,10)
		reagents.add_reagent("nutriment", 2)
		bitesize = 0.1 //this snack is supposed to be eating during looooong time. And this it not dinner food! --rastaf0
	On_Consume()
		if(prob(unpopped))
			usr << "\red You bite down on an un-popped kernel!"
			unpopped = max(0, unpopped-1)


/obj/item/weapon/reagent_containers/food/snacks/sosjerky
	name = "Scaredy's Private Reserve Beef Jerky"
	icon_state = "sosjerky"
	desc = "Beef jerky made from the finest space cows."
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/no_raisin
	name = "4no Raisins"
	icon_state = "4no_raisins"
	desc = "Best raisins in the universe. Not sure why."
	New()
		..()
		reagents.add_reagent("nutriment", 6)

/obj/item/weapon/reagent_containers/food/snacks/spacetwinkie
	name = "Space Twinkie"
	icon_state = "space_twinkie"
	desc = "Guaranteed to survive longer then you will."
	New()
		..()
		reagents.add_reagent("sugar", 4)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers
	name = "Cheesie Honkers"
	icon_state = "cheesie_honkers"
	desc = "Bite sized cheesie snacks that will honk all over your mouth"
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/dicksbag
	name = "Bag of Dick's"
	icon_state = "cheesie_honkers"
	desc = "Eat a bag of Dick's, and you'll never be hungry again!"
	New()
		..()
		reagents.add_reagent("nutriment", 20)
		bitesize = 10

/obj/item/weapon/reagent_containers/food/snacks/syndicake
	name = "Syndi-Cakes"
	icon_state = "syndi_cakes"
	desc = "An extremely moist snack cake that tastes just as good after being nuked."
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		reagents.add_reagent("syndicream", 2)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/loadedbakedpotato
	name = "Loaded Baked Potato"
	desc = "Totally baked."
	icon_state = "loadedbakedpotato"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/fries
	name = "Space Fries"
	desc = "AKA: French Fries, Freedom Fries, etc"
	icon_state = "fries"
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/soydope
	name = "Soy Dope"
	desc = "Dope from a soy."
	icon_state = "soydope"
	New()
		..()
		reagents.add_reagent("nutriment", 2)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/spagetti
	name = "Spagetti"
	desc = "Now thats a nice pasta!"
	icon_state = "spagetti"
	New()
		..()
		reagents.add_reagent("nutriment", 1)
		bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/cheesyfries
	name = "Cheesy Fries"
	desc = "Fries. Covered in cheese. Duh."
	icon_state = "cheesyfries"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/fortunecookie
	name = "Fortune cookie"
	desc = "A true prophecy in each cookie!"
	icon_state = "fortune_cookie"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		bitesize = 2
	On_Consume()
		if(!reagents.total_volume)
			var/mob/M = usr
			var/obj/item/weapon/paper/paper = locate() in src
			M.visible_message( \
				"\blue [M] takes a piece of paper from the cookie!", \
				"\blue You take a piece of paper from the cookie! Read it!" \
			)
			M.put_in_hand(paper)
			paper.add_fingerprint(M)

/obj/item/weapon/reagent_containers/food/snacks/badrecipe
	name = "Burned mess"
	desc = "Someone should be demoted from chef for this."
	icon_state = "badrecipe"
	New()
		..()
		reagents.add_reagent("toxin", 1)
		reagents.add_reagent("carbon", 1)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/meatsteak
	name = "Meat steak"
	desc = "A piece of hot spicy meat."
	icon_state = "meatstake"
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		reagents.add_reagent("sodiumchloride", 1)
		reagents.add_reagent("blackpepper", 1)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/spacylibertyduff
	name = "Spacy Liberty Duff"
	desc = "Jello gelatin, if Alfred Hubbard were a confectionist" //TODO
	icon_state = "spacylibertyduff"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("psilocybin", 6)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/amanitajelly
	name = "Amanita Jelly"
	desc = "Looks curiously toxic"
	icon_state = "amanitajelly"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("amatoxin", 6)
		reagents.add_reagent("psilocybin", 3)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/meatballsoup
	name = "Meatball soup"
	desc = "" //TODO
	icon_state = "meatballsoup"
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		reagents.add_reagent("water", 10)
		bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/vegetablesoup
	name = "Vegetable soup"
	desc = "" //TODO
	icon_state = "vegetablesoup"
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		reagents.add_reagent("water", 10)
		bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/nettlesoup
	name = "Nettle soup"
	desc = "" //TODO
	icon_state = "nettlesoup"
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		reagents.add_reagent("water", 7)
		reagents.add_reagent("tricordrazine", 3)
		bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/wishsoup
	name = "Wish Soup"
	desc = "I wish this was soup."
	icon = 'janitor.dmi'
	icon_state = "bucket"
	New()
		..()
		reagents.add_reagent("water", 20)
		bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/hotchili
	name = "Hot Chili"
	desc = "" //TODO
	icon_state = "hotchili"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("capsaicin", 3)
		reagents.add_reagent("tomatojuice", 2)
		bitesize = 5


/obj/item/weapon/reagent_containers/food/snacks/coldchili
	name = "Cold Chili"
	desc = "" //TODO
	icon_state = "coldchili"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("frostoil", 3)
		reagents.add_reagent("tomatojuice", 2)
		bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/telebacon
	name = "Tele Bacon"
	desc = "It tastes a little odd but it is still delicious."
	icon_state = "bacon"
	var/obj/item/device/radio/beacon/bacon/baconbeacon
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		baconbeacon = new /obj/item/device/radio/beacon/bacon(src)
	On_Consume()
		if(!reagents.total_volume)
			baconbeacon.loc = usr
			baconbeacon.digest_delay()


/obj/item/weapon/reagent_containers/food/snacks/bananaphone
	name = "Banana Phone"
	desc = "Ring ring ring ring ring..."
	icon = 'items.dmi'
	icon_state = "banana" //needs a new icon.
	bitesize = 5
	var/obj/item/device/radio/banana/bananaphone
	New()
		..()
		reagents.add_reagent("banana", 5)
		bananaphone = new /obj/item/device/radio/banana(src)
		bananaphone.listening = 1
		bananaphone.broadcasting = 1

	hear_talk(mob/M as mob, msg)
		if(bananaphone)
			bananaphone.hear_talk(M, msg)

/obj/item/weapon/reagent_containers/food/snacks/monkeycube
	name = "monkey cube"
	desc = "Just add water!"
	icon_state = "monkeycube"
	bitesize = 12
	var/wrapped = 0

	New()
		..()
		reagents.add_reagent("nutriment",12)

	afterattack(obj/O as obj, mob/user as mob)
		if(istype(O,/obj/machinery/sink) && !wrapped)
			user << "You place [name] under a stream of water..."
			loc = get_turf(O)
			return Expand()
		..()

	attack_self(mob/user as mob)
		if(wrapped)
			Unwrap(user)

	proc/Expand()
		for(var/mob/M in viewers(src,7))
			M << "\red The monkey cube expands!"
		new /mob/living/carbon/monkey(get_turf(src))
		del(src)

	proc/Unwrap(mob/user as mob)
		icon_state = "monkeycube"
		desc = "Just add water!"
		user << "You unwrap the cube."
		wrapped = 0
		return

	wrapped
		desc = "Still wrapped in some paper."
		icon_state = "monkeycubewrap"
		wrapped = 1

/obj/item/weapon/reagent_containers/food/snacks/spellburger
	name = "Spell Burger"
	desc = "This is absolutely Ei Nath."
	icon_state = "spellburger"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/bigbiteburger
	name = "Big Bite Burger"
	desc = "Forget the Big Mac. THIS is the future!"
	icon_state = "bigbiteburger"
	New()
		..()
		reagents.add_reagent("nutriment", 14)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/enchiladas
	name = "Enchiladas"
	desc = "Viva La Mexico!"
	icon_state = "enchiladas"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("capsaicin", 6)
		bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/monkiesdelight
	name = "Monkie's Delight"
	desc = "Eeee Eee!"
	icon_state = "monkiesdelight"
	New()
		..()
		reagents.add_reagent("nutriment", 14)
		reagents.add_reagent("banana", 5)
		reagents.add_reagent("blackpepper", 1)
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 6

/obj/item/weapon/reagent_containers/food/snacks/baguette
	name = "Baguette"
	desc = "Bon appetit!"
	icon_state = "baguette"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("blackpepper", 1)
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/fishandchips
	name = "Fish and Chips"
	desc = "I do say so myself chap."
	icon_state = "fishandchips"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("carpotoxin", 3)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/sandwich
	name = "Sandwich"
	desc = "A grand creation of meat, cheese, bread and several leafs oflettuce! Arthur Dent would be proud."
	icon_state = "sandwich"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/toastedsandwich
	name = "Toasted Sandwich"
	desc = "Now if you only had a pepper bar."
	icon_state = "toastedsandwich"
	New()
		..()
		reagents.add_reagent("nutriment", 9)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/tomatosoup
	name = "Tomato Soup"
	desc = "Drinking this feels like being a vampire! A tomato vampire..."
	icon_state = "tomatosoup"
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		reagents.add_reagent("tomatojuice", 10)
		reagents.add_reagent("water", 10)
		bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/rofflewaffles
	name = "Roffle Waffles"
	desc = "Waffles from Roffle. Co."
	icon_state = "rofflewaffles"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("psilocybin", 8)
		bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/stew
	name = "Stew"
	desc = "A nice and warm stew. Healthy and strong."
	icon_state = "stew"
	New()
		..()
		reagents.add_reagent("nutriment", 20)
		reagents.add_reagent("tomatojuice", 5)
		reagents.add_reagent("imidazoline", 5)
		reagents.add_reagent("water", 10)
		bitesize = 10

/obj/item/weapon/reagent_containers/food/snacks/metroidtoast
	name = "Metroid Toast"
	desc = "A slice of bread covered with delicious jam."
	icon_state = "metroidtoast"
	New()
		..()
		reagents.add_reagent("nutriment", 1)
		reagents.add_reagent("metroid", 5)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/milosoup
	name = "Milosoup"
	desc = "The universes best soup! Yum!!!"
	icon_state = "milosoup"
	New()
		..()
		reagents.add_reagent("nutriment", 12)
		reagents.add_reagent("water", 20)
		bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/stewedsoymeat
	name = "Stewed Soy Meat"
	desc = "Even non-vegetarians will LOVE this!"
	icon_state = "stewedsoymeat"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/boiledspagetti
	name = "Boiled Spagetti"
	desc = "A plain dish of noodles, this sucks."
	icon_state = "spagettiboiled"
	New()
		..()
		reagents.add_reagent("nutriment", 2)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/pastatomato
	name = "Spagetti"
	desc = "Spaghetti and crushed tomatoes. Just like your abusive father used to make!"
	icon_state = "pastatomato"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("tomatojuice", 10)
		bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/meatballspagetti
	name = "Spagetti & Meatballs"
	desc = "Now thats a nic'e meatball!"
	icon_state = "meatballspagetti"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/poppypretzel
	name = "Poppy Pretzel"
	desc = "A large soft pretzel full of POP!"
	icon_state = "poppypretzel"
	New()
		..()
		reagents.add_reagent("nutriment", 5)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/carrotfries
	name = "Carrot Fries"
	desc = "Tasty fries from fresh Carrots."
	icon_state = "carrotfries"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("imidazoline", 3)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/superbiteburger
	name = "Super Bite Burger"
	desc = "This is a mountain of a burger. FOOD!"
	icon_state = "superbiteburger"
	New()
		..()
		reagents.add_reagent("nutriment", 40)
		bitesize = 10

/obj/item/weapon/reagent_containers/food/snacks/candiedapple
	name = "Candied Apple"
	desc = "An apple coated in sugary sweetness."
	icon_state = "candiedapple"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/applepie
	name = "Apple Pie"
	desc = "A pie containing sweet sweet love...or apple."
	icon_state = "applepie"
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/buttbusterburger
	name = "The Buttbuster"
	desc = "Merely looking at this monstroity makes you feel like you're having a heart attack."
	icon = 'buttbuster.dmi'
	icon_state = "buttbuster"
	New()
		..()
		reagents.add_reagent("nutriment", 720) //WHAT CAN GO WRONG
		bitesize = 20

/obj/item/weapon/reagent_containers/food/snacks/salad
	name = "salad"
	desc = "A generic combination of lettuce and tomato topped with seasonings. How bland."
	icon_state = "salad"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("imidazoline", 5)
		bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/dong
	name = "honey nut penis"
	desc = "A delicious combination of honey, nuts and a penis."
	icon_state = "hnp"
	New()
		..()
		reagents.add_reagent("nutriment", 5)
		reagents.add_reagent("cum", 5)
		reagents.add_reagent("sugar", 5) //why don't we have honey implemented yet guys
		bitesize = 5

/////////////////////////////////////////////////Sliceable////////////////////////////////////////
// All the food items that can be sliced into smaller bits like Meatbread and Cheesewheels

/obj/item/weapon/reagent_containers/food/snacks/sliceable/meatbread
	name = "meatbread loaf"
	desc = "The culinary base of every self-respecting eloquent gentleman."
	icon_state = "meatbread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/meatbreadslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 40)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/meatbreadslice
	name = "meatbread slice"
	desc = "A slice of delicious meatbread."
	icon_state = "meatbreadslice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/xenomeatbread
	name = "xenomeatbread loaf"
	desc = "The culinary base of every self-respecting eloquent gentleman. Extra Heretical."
	icon_state = "xenomeatbread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/xenomeatbreadslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 5)
		reagents.add_reagent("xenomicrobes", 35)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/xenomeatbreadslice
	name = "xenomeatbread slice"
	desc = "A slice of delicious meatbread. Extra Heretical."
	icon_state = "xenobreadslice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/bananabread
	name = "Banana-nut bread"
	desc = "A heavenly and filling treat."
	icon_state = "bananabread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/bananabreadslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("banana", 20)
		reagents.add_reagent("nutriment", 20)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/bananabreadslice
	name = "Banana-nut bread slice"
	desc = "A slice of delicious banana bread."
	icon_state = "bananabreadslice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/tofubread
	name = "Tofubread"
	icon_state = "Like meatbread but for vegetarians. Not guaranteed to give superpowers."
	icon_state = "tofubread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/tofubreadslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 40)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/tofubreadslice
	name = "Tofubread slice"
	desc = "A slice of delicious tofubread."
	icon_state = "tofubreadslice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/carrotcake
	name = "Carrot Cake"
	desc = "A favorite dessert of a certain wascally wabbit. Not a lie."
	icon_state = "carrotcake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/carrotcakeslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 30)
		reagents.add_reagent("imidazoline", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/carrotcakeslice
	name = "Carrot Cake slice"
	desc = "Carrotty slice of Carrot Cake, carrots are good for your eyes! Also not a lie."
	icon_state = "carrotcake_slice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesecake
	name = "Cheese Cake"
	desc = "DANGEROUSLY cheesy."
	icon_state = "cheesecake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/cheesecakeslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 30)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/cheesecakeslice
	name = "Cheese Cake slice"
	desc = "Slice of pure cheestisfaction"
	icon_state = "cheesecake_slice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/plaincake
	name = "Vanilla Cake"
	desc = "A plain cake, not a lie."
	icon_state = "plaincake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/plaincakeslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 25)

/obj/item/weapon/reagent_containers/food/snacks/plaincakeslice
	name = "Vanilla Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "plaincake_slice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesewheel
	name = "Cheese wheel"
	desc = "A big wheel of delcious Cheddar."
	icon_state = "cheesewheel"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 20)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	name = "Cheese wedge"
	desc = "A wedge of delicious Cheddar. The cheese wheel it was cut from can't have gone far."
	icon_state = "cheesewedge"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/birthdaycake
	name = "Birthday Cake"
	desc = "Happy Birthday little cluwne..."
	icon_state = "birthdaycake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/birthdaycakeslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 30)
		reagents.add_reagent("sprinkles", 10)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/birthdaycakeslice
	name = "Birthday Cake slice"
	desc = "A slice of your birthday"
	icon_state = "birthdaycakeslice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread
	name = "Bread"
	icon_state = "Some plain old Earthen bread."
	icon_state = "bread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/breadslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/breadslice
	name = "Bread slice"
	desc = "A slice of home."
	icon_state = "breadslice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/grown/watermelon
	name = "Watermelon"
	icon_state = "A juicy watermelon"
	icon_state = "watermelon"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/watermelonslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/watermelonslice
	name = "Watermelon Slice"
	desc = "A slice of watery goodness."
	icon_state = "watermelonslice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/applecake
	name = "Apple Cake"
	desc = "A cake centred with Apple"
	icon_state = "applecake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/applecakeslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 29)

/obj/item/weapon/reagent_containers/food/snacks/applecakeslice
	name = "Apple Cake slice"
	desc = "A slice of heavenly cake."
	icon_state = "applecakeslice"
	bitesize = 2




/////////////////////////////////////////////////PIZZA////////////////////////////////////////

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza
	slices_num = 6

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/margherita
	name = "Margherita"
	desc = "The most cheezy pizza in galaxy"
	icon_state = "pizzamargherita"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/margheritaslice
	slices_num = 6
	New()
		..()
		reagents.add_reagent("nutriment", 40)
		reagents.add_reagent("tomatojuice", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/margheritaslice
	name = "Margherita slice"
	desc = "A slice of the most cheezy pizza in galaxy"
	icon_state = "pizzamargheritaslice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/meatpizza
	name = "Meatpizza"
	desc = "" //TODO:
	icon_state = "meatpizza"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/meatpizzaslice
	slices_num = 6
	New()
		..()
		reagents.add_reagent("nutriment", 50)
		reagents.add_reagent("tomatojuice", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/meatpizzaslice
	name = "Meatpizza slice"
	desc = "A slice of " //TODO:
	icon_state = "meatpizzaslice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/mushroompizza
	name = "Mushroompizza"
	desc = "Very special pizza"
	icon_state = "mushroompizza"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/mushroompizzaslice
	slices_num = 6
	New()
		..()
		reagents.add_reagent("nutriment", 35)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/mushroompizzaslice
	name = "Mushroompizza slice"
	desc = "Maybe it is the last slice of pizza in your life."
	icon_state = "mushroompizzaslice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza
	name = "Vegetable pizza"
	desc = "No one of Tomatos Sapiens were harmed during making this pizza"
	icon_state = "vegetablepizza"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/vegetablepizzaslice
	slices_num = 6
	New()
		..()
		reagents.add_reagent("nutriment", 30)
		reagents.add_reagent("tomatojuice", 6)
		reagents.add_reagent("imidazoline", 12)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/vegetablepizzaslice
	name = "Vegetable pizza slice"
	desc = "A slice of the most green pizza of all pizzas not containing green ingredients."
	icon_state = "vegetablepizzaslice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/creamcheesebread
	name = "Cream Cheese Bread"
	desc = "Yum yum yum!"
	icon_state = "creamcheesebread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/creamcheesebreadslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 20)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/creamcheesebreadslice
	name = "Cream Cheese Bread slice"
	desc = "A slice of yum!"
	icon_state = "creamcheesebreadslice"
	bitesize = 2

