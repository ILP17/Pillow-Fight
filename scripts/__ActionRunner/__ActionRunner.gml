function ActionRunner(_id, _config) : Action() constructor {
    __.id = _id;
    __.steps = [];
    __.index = 0;
    
    var _steps = _config[$ "steps"] ?? [];
    
    for(var i = 0; i < array_length(_steps); i++) {
        array_push(__.steps, ActionStepFactory(_steps[i]));
    }
    
    /**
     * @return {Struct.ActionMetadata}
	**/
	static GetMetadata = function() {
		return ObjActionMetadataProvider.GetActionMetadata(__.id);
	}
    
    __Initialize = function() {
		__.index = 0;
		__.has_ended = false;
        
        for(var i = 0; i < array_length(__.steps); i++) {
            __.steps[i].Reset(__.turn_context);
        }
	}
    
	Advance = function() {
		__.index++;
	}
	
	Run = function() {
        if(__.has_ended) {
            return;
        }
        
        var _step = __.steps[__.index];
        
        try {
        	_step.Run();
        }
        catch (error) {
            show_debug_message($"Error occured for action {__.id}");
            show_debug_message(error);
        	show_message($"Error occured for action {__.id}\n{error}");
            game_end();
        }
        
        if(_step.finished) {
            Advance();
            
            __.has_ended = __.index == array_length(__.steps);
        }
	}
}