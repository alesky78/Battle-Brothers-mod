local gt = this.getroottable();

/*
* define the new faction demon_slayer
* scripts/config/factions
*/
gt.Const.FactionType.demon_slayer <- gt.Const.FactionType.len() - 2;
gt.Const.FactionType.COUNT = gt.Const.FactionType.COUNT + 1;

gt.Const.Faction.demon_slayer <- gt.Const.FactionType.len() - 2;
gt.Const.Faction.COUNT = gt.Const.FactionType.COUNT + 1;

/*
* define the traits of the new faction demon_slayer
* scripts/config/faction_traits
*/
gt.Const.FactionTrait.demon_slayer <- gt.Const.FactionTrait.len() - 1;
gt.Const.FactionTrait.Actions.push([
	"scripts/factions/actions/build_demon_slayer_camp_action",
	"scripts/factions/actions/defend_demon_slayer_action"
]);

/*
* define an alliances bewteen demon_slayer, Civilian and NobleHouse
* scripts/config/factions
*/
local alliance = null;
alliance = gt.Const.FactionAlliance[gt.Const.Faction.Civilian];
alliance.push(gt.Const.Faction.demon_slayer);
alliance = gt.Const.FactionAlliance[gt.Const.Faction.NobleHouse];
alliance.push(gt.Const.Faction.demon_slayer);	

local demon_slayer_alliance = [gt.Const.Faction.demon_slayer,gt.Const.Faction.Civilian,gt.Const.Faction.NobleHouse];
gt.Const.FactionAlliance.push(demon_slayer_alliance);	

