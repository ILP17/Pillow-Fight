function HealTargetStrategy() : TargetStrategy() constructor {
	var _self = self;
	with(__) {
		ValidTargetFilter = method(_self, function(_potential_target, _index) {
			return _potential_target.IsAlive() && _potential_target.GetHealthRatio() < 1;
		});
	}
	
	SelectTargets = function(_main_valid_target_index, _target_team) {
		var _targets = [];
		var _valid_targets_length = array_length(__.validTargets);
		
		if(_valid_targets_length > 0) {
            var _chosen_target = __.validTargets[0],
                _last_hp_ratio = _chosen_target.GetHealthRatio(),
                _potential_target;
            
            for(var i = 1; i < _valid_targets_length; i++) {
                _potential_target = __.validTargets[i];
                if(_potential_target.GetHealthRatio() < _last_hp_ratio) {
                    _chosen_target = _potential_target;
                    _last_hp_ratio = _chosen_target.GetHealthRatio();
                }
            }
            
            array_push(_targets, _chosen_target);
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
        }
        
        return _new_targets;
    }
}