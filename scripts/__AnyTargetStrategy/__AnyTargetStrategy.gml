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
	
	DelayedActionTargetsCheck = function(_turn_context) {
		var _current_selected_targets = _turn_context.GetTurnAction().targets;
		var _valid = IsTargetValid(array_first(_current_selected_targets));
		var _target_team = _turn_context.ResolveTargets();
        var _new_targets = _current_selected_targets;
		
		if(!_valid) {
            //initialize again to get new valid targets
            Initialize(_turn_context);
            var _new_valid_target_index = irandom(array_length(__.validTargets) - 1);
            
			_new_targets = SelectTargets(_new_valid_target_index, _target_team);
		}
        
        show_message($"{_new_targets[0].__.characterData.name}, hp={_new_targets[0].__.health}")
		
		return _new_targets;
	}
}