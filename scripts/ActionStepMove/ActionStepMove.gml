function ActionStepMove(_config) : ActionStep(_config) constructor {
    target = _config[$ "target"];
    x = _config[$ "x"];
    y = _config[$ "y"];
    speed = _config[$ "speed"];
    padding = _config[$ "padding"] ?? 0;
    
    static Run = function() {
        if(finished) {
            return;
        }
        
        var _target = ParseInstance(target);
        var _x = EvaluateX(x);
        var _y = EvaluateY(y);
        
        if(_target == noone) {
            finished = true;
            return;
        }
        
        finished = ScrInstanceMoveTo(_target, _x, _y, speed, padding);
    }
}