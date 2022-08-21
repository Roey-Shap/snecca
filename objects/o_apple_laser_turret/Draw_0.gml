/// @description

var dis = 1;
var xadd = jitter ? irandom_range(-dis, dis) : 0;
var yadd = jitter ? irandom_range(-dis, dis) : 0;

draw_sprite_ext(sprite_index, image_index, x + xadd, y + yadd, image_xscale, image_yscale,
			image_angle, image_blend, image_alpha);
			
			