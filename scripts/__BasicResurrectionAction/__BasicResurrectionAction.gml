function BasicResurrectionAction() : Action() constructor {
	//Feather ignore GM2043
	__state = 0;
	__shakeTimer = new SimpleTimer(80, self, "AdvanceState");
	__waitTimer = new SimpleTimer(15, self, "AdvanceState");
	__z = 0;
	__zSpeed = -12;
	__zGravity = 1;
	__part_system = undefined;
	//Feather restore GM2043
	
	AdvanceState = function() {
		__state++;
	}
	
	Run = function() {
		var _turn_action = __.turn_context.GetTurnAction();
		var _attacker = array_first(_turn_action.attackers);
        var _victim = array_first(_turn_action.targets);
		
		switch(__state) {
			case 0:
				__z = min(__z + __zSpeed, 0);
				__zSpeed += __zGravity;
				_attacker.y = _attacker.ystart + __z;
				if(__z == 0) {
					AdvanceState();
					break;
				}
				break;
			case 1:
				__part_system = part_system_create_layer("Instances", false, PartSysResurrect);
				part_system_position(__part_system, _victim.x, _victim.y);
				AdvanceState();
				break;
			case 2:
				if(!__shakeTimer.IsFinished()) {
					_victim.x = _victim.xstart + irandom_range(-4, 4);
				}
				
				__shakeTimer.Tick();
				break;
			case 3:
				_victim.x = _victim.xstart
				_victim.Damage(ScrGetDamageNoDefense(_attacker, -0.30, _victim, MAG_STAT, 10));
				__z = 0;
				__zSpeed = -14;
				AdvanceState();
				break;
			case 4:
				__z = min(__z + __zSpeed, 0);
				__zSpeed += __zGravity;
				_victim.y = _victim.ystart + __z;
				if(__z == 0) {
					AdvanceState();
					break;
				}
				break;
			case 5:
				__waitTimer.Tick();
				break;
			case 6:
				part_system_destroy(__part_system);
				__.has_ended = true;
				break;
		}
	}
}