CreateActionMetadata = function(_config = {}) {
    var _action_metadata_config = {};
    
    var _name = _config[$ "name"];
    if(!is_undefined(_name)) { _action_metadata_config[$ "name"] = _name; }
    
    var _target_strategy = _config[$ "targetStrategy"];
    if(!is_undefined(_target_strategy)) {
        var _function = AnyTargetStrategy;
        
        switch(_target_strategy) {
            case "target_and_adjacent": _function = AdjacentTargetStrategy; break;
            case "all": _function = AllTargetStrategy; break;
            case "buff": _function = BuffTargetStrategy; break;
            case "heal": _function = HealTargetStrategy; break;
            case "revive": _function = ReviveTargetStrategy; break;
        }
        
        _action_metadata_config[$ "targetStrategy"] = _function;
    }
    
    var _target_type = _config[$ "targetType"];
    if(!is_undefined(_target_type)) { _action_metadata_config[$ "targetType"] = TargetTypeFromString(_target_type); }
    
    var _effect_type = _config[$ "effectType"];
    if(!is_undefined(_effect_type)) { _action_metadata_config[$ "effectType"] = TargetTypeFromString(_effect_type); }
    
    var _buffs = _config[$ "buffs"];
    if(!is_undefined(_buffs)) {
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
        
        _action_metadata_config[$ "buffs"] = _buff_list;
    }
    
    return new ActionMetadata(_action_metadata_config);
}

GetActionMetadata = function(_action) {
    return __.data[$ instanceof(_action)];
}

PRIVATE

__.data = {};

var _file = "action_metadata.json";
var _data = ScrLoadJson(_file);
var _keys = struct_get_names(_data);

for(var i = 0; i < array_length(_keys); i++) {
    __.data[$ _keys[i]] = CreateActionMetadata(_data[$ _keys[i]]);
}

