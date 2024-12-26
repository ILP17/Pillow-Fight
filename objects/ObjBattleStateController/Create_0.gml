var _self = self;
__ = {};
with (__) {
	scheduler = new Scheduler();
	currentTurnIndex = 0;
	alphaTeam = [];
	betaTeam = [];
	currentTurnOrder = [];
	battleState = BattleStates.NA;
	
	SortBySpeed = method(_self, function(_bp1, _bp2) {
		return _bp2.GetStat(SP_STAT) - _bp1.GetStat(SP_STAT);
	});

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
		array_sort(__.currentTurnOrder, __.SortBySpeed);
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
		if(!__.CheckTeamAlive(__.alphaTeam)) {
			OnBattleDecided(BattleVictors.Beta);
			__.battleState = BattleStates.PostBattle;
			return true;
		} else if(!__.CheckTeamAlive(__.betaTeam)) {
			OnBattleDecided(BattleVictors.Alpha);
			__.battleState = BattleStates.PostBattle;
			return true;
		}
	
		return false;
	});
}

OnBattleDecided = function(_victor_team) {}

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

PreBattle = function() {
	var _character_data,
		_battle_participant = noone,
		_battle_participant_object = global.pillowCombatConfig.battleParticipantObject,
		_base_y = room_height / 2,
		_player_x = room_width / 3,
		_monster_x = room_width * (2 / 3),
		_y = _base_y - array_length(global.playerParty) * 34 / 2;
	
	for(var i = 0; i < array_length(global.playerParty); i++) {
		_character_data = global.playerParty[i];
		_battle_participant = instance_create_layer(
			_player_x + irandom_range(-18, 18),
			_y + i * 34,
			layer,
			_battle_participant_object).Initialize(_character_data);
		array_push(__.alphaTeam, _battle_participant);
	}
	
	_y = _base_y - array_length(global.enemyParty) * 34 / 2;
	for(var i = 0; i < array_length(global.enemyParty); i++) {
		_character_data = global.enemyParty[i];
		
		var _real_monster_x = _monster_x + irandom_range(-18, 18);
		
		if(_character_data.isBoss) {
			_real_monster_x += 80;
		}
		
		_battle_participant = instance_create_layer(
			_real_monster_x,
			_y + i * 34,
			layer,
			_battle_participant_object).Initialize(_character_data);
		_battle_participant.image_xscale = -1;
		array_push(__.betaTeam, _battle_participant);
	}
	
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
	
	if(_turn_instance.EvaluateActionAndSelectedTargets(_turn_context)) {
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
	__.currentTurnOrder[__.currentTurnIndex].DecayBuffs();
	__.currentTurnIndex++;
	
	if(__.currentTurnIndex >= array_length(__.currentTurnOrder)) {
		__.CreateTurnOrder();
		__.currentTurnIndex = 0;
	}
	
	__.battleState = BattleStates.PreTurn;
}

PostBattle = function() {
}