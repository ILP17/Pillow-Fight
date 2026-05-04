GetAnimation = function(_key, _instance, turn_context, _config) {
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