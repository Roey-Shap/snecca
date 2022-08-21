// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function simple_outline(xx, yy, color){	
	
	var offset = 1;
	
	gpu_set_fog(true, color, 0, 1);
	draw_sprite_ext(sprite_index, image_index, xx + offset, yy, image_xscale, image_yscale, image_angle, color, image_alpha);
	draw_sprite_ext(sprite_index, image_index, xx, yy + offset, image_xscale, image_yscale, image_angle, color, image_alpha);
	draw_sprite_ext(sprite_index, image_index, xx - offset, yy, image_xscale, image_yscale, image_angle, color, image_alpha);
	draw_sprite_ext(sprite_index, image_index, xx, yy - offset, image_xscale, image_yscale, image_angle, color, image_alpha);
	gpu_set_fog(false, c_white, 0, 1);
}