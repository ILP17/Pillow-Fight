var _value = 0;
var _t = min(__time / 15, 1);

_value = animcurve_channel_evaluate(style.channel, _t);

image_xscale = _value;
image_yscale = _value;

if(__time >= 50) {
	instance_destroy();
	exit;
}

__time++;