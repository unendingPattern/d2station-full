/client/proc/only_one()
	set category = "Fun"
	set name = "THERE CAN BE ONLY ONE"
	set desc = "Makes everyone into a traitor and has them fight for the nuke auth. disk."
	if(!ticker)
		alert("The game hasn't started yet!")
		return
	if(alert("BEGIN THE TOURNAMENT?",,"Yes","No")=="No")
		return
	for(var/mob/living/carbon/human/H in mobz)
		if(H.stat == 2 || !(H.client)) continue
		if(is_special_character(H)) continue

		ticker.mode.equip_traitor(H)
		ticker.mode.traitors += H.mind
		H.mind.special_role = "traitor"

		var/datum/objective/steal/steal_objective = new
		steal_objective.owner = H.mind
		steal_objective.set_target("nuclear authentication disk")
		H.mind.objectives += steal_objective

		var/datum/objective/hijack/hijack_objective = new
		hijack_objective.owner = H.mind
		H.mind.objectives += hijack_objective

		H << "<B>You are the traitor.</B>"
		var/obj_count = 1
		for(var/datum/objective/OBJ in H.mind.objectives)
			H << "<B>Objective #[obj_count]</B>: [OBJ.explanation_text]"
			obj_count++
		new /obj/item/weapon/pinpointer(H.loc)

	message_admins("\blue [key_name_admin(usr)] used THERE CAN BE ONLY ONE!", 1)
	log_admin("[key_name(usr)] used there can be only one.")