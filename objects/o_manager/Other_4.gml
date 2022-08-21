/// @description

//make a camera
if !instance_exists(camera){
	cam = instance_create_layer(x, y, layer, camera);
}

if !layer_exists(LAYER_COLLISION_TILES) {
	layer_create(250, LAYER_COLLISION_TILES);
}
var col_tiles_layer_id = layer_get_id(LAYER_COLLISION_TILES);

// make the tiles for the blocks
var tilemap = layer_tilemap_create(col_tiles_layer_id, 0, 0, ts_barrier_1, ceil(room_width/CELL_W), ceil(room_height/CELL_H));
var obj_ind = o_barrier;
with (obj_ind) {
	if object_index == obj_ind {	// don't include children
		for (var w = 0; w < image_xscale; w++) {
			for (var h = 0; h < image_yscale; h++) {
			
				var rx = x + (w*CELL_W);
				var ry = y + (h*CELL_H);
			
				var north_tile = collision_point(rx, ry - CELL_H, obj_ind, false, false) != noone or rx >= room_width;
				var west_tile  = collision_point(rx - CELL_W, ry, obj_ind, false, false) != noone or rx <= 0;
				var east_tile  = collision_point(rx + CELL_W, ry, obj_ind, false, false) != noone or ry >= room_height;
				var south_tile = collision_point(rx, ry + CELL_H, obj_ind, false, false) != noone or ry <= 0;
			
				var tile_index = NORTH*north_tile + WEST*west_tile  + EAST*east_tile + SOUTH*south_tile + 1;
				
				tilemap_set(tilemap, tile_index, floor(rx / CELL_W), floor(ry / CELL_H));
			}
		}
	}
}


layer_set_visible(layer_get_id("Background"), false); //I'm too lazy to otherwise manually control the backgrounds' visible

if room == rm_level_select {
	var lay_id = layer_get_id("Backgrounds_1");
	var BG_id = layer_background_get_id(lay_id);
	if layer_exists(lay_id) layer_background_blend(BG_id, merge_color(global_color(SNAKE_COLOR), c_black, 0.1));
}

global.step_input = global.buffer_amount * 8;

if !WEB_BUILD {
	if global.fullscreen and !window_get_fullscreen() window_set_fullscreen(true);
}

//Refresh the undo list
if ds_exists(room_state_data, ds_type_list) {
	
	//loop through the stack, destroying every frame's state_data_list
	while (!ds_list_empty(room_state_data)) {
		//get the top-most one
		var cur_list = room_state_data[| 0];
		ds_list_destroy(cur_list);
		ds_list_delete(room_state_data, 0);
	}
	
	ds_list_destroy(room_state_data);
	//effect_create_above(ef_ring, 0, 0, 20, c_red);
}

room_state_data = ds_list_create();

//Make the starting cutscene
if just_transitioned or true {	//it's fine to just have them see the title every time
	if just_transitioned {
		intro_timer = intro_time; //changing the title to appear once
	}
	just_transitioned = false;
	

	global.step_input = intro_timer * 2/3;
	//var cutscene = instance_create_layer(0, 0, layer, obj_cutscene_textbox_scribble);
	//cutscene.textbox_conversation = level_introductions[level_index]; 
}

if just_transitioned {	//if this is the first time you've been in this room during this session
	just_transitioned = false;
	with (obj_cutscene_textbox_scribble){
		if CAN_SCRIBBLE {
			textbox_skip = true;
		}
	}
}



///---------------- Level Select Screen and main menu ----------------------------\\\
if room == rm_level_select {
	if !WEB_BUILD {
		repeat(irandom_range(3, 6)){
			var ranx = irandom_range(room_width * 1/8, room_width * 7/8);
			var rany = irandom_range(room_height *1 /8, room_height * 7/8);
			ranx = (ranx) - (ranx % CELL_W);
			rany = (rany) - (rany % CELL_H);
		
			while instance_place(ranx, rany, o_snake_part_parent){
				ranx = irandom_range(room_width * 1/8, room_width * 7/8);
				rany = irandom_range(room_height *1 /8, room_height * 7/8);
				ranx = (ranx) - (ranx % CELL_W);
				rany = (rany) - (rany % CELL_H);
		
			}
		
			var snake = instance_create_layer(ranx, rany, layer, o_snake);
			snake.dummy_mode = true;
			snake.starting_length = irandom_range(1, 6);
			snake.last_direction = irandom(3) * 90;
		
			with(snake){
				add_to_body(starting_length - 1, o_collision_snake_part, last_direction);

				last_input_direction = last_direction;
			}
		}
	}
} else {
	
	var level_BG_snd = music_list[get_level_music_from_index(level_index)];
	
	var tracks = array_length(music_list);
	for (var m = 0; m < tracks; m++){
		var cur = music_list[m];
		if audio_is_playing(cur) and cur != level_BG_snd {
			audio_stop_sound(cur);
		}
	}
	
	if !audio_is_playing(level_BG_snd){
		var music = audio_play_sound(level_BG_snd, 3, true);
		audio_sound_gain(music, global.audio_music_level, 300);
	}
}


