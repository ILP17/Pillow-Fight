function AdjacentTargetStrategy() : TargetStrategy() constructor {
	var _self = self;
	with(__) {
		TryAddAdjacentTarget = method(_self, function(_targets, _index, _valid_targets) {
			if(array_has_index(_valid_targets, _index) && _valid_targets[_index].IsTargetable()) {
				array_push(_targets, _valid_targets[_index]);
			}
		});
	}
	
	IsTargetValid = function(_potential_target) {
		return _potential_target.IsTargetable();
	}
	
    SelectTargets = function(_main_valid_target_index, _target_team) {
        var _targets = [],
            _valid_targets_length = array_length(__.validTargets);
        
        if(_valid_targets_length > 0) {
            var _main_target = __.validTargets[_main_valid_target_index];
            var _target_index = array_get_index(_target_team, _main_target);
            
            array_push(_targets, _target_team[_target_index]);
            
            __.TryAddAdjacentTarget(_targets, _target_index - 1, _target_team);
            __.TryAddAdjacentTarget(_targets, _target_index + 1, _target_team);
        }
        
        return _targets;
    } 
    
    DelayedActionTargetsCheck = function(_turn_context) {
        var _current_selected_targets = _turn_context.GetTurnAction().targets;
        var _valid = IsTargetValid(_current_selected_targets[0]);
        var _target_team = _turn_context.ResolveTargets();
        var _new_targets = _current_selected_targets;
        
        if(!_valid) {
            //initialize again to get new valid targets
            Initialize(_turn_context);
            var _new_valid_target_index = irandom(array_length(__.validTargets) - 1);
            _new_targets = SelectTargets(_new_valid_target_index, _target_team);
        } else {
            var _target_index = array_get_index(_target_team, _current_selected_targets[1]);
            if(array_length(_current_selected_targets) >= 2 && !IsTargetValid(_current_selected_targets[1])) {
                array_delete(_current_selected_targets, _target_index, 1);
            }
            _target_index = array_get_index(_target_team, _current_selected_targets[2]);
            if(array_length(_current_selected_targets) >= 3 && !IsTargetValid(_current_selected_targets[2])) {
                array_delete(_current_selected_targets, _target_index, 1);
            }
            _new_targets = _current_selected_targets;
        }
        
        return _new_targets;
    }
}