__time = 0;
__damageChannel = animcurve_get_channel(AnimCurveElastic, 0);
__critChannel = animcurve_get_channel(AnimCurveElastic, 1);
__weakChannel = animcurve_get_channel(AnimCurveElastic, 2);
__textColor = c_maroon;
damage = 0;
styles = [
    new DamageStyle(0, __weakChannel, c_maroon),
    new DamageStyle(1, __damageChannel, c_maroon),
    new DamageStyle(2, __critChannel, c_maroon),
    new DamageStyle(3, __weakChannel, #1E664E)
];
style = styles[0];

Initialize = function(_damage, _styleIndex) {
	damage = _damage;
	style = styles[_styleIndex];
    
    image_index = style.imageIndex;
    __textColor = style.textColor;
}
