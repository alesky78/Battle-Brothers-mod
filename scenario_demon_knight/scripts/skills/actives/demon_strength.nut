this.demon_strength <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.demon_strength";
		this.m.Name = "Demon Strength";
		this.m.Description = "Pray the demon to obtain more power, giving your blod as payement";
		this.m.KilledString = "Terrified to death";		
		this.m.Icon = "skills/demon_strength.png";
		this.m.IconDisabled = "skills/demon_strength_sw.png";
		//this.m.Overlay = "active_41";
		this.m.SoundOnUse = [
			"sounds/combat/demon_strength.wav"
		];

		this.m.ActionPointCost = 0;
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
				text = "Become bleeding but obtain the power of the demon, valid this you are bleeding: adrenaline rush, [color=" + this.Const.UI.Color.PositiveValue + "]+3[/color] action points per turn, [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] Fatigue Recovery per turn,  killing an enemy immediately regains [color=" + this.Const.UI.Color.PositiveValue + "]2[/color] Action Point"
			}
		];
		return ret;
	}	

	function isUsable()
	{
		return !this.getContainer().hasSkill("effects.demon_strength");		
	}


	function onUse( _user, _targetTile )
	{

		this.m.Container.add(this.new("scripts/skills/effects/demon_strength_effect"));
		this.m.Container.add(this.new("scripts/skills/effects/bleeding_effect"));		


		return true;
	}

});

