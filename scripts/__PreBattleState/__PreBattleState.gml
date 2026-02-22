function PreBattleState(_turn_sort_function) constructor {
    __ = self[$ "__"] ?? { };
    __.turn_sort = _turn_sort_function;
    
    /**
     * @param {Struct.Battle} _battle
    **/
    static CreateTurnOrder = function(_battle) {
        array_sort(_battle.turn_order, __.turn_sort);
    }
    
    /**
     * @param {Struct.Battle} _battle
    **/
    static Process = function(_battle) {
        CreateTurnOrder(_battle);
    }
}