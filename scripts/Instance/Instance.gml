/**
	@param {Id.Instance} _instance
	@param {real} _x
	@param {real} _y
*/
function ScrInstanceSetPos(_instance, _x, _y) {
	_instance.x = _x;
	_instance.y = _y;
}

/**
	@param {Id.Instance} _instance
	@param {real} _x
	@param {real} _y
	@param {real} _step
	@param {real} _padding
*/
function ScrInstanceMoveTo(_instance, _x, _y, _step, _padding = 0) {
	var _distance = point_distance(_instance.x, _instance.y, _x, _y),
		_direction = point_direction(_instance.x, _instance.y, _x, _y);
	
	if(_distance - _padding <= _step) {
		_instance.x = _x - lengthdir_x(_padding, _direction);
		_instance.y = _y - lengthdir_y(_padding, _direction);
		return true;
	}
	
	_instance.x += lengthdir_x(_step, _direction);
	_instance.y += lengthdir_y(_step, _direction);
	
	return false;
}

/**
	@param {Id.Instance} _instance
	@param {real} _x
	@param {real} _y
*/
function ScrInstanceSetScale(_instance, _x, _y) {
	_instance.image_xscale = _x;
	_instance.image_yscale = _y;
}