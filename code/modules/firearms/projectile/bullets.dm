/obj/item/projectile/weakbullet
	damage = 8
	mobdamage = list(BRUTE = 8, BURN = 0, TOX = 0, OXY = 0, CLONE = 0)
	New()
		..()
		effects["stun"] = 5
		effects["weak"] = 10
		effects["stutter"] = 2
		effectprob["weak"] = 25

/obj/item/projectile/midbullet
	damage = 16
	mobdamage = list(BRUTE = 32, BURN = 0, TOX = 0, OXY = 0, CLONE = 0)
	New()
		..()
		effects["weak"] = 10
		effects["stun"] = 10

/obj/item/projectile/strongbullet
	damage = 25
	mobdamage = list(BRUTE = 49, BURN = 0, TOX = 0, OXY = 0, CLONE = 0)
	New()
		..()
		effects["weak"] = 10
		effects["stun"] = 5

/obj/item/projectile/suffocationbullet//How does this even work?
	mobdamage = list(BRUTE = 5, BURN = 0, TOX = 0, OXY = 15, CLONE = 0)//Lung penetration you douchrocket -Nernums

/obj/item/projectile/cyanideround//Instakill guns are not a good thing, make them hit a few times
	mobdamage = list(BRUTE = 5, BURN = 0, TOX = 40, OXY = 0, CLONE = 0)

/obj/item/projectile/burstbullet
	damage = 20
	mobdamage = list(BRUTE = 20, BURN = 0, TOX = 0, OXY = 0, CLONE = 0)

/obj/item/projectile/gyro
	name ="gyro"
	icon_state= "bolter"
	damage = 50
	mobdamage = list(BRUTE = 50, BURN = 0, TOX = 0, OXY = 0, CLONE = 0)
	flag = "bullet"
	New()
		..()
		effects["weak"] = 10
		effects["stun"] = 10

/obj/item/projectile/stunshot
	name = "stunshot"
	icon_state = "bullet"
	flag = "bullet"
	damage = 5
	mobdamage = list(BRUTE = 5, BURN = 0, TOX = 0, OXY = 0, CLONE = 0)
	New()
		..()
		effects["stun"] = 20
		effects["weak"] = 20
		effectprob["weak"] = 45
		effects["stutter"] = 20

/obj/item/projectile/magnet
	name = "magnet round"
	icon_state = "magnetpellet"
	flag = "bullet"
	damage = 60
	mobdamage = list(BRUTE = 55, BURN = 5, TOX = 0, OXY = 0, CLONE = 0)

/obj/item/projectile/pellet
	name = "buckshotpellet"
	icon_state = "bullet"
	flag = "bullet"
	damage = 3
	mobdamage = list(BRUTE = 3, BURN = 0, TOX = 0, OXY = 2, CLONE = 0)
