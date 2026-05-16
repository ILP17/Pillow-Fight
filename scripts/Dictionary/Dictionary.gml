function Dictionary() constructor {
    PRIVATE
    
    __.dictionary = {};
    
    /**
     * @param {String} _id
     * @param {Any} _instance
    **/
    Add = function(_id, _effect_object) {
    	__.dictionary[$ _id] = _effect_object;
    }
    
    /**
     * @param {String} _id
     * @return {Any}
    **/
    Get = function(_id) {
    	return __.dictionary[$ _id];
    }
    
    /**
     * @return {Array<String>}
    **/
    GetKeys = function() {
    	return struct_get_names(__.dictionary);
    }
    
    /**
     * @param {String} _id
    **/
    Remove = function(_id) {
    	variable_struct_remove(__.dictionary, _id);
    }
    
    Clear = function() {
        __.dictionary = {};
    }
}

function InstanceDictionary() : Dictionary() constructor {
    /**
     * @param {String} _id
     * @param {Id.Instance} _instance
    **/
    Add = function(_id, _effect_object) {
    	__.dictionary[$ _id] = _effect_object;
    }
    
    /**
     * @param {String} _id
     * @return {Id.Instance}
    **/
    Get = function(_id) {
    	return __.dictionary[$ _id];
    }
    
    /**
     * @param {String} _id
    **/
    Remove = function(_id) {
        instance_destroy(Get(_id));
    	variable_struct_remove(__.dictionary, _id);
    }
    
    Clear = function() {
        static __Remove = function(_id, _instance) {
            instance_destroy(_instance);
        }
        
        struct_foreach(__.dictionary, __Remove);
        
        __.dictionary = {};
    }
}

function AnimationDictionary() : Dictionary() constructor {
    /**
     * @param {String} _id
     * @param {Struct.Animation} _instance
    **/
    Add = function(_id, _effect_object) {
    	__.dictionary[$ _id] = _effect_object;
    }
    
    /**
     * @param {String} _id
     * @return {Struct.Animation}
    **/
    Get = function(_id) {
    	return __.dictionary[$ _id];
    }
    
    /**
     * @param {String} _id
    **/
    Remove = function(_id) {
        Get(_id).Stop();
    	variable_struct_remove(__.dictionary, _id);
    }
    
    Clear = function() {
        static __Remove = function(_id, _animation) {
            _animation.Stop();
        }
        
        struct_foreach(__.dictionary, __Remove);
        
        __.dictionary = {};
    }
}