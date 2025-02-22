/**
	@param {real} _x
	@param {real} _y
	@param {real} _depth
	@param {Asset.GMParticleSystem} _particle_system
*/
function ScrPartSystemCreate(_x, _y, _depth, _particle_system) {
	var _particle = part_system_create(_particle_system);
	part_system_depth(_particle, _depth);
	part_system_position(_particle, _x, _y);
	return _particle;
}