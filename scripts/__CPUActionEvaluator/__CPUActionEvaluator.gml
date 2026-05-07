/**
 * @param {Struct.BaseBattleParticipantData} _character_data
**/
function CPUActionEvaluator(_character_data) : ActionEvaluator() constructor { 
	__ = {};
    
    with(__) {
        characterData = _character_data;
        /**
         * @return {Struct.TargetStrategy}
        **/
        GetTargetStrategy = function(_action_metadata) {
            var _target_strategy = _action_metadata.GetData("targetStrategy", AnyTargetStrategy);
            return new _target_strategy();
        }
    }
    
    Reset = function() { }
    
    /**
     * Tries to determine an action.
     * Returns an action if successful
     * Returns NoAction if no action has been determined
	 * @param {Struct.TurnContext} _turn_context
	 * @return {Struct.Action}
	**/
	TryDetermineAction = function(_turn_context) {
        var _action = new NoAction();
        var _character_data = __.characterData;
        var _strat_count = _character_data.GetStrategyCount();
        var _weights = array_create(_character_data.GetActionCount(), 0);
        
		//Get weights
		var _action_strategy;
		for(var i = 0; i < _strat_count; i++) {
			_action_strategy = _character_data.GetStrategy(i);
			_weights = _action_strategy.EvaluateAction(_character_data, _turn_context, _weights);
		}
        
		var _total_weight = array_sum(_weights);
	
		//Get action
		var _chosen_weight = random(_total_weight),
			_min_weight = 0,
			_max_weight = 0;
        
		for(var i = 0; i < array_length(_weights); i++) {
			if(_weights[i] == 0) {
				continue;
			}
		
			_max_weight = _weights[i] + _min_weight;
		
			if(_chosen_weight >= _min_weight && _chosen_weight <= _max_weight) {
				_action = _character_data.GetAction(i);
				break;
			}
			_min_weight = _max_weight;
		}
	
		return _action;
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