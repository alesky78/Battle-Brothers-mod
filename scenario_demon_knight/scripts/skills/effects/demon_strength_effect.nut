this.demon_strength_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.demon_strength";
		this.m.Name = "Demon Strength";
		this.m.Icon = "skills/status_effect_70.png";
		this.m.IconMini = "status_effect_70_mini";
		this.m.Overlay = "status_effect_70";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "adrenaline rush, [color=" + this.Const.UI.Color.PositiveValue + "]+3[/color] action points per turn, [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] Fatigue Recovery per turn,  killing an enemy immediately regains [color=" + this.Const.UI.Color.PositiveValue + "]2[/color] Action Point";
	}
	
	
	function onUpdate( _properties )
	{
			_properties.InitiativeForTurnOrderAdditional += 2000;
			_properties.ActionPoints = _properties.ActionPoints + 3;
			_properties.FatigueRecoveryRate += 5;			
			
					
			//to check if add immediatelly 2 point here or find a solution in the effect
			//_user.setActionPoints(this.Math.min(actor.getActionPointsMax(), actor.getActionPoints() + 2));
	}
	
	function onTurnStart()
	{
		//remove when stop to blend
		if (!this.getContainer().hasSkill("effects.bleeding"))
		{
			this.removeSelf();
		}
	}
	
	function onTargetKilled( _targetEntity, _skill )
	{
		local actor = this.getContainer().getActor();

		if (actor.isAlliedWith(_targetEntity))
		{
			return;
		}

		if (actor.getActionPoints() == actor.getActionPointsMax())
		{
			return;
		}

		if (this.Tactical.TurnSequenceBar.getActiveEntity() != null && this.Tactical.TurnSequenceBar.getActiveEntity().getID() == actor.getID())
		{
			actor.setActionPoints(this.Math.min(actor.getActionPointsMax(), actor.getActionPoints() + 2));
			actor.setDirty(true);
			this.spawnIcon("trait_icon_71", this.m.Container.getActor().getTile());
		}
	}	


});

