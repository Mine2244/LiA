﻿require('survival/AIcreeps')

function Spawn(entityKeyValues)
	--print("Spawn")
    thisEntity:SetHullRadius(32) 
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	ABILITY_16_wave_mana_burn = thisEntity:FindAbilityByName("16_wave_mana_burn")
	ABILITY_16_wave_slow = thisEntity:FindAbilityByName("16_wave_slow")
	thisEntity:SetContextThink( "AIThink", AIThink , 0.1)
end

function AIThink()
	if not thisEntity:IsAlive() or thisEntity:IsIllusion() then
		return nil 
	end

	if GameRules:IsGamePaused() then
		return 1
	end

	AICreepsAttackOneUnit({unit = thisEntity})
	--print(Survival.AICreepCasts)

	if thisEntity:IsStunned() then 
		return 2 
	end

	if ABILITY_16_wave_slow:IsFullyCastable() then --в первую очередь босс кастует замедление
		local targets = FindUnitsInRadius(thisEntity:GetTeam(), 
						  thisEntity:GetOrigin(), 
						  nil, 
						  700, 
						  DOTA_UNIT_TARGET_TEAM_ENEMY, 
						  DOTA_UNIT_TARGET_HERO, 
						  DOTA_UNIT_TARGET_FLAG_NONE, 
						  FIND_ANY_ORDER, 
						  false)

		--не накладываем заклинание на тех, кто уже под его действием
		for k,target in pairs(targets) do 
			if target:HasModifier("modifier_16_wave_slow") then 
				table.remove(targets,k)
			end
		end
		if #targets ~= 0 then
			thisEntity:CastAbilityOnTarget(targets[RandomInt(1,#targets)], ABILITY_16_wave_slow, -1)
			Survival.AICreepCasts = Survival.AICreepCasts + 1
			return 2
		end
	end

	if Survival.AICreepCasts >= Survival.AIMaxCreepCasts then --мана берн не кастуем, если превышен лимит кастов
		return 2
	end

	if ABILITY_16_wave_mana_burn:IsFullyCastable() then
		local targets = FindUnitsInRadius(thisEntity:GetTeam(), 
						  thisEntity:GetOrigin(), 
						  nil, 
						  500, 
						  DOTA_UNIT_TARGET_TEAM_ENEMY, 
						  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
						  DOTA_UNIT_TARGET_FLAG_MANA_ONLY, 
						  FIND_ANY_ORDER, 
						  false)
		if #targets ~= 0 then
			thisEntity:CastAbilityOnTarget(targets[RandomInt(1,#targets)], ABILITY_16_wave_mana_burn, -1)
			Survival.AICreepCasts = Survival.AICreepCasts + 1
		end
	end	
	
	return 2
end