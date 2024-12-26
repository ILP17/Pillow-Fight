global.monsters = {
	Weirdo: new ExampleMonsterCharacter(
		{ name: "Weirdo", sprite: SprMonster, stats: new Stats({ hp: 40, at: 30, df: 2, sp: 3 }) }),
	Killer: new ExampleMonsterCharacter(
		{ name: "Killer", sprite: SprAngryMonster, stats: new Stats({ hp: 25, at: 45, df: 3, sp: 2 }) }),
	Abhorrence: new ExampleMonsterCharacter(
		{ name: "Abhorrence", sprite: SprAbhorrence, isBoss: true, stats: new Stats({ hp: 175, at: 60, df: 5, sp: 1 }) }),
	SassyWitch: new ExampleMonsterCharacter({
		name: "Sassy Witch",
		sprite: SprSassyWitch,
		stats: new Stats({ hp: 70, at: 35, df: 3, sp: 5 }),
		actions: [BasicHitAction, BasicStrengthBuffAction, BasicSpeedDebuffAction],
		strategies: [BasicActionStrategy, BuffActionStrategy] })
};

global.classes = {
	Rouge: new Class({
		baseStats: new Stats({ hp: 12, at: 5, df: 1, sp: 5 }),
		maxStats: new Stats({ hp: 275, at: 175, df: 75, sp: 100 })}),
	Warrior: new Class({
		baseStats: new Stats({ hp: 15, at: 5, df: 5, sp: 3 }),
		maxStats: new Stats({ hp: 350, at: 225, df: 95, sp: 75 })}),
	Mage: new Class({
		baseStats: new Stats({ hp: 10, at: 3, df: 1, sp: 3, mag: 1}),
		maxStats: new Stats({ hp: 250, at: 120, df: 75, sp: 85, mag: 140 }),
		actions: [BasicHitAction, BasicLightningAction, BasicExplosionAction, BasicDefenseBuffAction],
		strategies: [BasicActionStrategy, BuffActionStrategy]}),
	Angel: new Class({
		baseStats: new Stats({ hp: 10, at: 3, df: 1, sp: 4, mag: 1 }),
		maxStats: new Stats({ hp: 195, at: 100, df: 80, sp: 90, mag: 168 }),
		actions: [BasicHitAction, BasicHealAction, BasicResurrectionAction, BasicMultiTurnAction],
		strategies: [BasicActionStrategy, HealActionStrategy, ReviveActionStrategy]})
}