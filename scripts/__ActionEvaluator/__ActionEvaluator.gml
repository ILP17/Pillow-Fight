/**
 * @param {Struct.Character} _character_data
*/
function ActionEvaluator(_character_data) constructor {
	__ = { };
    
	with(__) {
		characterData = _character_data;
	}
	
	/**
	 * @return {bool}
	*/
	IsReady = function() {
		ScrEnforceImplementation(nameof(ActionEvaluator), nameof(IsReady));
	}
	
	/**
	 * @param {Struct.TurnContext} _turn_context
	 * @return {Struct.Action}
	*/
	DetermineAction = function(_turn_context) {
		ScrEnforceImplementation(nameof(ActionEvaluator), nameof(DetermineAction));
	}
	
	/**
	 * @param {Struct.TurnContext} _turn_context
	 * @return {Array<Id.Instance>}
	*/
	SelectTargets = function(_turn_context) {
		ScrEnforceImplementation(nameof(ActionEvaluator), nameof(SelectTargets));
	}
	
	/**
	 * @param {Struct.TurnContext} _turn_context
	 * @return {Array<Id.Instance>}
	*/
	UpdateTargets = function(_turn_context) {
		ScrEnforceImplementation(nameof(ActionEvaluator), nameof(UpdateTargets));
	}
}