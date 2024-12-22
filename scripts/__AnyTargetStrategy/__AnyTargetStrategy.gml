function AnyTargetStrategy() : TargetStrategy() constructor {
	IsTargetValid = function(_potential_target) {
		return _potential_target.IsTargetable();
	}
	
	SelectTargets = function(_main_valid_target_index, _target_team) {
		var _targets = [];
		var _valid_targets_length = array_length(__.validTargets);
		
		if(_valid_targets_length > 0) {
			array_push(_targets, __.validTargets[_main_valid_target_index]);
		}
        
		return _targets;
	}
	
	/**
		This will check that the current targets are still valid and if not return a new target list
		This may return an empty list if no suitable targets are found
		@param {Struct.Action} _action
		@param {Struct.TurnContext} _turn_context
	*/
	DelayedActionTargetsCheck = function(_action, _turn_context) {
		var _current_selected_targets = _action.GetTargets();
		var _valid = IsTargetValid(_current_selected_targets[0]);
        var _action_metadata = _action.GetMetadata();
		var _target_team = _turn_context.ResolveTargets(_action_metadata);
        var _new_targets = _current_selected_targets;
		
		if(!_valid) {
            //initialize again to get new valid targets
            Initialize(_action, _target_team);
            var _new_valid_target_index = irandom(array_length(__.validTargets - 1));
            
			_new_targets = SelectTargets(_new_valid_target_index, _target_team);
		}
		
		return _new_targets;
	}
}