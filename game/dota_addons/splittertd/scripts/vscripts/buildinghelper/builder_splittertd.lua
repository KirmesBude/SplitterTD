if not Builder_SplitterTD then
	Builder_SplitterTD = class({})
end

function Builder_SplitterTD:ValidPosition_Allied_Ground(caster, vPos)
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	local playerID = hero:GetPlayerID()
	local team = PlayerResource:GetTeam(playerID)

	if 	team==DOTA_TEAM_GOODGUYS and vPos.y>0
		or	team==DOTA_TEAM_BADGUYS and vPos.y<0   then

		SendErrorMessage(caster:GetPlayerOwnerID(), "#error_must_build_on_allied_ground")
		return false
	end

	return true
end

function Builder_SplitterTD:OnConstructionStarted_DisableAttackCapability(unit)
	unit.UNIT_CAP_ATTACK = unit:GetAttackCapability()

	unit:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
end

function Builder_SplitterTD:OnConstructionCompleted_ReEnableAttackCapability(unit)
	
	unit:SetAttackCapability(unit.UNIT_CAP_ATTACK)
end