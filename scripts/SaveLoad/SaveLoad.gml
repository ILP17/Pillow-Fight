function ScrLoadJson(_path) {
    var _data;
	
	try
	{
        var _buffer = buffer_load(_path);
		_data = buffer_read(_buffer, buffer_string);
		buffer_delete(_buffer);
	}
	catch(_error)
	{
        show_debug_message($"Failed to load data from {_path}:\n{_error}");
        return undefined;
	}
	
	return json_parse(_data);
}

function ScrSaveJson(_struct, _path) {
    var _data;
	
	try
	{
        var _string = json_stringify(_struct);
        var _buffer = buffer_create(string_byte_length(_string), buffer_grow, 1);
        buffer_write(_buffer, buffer_string, _string);
        buffer_save(_buffer, _path);
		buffer_delete(_buffer);
	}
	catch(_error)
	{
		show_debug_message($"Failed to save data to {_path}:\n{_error}");
	}
}