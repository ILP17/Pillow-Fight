function BasicMultiTurnAttackAction() : Action() constructor {
	__state = 0;
	__part_system = undefined;
	__effect = noone;
	__rotateSpeed = 0;
	__maxRotateSpeed = 25;
	__beamLength = 0;
	
	__DoRotation = function(_instance) {
		__SetRotation(_instance, _instance.image_angle - __rotateSpeed * _instance.image_xscale);
	}
	
	__SetRotation = function(_instance, _rotation) {
		_instance.image_angle = _rotation;
		
		var _length = _instance.sprite_height / 2;
		var _x1 = lengthdir_x(_length, _instance.image_angle + 90);
		var _y1 = lengthdir_y(_length, _instance.image_angle + 90);
		var _x2 = lengthdir_x(_length, 90);
		var _y2 = lengthdir_y(_length, 90);
		var _direction = point_direction(_x1, _y1, _x2, _y2);
		var _distance = point_distance(_x1, _y1, _x2, _y2);
		
		ScrInstanceSetPos(_instance,
			_instance.xstart + lengthdir_x(_distance, _direction),
			_instance.ystart + lengthdir_y(_distance, _direction))
	}
	
	Fail = function() {
		__attackers[0].RemoveEffect(ObjAngelBeamCharge);
	}
	
	Run = function() {
		var _turn_action = __.turn_context.GetTurnAction();
		var _attacker = array_first(_turn_action.attackers);
        var _victim = array_first(_turn_action.targets);
		
		switch(__state) {
			case 0:
				__DoRotation(_attacker);
				if(__rotateSpeed >= __maxRotateSpeed) {
					__state++;
					break;
				}
				__rotateSpeed += 0.5;
				break;
			case 1:
				__DoRotation(_attacker);
				__effect = instance_create_depth(_attacker.x, _attacker.y - 12, _attacker.depth + 1, ObjBasicEffect);
				__effect.Initialize(SprAngelBeam, 9999);
				__effect.image_xscale = __beamLength / 64;
				__effect.image_angle =  point_direction(_attacker.x, _attacker.y - 12, _victim.x, _victim.y - 12);
				__state++;
				break;
			case 2:
				__DoRotation(_attacker);
				var _distance = point_distance(_attacker.x, _attacker.y - 12, _victim.x, _victim.y - 12);
				__beamLength += min(16, _distance - __beamLength);
				__effect.image_xscale = __beamLength / 64;
				
				if(__beamLength == _distance) {
					__state++;
					break;
				}
				
				break;
			case 3:
				__DoRotation(_attacker);
				_attacker.RemoveEffect(ObjAngelBeamCharge);
				_victim.Damage(ScrGetDamage(_attacker, 1, _victim, MAG_STAT, DF_STAT));
				__state++;
				break;
			case 4:
				__DoRotation(_attacker);
				if(__effect.image_yscale - 0.05 <= 0) {
					__SetRotation(_attacker, 0);
					instance_destroy(__effect);
					__state++;
					break;
				}
				
				__effect.image_yscale -= 0.05;
				break;
			case 5:
				__.has_ended = true;
				break;
		}
	}
}