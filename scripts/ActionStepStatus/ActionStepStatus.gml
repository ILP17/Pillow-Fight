function ActionStepStatus(_config) : ActionStep(_config) constructor {
    status = _config[$ "status"];
    active_turns = _config[$ "active_turns"];
    target = _config[$ "target"];
    
    __part_system = undefined;
    
    __Reset = function() {
        __z = 0;
	}
    
    static Run = function() {
        if(finished) {
            return;
        }
        
        var _target = ParseInstance(target);
        
        _target.ApplyBuff(ObjStatusProvider.GetStatus(status, active_turns));
        
        finished = true;
    }
}