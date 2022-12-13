this.demon_knight_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {
		becomeValid = false
	},
	function create()
	{
		this.m.ID = "scenario.demon_knight";
		this.m.Name = "The Demon Knigh";
		this.m.Description = "[p=c][img]gfx/ui/events/event_scenario_demon_knight.png[/img][/p][p]William had a rough life. Younger son of a lord, he got caught up in a succession crisis at 6. William was taken prisoner to be used as leverage to force a surrender. He survived and, by age 12, thanks to his talents was being trained as a knight. He received land as a dowry and rebuilt his family but it was brutally murdered in front of him. \n\n[color=#bcad8c]Lone Wolf:[/color] Start with William Marshal and indemonised knight with monstrous powers.\n[color=#bcad8c]Elite Few:[/color] Can never have more than 1 men in your roster.\n[color=#bcad8c]Avatar:[/color] If William dies, the campaign ends.[/p]";
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
		local background = this.new("scripts/skills/backgrounds/hedge_knight_background");
		
		//set the startign value 
		setStartValuesEx(bro, "hedge_knight_background");
		
		bro.getBackground().m.RawDescription = "A demon knight, anyone approaching him feels a sense of dread, you must face every challenge alone";
		bro.getBackground().buildDescription(true);
		bro.setName("William Marshal")	
		bro.setTitle("The Demon Knight");
				
		//trait
		bro.getSkills().add(this.new("scripts/skills/traits/player_character_trait"));
		bro.getSkills().add(this.new("scripts/skills/traits/indemonised_trait"));	
		bro.getSkills().add(this.new("scripts/skills/traits/iron_lungs_trait"));
			
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
	
/*
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
		this.World.Assets.updateLook(6);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList(["music/noble_02.ogg"], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.demon_knight_scenario_intro");
		}, null);
	}

	function onInit()
	{
		this.World.Assets.m.BrothersMax = 1;
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

