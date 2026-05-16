function ActionStepEffectAnimationWait(_config) : ActionStep(_config) constructor {
    id = _config[$ "id"];
    
    static Run = function() {
        if(finished) {
            return;
        }
        
        var _instance = turn_context.GetTurnInstance();
        var _effect = _instance.GetEffects().Get(id);
        var _effect_animation = _effect.GetAnimation();
        
        if(is_undefined(_effect) || !instance_exists(_effect) || is_undefined(_effect_animation)) {
            finished = true;
            return;
        }
        
        finished = _effect_animation.finished;
    }
}