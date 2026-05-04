GetStatus = function(_key, _turn_count) {
    return new __.status[$ _key](_turn_count);
}

PRIVATE

__.status = {
    "protection": ProtectionBuff,
    "valor": ValorBuff,
    "stagger": StaggerBuff
};