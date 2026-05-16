function StatusManager() constructor {
    /**
     * Gets the number of buffs
     * @return {Real}
    **/
    GetBuffCount = function() { return array_length(__.statuses); }
    
    /**
     * Gets a status at the provided index
     * @param {Real} _index
     * @return {Struct.Status}
    **/
    GetBuff = function(_index) { return __.statuses[_index]; }
    
    /**
     * @param {string} _status_id
     * @return {bool}
    **/
    HasStatus = function(_status_id) {
    	var _method = method({_status_id}, function(_status, _index) {
    		return _status.id == _status_id;
    	});
    	
    	return array_any(__.statuses, _method);
    }
    
    /**
     * Returns true any of the provided buffs are found
     * @param {Array<Struct.Status>} _statuses
     * @return {bool}
    **/
    static HasAnyStatus = function(_statuses) {
    	for(var i = 0; i < array_length(_statuses); i++) {
    		if(HasStatus(_statuses[i])) {
    			return true;
    		}
    	}
    	
    	return false;
    }
    
    /**
     * @param {Struct.Status} _status
    **/
    static ApplyBuff = function(_status) {
    	array_push(__.statuses, _status);
    }
    
    /**
     * Clears buffs
    **/
    static ClearBuffs = function() {
    	__.statuses = [];
    }
    
    static DecayStatuses = function() {
        //Decays all buffs' turn timers by 1
        static Filter = function(_status, _index) {
            return _status.turn_count > 0;
        }
        
        __.statuses = array_filter(__.statuses, Filter);
        
        for(var i = 0; i < array_length(__.statuses); i++) {
            GetBuff(i).DecrementTurnCount();
        }
    }
    
    PRIVATE
    
    __.statuses = [];
}