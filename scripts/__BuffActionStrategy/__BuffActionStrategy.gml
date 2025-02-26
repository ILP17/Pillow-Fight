function BuffActionStrategy() : ActionStrategy() constructor {
	/**
		@param {Struct.BaseBattleParticipantData} _character_data
		@param {Struct.TurnContext} _turn_context
		@param {Array<real>|undefined} _weights
		@return {Array<real>}
	*/
	EvaluateAction = function(_character_data, _turn_context, _weights = undefined) {
		var _action_count = _character_data.GetActionCount();
		_weights ??= __InitializeWeights(_action_count);
		var _should_buff = 0;
		
		//for each action
		for(var i = 0; i < _action_count; i++) {
			var _action = _character_data.GetAction(i);
            var _metadata = _action.GetMetadata();
			
			if(_metadata.effectType != EffectType.Buff) {
				continue;
			}
			
			_should_buff = 0;
            var _targets = ScrGetTargetTeamBasedOnAction(
                            _action,
                            _turn_context.GetTurnInstance(),
                            _turn_context.GetAllyTeam(),
                            _turn_context.GetEnemyTeam());
			
			//for each target
			for(var j = 0; j < array_length(_targets); j++) {
				var _target = _targets[j];
				
				if(!_target.IsAlive()) {
					continue;
				}
				
                var _buffs = _metadata.GetData("buffs", []);
                
				if(!_target.HasAnyBuff(_buffs)) {
					_should_buff = 1;
					break;
				}
			}
			
			if(_should_buff == 0) {
				_weights[i] = __AdjustWeight(_weights[i], -999);
			}
		}
		
		return _weights;
	}
}