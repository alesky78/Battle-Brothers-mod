this.build_demon_slayer_camp_action <- this.inherit("scripts/factions/faction_action", {
	m = {
		developer_mode=true
	},
	function create()
	{
		this.m.ID = "build_demon_slayer_camp_action";
		this.m.IsRunOnNewCampaign = true;
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		local settlements = _faction.getSettlements();

		if (this.World.FactionManager.isGreaterEvil())
		{
			if (settlements.len() > 3)
			{
				return;
			}
		}
		else if (settlements.len() > 3)
		{
			return;
		}

		this.m.Score = 2;
	}

	function onClear()
	{
	}

	function onExecute( _faction )
	{
		local camp;
		local r = this.Math.rand(1, 1);
		local minY = 0.0;
		local maxY = 1.0;
		local tile = null;		
		
		local disallowedTerrain = [this.Const.World.TerrainType.Mountains, this.Const.World.TerrainType.Impassable, this.Const.World.TerrainType.Ocean];
				
		if (r == 1)
		{
			tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, disallowedTerrain, 7, 300, 300, 7, 7, null, minY, maxY);

			if (tile != null)
			{
				camp = this.World.spawnLocation("scripts/entity/world/locations/demon_slayer_camp_location.nut", tile.Coords);
			}
		}

		if (camp != null)
		{
					
			camp.onSpawned();
			
			local banner = _faction.getBannerSmall();			
			camp.setBanner(banner);
			_faction.addSettlement(camp, false);
			
			if(this.m.developer_mode){
				this.logDebug("build_demon_slayer_camp_action: show the camp in the word map");				
				this.World.uncoverFogOfWar(tile.Pos, 500.0);			
				camp.setDiscovered(true);	//this show in the word map wihtout need to discover it
			}
		
		}
	}

});

