function BasicActionStrategy() : ActionStrategy() constructor {
	/**
	 * @param {Struct.BaseBattleParticipantData} _character_data
	 * @param {Struct.TurnContext} _turn_context
	 * @param {Array<real>} _weights
	 * @return {Array<real>}
	**/
	EvaluateAction = function(_character_data, _turn_context, _weights) {
		var _action_count = _character_data.GetActionCount();
		
		for(var i = 0; i < _action_count; i++) {
			_weights[i] = __.AdjustWeight(_weights[i], 10);
		}
		
		return _weights;
	}
}