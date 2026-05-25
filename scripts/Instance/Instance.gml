function CreateBasicEffect(_x, _y, _depth, _sprite, _life = -1) {
    return instance_create_depth(_x, _y, _depth, ObjBasicEffect).Initialize(_sprite, _life);
}

function CreateParticleEffect(_x, _y, _depth, _particle) {
    return instance_create_depth(_x, _y, _depth, ObjParticle, { particle: _particle });
}

function CreatePersistentEffect(_x, _y, _depth, _particle) {
    return instance_create_depth(_x, _y, _depth, ObjParticle, { particle: _particle });
}