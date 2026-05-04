/**
 * @param {Id.Instance} _instance
**/
function AnimationSpin(_instance) : Animation() constructor {
    instance = _instance;
    spin_speed = 0;
    max_spin_speed = 25;
    
    __DoRotation = function() {
		__SetRotation(instance.image_angle - spin_speed * instance.image_xscale);
	}
	
	__SetRotation = function(_rotation) {
		instance.image_angle = _rotation;
		
		var _length = instance.sprite_height / 2;
		var _x1 = lengthdir_x(_length, instance.image_angle + 90);
		var _y1 = lengthdir_y(_length, instance.image_angle + 90);
		var _x2 = lengthdir_x(_length, 90);
		var _y2 = lengthdir_y(_length, 90);
		var _direction = point_direction(_x1, _y1, _x2, _y2);
		var _distance = point_distance(_x1, _y1, _x2, _y2);
		
		ScrInstanceSetPos(instance,
			instance.xstart + lengthdir_x(_distance, _direction),
			instance.ystart + lengthdir_y(_distance, _direction))
	}
    
    Play = function() { 
		if(spin_speed >= max_spin_speed) {
			finished = true;
			return;
		}
		spin_speed += 0.5;
        __DoRotation();
    }
    
    Stop = function() {
        instance.image_angle = 0;
    }
}