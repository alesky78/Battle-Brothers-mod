this.summon_lost_soul <- this.inherit("scripts/skills/skill", {
    m = {
        Cooldown = 0,
        CooldownMax = 3,
    },
    function create() {
        this.m.ID = "actives.summon_lost_soul";
        this.m.Name = "Summon lost soul";
        this.m.Description = "The Demon calls a soul from the hell  hat will fight at his side.";
        this.m.Icon = "skills/summon_lost_soul.png";
        this.m.IconDisabled = "skills/summon_lost_soul_sw.png";
        //this.m.Overlay = "possess56";
        this.m.SoundOnUse = [
            "sounds/enemies/miasma_spell_01.wav",
			"sounds/enemies/miasma_spell_02.wav",
			"sounds/enemies/miasma_spell_03.wav"
        ];
		this.m.IsSerialized = true;	//skill to save				
		
        this.m.SoundVolume = 1.25;
        this.m.Type = this.Const.SkillType.Active;
        this.m.Order = this.Const.SkillOrder.NonTargeted + 5;
        this.m.IsActive = true;
        this.m.IsTargeted = true;
        this.m.IsStacking = false;
        this.m.IsAttack = false;
        this.m.IsTargetingActor = false;
        this.m.ActionPointCost = 5;
        this.m.FatigueCost = 30;
        this.m.MinRange = 1;
        this.m.MaxRange = 6;
    }

    function getTooltip() 
	{
        local ret = [{
                id = 1,
                type = "title",
                text = this.getName()
            },
            {
                id = 2,
                type = "description",
                text = this.getDescription()
            },
            {
                id = 3,
                type = "text",
                text = this.getCostString()
            },
        ];

        if (this.m.Cooldown != 0) {
            local cooldownTooltip = this.getCooldownTooltip();
            ret.push(cooldownTooltip);
        }

        return ret;
    }

    function getCooldownTooltip() {
        local cooldownLeft = this.m.Cooldown;
        local cooldown = {
            id = 10,
            type = "text",
            icon = "ui/tooltips/warning.png",
            text = "Summon a knight from the hell, the skill will be usable again in [color=" + this.Const.UI.Color.NegativeValue + "]" + cooldownLeft + "[/color] turns."
        }
        return cooldown;
    }
	
	

    function isUsable() {
        return this.m.Cooldown == 0 && this.skill.isUsable();
    }

    function onTurnStart() {
        this.m.Cooldown = this.Math.max(0, this.m.Cooldown - 1);
    }

    function onCombatStarted()
	{
		this.m.Cooldown = 0;
		this.skill.onCombatStarted();
	}

	function onCombatFinished()
	{
		this.m.Cooldown = 0;
		this.skill.onCombatFinished();
	}

    function onVerifyTarget(_originTile, _targetTile) {
        local actor = this.getContainer().getActor();
        return this.skill.onVerifyTarget(_originTile, _targetTile) && _targetTile.IsEmpty;
    }

    function onUse(_user, _targetTile) {
        local s = [
            "scripts/entity/tactical/enemies/zombie_knight"	   
        ];
        local script = s[this.Math.rand(0, s.len() - 1)];
        local entity = this.Tactical.spawnEntity(script, _targetTile.Coords.X, _targetTile.Coords.Y);
        entity.setFaction(this.Const.Faction.PlayerAnimals);
        entity.riseFromGround(0.75);
        entity.assignRandomEquipment();
		
		if (entity.hasSprite("head")){
				entity.getSprite("head").Color = this.createColor("#860111")
		}		
		
        this.m.Cooldown = this.m.CooldownMax;
        return true;
    }

});