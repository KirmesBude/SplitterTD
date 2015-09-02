function StartUpgrade_DisableAttackCapability(caster)
	caster.UNIT_CAP_ATTACK = caster:GetAttackCapability()

	caster:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)

	caster:Stop()
end

function CancelUpgrade_ReEnableAttackCapability(caster)
	caster:SetAttackCapability(caster.UNIT_CAP_ATTACK)
end