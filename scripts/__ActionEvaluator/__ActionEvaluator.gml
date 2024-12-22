/**
	@param {struct.Character} _character_data
*/
function ActionEvaluator(_character_data) constructor {
	__ = {};
	with(__) {
		characterData = _character_data;
	}
	
	/**
		@return {bool}
	*/
	IsReady = function() {
		ScrEnforceImplementation(nameof(ActionEvaluator), nameof(IsReady));
	}
	
	/**
		@param {struct.TurnContext} _turn_context
		@return {struct.Action}
	*/
	DetermineAction = function(_turn_context) {
		ScrEnforceImplementation(nameof(ActionEvaluator), nameof(DetermineAction));
	}
	
	/**
		@param {struct.Action} _action
		@param {struct.TurnContext} _turn_context
		@return {Array<Id.Instance>}
	*/
	DetermineTargets = function(_action, _turn_context) {
		ScrEnforceImplementation(nameof(ActionEvaluator), nameof(DetermineTargets));
	}
	
	/**
		@param {struct.Action} _action
		@param {struct.TurnContext} _turn_context
		@return {Array<Id.Instance>}
	*/
	UpdateTargets = function(_action, _turn_context) {
		ScrEnforceImplementation(nameof(ActionEvaluator), nameof(UpdateTargets));
	}
}