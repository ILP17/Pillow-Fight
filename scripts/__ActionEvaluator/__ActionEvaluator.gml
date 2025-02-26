/**
 * Interface for determining an acton and a set of targets for a turn
**/
function ActionEvaluator() constructor {
	/**
     * Tries to determine an action.
     * Returns true if successful and action result should contain the action
     * Returns false if no action has been determined
	 * @param {Struct.TurnContext} _turn_context
	 * @param {Struct.ActionResult} _action_result
	 * @return {bool}
	**/
	TryDetermineAction = function(_turn_context, _action_result) {
		ScrThrowNotImplemented(nameof(ActionEvaluator), nameof(TryDetermineAction));
	}
	
	/**
     * Tries to determine a set of targets.
     * Returns true if successful and action result should contain the action
     * Returns false if no action has been determined
	 * @param {Struct.TurnContext} _turn_context
	 * @param {Struct.TargetsResult} _targets_result
	 * @return {bool}
	**/
	TrySelectTargets = function(_turn_context, _targets_result) {
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

function ActionResult() constructor {
    __ = {
        action: undefined
    }
    
    /**
     * @return {Struct.Action}
    **/
    static GetAction = function() {
        return __.action;
    }
    
    /**
     * @param {Struct.Action,undefined} _action
    **/
    static SetAction = function(_action) {
        __.action = _action;
    }
}

function TargetsResult() constructor {
    __ = {
        targets: undefined
    }
    
    /**
     * @return {Array<Id.Instance>}
    **/
    static GetTargets = function() {
        return __.targets;
    }
    
    /**
     * @param {Array<Id.Instance>,undefined} _targets
    **/
    static SetTargets = function(_targets) {
         __.targets = _targets;
    }
}