function AllTargetStrategy() : TargetStrategy() constructor {
	IsTargetValid = function(_potential_target) {
		return _potential_target.IsTargetable();
	}
	
	SelectTargets = function(_main_valid_target_index, _target_team) {
		return __.validTargets;
	}
	
	DelayedActionTargetsCheck = function(_turn_context) {
        //initialize again to get new valid targets
        Initialize(_turn_context);
		return __.validTargets;
	}
}