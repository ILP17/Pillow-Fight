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

ScrRegisterActionMetadata(nameof(BasicHitAction), new ActionMetadata());
ScrRegisterActionMetadata(nameof(BasicHealAction), new ActionMetadata({
	targetType: TargetType.Team,
	effectType: EffectType.Heal,
	targetStrategy: HealTargetStrategy}));
ScrRegisterActionMetadata(nameof(BasicResurrectionAction), new ActionMetadata({
	targetType: TargetType.Team,
	effectType: EffectType.Revive,
	targetStrategy: ReviveTargetStrategy}));
ScrRegisterActionMetadata(nameof(BasicLightningAction), new ActionMetadata({
	targetStrategy: AdjacentTargetStrategy}));
ScrRegisterActionMetadata(nameof(BasicExplosionAction), new ActionMetadata({
	targetStrategy: AllTargetStrategy}));
ScrRegisterActionMetadata(nameof(BasicStrengthBuffAction), new ActionMetadata({
	targetType: TargetType.Team,
	effectType: EffectType.Buff,
	targetStrategy: BuffTargetStrategy,
	buffs: [ValorBuff]}));
ScrRegisterActionMetadata(nameof(BasicDefenseBuffAction), new ActionMetadata({
	targetType: TargetType.Team,
	effectType: EffectType.Buff,
	targetStrategy: BuffTargetStrategy,
	buffs: [ProtectionBuff]}));
ScrRegisterActionMetadata(nameof(BasicSpeedDebuffAction), new ActionMetadata({
	effectType: EffectType.Buff,
	targetStrategy: BuffTargetStrategy,
	buffs: [StaggerBuff]}));
ScrRegisterActionMetadata(nameof(BasicMultiTurnAction), new ActionMetadata());
ScrRegisterActionMetadata(nameof(BasicMultiTurnAttackAction), new ActionMetadata());

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