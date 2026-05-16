GetActionMetadata = function(_key) {
    return __.data[$ _key];
}

CreateActionMetadata = function(_config = {}) {
    var _action_metadata_config = {};
    
    ParseValue(_config, _action_metadata_config, "name", "_action_");
    ParseValue(_config, _action_metadata_config, "cost", 0);
    ParseValue(_config, _action_metadata_config, "endTurn", false);
    ParseValue(_config, _action_metadata_config, "targetType", TargetType.Enemy, TargetTypeFromString);
    ParseValue(_config, _action_metadata_config, "effectType", EffectType.Damage, EffectTypeFromString);
    ParseValue(_config, _action_metadata_config, "targetStrategy", AnyTargetStrategy, ParseTargetStrategy);
    ParseValue(_config, _action_metadata_config, "buffs", []);
    
    return new ActionMetadata(_action_metadata_config);
}

ParseValue = function(_config, _action_metadata_config, _value_key, _default_value, _transform_function = function(_value) { return _value }) {
    var _value = _config[$ _value_key];
    if(!is_undefined(_value)) { 
        _action_metadata_config[$ _value_key] = _transform_function(_value); 
    } else {
        _action_metadata_config[$ _value_key] = _default_value;
    }
}

ParseTargetStrategy = function(_key) {
    switch(_key) {
        case "target_and_adjacent": return AdjacentTargetStrategy;
        case "all": return AllTargetStrategy;
        case "buff": return BuffTargetStrategy;
        case "heal": return HealTargetStrategy;
        case "revive": return ReviveTargetStrategy;
        default: return AnyTargetStrategy
    }
}

PRIVATE

__.data = {};

var _file = "action_metadata.json";
var _data = ScrLoadJson(_file);
var _keys = struct_get_names(_data);

for(var i = 0; i < array_length(_keys); i++) {
    __.data[$ _keys[i]] = CreateActionMetadata(_data[$ _keys[i]]);
}