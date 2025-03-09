function ScrThrowNotImplemented(_construct_name, _method_name) {
	throw (_construct_name + " does not implement " + _method_name);
}

function ScrThrowArgumentUndefined(_variable_name) {
    throw (_variable_name + " is undefined.");
}