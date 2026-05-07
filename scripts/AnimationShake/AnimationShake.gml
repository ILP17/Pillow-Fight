/**
 * @param {Id.Instance} _instance
**/
function AnimationShake(_instance) : Animation() constructor {
    shake_time = 80;
    shake_timer = 80;
    instance = _instance;
    
    Play = function() { 
        if(shake_timer == 0) {
			finished = true;
            instance.x = instance.xstart;
            return;
		}
        
        instance.x = instance.xstart + irandom_range(-4, 4);
		shake_timer--;
    }
}