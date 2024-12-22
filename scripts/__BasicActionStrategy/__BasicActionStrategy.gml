function BasicActionStrategy() : ActionStrategy() constructor {
	/**
		@param {Struct.Character} _character_data
		@param {Struct.TurnContext} _turn_context
		@param {Array<real>|undefined} _weights
		@return {Array<real>}
	*/
	EvaluateAction = function(_character_data, _turn_context, _weights = undefined) {
		var _action_count = _character_data.GetActionCount();
		_weights ??= __InitializeWeights(_action_count);
		
		for(var i = 0; i < _action_count; i++) {
			_weights[i] = __AdjustWeight(_weights[i], 10);
		}
		
		return _weights;
	}
}