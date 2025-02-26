/**
 * @param {Struct.BaseBattleParticipantData} _character_data
*/
function CPUActionEvaluator(_character_data) : ActionEvaluator() constructor { 
	__ = {};
    
    with(__) {
        characterData = _character_data;
        GetTargetStrategy = function(_action_metadata) {
            var _target_strategy = _action_metadata.GetData("targetStrategy", AnyTargetStrategy);
            return new _target_strategy();
        }
    }
    /**
     * Tries to determine an action.
     * Returns true if successful and action result should contain the action
     * Returns false if no action has been determined
	 * @param {Struct.TurnContext} _turn_context
	 * @param {Struct.ActionResult} _action_result
	 * @return {bool}
	**/
	TryDetermineAction = function(_turn_context, _action_result) {
        if(is_undefined(_action_result)) {
            ScrThrowArgumentUndefined(nameof(_action_result));
        }
        
        _action_result.SetAction(undefined);
        
		var _weights = undefined;
	
		//Get weights
		var _action_strategy;
		for(var i = 0; i < __.characterData.GetStrategyCount(); i++) {
			_action_strategy = __.characterData.GetStrategy(i);
			_weights = _action_strategy.EvaluateAction(__.characterData, _turn_context, _weights);
		}
	
		//Get total weight
		var _total_weight = 0;
		for(var i = 0; i < array_length(_weights); i++) {
			_total_weight += _weights[i];
		}
	
		//Get action
		var _chosen_weight = random(_total_weight),
			_min_weight = 0,
			_max_weight = 0,
			_action;
		for(var i = 0; i < array_length(_weights); i++) {
			if(_weights[i] == 0) {
				continue;
			}
		
			_max_weight = _weights[i] + _min_weight;
		
			if(_chosen_weight >= _min_weight && _chosen_weight <= _max_weight) {
				_action = __.characterData.GetAction(i);
				break;
			}
			_min_weight = _max_weight;
		}
        
        _action_result.SetAction(_action);
	
		return true;
	}
	
	/**
     * Tries to determine a set of targets.
     * Returns true if successful and action result should contain the action
     * Returns false if no action has been determined
	 * @param {Struct.TurnContext} _turn_context
	 * @param {Struct.TargetsResult} _targets_result
	 * @return {bool}
	**/
	TrySelectTargets = function(_turn_context, _targets_result) {
        if(is_undefined(_targets_result)) {
            ScrThrowArgumentUndefined(nameof(_targets_result));
        }
        
        _targets_result.SetTargets(undefined);
        
        var _action = _turn_context.GetAction();
		var _target_strategy = __.GetTargetStrategy(_action.GetMetadata());
		var _target_team = _turn_context.ResolveTargets();
        
        _target_strategy.Initialize(_turn_context);
        
        var _targets = _target_strategy.SelectTargets(
            irandom(array_length(_target_strategy.GetValidTargets()) - 1),
            _target_team);
        
        _targets_result.SetTargets(_targets);
        
		return true;
	}
	
	/**
	 * @param {Struct.TurnContext} _turn_context
	 * @return {Array<Id.Instance>}
	**/
	UpdateTargets = function(_turn_context) {
        var _action = _turn_context.GetAction();
        var _target_strategy = __.GetTargetStrategy(_action.GetMetadata());
        
        _target_strategy.Initialize(_turn_context);
        
		return _target_strategy.DelayedActionTargetsCheck(_turn_context);
	}
}