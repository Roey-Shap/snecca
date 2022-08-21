// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function basic_tile(){
	for (var w = 0; w < image_xscale; w++) {
		for (var h = 0; h < image_yscale; h++) {
			draw_sprite_ext(sprite_index, image_index, x + w*CELL_W, y + h*CELL_H, 
							1, 1, 0, image_blend, image_alpha);
		}
	}
}