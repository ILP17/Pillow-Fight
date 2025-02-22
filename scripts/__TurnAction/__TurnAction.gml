/**
 * This holds the data for what action and targets are selected for a turn 
 * @param {Struct.Action} _action
 * @param {Array<Id.Instance>} _attackers
 * @param {Array<Id.Instance>} _targets
**/
function TurnAction(_action, _attackers, _targets) constructor {
    action = _action ?? ScrThrowArgumentUndefined(nameof(_action));
    attackers = _attackers ?? ScrThrowArgumentUndefined(nameof(_attackers));
    targets = _targets ?? ScrThrowArgumentUndefined(nameof(_targets));
}