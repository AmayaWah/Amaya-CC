//Normal Bounty - But our target has possibly ascended or gotten improved stats, allowing ghosts to play as the mob.
//Otherwise, if no one takes the mob, spawns a strong NPC in place.

GLOBAL_LIST_INIT(ascended_bounty_mobs, list(
	/mob/living/carbon/human/species/human/northern/outlaw_duelist,
	/mob/living/carbon/human/species/human/northern/outlaw_ranger,
	/mob/living/carbon/human/species/human/northern/outlaw_tank
))

/datum/quest/kill/ascended_bounty
	quest_type = QUEST_ASCENDED_BOUNTY
	quest_difficulty = QUEST_DIFFICULTY_PLAYER_VS_PLAYER
	tp_budget = QUEST_TP_BUDGET_BOUNTY_GOONS
	threat_bands_cleared = QUEST_BANDS_BOUNTY
	required_fellowship_size = 0
	/// Generated boss name for title/objective. Set at preview.
	var/boss_name
	/// If TRUE, the boss is a large goblin and goons are drawn from quest_bounty_goblin_goons
	/// instead of the region faction. Rolled at preview time.
	var/goblin_warlord_variant = FALSE

/datum/quest/kill/ascended_bounty/preview(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	pending_landmark_ref = WEAKREF(landmark)
	target_spawn_area = get_area_name(get_turf(landmark))
	region = landmark.region
	var/datum/threat_region/TR = SSregionthreat.get_region(region)
	if(!TR)
		return FALSE
	faction = pick_region_faction_for(TR)
	if(!faction)
		return FALSE
	faction_id = faction.id
	target_mob_type = pick(GLOB.ascended_bounty_mobs) //Pick between 3 outlaw variants.
	progress_required = 1
	finalize_preview_title()
	return TRUE

/datum/quest/kill/ascended_bounty/get_named_target()
	return boss_name

/datum/quest/kill/ascended_bounty/get_title()
	if(title)
		return title
	return "Bring down a notorious outlaw"

/datum/quest/kill/ascended_bounty/get_objective_text()
	return "Slay the target, but be warned! They are rumored to be quite the formidable opponent!"

/datum/quest/kill/ascended_bounty/get_additional_reward(turf/origin_turf, turf/target_turf)
	if(!target_mob_type)
		return 0
	var/boss_threat = initial(target_mob_type.threat_point) || 0
	return (boss_threat * QUEST_ASCENDED_BOUNTY_THREAT_MULT)

/// Override — bounty progress is fixed at 1 (the boss), regardless of goon count.
/datum/quest/kill/ascended_bounty/estimate_mob_count()
	return 1

/datum/quest/kill/ascended_bounty/materialize(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	if(!faction)
		return FALSE
	spawn_boss(landmark)
	//spawn_goons(landmark) //Unused.
	progress_required = 1
	// Rename the boss mob after a delay so subtype after_creation() doesn't clobber it.
	// Some subtypes (e.g. large_goblin) call after_creation on a 1s timer and set their own name.
	addtimer(CALLBACK(src, PROC_REF(apply_boss_name)), 2 SECONDS)
	return TRUE

/datum/quest/kill/ascended_bounty/proc/spawn_boss(obj/effect/landmark/quest_spawner/landmark)
	var/turf/spawn_turf = landmark.get_safe_spawn_turf()
	if(!spawn_turf)
		return

	//We handle the mind transfer within the spawn_effect itself as opposed to the quest,
	//  that way we can trigger the ghost poll when the contract holders are actually within range to release the mob appropriately.
	var/obj/effect/quest_spawn/pvp/spawn_effect = new /obj/effect/quest_spawn/pvp(spawn_turf)
	var/mob/living/boss = new target_mob_type(spawn_turf)

	boss.faction |= "quest"
	if(faction?.faction_tag)
		boss.faction |= faction.faction_tag
	boss.mark_contract_spawned()
	boss.AddComponent(/datum/component/quest_object/kill, src)
	ADD_TRAIT(boss, TRAIT_FRESHSPAWN, "[type]")
	addtimer(TRAIT_CALLBACK_REMOVE(boss, TRAIT_FRESHSPAWN, "[type]"), 60 SECONDS)
	spawn_effect.contained_atom = boss
	spawn_effect.AddComponent(/datum/component/quest_object/mob_spawner, src)
	register_spawner(spawn_effect)
	add_tracked_atom(boss)
	landmark.add_quest_faction_to_nearby_mobs(spawn_turf)

/datum/quest/kill/ascended_bounty/proc/apply_boss_name()
	for(var/datum/weakref/ref in tracked_atoms)
		var/mob/living/M = ref.resolve()
		if(QDELETED(M))
			continue
		if(!istype(M, target_mob_type))
			continue
		M.real_name = boss_name
		M.name = boss_name

/// Spawn goons alongside the bounty boss.
/// Otherwise spends TP budget drawing from the region faction.
/// Currently unused.
/* /datum/quest/kill/ascended_bounty/proc/spawn_goons(obj/effect/landmark/quest_spawner/landmark)
	var/list/to_spawn = compose_warband()
	total_spawned_tp = 0
	for(var/goon_type in to_spawn)
		var/turf/spawn_turf = landmark.get_safe_spawn_turf()
		if(!spawn_turf)
			continue
		var/obj/effect/quest_spawn/spawn_effect = new /obj/effect/quest_spawn(spawn_turf)
		var/mob/living/goon = new goon_type(spawn_effect)
		goon.faction |= "quest"
		if(faction?.faction_tag)
			goon.faction |= faction.faction_tag
		goon.mark_contract_spawned()
		ADD_TRAIT(goon, TRAIT_FRESHSPAWN, "[type]")
		addtimer(TRAIT_CALLBACK_REMOVE(goon, TRAIT_FRESHSPAWN, "[type]"), 60 SECONDS)
		spawn_effect.contained_atom = goon
		spawn_effect.AddComponent(/datum/component/quest_object/mob_spawner, src)
		register_spawner(spawn_effect)
		total_spawned_tp += initial(goon.threat_point) || 0 */

/// Spawns 5-9 mixed goblin goons for the goblin warlord variant.
/// Currently unused.
/* /datum/quest/kill/ascended_bounty/proc/spawn_goblin_horde(obj/effect/landmark/quest_spawner/landmark)
	total_spawned_tp = 0
	for(var/i in 1 to rand(5, 9))
		var/turf/spawn_turf = landmark.get_safe_spawn_turf()
		if(!spawn_turf)
			continue
		var/obj/effect/quest_spawn/spawn_effect = new /obj/effect/quest_spawn(spawn_turf)
		var/goon_path = pick(GLOB.quest_bounty_goblin_goons)
		var/mob/living/goon = new goon_path(spawn_effect)
		goon.faction |= "quest"
		goon.mark_contract_spawned()
		ADD_TRAIT(goon, TRAIT_FRESHSPAWN, "[type]")
		addtimer(TRAIT_CALLBACK_REMOVE(goon, TRAIT_FRESHSPAWN, "[type]"), 60 SECONDS)
		spawn_effect.contained_atom = goon
		spawn_effect.AddComponent(/datum/component/quest_object/mob_spawner, src)
		register_spawner(spawn_effect)
		total_spawned_tp += initial(goon.threat_point) || 0 */
