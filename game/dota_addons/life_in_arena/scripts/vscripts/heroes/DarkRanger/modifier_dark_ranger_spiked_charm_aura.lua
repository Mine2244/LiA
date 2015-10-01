modifier_dark_ranger_spiked_charm_aura = class({})

function modifier_dark_ranger_spiked_charm_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end


function modifier_dark_ranger_spiked_charm_aura:OnAttackLanded(params)
	if IsServer() then
		if params.target == self:GetParent() and (not self:GetParent():IsIllusion()) and not params.ranged_attack then
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			local target = params.target
			local return_damage = self:GetAbility():GetSpecialValueFor("damage_return")*0.01*params.damage
			ApplyDamage(
			{
				victim = params.attacker, 
				attacker = target, 
				damage = return_damage, 
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
				ability = params.ability
			})
		end
	end
end