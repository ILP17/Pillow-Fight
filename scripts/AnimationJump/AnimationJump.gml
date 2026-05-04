function AnimationJump(_instance) : Animation() constructor {
    z = 0;
	zSpeed = -12;
	zGravity = 1;
    instance = _instance;
    
    Play = function() { 
        z = min(z + zSpeed, 0);
		zSpeed += zGravity;
		instance.y = instance.ystart + z;
        
		if(z == 0) {
			finished = true;
		}
    }
}