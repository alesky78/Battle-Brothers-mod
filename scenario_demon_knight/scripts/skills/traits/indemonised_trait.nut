this.indemonised_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "indemonised.master";
		this.m.Name = "Indemonised";
		this.m.Icon = "ui/traits/trait_icon_indemonised.png";
		this.m.Description = "Horribly inhuman, feels no fear, he desires only death and destruction of his enemies.";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
		this.m.Titles = [];
		this.m.Excluded = [
			"trait.disloyal"
			"trait.huge"
			"trait.survivor"
			"trait.dastard"
			"trait.fear_nobles"
			"trait.pessimist"
			"trait.asthmatic"
			"trait.craven"
			"trait.short_sighted"
			"trait.hesitant"
			"trait.cocky"
			"trait.clumsy"
			"trait.dumb"
			"trait.fainthearted"
			"trait.bleeder"
			"trait.ailing"
			"trait.fragile"
			"trait.insecure"
			"trait.superstitious"
			"trait.asthmatic"
			"trait.craven"
			"trait.greedy"
			"trait.gluttonous"
			"trait.irrational"
			"trait.clubfooted"
			"trait.brute"
			"trait.bloodthirsty"
			"trait.night_blind"
			"trait.fear_beasts"
			"trait.fear_undead"
			"trait.fear_greenskins"
		];
	}

	function getTooltip()
	{
		return [
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
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] Initiative"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+30[/color] Resolve"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+25%[/color] Melee Damage"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] Melee Skill"
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Melee Defense"
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Ranged Defense"
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+50[/color] Max Fatigue"
			},
			{
				id = 17,
				type = "text",
				icon = "ui/icons/health.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+50[/color] Hitpoints"
			},
			{
				id = 18,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Builds up [color=" + this.Const.UI.Color.PositiveValue + "]2[/color] less fatigue for each tile travelled"
			},
			{
				id = 19,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+1[/color] Vision"
			},
			{
				id = 20,
				type = "text",
				icon = "ui/icons/special.png",
				text = "All kills are fatalities (if the weapon allows)."
			},
			{
				id = 21,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Upon killing an enemy on his turn, this character immediately regains [color=" + this.Const.UI.Color.PositiveValue + "]1[/color] Action Point"
			},
			{
				id = 22,
				type = "text",
				icon = "ui/icons/morale.png",
				text = "No morale check triggered upon losing hitpoints"
			},
			{
				id = 23,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Is not affected by fresh injuries sustained during the current battle"
			},
			{
				id = 24,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can use demoniac skills in battle"
			},
			{
				id = 25,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Don't eat more food"
			}
			
		];
	}

	function onUpdate( _properties )
	{
	
		//da analizzare effect/berserker_rage_effect e prorpio fico e fa vedere come aumentare i poteri con il passare dei turni
	
		_properties.Initiative += 20;
		_properties.Bravery += 30;		
		_properties.MeleeDamageMult *= 1.25;		
		_properties.MeleeSkill += 20;		
		_properties.MeleeDefense += 10;
		_properties.RangedDefense += 10;	
		_properties.Stamina += 50;		
		_properties.Hitpoints += 50;		

		_properties.MovementFatigueCostAdditional -= 2;		

		_properties.Vision += 1;
		
		_properties.RerollMoraleChance = 100;
		_properties.RerollDefenseChance += 10;		
		_properties.FatalityChanceMult = 1000.0;		
		
		_properties.IsAffectedByLosingHitpoints = false;
		_properties.IsAffectedByFreshInjuries = false;		
		
		_properties.DailyWageMult *= 0.0;
		_properties.DailyFood = 0;
		_properties.XPGainMult *= 1.25;		
		
		
	}
	
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill.isAttack() && !_skill.isRanged())
		{
			_properties.DamageAgainstMult[this.Const.BodyPart.Head] += 0.15;
		}
	}
	
	function onCombatStarted()
	{
		local actor = this.getContainer().getActor();

		if (actor.getMoodState() >= this.Const.MoodState.Neutral && actor.getMoraleState() < this.Const.MoraleState.Confident)
		{
			actor.setMoraleState(this.Const.MoraleState.Confident);
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
			actor.setActionPoints(this.Math.min(actor.getActionPointsMax(), actor.getActionPoints() + 1));
			actor.setDirty(true);
			this.spawnIcon("trait_icon_71", this.m.Container.getActor().getTile());
		}
	}	
	

});

