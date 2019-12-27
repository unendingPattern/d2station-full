var
	jobban_runonce	// Updates legacy bans with new info
	jobban_keylist[0]		//to store the keys & ranks

/proc/jobban_fullban(mob/M, rank)
	if (M.client)
		jobban_keylist.Add(text("[M.ckey] - [rank]"))
		jobban_savebanfile()

/proc/jobban_isbanned(mob/M, rank)
	if(_jobban_isbanned(M, rank)) return 1//for old jobban
	if(M)
		//LIST YOUR GOLD JOBS HERE GUYS
		if((rank == "Clown") || (rank == "Mime") || (rank == "Prostitute") || (rank == "Retard") || (rank == "Monkey") || (rank == "Lawyer"))
			if(M.client.goon)
				return 0
			else
				return 1
		if(is_important_job(rank))
			if(config.guest_jobban && IsGuestKey(M.key))
				return 1
			if(config.usewhitelist && !check_whitelist(M))
				return 1
		if (jobban_keylist.Find(text("[M.ckey] - [rank]")))
			return 1
		else
			return 0

/*
working but not needed
/proc/jobban_isbanned_for_heads(mob/M)
	if(config.guest_jobban && IsGuestKey(M.key))
		return 1
	if(config.usewhitelist && check_whitelist(M))
		return 1
	for (var/rank in head_positions)
		if (!jobban_keylist.Find(text("[M.ckey] - [rank]")))
			return 0
	return 1
*/

/proc/jobban_loadbanfile()
	var/savefile/S=new("data/job_full.ban")
	S["keys[0]"] >> jobban_keylist
	log_admin("Loading jobban_rank")
	S["runonce"] >> jobban_runonce
	if (!length(jobban_keylist))
		jobban_keylist=list()
		log_admin("jobban_keylist was empty")

/proc/jobban_savebanfile()
	var/savefile/S=new("data/job_full.ban")
	S["keys[0]"] << jobban_keylist

/proc/jobban_unban(mob/M, rank)
	jobban_keylist.Remove(text("[M.ckey] - [rank]"))
	jobban_savebanfile()

/proc/jobban_updatelegacybans()
	if(!jobban_runonce)
		log_admin("Updating jobbanfile!")
		// Updates bans.. Or fixes them. Either way.
		for(var/T in jobban_keylist)
			if(!T)	continue
		jobban_runonce++	//don't run this update again

/proc/jobban_remove(X)
	if(jobban_keylist.Find(X))
		jobban_keylist.Remove(X)
		jobban_savebanfile()
		return 1
	return 0
