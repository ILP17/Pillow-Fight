function AdjacentTargetStrategy() : TargetStrategy() constructor {
	var _self = self;
	with(__) {
		TryAddAdjacentTarget = method(_self, function(_targets, _index, _valid_targets) {
			if(ScrArrayContainsIndex(_valid_targets, _index) && _valid_targets[_index].IsTargetable()) {
				array_push(_targets, _valid_targets[_index]);
			}
		});
	}
	
	IsTargetValid = function(_potential_target) {
		return _potential_target.IsTargetable();
	}
	
    SelectTargets = function(_main_valid_target_index, _target_team, _action_metadata) {
        var _targets = [],
            _targets_length = array_length(__.validTargets);
        
        if(_targets_length == 0) {
            return _targets;
        }
        
        var _main_target = __.validTargets[_main_valid_target_index];
        var _target_index = array_get_index(_target_team, _main_target);
        
        array_push(_targets, _target_team[_target_index]);
        
        __.TryAddAdjacentTarget(_targets, _target_index - 1, _target_team);
        __.TryAddAdjacentTarget(_targets, _target_index + 1, _target_team);
        
        return _targets;
    } 
    
    /**
        This will check that the current targets are still valid and if not return a new target list
        This may return an empty list if no suitable targets are found
        @param {struct.Action} _action
        @param {struct.TurnContext} _turn_context
    */
    DelayedActionTargetsCheck = function(_action, _turn_context) {
        var _current_targets = _action.GetTargets();
        var _action_metadata = _action.GetMetadata();
        var _valid = IsTargetValid(_current_targets[0]);
        var _new_targets = _current_targets;
        var _targets = _turn_context.ResolveTargets(_action_metadata);
        
        if(!_valid) {
            _new_targets = GetTarget(_targets, _action_metadata);
        } else {
            var _target_index = array_get_index(_targets, _current_targets[1]);
            if(array_length(_current_targets) >= 2 && !IsTargetValid(_current_targets[1])) {
                array_delete(_current_targets, _target_index, 1);
            }
            _target_index = array_get_index(_targets, _current_targets[2]);
            if(array_length(_current_targets) >= 3 && !IsTargetValid(_current_targets[2])) {
                array_delete(_current_targets, _target_index, 1);
            }
            _new_targets = _current_targets;
        }
        
        return _new_targets;
    }
}