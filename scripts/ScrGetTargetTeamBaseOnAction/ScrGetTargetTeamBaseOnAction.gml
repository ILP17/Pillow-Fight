/**
 * @param {Struct.Action} _action
 * @param {Id.Instance} _turn_instance
 * @param {Array<Id.Instance>} _ally_team
 * @param {Array<Id.Instance>} _enemy_team
**/
function ScrGetTargetTeamBaseOnAction(_action, _turn_instance, _ally_team, _enemy_team) { 
    var _action_metadata = _action.GetMetadata();
    
    switch(_action_metadata.targetType) {
        case TargetType.Enemy:
            return _enemy_team;
        case TargetType.Team:
            return _ally_team;
        case TargetType.Self:
            return _turn_instance;
    }
}