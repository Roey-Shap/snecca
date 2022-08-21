// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function draw_self_ext(){
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale,
					image_angle, global_color(image_blend), image_alpha);
}