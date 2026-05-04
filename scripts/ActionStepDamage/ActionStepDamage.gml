function ActionStepDamage(_config) : ActionStep(_config) constructor {
    agressor = _config[$ "agressor"];
    defender = _config[$ "defender"];
    agressor_stat = _config[$ "agressor_stat"] ?? AT_STAT;
    defender_stat = _config[$ "defender_stat"];
    scaler = _config[$ "scaler"] ?? 1;
    base_damage = _config[$ "base_damage"] ?? 0;
    
    static Run = function() {
        if(finished) {
            return;
        }
        
        var _agressor = ParseInstance(agressor);
        var _defender = ParseInstance(defender);
        
        if(is_undefined(defender_stat)){
            _defender.Damage(ScrGetDamageNoDefense(_agressor, scaler, _defender, agressor_stat, base_damage))
        } else {
            _defender.Damage(ScrGetDamage(_agressor, scaler, _defender, agressor_stat, defender_stat, base_damage));
        }
        
        finished = true;
    }
}