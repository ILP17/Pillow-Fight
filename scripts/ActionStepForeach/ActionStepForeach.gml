function ActionStepForeach(_config) : ActionStep(_config) constructor {
    target_config = _config[$ "target"];
    target = [];
    iterating = 0;
    step = [];
    
    var _step = _config[$ "step"] ?? [];
    
    if(is_array(_step)) {
        for(var i = 0; i < array_length(_step); i++) {
            array_push(step, ActionStepFactory(_step[i]));
        }
    } else {
        step = [ActionStepFactory(_step)];
    }
    
    __Reset = function() {
        target = ParseTarget(target_config);
        
        for(var i = 0; i < array_length(step); i++) {
            step[i].Reset(turn_context);
        }
	}
    
    /**
     * @param {Struct.ActionStep} _step
     * @param {Array<Id.Instance>} _array
    **/
    __Reset_Step = function(_step, _array) {
        _step.Reset(turn_context);
        
        if(iterating == 1) {
            _step.victim = _array;
            return;
        }
        
        _step.attacker = _array;
    }
    
    static Run = function() {
        if(finished) {
            return;
        }
        
        for(var i = 0; i < array_length(target); i++) {
            for(var j = 0; j < array_length(step); j++) {
                __Reset_Step(step[j], [target[i]]);
                step[j].Run();
            }
        }
        
        finished = true;
    }
    
    static ParseTarget = function(_input) {
        if(!is_string(_input)) {
            show_message($"ActionStepForeach - [ParseTarget] failed to parse instance, input={_input}");
            game_end();
            return [];
        }
        
        var _has_attacker = string_pos("attacker", _input);
        var _has_victim = string_pos("victim", _input);
        
        if(_has_attacker && _has_victim) {
            show_message("ActionStepForeach - [ParseTarget] attacker and victim cannot both be present");
            game_end();
            return [];
        }
        
        if(_has_attacker) {
            iterating = 0;
            return attacker;
        }
        
        if(_has_victim) {
            iterating = 1;
            return victim;
        }
    }
}