function TargetStrategy() constructor {
	var _self = self;
	__ = { };
	with(__) {
        validTargets = [];
        
        AquireValidTargets = method(_self, function(_target_team) {
            __.validTargets = array_filter(_target_team, __.ValidTargetFilter);
        });
        
		/**
		 * Used for target list filtering and should make use of the IsTargetValid method
		 * @param {Id.Instance} _potential_target
		 * @param {real} _index
		 * @return {bool}
		**/
		ValidTargetFilter = method(_self, function(_potential_target, _index) {
			return IsTargetValid(_potential_target);
		});
	}
    
    /**
     * @param {Struct.TurnContext} _turn_context
     * @param {Struct.Action} _action
    **/
    Initialize = function(_turn_context, _action) {
        var _action_to_use = _action ?? _turn_context.GetTurnAction().action;
        __.AquireValidTargets(ScrGetTargetTeamBasedOnAction(_action_to_use, _turn_context));
    }
    
    /**
     * @return {Array<Id.Instance>}
    **/
    GetValidTargets = function() {
        return __.validTargets;
    }
	
	/**
     * @param {Id.Instance} _potential_target
     * @return {bool}
	**/
	IsTargetValid = function(_potential_target) {
		ScrThrowNotImplemented(instanceof(self), nameof(IsTargetValid));
	}
    
    /**
     * Creates a list containing the main target and any addition targets per the rules of the target strategy
     * @param {Id.Instance} _main_valid_target_index
     * @param {Array<Id.Instance>} _target_team
     * @return {Array<Id.Instance>}
    **/
    SelectTargets = function(_main_valid_target_index, _target_team) {
        ScrThrowNotImplemented(instanceof(self), nameof(SelectTargets));
    }
	
	/**
	 * This will check that the current targets are still valid and if not return a new target list
	 * This may return an empty list if no suitable targets are found
	 * @param {Struct.TurnContext} _turn_context
	 * @return {Array<Id.Instance>}
	**/
	DelayedActionTargetsCheck = function(_turn_context) {
		ScrThrowNotImplemented(instanceof(self), nameof(DelayedActionTargetsCheck));
	}
}