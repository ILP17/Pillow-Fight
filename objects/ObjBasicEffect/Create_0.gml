__life = -1;
__initialLife = -1;
animation = undefined;

Initialize = function(_sprite, _life = -1) {
	sprite_index = _sprite;
	__initialLife = _life;
	__life = __initialLife;
    return self;
}

SetLife = function(_life) {
    __life = -1;
    __initialLife = -1;
}

/**
 * @param {Struct.Animation} _animation
**/
SetAnimation = function(_animation) {
    if(!is_undefined(animation)) {
        animation.Stop();
    }
    
    animation = _animation;
    animation.Play();
}

/**
 * @return {Struct.Animation}
**/
GetAnimation = function() {
    return animation;
}