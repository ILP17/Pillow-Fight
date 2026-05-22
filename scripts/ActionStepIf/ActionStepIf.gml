function ActionStepIf(_config) : ActionStep(_config) constructor {
    exists = _config[$ "exists"];
    has_status = _config[$ "has_status"];
    target = _config[$ "target"];
    step_true = [];
    step_false = [];
    selected_step = 0;
    
    var _step_true = _config[$ "true"] ?? [];
    var _step_false = _config[$ "false"] ?? [];
    
    if(is_array(_step_true)) {
        for(var i = 0; i < array_length(_step_true); i++) {
            array_push(step_true, ActionStepFactory(_step_true[i]));
        }
    } else {
        step_true = [ActionStepFactory(_step_true)];
    }
    
    if(is_array(_step_false)) {
        for(var i = 0; i < array_length(_step_false); i++) {
            array_push(step_false, ActionStepFactory(_step_false[i]));
        }
    } else {
        step_false = [ActionStepFactory(_step_false)];
    }
    
    __Reset = function() {
        selected_step = 0;
        for(var i = 0; i < array_length(step_true); i++) { step_true[i].Reset(turn_context); }
        for(var i = 0; i < array_length(step_false); i++) { step_false[i].Reset(turn_context); }
	}
    
    static __ProcessSteps = function(_steps) {
        if(array_length(_steps) == 0) {
            finished = true;
            return;
        }
        
        _steps[selected_step].Run();
        
        if(_steps[selected_step].finished) {
            selected_step ++;
        }
        
        finished = selected_step == array_length(_steps);
    }
    
    static Run = function() {
        if(finished) {
            return;
        }
        
        var _evaluation = false;
        
        if(!is_undefined(exists)) {
            _evaluation = ParseInstance(exists) != noone;
        }
        
        if(!is_undefined(has_status)) {
            if(is_undefined(target)) {
                ShowMessageAndEnd("ActionStepIf.Run", "\"target\" must be defined when using \"has_status\"");
                return;
            }
            
            var _status = has_status;
            var _target = ParseInstance(target);
            
            _evaluation = _target != noone && _target.GetStatusManager().HasStatus(_status);
        }
        
        if(_evaluation) {
            __ProcessSteps(step_true);
            return;
        }
        
        __ProcessSteps(step_false);
    }
}