function ActionStepPrepare(_config) : ActionStep(_config) constructor {
    action = _config[$ "action"];
    turn_count = _config[$ "turn_count"];
    
    static Run = function() {
        if(finished) {
            return;
        }
        
        var _action = ObjActionProvider.GetAction(action);
        var _new_turn_action = new TurnAction(_action, attacker, victim);
        ObjBattleStateController.AddDelayedAction(turn_context.GetTurnInstance(), _new_turn_action, turn_count);
        
        finished = true;
    }
}