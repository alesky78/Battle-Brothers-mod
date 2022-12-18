this.fire_from_hell_skill <- this.inherit("scripts/skills/skill", {
	m = {
		HitChanceBonus_by_level = 0
	},
	function create()
	{
		this.m.ID = "actives.fire_from_hell";
		this.m.Name = "Fire from hell";
		this.m.Description = "The hands of the demon unleash a stream of fire at your opponents.";
		this.m.Icon = "skills/fire_from_hell.png";
		this.m.IconDisabled = "skills/fire_from_hell_sw.png";
		//this.m.Overlay = "active_202";
		this.m.SoundVolume = 1.1,		
		this.m.SoundOnUse = [
			"sounds/combat/fire_from_hell_use.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/poison_applied_01.wav",
			"sounds/combat/poison_applied_02.wav"
		];
		this.m.IsSerialized = true;		

		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 5;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.MaxRangeBonus = 0;
		//this.m.MaxLevelDifference = 4;
		//this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		
		this.m.SoundOnHitDelay = 0;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Delay = 500;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsUsingHitchance = true;
		this.m.IsDoingForwardMove = true;
		this.m.IsTargetingActor = false;
		this.m.InjuriesOnBody = this.Const.Injury.BurningBody;
		this.m.InjuriesOnHead = this.Const.Injury.BurningHead;
		this.m.HitChanceBonus = 0;	// set by updateSkillPowerByLever()
		this.m.DirectDamageMult = 0.70;	//70% ingore armour
		
		//this.m.ChanceDecapitate = 10;
		//this.m.ChanceDisembowel = 30;
		//this.m.ChanceSmash = 50;		

	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "Has [color=" + this.Const.UI.Color.PositiveValue + "]+" +this.m.HitChanceBonus_by_level+ "%[/color] chance to hit"
		});
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Can hit up to 2 targets"
		});

		return ret;
	}

	/**
	* the skill are added during the CombatStarted by the demon_skill_trait
	* then this method will be not called for this skill if the combat si already started
	* then recall also for onAdded
	*/	
	function onCombatStarted()
	{
		this.skill.onCombatStarted();
		updateSkillPowerByLever();		
	}		
	
	function onAdded()
	{
		updateSkillPowerByLever();
	}	
	
	function updateSkillPowerByLever(){
		local actor = this.getContainer().getActor();
	
			//max values
			this.m.HitChanceBonus_by_level = 40;

			local multiplier = 1.0; 
			if(actor.m.Level<11){
				multiplier = (actor.m.Level/11.0);			
			}
			
			//this.logDebug("fire_from_hell_skill: multiplier value "+multiplier);
			
			this.m.HitChanceBonus_by_level = this.Math.abs(this.m.HitChanceBonus_by_level*multiplier);	
			this.m.HitChanceBonus = this.m.HitChanceBonus_by_level;
	}
	

	function isUsable()
	{
		return this.skill.isUsable();
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.RangedSkill += 40;
			_properties.DamageRegularMin = 40;
			_properties.DamageRegularMax = 60;
			_properties.DamageArmorMult = 0;
		}
	}
	
	function onTargetSelected( _targetTile )
	{
		this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
		local ownTile = this.m.Container.getActor().getTile();
		local dir = ownTile.getDirectionTo(_targetTile);

		if (_targetTile.hasNextTile(dir))
		{
			local forwardTile = _targetTile.getNextTile(dir);

			if (this.Math.abs(forwardTile.Level - ownTile.Level) <= 1)
			{
				this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, forwardTile, forwardTile.Pos.X, forwardTile.Pos.Y);
			}
		}
	}	

	function onUse( _user, _targetTile )
	{

		local myTile = _user.getTile();
		local dir = myTile.getDirectionTo(_targetTile);

		//determine the targets
		local targets = [];		
		if (_targetTile.IsOccupiedByActor && _targetTile.getEntity().isAttackable())
		{
			targets.push(_targetTile.getEntity());
		}
		
		if (_targetTile.hasNextTile(dir))
		{
			local nextTile = _targetTile.getNextTile(dir);

			if (nextTile.IsOccupiedByActor && nextTile.getEntity().isAttackable() && this.Math.abs(nextTile.Level - myTile.Level) <= 1)
			{
				targets.push(nextTile.getEntity());
			}
		}

		local tag = {
			User = _user,
			TargetTile = _targetTile,
			Targets = targets			
		};		
		
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, this.onDelayedEffect.bindenv(this), tag);
		return true;
	}	

	function onDelayedEffect( _tag )
	{
		local user = _tag.User;
		local targetTile = _tag.TargetTile;
		local targets  = _tag.Targets;
		
		local myTile = user.getTile();

		if (myTile.IsVisibleForPlayer)
		{
			if (user.isAlliedWithPlayer())
			{
				for( local i = 0; i < this.Const.Tactical.FireLanceRightParticles.len(); i = ++i )
				{
					local effect = this.Const.Tactical.FireLanceRightParticles[i];
					this.Tactical.spawnParticleEffect(false, effect.Brushes, myTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 0));
				}
			}
			else
			{
				for( local i = 0; i < this.Const.Tactical.FireLanceLeftParticles.len(); i = ++i )
				{
					local effect = this.Const.Tactical.FireLanceLeftParticles[i];
					this.Tactical.spawnParticleEffect(false, effect.Brushes, myTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 0));
				}
			}
		}

		this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], 1.0, user.getPos());
		local tag = {
			User = user,
			Targets = targets
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 200, this.applyEffectToTargets.bindenv(this), tag);
		return true;
	}
	
	function applyEffectToTargets( _tag )
	{
		local user = _tag.User;
		local targets = _tag.Targets;

		foreach( t in targets )
		{
			if (!t.isAlive() || t.isDying())
			{
				continue;
			}

			local success = this.attackEntity(user, t, false);

			if (success && t.isAlive() && !t.isDying() && t.getTile().IsVisibleForPlayer)
			{
				for( local i = 0; i < this.Const.Tactical.BurnParticles.len() - 1; i = ++i )
				{
					local effect = this.Const.Tactical.BurnParticles[i];
					this.Tactical.spawnParticleEffect(false, effect.Brushes, t.getTile(), effect.Delay, effect.Quantity * 0.1, effect.LifeTimeQuantity * 0.1, effect.SpawnRate * 0.1, effect.Stages, this.createVec(0, 0));
				}
			}
		}
	}	

});

