this.demon_slayer_faction <- this.inherit("scripts/factions/faction", {
	m = {
		HairColor = 0
	},
	function create()
	{
		this.faction.create();
		this.m.Type = this.Const.FactionType.demon_slayer;
		this.m.HairColor = this.Math.rand(0, this.Const.HairColors.Lineage.len() - 1);		
		this.m.Base = "world_base_07";
		this.m.TacticalBase = "bust_base_military";
		this.m.CombatMusic = this.Const.Music.NobleTracks;
		this.m.Footprints = this.Const.GenericFootprints;		
		this.m.PlayerRelation = 0.0;
		//show in the UI faction menu
		this.m.IsHiddenIfNeutral = false
		this.m.IsHidden = true
		this.m.IsRelationDecaying = false;	
	}

	function onSerialize( _out )
	{
		this.faction.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.faction.onDeserialize(_in);
	}
	
	function getBannerSmall()
	{
		return "banner_noble_" + (this.m.Banner < 10 ? "0" + this.m.Banner : this.m.Banner);
	}	
	
	function onUpdateRoster()
	{
		for( local roster = this.getRoster(); roster.getSize() < 4;  )
		{
			local character = roster.create("scripts/entity/tactical/humans/noble");
			character.setFaction(this.m.ID);
			character.m.HairColors = this.Const.HairColors.Lineage[this.m.HairColor];
			character.setAppearance();
			character.setTitle("von " + this.m.Name);
			character.assignRandomEquipment();
		}
	}	

});

