function StartUpgrade_DisableAttackCapability(caster)
	caster.UNIT_CAP_ATTACK = caster:GetAttackCapability()

	caster:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)

	caster:Stop()
end

function CancelUpgrade_ReEnableAttackCapability(caster)
	caster:SetAttackCapability(caster.UNIT_CAP_ATTACK)
end

function UpgradeBuilding_UpdateRefund(event, building)
	local caster = event.caster
	local refund = caster.refund

	local ability = event.ability
	local level = ability:GetLevel()
	local refund_add = ability:GetGoldCost(level)

	building.refund = refund + refund_add
end