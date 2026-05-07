GetAnimation = function(_key_or_config, _instance, turn_context) {
    var _key = _key_or_config;
    var _config = {};
    
    if(is_struct(_key)) {
        _key = _key_or_config[$ "type"];
        _config = _key_or_config;
    }
    
    return new __.animations[$ _key](_instance, turn_context, _config);
}

PRIVATE

__.animations = {
    "jump": AnimationJump,
    "shake": AnimationShake,
    "laser_grow": AnimationLaserGrow,
    "laser_shrink": AnimationLaserShrink,
    "spin": AnimationSpin,
};