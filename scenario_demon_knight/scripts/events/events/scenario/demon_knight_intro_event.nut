this.demon_knight_intro_event <- this.inherit("scripts/events/event", {
	m = {
		indemonised = null	
	},
	function create()
	{
		this.m.ID = "event.demon_knight_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_scenario_demon_knight.png[/img]{Your wife and children have just died, the blood is everywhere. A stabbing pain breaks your heart, you can no longer breathe, you lose consciousness....\n\n Everything is dark around you, you hear a voice whispering \n\'what do you want now\', you reply that you just want to die.  The voice becomes clearer and replies \'I can help you if you want\'.\n\n Without thinking overwhelmed by pain you answer \n\'what should I do?\'\n\nYou feel a presence around you, you cannot see it or touch it but it is there with you and whispers in your ear \'let me in\'. \nYou let it go and you feel something go through your chest, you feel no pain but only a strange warmth.\n\n You wake up not knowing how much time has passed, minutes, days, hours?\n The bodies of your wife and children are no longer there and you feel strangely relieved....\n You don\'t understand, then you hear a voice inside you claiming: revenge... death...}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Yes, that is what I want, revenge... death...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local skill = this.new("scripts/skills/traits/indemonised_trait");
				_event.m.indemonised.getSkills().add(skill);				
			
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				this.Characters.push(_event.m.indemonised.getImagePath());
				this.List.push({
					id = 16,
					icon = "ui/traits/trait_icon_indemonised.png",
					text = _event.m.indemonised.getNameOnly() + " gains " + skill.getName() + " trait"
				});				
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();	
		
		local candidates = [];
		
		foreach( bro in brothers )
		{
		
			if(bro!=null && !bro.m.Skills.hasSkill("trait.indemonised")){
				candidates.push(bro);
			}				
		}
		
		if (candidates.len() == 0)
		{
			return;
		}

		this.m.indemonised = candidates[this.Math.rand(0, candidates.len() - 1)];
		
	}

	function onPrepare()
	{
		this.m.Title = "The Demon Knight";
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.indemonised = null;
	}

});

