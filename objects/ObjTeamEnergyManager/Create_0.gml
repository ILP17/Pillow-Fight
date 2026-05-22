Reset = function() {
    var _turn_order = ObjBattleStateController.GetTurnOrder();
    var _extra_energy = 0;
    
    for(var i = 0, n = array_length(_turn_order); i < n; i++) {
        var _battle_participant = _turn_order[i];
        var _status_manager = _battle_participant.GetStatusManager();
       	for(var j = 0, m = _status_manager.GetStatusCount(); j < m; j++) {
       		_extra_energy += _status_manager.GetStatus(j).energy;
       	}
    }
    __.energy = __.max_energy;
}

GetEnergy = function() { return __.energy; }

AddEnergy = function(_amount) {
    __.energy = clamp(__.energy + _amount, 0, __.max_energy);
}

PRIVATE
__.max_energy = 6;
__.energy = 6;

