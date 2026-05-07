GetAction = function(_key) {
    return __.data[$ _key];
}

PRIVATE

__.data = {};

var _mask = "actions/*.json";
var _file_name = file_find_first(_mask, fa_none);

while(string_length(_file_name) > 0) {
    var _data = ScrLoadJson("actions/"+_file_name);
    var _key = string_copy(_file_name, 0, string_length(_file_name) - 5);
    __.data[$ _key] = new ActionRunner(_key, _data);
    _file_name = file_find_next();
}
file_find_close();
