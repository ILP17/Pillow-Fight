#macro KEYWORD_ATTACKER "attacker"
#macro KEYWORD_VICTIM "victim"
#macro KEYWORD_ATTACKER_LENGTH 8
#macro KEYWORD_VICTIM_LENGTH 6
#macro KEYWORD_RANDOM ".random"

function ActionStep(_config) constructor {
    finished = false;
    turn_context = undefined;
    attacker = [];
    victim = [];
    random_attacker = noone;
    random_victim = noone;
    
    static Run = function() { }
    
    /**
     * @param {Struct.TurnContext} _turn_context
    **/
    static Reset = function(_turn_context) {
        var _turn_action = _turn_context.GetTurnAction();
		finished = false;
        turn_context = _turn_context;
        attacker = _turn_action.attackers;
        victim = _turn_action.targets;
        random_attacker = noone;
        random_victim = noone;
        __Reset();
	}
    
    __Reset = function() { }
    
    /**
     * @param {String} _input
     * @return {Id.Instance}
    **/
    static ParseInstance = function(_input) {
        if(!is_string(_input)) {
            show_message($"[ParseInstance] failed to parse instance, input={_input}");
            game_end();
            return noone;
        }
        var _has_attacker = string_pos(KEYWORD_ATTACKER, _input) * KEYWORD_ATTACKER_LENGTH;
        var _has_victim = string_pos(KEYWORD_VICTIM, _input) * KEYWORD_VICTIM_LENGTH;
        var _starting_index = _has_attacker + _has_victim;
        
        if(_has_attacker && _has_victim) {
            show_message("[ParseInstance] attacker and victim cannot both be present");
            game_end();
            return noone;
        }
        
        var _has_random = string_pos_ext(KEYWORD_RANDOM, _input, _starting_index)
        
        if(_has_attacker) {
            var _attacker = attacker[0];
            
            if(_has_random) {
                if(random_attacker == noone) {
                    random_attacker = attacker[irandom(array_length(attacker)-1)];
                }
                _attacker = random_attacker;
            }
            
            return _attacker;
        }
        
        if(_has_victim) {
            var _victim = victim[0];
            
            if(_has_random) {
                if(random_victim == noone) {
                    random_victim = victim[irandom(array_length(victim)-1)];
                }
                _victim = random_victim;
            }
            
            return _victim;
        }
    }
    
    ParseNumber = function(_input) {
        var _is_add = string_pos("+", _input);
        var _is_sub = string_pos("-", _input);
        var _start_index = _is_add + _is_sub;
        var _number = 0;
        
        if(_is_add && _is_sub) {
            show_message("[ParseNumber] + and - cannot both be present");
            game_end();
            return 0;
        }
        
        if(_start_index) {
            var _number_string = string_copy(_input, _start_index+1, string_length(_input));
            _number = _number_string == "" ? 0 : real(_number_string);
            
            if(_is_sub) {
                _number *= -1;
            }
        }
        
        return _number;
    }
    
    /**
     * @param {String} _input
     * @return {real}
    **/
    static EvaluateX = function(_input) {
        if(is_real(_input)) {
            return _input;
        }
        
        if(is_string(_input)) {
            var _instance = ParseInstance(_input);
            var _number = ParseNumber(_input);
            
            if(string_pos(".start", _input) || string_pos(".xstart", _input)) {
                return _instance.xstart + _number;
            }
            
            return _instance.x + _number;
        }
        
        show_message($"[EvaluateX] failed to parse x, input={_input}");
        game_end();
        return 0;
    }
    
    /**
     * @param {String} _input
     * @return {real}
    **/
    static EvaluateY = function(_input) {
        if(is_real(_input)) {
            return _input;
        }
        
        if(is_string(_input)) {
            var _instance = ParseInstance(_input);
            var _number = ParseNumber(_input);
            
            if(string_pos(".start", _input) || string_pos(".ystart", _input)) {
                return _instance.ystart + _number;
            }
            
            return _instance.y + _number;
        }
        
        show_message($"[EvaluateY] failed to parse y, input={_input}");
        game_end();
        return 0;
    }
    
    /**
     * @param {String} _input
     * @return {real}
    **/
    static EvaluateDepth = function(_input) {
        if(is_real(_input)) {
            return _input;
        }
        
        if(is_string(_input)) {
            var _instance = ParseInstance(_input);
            var _number = ParseNumber(_input);
            return _instance.depth + _number;
        }
        
        show_message($"[EvaluateDepth] failed to parse depth, input={_input}");
        game_end();
        return 0;
    }
}