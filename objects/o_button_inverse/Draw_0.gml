/// @description

//var color = pressed_color;

if pressed {
	//highlight
	var sinadd = abs(sin(current_time/400)) * 20;
	var major_axis = round(sprite_width*1.1 + sinadd);
	var minor_axis = round(sprite_height*0.6 + sinadd);
	var cx = -1 + x + CELL_W/2;
	var cy = y + CELL_H/2;
	var offset = 1;

	draw_set_alpha(1);
	draw_set_color(c_white);

	draw_ellipse(-offset + cx - major_axis/2, -offset + cy - minor_axis/2, 
				offset + cx + major_axis/2, offset + cy + minor_axis/2, false);
				
	draw_set_color(merge_color((image_blend == c_white ? merge_color(c_white, global_color(SNAKE_COLOR), 0.3) : global_color(image_blend)), c_black, 0.4));
	//draw_set_alpha(0.8);
	draw_ellipse(cx - major_axis/2, cy - minor_axis/2, cx + major_axis/2, cy + minor_axis/2, false);
	
	draw_set_color(c_black);
	draw_ellipse(cx - major_axis/2, cy - minor_axis/2, cx + major_axis/2, cy + minor_axis/2, true);
	
	draw_set_alpha(1);
	draw_set_color(c_white);
	//draw_ellipse(cx - major_axis/2, cy - minor_axis/2, cx + major_axis/2, cy + minor_axis/2, true);
	
}

draw_self_ext();
