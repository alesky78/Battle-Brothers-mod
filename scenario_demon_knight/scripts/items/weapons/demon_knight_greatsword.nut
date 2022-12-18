this.demon_knight_greatsword <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		StunChance = 0
	},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.demon_knight_greatsword";
		this.m.Name = "Demon Greatsword";
		this.m.Description = "The demon greatsword is a devastating weapons, have the flexibility of a sword but the impact of an axe.";
		this.m.Categories = "Sword, Two-Handed";
		this.m.IconLarge = "weapons/melee/demon_knight_greatsword_01.png";
		this.m.Icon = "weapons/melee/demon_knight_greatsword_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "demon_knight_greatsword_01";
		this.m.Value = 40000;
		this.m.ShieldDamage = 25;
		this.m.Condition = 200.0;
		this.m.ConditionMax = 200.0;
		this.m.StaminaModifier = -8;
		this.m.RegularDamage = 90;
		this.m.RegularDamageMax = 100;
		this.m.ArmorDamageMult = 1.5;
		this.m.DirectDamageMult = 0.4;
		this.m.ChanceToHitHead = 10;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skillToAdd = this.new("scripts/skills/actives/overhead_strike");
		skillToAdd.setStunChance(this.m.StunChance);
		this.addSkill(skillToAdd);
		this.addSkill(this.new("scripts/skills/actives/split"));
		this.addSkill(this.new("scripts/skills/actives/swing"));
		local skillToAdd = this.new("scripts/skills/actives/split_shield");
		skillToAdd.setFatigueCost(skillToAdd.getFatigueCostRaw() + 2);
		this.addSkill(skillToAdd);
	}

});

