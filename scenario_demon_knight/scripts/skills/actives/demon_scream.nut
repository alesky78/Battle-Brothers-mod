this.demon_scream <- this.inherit("scripts/skills/skill", {
	m = {},
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

		this.m.ActionPointCost = 1;
		this.m.FatigueCost = 0;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;		
		
		this.m.Delay = 0;
		this.m.IsSerialized = false;
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
				text = "All the enemy around you could become horrified and unable to act until next turn. They have [color=" + this.Const.UI.Color.NegativeValue + "]-50[/color] malus to resolve the morale checks. can be use only one time per fight."
			}
		];
		return ret;
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

			target.checkMorale(-2, -50, this.Const.MoraleCheckType.MentalAttack)

			if (!target.checkMorale(-1, -50, this.Const.MoraleCheckType.MentalAttack))
			{
				target.getSkills().add(this.new("scripts/skills/effects/horrified_effect"));

				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " is horrified");
				}
			}
		}
		
		this.m.Container.add(this.new("scripts/skills/effects/demon_scream_effect"));

		return true;
	}

});

