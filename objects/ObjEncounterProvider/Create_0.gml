GetEncounter = function(_index) {
    var _encounter_config = __.encounters[_index];
    var _encounter = [];
    
    for(var i = 0; i < array_length(_encounter_config); i++) {
        var _monster_key = _encounter_config[i];
        
        if(is_undefined(_monster_key)) {
            show_message($"{object_index}.[{nameof(GetEncounter)}] {_monster_key} is not a known monster");
            game_end();
            break;
        }
        
        array_push(_encounter, global.monsters[$ _encounter_config[i]]);
    }
    
    
    return _encounter;
}

GetRandomEncounter = function() {
    return GetEncounter(irandom(array_length(__.encounters) - 1));
}

PRIVATE

__.encounters = [];

var _file = "encounters.json";
var _data = ScrLoadJson(_file);

__.encounters = _data[$ "encounters"];

if(is_undefined(__.encounters)) {
    show_message("Encounters are undefined");
    game_end();
}