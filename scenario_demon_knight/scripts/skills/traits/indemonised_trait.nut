this.indemonised_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {
		last_time_kill = 0.0,
		days_Passed_no_kill = 0,
		attribute_Initiative = 0,
		attribute_Bravery  = 0,
		attribute_MeleeSkill = 0,
		attribute_MeleeDefense = 0,
		attribute_RangedDefense = 0,
		attribute_Stamina = 0,
		attribute_Hitpoints = 0
		
	},
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+"+this.m.attribute_Initiative+"[/color] Initiative"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+"+this.m.attribute_Bravery +"[/color] Resolve"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+"+this.m.attribute_MeleeSkill	+"[/color] Melee Skill"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+"+this.m.attribute_MeleeDefense+"[/color] Melee Defense"
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+"+this.m.attribute_RangedDefense+"[/color] Ranged Defense"
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+"+this.m.attribute_Stamina+"[/color] Max Fatigue"
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/health.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+"+this.m.attribute_Hitpoints+"[/color] Hitpoints"
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
				icon = "ui/icons/morale.png",
				text = "No morale check triggered losing hitpoints and not affected by fresh injuries sustained during the current battle"
			},
			{
				id = 20,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can use demoniac skills in battle, these abilities become more powerful increasing level"
			},
			{
				id = 21,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Don't eat more food, but the demon need to kill to survive or the attributes decreases. [color=" + this.Const.UI.Color.NegativeValue + "]" +this.m.days_Passed_no_kill+ "[/color] days wihtout a kill"
			},
{
				id = 22,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Attributes become more powerful increasing level"
			}
			
		];
	}

	function onUpdate( _properties )
	{
	
		//to analizze effect/berserker_rage_effect to implement a version base on the Hitpoints damage received
	
		//day passed since last kill
		this.m.days_Passed_no_kill = this.Math.ceil((this.getGameSessionTime() - this.m.last_time_kill) / this.World.getTime().SecondsPerDay);
			
		local multiplier = 1.0; 
		local actor = this.getContainer().getActor();
		if(actor.m.Level<12){
			multiplier = (actor.m.Level/11.0);			
		}			
						
		this.m.attribute_Initiative		=  this.Math.abs(this.Math.max(0, (30*multiplier)) - this.m.days_Passed_no_kill);
		this.m.attribute_Bravery 		=  this.Math.abs(this.Math.max(0, (30*multiplier)) - this.m.days_Passed_no_kill);
		this.m.attribute_MeleeSkill		=  this.Math.abs(this.Math.max(0, (15*multiplier)) - this.m.days_Passed_no_kill);
		this.m.attribute_MeleeDefense	=  this.Math.abs(this.Math.max(0, (15*multiplier)) - this.m.days_Passed_no_kill);
		this.m.attribute_RangedDefense	=  this.Math.abs(this.Math.max(0, (15*multiplier)) - this.m.days_Passed_no_kill);
		this.m.attribute_Stamina		=  this.Math.abs(this.Math.max(0, (50*multiplier)) - this.m.days_Passed_no_kill);
		this.m.attribute_Hitpoints		=  this.Math.abs(this.Math.max(0, (50*multiplier)) - this.m.days_Passed_no_kill);
						
		_properties.Initiative += this.m.attribute_Initiative;
		_properties.Bravery += this.m.attribute_Bravery;
		_properties.MeleeSkill += this.m.attribute_MeleeSkill;
		_properties.MeleeDefense += this.m.attribute_MeleeDefense;		
		_properties.RangedDefense += this.m.attribute_RangedDefense;
		_properties.Stamina += this.m.attribute_Stamina;
		_properties.Hitpoints += this.m.attribute_Hitpoints;

		_properties.MovementFatigueCostAdditional -= 2;		
		
		_properties.RerollMoraleChance = 100;
		_properties.RerollDefenseChance += 10;		
		_properties.FatalityChanceMult = 1000.0;		
		
		_properties.IsAffectedByLosingHitpoints = false;
		_properties.IsAffectedByFreshInjuries = false;		
		
		_properties.DailyWageMult *= 0.0;
		_properties.DailyFood = 0;
		
	}
		
	function onTargetKilled( _targetEntity, _skill )
	{
		this.m.last_time_kill = this.getGameSessionTime();
	}
	
	function getGameSessionTime()
	{
		if (("State" in this.World) && this.World.State != null && this.World.State.getCombatStartTime() != 0)
		{
			return this.World.State.getCombatStartTime();
		}
		else
		{
			return this.Time.getVirtualTimeF();
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
	

});

