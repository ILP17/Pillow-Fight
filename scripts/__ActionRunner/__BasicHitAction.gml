function BasicHitAction() : Action() constructor {
	__state = 0;
	
	Run = function() {
		var _attacker = __attackers[0],
			_victim = __targets[0];
		
		switch(__state) {
			case 0:
				if(scr_instance_move_to(_attacker, _victim.x, _victim.y, 8, 24)) {
					__state++;
					break;
				}
				break;
			case 1:
				_victim.Damage(GetDamage(_attacker, 0.25, _victim, AT_STAT, DF_STAT));
				__state++;
				break;
			case 2:
				if(scr_instance_move_to(_attacker, _attacker.xstart, _attacker.ystart, 8)) {
					__state++;
					break;
				}
				break;
			case 3:
				__hasEnded = true;
				break;
		}
	}
}