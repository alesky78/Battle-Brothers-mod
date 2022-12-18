this.demon_skill_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.demon_skill";
		this.m.Name = "demon skill";
		this.m.Icon = "ui/traits/trait_icon_demon_skills.png";
		this.m.Description = "Summons the powers of hell.";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
		this.m.Titles = [];
		this.m.Excluded = [
		];
	}

	function getTooltip()
	{
        local level = this.getContainer().getActor().getLevel();	
		local dynamicTooltip = this.skill.getTooltip();
		
		dynamicTooltip.push({
			id = 1,
			type = "text",
			text = "The skills become more powerful increasing level, till 11\n"
		})				
				
        // 3
        if(level >= 5) 
        {
            dynamicTooltip.push({
				id = 5,
				type = "text",
				text = "[u]level 5:[/u]\n"
			})
            dynamicTooltip.push({
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "unlocked the skill '[color=" + this.Const.UI.Color.PositiveValue + "]Demon Scream[/color]'.\n"
			})
        } 
        else 
        {
            dynamicTooltip.push({
				id = 5,
				type = "text",
				text = "[color=#525252][u]level 5:[/u]\n unlock the skill 'Demon Scream'.[/color]\n"
			})
        }
		
        // 7
        if(level >= 7) 
        {
            dynamicTooltip.push({
				id = 7,
				type = "text",
				text = "[u]level 6:[/u]\n"
			})
            dynamicTooltip.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "unlocked the skill '[color=" + this.Const.UI.Color.PositiveValue + "]Fire from hell[/color]'.\n"
			})
        } 
        else 
        {
            dynamicTooltip.push({
				id = 7,
				type = "text",
				text = "[color=#525252][u]level 7:[/u]\n unlock the skill 'Fire from hell'.[/color]\n"
			})
        }			
		
        // 9
        if(level >= 9) 
        {
            dynamicTooltip.push({
				id = 9,
				type = "text",
				text = "[u]level 9:[/u]\n"
			})
            dynamicTooltip.push({
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "unlocked the skill '[color=" + this.Const.UI.Color.PositiveValue + "]Summon lost soul[/color]'.\n"
			})
        } 
        else 
        {
            dynamicTooltip.push({
				id = 9,
				type = "text",
				text = "[color=#525252][u]level 9:[/u]\n unlock the skill 'Summon lost soul'.[/color]\n"
			})
        }		

        // 1
        if(level >= 11) 
        {
            dynamicTooltip.push({
				id = 11,
				type = "text",
				text = "[u]level 11:[/u]\n"
			})
            dynamicTooltip.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "unlocked the skill '[color=" + this.Const.UI.Color.PositiveValue + "]Demon Strength[/color]'.\n"
			})
        } 
        else 
        {
            dynamicTooltip.push({
				id = 11,
				type = "text",
				text = "[color=#525252][u]level 11:[/u]\n unlock the skill 'Demon Strength'.[/color]\n"
			})
        }		
		
		return dynamicTooltip;
	}
			
	function onCombatStarted(){
		this.updateDemonSkills();
	}		
	
	function onRemoved(){		
		removeDemonSkills();
	}	
	
    function updateDemonSkills() {
        //this.logInfo("demon_skill_trait updateDemonSkills");
        local actor = this.getContainer().getActor();
        local level = actor.getLevel();
		local skills = actor.getSkills();
		
        if (level >= 5 && !skills.hasSkill("actives.demon_scream")) {
            skills.add(this.new("scripts/skills/actives/demon_scream"));
			//this.logInfo("demon_skill_trait add demon_scream");			
        }
		
        if (level >= 7 && !skills.hasSkill("actives.fire_from_hell")) {
            skills.add(this.new("scripts/skills/actives/fire_from_hell_skill"));
			//this.logInfo("demon_skill_trait add fire_from_hell_skill");			
        }		
		
        if (level >= 9 && !skills.hasSkill("actives.summon_lost_soul")) {
            skills.add(this.new("scripts/skills/actives/summon_lost_soul"));
			//this.logInfo("demon_skill_trait add summon_lost_soul");			
        }		
		
        if (level >= 11 && !skills.hasSkill("actives.demon_strength")) {
            skills.add(this.new("scripts/skills/actives/demon_strength"));
			//this.logInfo("demon_skill_trait add demon_strength");	
        }
    }	
	
    function removeDemonSkills() {	
	    //this.logInfo("demon_skill_trait remove all demoniac skills");		
		local actor = this.getContainer().getActor();
		local skills = actor.getSkills();
		
		skills.removeByID("actives.demon_scream");
		skills.removeByID("actives.fire_from_hell");
		skills.removeByID("actives.summon_lost_soul");
		skills.removeByID("actives.demon_strength");
	}
	

});

