/**
 * @param {Id.Instance} _instance
 * @param {Struct.TurnContext} _turn_context
 * @param {Struct} _config
**/
function AnimationLaserGrow(_instance, _turn_context, _config) : Animation() constructor {
    x = _config[$ "x"];
    y = _config[$ "y"];
    
    length = 0;
    instance = _instance;
    turn_context = _turn_context;
    
    Play = function() {
        var _action_step = new ActionStep({});
        _action_step.Reset(turn_context);
        
        var _x = _action_step.EvaluateX(x);
        var _y = _action_step.EvaluateY(y);
        var _direction = point_direction(instance.x, instance.y, _x, _y);
        var _distance = point_distance(instance.x, instance.y, _x, _y);
        
        length += min(16, _distance - length);
        instance.image_angle = _direction;
        instance.image_xscale = length / sprite_get_width(instance.sprite_index);
		
		if(length >= _distance) {
            finished = true;
		}
    }
}