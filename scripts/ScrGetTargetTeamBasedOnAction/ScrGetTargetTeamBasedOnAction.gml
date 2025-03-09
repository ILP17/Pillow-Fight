/**
 * @param {Struct.Action} _action
 * @param {Struct.TurnContext} _turn_context
 * @return {Array<Id.Instance>}
**/
function ScrGetTargetTeamBasedOnAction(_action, _turn_context) { 
    var _action_metadata = _action.GetMetadata();
    
    switch(_action_metadata.targetType) {
        case TargetType.Enemy:
            return _turn_context.GetEnemyTeam();
        case TargetType.Team:
            return _turn_context.GetAllyTeam();
        case TargetType.Self:
            return [_turn_context.GetTurnInstance()];
    }
    
    throw ("Could not resolve potential targets.");
}