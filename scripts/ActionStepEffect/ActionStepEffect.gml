function ActionStepEffect(_config) : ActionStep(_config) constructor {
    id = _config[$ "id"];
    x = _config[$ "x"];
    y = _config[$ "y"];
    depth = _config[$ "depth"];
    life = _config[$ "life"] ?? -1;
    sprite = asset_get_index(_config[$ "sprite"] ?? nameof(SprPillowCombatMissing));
    scale = _config[$ "scale"] ?? [1, 1];
    animation = _config[$ "animation"];
    
    static Run = function() {
        if(finished) {
            return;
        }
        
        var _instance = turn_context.GetTurnInstance();
        var _x = EvaluateX(x);
        var _y = EvaluateY(y);
        var _depth = EvaluateDepth(depth);
        var _effect = CreateBasicEffect(_x, _y, _depth, sprite, life);
        ScrInstanceSetScale(_effect, scale[0], scale[1]);
        
        if(!is_undefined(id)) {
            _instance.AddEffect(id, _effect);
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