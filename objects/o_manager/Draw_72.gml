/// @description

draw_rectangle_color(0, 0, room_width, room_height, c_black, c_black, c_black, c_black, false);

draw_clear_alpha(c_black, 0);

//draw background
if room != rm_level_select {
	var cx = view_get_xport(0) - CELL_W;
	var cy = view_get_yport(0) - CELL_H;
	
	//var tw = (SCREEN_W + (2*CELL_W)) div CELL_W;
	//var th = (SCREEN_H + (2*CELL_H)) div CELL_H;
	
	var floor_col = global_color(FLOOR_COLOR);
	
	draw_sprite_tiled_ext(spr_floor_tiled, 0, cx - SCREEN_W/2, cy - CELL_H, 1, 1, floor_col, 1);
	
	//Somehow this one is less efficient - maybe a vertex drawing thingy where they stretch it into a larger combined "sprite" and draw that with just two tris
	//for (var w = 0; w < tw; w++){
	//	for (var h = 0; h < th; h++){
	//		draw_sprite_ext(spr_floor_tiled, 0, cx + (w*CELL_W), cy + (h*CELL_H),
	//						1, 1, 0, floor_col, 1);
	//	}
	//}

	//draw_sprite_tiled_ext(spr_floor_tiled, 0, 
	//camera.x - camera.camwidth/2 - CELL_W, camera.y - camera.camheight/2 - CELL_H,
	//1, 1, global_color(FLOOR_COLOR), 1);
	////camera.x + camera.camwidth/2 + CELL_W, camera.y + camera.camheight/2 - CELL_H,
}

if global.show_grid {
	draw_set_alpha(0.2);
	var w = room_width/CELL_W;
	var h = room_height/CELL_H;

	for (var i = 0; i < w; i++) {
		draw_line_width_color(i*CELL_W, 0, i*CELL_W, room_height, 1, c_white, c_white);
		//draw_line_width_color(i*CELL_W, 0, i*CELL_W, room_height, 1, c_black, c_black);
	}
	for (var i = 0; i < h; i++) {
		draw_line_width_color(0, i*CELL_H, room_width, i*CELL_H, 1, c_white, c_white);
//		draw_line_width_color(0, i*CELL_H, room_width, i*CELL_H, 1, c_black, c_black);
	}
	draw_set_alpha(1);
}