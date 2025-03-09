function BasicHitAction() : Action() constructor {
	__state = 0;
	
	Run = function() {
        var _turn_action = __.turn_context.GetTurnAction();
		var _attacker = array_first(_turn_action.attackers);
        var _victim = array_first(_turn_action.targets);
		
		switch(__state) {
			case 0:
				if(ScrInstanceMoveTo(_attacker, _victim.x, _victim.y, 8, 24)) {
					__state++;
					break;
				}
				break;
			case 1:
				_victim.Damage(ScrGetDamage(_attacker, 0.5, _victim, AT_STAT, DF_STAT));
				__state++;
				break;
			case 2:
				if(ScrInstanceMoveTo(_attacker, _attacker.xstart, _attacker.ystart, 8)) {
					__state++;
					break;
				}
				break;
			case 3:
				__.has_ended = true;
				break;
		}
	}
}