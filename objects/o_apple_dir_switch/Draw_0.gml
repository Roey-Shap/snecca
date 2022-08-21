/// @description

var dis = 1;
var xadd = sin(current_time/400) * (image_angle % 180 == 0);
var yadd = cos(current_time/400) * (image_angle % 180 == 90);

draw_sprite_ext(sprite_index, image_index, x + xadd, y + yadd, image_xscale, image_yscale,
			image_angle, image_blend, image_alpha);