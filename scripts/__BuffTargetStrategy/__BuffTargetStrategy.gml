function BuffTargetStrategy() : TargetStrategy() constructor {
	var _self = self;
    
    with(__) {
		actionMetadata = undefined; 
	}
    
    /**
     * @param {Struct.TurnContext} _turn_context
    **/
    Initialize = function(_turn_context) {
        __.actionMetadata = _turn_context.GetAction().GetMetadata();
        __.AquireValidTargets(_turn_context.ResolveTargets());
    }
	
	IsTargetValid = function(_potential_target) {
		return _potential_target.IsTargetable() && !_potential_target.HasAnyBuff(__.actionMetadata.buffs);
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
        var _action = _turn_context.GetAction();
		var _current_selected_targets = _action.GetTargets();
		var _valid = IsTargetValid(_current_targets[0]);
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