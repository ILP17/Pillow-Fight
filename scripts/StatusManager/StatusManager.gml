function StatusManager() constructor {
    /**
     * Gets the number of statuses
     * @return {Real}
    **/
    GetStatusCount = function() { return array_length(__.statuses); }
    
    /**
     * Gets a status at the provided index
     * @param {Real} _index
     * @return {Struct.Status}
    **/
    GetStatus = function(_index) { return __.statuses[_index]; }
    
    /**
     * @param {String} _status_id
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
     * @param {Array<String>} _status_ids
     * @return {bool}
    **/
    static HasAnyStatus = function(_status_ids) {
    	for(var i = 0; i < array_length(_status_ids); i++) {
    		if(HasStatus(_status_ids[i])) {
    			return true;
    		}
    	}
    	
    	return false;
    }
    
    /**
     * @param {Struct.Status} _status
    **/
    static AddStatus = function(_status) {
    	array_push(__.statuses, _status);
    }
    
    /**
     * Clears buffs
    **/
    static ClearStatus = function() {
    	__.statuses = [];
    }
    
    static DecayStatuses = function() {
        //Decays all status' turn timers by 1
        static Filter = function(_status, _index) {
            return _status.turn_count > 0;
        }
        
        __.statuses = array_filter(__.statuses, Filter);
        
        for(var i = 0; i < array_length(__.statuses); i++) {
            GetStatus(i).DecrementTurnCount();
        }
    }
    
    PRIVATE
    
    __.statuses = [];
}