__.healthColor = c_aqua;

if(GetHealthRatio() < 0.5) {
	__.healthColor = c_yellow;
}

if(GetHealthRatio() < 0.25) {
	__.healthColor = c_red;
}

var _difference = (__.health - __.healthDisplay),
	_sign_difference = sign(_difference),
	_abs_difference = abs(_difference);

__.healthDisplay += max(_abs_difference div 5, 1) * _sign_difference;

var _animations = struct_get_names(__.animations);
for(var i = 0; i < array_length(_animations); i++) {
    __.animations[$ _animations[i]].Play();
}