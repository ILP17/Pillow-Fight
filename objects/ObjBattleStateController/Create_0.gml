var _self = self;
__ = {};
with (__) {
    initialize = false
	scheduler = new Scheduler();
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
            _enemy_team;
        
        if(array_contains(__.alphaTeam, _turn_instance)) {
            _ally_team = __.alphaTeam;
            _enemy_team = __.betaTeam;
        } else if(array_contains(__.betaTeam, _turn_instance)) {
            _ally_team = __.betaTeam;
            _enemy_team = __.alphaTeam;
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

GetBattleState = function() {
	return __.battleState;
}

TryBeginBattle = function() {
	if(GetBattleState() != BattleStates.NA) {
		return;
	}

	__.battleState = BattleStates.PreBattle;
}

/**
	@param {Id.Instance} _battle_participant
	@param {Struct.Action} _action
	@param {real} _turn_count the number of turns to wait, 0 will mean the very next turn
*/
AddDelayedAction = function(_battle_participant, _action, _turn_count) {
	__.scheduler.AddDelayedAction(new DelayedAction(_battle_participant, _action, _turn_count));
}

/**
	@param {Id.Instance} _battle_participant
	@param {Struct.Action} _action
	@param {real} _turn_count the number of turns to wait, 0 will mean the very next turn
*/
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
	
	var _turn_instance = __.currentTurnOrder[__.currentTurnIndex];
	
	if(__.SkipTurn(!_turn_instance.CanAct())) {
		return;
	}
    
    var _turn_context = __.SetupTurnContext(_turn_instance);
	
	__.scheduler.TickDelayedActions(_turn_instance);
	
	if(__.scheduler.HasReadyAction()) {
		var _action = __.scheduler.GetCurrentAction();
        
        _turn_context.SetAction(_action);
        
		var _new_targets = _turn_instance.UpdateTargets(_turn_context);
		
		if(array_length(_new_targets) == 0) {
			_action.Fail();
			__.scheduler.TrashCurrentAction();
			__.battleState = BattleStates.PostTurn;
			return;
		}
		
		_action.Initialize([_turn_instance], _new_targets);
		
		__.battleState = BattleStates.Turn;
		return;
	}
	
	if(__.SkipTurn(__.scheduler.HasDelayedActionFor(_turn_instance))) {
		return;
	}
    
    var _turn_action = _turn_instance.GetAction(_turn_context);
	
	if(!is_undefined(_turn_action)) {
        var _action = _turn_action.action;
        _action.Initialize(_turn_action.attackers, _turn_action.targets);
     	__.scheduler.AddAction(_turn_context.GetAction());
     	__.battleState = BattleStates.Turn;
    }
}

Turn = function() {
	__.scheduler.ProcessCurrentAction();
	
	if(!__.scheduler.HasReadyAction()) {
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