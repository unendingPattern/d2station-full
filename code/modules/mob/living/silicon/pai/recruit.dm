// Recruiting observers to play as pAIs

var/datum/paiController/paiController			// Global handler for pAI candidates

/datum/paiCandidate
	var
		name
		key
		description
		role
		comments
		ready = 0



/datum/paiController
	var/list/pai_candidates = list()
	var/list/asked = list()

	var/askDelay = 10 * 60 * 5	// Five minutes

	Topic(href, href_list[])
		if(href_list["download"])
			var/datum/paiCandidate/candidate = locate(href_list["candidate"])
			var/obj/item/device/paicard/card = locate(href_list["device"])
			if(card.pai)
				return
			if(card && candidate)
				var/mob/living/silicon/pai/pai = new(card)
				pai.name = candidate.name
				pai.real_name = pai.name
				pai.key = candidate.key
				card.pai = pai
				card.looking_for_personality = 0
				pai_candidates.Remove(candidate)
				usr << browse(null, "window=findPai")
		if(href_list["new"])
			var/datum/paiCandidate/candidate = locate(href_list["candidate"])
			var/option = href_list["option"]
			switch(option)
				if("name")
					candidate.name = strip_html(input("Enter a name for your pAI", "pAI Name", candidate.name) as text, 50)
				if("desc")
					candidate.description = strip_html(input("Enter a description for your pAI", "pAI Description", candidate.description) as message, 128)
				if("role")
					candidate.role = strip_html(input("Enter a role for your pAI", "pAI Role", candidate.role) as text, 128)
				if("ooc")
					candidate.comments = strip_html(input("Enter any OOC comments", "pAI OOC Comments", candidate.comments) as message, 128)

				if("save")
					candidate.savefile_save(usr)
				if("load")
					candidate.savefile_load(usr)

				if("submit")
					if(candidate)
						candidate.ready = 1
						for(var/obj/item/device/paicard/p in world)
							if(p.looking_for_personality == 1)
								p.alertUpdate()
					usr << browse(null, "window=paiRecruit")
					return
			recruitWindow(usr)

	proc/recruitWindow(var/mob/M as mob)
		var/datum/paiCandidate/candidate
		for(var/datum/paiCandidate/c in pai_candidates)
			if(c.key == M.key)
				candidate = c
		if(!candidate)
			candidate = new /datum/paiCandidate()
			candidate.key = M.key
			pai_candidates.Add(candidate)


		var/dat = ""
		dat += {"
				<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' />
				<style type="text/css">

				p.top {
					background-color: #AAAAAA; color: black;
				}

				tr.d0 td {
					background-color: #CC9999; color: black;
				}
				tr.d1 td {
					background-color: #9999CC; color: black;
				}
				</style>
				"}

		dat += "<p class=\"top\">Please configure your pAI personality's options. Remember, what you enter here could determine whether or not the user requesting a personality chooses you!</p>"
		dat += "<table>"
		dat += "<tr class=\"d0\"><td>Name:</td><td>[candidate.name]</td></tr>"
		dat += "<tr class=\"d1\"><td><a href='byond://?src=\ref[src];option=name;new=1;candidate=\ref[candidate]'>\[Edit\]</a></td><td>What you plan to call yourself. Suggestions: Any character name you would choose for a station character OR an AI.</td></tr>"

		dat += "<tr class=\"d0\"><td>Description:</td><td>[candidate.description]</td></tr>"
		dat += "<tr class=\"d1\"><td><a href='byond://?src=\ref[src];option=desc;new=1;candidate=\ref[candidate]'>\[Edit\]</a></td><td>What sort of pAI you typically play; your mannerisms, your quirks, etc. This can be as sparse or as detailed as you like.</td></tr>"

		dat += "<tr class=\"d0\"><td>Preferred Role:</td><td>[candidate.role]</td></tr>"
		dat += "<tr class=\"d1\"><td><a href='byond://?src=\ref[src];option=role;new=1;candidate=\ref[candidate]'>\[Edit\]</a></td><td>Do you like to partner with sneaky social ninjas? Like to help security hunt down thugs? Enjoy watching an engineer's back while he saves the station yet again? This doesn't have to be limited to just station jobs. Pretty much any general descriptor for what you'd like to be doing works here.</td></tr>"

		dat += "<tr class=\"d0\"><td>OOC Comments:</td><td>[candidate.comments]</td></tr>"
		dat += "<tr class=\"d1\"><td><a href='byond://?src=\ref[src];option=ooc;new=1;candidate=\ref[candidate]'>\[Edit\]</a></td><td>Anything you'd like to address specifically to the player reading this in an OOC manner. \"I prefer more serious RP.\", \"I'm still learning the interface!\", etc. Feel free to leave this blank if you want.</td></tr>"

		dat += "</table>"

		dat += "<br>"
		dat += "<h3><a href='byond://?src=\ref[src];option=submit;new=1;candidate=\ref[candidate]'>Submit Personality</a></h3><br>"
		dat += "<a href='byond://?src=\ref[src];option=save;new=1;candidate=\ref[candidate]'>Save Personality</a><br>"
		dat += "<a href='byond://?src=\ref[src];option=load;new=1;candidate=\ref[candidate]'>Load Personality</a><br>"

		M << browse(dat, "window=paiRecruit")

	proc/findPAI(var/obj/item/device/paicard/p, var/mob/user)
		requestRecruits()
		var/list/available = list()
		for(var/datum/paiCandidate/c in paiController.pai_candidates)
			if(c.ready)
				var/found = 0
				for(var/mob/dead/observer/o in mobz)
					if(o.key == c.key)
						found = 1
				if(found)
					available.Add(c)
		var/dat = ""

		dat += {"
				<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' />
				<style type="text/css">

				p.top {
					background-color: #AAAAAA; color: black;
				}

				tr.d0 td {
					background-color: #CC9999; color: black;
				}
				tr.d1 td {
					background-color: #9999CC; color: black;
				}
				tr.d2 td {
					background-color: #99CC99; color: black;
				}
				</style>
				"}
		dat += "<p class=\"top\">Requesting AI personalities from central database... If there are no entries, or if a suitable entry is not listed, check again later as more personalities may be added.</p>"

		dat += "<table>"

		for(var/datum/paiCandidate/c in available)
			dat += "<tr class=\"d0\"><td>Name:</td><td>[c.name]</td></tr>"
			dat += "<tr class=\"d1\"><td>Description:</td><td>[c.description]</td></tr>"
			dat += "<tr class=\"d0\"><td>Preferred Role:</td><td>[c.role]</td></tr>"
			dat += "<tr class=\"d1\"><td>OOC Comments:</td><td>[c.comments]</td></tr>"
			dat += "<tr class=\"d2\"><td><a href='byond://?src=\ref[src];download=1;candidate=\ref[c];device=\ref[p]'>\[Download [c.name]\]</a></td><td></td></tr>"

		dat += "</table>"

		user << browse(dat, "window=findPai")

	proc/requestRecruits()
		for(var/mob/dead/observer/O in mobz)
			if(asked.Find(O.key))
				if(world.time < asked[O.key] + askDelay)
					continue
				else
					asked.Remove(O.key)
			if(O.client)
				var/hasSubmitted = 0
				for(var/datum/paiCandidate/c in paiController.pai_candidates)
					if(c.key == O.key)
						hasSubmitted = 1
				if(!hasSubmitted)
					spawn question(O.client)

	proc/question(var/client/C)
		asked.Add(C.key)
		asked[C.key] = world.time
		var/response = input(C, "Someone is requesting a pAI personality. Would you like to play as a personal AI?", "pAI Request") in list ("Yes", "No")
		if(response == "Yes")
			recruitWindow(C.mob)
