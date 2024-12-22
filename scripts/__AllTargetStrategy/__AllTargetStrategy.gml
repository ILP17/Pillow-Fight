function AllTargetStrategy() : TargetStrategy() constructor {
	IsTargetValid = function(_potential_target) {
		return _potential_target.IsTargetable();
	}
	
	GetTarget = function(_target_team, _action_metadata) {
		var _valid_targets = array_filter(_target_team, __.ValidTargetFilter);
		var _valid_targets_length = array_length(_valid_targets);
		
		if(_valid_targets_length == 0) {
			return _valid_targets;
		}
		
		return _valid_targets;
	}
	
	/**
		This will check that the current targets are still valid and if not return a new target list
		This may return an empty list if no suitable targets are found
		@param {struct.Action} _action
		@param {struct.TurnContext} _turn_context
	*/
	DelayedActionTargetsCheck = function(_action, _turn_context) {
		var _action_metadata = _action.GetMetadata();
		return GetTarget(_turn_context.ResolveTargets(_action_metadata), _action_metadata);
	}
}