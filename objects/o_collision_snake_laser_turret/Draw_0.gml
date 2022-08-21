/// @description

// Inherit the parent event

if fire_timer != 0 or true {// or floor(current_time + 10) % 30 != 0 {
	var dis = CELL_W/16;
	var spacing = 2;
	var total_distance = dis*(spacing*fire_timer);
	var height = floor(CELL_H/5);
	for (var i = 0; i < fire_timer + 1; i++){
		var curx = (x + CELL_W/2) - (total_distance/2) + (dis*(2*i));
		draw_set_color(c_black);
		draw_circle(curx, y - height, 3, false);
		draw_set_color(image_blend);
		draw_circle(curx, y - height, 3, true);
	}
}

event_inherited();

if alarmed {
	draw_set_color(CHEESE_COLOR);
	draw_set_alpha(0.7 * 1);//(floor(current_time % 30) != 0));
	
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
