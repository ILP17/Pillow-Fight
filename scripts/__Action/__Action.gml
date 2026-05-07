function Action() constructor {
    __ = {
        turn_context: undefined,
        has_ended: false
    }
    
    if(false) __.turn_context = new TurnContext(self, [], []);
	
	/**
     * @return {Struct.ActionMetadata}
	**/
	static GetMetadata = function() {
		return ObjActionMetadataProvider.GetActionMetadata(instanceof(self));
	}
	
    /**
     * @return {bool}
	**/
	static HasEnded = function() {
		return __.has_ended;
	}
    
    /**
     * @param {Struct.TurnContext} _turn_context
    **/
    Initialize = function(_turn_context) {
        __.turn_context = _turn_context;
        __Initialize();
        return self;
    }
    
    __Initialize = function() { }
    
    Run = function() { }
    
    /**
     * The attack has failed, does necessary clean up
    **/
    Fail = function() { }
}