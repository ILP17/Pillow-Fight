global.playerParty = [
	new ExamplePlayerCharacter({
		name: "Loser",
		class: global.classes.Rouge,
		level: 8 }),
	new ExamplePlayerCharacter({
		name: "Kartoffel",
		sprite: SprMage,
		class: global.classes.Mage,
		level: 7 }),
	new ExamplePlayerCharacter({
		name: "#1 Harpy Fan",
		class: global.classes.Warrior,
		level: 10 }),
	new ExamplePlayerCharacter({
		name: "Angel",
		sprite: SprHealer,
		class: global.classes.Angel,
		level: 8 })
];

global.enemyParty = [
	global.monsters.Weirdo,
	global.monsters.Weirdo,
	global.monsters.Abhorrence,
	global.monsters.SassyWitch,
	global.monsters.Killer,
	global.monsters.Killer
];

global.pillowCombatConfig.turnSortFunction = function(_bp1, _bp2) {
    return _bp2.GetStat(SP_STAT) - _bp1.GetStat(SP_STAT);
};

global.pillowCombatConfig.battleDecidedFunction = function(_victors) {
    if(!auto_run){
        return;
    }
    game_restart();
}