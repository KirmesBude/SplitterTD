
function ValidPosition_AlliedGround(caster, vPos)
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

function OnConstructionCompleted_InitRefund(unit)
	unit.refund = unit.GoldCost
end

function Refund(event)
	caster = event.caster
	hero = caster:GetPlayerOwner():GetAssignedHero()
	target = event.target
	toRefund = target.refund

	if target.state == "complete" and not target.upgrade_modifier and toRefund then
		DebugPrint("[SPLITTERTD] Sell Building")

		--Fire Effect
		particle = ParticleManager:CreateParticleForPlayer("particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf", PATTACH_ABSORIGIN  , target, caster:GetPlayerOwner())
		ParticleManager:SetParticleControl( particle, 0, target:GetAbsOrigin() )
		ParticleManager:SetParticleControl( particle, 1, target:GetAbsOrigin() )

		--refund
		hero:ModifyGold(toRefund, false, 0)
		PopupGoldGain(target, toRefund)
		BuildingHelper:RemoveBuilding(target, true)
	else
		DebugPrint("[SPLITTERTD] Error - Building still in construction/upgrade")
		SendErrorMessage(caster:GetPlayerOwnerID(), "#error_bulding_not_complete")
	end
end