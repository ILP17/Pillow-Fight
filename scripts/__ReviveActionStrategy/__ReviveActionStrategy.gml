function ReviveActionStrategy() : ActionStrategy() constructor {
	/**
	 * @param {Struct.BattleParticipantData} _character_data
	 * @param {Struct.TurnContext} _turn_context
	 * @param {Array<real>} _weights
	 * @return {Array<real>}
	**/
	EvaluateAction = function(_character_data, _turn_context, _weights) {
		var _action_count = _character_data.GetActionCount();
		var _should_heal = 0;
		
		//for each action
		for(var i = 0; i < _action_count; i++) {
            var _action = _character_data.GetAction(i);
            var _metadata = _action.GetMetadata();
			
			if(_metadata.effectType != EffectType.Revive) {
				continue;
			}
			
			_should_heal = 0;
            var _targets = ScrGetTargetTeamBasedOnAction(_action, _turn_context);
			
			//for each target
			for(var j = 0; j < array_length(_targets); j++) {
				var _target = _targets[j];
				
				if(!_target.IsAlive()) {
					_should_heal = 1;
					break;
				}
			}
			
			switch(_should_heal) {
				case 0:
					_weights[i] = __.AdjustWeight(_weights[i], -999);
					break;
				case 1:
					_weights[i] = __.AdjustWeight(_weights[i], 100);
					break;
			}
		}
		
		return _weights;
	}
}