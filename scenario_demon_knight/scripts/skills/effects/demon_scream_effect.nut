this.demon_scream_effect <- this.inherit("scripts/skills/skill", {
	m = {
		sprites = {}
	},
	function create()
	{
		this.m.ID = "effects.demon_scream";
		this.m.Name = "Demon Scream";
		this.m.Icon = "skills/status_effect_70.png";
		this.m.IconMini = "status_effect_70_mini";
		this.m.Overlay = "status_effect_70";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "this character showed  the demon that controls him.";
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
			}
		];
	}
	
	function onCombatFinished()
	{
		
		local _user = this.getContainer().getActor();
		
		foreach (key, value in this.m.sprites) {
			local sprite = this.m.sprites[key];
			if (_user.hasSprite(sprite.name)){
					_user.getSprite(sprite.name).Color = sprite.color;
			}
		}
	
		this.skill.onCombatFinished();	

	}	


});

