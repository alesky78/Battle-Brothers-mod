this.demon_knight_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {
		becomeValid = false
	},
	function create()
	{
		this.m.ID = "scenario.demon_knight";
		this.m.Name = "The Demon Knigh";
		this.m.Description = "[p=c][img]gfx/ui/events/event_scenario_demon_knight.png[/img][/p][p]You had a rough life. Younger son of a lord got caught up in a succession crisis, become a slave. You survived to all this and being trained as a knight. \n\n[color=#bcad8c]Lone Wolf:[/color] Start with and indemonised knight.\n[color=#bcad8c]Elite Few:[/color] Can never have more than 1 men in your roster.\n[color=#bcad8c]Skilled:[/color] Start with few free of charge perks.\n[color=#bcad8c]Avatar:[/color] If you avatar dies, the campaign ends.[/p]";
		this.m.Difficulty = 3;
		this.m.Order = 1;
		this.m.IsFixedLook = true;
	}

	function isValid()
	{
		return this.m.becomeValid;
	}
	
	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local bro = roster.create("scripts/entity/tactical/player");
		
		//set the startign value 
		setStartValuesEx(bro, "demon_knight_background");
		
		bro.getBackground().m.RawDescription = "A Demon Knight, anyone approaching him feels a sense of dread, you must face every challenge alone";
		bro.getBackground().buildDescription(true);
		
		bro.setTitle("The Demon knight");
				
		//trait
		bro.getSkills().add(this.new("scripts/skills/traits/player_character_trait"));
		bro.getSkills().add(this.new("scripts/skills/traits/iron_lungs_trait"));
		//bro.getSkills().add(this.new("scripts/skills/traits/indemonised_trait"));		this trait is obtained by the starting event, see event.demon_knight_scenario_intro
			
		//generic data
		bro.setPlaceInFormation(4);
		bro.getFlags().set("IsPlayerCharacter", true);
		
		bro.getSprite("miniboss").setBrush("bust_miniboss_lone_wolf");
		bro.m.HireTime = this.Time.getVirtualTimeF();

		//experience and start perks
		bro.m.PerkPoints = 3;
		bro.m.LevelUps = 3;
		bro.m.Level = 4;

		//Talents and attributes
		bro.m.Talents = [];
		bro.m.Attributes = [];
		local talents = bro.getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.MeleeDefense] = 3;
		talents[this.Const.Attributes.Fatigue] = 3;
		talents[this.Const.Attributes.MeleeSkill] = 3;
		talents[this.Const.Attributes.Bravery] = 3;		
		
		//fill the attributes
		bro.fillAttributeLevelUpValues(1,true,false);

		//extra perks wihtout impacting the defaul 11 perks
		local skills = bro.m.Skills;
		skills.add(this.new("scripts/skills/perks/perk_mastery_sword"));
		skills.add(this.new("scripts/skills/perks/perk_mastery_hammer"));		
		skills.add(this.new("scripts/skills/perks/perk_fearsome"));
		
		//add demoniac skills 
		skills.add(this.new("scripts/skills/actives/demon_scream"));
		skills.add(this.new("scripts/skills/actives/demon_strength"));		
		
		skills.update();				

		//starting items
		local items = bro.getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Body));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Offhand));
		
		//weapon and armour 
		items.equip(this.new("scripts/items/armor/sellsword_armor"));
		items.equip(this.new("scripts/items/helmets/bascinet_with_mail"));	
		items.equip(this.new("scripts/items/weapons/longsword"));
		
		//reputation
		this.World.Assets.m.BusinessReputation = 200;
		
		//stash start assets
		this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() - 9);
		
		this.World.Assets.m.Money = this.World.Assets.m.Money / 2 - (this.World.Assets.getEconomicDifficulty() == 0 ? 0 : 100);
		this.World.Assets.m.ArmorParts = this.World.Assets.m.ArmorParts / 2;
		this.World.Assets.m.Medicine = this.World.Assets.m.Medicine / 3;
		this.World.Assets.m.Ammo = 0;
	}
	
	function setStartValuesEx(bro, background_name){
	
			//set default logic and don't add any new trait
			bro.setStartValuesEx([background_name],false);
	
			/*in case you want to force the attributes to the max of the background
			
			//standard values map defined in the scripts\skills\backgrounds\character_background.nut
			local a = {
				Hitpoints = [50,60],
				Bravery = [30,40],
				Stamina = [90,100],
				MeleeSkill = [47,57],
				RangedSkill = [32,42],
				MeleeDefense = [0,5],
				RangedDefense = [0,5],
				Initiative = [100,110]
			};
			
			//overwrite with max values of its backgrounds 
			local background = this.new("scripts/skills/backgrounds/" + background_name);
			local c = background.onChangeAttributes();
			
			a.Hitpoints[1] += c.Hitpoints[1];
			a.Bravery[1] += c.Bravery[1];
			a.Stamina[1] += c.Stamina[1];
			a.MeleeSkill[1] += c.MeleeSkill[1];
			a.MeleeDefense[1] += c.MeleeDefense[1];
			a.RangedSkill[1] += c.RangedSkill[1];
			a.RangedDefense[1] += c.RangedDefense[1];
			a.Initiative[1] += c.Initiative[1];
			
			local b = bro.getBaseProperties();

			//set the properties
			b.Hitpoints = a.Hitpoints[1];
			b.Bravery = a.Bravery[1];
			b.Stamina = a.Stamina[1];
			b.MeleeSkill = a.MeleeSkill[1];
			b.RangedSkill = a.RangedSkill[1];
			b.MeleeDefense = a.MeleeDefense[1];
			b.RangedDefense = a.RangedDefense[1];
			b.Initiative = a.Initiative[1];
*/			
			
	}
	
	

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() >= 3 && !randomVillage.isSouthern())
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 1), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 1));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 1), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 1));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) == 0)
				{
				}
				else if (!tile.HasRoad)
				{
				}
				else
				{
					randomVillageTile = tile;
					break;
				}
			}
		}
		while (1);

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(6); 	 //sellman look
		
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList(["music/noble_02.ogg"], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.demon_knight_scenario_intro");
		}, null);
	}

	function onInit()
	{
		//set the max brothers
		this.World.Assets.m.BrothersMax = 1;
		
		//clean the incompatibel events: by indemonised_trait avatar don't eat more but need to kill enemy to restore
		this.World.Events.deleteEventByID("event.good_food_variety");
		this.World.Events.deleteEventByID("event.no_food_variety");			
		this.World.Events.deleteEventByID("event.no_food");					
		this.World.Events.deleteEventByID("event.hunt_food");
		this.World.Events.deleteEventByID("event.food_goes_bad");		
		
		//clean the incompatibel ambitions: this is a lone scenario
		this.World.Ambitions.deleteAmbitionByID("ambition.hammer_mastery");	//i have this mastery by default
		this.World.Ambitions.deleteAmbitionByID("ambition.have_all_provisions");		
		this.World.Ambitions.deleteAmbitionByID("ambition.have_talent");		
		this.World.Ambitions.deleteAmbitionByID("ambition.hire_follower");		
		this.World.Ambitions.deleteAmbitionByID("ambition.ranged_mastery");
		this.World.Ambitions.deleteAmbitionByID("ambition.roster_of_12");	
		this.World.Ambitions.deleteAmbitionByID("ambition.roster_of_16");
		this.World.Ambitions.deleteAmbitionByID("ambition.roster_of_20");
		this.World.Ambitions.deleteAmbitionByID("ambition.sergeant");
		this.World.Ambitions.deleteAmbitionByID("ambition.weapon_mastery");
	
	}

	function onCombatFinished()
	{
		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			if (bro.getFlags().get("IsPlayerCharacter"))
			{
				return true;
			}
		}

		return false;
	}

});

