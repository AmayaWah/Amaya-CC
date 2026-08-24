/mob/living/carbon/human/species/hobgoblin/boss
	hobgob_outfit = /datum/outfit/job/roguetown/npc/hobgoblin/boss

/datum/outfit/job/roguetown/npc/hobgoblin/boss/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 11
	H.STAPER = 10
	H.STAINT = 8
	H.STACON = 14 //We are strong and sturdy, naturally tanky even due to our more primitive armor/gear.
	H.STAWIL = 14
	H.STASPD = 9
	H.STALUC = 10

	//We are an expert jack of all trades for most weapons.
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)

	//Some pretty nice traits.
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)


	var/loadout = rand(1,10)
	switch(loadout)
		if(1) //spear + leathers
			r_hand = /obj/item/rogueweapon/spear
			head = /obj/item/clothing/head/roguetown/helmet/hobgoblin
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hobgoblin
		if(2) //handaxe + leathers
			r_hand = /obj/item/rogueweapon/stoneaxe/handaxe
			head = /obj/item/clothing/head/roguetown/helmet/leather/hobgoblin
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hobgoblin
		if(3) //mace + leathers
			r_hand = /obj/item/rogueweapon/mace
			head = /obj/item/clothing/head/roguetown/helmet/leather/hobgoblin
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hobgoblin
		if(4) //iron messer + leathers
			r_hand = /obj/item/rogueweapon/sword/short/messer/iron
			head = /obj/item/clothing/head/roguetown/helmet/leather/hobgoblin
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hobgoblin
		if(5) //sword & shield
			r_hand = /obj/item/rogueweapon/sword/short/iron
			l_hand = /obj/item/rogueweapon/shield/heater
			if(prob(90))
				head = /obj/item/clothing/head/roguetown/helmet/hobgoblin
			else
				head = /obj/item/clothing/head/roguetown/helmet/leather/hobgoblin
			if(prob(90))
				armor =	/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/hobgoblin
			else
				armor = /obj/item/clothing/suit/roguetown/armor/leather/hobgoblin
		if(6) //warhammer
			r_hand = /obj/item/rogueweapon/mace/warhammer
			head = /obj/item/clothing/head/roguetown/helmet/leather/hobgoblin
			armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/hobgoblin
		if(7) //dual iron daggers
			r_hand = /obj/item/rogueweapon/huntingknife/idagger
			l_hand = /obj/item/rogueweapon/huntingknife/idagger
			head = /obj/item/clothing/head/roguetown/helmet/leather/hobgoblin
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hobgoblin
		if(8) //brass knuckles + plate
			gloves = /obj/item/clothing/gloves/roguetown/knuckles/bronze
			head = /obj/item/clothing/head/roguetown/helmet/hobgoblin
			armor =	/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/hobgoblin
		if(9) //spear & shield
			r_hand = /obj/item/rogueweapon/spear
			l_hand = /obj/item/rogueweapon/shield/heater
			if(prob(66))
				head = /obj/item/clothing/head/roguetown/helmet/hobgoblin
			else
				head = /obj/item/clothing/head/roguetown/helmet/leather/hobgoblin
			armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/hobgoblin
		if(10) //greatsword + full plate (rare)
			r_hand = /obj/item/rogueweapon/greatsword/iron
			head = /obj/item/clothing/head/roguetown/helmet/hobgoblin
			armor =	/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/hobgoblin

		//So they can store items on their hips and hold a single strong health vial.
		belt = /obj/item/storage/belt/rogue/leather/cloth
		beltr = /obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew
