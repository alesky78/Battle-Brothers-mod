::mods_registerMod("mod_scenario_demon_knight", 1.0, "mod_scenario_demon_knight");
::mods_queue("mod_scenario_demon_knight", null, function() 
{	
		
	/**
	* the scenario manager during the create() has a dirty implementation to verify if you can see a scenario.
	* To add properly the new scenario avoiding to impact the scenario already installed, add the new scenario after all the other scenario are added
	* other way same scenario could be push out of the list in the UI
	*/
	::mods_hookNewObject("scenarios/scenario_manager", function(o){ 
	  		
		//add the new scenario
		local s = this.new("scripts/scenarios/world/demon_knight_scenario");
		s.m.becomeValid = true;
		o.m.Scenarios.push(s);
		o.m.Scenarios.sort(o.onOrderCompare);
		this.logInfo("demon_knight_scenario added to the scenario_manager");

    });
	
	
	/**
	* the faction_manager must be modified in the way to 
	* 1 - create the new faction 
	* 2 - update the new faction
	*/
	::mods_hookNewObjectOnce("factions/faction_manager", function (o)
	{
	
		this.logDebug("hook: factions/faction_manager");	
	
		//create the new faction and push it in the list of the factions
		local createFactions = o.createFactions;
		o.createFactions = function()
		{	
			createFactions()
			local demon_slayer_faction = this.new("scripts/factions/demon_slayer_faction")
			demon_slayer_faction.setID(this.m.Factions.len());
			demon_slayer_faction.setName("Demon Slayer");
			demon_slayer_faction.setDiscovered(true);
			demon_slayer_faction.addTrait(this.Const.FactionTrait.demon_slayer);
			
			//add the banner using noble house banner
			local banners = [];
			local factions = this.getFactionsOfType(this.Const.FactionType.NobleHouse)
			foreach(faction in factions ){
					banners.push(faction.m.Banner);
			}
			
			local banner;
			do{
				banner = this.Math.rand(2, 10);
			}while (banners.find(banner) != null);			
			
			demon_slayer_faction.setBanner(banner);
			
			this.m.Factions.push(demon_slayer_faction);
		}			
		
		//update the simualtion adding also the new faction
		local runSimulation = o.runSimulation;		
		o.runSimulation = function()
		{	
			runSimulation()
			local demon_slayer_faction = this.getFactionOfType(this.Const.FactionType.demon_slayer);
			for( local i = 0; i < this.Const.Factions.CyclesOnNewCampaign; i = ++i )
			{
				demon_slayer_faction.update(true, true);
			}
		}		
	})	
	
	
	/**
	* script that permit to enable the development mode
	* defined in the table m.developer_mode = true;	
	*	
	* factions/faction_action/build_demon_slayer_camp_action	--> show immediatelly the demon slayer settlements in the word map
	*/		




	/*
	this.logInfo("log_test ouside hook");		//blu
	this.logError("log_test ouside hook");		//red
	this.logWarning("log_test ouside hook");	//orange
	this.logDebug("log_test ouside hook");		//yellow	
	
	*/
});


