function ActionStepAnimation(_config) : ActionStep(_config) constructor {
    animation_config = _config[$ "animation"];
    target = _config[$ "target"];
    id = _config[$ "id"];
    animation = undefined;
    
    __Reset = function() {
        var _target = ParseInstance(target);
        
        if(is_string(animation_config)) {
            animation = ObjAnimationProvider.GetAnimation(animation_config, _target, turn_context, {});
        } else {
            animation = ObjAnimationProvider.GetAnimation(animation_config[$ "type"], _target, turn_context, animation_config);
        }
	}
    
    static Run = function() {
        if(finished) {
            return;
        }
        
        if(!is_undefined(id)) {
            var _instance = turn_context.GetTurnInstance();
            _instance.AddAnimation(id, animation);
        } else {
            animation.Play();
        }
        
        finished = animation.finished;
    }
}