this.demon_knight_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.demon_knight";
		this.m.Name = "The Demon\'s Armor";
		this.m.Description = "An armour worn by the strongest demons, made from the blood and bones of murdered souls and imbued with dark energies.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = false;
		this.m.ShowOnCharacter = true;
		this.m.IsIndestructible = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 90000;
		this.m.Condition = 400;
		this.m.ConditionMax = 400;
		this.m.StaminaModifier = -25;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
	}

	
	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_demon_knight_armor_body_" + variant;
		this.m.SpriteDamaged = "bust_demon_knight_armor_body_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_demon_knight_armor_body_" + variant + "_dead";
		this.m.IconLarge = "armor/inventory_demon_knight_armor_body_" + variant + ".png";
		this.m.Icon = "armor/icon_demon_knight_armor_body_" + variant + ".png";
	}	


});

