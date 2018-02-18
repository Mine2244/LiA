item_lia_spherical_staff = class({})
LinkLuaModifier("modifier_spherical_staff", "items/modifier_spherical_staff.lua", LUA_MODIFIER_MOTION_NONE)

function item_lia_spherical_staff:GetIntrinsicModifierName()
	return "modifier_spherical_staff"
end

function item_lia_spherical_staff:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function item_lia_spherical_staff:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local stunDuration = self:GetSpecialValueFor("stun_duration")
	local golemLifeTime = self:GetSpecialValueFor("infernal_duration")

	local pFX = ParticleManager:CreateParticle("particles/custom/items/spherical_staff_infernal.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(pFX, 0, point + Vector(500,500,2000))
	ParticleManager:SetParticleControl(pFX, 1, point)
	ParticleManager:SetParticleControl(pFX, 2, Vector(2,0,0))
	ParticleManager:ReleaseParticleIndex(pFX)

	EmitSoundOnLocationWithCaster(point, "DOTA_Item.MeteorHammer.Cast", caster)

	Timers:CreateTimer(2, function() 
		local targets = FindUnitsInRadius(
			caster:GetTeamNumber(),
			point,
			nil,
			radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_NOT_DOMINATED,
			FIND_ANY_ORDER,
			false)	

		local damageTable = { attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self}

		for _,unit in pairs(targets) do
			unit:AddNewModifier(caster,self,"modifier_stunned",{ duration = stunDuration })
			damageTable.victim = unit
			ApplyDamage(damageTable)
		end

		local golem = CreateUnitByName("spherical_staff_fire_golem", point, true, caster, caster, caster:GetTeamNumber())
		golem:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
		golem:AddNewModifier(caster,self,"modifier_kill",{duration = golemLifeTime})

		EmitSoundOnLocationWithCaster(point,"DOTA_Item.MeteorHammer.Impact",caster)

	end)
end