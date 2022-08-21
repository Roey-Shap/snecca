// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function autotile_global_color(tileset, obj_ind){
	
	autotile_helper(tileset, obj_ind, global_color(image_blend));
	// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
	/*
	var one_wide = image_xscale == 1;
	var one_high = image_yscale == 1;
	
	if one_wide and one_high {
		var rx = x;
		var ry = y;
			
		var north_tile = collision_point(rx, ry - CELL_H, obj_ind, false, false) != noone;
		var west_tile  = collision_point(rx - CELL_W, ry, obj_ind, false, false) != noone;
		var east_tile  = collision_point(rx + CELL_W, ry, obj_ind, false, false) != noone;
		var south_tile = collision_point(rx, ry + CELL_H, obj_ind, false, false) != noone;
	
		var tile_index = NORTH*north_tile + WEST*west_tile  + EAST*east_tile + SOUTH*south_tile + 1;
		var xcoord = (tile_index) % 5;
		var ycoord = floor((tile_index) / 5);
		draw_sprite_part_ext(tileset, 0, (xcoord)*32, (ycoord)*32, 32, 32, rx, ry, 1, 1, image_blend, image_alpha);	
		
		return;
	}
	
	//var cx = camera.x;
	//var cy = camera.y;
	//var cw = camera.camwidth;
	//var ch = camera.camheight;
	
	//only need to check those on the outside - the ones on the inside will definitely be of a given tile
	
	//top row
	for (var w = 0; w < image_xscale; w++){
		var rx = x + w*CELL_W;
		var ry = y; //y + h*CELL_H;
			
		var north_tile = collision_point(rx, ry - CELL_H, obj_ind, false, false) != noone;
		var west_tile  = collision_point(rx - CELL_W, ry, obj_ind, false, false) != noone;
		var east_tile  = collision_point(rx + CELL_W, ry, obj_ind, false, false) != noone;
		var south_tile = true;
		if !one_high south_tile = collision_point(rx, ry + CELL_H, obj_ind, false, false) != noone;
	
		var tile_index = NORTH*north_tile + WEST*west_tile  + EAST*east_tile + SOUTH*south_tile + 1;
		var xcoord = (tile_index) % 5;
		var ycoord = floor((tile_index) / 5);
		draw_sprite_part_ext(tileset, 0, (xcoord)*32, (ycoord)*32, 32, 32, rx, ry, 1, 1, image_blend, image_alpha);
	}
	
	//right column
	for (var h = 0; h < image_yscale; h++){
		var rx = x + (image_xscale-1)*CELL_W;
		var ry = y + h*CELL_H;
			
		var north_tile = collision_point(rx, ry - CELL_H, obj_ind, false, false) != noone;
		var west_tile = false;
		if !one_wide west_tile  = collision_point(rx - CELL_W, ry, obj_ind, false, false) != noone;
		var east_tile  = collision_point(rx + CELL_W, ry, obj_ind, false, false) != noone;
		var south_tile = collision_point(rx, ry + CELL_H, obj_ind, false, false) != noone;
	
		var tile_index = NORTH*north_tile + WEST*west_tile  + EAST*east_tile + SOUTH*south_tile + 1;
		var xcoord = (tile_index) % 5;
		var ycoord = floor((tile_index) / 5);
		
		draw_sprite_part_ext(tileset, 0, (xcoord)*32, (ycoord)*32, 32, 32, rx, ry, 1, 1, image_blend, image_alpha);
	}
	
	//bottom row
	for (var w = 0; w < image_xscale; w++){
		var rx = x + w*CELL_W;
		var ry = y + (image_yscale-1)*CELL_H;
			
		var north_tile = false;
		if !one_high north_tile = collision_point(rx, ry - CELL_H, obj_ind, false, false) != noone;
		var west_tile  = collision_point(rx - CELL_W, ry, obj_ind, false, false) != noone;
		var east_tile  = collision_point(rx + CELL_W, ry, obj_ind, false, false) != noone;
		var south_tile = collision_point(rx, ry + CELL_H, obj_ind, false, false) != noone;
	
		var tile_index = NORTH*north_tile + WEST*west_tile  + EAST*east_tile + SOUTH*south_tile + 1;
		var xcoord = (tile_index) % 5;
		var ycoord = floor((tile_index) / 5);
		
		draw_sprite_part_ext(tileset, 0, (xcoord)*32, (ycoord)*32, 32, 32, rx, ry, 1, 1, image_blend, image_alpha);
	}
	
	//left column
	for (var h = 0; h < image_yscale; h++){
		var rx = x;//x + w*CELL_W;
		var ry = y + h*CELL_H;
			
		var north_tile = collision_point(rx, ry - CELL_H, obj_ind, false, false) != noone;
		var west_tile  = collision_point(rx - CELL_W, ry, obj_ind, false, false) != noone;
		var east_tile = false;
		if !one_wide east_tile  = collision_point(rx + CELL_W, ry, obj_ind, false, false) != noone;
		var south_tile = collision_point(rx, ry + CELL_H, obj_ind, false, false) != noone;
	
		var tile_index = NORTH*north_tile + WEST*west_tile  + EAST*east_tile + SOUTH*south_tile + 1;
		var xcoord = (tile_index) % 5;
		var ycoord = floor((tile_index) / 5);
		
		draw_sprite_part_ext(tileset, 0, (xcoord)*32, (ycoord)*32, 32, 32, rx, ry, 1, 1, image_blend, image_alpha);
	}
	
	
	
	if image_xscale >= 3 and image_yscale >= 3 {
		//do the inner block			
		var north_tile = true;
		var west_tile  = true;
		var east_tile  = true;
		var south_tile = true;
	
		var tile_index = NORTH*north_tile + WEST*west_tile  + EAST*east_tile + SOUTH*south_tile + 1;
		var xcoord = (tile_index) % 5;
		var ycoord = floor((tile_index) / 5);
	
		if tileset != spr_tiles_floor_break_basic {
		
			draw_sprite_ext(global.tilemap_centers[? tileset], 0, x + CELL_W, y + CELL_H, image_xscale-2, image_yscale-2, 
							0, c_white, 1);
		} else {
			for (var w = 1; w < image_xscale-1; w++){
				for (var h = 1; h < image_yscale-1; h++){
			
					var rx = x + w*CELL_W;
					var ry = y + h*CELL_H;
			
					draw_sprite_part_ext(tileset, 0, (xcoord)*32, (ycoord)*32, 32, 32, rx, ry, 1, 1, image_blend, image_alpha);
				}	
			}
		}
	}
	/*
	for (var w = 0; w < image_xscale; w++){
		for (var h = 0; h < image_yscale; h++){
			
			
			//in-bounds check
			if rx <= cx + (cw/2) + CELL_W and rx >= cx - (cw/2) - CELL_W and ry <= cy + (ch/2) + CELL_H and ry >= cy - (ch/2) - CELL_H {
				draw_sprite_part_ext(tileset, 0, (xcoord)*32, (ycoord)*32, 32, 32, rx, ry, 1, 1, image_blend, image_alpha);
			}
			//if global.debug {
			//	draw_set_font(fnt_regular);
				
			//	draw_text_color(rx + CELL_W/2, ry + CELL_H/2, tile_index, 
			//					c_black, c_white, c_black, c_white, 1);
			//}
		}
	}
	*/
}
	
	/*
	//var cx = camera.x;
	//var cy = camera.y;
	//var cw = camera.camwidth;
	//var ch = camera.camheight;
	
	var col = global_color(image_blend);
	
	//only need to check those on the outside - the ones on the inside will definitely be of a given tile
	
	//top row
	for (var w = 0; w < image_xscale; w++){
		var rx = x + w*CELL_W;
		var ry = y; //y + h*CELL_H;
			
		var north_tile = collision_point(rx, ry - CELL_H, obj_ind, false, false) != noone;
		var west_tile  = collision_point(rx - CELL_W, ry, obj_ind, false, false) != noone;
		var east_tile  = collision_point(rx + CELL_W, ry, obj_ind, false, false) != noone;
		var south_tile = collision_point(rx, ry + CELL_H, obj_ind, false, false) != noone;
	
		var tile_index = NORTH*north_tile + WEST*west_tile  + EAST*east_tile + SOUTH*south_tile + 1;
		var xcoord = (tile_index) % 5;
		var ycoord = floor((tile_index) / 5);
		draw_sprite_part_ext(tileset, 0, (xcoord)*32, (ycoord)*32, 32, 32, rx, ry, 1, 1, col, image_alpha);
	}
	
	//right column
	for (var h = 0; h < image_yscale; h++){
		var rx = x + (image_xscale-1)*CELL_W;
		var ry = y + h*CELL_H;
			
		var north_tile = collision_point(rx, ry - CELL_H, obj_ind, false, false) != noone;
		var west_tile  = collision_point(rx - CELL_W, ry, obj_ind, false, false) != noone;
		var east_tile  = collision_point(rx + CELL_W, ry, obj_ind, false, false) != noone;
		var south_tile = collision_point(rx, ry + CELL_H, obj_ind, false, false) != noone;
	
		var tile_index = NORTH*north_tile + WEST*west_tile  + EAST*east_tile + SOUTH*south_tile + 1;
		var xcoord = (tile_index) % 5;
		var ycoord = floor((tile_index) / 5);
		
		draw_sprite_part_ext(tileset, 0, (xcoord)*32, (ycoord)*32, 32, 32, rx, ry, 1, 1, col, image_alpha);
	}
	
	//bottom row
	for (var w = 0; w < image_xscale; w++){
		var rx = x + w*CELL_W;
		var ry = y + (image_yscale-1)*CELL_H;
			
		var north_tile = collision_point(rx, ry - CELL_H, obj_ind, false, false) != noone;
		var west_tile  = collision_point(rx - CELL_W, ry, obj_ind, false, false) != noone;
		var east_tile  = collision_point(rx + CELL_W, ry, obj_ind, false, false) != noone;
		var south_tile = collision_point(rx, ry + CELL_H, obj_ind, false, false) != noone;
	
		var tile_index = NORTH*north_tile + WEST*west_tile  + EAST*east_tile + SOUTH*south_tile + 1;
		var xcoord = (tile_index) % 5;
		var ycoord = floor((tile_index) / 5);
		
		draw_sprite_part_ext(tileset, 0, (xcoord)*32, (ycoord)*32, 32, 32, rx, ry, 1, 1, col, image_alpha);
	}
	
	//left column
	for (var h = 0; h < image_yscale; h++){
		var rx = x;//x + w*CELL_W;
		var ry = y + h*CELL_H;
			
		var north_tile = collision_point(rx, ry - CELL_H, obj_ind, false, false) != noone;
		var west_tile  = collision_point(rx - CELL_W, ry, obj_ind, false, false) != noone;
		var east_tile  = collision_point(rx + CELL_W, ry, obj_ind, false, false) != noone;
		var south_tile = collision_point(rx, ry + CELL_H, obj_ind, false, false) != noone;
	
		var tile_index = NORTH*north_tile + WEST*west_tile  + EAST*east_tile + SOUTH*south_tile + 1;
		var xcoord = (tile_index) % 5;
		var ycoord = floor((tile_index) / 5);
		
		draw_sprite_part_ext(tileset, 0, (xcoord)*32, (ycoord)*32, 32, 32, rx, ry, 1, 1, col, image_alpha);
	}
	
	
	//do the inner block			
	var north_tile = true;
	var west_tile  = true;
	var east_tile  = true;
	var south_tile = true;
	
	var tile_index = NORTH*north_tile + WEST*west_tile  + EAST*east_tile + SOUTH*south_tile + 1;
	var xcoord = (tile_index) % 5;
	var ycoord = floor((tile_index) / 5);
	
	for (var w = 1; w < image_xscale-1; w++){
		for (var h = 1; h < image_yscale-1; h++){
			
			var rx = x + w*CELL_W;
			var ry = y + h*CELL_H;
			
			draw_sprite_part_ext(tileset, 0, (xcoord)*32, (ycoord)*32, 32, 32, rx, ry, 1, 1, col, image_alpha);
		}	
	}
	/*
	for (var w = 0; w < image_xscale; w++){
		for (var h = 0; h < image_yscale; h++){
			
			
			//in-bounds check
			if rx <= cx + (cw/2) + CELL_W and rx >= cx - (cw/2) - CELL_W and ry <= cy + (ch/2) + CELL_H and ry >= cy - (ch/2) - CELL_H {
				draw_sprite_part_ext(tileset, 0, (xcoord)*32, (ycoord)*32, 32, 32, rx, ry, 1, 1, image_blend, image_alpha);
			}
			//if global.debug {
			//	draw_set_font(fnt_regular);
				
			//	draw_text_color(rx + CELL_W/2, ry + CELL_H/2, tile_index, 
			//					c_black, c_white, c_black, c_white, 1);
			//}
		}
	}
	*/
	
	
	//for (var w = 0; w < image_xscale; w++){
	//	for (var h = 0; h < image_yscale; h++){
	//		var rx = x + w*CELL_W;
	//		var ry = y + h*CELL_H;
			
	//		var north_tile = collision_point(rx, ry - CELL_H, obj_ind, false, false) != noone;
	//		var west_tile  = collision_point(rx - CELL_W, ry, obj_ind, false, false) != noone;
	//		var east_tile  = collision_point(rx + CELL_W, ry, obj_ind, false, false) != noone;
	//		var south_tile = collision_point(rx, ry + CELL_H, obj_ind, false, false) != noone;
	
	//		var tile_index = NORTH*north_tile + WEST*west_tile  + EAST*east_tile + SOUTH*south_tile + 1;
	//		var xcoord = (tile_index) % 5;
	//		var ycoord = floor((tile_index) / 5);
			
	//		draw_sprite_part_ext(tileset, 0, (xcoord)*32, (ycoord)*32, 32, 32, rx, ry, 1, 1, global_color(image_blend), image_alpha);
	//		if global.debug {
	//			draw_text_color(rx + CELL_W/2, ry + CELL_H/2, tile_index, 
	//							c_black, c_white, c_black, c_white, 1);
	//		}
	//	}
	//}
//}