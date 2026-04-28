var _self = self;
__ = {};
with (__) {
    initialize = false
	scheduler = new ActionScheduler();
	currentTurnIndex = 0;
	alphaTeam = [];
	betaTeam = [];
	currentTurnOrder = [];
	battleState = BattleStates.NA;

	SignalTurnEnd = method(_self, function() {
		__.battleState = BattleStates.PostTurn;
	});

	CheckTeamAlive = method(_self, function(_team) {
		for(var i = 0; i < array_length(_team); i++) {
			if(_team[i].IsAlive()) {
				return true;
			}
		}
	
		return false;
	});

	CreateTurnOrder = method(_self, function() {
		array_sort(__.currentTurnOrder, global.pillowCombatConfig.turnSortFunction);
	});

	SkipTurn = method(_self, function(_should_skip_turn) {
		if(!_should_skip_turn) {
			return false;
		}
	
		__.battleState = BattleStates.PostTurn;
		return true;
	});
    
    SetupTurnContext = method(_self, function(_turn_instance) {
        var _ally_team,
            _enemy_team,
            _team = GetTeam(_turn_instance);
        
        switch(_team) {
            case 0:
                _ally_team = __.alphaTeam;
                _enemy_team = __.betaTeam;
                break;
            case 1:
                _ally_team = __.betaTeam;
                _enemy_team = __.alphaTeam;
                break;
            default:
                throw("[SetupTurnContext] Current turn instance is not part of a team.");
        }
        
        return new TurnContext(_turn_instance, _ally_team, _enemy_team);
    });

	BattleHasVictor = method(_self, function() {
        var _victors = BattleVictors.NA;
        
		if(!__.CheckTeamAlive(__.alphaTeam)) {
			_victors = BattleVictors.Beta;
		} else if(!__.CheckTeamAlive(__.betaTeam)) {
			_victors = BattleVictors.Alpha;
		}
        
        if(_victors != BattleStates.NA) {
            global.pillowCombatConfig.battleDecidedFunction(_victors);
            __.battleState = BattleStates.PostBattle;
            return true;
        }
	
		return false;
	});
}

/**
 * @param {Id.Instance} _battle_participant
 * @return {real} Represents the team's index starting from 0. -1 means there is no team associated with the battle participant.
**/
GetTeam = function(_battle_participant) {
    if(array_contains(__.alphaTeam, _battle_participant)) {
        return 0;
    } else if(array_contains(__.betaTeam, _battle_participant)) {
        return 1;
    }
    
    return -1;
}

GetBattleState = function() {
	return __.battleState;
}

GetCurrentTurnInstance = function() {
    return __.currentTurnOrder[__.currentTurnIndex];
}

TryBeginBattle = function() {
	if(GetBattleState() != BattleStates.NA) {
		return;
	}

	__.battleState = BattleStates.PreBattle;
}

/** 
 * @param {Id.Instance} _battle_participant 
 * @param {Struct.TurnAction} _turn_action 
 * @param {real} _turn_count the number of turns to wait, 0 will mean the very next turn
**/
AddDelayedAction = function(_battle_participant, _turn_action, _turn_count) {
	__.scheduler.AddDelayedAction(new DelayedAction(_battle_participant, _turn_action, _turn_count));
}

/** 
 * @param {Id.Instance} _battle_participant
**/
OnBattleParticipantDeath = function(_battle_participant) {
	__.scheduler.RemoveDelayedActionsFor(_battle_participant);
}

/**
 * @param {Array<Id.Instance>} _alphaTeam
 * @param {Array<Id.Instance>} _betaTeam
**/
Initialize = function(_alphaTeam, _betaTeam) {
    __.alphaTeam = _alphaTeam;
    __.betaTeam = _betaTeam;
    __.initialize = true;
}

PreBattle = function() {
	__.currentTurnOrder = array_concat(__.alphaTeam, __.betaTeam);
	__.CreateTurnOrder();
	__.battleState = BattleStates.PreTurn;
}

PreTurn = function() {
	if(__.BattleHasVictor()) {
		return;
	}
	
	var _turn_instance = GetCurrentTurnInstance();
	
	if(__.SkipTurn(!_turn_instance.CanAct())) {
		return;
	}
    
    _turn_instance.Reset();
    
    __.battleState = BattleStates.Turn;
}

Turn = function() {
	if(__.BattleHasVictor()) {
		return;
	}
	
	var _turn_instance = GetCurrentTurnInstance();
	
	if(__.SkipTurn(!_turn_instance.CanAct())) {
		return;
	}
    
    var _turn_context = __.SetupTurnContext(_turn_instance);
	
	__.scheduler.TickDelayedActions(_turn_instance);
	
	if(__.scheduler.HasReadyTurnAction()) {
		var _turn_action = __.scheduler.GetCurrentTurnAction();
        _turn_context.SetTurnAction(_turn_action);
        
		var _new_targets = _turn_instance.UpdateTargets(_turn_context);
        _turn_action.targets = _new_targets;
		
		if(array_length(_new_targets) == 0) {
			_turn_action.action.Fail();
			__.scheduler.TrashCurrentTurnAction();
			__.battleState = BattleStates.PostTurn;
			return;
		}
		
        _turn_action.action.Initialize(_turn_context);
		__.battleState = BattleStates.ExecuteAction;
		return;
	}
	
	if(__.SkipTurn(__.scheduler.HasDelayedActionFor(_turn_instance))) {
		return;
	}
    
    var _turn_action = _turn_instance.GetAction(_turn_context);
    
    if(_turn_action.IsValid()) {
        show_debug_message($"{_turn_instance.GetCharacterData().name} prepares {instanceof(_turn_action.action)}");
        _turn_context.SetTurnAction(_turn_action);
        _turn_action.action.Initialize(_turn_context);
        __.scheduler.AddTurnAction(_turn_action);
        __.battleState = BattleStates.ExecuteAction;
    }
}

ExecuteAction = function() {
	__.scheduler.ProcessCurrentTurnAction();
	
	if(!__.scheduler.HasReadyTurnAction()) {
		__.battleState = BattleStates.PostTurn;
	}
}

PostTurn = function() {
    __.currentTurnOrder[__.currentTurnIndex].OnPostTurn();
	__.currentTurnIndex++;
	
	if(__.currentTurnIndex >= array_length(__.currentTurnOrder)) {
		__.CreateTurnOrder();
		__.currentTurnIndex = 0;
	}
	
	__.battleState = BattleStates.PreTurn;
}

PostBattle = function() { }