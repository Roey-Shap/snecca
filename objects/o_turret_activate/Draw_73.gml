/// @description

if global.debug or true{
	var cx = x + CELL_W/2;
	var cy = y + CELL_H/2;
	var dis = horizontal_range;
	var col = HURT_COLOR;
	
	draw_set_alpha(0.5);
	draw_rectangle_color(cx + lengthdir_x(dis, fire_direction + 90), 
				cy + lengthdir_y(dis, fire_direction + 90), 
				cx + lengthdir_x(room_width, fire_direction) - lengthdir_x(dis, fire_direction + 90), 
				cy + lengthdir_y(room_height, fire_direction) - lengthdir_y(dis, fire_direction + 90),
				col, col, col, col, true);
	draw_set_alpha(1);
}