function ActionStrategy() constructor {
	__ = { };
    __.AdjustWeight = function(_weight, _value) { return clamp(_weight + _value, 0, 100); }
}