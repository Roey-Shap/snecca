/// @description
var w = display_get_gui_width();
var h = display_get_gui_height();

switch(global.game_state){
	case RUNNING:
	
	break;
	
	case LOST:	
		draw_set_color(c_black);
		draw_set_alpha(0.65);
		draw_rectangle(0, 0, x+w, y+h, false);
		draw_set_color(c_white);
		draw_set_alpha(1);

		var base_height = 24;

		var margin = 4;
		draw_set_font(fa_small);
		var text_height = string_height("AAA");
		var i = 0;
		
		draw_set_halign(fa_center);
		draw_set_valign(fa_center);
		draw_set_color(c_white);
		draw_text_ext(w/2, base_height+(text_height+margin)*(i++), "You've worn your soul thin... Rest up and give it another shot!", string_height("AAA"), w*2/3);
		i++; //accounting for extra line
		draw_text(w/2, base_height+(text_height+margin)*(i++), "Stats\n-----------------------");
		if global.record_run {
			draw_set_color(c_yellow);
			draw_text(w/2, base_height+(text_height+margin)*(i++), "Record Run! This is the furthest you've gotten!");
			draw_set_color(c_white);
		}
		draw_text(w/2, base_height+(text_height+margin)*(i++), "Total monsters killed: " + string(global.cur_monsters_killed_as_ghost+global.cur_monsters_killed_in_body));
		draw_text(w/2, base_height+(text_height+margin)*(i++), "Monsters killed in a body: " + string(global.cur_monsters_killed_as_ghost));
		draw_text(w/2, base_height+(text_height+margin)*(i++), "Monsters killed as a ghost: " + string(global.cur_monsters_killed_in_body));
		draw_text(w/2, base_height+(text_height+margin)*(i++), "Rooms visited: " + string(global.cur_rooms_cleared));
		draw_text(w/2, base_height+(text_height+margin)*(i++), "Floors cleared: " + string(global.cur_floors_cleared));
		draw_text(w/2, base_height+(text_height+margin)*(i++), "Percentage of current floor cleared: " + string(100*global.rooms_cleared_on_cur_floor/global.rooms_needed_until_next_floor) + "%");
		
		var time_data = scr_get_time_HH_MM_SS(global.cur_run_time/60);
		var seconds = time_data[0];
		var minutes = time_data[1];
		var hours = time_data[2];
		
		var time_text = "";
		time_text += string(hours) + ": ";
		time_text += string(minutes) + ": ";
		time_text += string(seconds);

		draw_text(w/2, base_height+(text_height+margin)*(i++), "Run Duration (HH/MM/SS): " + time_text);
		
		
		
		draw_text(w/2, base_height+(text_height+margin)*(i++), "Spirit Points Collected: " + string(global.cur_spirit_points_collected));
		draw_text(w/2, base_height+(text_height+margin)*(i++), "-----------------------");
		
		//show the player their stats:
		//monsters killed while ghost form
		//monsters killed while in a body
		//monsters killed total
		//spirit points accumulated
		//run time
		//rooms cleared
		//floors cleared
		
		if move_on_timer <= 0 {
			draw_text(w/2, base_height+(text_height+margin)*(i++), "Press any key to return to the home menu.");
		}
		
	break;
	
	case PAUSED:
		if global.game_state == PAUSED {
			if surface_exists(surf){
				draw_surface(surf, 0, 0);
				draw_set_font(fa_large);
				draw_set_color(c_black);
				draw_set_alpha(0.4);
				draw_rectangle(0, 0, x+w, y+h, false);
				draw_set_color(c_white);
				draw_set_alpha(1);
				draw_set_halign(fa_center);
				draw_set_valign(fa_center);
				draw_text(w/2, h/2, "Paused. Press Tab to resume.");
			}
		}
	break;
}