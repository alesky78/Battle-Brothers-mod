this.demon_strength <- this.inherit("scripts/skills/skill", {
	m = {		
		action_points_per_turn = 0,
		action_points_per_kill = 0,
		fatigue_recovery_per_turn = 0
	},
	
	function create()
	{
		this.m.ID = "actives.demon_strength";
		this.m.Name = "Demon Strength";
		this.m.Description = "Pray the demon to obtain more power, giving your blod as payement";
		this.m.KilledString = "Terrified to death";		
		this.m.Icon = "skills/demon_strength.png";
		this.m.IconDisabled = "skills/demon_strength_sw.png";
		//this.m.Overlay = "active_41";
		this.m.SoundVolume = 1.1,
		this.m.SoundOnUse = [
			"sounds/combat/demon_strength.wav"
		];
		this.m.IsSerialized = true;	//skill to save		

		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;		
		
		this.m.Delay = 0;
		this.m.IsActive = true;
		this.m.IsTargeted = false;	
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsRanged = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = false;
		this.m.IsVisibleTileNeeded = true;			
	}
	
	function getTooltip()
	{
		local ret = [
			{
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
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Become [color=" + this.Const.UI.Color.NegativeValue + "]bleeding[/color] but obtain extra power from the demon, valid till you are bleeding: adrenaline rush, [color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.action_points_per_turn+ "[/color] action points per turn, [color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.fatigue_recovery_per_turn+ "[/color] Fatigue Recovery per turn, killing an enemy immediately regains [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.action_points_per_kill+ "[/color] Action Point, [color=" + this.Const.UI.Color.PositiveValue + "]+25%[/color] Melee Damage"
			}
		];
		return ret;
	}	
	
	
	
	/**
	* the skill are added during the CombatStarted by the demon_skill_trait
	* then this method will be not called for this skill if the combat si already started
	* then recall also for onAdded
	*/
	function onCombatStarted()
	{
		updateSkillPowerByLever();
	}		
	
	function onAdded()
	{
		updateSkillPowerByLever();
	}

	function updateSkillPowerByLever()
	{
			local actor = this.getContainer().getActor();
	
			//max values
			this.m.action_points_per_turn = 3;
			this.m.action_points_per_kill = 1;
			this.m.fatigue_recovery_per_turn = 6;
			
			local multiplier = 1.0; 
			if(actor.m.Level<12){
				multiplier = (actor.m.Level/11.0);			
			}
			
			this.logDebug("demon_strength: multiplier value "+multiplier);
			
			this.m.action_points_per_turn = this.Math.abs(this.Math.max(1,this.m.action_points_per_turn*multiplier));
			this.m.action_points_per_kill = this.Math.abs(this.Math.max(1,this.m.action_points_per_kill*multiplier));
			this.m.fatigue_recovery_per_turn = this.Math.abs(this.Math.max(1,this.m.fatigue_recovery_per_turn*multiplier));			
	}	

	function isUsable()
	{
		return !this.getContainer().hasSkill("effects.demon_strength");		
	}


	function onUse( _user, _targetTile )
	{
	
		local effect = this.new("scripts/skills/effects/demon_strength_effect");
		effect.m.action_points_per_turn = this.m.action_points_per_turn;
		effect.m.action_points_per_kill = this.m.action_points_per_kill;
		effect.m.fatigue_recovery_per_turn = this.m.fatigue_recovery_per_turn;
		this.m.Container.add(effect);
		
		//sacrifice of blood
		local n = _user.m.BloodType;
		for( local i = 0; i < this.Const.Tactical.BloodEffects[n].len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BloodEffects[n][i].Brushes, _targetTile, this.Const.Tactical.BloodEffects[n][i].Delay, this.Const.Tactical.BloodEffects[n][i].Quantity, this.Const.Tactical.BloodEffects[n][i].LifeTimeQuantity, this.Const.Tactical.BloodEffects[n][i].SpawnRate, this.Const.Tactical.BloodEffects[n][i].Stages);
		}
		
		this.m.Container.add(this.new("scripts/skills/effects/bleeding_effect"));		
		
		return true;
	}

});

