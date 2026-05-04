function ActionStepTimer(_config) : ActionStep(_config) constructor {
    time = _config[$ "time"];
    repeat_config = _config[$ "repeat"];
    step = [];
    time_source = time_source_create(time_source_game, time, time_source_units_frames, function() { __Callback(); }, []);
    
    var _step = _config[$ "step"] ?? [];
    
    if(is_array(_step)) {
        for(var i = 0; i < array_length(_step); i++) {
            array_push(step, ActionStepFactory(_step[i]));
        }
    } else {
        step = [ActionStepFactory(_step)];
    }
    
    __Reset = function() {
        time_source_reset(time_source);
        
        for(var i = 0; i < array_length(step); i++) {
            step[i].Reset(turn_context);
        }
	}
    
    __Callback = function() {
        for(var i = 0; i < array_length(step); i++) {
            step[i].Reset(turn_context);
            step[i].Run();
        }
        
        finished = time_source_get_reps_remaining(time_source) == 0;
    }
    
    static Run = function() {
        if(finished) {
            return;
        }
        
        if(time_source_get_state(time_source) == time_source_state_initial) {
            var _repeat = ParseRepeat(repeat_config);
            time_source_reconfigure(time_source, time, time_source_units_frames, __Callback, [], _repeat);
            time_source_start(time_source);
        }
    }
    
    static ParseRepeat = function(_input) {
        if(is_real(_input)) {
            return _input;
        }
        
        if(!is_string(_input)) {
            show_message($"ActionStepTimer - [ParseRepeat] failed to parse instance, input={_input}");
            game_end();
            return 0;
        }
        
        var _has_attacker = string_pos("attacker", _input);
        var _has_victim = string_pos("victim", _input);
        
        if(_has_attacker && _has_victim) {
            show_message("ActionStepTimer - [ParseRepeat] attacker and victim cannot both be present");
            game_end();
            return 0;
        }
        
        if(_has_attacker) {
            return array_length(attacker);
        }
        
        if(_has_victim) {
            return array_length(victim);
        }
    }
}