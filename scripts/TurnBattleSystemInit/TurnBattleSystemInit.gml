#macro MAX_LEVEL 50
#macro HP_STAT "hp"
#macro AT_STAT "at"
#macro DF_STAT "df"
#macro MAG_STAT "mag"
#macro SP_STAT "sp"

enum BattleStates {
	NA,			// Pause
	PreBattle,	// Intro Animation
	PreTurn,	// Get Action and Target
	Turn,		// Turn cycle
	PostTurn,	// Advance Turn
	PostBattle	// Exp Award Animation
}

enum BattleVictors {
	Alpha,
	Beta
}

enum EffectType {
	Damage,
	Heal,
	Revive,
	Buff
}

enum TargetType {
	Enemy,
	Team,
	Self
}

global.actionMetadata = {};

// Fill this with character data
global.playerParty = [];

// Fill this with character data
global.enemyParty = [];

#region Action Metadata
global.actionMetadata[$ nameof(BasicHitAction)] = new ActionMetadata();
global.actionMetadata[$ nameof(BasicHealAction)] = new ActionMetadata({
	targetType: TargetType.Team,
	effectType: EffectType.Heal,
	targetStrategy: HealTargetStrategy});
global.actionMetadata[$ nameof(BasicResurrectionAction)] = new ActionMetadata({
	targetType: TargetType.Team,
	effectType: EffectType.Revive,
	targetStrategy: ReviveTargetStrategy});
global.actionMetadata[$ nameof(BasicLightningAction)] = new ActionMetadata({
	targetStrategy: AdjacentTargetStrategy});
global.actionMetadata[$ nameof(BasicExplosionAction)] = new ActionMetadata({
	targetStrategy: AllTargetStrategy});
global.actionMetadata[$ nameof(BasicStrengthBuffAction)] = new ActionMetadata({
	targetType: TargetType.Team,
	effectType: EffectType.Buff,
	targetStrategy: BuffTargetStrategy,
	buffs: [ValorBuff]});
global.actionMetadata[$ nameof(BasicDefenseBuffAction)] = new ActionMetadata({
	targetType: TargetType.Team,
	effectType: EffectType.Buff,
	targetStrategy: BuffTargetStrategy,
	buffs: [ProtectionBuff]});
global.actionMetadata[$ nameof(BasicSpeedDebuffAction)] = new ActionMetadata({
	effectType: EffectType.Buff,
	targetStrategy: BuffTargetStrategy,
	buffs: [StaggerBuff]});
global.actionMetadata[$ nameof(BasicMultiTurnAction)] = new ActionMetadata();
global.actionMetadata[$ nameof(BasicMultiTurnAttackAction)] = new ActionMetadata();
#endregion

/**
	@param {Function} _action
	@return {Struct.ActionMetadata}
*/
function ScrActionGetMetadata(_action) {
	return global.actionMetadata[$ script_get_name(_action)];
}

/**
	@param {Struct.Action} _action
	@return {Struct.ActionMetadata}
*/
function ScrActionGetMetadataFromInstance(_action) {
	return global.actionMetadata[$ instanceof(_action)];
}