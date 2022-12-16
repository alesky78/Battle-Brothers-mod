this.demon_scream <- this.inherit("scripts/skills/skill", {
	m = {
		morale_checks_malus = 0
	},
	function create()
	{
		this.m.ID = "actives.demon_scream";
		this.m.Name = "Demon Scream";
		this.m.Description = "Show the demon that possesses you terrorising the enemy";
		this.m.KilledString = "Terrified to death";		
		this.m.Icon = "skills/demon_scream.png";
		this.m.IconDisabled = "skills/demon_scream_sw.png";
		//this.m.Overlay = "active_41";
		this.m.SoundOnUse = [
			"sounds/combat/demon_scream.wav"
		];
		this.m.IsSerialized = true;	//skill to save				

		this.m.ActionPointCost = 1;
		this.m.FatigueCost = 6;
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
				text = "All the enemy around you could become horrified and unable to act until next turn. They have [color=" + this.Const.UI.Color.NegativeValue + "]-" +this.m.morale_checks_malus+ "[/color] malus to resolve the morale checks. can be use only one time per fight."
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
	
	function updateSkillPowerByLever(){
		local actor = this.getContainer().getActor();
	
			//max values
			this.m.morale_checks_malus = 35;

			local multiplier = 1.0; 
			if(actor.m.Level<12){
				multiplier = (actor.m.Level/11.0);			
			}
			
			//this.logDebug("demon_scream: multiplier value "+multiplier);
			
			this.m.morale_checks_malus = this.Math.abs(this.m.morale_checks_malus*multiplier);			
	}

	
	//usable if at least one enemy around you
	function isUsable()
	{
		local actor = this.m.Container.getActor();
		local tile = actor.getTile();

		local targets = [];
		
		for( local i = 0; i < 6; i = ++i )
		{
			if (!tile.hasNextTile(i))
			{
			}
			else
			{
				local adjacent = tile.getNextTile(i);

				if (adjacent.IsOccupiedByActor)
				{
					local entity = adjacent.getEntity();

					if (this.isViableTarget(actor, entity))
					{
						targets.push(entity);
					}
				}
			}
		}		
	
		return targets.len()>0 && !this.getContainer().hasSkill("effects.demon_scream");
		
	}


	function isViableTarget( _user, _target )
	{
		if (_target.isAlliedWith(_user))
		{
			return false;
		}

		if (_target.getMoraleState() == this.Const.MoraleState.Ignore || _target.getMoraleState() == this.Const.MoraleState.Fleeing || _target.getCurrentProperties().IsStunned)
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local targets = [];

		local tile = _user.getTile();


		for( local i = 0; i < 6; i = ++i )
		{
			if (!tile.hasNextTile(i))
			{
			}
			else
			{
				local adjacent = tile.getNextTile(i);

				if (adjacent.IsOccupiedByActor)
				{
					local entity = adjacent.getEntity();

					if (this.isViableTarget(_user, entity))
					{
						targets.push(entity);
					}
				}
			}
		}

		foreach( target in targets )
		{
			local effect = this.Tactical.spawnSpriteEffect("effect_skull_03", this.createColor("#ffffff"), target.getTile(), 0, 40, 1.0, 0.25, 0, 400, 300);

			target.checkMorale(-2, -this.m.morale_checks_malus, this.Const.MoraleCheckType.MentalAttack)

			if (!target.checkMorale(-1, -this.m.morale_checks_malus, this.Const.MoraleCheckType.MentalAttack))
			{
				target.getSkills().add(this.new("scripts/skills/effects/horrified_effect"));

				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " is horrified");
				}
			}
		}
		
		//smock effect during transformation
		if (this.Const.Tactical.SmokeParticles.len() != 0)
		{
			for( local i = 0; i < this.Const.Tactical.SmokeParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.SmokeParticles[i].Brushes, _user.getTile(), this.Const.Tactical.SmokeParticles[i].Delay, this.Const.Tactical.SmokeParticles[i].Quantity, this.Const.Tactical.SmokeParticles[i].LifeTimeQuantity, this.Const.Tactical.SmokeParticles[i].SpawnRate, this.Const.Tactical.SmokeParticles[i].Stages);
			}
		}				
		
		//all the sprites that become red
		local sprites = {};
		sprites.head <- {};
		sprites.head.name <- "head";
		sprites.head.color <- "";
		sprites.body <- {};
		sprites.body.name <- "body";
		sprites.body.color <- "";					
		
		foreach (key, value in sprites) {
			local sprite = sprites[key];
			if (_user.hasSprite(sprite.name)){
					sprite.color = _user.getSprite(sprite.name).Color;
					_user.getSprite(sprite.name).Color = this.createColor("#860111")
				}
		}
				
		local effect = this.new("scripts/skills/effects/demon_scream_effect");
		effect.m.sprites = sprites;
		this.m.Container.add(effect);

		return true;
		
	}

});

