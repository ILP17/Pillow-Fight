enum BattleStates {
	NA,			 // Pause
	PreBattle,	    // Intro Animation
	PreTurn,	  // Get Action and Target
	Turn,		    // Turn cycle
	ExecuteAction, // Turn cycle
	PostTurn,	// Advance Turn
	PostBattle	// Exp Award Animation
}

enum BattleTeams {
    NA,
	Alpha,
	Beta
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
	    case BattleStates.ExecuteAction: return "ExecuteAction";
	    case BattleStates.PostTurn: return "PostTurn";
	    case BattleStates.PostBattle: return "PostBattle";
    }
}

static_get(new Action());