/**
 * @param {Id.Instance} _instance
**/
function AnimationLaserShrink(_instance) : Animation() constructor {
    instance = _instance;
    
    Play = function() {
        if(finished) {
            return;
        }
        
		if(instance.image_yscale - 0.05 <= 0) {
            instance.image_yscale = 0;
			finished = true;
            return;
		}
		
		instance.image_yscale -= 0.05;
    }
}