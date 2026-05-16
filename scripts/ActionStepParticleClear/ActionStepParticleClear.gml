function ActionStepParticleClear(_config) : ActionStep(_config) constructor {
    id = _config[$ "id"];
    
    static Run = function() {
        if(finished) {
            return;
        }
        
        var _instance = turn_context.GetTurnInstance();
        
        _instance.GetParticles().Remove(id);
        
        finished = true;
    }
}