GetOption = function(_key, _default_value) {
    return __.options[$ _key] ?? _default_value;
}

PRIVATE

__.options = {};

var _file = "options.json";
var _data = ScrLoadJson(_file);

__.options = _data ?? {};