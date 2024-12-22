function AllTargetStrategy() : TargetStrategy() constructor {
	IsTargetValid = function(_potential_target) {
		return _potential_target.IsTargetable();
	}
	
	SelectTargets = function(_main_valid_target_index, _target_team) {
		return __.validTargets;
	}
	
	/**
		This will check that the current targets are still valid and if not return a new target list
		This may return an empty list if no suitable targets are found
		@param {Struct.Action} _action
		@param {Struct.TurnContext} _turn_context
	*/
	DelayedActionTargetsCheck = function(_action, _turn_context) {
        //initialize again to get new valid targets
        Initialize(_action, _turn_context.ResolveTargets(_action.GetMetadata()));
		return __.validTargets;
	}
}