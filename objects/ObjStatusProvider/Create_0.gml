GetStatus = function(_key, _turn_count) {
    var _status_data = __.status[$ _key];
    var _status = new Status(_key, _turn_count, _status_data[$ "icon"]);
    _status.stats = new StatsMultiplierModifier(_status_data[$ "stats"]);
    _status.energy = _status_data[$ "energy"] ?? 0;
    
    return _status;
}

PRIVATE

__.status = {};

var _mask = "statuses/*.json";
var _file_name = file_find_first(_mask, fa_none);

while(string_length(_file_name) > 0) {
    var _data = ScrLoadJson("statuses/"+_file_name);
    var _key = string_copy(_file_name, 0, string_length(_file_name) - 5);
    __.status[$ _key] = _data;
    _file_name = file_find_next();
}
file_find_close();