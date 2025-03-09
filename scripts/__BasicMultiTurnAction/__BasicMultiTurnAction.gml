function BasicMultiTurnAction() : Action() constructor {
	__state = 0;
	__z = 0;
	__zSpeed = -12;
	__zGravity = 1;
	__part_system = undefined;
	
	Run = function() {
        var _turn_action = __.turn_context.GetTurnAction();
		var _attacker = array_first(_turn_action.attackers);
		
		switch(__state) {
			case 0:
				__z = min(__z + __zSpeed, 0);
				__zSpeed += __zGravity;
				_attacker.y = _attacker.ystart + __z;
				if(__z == 0) {
					__state++;
					break;
				}
				break;
			case 1:
				var _action = new BasicMultiTurnAttackAction().Initialize(__.turn_context);
                var _new_turn_action = new TurnAction(_action, _turn_action.attackers, _turn_action.targets);
				
				ObjBattleStateController.AddDelayedAction(_attacker, _new_turn_action, 0);
				_attacker.AddEffect(instance_create_depth(_attacker.x, _attacker.y, _attacker.depth + 1, ObjAngelBeamCharge));
				__state++;
				break;
			case 2:
				__.has_ended = true;
				break;
		}
	}
}