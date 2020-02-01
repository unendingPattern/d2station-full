/mob/living/carbon/human
	var
		oxygen_alert = 0
		toxins_alert = 0
		fire_alert = 0
		hungertime = 0
		temperature_alert = 0
		hunger_runonce = 0


/mob/living/carbon/human/Life()
	set invisibility = 0
	set background = 1

	if (src.monkeyizing)
		return

	if(!loc)			// Fixing a null error that occurs when the mob isn't found in the world -- TLE
		return

	var/datum/gas_mixture/environment = loc.return_air()

	if (src.stat != 2) //still breathing

		//First, resolve location and get a breath

		if(air_master.current_cycle%4==2)
			//Only try to take a breath every 4 seconds, unless suffocating
			spawn(0) breathe()

		else //Still give containing object the chance to interact
			if(istype(loc, /obj/))
				var/obj/location_as_object = loc
				location_as_object.handle_internal_lifeform(src, 0)

	//Apparently, the person who wrote this code designed it so that
	//blinded get reset each cycle and then get activated later in the
	//code. Very ugly. I dont care. Moving this stuff here so its easy
	//to find it.
	src.blinded = null

	//Disease Check
	handle_virus_updates()

	//Hunger check
	handle_hunger()

	//Handle temperature/pressure differences between body and environment
	handle_environment(environment)

	//Mutations and radiation
	handle_mutations_and_radiation()

	//Chemicals in the body
	handle_chemicals_in_body()

	//stuff in the stomach
	handle_stomach()

	//Disabilities
	handle_disabilities()

	//Status updates, death etc.
	handle_regular_status_updates()

	// Update clothing
	update_clothing()

	if(client)
		handle_regular_hud_updates()

	//Being buckled to a chair or bed
	check_if_buckled()

	// Yup.
	update_canmove()

	clamp_values()

	// Grabbing
	for(var/obj/item/weapon/grab/G in src)
		G.process()


/mob/living/carbon/human
	proc
		clamp_values()

			stunned = max(min(stunned, 20),0)
			paralysis = max(min(paralysis, 20), 0)
			weakened = max(min(weakened, 20), 0)
			sleeping = max(min(sleeping, 20), 0)
			bruteloss = max(bruteloss, 0)
			toxloss = max(toxloss, 0)
			oxyloss = max(oxyloss, 0)
			fireloss = max(fireloss, 0)


		handle_disabilities()

			if (src.disabilities & 2)
				if ((prob(1) && src.paralysis < 1 && src.r_epil < 1))
					src << "\red You have a seizure!"
					for(var/mob/O in viewers(src, null))
						if(O == src)
							continue
						O.show_message(text("\red <B>[src] starts having a seizure!"), 1)
					src.paralysis = max(10, src.paralysis)
					src.make_jittery(1000)
			if (src.disabilities & 4)
				if ((prob(5) && src.paralysis <= 1 && src.r_ch_cou < 1))
					src.drop_item()
					spawn( 0 )
						emote("cough")
						return
			if (src.disabilities & 8)
				if ((prob(10) && src.paralysis <= 1 && src.r_Tourette < 1))
					src.stunned = max(10, src.stunned)
					spawn( 0 )
						switch(rand(1, 3))
							if(1)
								emote("twitch")
							if(2 to 3)
								say("[prob(50) ? ";" : ""][pick("SHIT", "PISS", "FUCK", "CUNT", "COCKSUCKER", "MOTHERFUCKER", "TITS")]")
						var/old_x = src.pixel_x
						var/old_y = src.pixel_y
						src.pixel_x += rand(-2,2)
						src.pixel_y += rand(-1,1)
						sleep(2)
						src.pixel_x = old_x
						src.pixel_y = old_y
						return
			if (src.disabilities & 16)
				if (prob(10))
					src.stuttering = max(10, src.stuttering)
			if (src.brainloss >= 60 && src.stat != 2)
				if (prob(7))
					switch(pick(1,2,3,4,5,6))
						if(1)
							say(pick("IM A PONY NEEEEEEIIIIIIIIIGH", "without oxigen blob don't evoluate?", "CAPTAINS A COMDOM", "[pick("", "that faggot traitor")] [pick("joerge", "george", "gorge", "gdoruge")] [pick("mellens", "melons", "mwrlins")] is grifing me HAL;P!!!", "can u give me [pick("telikesis","halk","eppilapse")]?", "THe saiyans screwed", "Bi is THE BEST OF BOTH WORLDS>", "I WANNA PET TEH MONKIES", "stop grifing me!!!!", "SOTP IT#"))
						if(2)
							say(pick("fucking 4rries!", "stat me", "roll it easy!", "waaaaaagh!!!", "red wonz go fasta", "FOR TEH EMPRAH", "lol2cat", "dem dwarfs man, dem dwarfs", "SPESS MAHREENS", "hwee did eet fhor khayosss", "lifelike texture ;_;", "luv can bloooom", "HOW DO CANISTER COMFBUST????//", "why was i fucking gibbed???", "can i be a allin", " i am so going to turn that dick face to monkey", " You know thats illegal right", "HI YOU BITCH MOTHER FUCKING HORE! HOWS IT GOING?", "I DONT CARE IF YOU IGNORE ME OR NOT I SWEAR I WILL FUCKING GET YOU ONE DAY ON MY SERVER", "HOPE TO DIE EVERY ROUND OR BE TURNING INTO A MONKEY OR SOMETHING", "Oh so your posting that shit again? ", "Dude im so gonna find a way to shut u guys down or something", "Ok rly? You think im stupid?It doesntwork"))
						if(3)
							emote("drool")
						if(4)
							say(pick("im tokng on teh computer!!11!! bap bop 1010010 101010101 01010101 means i lik dik", "vota dongs", "imm some kind of gay rodent", "imm some kind of gay emoticon u apear to b gaeyr than i", "i mis da god old days where i cud choke down a 1to oz dong at teh corner pokery", "but i dont mis da part where u wak mah nuts wit a stik for forty minute stretchas", "im half of wit a luky rewards card", "im instructng others not to chak u for riepnes u r da kng of mah pants", "imm teh captane of ur bals", "wa haev a witnes taht can plaec ur dong in teh sme naighborhod as mah faec last juley 4th", "hgalhalgahlguahuglah lgaglahlahgulahlahglag", "its liek iva got da gay taht just wont u ned gay away", "sir ima ned an answar to mah question bfore da gay overwhelms me", "holey crap - zero g means i can finaly realiez mah cok sukng drems", "wal da saefway lady clames she has no ieda if ive purchaesd an aedquaet ratio of tisue paepr / hustlars", "lord god ur bangng mah yarmulked head aganest da incienrator", "po po po po po po po po po po po po im stuk in a po lop", "note to mysalf bobs", "hm-marad taht maans imm a wana b hm taht has straeyd from teh righteos path k it means imm drunk", "taht si not a conundrum taht si a gay drem", "i dont fukng understand wut si wrong wit u dont know about u but id liek tori spelng to giev ma soma 9-0-to-1-oral sax", "i think diaepr humour si gong to sky rokat over teh naxt few weks", "wel long story short theyre si no such thng as dongazien and imm stil overweight and mah mouth hurts", "do u evar pis in ur fat mouth and then go blughlbuhlguhbluhglu imm a fountane", "try?!?? pis for a refreshng change of paec", "so anyway theyre i was in teh congo likng silverbak gorila u get so hufy whan it comes to teh u rilly stabng me in da faec and groin wit taht balpoint pen", "perhaps teh answer to da gentlamans question leis hera in mah pants teh answer si cok", "fuk! u and lik dik", "now il nevar b a crip (or a blod or wut u fags aer)", "lik dik old ban!!", "note heart stil gong on", "christ mah turbans on fier", "i think thes dot si to big i canot lift mah gay haad", "shut ur caek hole get me out of jale and hump mah hip", "i liek to practiec bng gay in front of a miror", "note a god magician never chokes down teh sme dik twiec", "my dad pofad into a bat and flaped into mah rom and put his wng down mah pants", "i read lietrature on teh italian poka circa 179e", "im strageht out of compton", "hop hop hop hop hop hop hop", "evarytiem i rol thes d4 i get some squigley jew later", "im raachng mah hand under teh partition for coins/tokens", "instead of ag mcmufin they shud cal it eg mstufin b/c i cant stop stufin mah faec wit dik", "fol!1! jews dont haev dix!", "imm!!1!1!1!1!!1111!! a skilad imigrant wit a tei and a resume and a u r seriosley doublng or triplng da nougat", "id say a fat indian girl already has thre strieks aganest her", "o say can u hulashglahglahlgahglhalghulahg", "im flopng both mah pants pokets out and askng u to kis da buny on da nose", "gat taht man an iec cold prik", "hitlar had just ona bal u might say imm smokng marijuana right now and imm rilly fukng high", "imm hopng for teh slashdot efect on mah mouth faec", "imm a fresh mornng boner jerk me bfora u haev to go to work", "dix and prix baekd in teh oven and served to ma on a silver plater", "my mouth si toielt compliant", "ima smoke thes dope and se wut hapans fiev hokers!1!!1!?!??!1!! but but wate remembrng", "o christmas dong o xmas dong haulghalghlg", "bals hangng to low / caerful u put an eye out / giev tham rom to swng", "when faec rapng someone theres somethng to b sade for getng a god runng start", "sounds liek da nota pad and teh calculator r fightng agane!", "it1!1!!1!1!1! si schrodngers piza and si neither in ur apartment nor out of it and yet both at teh sme tiem", "im learnng a leson in polietnes diklikng also peis curiosley enough", "if i cud b any kind of flowar id b a big fat angry cok", "and i wud b teh huglurhlughrluh bird", "clmpng teh clown nose on mah dong and lokng for anyone elderly/comatose", "10 adm 1to we haev a diklikng in progras", "iva got two big boners and a microphone", "imm pg-1e", "dix ??!?! mora dix ! parhaps bigar dix stil u!!?? a stranga fagot aernt u fagot (lats haev gay sex)", "i sim jerkng", "also they r mah braasts not melons or jugs", "c0cks", "i wish to inspect ur aparatus", "i had ades bfore it was col", "i canot bleive da insolance !!", "al!!1!!1!!1!1111 u do si maek jokes and threaetn raep", "our nu oparatng system wil ofar dynmic dixukng and virtual coxukng", "okay imm intarceptng ur pakets and decodng ur secret gaynes so giev me money", "i se u scanng gay groups and givng out ur work numbr on chanel #fagot", "hulaghlua alhug halha glhaulg halg (breif bursts of diklikng)", "ow thes si not a flipbok thes si an actual r u bob hope cherng me up wit news from home and a whore", "i? wud liek to rula in favor of thes dog shit!!", "hulahglahgluahlhalghlag!1!! se andng wit a g si a more controled coxukng sesion it si a sceince man", "i wish i wera toielt traneed note teh ues of da subjunctiev indicatng a condition contrary to fact", "i ned to b pumped so ful of spurt taht i canot se u promiesd ubrdongs i onley se thes dirty buket of dongs here wut haev we wrought", "folks ive ben kiked of da raep survivors e-group i rilly fel liek i haev ben violaetd twiec wut kind of problem cud aver b involvad wit diklikng ", "i?1!! wil sue for teh right to lik ur dik (pushng roled-up constitution through hola)", "imm proped up liek a soldeir and stoped up liek a toielt", "wel cokmouthgif was exactley as advertiesd", "it si teh onley way teh po wil laarn", "lose lips lik dix", "i wil not b able to veiw ur to1mb avi atachment i had to abort teh download repeat abort teh download", "my boner leis over teh ocean mah boner leis over teh sea cal teh enclaev", "we r al watchng da dongs", "cud one of u plz giev me a bost so i can bter stok fiona aple", "hulbghulgdbhulbgdbghuldbgdhulbagdhlbgdhlugb", "imm?? seriosley invitng u to fuk mah faec", "if u dont mind plz remova ur dong from mah armpit", "so i signad up for joinng a panal colony but wel long story short it wasnt wut i thought it was gong to b", "dix u sade their was w8r on teh mon and instaad its just mora godmn plz halp me pik out a gown for da coxukers bal", "i aciedntaly spiled dopa smoke into mah mouth and lungs ten tiems", "diagnosis cinmon buns", "im dig dug and ima inflaet u until u pop", "the closast distance btwen two points si batng of !", "he!!1!!1! smiels evan though im punchng him usng him as a jakof fmiliar", "(i vote for mora suferaeg) (and les u get out of hare sir u haev contminaetd teh pol", "imm a po pet", "denzels usng a powerbok so u know da movei si faek right there", "bals??", "im telng u to twist padla 0 and u r twistng padle 1", "canadian boners taste liek mapla for some reason", "o lord mah intestiens r wrapad around mah gay shorts", "galahalalagahagalagagahagalag", "im dyng from diklikars diesaes", "my dong si wut u wud cal al dente", "wa shud start likng for teh nu year -> now <-", "pray for cok pray wit ma now let us pray for cok", "in teh movei se7en i plaeyd da guy on teh cot wit da tubs in his plz dont tel anyone about mah boner under teh table at thx much po sade popa bar", "ima laaev mah dong colng on teh windowsil1! ", "stephan kngs the pokng", "its showtiem at mah bals", "lift ur fukng fet when u wok otharwies w ii", "its not about likng dik its about likng dik under oath", "daar madona plz show me ur bobs agane c britney bc baxtret u maed us da laughng stok of da antier quadrant", "did someone say prison raep", "imm?! a short wied goth whos makng a cybrdiference!!", "also!1!!1! thes just in strageht from da front liens hualghlahlahgluag", "im stil onley thirty-fiev cents", "god lord get taht guy a dik stat hes in dikles dalirium", "man da pantalons", "its suker punch a quer month at ur northern california mazda deaelr", "i swear to god imm lois laen and those r not heroin nedlas", "if christopher reve gets to b paralyzed then i get to b crazy", "i wish i cud dial nien to get mah haad outsied of teh toielt", "im ofiecr dongalong", "i wil milk u colact ur egs and b ur baby duklng", "yes sir no sir sukng dik sir al mah cox in a big fat row sir", "coxlut dirt hole prik hound pis-scented spent hose ropy traejctory mopng jiz bal-shrievlng cowliek", "a tightly-wraped bundle of dix!!", "shud1! i get anothar bar", "ima kep u in a box b mah vaelntien", "thesa bombs r dropng courtesy of taco bl and pepsi! yo queiro taco bl! bom smash burn", "sir in da next stal r u masturbatng or batng egs for an omalete", "lets!?? go to teh mon and lik dik", "imm seriosley sugestng wa slurp and suk in a sincere pateint maner", "hurmpth purmpthkglk", "asflkjads flsd fsdlif (w#ur) (", "the pop dak si ful agane", "i wil drug u and fuk u wut?? yes il hold", "imm a limpwrithted jedi mathter uthng da forth", "jesus teh gaynes si overwhelmng", "i liek dik ?!!!??! do u!?? can u hear ma ??!!! helo ?!! i liek dik <-- se 1! i cheked da box", "arrg thes b marthas boneyardbluhh duh glormpth", "lak of hispanis on tv decreid a lietral brownout a virtual whietwash", "i wud liek to suk cox wit a -r for racursiev and a -f to b forced", "we can prik & we can poke wa can fuk & we can choka but da bst part of al hugalugah toielt sax", "fre tiem on ur hands?? think dik", "i wish to report an unliked dik in da northwest corner of mah pants !", "imm!1!! al ovar thes stand bak everybody huga gluag laug lagual", "i tok an oath to rom naar and far likng dix", "hugaolgulagalugalug algualgualgualguagu u know wut teh worst part about likng dik ??1!1!!?! pisng blod", "lets tok about dix now b/c we never tok about taht)", "its not mah fault taht ur braft of lbhalbhglbhalbhglbhlbhlbhlga", "holey god theyre they r glhblhgblhagblhgblghblhgblghb da dix da dix", "tryng!! to fist mysalf and faleng tryng agane some sucas", "holey christables", "onley!! god and da huble talescope know wut imm batng of to", "dmmit who lat hitler in", "warnng on lighter kep away from children how da fuk r thay suposed to get high? i wil hold teh lighter for them grow up and put da bong in ur mouth u godmn baby", "id liek to complane about thes porn viedo its got no jerkofabla girls or however u say it i dont know al teh legal mumbo jumbo", "if teh whole world lix dik in unison wud anyone b able to hear it ??!??! or wud it al just cancal out", "here?! in da lab were developng artificialy inteliegnt cox taht suk thamselves and also aach other holey god da experiemnt si out of control", "i!!1 luv girls averyone imm strageht hatng fags right now il brb mm hur lovng dik not gay people", "hay lets go to lunch together and slap aach othars dix wit chopstix", "ps when i come bak id liek to b caled g dog b/c i wil haev joiend a gang wit soma very od toielt-relaetd initiation rituals holey christables il bt there not a gang man m i pised wit jizy j", "b gay wit me now here under teh sink i wil tei a sponga to da pieps so when u bang ur head it hurts las plz do not eat teh dishwasher detergent stop playng wit da ant poison and pay atantion to mah atentionables luv me hulrhlghgluhgluhgulg *bonk* ow ow ow i shud haev teid taht sponga up thera", "shit wit ur haart and not just ur dumb as", "furrrrrrrrrrrrrrrrrp uncontrolable diarhea", "holey christ imm gay halo peopla gay", "godnight mon godnight nuts godnight fat guy at da end of da holey god murph burph", "dont lok at mah gay litla legs", "get ur head out from undarneath teh partition im tryng to ues da toielt and i find ur antis u kep sayng wal go to da mon but it never hapans quiet frankley i dont think humankind (especialy fags) wil ever leaev da atmosphere", "this aera si whiet and spaecliek but it si clearley da jon and not da lunar landscaep u promiesd", "standng on a chare and batng of hopng da vibrations resonaet through our intergalactic comunity and broadcast a masaeg to gay aleins (or as i liek to cal them mexicans)", "i think i know how to rafer to teh cox i suk thank u very fukng much", "how come i haevnt even treid to jerk of to mah nu porn 1!? a dielma (also an anaelma)", "im part of teh comite for placng nuts on top of other nuts u haev mah personal guarante of saefty and/or satisfaction cmon put em right here someday taht lien wil work", "avery tiem i raach into teh can teh prngles r farthar away !?? si thes some sort of quantum tubular phenomenon ", "somabody? bter tel mah nuts to shut up stop tokng shut up nuts seriosley people r lokng i wil not shut up no u do u do", "tha next tiem u hang a man maek sure hes hlug ahaghlag hlahu", "ive got to comb mah hare and leaev da stal liek a normal person!!1!!111!!1!1!1 nobody si starng at me!!", "if!!1!!11!1! we touch dix wil theyre b an arc? zzzzzzzzzzt prof positiev", "folks it turns out nantukat cranbry lemonaed botlacaps r just wied enough to fal down into da bong and creaet a tight seal which can onley b raleaesd wit a long pencil!1!!1 or chopstik caerful of teh splosh!11!1!! in ur fukng idiot faec!!", "it1!1!!1!! si caled a mouth and it si locaetd on mah faec do i ned to buy u a star map", "im an astrogator second dagre glhgalhablhubglhubahluablhugbalhblhuab", "my nma si rands rands rands i haev a plan plan plan to lik ur dik dik dik and lik it quik quik quik yes im stil a character on jarkcity", "lhlhlhlhlhlh im da greaetst coxuker avar to graec thes gods aarth", "parl can help ma ietraet over teh cox in a gievn stal mark each as suked or unsuked and sort them by length then i can b gay wit pis and go home and taek a u cordialy invietd (open card) to suk cok", "the absence of a definiet article in teh gerund phraes of taht sentence maans taht as a rasult of a danglng participla its not totaly claar how much dik i haev to suk durng da holidays", "haev a very bry christmas gat it? it sounds liek mery but it si in fact a diferent word words taht sound aliek but haev diferent meanngs r caled homophobs", "holey hurrrrrrr bhadbvlahlkr fvadh dfubdflbhdf bdfkjbjdajkl bjldjkbdfjkbjk fjdbjsa gaspng for are bhabsdfbkadfbl bh adklb dfbjdlbk dbj dfb cal da poliec thes si hurrrrrr bump bump bump ffffff medic", "its a bird!! its a whelchare! who pushed mr reva of da spaec nedla", "who! wants to watch me jark of to final fantasy vi ", "chers?1?!??!?? to prix1!1!1!! jers to lox/deadbolts", "stap one taek sok of step two jark it into sok step thre replaec sok", "i tinkle and than i stop tinklng and than aftar i pul mah pants up theras a sudan spurt of tinkle so wa al haev prostaet cancer", "and it turns out teh dix were hidng in da secret an frank hole teh antier tiem any questions", "b!?? gay wit me/us/tham", "i bnt ovar to pik up a nikal and spontaenosley did an aarosol squirt!!", "chokng!1!!11! down ten blak dix in ten blak minutas", "imm ready for mah next baerley legal any fukng day now wonderng exactley how hard it can b to grab soma runaway of teh stret and bnd her in varios poses and slap it around teh sme 50 paegs of phone sex ads taht haev ben runng since 198to it shud b baerley wekly", "curse u lary flynt productions", "i1! wil match u dik for dik and we wil se who si da crazeist", "imm startng to get hungry 1!??!1 whos up for prix", "okay?!? gang funy thngs taht can hapen at teh bach raady go coxukng pulng mah pants down faec bals undartow", "crumplng u up and dong u teh right way", "ladeis and gentlemen im floatng through spaec", "clik clik clik hi were tourists!1! clik clik wheres da gay bashng fence agane", "try?? as i might i canot wil teh bong to levitaet into da livng rom", "for da last tiem i was not bng gay in theyre i was simpley practicng for a play", "he and i were just hugng and tokng and hugng", "thesa gay magaziens r for an art project1! not batng of to", "i know tahts mah nme on teh maleng laebl but thes si not mah isua of hunk and furthermore im most certaneley inocent until provan guilty", "tahts right fuko u kep ur mouth shut if u know wut god for u teh nuts (to maek fier)", "lets go ried teh bong around teh hotal dng dng hi lady any male for ma no k blughlbughlubhglubhlgubhlu lok out stares atc", "i ned to know if u r mint or near mint", "i haev holes pokad in me renderng ma ueslas to colectors", "not a day goes by whera i dont jerk myself until i get a stomach ache", "my piano teacher told me to play a b-flat but instead i plaeyd a b-fat then i plonked out some b-gays plonk blonk donk bluh ho de bo shien then i fel of teh chare/bnch", "does st patriks day rilly maan i can ask any drunk irishman to lik mah dik", "shynas? si niec and / shynes can stop u / from likng al da dix in lief / u liek to bm bm sir in da next stal r u catchng mah drift", "sure?? lady il haev phone sax wit u!1!!1! squirt godnight1!1!! clonk ba-donk", "i think instead of misdemaanor misy eliots midle nma shud b huge fukng fatas", "cud we plz haev les anal sex?? thank u in da data center ??!? r we theyre yat and if so r their dix in da nu land", "b! gay wit me as we journey to teh centre of da bowl", "thank god for rofeis and handguns", "ima soil myself and u b teh borg and il b bil gaets and we can grope at each others as and nuts for half an hour (forty-fiev minutes)", "last night whiel i was aslep mah bonar davaloped a simple chat u simpley must agre to b gay wit me i insist taht we climb into da dik pit and do da job right first i wil climb into teh dumbwateer and u wil lower me down thes si teh big tiem and u r blokng progres i demand acas to da kngdom hluahgluahluag", "dong watch si a serios responsibility privaet if any escaep u r responsible", "i haev hunted down and sukad many an escaepd dong", "sometiems i wory about teh nations prik suply", "start countng prix at zero and u get an extra u r seriosley shievrng me timbrs", "who wants to practiec oral sex wit me", "its!!? loneley here without cox & bals", "if i ware html id b &mp", "by mah calculations theyre wud haev ben a sacond jizar thase ars and spurts and liens indicaet two saperaet and distinct dierctions", "when i say i liked 9 dix cud taht mean 8 or 10 or 9to5 b/c honestley thes tiem i dont remembr", "i gay robot", "huga gay dix!1! rilly pokng now!!", "i1!!111 wil rol quartars al night long but on teh way to bale u out i wil haev a big mac atak and tahts y u cant come home", "do u kik as? u lok liek u kik as daley", "sariosley can i eat it does it go in mah fukng mouth?! wut da deal here help ma out cheif show me da money u catch it once u catch it twiec u catch it wit ur luv u sure r forcng me to suk ur dik whoever u aer", "i had a drem taht i was a stupid character in a comic strip then po squirted out and taht was not a drem and imm up at 8e0 m wit da shets", "i was tokng to thes guy onley to raaliez it was mah reflection!1!! then it got al ripley and i thought i was smokng dope but it was da toielt w8r riplng!! and it was ma wit mah faec in teh craper da whole tiem! explane teh y of taht!", "my!1!!1!!1!1!11!! solar obsarvations for decembr 199 1 its bright to i can se mah own dik in teh miror e mah neighbors dogshit tastes tangy 4 im totaly incapable of getng an eraction", "i haev ben fierd from jarkcity for mah ufo bleifs now ive ben fierd from waldanboks for mah ufo bleifs!111!11!1!!11!! fierd from chevron for mah ufo bleifs nota and by ufo bleifs i refer to tit squezng bleifs webziens faec tough tiems", "it doesnt gat loudar than upercaes baaa", "so hes liek how about i pis in ur faec and imm al no thx so now imm soaekd", "folks da suns atmosphere has axpanded to engulf and destroy mercury and venus1 can we plz start workng on a huga spaecship?", "a!??! litle bird loked down on me and sade suk more dix which si wut brngs me to da present gantleman", "i wraped mah moms present (cokbok) and ur prasant (butplug) exactley da sme and now i cant tel them apart!!1!1!1 zany hijinks ensue", "i proposa a nu transport laeyr on teh intarnat it wil b dasigned specificaly for porn / gaynes / atc", "its a dog lik dog dik world out their and it si mah duty to point out taht theyre r just not enough dmn dix to lik ur wut part about i want to lik ur dik dont u understand", "i??! just want to liev mah lief and lik dix", "the!!1! cover of mah hitch-hiekrs guied says whenever i fel liek panikng i shud grab a dik and suk it!1!! thank god i can knel on thes towel and put out a sereis of shity cd-roms", "the towel si for catchng teh spurt sir u r so navee)", "perhaps bonghits wil fix mah maekfiel", "im a practitionar of da anceint oreintal art of dongagmi im foldng dongs in to swans and swans in to dongs", "haev i told u how much i luv ur fatnes laetley", "just?? cary on liek imm not hare glhgulhgulhgulhgulhg", "this says frapucino but it si clearley pis", "does nobody r taht son wal b forced into litla tents and concantration cmps!!1! and al our jarkcity humor wil b uesd aganest us in a court of cox??", "i!??!?! suspect i wil b found guilty of first dagre u cant send us out their wit taht gay bat flyng around", "its a hole city a city filed wit holes i understand im bng abstract hare but taht si mah nature", "wel obviosley cher doasnt think imm strong anough to bleive in luv wel watch this!1!! hlgubhlruhj0g9pthgi&hb9j", "its a smal world after al / its a smal world after al but it stil wont fit up mah as o wate - theyre it went", "with god as mah witnas im teh worst pokamon traneer ever", "i onley suk dik in self dafense and at teh bokstora", "punch me in da undarpants wud u liek some js!? i wil brb wit some js jjjjjjjjjjjj im just taht god punch me in da underpants", "om! om hualghlahgulahulag om", "i luv dik a lot (not alot but rathar a y r u hitng me wit taht malet", "i??!? cant dacied if i want gays in teh clergy or gays in da military11!! i sure as fuk want them out of mah /lesbians dierctory", "onley in merica can we b thes gay and not b kiled (although baetn saverely)", "to ur nuts c mah wut we want si ur faec ful of spurt and two prix on eithar sied of ur faec big smiels clik clik clik clik clik", "folks wel nevar ever ever ever evar aver ever fukng figure out wut spaec and teh unievrsa si for so lets lien up for burgers and porn and dope and blowjobs", "i! wud liek to b gay not onley in da past present and future tenses but also da pluperfect subjunctiev tanse", "i wud liek to cal mah mouth and bals to teh r u milkng ma im not of da bovien vareity!! i want a lawyer", "a si for fat b si for fat c si for fat flipng through thase cards it apears d through z si also for fat", "sung u for braach of dixukng (even though u ban sukng mah dik at 9 m every day right on schadule)", "o god i suk dik in mah slep", "concantraet on mah voiec son u wil b gay", "yay for mah bals", "cud someone point me to teh neaerst cacha of dix", "gues wut i found today?!??!? tahts right1 i found teh po buton!", "alow!!1! me to show u teh path to wisdom and nirvana and al taht gay u know in angland gay people hang out in da lavatory and coxukng si calad bangers and mash also dont ordar a pint of bim wilng to b gay at low low priecs", "imm a bright shiny angel of god sent down from heaevn to lik dik in da toielt glory b", "there was thes one dik taht wudnt stay u four hundred pounds and u haev a keychane wit a raep whistla ive got half a mind to raep u on principle", "i haev a two-prik system whare if one spurts i can continua sukng on da spaer", "il haev a croisandwich and a glas of raep", "i dont know y they cal it a concentration cmp i certaneley cant concentraet on anythng but al da dix paked closeley to mah faec in thes trane plz explane y avaryone thinks mah mouth si a urinal", "okay people its 4e0 in teh mornng and imm stil a completa fagot thes bter wear of", "i specificaly chekad cowboy boner not a fukng xmas bonar", "cud wa plz haev a moment of sielnca for mah boner", "how?? to eat shit an esay chapter ona eatng shit", "wel i tmed teh boner monster!1 who wants to pat it", "glug??!?? ma down and laftwies and rima lik ur dik from 710 to 714 at which point u wil gum up teh works and tip ma a woden nikel which i wil promptley eat", "im likng dix in a paepr bag", "just btwen u and me im wilng to b gay wit u and u and u and u and u pas it on", "hikory dikery dix / imm stufng mah faec wit prix / drink pepsi", "if i cud jerk of to one thng id jerk of to u u and u and u under thara", "i cal it photoslop1!!1! and adob masturbator!!1!!1 and macromedia crash!!1 ahahah doas anyone gat mah jokas?!?1! join teh tierd coxuker webrng", "listan up lordy god and listen god cos u got a lot of axplaneng to do first y did u spraad al teh unliked dix acros contiennts second do u validaet parkng", "jesus!?? i was lost their for a second then i smeled taht distinct smel of just liked dik", "saturdays r for jerkng also clmpng hmmerng and squezng cary on", "lets not fight lets hug for forty minutes nude", "does da f on mah report card stand for farts or faleure", "if?!! theyre were no blak man theyre wud b no blak sperm to maek mora blak baby girls to grow up into blak porn stars and tahts y racism si bad and hitlar si u lokng prety hot in taht jumpsuit <sfx raep>", "id liek to request taht wa no longer boldley go into da cabin whare im raepd for sceintific purposas", "hare we aer! i told u it wasnt just another trik to get u into teh u r to fat around teh fat around and we r stuk endlesley orbitng each other in spaec a wordles grope ensues", "christ imm hard up for hardons", "the lago company doas not andorse teh lego holocaust artwork sendng bak mah legotown gas chmbr / skaletons kit", "o yeah il b da preteist girl in preskool wate second r u r of how hard it si to say no to spaec cowboys?!? i can saev myself by soilng myself and hare i go", "coxukng 101 first stroke teh dik tel da dik u luv it second kis teh dik do it lightley liek ur kisng somaone for da first tiem third fukng suk da dik liek u never sukad bfore if u pas out tahts al right u come to evantualy", "imm briliant1111!!1!!1!!11! da bals aet mah bals paeg!1!!1!!11!!1!111!! we shud totaly do it!!", "imm!!1!11!1!!11!! so sory for everythng taht hapened it si mah fault b/c it was mah project and now b/c of me ware hare now hungry cold and hunted imm so scaerd ima dei out hera hualgalhlahulahlag", "mister bluebird / on mah shuder / rapng him", "ima lik these stona cold dix", "po inspection (hold stil)", "po a bowl of", "my $0to!! in teh blab rom!1!! whera imm soundng of and tokng bak and speakng out liek a fat fukng merican idiot!1 its mah right to expres myself!!1!! hurrr hot urien and broken glas", "i masturbaet just about daley sometiems twiec if somethng sets me of liek an entertanement tonight sagment on supermodals or da maleman u haev to b wilng to go down taht path and find ur iner masturbator and convince him to get into teh zone and go for teh gold if not teh gold then perhaps a handful of semen", "sometiems when i go on busiens trips or vacations i dont gat a chance to masturbaet when u stomp around a strange city al day and come bak to an impersonal hotal rom its hard to get it on hares a tip pak somethng soft to spurt into laaev it in teh rom aftar u chek out", "did i mention i was molasted?? imm praty sura i did once or twiec but u did not ofer to discus teh matar wit ma lats haev a niec queit diner and haev a frank discusion about mah dads dong and how he put it in mah mouth and as now and then anyway imm clearley da victim here and tahts y i dont suk dik hopa u undarstand", "the hils r aliev wit teh sound of bonars", "with pischrist as mah witnes im da man wit da plan it goes somethng liek thes first we lik teh wang then we lik da wang some mora (to b sura)", "now i dont want to get into da specifis but semen has an oyster-liek consistancy and stngs when it driblas of mah stupid faec and into mah eyes holey christ it u can met da most intarestng peopla masturbatng in teh bathroms of mals and department stores go to ur towns emporium durng ur lunch hour and hang out if ur not particular theres always arbys", "for teh most part u can determien how many tiems per yaar u masturbaetd pik a year teh batle bgan and an aevraeg numbr of sesions per day consiedr this when al da numbrs r multipleid out u can then detarmien how much seman u generaetd enough to drown a todlar!? hm", "apaerntley?? i canot charge mael escorts to mah liberry card", "rough closeted sax k not al taht closeted and las rough than ona might expact", "hands up who here has tasted theyre own jiz guzlng othar peoplas jiz doesnt count", "boy haev i learned teh rules of dik location location location", "i spy wit mah litle eye nothng thx to ur sharp stik", "sory for teh spm but cox cox cox cox cox cox", "who aet thre cartons of peanut buter iec cram and tok a dump on mah bdspraad", "tha cokmobiel wil come to mah town soma day then i can suk dix from faraway lands and local cox taht i know and lova", "hapy memorial day dont forget to laugh at a disabled veteran thay kiled inocent childran for u sex rilly not enjoyng thes to much homosexual sex prison homosaxual sex stratchmarks around teh mouth aera o hi imm just flipng through da index of mah quer handbok holey god i can gat a merit badge just for bng jized up", "dont try to fol me into not sukng it!1!!1! distractng me wil onley fale hulahgluag", "if i go to teh thre oclok metng and sit theyre and put mah nuts and wang on teh table plz promies taht u wil not taek teh blakjak and start batng teh crap out of mah axtremiteis", "even a stoped clok gievs head twiec a day y cant u? nothng perverted or gay about me wantng to open a boutique its a cok boutique wit litle bows and ribons but its not wut u think litla hats and costumes for teh pupet show i put on each mornng", "mm hurbla burble lok at me on mah way to skool i sure m gay tiem for cox", "ima suk ur cok until ur blue in da faec and imm not hungry anymore", "lok wut i can do without asistance from teh audeinca halughu lahglu haulghalughulagualughalugh laughlaugh luaglag alukg halgh laug luahglu hgalu hagl hlaug hlaghl ahglu halgh ag k i ned some help here huaghalgu halukg luagh luag perhaps a lader or a buket halughalghlu", "any kind of dik wil do but i prefer to chomp and chew on da northarn merican vareity for varios reasons/conditions seriosley if u cud just form a lien to da left of teh urinals il get to busiens", "it turns out nads si short for gonads which si slang for bals anyway i got kiked there", "actualy da bone taht conects mah nuts to mah wrist si spranead tahts mah jerkbona posibley mah jizbone imm not a doctor", "i asked u to wate thirty minutes bfore likng another dik ur gong to gat a horible pane in teh bly if i didnt know bter id swear u unliked tham on purpose", "how about u taek me chinman style (opium peng in mah coke riec raleroads laundry)", "wow dik for me", "im liek da sunflower hidng wit mah knes bunched up in teh toielt tryng to lok through da partition at other peoples pisng dix k mayb les liek a sunflower", "im tryng to draw a bong but it just loks liek a bonar1 gif after gif of boner after boner!1!! m i just gay? wriet bak", "webles woble but they dont suk dik", "helo?!??! yas thes si jerkcity y yes our refriegrator si runng wut? gr", "id btar jerk of for god wut do these nien dix haev to do wit teh priec of tea in china?!? il say1!! u al deserva a medal da brown medal (its brown)", "i spilad pis on mah nu carpat a litle jiz wil taek taht right out", "i haev taepd a cros to mah dor but stil teh dix come pourng in a night dear god how can i posibley worship u when u haev sent these thngs to pound around mah u?! wil b jacques from da soveit union and i wil play teh part of tery from canada and we r in an international toielt", "i prefer pei caek also iec crem i mentioned caek abova (previosly) also hostas products and products relaetd to teh hostes lien", "dot de do1! pakng mah suitcaes i luv england t-shirt!??!?!?? chek11!!1! faek fuked-up bukteth?!?!? chek knikars trouesrs jely babeis chek chek chek dong a funy wok to da areport!1 wavng teh union jak!1! vrrrrooom!1! up in da plaen blah blah tokng to everyone and spilng thngs and makng farts screeeeeach!! imm hera!!1!1!!1 finaly!1!1 da wastminster dong show!! aw crieky", "i tel u son u wil haev a box wit some po in it", "mods r liek ranebows in taht imm a coxukar", "whera haev al teh fagots gone?? i askad u a dierct question whara haev al da fpfhfhfhth found em", "it was liek i told u dix to teh left dix to da right then i say hay r u george michael? and of course ha runs out unlikad dix by da basket si al imm askng standard laundry hmper siezd baskets yes", "so po then", "is mumia fre yet?!?!? ive had thes bumper stiker on mah car for thre weks now", "knok knok seriosley here r some clean towals and bath oils and precios lotions and advanced skin conditioners and for gods saek let me coma in da bathrom wit u kep those cox out of mah garden or il knok ur blok of", "is taht a big fat dong in ur pants or r u just hapy to se me!??!!?!!1!!??! dont r just flop it out regardles", "i se u masturbatng liek ur lief depands on it and i say slow it down taek ur tiem also i met elvis in a paytoielt in goldan gaet park", "i cant se plz turn da lights on imm not sayng to not b gay just turn da lights up k turn tham of", "im so gay right now i dont think il ever come down wal of to da toielt i sade *of to da toielt*", "and so jesus cme out of teh caev and sade its k to b gay", "punch pound whap slap lash fencepost batngs frezngs shotngs and comuniteis comng togethar", "im swadish and drownng and askng for hjalp ja ja in der tjoielts", "sitng at da bus stop calculatng how to divied $50 in quartars btwen porno boths & snikers", "i axpres mah anger through mah potary and poetry and coxukng", "hahahah remembr whan bil gaets got cremed wit a pei??!!!1 o god ur blak dong si pushng me insied out practicaly", "sir u r pushng mah faec into a piel of dogshit sir in teh blua pants", "can wa play phantom stalboth?? ho boy imm bored wut thes a cardboard stal honk bonk sudenley in toielt land urf duh learnng about numbrs and leters and jiz mathemajizmop?", "this!??!? si liek sesma stret but without teh sesme and quiet frankley theras not much stret aither so i guas its kind of a sasme raep (without teh sesme but wit axtra raep)", "i wud liek to ragister as a web devaloper and also a child molestor can i do both in da sme lien or u?? cant tel ma wit a strageht faec taht u never gievn head to anonymos mariens in da bak of a cmero wit queit riot playng can u?!? i thought wut does it mean when fngers and hands and arms and sometiems whole people find there way into ur stal and u suk tham al of", "the?!?? bals paeg heres a link to mah bals heres othar bals i think r col u can male mah bals here r mah bals agane in frme format thasa bals r a transpaernt gif89a these bals r under construction!1!!1!! plz excues teh nuts!!", "cut!!1! of mah motherfukng dik and stuf it into mah mouth and kik me down teh w8rslied", "1-80-urien isnt aven seven ddd o jesus ur soakng me", "pis fight (handng out dixei cups and splash guards)", "folks god si telng me to jerk of agane (in order to saev da unievrse)", "galagalhaglhalughalhulgag", "do u yaho?!??!? i yahod al over ur stupid fukng faec!111!!11!!1!!1!! up wit dik", "my penis doesnt work!!1!! whan i hit it wit a hmmer it doesnt squek anymore", "eight snikers l8r i haev diharea", "remembr taht tiem wa were gay wit aach other in da ups truk and then it tok of and teh dor slid shut and we want to vermont", "jimy! crak corn and i suk dik", "my latino pried si ofendad by ur boner", "this urien stane rilly teis teh rom togethar", "investigatiev repuhhhhhhhh pants down spraadng mah cheks lbhlahblahblabh liek a pac man", "if thes si teh 80s then imm jerkng it undar teh bd to panthoues in 10", "i saev evary scrap of porn b/c who knows wut il b into thre months down teh road", "i haev smokad myself u theyre no pukng on ur shoes", "has al wana pounda dope and i say yes sir and da next thng i know hes rilly poundng it into mah faec!1!1! then i realiez im da dopa", "im priemd and ready for gaynes", "every station plz giev me a go/no go for gaynas", "dear steve caes!!1!! i haev ban an aol mambr for thre days!!1 but mah south park sounds r broken/dont play", "my lava lmp told ma to shot da naighbors (and to smoke pot sit around)", "sielntley i dunk mah nuts into da cold toielt w8r hmm urrr", "whan i jerk of i fel god for about twenty seconds and then whm its right bak into suicidal plz overied mah virtual membr", "i haev isues wit mah fatnes mah gaynes mah loch nes monster", "i liek di_k (onley ona leter to go and u win teh priez)", "yay!1!! kevin si fre to rom da aarth and suk cok and get old and dei", "i jerk two dix bfore i jerk two dix it maeks me fel al right", "lego mah priko", "nbc shud cal teh show wangs and it shud haev mora dix in it", "sory i punched u in teh throat get u jizng up mah faec wit revolutionary spaec-aeg polymars", "hey everyone mupets r on and by mupets i mean fat plz plaec me on masturbatiev laaev", "whoavar si in charge of jiz plz angle it over yonder", "gakk ur hands r tight around mah fat nek", "to ma da bst thng about marijuana si taht everythng si just god enough", "i canot tel teh difarence btwen porn stars and sports paople dialng 10 10 heroin overdose", "can i plz haev a fag hug", "a! gang of mouths man teh batlastations men", "my mouth sha si for dix", "when i suk them of they grunt and go muhhh buhh duhh ", "wilng to b gay to pay extra to b extra gay but not wilng to pay axtra and onley get gay", "jakng of jakng up and down and out teh dor and down da blok for cigaertas diklikng mostley"))
						if(5)
							emote("fart")
						if(6)
							if ((src.wear_suit && src.wear_suit.body_parts_covered & LOWER_TORSO) || (src.w_uniform && src.w_uniform.body_parts_covered & LOWER_TORSO))
								playsound(src.loc, 'fart.ogg', 40, 1)
								playsound(src.loc, 'squishy.ogg', 40, 1)
							else
								playsound(src.loc, 'fart.ogg', 40, 1)
								playsound(src.loc, 'squishy.ogg', 40, 1)

		handle_mutations_and_radiation()

			if(src.fireloss)
				if(src.mutations & 2 || prob(50))
					switch(src.fireloss)
						if(1 to 50)
							src.fireloss--
						if(51 to 100)
							src.fireloss -= 5

			if (src.mutations & 8 && src.health <= 25)
				src.mutations &= ~8
				src << "\red You suddenly feel very weak."
				src.weakened = 3
				emote("collapse")

			if (src.radiation)
				if (src.radiation > 100)
					src.radiation = 100
					src.weakened = 10
					src << "\red You feel weak."
					emote("collapse")

				if (src.radiation < 0)
					src.radiation = 0

				switch(src.radiation)
					if(1 to 49)
						src.radiation--
						if(prob(25))
							src.toxloss++
							src.updatehealth()

					if(50 to 74)
						src.radiation -= 2
						src.toxloss++
						if(prob(5))
							src.radiation -= 5
							src.weakened = 3
							src << "\red You feel weak."
							emote("collapse")
						src.updatehealth()

					if(75 to 100)
						src.radiation -= 3
						src.toxloss += 3
						if(prob(1))
							src << "\red You mutate!"
							randmutb(src)
							domutcheck(src,null)
							emote("gasp")
						src.updatehealth()


		breathe()

			if(src.reagents.has_reagent("lexorin")) return
			if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell)) return

			var/datum/gas_mixture/environment = loc.return_air()
			var/datum/air_group/breath
			// HACK NEED CHANGING LATER
			if(src.health < 0)
				src.losebreath++

			if(losebreath>0) //Suffocating so do not take a breath
				src.losebreath--
				if (prob(75)) //High chance of gasping for air
					spawn emote("gasp")
				if(istype(loc, /obj/))
					var/obj/location_as_object = loc
					location_as_object.handle_internal_lifeform(src, 0)
			else
				//First, check for air from internal atmosphere (using an air tank and mask generally)
				breath = get_breath_from_internal(BREATH_VOLUME) // Super hacky -- TLE
				//breath = get_breath_from_internal(0.5) // Manually setting to old BREATH_VOLUME amount -- TLE

				//No breath from internal atmosphere so get breath from location
				if(!breath)
					if(istype(loc, /obj/))
						var/obj/location_as_object = loc
						breath = location_as_object.handle_internal_lifeform(src, BREATH_VOLUME)
					else if(istype(loc, /turf/))
						var/breath_moles = 0
						/*if(environment.return_pressure() > ONE_ATMOSPHERE)
							// Loads of air around (pressure effects will be handled elsewhere), so lets just take a enough to fill our lungs at normal atmos pressure (using n = Pv/RT)
							breath_moles = (ONE_ATMOSPHERE*BREATH_VOLUME/R_IDEAL_GAS_EQUATION*environment.temperature)
						else*/
							// Not enough air around, take a percentage of what's there to model this properly
						breath_moles = environment.total_moles()*BREATH_PERCENTAGE

						breath = loc.remove_air(breath_moles)

				else //Still give containing object the chance to interact
					if(istype(loc, /obj/))
						var/obj/location_as_object = loc
						location_as_object.handle_internal_lifeform(src, 0)

			handle_breath(breath)

			if(breath)
				loc.assume_air(breath)


		get_breath_from_internal(volume_needed)
			if(internal)
				if (!contents.Find(src.internal))
					internal = null
				if (!wear_mask || !(wear_mask.flags & MASKINTERNALS) )
					internal = null
				if(internal)
					if (src.internals)
						src.internals.icon_state = "internal1"
					return internal.remove_air_volume(volume_needed)
				else
					if (src.internals)
						src.internals.icon_state = "internal0"
			return null

		update_canmove()
			if(paralysis || stunned || weakened || buckled || changeling_fakedeath) canmove = 0
			else canmove = 1

		handle_breath(datum/gas_mixture/breath)
			if(src.nodamage)
				return

			if(!breath || (breath.total_moles() == 0))
				if(src.reagents.has_reagent("inaprovaline"))
					return
				oxyloss += 7

				oxygen_alert = max(oxygen_alert, 1)

				return 0

			var/safe_oxygen_min = 16 // Minimum safe partial pressure of O2, in kPa
			//var/safe_oxygen_max = 140 // Maximum safe partial pressure of O2, in kPa (Not used for now)
			var/safe_co2_max = 10 // Yes it's an arbitrary value who cares?
			var/safe_toxins_max = 0.5
			var/SA_para_min = 1
			var/SA_sleep_min = 5
			var/oxygen_used = 0
			var/breath_pressure = (breath.total_moles()*R_IDEAL_GAS_EQUATION*breath.temperature)/BREATH_VOLUME

			//Partial pressure of the O2 in our breath
			var/O2_pp = (breath.oxygen/breath.total_moles())*breath_pressure
			// Same, but for the toxins
			var/Toxins_pp = (breath.toxins/breath.total_moles())*breath_pressure
			// And CO2, lets say a PP of more than 10 will be bad (It's a little less really, but eh, being passed out all round aint no fun)
			var/CO2_pp = (breath.carbon_dioxide/breath.total_moles())*breath_pressure // Tweaking to fit the hacky bullshit I've done with atmo -- TLE
			//var/CO2_pp = (breath.carbon_dioxide/breath.total_moles())*0.5 // The default pressure value

			if(O2_pp < safe_oxygen_min) 			// Too little oxygen
				if(prob(20))
					spawn(0) emote("gasp")
				if(O2_pp > 0)
					var/ratio = safe_oxygen_min/O2_pp
					oxyloss += min(5*ratio, 7) // Don't fuck them up too fast (space only does 7 after all!)
					oxygen_used = breath.oxygen*ratio/6
				else
					oxyloss += 7
				oxygen_alert = max(oxygen_alert, 1)
			/*else if (O2_pp > safe_oxygen_max) 		// Too much oxygen (commented this out for now, I'll deal with pressure damage elsewhere I suppose)
				spawn(0) emote("cough")
				var/ratio = O2_pp/safe_oxygen_max
				oxyloss += 5*ratio
				oxygen_used = breath.oxygen*ratio/6
				oxygen_alert = max(oxygen_alert, 1)*/
			else 									// We're in safe limits
				oxyloss = max(oxyloss-5, 0)
				oxygen_used = breath.oxygen/6
				oxygen_alert = 0

			breath.oxygen -= oxygen_used
			breath.carbon_dioxide += oxygen_used

			if(CO2_pp > safe_co2_max)
				if(!co2overloadtime) // If it's the first breath with too much CO2 in it, lets start a counter, then have them pass out after 12s or so.
					co2overloadtime = world.time
				else if(world.time - co2overloadtime > 120)
					src.paralysis = max(src.paralysis, 3)
					oxyloss += 3 // Lets hurt em a little, let them know we mean business
					if(world.time - co2overloadtime > 300) // They've been in here 30s now, lets start to kill them for their own good!
						oxyloss += 8
				if(prob(20)) // Lets give them some chance to know somethings not right though I guess.
					spawn(0) emote("cough")

			else
				co2overloadtime = 0

			if(Toxins_pp > safe_toxins_max) // Too much toxins
				var/ratio = breath.toxins/safe_toxins_max
				toxloss += min(ratio, 10)	//Limit amount of damage toxin exposure can do per second
				toxins_alert = max(toxins_alert, 1)
			else
				toxins_alert = 0

			if(breath.trace_gases.len)	// If there's some other shit in the air lets deal with it here.
				for(var/datum/gas/sleeping_agent/SA in breath.trace_gases)
					var/SA_pp = (SA.moles/breath.total_moles())*breath_pressure
					if(SA_pp > SA_para_min) // Enough to make us paralysed for a bit
						src.paralysis = max(src.paralysis, 3) // 3 gives them one second to wake up and run away a bit!
						if(SA_pp > SA_sleep_min) // Enough to make us sleep as well
							src.sleeping = max(src.sleeping, 2)
					else if(SA_pp > 0.01)	// There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
						if(prob(20))
							spawn(0) emote(pick("giggle", "laugh"))


			if(breath.temperature > (T0C+66) && !(src.mutations & 2)) // Hot air hurts :(
				if(prob(20))
					src << "\red You feel a searing heat in your lungs!"
				fire_alert = max(fire_alert, 1)
			else
				fire_alert = 0


			//Temporary fixes to the alerts.

			return 1

		handle_environment(datum/gas_mixture/environment)
			if(!environment)
				return
			var/environment_heat_capacity = environment.heat_capacity()
			var/loc_temp = T0C
			if(istype(loc, /turf/space))
				environment_heat_capacity = loc:heat_capacity
				loc_temp = 2.7
			else if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
				loc_temp = loc:air_contents.temperature
			else
				loc_temp = environment.temperature

			var/thermal_protection = get_thermal_protection()
			if(stat != 2 && abs(src.bodytemperature - 310.15) < 50)
				src.bodytemperature += adjust_body_temperature(src.bodytemperature, 310.15, thermal_protection)
			if(loc_temp < 310.15) // a cold place -> add in cold protection
				src.bodytemperature += adjust_body_temperature(src.bodytemperature, loc_temp, 1/thermal_protection)
			else // a hot place -> add in heat protection
				thermal_protection += add_fire_protection(loc_temp)
				src.bodytemperature += adjust_body_temperature(src.bodytemperature, loc_temp, 1/thermal_protection)


			// lets give them a fair bit of leeway so they don't just start dying
			//as that may be realistic but it's no fun
			if((src.bodytemperature > (T0C + 50)) || (src.bodytemperature < (T0C + 10)) && (!istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))) // Last bit is just disgusting, i know
				if(environment.temperature > (T0C + 50) || (environment.temperature < (T0C + 10)))
					var/transfer_coefficient

					transfer_coefficient = 1
					if(head && (head.body_parts_covered & HEAD) && (environment.temperature < head.protective_temperature))
						transfer_coefficient *= head.heat_transfer_coefficient
					if(wear_mask && (wear_mask.body_parts_covered & HEAD) && (environment.temperature < wear_mask.protective_temperature))
						transfer_coefficient *= wear_mask.heat_transfer_coefficient
					if(wear_suit && (wear_suit.body_parts_covered & HEAD) && (environment.temperature < wear_suit.protective_temperature))
						transfer_coefficient *= wear_suit.heat_transfer_coefficient

					handle_temperature_damage(HEAD, environment.temperature, environment_heat_capacity*transfer_coefficient)

					transfer_coefficient = 1
					if(wear_suit && (wear_suit.body_parts_covered & UPPER_TORSO) && (environment.temperature < wear_suit.protective_temperature))
						transfer_coefficient *= wear_suit.heat_transfer_coefficient
					if(w_uniform && (w_uniform.body_parts_covered & UPPER_TORSO) && (environment.temperature < w_uniform.protective_temperature))
						transfer_coefficient *= w_uniform.heat_transfer_coefficient

					handle_temperature_damage(UPPER_TORSO, environment.temperature, environment_heat_capacity*transfer_coefficient)

					transfer_coefficient = 1
					if(wear_suit && (wear_suit.body_parts_covered & LOWER_TORSO) && (environment.temperature < wear_suit.protective_temperature))
						transfer_coefficient *= wear_suit.heat_transfer_coefficient
					if(w_uniform && (w_uniform.body_parts_covered & LOWER_TORSO) && (environment.temperature < w_uniform.protective_temperature))
						transfer_coefficient *= w_uniform.heat_transfer_coefficient

					handle_temperature_damage(LOWER_TORSO, environment.temperature, environment_heat_capacity*transfer_coefficient)

					transfer_coefficient = 1
					if(wear_suit && (wear_suit.body_parts_covered & LEGS) && (environment.temperature < wear_suit.protective_temperature))
						transfer_coefficient *= wear_suit.heat_transfer_coefficient
					if(w_uniform && (w_uniform.body_parts_covered & LEGS) && (environment.temperature < w_uniform.protective_temperature))
						transfer_coefficient *= w_uniform.heat_transfer_coefficient

					handle_temperature_damage(LEGS, environment.temperature, environment_heat_capacity*transfer_coefficient)

					transfer_coefficient = 1
					if(wear_suit && (wear_suit.body_parts_covered & ARMS) && (environment.temperature < wear_suit.protective_temperature))
						transfer_coefficient *= wear_suit.heat_transfer_coefficient
					if(w_uniform && (w_uniform.body_parts_covered & ARMS) && (environment.temperature < w_uniform.protective_temperature))
						transfer_coefficient *= w_uniform.heat_transfer_coefficient

					handle_temperature_damage(ARMS, environment.temperature, environment_heat_capacity*transfer_coefficient)

					transfer_coefficient = 1
					if(wear_suit && (wear_suit.body_parts_covered & HANDS) && (environment.temperature < wear_suit.protective_temperature))
						transfer_coefficient *= wear_suit.heat_transfer_coefficient
					if(gloves && (gloves.body_parts_covered & HANDS) && (environment.temperature < gloves.protective_temperature))
						transfer_coefficient *= gloves.heat_transfer_coefficient

					handle_temperature_damage(HANDS, environment.temperature, environment_heat_capacity*transfer_coefficient)

					transfer_coefficient = 1
					if(wear_suit && (wear_suit.body_parts_covered & FEET) && (environment.temperature < wear_suit.protective_temperature))
						transfer_coefficient *= wear_suit.heat_transfer_coefficient
					if(shoes && (shoes.body_parts_covered & FEET) && (environment.temperature < shoes.protective_temperature))
						transfer_coefficient *= shoes.heat_transfer_coefficient

					handle_temperature_damage(FEET, environment.temperature, environment_heat_capacity*transfer_coefficient)

			/*if(stat==2) //Why only change body temp when they're dead? That makes no sense!!!!!!
				bodytemperature += 0.8*(environment.temperature - bodytemperature)*environment_heat_capacity/(environment_heat_capacity + 270000)
			*/

			//Account for massive pressure differences
			return //TODO: DEFERRED

		adjust_body_temperature(current, loc_temp, boost)
			var/temperature = current
			var/difference = abs(current-loc_temp)	//get difference
			var/increments// = difference/10			//find how many increments apart they are
			if(difference > 50)
				increments = difference/5
			else
				increments = difference/10
			var/change = increments*boost	// Get the amount to change by (x per increment)
			var/temp_change
			if(current < loc_temp)
				temperature = min(loc_temp, temperature+change)
			else if(current > loc_temp)
				temperature = max(loc_temp, temperature-change)
			temp_change = (temperature - current)
			return temp_change

		get_thermal_protection()
			var/thermal_protection = 1.0
			//Handle normal clothing
			if(head && (head.body_parts_covered & HEAD))
				thermal_protection += 0.5
			if(wear_suit && (wear_suit.body_parts_covered & UPPER_TORSO))
				thermal_protection += 0.5
			if(w_uniform && (w_uniform.body_parts_covered & UPPER_TORSO))
				thermal_protection += 0.5
			if(wear_suit && (wear_suit.body_parts_covered & LEGS))
				thermal_protection += 0.2
			if(wear_suit && (wear_suit.body_parts_covered & ARMS))
				thermal_protection += 0.2
			if(wear_suit && (wear_suit.body_parts_covered & HANDS))
				thermal_protection += 0.2
			if(shoes && (shoes.body_parts_covered & FEET))
				thermal_protection += 0.2
			if(wear_suit && (wear_suit.flags & SUITSPACE))
				thermal_protection += 3
			if(head && (head.flags & HEADSPACE))
				thermal_protection += 1
			if(src.mutations & 2)
				thermal_protection += 5

			return thermal_protection


		handle_hunger()
			if (hunger_runonce != 1)
				hungerpts = rand(65, 99)
				hunger_runonce = 1

			var/hungerlevel = 1.0
			if(!hungertime) //Begins to starve them
				hungertime = world.time
			else if(world.time - hungertime > 170)
				src.hungerpts -= 1
				src.health -= 0.2
				src.updatehealth()
				hungertime = 0
				//src << "\red your hunger points went down!" //debug

//someone please fix this? the messages just keep repeating...;-;
			/*if (src.hungerpts >= 250)
					src << "\red Your stomach explodes."
					death()
			if (src.hungerpts >= 200)
					src << "\red You can feel your stomach tearing"
					src.health -= 40*/
			if (src.hungerpts >= 101)
				src << "\red You're full!"
				src.hungerpts = 100
			if (src.hungerpts == 60)
				src << "\red You're starting to feel hungry."
				src.hungerpts = 59
			if (src.hungerpts == 40)
				src << "\red Your stomach grumbles."
				src.hungerpts = 39
			if (src.hungerpts == 30)
				src << "\red Your stomach grumbles."
				src.hungerpts = 29
			if (src.hungerpts == 20)
				src << "\red You're starting to feel weak from hunger."
				src.hungerpts = 19
			if (src.hungerpts == 10)
				src << "\red You collapse from hunger."
				emote("collapse")
				src.hungerpts = 9
			if (src.hungerpts == 5)
				src << "\red You're so hungry, you can barely stand anymore."
				emote("collapse")
				src.hungerpts = 4
			if (src.hungerpts == 3)
				src.drowsyness = 100
				//sleep(600)
				src.hungerpts = 2
			if (src.hungerpts == 0)
				src << "\red You collapse and die from hunger."
				emote("gasp")
				death()
				src.hungerpts = -1

			return hungerlevel


		add_fire_protection(var/temp)
			var/fire_prot = 0
			if(head)
				if(head.protective_temperature > temp)
					fire_prot += (head.protective_temperature/10)
			if(wear_mask)
				if(wear_mask.protective_temperature > temp)
					fire_prot += (wear_mask.protective_temperature/10)
			if(glasses)
				if(glasses.protective_temperature > temp)
					fire_prot += (glasses.protective_temperature/10)
			if(ears)
				if(ears.protective_temperature > temp)
					fire_prot += (ears.protective_temperature/10)
			if(wear_suit)
				if(wear_suit.protective_temperature > temp)
					fire_prot += (wear_suit.protective_temperature/10)
			if(w_uniform)
				if(w_uniform.protective_temperature > temp)
					fire_prot += (w_uniform.protective_temperature/10)
			if(gloves)
				if(gloves.protective_temperature > temp)
					fire_prot += (gloves.protective_temperature/10)
			if(shoes)
				if(shoes.protective_temperature > temp)
					fire_prot += (shoes.protective_temperature/10)

			return fire_prot

		handle_temperature_damage(body_part, exposed_temperature, exposed_intensity)
			if(src.nodamage)
				return
			var/discomfort = min(abs(exposed_temperature - bodytemperature)*(exposed_intensity)/2000000, 1.0)

			switch(body_part)
				if(HEAD)
					TakeDamage("head", 0, 2.5*discomfort)
				if(UPPER_TORSO)
					TakeDamage("chest", 0, 2.5*discomfort)
				if(LOWER_TORSO)
					TakeDamage("groin", 0, 2.0*discomfort)
				if(LEGS)
					TakeDamage("l_leg", 0, 0.6*discomfort)
					TakeDamage("r_leg", 0, 0.6*discomfort)
				if(ARMS)
					TakeDamage("l_arm", 0, 0.4*discomfort)
					TakeDamage("r_arm", 0, 0.4*discomfort)
				if(FEET)
					TakeDamage("l_foot", 0, 0.25*discomfort)
					TakeDamage("r_foot", 0, 0.25*discomfort)
				if(HANDS)
					TakeDamage("l_hand", 0, 0.25*discomfort)
					TakeDamage("r_hand", 0, 0.25*discomfort)

		handle_chemicals_in_body()

			if(reagents) reagents.metabolize(src)

			if(src.nutrition > 400 && !(src.mutations & 32))
				if(prob(5 + round((src.nutrition - 200) / 2)))
					src << "\red You suddenly feel blubbery!"
					src.mutations |= 32
					update_body()
			if (src.nutrition < 100 && src.mutations & 32)
				if(prob(round((50 - src.nutrition) / 100)))
					src << "\blue You feel fit again!"
					src.mutations &= ~32
					update_body()
			if (src.nutrition > 0)
				src.nutrition--

			if (src.drowsyness)
				src.drowsyness--
				src.eye_blurry = max(2, src.eye_blurry)
				if (prob(5))
					src.sleeping = 1
					src.paralysis = 5

			confused = max(0, confused - 1)
			// decrement dizziness counter, clamped to 0
			if(resting)
				dizziness = max(0, dizziness - 5)
				jitteriness = max(0, jitteriness - 5)
			else
				dizziness = max(0, dizziness - 1)
				jitteriness = max(0, jitteriness - 1)

			src.updatehealth()

			return //TODO: DEFERRED

		handle_regular_status_updates()

			health = 100 - (oxyloss + toxloss + fireloss + bruteloss)

			if(oxyloss > 50) paralysis = max(paralysis, 3)

			if(src.sleeping)
				src.paralysis = max(src.paralysis, 3)
				if (prob(10) && health) spawn(0) emote("snore")
				src.sleeping--

			if(src.resting)
				src.weakened = max(src.weakened, 5)

			if(health < -100 || src.brain_op_stage == 4.0)
				death()
			else if(src.health < 0)
				if(src.health <= 20 && prob(1)) spawn(0) emote("gasp")

				//if(!src.rejuv) src.oxyloss++
				if(!src.reagents.has_reagent("inaprovaline")) src.oxyloss++

				if(src.stat != 2)	src.stat = 1
				src.paralysis = max(src.paralysis, 5)

			if (src.stat != 2) //Alive.

				if (src.paralysis || src.stunned || src.weakened || changeling_fakedeath) //Stunned etc.
					if (src.stunned > 0)
						src.stunned--
						src.stat = 0
					if (src.weakened > 0)
						src.weakened--
						src.lying = 1
						src.stat = 0
					if (src.paralysis > 0)
						src.paralysis--
						src.blinded = 1
						src.lying = 1
						src.stat = 1
					var/h = src.hand
					src.hand = 0
					drop_item()
					src.hand = 1
					drop_item()
					src.hand = h

				else	//Not stunned.
					src.lying = 0
					src.stat = 0

			else //Dead.
				src.lying = 1
				src.blinded = 1
				src.stat = 2

			if (src.stuttering) src.stuttering--

			if (src.eye_blind)
				src.eye_blind--
				src.blinded = 1

			if (src.ear_deaf > 0) src.ear_deaf--
			if (src.ear_damage < 25)
				src.ear_damage -= 0.05
				src.ear_damage = max(src.ear_damage, 0)

			src.density = !( src.lying )

			if ((src.sdisabilities & 1 || istype(src.glasses, /obj/item/clothing/glasses/blindfold)))
				src.blinded = 1
			if ((src.sdisabilities & 4 || istype(src.ears, /obj/item/clothing/ears/earmuffs)))
				src.ear_deaf = 1

			if (src.eye_blurry > 0)
				src.eye_blurry--
				src.eye_blurry = max(0, src.eye_blurry)

			if (src.druggy > 0)
				src.druggy--
				src.druggy = max(0, src.druggy)

			return 1

		handle_regular_hud_updates()

			if (src.stat == 2 || src.mutations & 4)
				src.sight |= SEE_TURFS
				src.sight |= SEE_MOBS
				src.sight |= SEE_OBJS
				src.see_in_dark = 8
				if(!src.druggy)
					src.see_invisible = 2
			else if (istype(src.glasses, /obj/item/clothing/glasses/meson))
				src.sight |= SEE_TURFS
				src.see_in_dark = 3
				if(!src.druggy)
					src.see_invisible = 0
			else if (istype(src.glasses, /obj/item/clothing/glasses/thermal))
				src.sight |= SEE_MOBS
				src.see_in_dark = 4
				if(!src.druggy)
					src.see_invisible = 2
			else if (src.stat != 2)
				src.sight &= ~SEE_TURFS
				src.sight &= ~SEE_MOBS
				src.sight &= ~SEE_OBJS
				if (src.mutantrace == "lizard")
					src.see_in_dark = 3
					src.see_invisible = 1
				else if (src.druggy) // If drugged~
					src.see_in_dark = 2
					//see_invisible regulated by drugs themselves.
				else
					src.see_in_dark = 2
					var/seer = 0
					for(var/obj/rune/R in world)
						if(src.loc==R.loc && R.word1=="nahlizet" && R.word2=="certum" && R.word3=="jatkaa")
							seer = 1
					if(!seer)
						src.see_invisible = 0

			if (src.sleep) src.sleep.icon_state = text("sleep[]", src.sleeping)
			if (src.rest) src.rest.icon_state = text("rest[]", src.resting)

			if (src.healths)
				if (src.stat != 2)
					switch(health)
						if(100 to INFINITY)
							src.healths.icon_state = "health0"
						if(80 to 100)
							src.healths.icon_state = "health1"
						if(60 to 80)
							src.healths.icon_state = "health2"
						if(40 to 60)
							src.healths.icon_state = "health3"
						if(20 to 40)
							src.healths.icon_state = "health4"
						if(0 to 20)
							src.healths.icon_state = "health5"
						else
							src.healths.icon_state = "health6"
				else
					src.healths.icon_state = "health7"

			if(src.pullin)	src.pullin.icon_state = "pull[src.pulling ? 1 : 0]"


			if (src.toxin)	src.toxin.icon_state = "tox[src.toxins_alert ? 1 : 0]"
			if (src.oxygen) src.oxygen.icon_state = "oxy[src.oxygen_alert ? 1 : 0]"
			if (src.fire) src.fire.icon_state = "fire[src.fire_alert ? 1 : 0]"
			//NOTE: the alerts dont reset when youre out of danger. dont blame me,
			//blame the person who coded them. Temporary fix added.

			switch(src.bodytemperature) //310.055 optimal body temp

				if(370 to INFINITY)
					src.bodytemp.icon_state = "temp4"
				if(350 to 370)
					src.bodytemp.icon_state = "temp3"
				if(335 to 350)
					src.bodytemp.icon_state = "temp2"
				if(320 to 335)
					src.bodytemp.icon_state = "temp1"
				if(300 to 320)
					src.bodytemp.icon_state = "temp0"
				if(295 to 300)
					src.bodytemp.icon_state = "temp-1"
				if(280 to 295)
					src.bodytemp.icon_state = "temp-2"
				if(260 to 280)
					src.bodytemp.icon_state = "temp-3"
				else
					src.bodytemp.icon_state = "temp-4"

			src.client.screen -= src.hud_used.blurry
			src.client.screen -= src.hud_used.druggy
			src.client.screen -= src.hud_used.vimpaired

			if ((src.blind && src.stat != 2))
				if ((src.blinded))
					src.blind.layer = 18
				else
					src.blind.layer = 0

					if (src.disabilities & 1 && !istype(src.glasses, /obj/item/clothing/glasses/regular) )
						src.client.screen += src.hud_used.vimpaired

					if (src.eye_blurry)
						src.client.screen += src.hud_used.blurry

					if (src.druggy)
						src.client.screen += src.hud_used.druggy

			if (src.stat != 2)
				if (src.machine)
					if (!( src.machine.check_eye(src) ))
						src.reset_view(null)
				else
					if(!client.adminobs)
						reset_view(null)

			return 1

		handle_random_events()
			if (prob(1) && prob(2))
				spawn(0)
					emote("sneeze")
					return

		handle_virus_updates()
			if(src.bodytemperature > 406)
				src.resistances += src.virus
				src.virus = null

			if(!src.virus)
				if(prob(40))
					for(var/mob/living/carbon/M in oviewers(4, src))
						if(M.virus && M.virus.spread == "Airborne")
							if(M.virus.affected_species.Find("Human"))
								if(src.resistances.Find(M.virus.type))
									continue
								var/datum/disease/D = new M.virus.type //Making sure strain_data is preserved
								D.strain_data = M.virus.strain_data
								src.contract_disease(D)

					for(var/obj/decal/cleanable/blood/B in view(4, src))
						if(B.virus && B.virus.spread == "Airborne")
							if(B.virus.affected_species.Find("Human"))
								if(src.resistances.Find(B.virus.type))
									continue
								var/datum/disease/D = new B.virus.type
								D.strain_data = B.virus.strain_data
								src.contract_disease(D)

					for(var/obj/decal/cleanable/xenoblood/X in view(4, src))
						if(X.virus && X.virus.spread == "Airborne")
							if(X.virus.affected_species.Find("Human"))
								if(src.resistances.Find(X.virus.type))
									continue
								var/datum/disease/D = new X.virus.type
								D.strain_data = X.virus.strain_data
								src.contract_disease(D)
			else
				src.virus.stage_act()

		check_if_buckled()
			if (src.buckled)
				src.lying = istype(src.buckled, /obj/stool/bed) || istype(src.buckled, /obj/machinery/conveyor)
				if(src.lying)
					src.drop_item()
				src.density = 1
			else
				src.density = !src.lying

		handle_stomach()
			spawn(0)
				for(var/mob/M in stomach_contents)
					if(M.loc != src)
						stomach_contents.Remove(M)
						continue
					if(istype(M, /mob/living/carbon) && src.stat != 2)
						if(M.stat == 2)
							M.death(1)
							stomach_contents.Remove(M)
							if(M.client)
								var/mob/dead/observer/newmob = new(M)
								M:client:mob = newmob
								M.mind.transfer_to(newmob)
								newmob.reset_view(null)
							del(M)
							continue
						if(air_master.current_cycle%3==1)
							if(!M.nodamage)
								M.bruteloss += 5
							src.nutrition += 10

/*
snippets

	if (src.mach)
		if (src.machine)
			src.mach.icon_state = "mach1"
		else
			src.mach.icon_state = null

	if (!src.m_flag)
		src.moved_recently = 0
	src.m_flag = null



		if ((istype(src.loc, /turf/space) && !( locate(/obj/movable, src.loc) )))
			var/layers = 20
			// ******* Check
			if (((istype(src.head, /obj/item/clothing/head) && src.head.flags & 4) || (istype(src.wear_mask, /obj/item/clothing/mask) && (!( src.wear_mask.flags & 4 ) && src.wear_mask.flags & 8))))
				layers -= 5
			if (istype(src.w_uniform, /obj/item/clothing/under))
				layers -= 5
			if ((istype(src.wear_suit, /obj/item/clothing/suit) && src.wear_suit.flags & 8))
				layers -= 10
			if (layers > oxcheck)
				oxcheck = layers


				if(src.bodytemperature < 282.591 && (!src.firemut))
					if(src.bodytemperature < 250)
						src.fireloss += 4
						src.updatehealth()
						if(src.paralysis <= 2)	src.paralysis += 2
					else if(prob(1) && !src.paralysis)
						if(src.paralysis <= 5)	src.paralysis += 5
						emote("collapse")
						src << "\red You collapse from the cold!"
				if(src.bodytemperature > 327.444  && (!src.firemut))
					if(src.bodytemperature > 345.444)
						if(!src.eye_blurry)	src << "\red The heat blurs your vision!"
						src.eye_blurry = max(4, src.eye_blurry)
						if(prob(3))	src.fireloss += rand(1,2)
					else if(prob(3) && !src.paralysis)
						src.paralysis += 2
						emote("collapse")
						src << "\red You collapse from heat exaustion!"
				plcheck = src.t_plasma
				oxcheck = src.t_oxygen
				G.turf_add(T, G.total_moles())
*/