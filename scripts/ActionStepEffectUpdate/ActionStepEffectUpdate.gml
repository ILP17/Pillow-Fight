function ActionStepEffectUpdate(_config) : ActionStep(_config) constructor {
    id = _config[$ "id"];
    x = _config[$ "x"];
    y = _config[$ "y"];
    depth = _config[$ "depth"];
    life = _config[$ "life"];
    sprite = _config[$ "sprite"];
    scale = _config[$ "scale"];
    animation = _config[$ "animation"];
    
    static Run = function() {
        if(finished) {
            return;
        }
        
        var _instance = turn_context.GetTurnInstance();
        var _effect = _instance.GetEffect(id);
        
        _effect.x = is_undefined(x) ? _effect.x : EvaluateX(x);
        _effect.y = is_undefined(y) ? _effect.y : EvaluateY(y);
        _effect.depth = is_undefined(depth) ? _effect.depth : EvaluateDepth(depth);
        
        if(!is_undefined(sprite)) {
            _effect.sprite_index = asset_get_index(sprite);
        }
        
        if(!is_undefined(scale)) {
            _effect.image_xscale = scale[0];
            _effect.image_yscale = scale[1];
        }
        
        if(!is_undefined(life)) {
            _effect.SetLife(life);
        }
        
        if(!is_undefined(animation)) {
            if(is_string(animation)) {
                _effect.SetAnimation(ObjAnimationProvider.GetAnimation(animation, _instance, turn_context, {}));
            } else {
                _effect.SetAnimation(ObjAnimationProvider.GetAnimation(animation[$ "type"], _instance, turn_context, animation));
            }
        }
        
        finished = true;
    }
}