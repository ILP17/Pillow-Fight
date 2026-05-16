var _self = self;
__ = {};
with (__) {
    initialize = false
	scheduler = new ActionScheduler();
    turn_context = new TurnContext(noone, [], []);
	currentTurnIndex = 0;
	alphaTeam = [];
	betaTeam = [];
	currentTurnOrder = [];
	battleState = BattleStates.NA;
    end_turn = false;

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
            case BattleTeams.Alpha:
                _ally_team = __.alphaTeam;
                _enemy_team = __.betaTeam;
                break;
            case BattleTeams.Beta:
                _ally_team = __.betaTeam;
                _enemy_team = __.alphaTeam;
                break;
            default:
                throw("[SetupTurnContext] Current turn instance is not part of a team.");
        }
        
        return new TurnContext(_turn_instance, _ally_team, _enemy_team);
    });

	BattleHasVictor = method(_self, function() {
        var _victors = BattleTeams.NA;
        
		if(!__.CheckTeamAlive(__.alphaTeam)) {
			_victors = BattleTeams.Beta;
		} else if(!__.CheckTeamAlive(__.betaTeam)) {
			_victors = BattleTeams.Alpha;
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
        return BattleTeams.Alpha;
    } else if(array_contains(__.betaTeam, _battle_participant)) {
        return BattleTeams.Beta;
    }
    
    return BattleTeams.NA;
}

GetBattleState = function() { return __.battleState; }

/**
 * @return {Id.Instance}
**/
GetCurrentTurnInstance = function() { return __.currentTurnOrder[__.currentTurnIndex]; }

/**
 * @return {Array<Id.Instance>}
**/
GetTurnOrder = function() { return __.currentTurnOrder; }

MoveToNextTurnInstance = function() {
    var _prev_turn_index = __.currentTurnIndex;
    
    __.currentTurnIndex = (__.currentTurnIndex + 1) % array_length(__.currentTurnOrder);
    
    if(__.currentTurnIndex < _prev_turn_index) {
        if(ObjOptionsProvider.GetOption(OPTION_USE_TEAM_ENERGY, false)) { global.team_energy = global.max_team_energy; }
		__.CreateTurnOrder();
	}
    
    return __.currentTurnOrder[__.currentTurnIndex];
}

TryBeginBattle = function() {
	if(GetBattleState() != BattleStates.NA) {
		return;
	}
    
	__.battleState = BattleStates.PreBattle;
    
    instance_create_depth(0, 0, depth, ObjBattleHUD).SetUp(array_concat(__.alphaTeam, __.betaTeam));
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
    var _turn_instance = GetCurrentTurnInstance();
	
    if(__.BattleHasVictor() || __.SkipTurn(!_turn_instance.CanAct())) {
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
    
    __.turn_context = __.SetupTurnContext(_turn_instance);
	
	__.scheduler.TickDelayedActions(_turn_instance);
	
	if(__.scheduler.HasReadyTurnAction()) {
		var _turn_action = __.scheduler.GetCurrentTurnAction();
        __.turn_context.SetTurnAction(_turn_action);
        _turn_instance.InitializeAction(__.turn_context, _turn_action.action);
        
		var _new_targets = _turn_instance.UpdateTargets(__.turn_context);
        _turn_action.targets = _new_targets;
		
		if(array_length(_new_targets) == 0) {
			_turn_action.action.Fail();
			__.scheduler.TrashCurrentTurnAction();
			__.battleState = BattleStates.PostTurn;
			return;
		}
		
		__.battleState = BattleStates.ExecuteAction;
		return;
	}
	
	if(__.SkipTurn(__.scheduler.HasDelayedActionFor(_turn_instance))) {
		return;
	}
    
    var _turn_action = _turn_instance.GetAction(__.turn_context);
    
    if(_turn_action.IsValid()) {
        show_debug_message($"{_turn_instance.GetCharacterData().name} prepares {instanceof(_turn_action.action)}");
        __.turn_context.SetTurnAction(_turn_action);
        _turn_instance.InitializeAction(__.turn_context, _turn_action.action);
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
    var _turn_instance = GetCurrentTurnInstance();
    var _action = __.turn_context.GetTurnAction().action;
    var _action_end_turn = is_instanceof(_action, NoAction) ? false : _action.GetMetadata().GetData("endTurn", false);
    
    if(_turn_instance.IsPlayer() && ObjOptionsProvider.GetOption(OPTION_USE_TEAM_ENERGY, false) && global.team_energy == 0) {
        _turn_instance.OnPostTurn();
        var _instance = MoveToNextTurnInstance();
        while(_instance.IsPlayer()) {
            _instance = MoveToNextTurnInstance();
        }
        ToPreTurn();
        return;
    }
    
    if(_turn_instance.IsPlayer() && _turn_instance.CanAct() && !__.end_turn && !_action_end_turn) {
        __.battleState = BattleStates.Turn;
        return;
    }
    
	_turn_instance.OnPostTurn();
    
    MoveToNextTurnInstance();
	ToPreTurn();
}

PostBattle = function() { }

EndTurn = function() {
    __.battleState = BattleStates.PostTurn;
    __.end_turn = true;
}

ToPreTurn = function() {
    __.battleState = BattleStates.PreTurn;
    __.end_turn = false;
}