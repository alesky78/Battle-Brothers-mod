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
	
	
	/*
	// OK - mods_hookNewObject can be used to overwrite the properties value
	::mods_hookNewObject("skills/actives/aimed_shot", function(o){ 
		o.m.ActionPointCost = 1; 
	})

	this.logInfo("log_test ouside hook");		//blu
	this.logError("log_test ouside hook");		//red
	this.logWarning("log_test ouside hook");	//orange
	this.logDebug("log_test ouside hook");		//yellow	
	
	*/
});


