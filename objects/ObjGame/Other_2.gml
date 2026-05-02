global.playerParty = ObjBattleEntityDataProvider.GetBattleEntities(["Loser", "Kartoffel", "No1HarpyFan", "Angel"]);
global.enemyParty = ObjBattleEntityDataProvider.GetBattleEntities(["Weirdo", "Weirdo", "Abhorrence", "SassyWitch", "Killer", "Killer"]);

global.pillowCombatConfig.turnSortFunction = function(_bp1, _bp2) {
    return _bp2.GetStat(SP_STAT) - _bp1.GetStat(SP_STAT);
};

global.pillowCombatConfig.battleDecidedFunction = function(_victors) {
    if(!auto_run){
        return;
    }
    game_restart();
}