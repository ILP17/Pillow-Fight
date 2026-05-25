/**
 * @param {Struct.BattleParticipantData} _character_data
**/
function PlayerActionEvaluator(_character_data) : ActionEvaluator() constructor { 
	PRIVATE
    
    with(__) {
        character_data = _character_data;
        action = new NoAction();
        /**
         * @return {Struct.TargetStrategy}
        **/
        GetTargetStrategy = function(_action_metadata) {
            var _target_strategy = _action_metadata.GetData("targetStrategy", AnyTargetStrategy);
            return new _target_strategy();
        }
    }
    
    __SelectAction = function(_action) { __.action = _action; }
    
    Reset = function() {
        __.action = new NoAction();
    }
    
    /**
     * Tries to determine an action.
     * Returns an action if successful
     * Returns NoAction if no action has been determined
	 * @param {Struct.TurnContext} _turn_context
	 * @return {Struct.Action}
	**/
	TryDetermineAction = function(_turn_context) {
        var _character_data = __.character_data;
        
        if(!ObjUIControllerAction.IsShowing() && !ScrActionIsValid(__.action)) {
            ObjUIControllerAction.Show();
            ObjUIControllerAction.SetCharacter(_turn_context);
            ObjUIControllerAction.on_action_selected = __SelectAction;
            __.action = new NoAction();
        }
	
		return __.action;
	}
	
	/**
     * Tries to determine a set of targets.
     * Returns a list of instance if successful
     * Returns an empty list if no targets are selected
	 * @param {Struct.TurnContext} _turn_context
	 * @param {Struct.Action} _action
	 * @return {Array<Id.Instance>}
	**/
	TrySelectTargets = function(_turn_context, _action) {
        if(!ScrActionIsValid(_action)) {
            return [];
        }
        
        var _targets = [];
		var _target_strategy = __.GetTargetStrategy(_action.GetMetadata());
		var _target_team = ScrGetTargetTeamBasedOnAction(_action, _turn_context);
        
        _target_strategy.Initialize(_turn_context, _action);
        
        _targets = _target_strategy.SelectTargets(
            irandom(array_length(_target_strategy.GetValidTargets()) - 1),
            _target_team);
        
		return _targets;
	}
	
	/**
	 * @param {Struct.TurnContext} _turn_context
	 * @return {Array<Id.Instance>}
	**/
	UpdateTargets = function(_turn_context) {
        var _turn_action = _turn_context.GetTurnAction();
        var _target_strategy = __.GetTargetStrategy(_turn_action.action.GetMetadata());
        
        _target_strategy.Initialize(_turn_context);
        
		return _target_strategy.DelayedActionTargetsCheck(_turn_context);
	}
}