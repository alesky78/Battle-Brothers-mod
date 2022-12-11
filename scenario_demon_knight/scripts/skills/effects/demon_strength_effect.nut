this.demon_strength_effect <- this.inherit("scripts/skills/skill", {
	m = {
		first_activation = true,
		action_points_per_turn = 0,
		action_points_per_kill = 0,
		fatigue_recovery_per_turn = 0
	},
	
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
		return "adrenaline rush, [color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.action_points_per_turn+ "[/color] action points per turn, [color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.fatigue_recovery_per_turn+ "[/color] Fatigue Recovery per turn,  killing an enemy immediately regains [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.action_points_per_kill+ "[/color] Action Point";
	}
	
	
	function onUpdate( _properties )
	{
			_properties.InitiativeForTurnOrderAdditional += 2000;
			_properties.ActionPoints = _properties.ActionPoints + this.m.action_points_per_turn;
			_properties.FatigueRecoveryRate += this.m.fatigue_recovery_per_turn;			
			
			//give 3 action point first time it is used
			if(this.m.first_activation){
				this.m.first_activation = false;
				local actor = this.getContainer().getActor();
				actor.setActionPoints(this.Math.min(actor.getActionPointsMax(), actor.getActionPoints() + this.m.action_points_per_turn));			
			}

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
			actor.setActionPoints(this.Math.min(actor.getActionPointsMax(), actor.getActionPoints() + this.m.action_points_per_kill));
			actor.setDirty(true);
			this.spawnIcon("trait_icon_71", this.m.Container.getActor().getTile());
		}
	}	


});

