/**
	This is the "choice" of a battle participant containing the chosen action and selected targets
	@param {Struct.Action} _action
	@param {Array<Id.Instance>} _targets
*/
function TurnActionContext(_action, _targets) constructor {
	action = _action;
	targets = _targets;
}