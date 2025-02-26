function ActionMetadata(_config = {}) constructor {
	targetType = _config[$ "targetType"] ?? TargetType.Enemy;
	effectType = _config[$ "effectType"] ?? EffectType.Damage;
    
    var _names = struct_get_names(_config);
    
    for(var i = 0; i < array_length(_names); i++) {
        var _name = _names[i];
        
        self[$ _name] = self[$ _name] ?? _config[$ _name];
    }
    
    static GetData = function(_key, _default = undefined) {
        return self[$ _key] ?? _default;
    }
}