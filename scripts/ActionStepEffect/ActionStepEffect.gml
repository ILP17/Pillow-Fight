function ActionStepEffect(_config) : ActionStep(_config) constructor {
    id = _config[$ "id"];
    x = _config[$ "x"];
    y = _config[$ "y"];
    depth = _config[$ "depth"];
    life = _config[$ "life"] ?? -1;
    sprite = asset_get_index(_config[$ "sprite"] ?? nameof(SprPillowCombatMissing));
    scale = _config[$ "scale"] ?? [1, 1];
    angle= _config[$ "angle"] ?? 0;
    animation = _config[$ "animation"];
    waiting = false;
    effect = noone;
    
    __Reset = function() {
        effect = noone;
        waiting = false;
    }
    
    static Run = function() {
        if(finished) {
            return;
        }
        
        if(waiting) {
            finished = effect.GetAnimation().finished;
            return;
        }
        
        var _instance = turn_context.GetTurnInstance();
        var _x = EvaluateX(x);
        var _y = EvaluateY(y);
        var _depth = EvaluateDepth(depth);
        effect = CreateBasicEffect(_x, _y, _depth, sprite, life);
        ScrInstanceSetScale(effect, scale[0], scale[1]);
        effect.image_angle = angle;
        
        if(!is_undefined(id)) {
            _instance.AddEffect(id, effect);
        }
        
        if(!is_undefined(animation)) {
            effect.SetAnimation(ObjAnimationProvider.GetAnimation(animation, effect, turn_context));
            
            waiting = true;
            return;
        }
        
        finished = true;
    }
}