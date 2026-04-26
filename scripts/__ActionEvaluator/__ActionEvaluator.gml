/**
 * Interface for determining an acton and a set of targets for a turn
**/
function ActionEvaluator() constructor {
    Reset = function() { }
    
	/**
     * Tries to determine an action.
     * Returns an action if successful
     * Returns NoAction if no action has been determined
	 * @param {Struct.TurnContext} _turn_context
	 * @return {Struct.Action}
	**/
	TryDetermineAction = function(_turn_context) {
		ScrThrowNotImplemented(nameof(ActionEvaluator), nameof(TryDetermineAction));
	}
	
	/**
     * Tries to determine a set of targets.
     * Returns a list of instance if successful
     * Returns an empty list if no targets are selected
	 * @param {Struct.TurnContext} _turn_context
	 * @param {Struct.Action} _action
	 * @return {Array<Id.Instance>}
	**/
	TrySelectTargets = function(_turn_context, _action) {
		ScrThrowNotImplemented(nameof(ActionEvaluator), nameof(TrySelectTargets));
	}
	
	/**
	 * @param {Struct.TurnContext} _turn_context
	 * @return {Array<Id.Instance>}
	**/
	UpdateTargets = function(_turn_context) {
		ScrThrowNotImplemented(nameof(ActionEvaluator), nameof(UpdateTargets));
	}
}