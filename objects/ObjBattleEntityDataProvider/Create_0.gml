/**
 * @param {String} _key
**/
GetBattleEntity = function(_key) {
    return __.data[$ _key];
}

/**
 * @param {Array<String>} _keys
**/
GetBattleEntities = function(_keys) {
    var _data = [];
    for(var i = 0; i < array_length(_keys); i++) {
        array_push(_data, __.data[$ _keys[i]]);
    }
    return _data;
}

CreateBattleEntity = function(_config = {}) {
    var _battle_entity_config = {};
    
    ParseValue(_config, _battle_entity_config, "name", "_name_");
    ParseValue(_config, _battle_entity_config, "sprite", SprPillowCombatMissing, asset_get_index);
    ParseValue(_config, _battle_entity_config, "isBoss", false);
    ParseValue(_config, _battle_entity_config, "stats", new Stats(), ParseStats);
    ParseValue(_config, _battle_entity_config, "actions", [ ObjActionProvider.GetAction("action_strike") ], ParseActions);
    ParseValue(_config, _battle_entity_config, "strategies", [BasicActionStrategy], ParseActionStrategies);
    
    return new ExampleMonsterCharacter(_battle_entity_config);
}

ParseValue = function(_config, _battle_entity_config, _value_key, _default_value, _transform_function = function(_value) { return _value }) {
    var _value = _config[$ _value_key];
    if(!is_undefined(_value)) { 
        _battle_entity_config[$ _value_key] = _transform_function(_value);
    } else {
        _battle_entity_config[$ _value_key] = _default_value;
    }
}

ParseStats = function(_config) {
    return new Stats(_config);
}

ParseActions = function(_actions) {
    var _action_list = [];
    
    for(var i = 0; i < array_length(_actions); i++) {
        var _action = ObjActionProvider.GetAction(_actions[i]);
        
        if(is_undefined(_action)) {
            show_message($"[ParseActions] {_actions[i]} is not a valid action");
            game_end();
        }
        
        array_push(_action_list, _action);
    }
    
    return _action_list;
}

ParseActionStrategies = function(_actions) {
    var _action_list = [];
    
    for(var i = 0; i < array_length(_actions); i++) {
        var _action;
        
        switch(_actions[i]) {
            case "BasicActionStrategy": _action = BasicActionStrategy; break;
            case "BuffActionStrategy": _action = BuffActionStrategy; break;
            case "HealActionStrategy": _action = BuffActionStrategy; break;
            case "ReviveActionStrategy": _action = BuffActionStrategy; break;
            default: show_message($"[ParseActionStrategies] {_actions[i]} is not a valid action strategy"); game_end();
        }
        
        array_push(_action_list, _action);
    }
    
    return _action_list;
}

PRIVATE

__.data = {};

var _file = "battle_entities.json";
var _data = ScrLoadJson(_file);
var _keys = struct_get_names(_data);

for(var i = 0; i < array_length(_keys); i++) {
    __.data[$ _keys[i]] = CreateBattleEntity(_data[$ _keys[i]]);
}