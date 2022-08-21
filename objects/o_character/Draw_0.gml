/// @description
simple_outline(x, y-6, c_black);
draw_sprite_ext(sprite_index, image_index, x, y-8, xscale, yscale,
				image_angle, global_color(CHAR_COLOR), image_alpha);
				
//var add_x = lengthdir_x(20, walk_dir);
//var add_y = lengthdir_y(20, walk_dir);
//draw_arrow(x+16, y+16, x+16+add_x, y +16+ add_y, 50);
//draw_text_color(x, y, [x, y], c_yellow, c_red, c_yellow, c_red, 1);