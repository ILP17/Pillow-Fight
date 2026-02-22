/**
 * Purpose of this state is to determine an action and set of targets
**/
function PreTurnBattleState(_turn_sort_function) constructor {
    __ = self[$ "__"] ?? { };
    __.turn_sort = _turn_sort_function;
    
    /**
     * @param {Struct.Battle} _battle
    **/
    static CreateTurnOrder = function(_battle) {
        array_sort(_battle.turn_order, __.turn_sort);
    }
    
    /**
     * @param {Struct.Battle} _battle
    **/
    static Process = function(_battle) {
        if(__.BattleHasVictor()) {
        	return;
        }
        
        var _turn_instance = _battle.GetCurrentTurnInstance();
        var _turn_context = __.SetupTurnContext(_turn_instance);
           
        var _turn_action = _turn_instance.GetAction(_turn_context);
        
        if(_turn_action.IsValid()) {
            _turn_context.SetTurnAction(_turn_action);
            
            _turn_action.action.Initialize(_turn_context);
         	__.scheduler.AddTurnAction(_turn_action);
         	__.battleState = BattleStates.Turn;
        }
    }
}