function ActionStepParticle(_config) : ActionStep(_config) constructor {
    id = _config[$ "id"];
    particle = asset_get_index(_config[$ "particle"]);
    x = _config[$ "x"];
    y = _config[$ "y"];
    depth = _config[$ "depth"];
    persist = _config[$ "persist"] ?? false;
    
    instance = noone;
    
    __Reset = function() {
        instance_destroy(instance);
	}
    
    static Run = function() {
        if(finished) {
            return;
        }
        
        var _instance = turn_context.GetTurnInstance();
        var _x = EvaluateX(x);
        var _y = EvaluateY(y);
        var _depth = EvaluateDepth(depth);
        
        if(!is_undefined(id)) {
            _instance.AddParticle(id, CreateParticleEffect(_x, _y, _depth, particle));
            finished = true;
            return;
        }
        
        instance = CreateParticleEffect(_x, _y, _depth, particle);
        finished = true;
    }
}