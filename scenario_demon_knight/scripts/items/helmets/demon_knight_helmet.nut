this.demon_knight_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.demon_knight";
		this.m.Name = "The Demon\'s Countenance";
		this.m.Description = "A helmet and facemask, showing the visage of a demon, imbued with dark energies.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = false;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.HideCharacterHead = true;
		this.m.HideCorpseHead = true;
		this.m.IsIndestructible = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 90000;
		this.m.Condition = 400.0;
		this.m.ConditionMax = 400.0;
		this.m.StaminaModifier = -15;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
	}

	
	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_demon_knight_helmet_" + variant;
		this.m.SpriteDamaged = "bust_demon_knight_helmet_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_demon_knight_helmet_" + variant + "_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/icon_demon_knight_helmet_" + variant + ".png";
	}		


});

