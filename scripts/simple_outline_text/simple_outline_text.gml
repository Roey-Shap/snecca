// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function simple_outline_text(xx, yy, text, offset, color){	
	color = global_color(color);
	
	draw_text_color(xx + offset, yy, text, color, color, color, color, image_alpha);
	draw_text_color(xx, yy + offset, text, color, color, color, color, image_alpha);
	draw_text_color(xx - offset, yy, text, color, color, color, color, image_alpha);
	draw_text_color(xx, yy - offset, text, color, color, color, color, image_alpha);
}