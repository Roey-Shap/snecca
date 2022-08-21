/// @description

var col = global_color(HURT_COLOR);

if global.debug {
	var dis = horizontal_range;
	
	draw_set_alpha(1);
	draw_rectangle_color(CX + lengthdir_x(dis, fire_direction + 90), 
				CY + lengthdir_y(dis, fire_direction + 90), 
				CX + lengthdir_x(room_width, fire_direction) - lengthdir_x(dis, fire_direction + 90), 
				CY + lengthdir_y(room_height, fire_direction) - lengthdir_y(dis, fire_direction + 90),
				col, col, col, col, true);
	draw_set_alpha(1);
}

if firing {
	draw_set_color(col);
	var end_x = CX + lengthdir_x(room_width, fire_direction);
	var end_y = CY + lengthdir_y(room_width, fire_direction);
	
	draw_line(CX, CY, end_x, end_y);
				
	draw_set_color(c_white);
}