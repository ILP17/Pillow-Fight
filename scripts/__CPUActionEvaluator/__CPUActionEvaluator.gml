/**
	@param {Struct.Character} _character_data
*/
function CPUActionEvaluator(_character_data) : ActionEvaluator(_character_data) constructor {
	/**
		@return {bool}
	*/
	IsReady = function() {
		return true;
	}
	
	/**
		@param {Struct.TurnContext} _turn_context
		@return {Struct.Action}
	*/
	DetermineAction = function(_turn_context) {
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
	
		return _action;
	}
	
	/**
	 * @param {Struct.Action} _action
	 * @param {Struct.TurnContext} _turn_context
	 * @return {Array<Id.Instance>}
	*/
	SelectTargets = function(_action, _turn_context) {
		var _action_metadata = _action.GetMetadata();
		var _target_strategy = _action.CreateTargetStrategy();
		var _target_team = _turn_context.ResolveTargets(_action_metadata);
        
        _target_strategy.Initialize(_target_team);
        
		return _target_strategy.SelectTargets(
            irandom(array_length(_target_strategy.GetValidTargets()) - 1),
            _target_team,
            _action_metadata);
	}
	
	/**
		@param {Struct.Action} _action
		@param {Struct.TurnContext} _turn_context
		@return {Array<Id.Instance>}
	*/
	UpdateTargets = function(_action, _turn_context) {
		var _target_strategy = _action.CreateTargetStrategy();
		var _new_targets = _target_strategy.DelayedActionTargetsCheck(_action, _turn_context);
		
		return _new_targets;
	}
}