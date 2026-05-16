function BuffTargetStrategy() : TargetStrategy() constructor {
	var _self = self;
    
    with(__) {
		action_metadata = new ActionMetadata(); 
	}
    
    /**
     * @param {Struct.TurnContext} _turn_context
     * @param {Struct.Action} _action
    **/
    Initialize = function(_turn_context, _action) {
        var _action_to_use = _action ?? _turn_context.GetTurnAction().action;
        __.action_metadata = _action_to_use.GetMetadata();
        __.AquireValidTargets(ScrGetTargetTeamBasedOnAction(_action_to_use, _turn_context));
    }
	
	IsTargetValid = function(_potential_target) {
        var _buffs = __.action_metadata.GetData("buffs", []);
		return _potential_target.IsTargetable() && !_potential_target.GetStatusManager().HasAnyStatus(_buffs);
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