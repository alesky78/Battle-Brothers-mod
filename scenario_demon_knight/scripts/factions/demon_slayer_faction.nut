this.demon_slayer_faction <- this.inherit("scripts/factions/faction", {
	m = {
		HairColor = 0
		FootprintsType = 0		
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
		this.m.FootprintsType = this.Const.World.FootprintsType.Nobles;
		this.m.PlayerRelation = 0.0;
		//show in the UI faction menu
		this.m.IsHiddenIfNeutral = false
		this.m.IsHidden = false
		this.m.IsRelationDecaying = true;	
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
	
	function getMotto()
	{
		return "Primus gra-dus pietatis est sanctitatem diligere, postea Sanctos";
	}	
	
	function getDescription()
	{
		return "The demon slayer knights, also known simply demon slayer, are a religious order of knights whose sole purpose is to wipe all demonic forms off the face of the earth and send them back into the dark abyss of hell.";
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

