/// @description

if firing {
	draw_set_color(HURT_COLOR);
	var end_x = CX + lengthdir_x(room_width, fire_direction);
	var end_y = CY + lengthdir_y(room_width, fire_direction);
	
	draw_line(CX, CY, end_x, end_y);
				
	draw_set_color(c_white);
}