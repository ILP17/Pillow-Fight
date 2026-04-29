GetActionMetadata = function(_action) {
    return __.data[$ instanceof(_action)];
}

CreateActionMetadata = function(_config = {}) {
    var _action_metadata_config = {};
    
    ParseValue(_config, _action_metadata_config, "name", "_action_");
    ParseValue(_config, _action_metadata_config, "cost", 0);
    ParseValue(_config, _action_metadata_config, "targetType", TargetType.Enemy, TargetTypeFromString);
    ParseValue(_config, _action_metadata_config, "effectType", EffectType.Damage, EffectTypeFromString);
    ParseValue(_config, _action_metadata_config, "targetStrategy", AnyTargetStrategy, ParseTargetStrategy);
    ParseValue(_config, _action_metadata_config, "buffs", [], ParseBuffs);
    
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

ParseBuffs = function(_buffs) {
    var _buff_list = [];
    
    for(var i = 0; i < array_length(_buffs); i++) {
        var _buff;
        
        switch(_buffs[i]) {
            case "valor": _buff = ValorBuff; break;
            case "protection": _buff = ProtectionBuff; break;
            case "stagger": _buff = StaggerBuff; break;
            default: show_message($"[CreateActionMetadata] {_buffs[i]} is not a valid buff"); game_end();
        }
        
        array_push(_buff_list, _buff);
    }
    
    return _buff_list;
}

PRIVATE

__.data = {};

var _file = "action_metadata.json";
var _data = ScrLoadJson(_file);
var _keys = struct_get_names(_data);

for(var i = 0; i < array_length(_keys); i++) {
    __.data[$ _keys[i]] = CreateActionMetadata(_data[$ _keys[i]]);
}