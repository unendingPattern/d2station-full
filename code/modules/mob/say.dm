/mob/proc/say()
	return

/mob/verb/whisper()
	set name = "Whisper"
	set category = "IC"
	return

/mob/verb/say_verb(message as text)
	set name = "Say"
	set category = "IC"
	usr.say(message)

/mob/verb/me_verb(message as text)
	set name = "Me"
	set category = "IC"
	usr.emote("me",1,message)

/mob/verb/emote_verb(message as text)
	set name = "Emote"
	set category = "IC"
	usr.emote("message")

/mob/proc/say_dead(var/message)
	var/name = src.real_name
	var/alt_name = ""

	if (istype(src, /mob/living/carbon/human) && src.name != src.real_name)
		if (src:wear_id)
			var/obj/item/weapon/card/id/id = src:wear_id
			if(istype(src:wear_id, /obj/item/device/pda))
				var/obj/item/device/pda/pda = src:wear_id
				id = pda.id
			alt_name = " (as [id:registered])"
		else
			alt_name = " (as Unknown)"
	else if (istype(src, /mob/dead/observer))
		name = "Ghost"
		alt_name = " ([src.real_name])"
	else if (!istype(src, /mob/living/carbon/human))
		name = src.name

	message = src.say_quote(message)

	var/rendered = "<span class='game deadsay'><span class='prefix'>DEAD:</span> <span class='name'>[name]</span>[alt_name] <span class='message'>[message]</span></span>"

	for (var/mob/M in world)
		if (istype(M, /mob/new_player))
			continue
		if (M.stat == 2 || (M.client && M.client.holder && M.client.deadchat)) //admins can toggle deadchat on and off. This is a proc in admin.dm and is only give to Administrators and above
			M.show_message(rendered, 2)

/mob/proc/say_understands(var/mob/other)
	if (src.stat == 2)
		return 1
	else if (istype(other, src.type))
		return 1
	else if(other.universal_speak || src.universal_speak)
		return 1
	return 0

/mob/proc/say_quote(var/text)
	var/ending = copytext(text, length(text))
	if (src.stuttering)
		return "stammers, \"[text]\"";
	if (src.brainloss >= 60)
		return "gibbers, \"[text]\"";
	if (ending == "?")
		return "asks, \"[text]\"";
	else if (ending == "!")
		return "exclaims, \"[text]\"";

	return "says, \"[text]\"";

/mob/proc/emote(var/act)
	return