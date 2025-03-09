/**
 * @param {Array} _array
**/
function array_sum(_array) {
	var _total = 0;
    var _length = array_length(_array);
    for(var i = 0; i < _length; i++) {
        _total += _array[i];
    }
    return _total;
}

/**
 * @param {Array} _array
**/
function array_empty(_array) {
	return array_length(_array) == 0;
}

/**
 * @param {Array} _array
 * @param {real} _index
**/
function array_has_index(_array, _index) {
	return _index >= 0 && _index < array_length(_array);
}