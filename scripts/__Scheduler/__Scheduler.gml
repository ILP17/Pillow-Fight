function ActionScheduler() constructor {
	__ = { };
    __.turn_actions = [];
	__.delayed_turn_actions = [];
	
	static __ConsumeDelayedAction = function(_delayed_action) {
		array_delete(
			__.delayed_turn_actions,
			array_get_index(__.delayed_turn_actions, _delayed_action),
			1
		);
	}
	
	static __FilterByBattleParticipant = function(_delayed_action, _index) {
		return _delayed_action.battleParticipant == __battle_participant_to_search_for;
	}
    
    static __AnyTurnActions = function() {
		return array_length(__.turn_actions) > 0;
	}
	
	/** 
     * @param {Struct.TurnAction} _turn_action
	**/
	static AddTurnAction = function(_turn_action) {
		array_push(__.turn_actions, _turn_action);
	}
	
	/** 
     * @return {Struct.TurnAction}
	**/
	static GetCurrentTurnAction = function() {
		if (!__AnyTurnActions()) {
			return new TurnAction();
		}
		
		return __.turn_actions[0];
	}
	
	static ProcessCurrentTurnAction = function() {
		if (!__AnyTurnActions()) {
			return;
		}
        
        var _action = array_first(__.turn_actions).action;
		
		_action.Run();
		
		if(_action.HasEnded()) {
			array_shift(__.turn_actions);
		}
	}
	
	static TrashCurrentTurnAction = function() {
		array_shift(__.turn_actions);
	}
	
	/**
     * @return {bool}
	**/
	static HasReadyTurnAction = function() {
		return __AnyTurnActions();
	}
	
	#region Delayed Action
	/**
     * @param {Struct.DelayedAction} _delayed_action
	**/
	static AddDelayedAction = function(_delayed_action) {
		array_push(__.delayed_turn_actions, _delayed_action);
	}
	
	/**
     * @param {Id.Instance} _battle_participant
	**/
	__battle_participant_to_search_for = noone;
	static TickDelayedActions = function(_battle_participant) {		
		__battle_participant_to_search_for = _battle_participant;
		
		var _delayed_turn_actions = array_filter(__.delayed_turn_actions, __FilterByBattleParticipant),
			_delayed_action;
		
		for(var i = 0; i < array_length(_delayed_turn_actions); i++) {
			_delayed_action = _delayed_turn_actions[i];
			if(_delayed_action.remainingTurns <= 0) {
				AddTurnAction(_delayed_action.turn_action);
				__ConsumeDelayedAction(_delayed_action);
				continue;
			}
			
			_delayed_action.remainingTurns --;
		}
	}
	
	/**
     * @param {Id.Instance} _battle_participant
	**/
	static RemoveDelayedActionsFor = function(_battle_participant) {		
		__battle_participant_to_search_for = _battle_participant;
		
		var _delayed_turn_actions = array_filter(__.delayed_turn_actions, __FilterByBattleParticipant),
			_delayed_action;
		
		for(var i = 0; i < array_length(_delayed_turn_actions); i++) {
			_delayed_action = _delayed_turn_actions[i];
			__ConsumeDelayedAction(_delayed_turn_actions[i]);
			continue;
		}
	}
	
	/**
     * @param {Id.Instance} _battle_participant
     * @return {bool}
	**/
	static HasDelayedActionFor = function(_battle_participant) {		
		__battle_participant_to_search_for = _battle_participant;
		
		var _turn_actions = array_filter(__.delayed_turn_actions, __FilterByBattleParticipant);
		
		return array_length(_turn_actions) > 0;
	}
	#endregion
}

/** 
 * @param {Id.Instance} _battle_participant 
 * @param {Struct.TurnAction} _turn_action 
 * @param {real} _turn_count
**/
function DelayedAction(_battle_participant, _turn_action, _turn_count) constructor {
	battleParticipant = _battle_participant;
	turn_action = _turn_action;
	remainingTurns = _turn_count;
}