::mods_registerMod("mod_scenario_demon_knight", 1.0, "mod_scenario_demon_knight");
::mods_queue("mod_scenario_demon_knight", null, function() 
{	

	/**
	* script that permit to enable functionality for the development mode	
	*	
	* 1 - show immediatelly the demon slayer settlements in the word map --> factions/faction_action/build_demon_slayer_camp_action set m.developer_mode = true; 
	*/		


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
		//this.logInfo("demon_knight_scenario added to the scenario_manager");

    });
	
	/**
	* there are same events that become incompatible with this scneario then create a function to support the delete
	* function deleteEventByID(ID);
	*/	
	::mods_hookNewObject("events/event_manager", function(o){ 
	  		
		o.disableEventByID <- function(ID)
		{
			local index = null;
			local event = null;
			for( local i = 0; i < this.m.Events.len(); i = ++i ){
				event = this.m.Events[i];
				if(event!=null && event.m.ID==ID){
					index = i;
				}
			}
			
			if(index!=null){
				this.m.Events.remove(index)
				this.logDebug("hook: events/event_manager event delete: " +ID);							
			}
		}
    });
	
	
	/**
	* there are same ambitions that become incompatible with this scneario then create a function to support the delete 
	* function deleteEventByID(ID);
	*/	
	::mods_hookNewObject("ambitions/ambition_manager", function(o){ 
	  		
		o.disableAmbitionByID <- function(ID)
		{
			local index = null;
			local ambition = null;
			for( local i = 0; i < this.m.Ambitions.len(); i = ++i ){
				ambition = this.m.Ambitions[i];
				if(ambition!=null && ambition.m.ID==ID){
					index = i;
				}
			}
			
			if(index!=null){
				this.m.Ambitions.remove(index)
				this.logDebug("hook: ambitions/ambition_manager ambition delete: "+ID);
			}
		}
    });	
			
	
	/**
	* the faction_manager must be modified in the way to 
	* 1 - create the new faction demon slayer
	* 2 - update the new faction demon slayer
	*/
	::mods_hookNewObjectOnce("factions/faction_manager", function (o)
	{
	
		//this.logDebug("hook: factions/faction_manager");	
	
		//create the new faction and add to the factionManager
		local createFactions = o.createFactions;
		o.createFactions = function()
		{	
			createFactions();
			
			//add the demon_slayer_faction
			local demon_slayer_faction = this.new("scripts/factions/demon_slayer_faction")
			demon_slayer_faction.setID(this.m.Factions.len());
			demon_slayer_faction.setName("Demon Slayer");
			demon_slayer_faction.setDiscovered(true);
			demon_slayer_faction.addTrait(this.Const.FactionTrait.demon_slayer);
			this.m.Factions.push(demon_slayer_faction);
			
			//add the banner to demon_slayer_faction using noble house banner
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

			//create alliance with demon_slayer_factions			
			for( local i = 0; i < this.m.Factions.len(); i = ++i ){
				if (this.m.Factions[i] != null && (this.m.Factions[i].getType() == this.Const.FactionType.Settlement || this.m.Factions[i].getType() == this.Const.FactionType.NobleHouse )){
					demon_slayer_faction.addAlly(i);
					this.m.Factions[i].addAlly(demon_slayer_faction.getID());					
					//this.logDebug("alliance created for index: " + i + " name:" + m.Factions[i].getName());									
				}
				
			}
	
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
	
});


