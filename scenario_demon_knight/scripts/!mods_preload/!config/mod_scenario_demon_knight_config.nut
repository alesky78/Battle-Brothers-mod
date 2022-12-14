local gt = this.getroottable();

/*
* define the new faction demon_slayer
* scripts/config/factions extend definitionse 
*/
gt.Const.FactionType.demon_slayer <- gt.Const.FactionType.len() - 2;
gt.Const.FactionType.COUNT = gt.Const.FactionType.COUNT + 1;

gt.Const.Faction.demon_slayer <- gt.Const.FactionType.len() - 2;
gt.Const.Faction.COUNT = gt.Const.FactionType.COUNT + 1;

/*
* define the traits of the new faction demon_slayer
* scripts/config/faction_traits extend definitions 
*/
gt.Const.FactionTrait.demon_slayer <- gt.Const.FactionTrait.len() - 1;
gt.Const.FactionTrait.Actions.push([
	"scripts/factions/actions/build_demon_slayer_camp_action"
]);


