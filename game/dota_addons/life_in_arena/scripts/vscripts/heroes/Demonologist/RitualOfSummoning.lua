function GetPositionOnCircle(vCenter,vForward,flRadius,nPosition,nPositionCount)
	 local angle = nPosition / nPositionCount * 360
	 local QAngle = VectorToAngles(vForward)
	 QAngle.y = QAngle.y + angle
	 return RotatePosition(vCenter, QAngle, vCenter+vForward*flRadius)
end

function OnSpellStart(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local default_creeps = ability:GetSpecialValueFor("unit_count")
	local additional_creeps = caster:GetIntellect() / ability:GetSpecialValueFor("intelligence_for_unit")
	caster.demonologistUltimateCreepCount = math.floor(default_creeps + additional_creeps)
end

function SpawnUnits(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local boss_count = ability:GetSpecialValueFor("boss_count")

	local creep_name
	local boss_name

	if ((Survival.nRoundNum + 1) % 5 == 0) and (Survival.nRoundNum ~= 19) then
		creep_name = tostring(Survival.nRoundNum + 2).."_wave_creep"
		boss_name = tostring(Survival.nRoundNum + 2).."_wave_boss"
	elseif Survival.nRoundNum == 19 or Survival.nRoundNum == 20 then
		creep_name = "19_wave_creep"
		boss_name = "19_wave_boss"
	else
		creep_name = tostring(Survival.nRoundNum + 1).."_wave_creep"
		boss_name = tostring(Survival.nRoundNum + 1).."_wave_boss"
	end

	
	local radius = ability:GetSpecialValueFor("spawn_radius")
	local point = target:GetAbsOrigin()
    local points = caster.demonologistUltimateCreepCount

    if boss_count > 0 then
	    for i=1,boss_count do
	        local demonologistBoss = CreateUnitByName(boss_name, point, true, caster, caster, caster:GetTeam())
	        demonologistBoss.demonologistRitualCreep = true
			demonologistBoss:SetControllableByPlayer(caster:GetPlayerID(), true)
			ResolveNPCPositions(demonologistBoss:GetAbsOrigin(),100)
	    end
	end

    for i=1,points do
        local position = GetPositionOnCircle(point,Vector(1,0,0),radius,i,points)
        local demonologistCreep = CreateUnitByName(creep_name, position, true, caster, caster, caster:GetTeam())
        demonologistCreep.demonologistRitualCreep = true
		demonologistCreep:SetControllableByPlayer(caster:GetPlayerID(), true)
		ResolveNPCPositions(demonologistCreep:GetAbsOrigin(),100)
    end

	
end