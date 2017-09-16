wave_6_invisibility = class({})

LinkLuaModifier("modifier_wave_6_invisibility", "abilities/wave_6_invisibility.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wave_6_invisibility_buff", "abilities/wave_6_invisibility.lua", LUA_MODIFIER_MOTION_NONE)

function wave_6_invisibility:GetIntrinsicModifierName()
	return "modifier_wave_6_invisibility"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_wave_6_invisibility = class({})

--------------------------------------------------------------------------------

function modifier_wave_6_invisibility:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_wave_6_invisibility:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_wave_6_invisibility:OnCreated( kv )
	if IsServer() then
		self.delay = self:GetAbility():GetSpecialValueFor( "delay" )
		self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_wave_6_invisibility_buff",nil)
	end
end

--------------------------------------------------------------------------------

function modifier_wave_6_invisibility:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_wave_6_invisibility:OnAttack(params)
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_wave_6_invisibility_buff")	

		if not self:GetCaster().invisTimer then 
			self:GetCaster().invisTimer = DoUniqueString(nil)
		end
		Timers:CreateTimer(self:GetCaster().invisTimer,{ endTime = self.delay, callback = function()
			self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_wave_6_invisibility_buff",nil)
	    	return nil
	    end}) 
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_wave_6_invisibility_buff = class({})

--------------------------------------------------------------------------------

function modifier_wave_6_invisibility_buff:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_wave_6_invisibility_buff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_wave_6_invisibility_buff:OnCreated()
	if IsServer() then
		if self:GetParent():PassivesDisabled() then
			return
		end
		self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_invisible",nil)
	end
end

--------------------------------------------------------------------------------

function modifier_wave_6_invisibility_buff:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_invisible")
	end
end

--------------------------------------------------------------------------------

function modifier_wave_6_invisibility_buff:CheckState()
	if not self:GetParent():PassivesDisabled() then 
		return { [MODIFIER_STATE_INVISIBLE] = true} 
	end

	return state
end