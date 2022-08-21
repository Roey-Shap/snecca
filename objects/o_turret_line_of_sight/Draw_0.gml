
var offset = place_meeting(x, y, o_player_floor_parent) ? 8 : 0;
simple_outline(x, y-offset, c_black);
draw_sprite_ext(sprite_index, image_index, x, y-offset, image_xscale, image_yscale, image_angle,
				global_color(image_blend), image_alpha);

/// @description
if fire_timer != 0 or true {// or floor(current_time + 10) % 30 != 0 {
	var dis = CELL_W/16;
	var spacing = 2;
	var total_distance = dis*(spacing*fire_timer);
	var height = floor(CELL_H/5);
	for (var i = 0; i < fire_timer + 1; i++){
		var curx = (x + CELL_W/2) - (total_distance/2) + (dis*(2*i));
		draw_set_color(c_black);
		draw_circle(curx, y - height, 3, false);
		draw_set_color(global_color(image_blend));
		draw_circle(curx, y - height, 3, true);
	}
}


if alarmed {
	draw_set_color(global_color(CHEESE_COLOR));
	draw_set_alpha(0.7 * 1 * (fire_timer == 0 ? 1 : 0.5));//(floor(current_time % 30) != 0));
	
	var end_x = CX + lengthdir_x(room_width, fire_direction);
	var end_y = CY + lengthdir_y(room_width, fire_direction);
	
	draw_line(CX, CY, end_x, end_y);
				
	draw_set_color(c_white);
	draw_set_alpha(1);
	//draw_set_halign(fa_center);
	//draw_set_valign(fa_center);
	//draw_set_font(fnt_medium);
	
	//simple_outline_text(CX, CY - CELL_H/4, "!", 1, c_white);
	
	//draw_set_color(c_black);
	//draw_text(CX, CY - CELL_H/2, "!");
}
