/// @description

if keyboard_check_pressed(vk_escape) game_end();

if keyboard_check_pressed(ord("R")) room_restart();

if keyboard_check_pressed(ord("Q")) {
	global.debug = scr_toggle(global.debug);
	show_debug_overlay(global.debug);	
	if layer_exists("Test_Tiles") {
		layer_set_visible("Test_Tiles", global.debug);
	}
}

if keyboard_check_pressed(ord("C")) {
	if instance_exists(camera) {
		if global.debug {
			if camera.follow == o_meta_object {
				camera.follow = o_player;
			} else {
				camera.follow = o_meta_object;
			}
		}
	}
}

if global.debug {
	if keyboard_check_pressed(vk_left) or keyboard_check_pressed(vk_right) or keyboard_check_pressed(vk_up) or keyboard_check_pressed(vk_down) {
		camera.follow = o_meta_object;
	}
} else {
	camera.follow = o_player;
}

if instance_exists(camera){
	x = camera.x;
	y = camera.y;
}

switch(global.game_state){
	case RUNNING:
		if instance_number(o_player) == 0  {
			global.game_state = LOST;
			move_on_timer = 120;
			if global.cur_floors_cleared >= global.record_floors_cleared {
				if global.rooms_cleared_on_cur_floor/global.rooms_needed_until_next_floor >= global.record_percentage_cleared_of_record_floor {
					global.record_run = true;
					global.record_percentage_cleared_of_record_floor = global.rooms_cleared_on_cur_floor/global.rooms_needed_until_next_floor;
					global.record_floors_cleared = global.cur_floors_cleared;
				}
			}
			
			scr_random_pitch(s_death);
		}
		
		global.cur_run_time += 1;
		
		if keyboard_check_pressed(vk_tab){
			global.game_state = PAUSED;
			var cam = camera;
			
			if !surface_exists(surf){
				surf = surface_create(display_get_gui_width(), display_get_gui_height());
				surface_copy(surf, 0, 0, application_surface);
			}
			
			paused_cam_x = cam.x;
			paused_cam_y = cam.y;
			camwidth = cam.camwidth;
			camheight = cam.camheight;
			
			instance_deactivate_all(true);
		}
	break;
	
	case LOST:
		//show the player their stats:
		//monsters killed while ghost form
		//monsters killed while in a body
		//monsters killed total
		//spirit points accumulated
		//run time
		//rooms cleared
		//floors cleared
		
		if move_on_timer <= 0 {
			if keyboard_check_pressed(vk_anykey){
				
				scr_save_stats();
				
				//reset stats
				global.cur_floors_cleared = 0;
				global.cur_rooms_cleared = 0;
				global.rooms_cleared_on_cur_floor = 0;
				global.rooms_needed_until_next_floor = 0;
				global.cur_spirit_points_collected = 0;
				global.room_spirit_points_collected = 0;
				global.player1_health = -1;
				global.player1_cur_hp_regen_threshold = 1;
				global.player1_cur_hp_regen_target_hp = -1;
				global.record_run = false;
				
				room = rm_start;
				global.game_state = RUNNING; //will probably be set at the beginning of a game for safety but that's alright
			}
		} else {
			move_on_timer -= 1;
		}
	break;
	
	case PAUSED:
		if keyboard_check_pressed(vk_tab){
			global.game_state = RUNNING;
			instance_activate_all();
			
			if surface_exists(surf) surface_free(surf);
		}
	
	break;
}