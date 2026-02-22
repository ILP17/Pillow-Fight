enum BattleStates {
	NA,			// Pause
	PreBattle,	// Intro Animation
	PreTurn,	// Get Action and Target
	Turn,		// Turn cycle
	PostTurn,	// Advance Turn
	PostBattle	// Exp Award Animation
}

enum BattleVictors {
    NA,
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

function BattleStatesToString(_battle_state) {
	switch(_battle_state) {
        case BattleStates.NA: return "NA";
	    case BattleStates.PreBattle: return "PreBattle";
	    case BattleStates.PreTurn:	return "PreTurn";
	    case BattleStates.Turn: return "Turn";
	    case BattleStates.PostTurn: return "PostTurn";
	    case BattleStates.PostBattle: return "PostBattle";
    }
}

/**
 * @param {String} _action_name
 * @param {Struct.ActionMetadata} _action_metadata
**/
function ScrRegisterActionMetadata(_action_name, _action_metadata) {
	global.actionMetadata[$ _action_name] = _action_metadata;
}

/**
 * @param {Struct.Action} _action
 * @return {Struct.ActionMetadata}
**/
function ScrActionGetMetadataFromInstance(_action) {
	return global.actionMetadata[$ instanceof(_action)] ?? new ActionMetadata();
}

static_get(new Action());