/// @description


if false {
	var grid = ds_grid_create(image_xscale*2, image_yscale*2);
	variable_instance_set(id, "tile_info_grid", grid);
	var obj_ind = object_index;

	//var final_string = "\n";

	for (var w = 0; w < image_xscale; w++) {
		for (var h = 0; h < image_yscale; h++) {
			var rx = x + (w*CELL_W);
			var ry = y + (h*CELL_H);
			
			var north_tile = collision_point(rx, ry - CELL_H, obj_ind, false, false) != noone;
			var west_tile  = collision_point(rx - CELL_W, ry, obj_ind, false, false) != noone;
			var east_tile  = collision_point(rx + CELL_W, ry, obj_ind, false, false) != noone;
			var south_tile = collision_point(rx, ry + CELL_H, obj_ind, false, false) != noone;
			
			var tile_index = NORTH*north_tile + WEST*west_tile + EAST*east_tile + SOUTH*south_tile + 1;
			//var xcoord = (tile_index) % 5;
			//var ycoord = floor((tile_index) / 5);
		
			//grid[# w, h] = xcoord;
			//grid[# w + image_xscale, h] = ycoord;
		
			grid[# w, h] = tile_index;
		//	final_string += string(tile_index) + " ";
		}
		//final_string += "\n";
	}

	//show_debug_message([id, final_string]);
}