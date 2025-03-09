function BasicLightningAction() : Action() constructor {
	//Feather ignore GM2043
	__state = 0;
	__strikeTimer = new SimpleTimer(20, self, "DoStrike");
	__strikeCount = 0;
	__target_index = 0;
	//Feather restore GM2043
	
	DoStrike = function() {
        var _turn_action = __.turn_context.GetTurnAction();
		var _attacker = array_first(_turn_action.attackers);
        var _victim = _turn_action.targets[__target_index];
		var _effect = instance_create_depth(_victim.x, _victim.y, _victim.depth + 1, ObjBasicEffect);
		_effect.Initialize(SprLightning, 24);
		_effect.image_yscale = 100;
		_effect.image_angle = -25;
		__strikeTimer.Reset();
		
		if(__target_index == 0) {
			_victim.Damage(ScrGetDamage(_attacker, 0.8, _victim, MAG_STAT, DF_STAT, 4));
		} else {
			_victim.Damage(ScrGetDamage(_attacker, 0.5, _victim, MAG_STAT, DF_STAT, 4));
		}
		
		__strikeCount --;
		__target_index ++;
		
		if(__strikeCount == 0) {
			AdvanceState();
		}
	}
	
	AdvanceState = function() {
		__state++;
	}
	
	Run = function() {
        var _turn_action = __.turn_context.GetTurnAction();
		var _attacker = array_first(_turn_action.attackers);
		
		switch(__state) {
			case 0:
				if(ScrInstanceMoveTo(_attacker, _attacker.x, _attacker.ystart - 64, 6)) {
					__strikeCount = array_length(_turn_action.targets);
					AdvanceState();
				}
				break;
			case 1:
				__strikeTimer.Tick();
				break;
			case 2:
				if(ScrInstanceMoveTo(_attacker, _attacker.x, _attacker.ystart, 4)) {
					AdvanceState();
				}
				break;
			case 3:
				__.has_ended = true;
				break;
		}
	}
}