function ScrEnforceImplementation(_construct_name, _method_name) {
	throw (_construct_name + " does not implement " + _method_name);
}

function ScrThrowArgumentUndefined(_variable_name) {
    throw (_variable_name + "is undefined.");
}

function ThrowIfUndefined(_value, _member_name) {
	if(is_undefined(_value)) {
		throw (_member_name + " is undefined");
	}
	
	return _value;
}