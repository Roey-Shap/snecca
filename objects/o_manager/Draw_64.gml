/// @description

var w = display_get_gui_width();
var h = display_get_gui_height();

var snake_col = global_color(SNAKE_COLOR);
var hurt_col = global_color(HURT_COLOR);

var current_intro_fade_factor = (intro_timer*2.8/intro_time);

function draw_GUI_title(text, color, input_alpha, start_title_mode){
	
	draw_set_font(start_title_mode ? fnt_title_large : fnt_large);
	draw_set_color(c_black); 

	var w = display_get_gui_width();
	var h = display_get_gui_height();
	
	var title_text = text;
	var border = 3;
	var s_border = 1;
	var len = string_width(title_text) * 7/12;
	var height = string_height(title_text) * 7/12;
	var start_h = start_title_mode ? h * 1/8 : h * 1/9;
	var big_len = w*3/4;
	var factor = 3;
	
	if start_title_mode {
		draw_set_alpha(clamp(input_alpha * 0.6, 0, 1));
		draw_set_color(c_black);
		//draw_roundrect(w/2 - len*factor - border, start_h - height*factor - border, w/2 + len*factor + border, start_h + height*factor + border, false);
		draw_rectangle(0, 0, w, h, false);
	}
	
	draw_set_alpha(clamp(input_alpha, 0, 1));
	draw_set_color(c_white);
	draw_roundrect(w/2 - len - border, start_h - height - border, w/2 + len + border, start_h + height + border, false);
					
	draw_set_color(c_black);
	draw_rectangle(w/2 - len - s_border, start_h - height - s_border, w/2 + len + s_border, start_h + height + s_border, false);

	draw_set_halign(fa_center);
	draw_set_valign(fa_center);
	draw_set_alpha(1);
	
	draw_text_color(w/2, start_h, title_text, color, color, color, color, input_alpha);	
	
	
}


var alpha = 0.9;

	//---------------------------------------------------------------------------------------------------------------
	//---------------------------------------------------------------------------------------------------------------

switch(state){
	
	case game_state.playing:	
		
		draw_set_font(fnt_large);
		//var text = "Undo's Possible: " + string(ds_stack_size(room_state_data)) + "\n" + 
				//"LSHIFT / RSHIFT to Undo" + "\n" + 
				//"R to restart room" + "\n" + 
				//"ESC to pause";
		var snake_len = instance_exists(o_snake) ? o_snake.cur_length : 0;
		var text = "Current Length: " + string(snake_len) + "\nR to restart\nESC to pause";
 
		var sep = string_height("AAA");
		var width = 260;
		var buffer = 12;
		var text_w = string_width_ext(text, sep, width);
		var text_h = string_height_ext(text, sep, width);
		
		
		draw_set_alpha(0.7);
		draw_roundrect_color(24, 24, 24 + (buffer*2) + text_w, 24 + (buffer*2) + text_h, c_black, c_black, false);
		draw_set_alpha(1);
		draw_roundrect_color(24, 24, 24 + (buffer*2) + text_w, 24 + (buffer*2) + text_h, c_white, c_white, true);
		
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_set_alpha(1);
		draw_text_ext_color(24+buffer, 24+buffer, text, sep, width, c_white, c_white, c_white, c_white, 1);

		draw_set_alpha(1);
		draw_set_font(fnt_small);
		draw_set_valign(fa_center);


		if intro_timer > 0 {
			var is_challenge_level = get_level_progression_from_index(level_index) == 0;
			var outline_col = is_challenge_level ? hurt_col : c_white;
			var challenge_text = is_challenge_level ? "(Optional) " : "";
			draw_GUI_title("Level " + challenge_text + string(level_index+1) + ": \"" + get_level_name_from_index(level_index) + "\"", outline_col, clamp(current_intro_fade_factor, 0, 1), true);
		}
		
	break;

	//---------------------------------------------------------------------------------------------------------------
	//---------------------------------------------------------------------------------------------------------------
	
	case game_state.win:
		
		var text_x = w/2;
		var text_y = h * 1/5;
		var size = w/6;
	
		draw_set_color(c_white);
		draw_set_alpha(1);
	
		draw_GUI_title("Success!\nPress any button to continue.", snake_col, 1, false);
		
	break;
	
	//---------------------------------------------------------------------------------------------------------------
	//---------------------------------------------------------------------------------------------------------------
	
	case game_state.lost:
	
		var text_x = w * 1/2;
		var text_y = h * 1/5;
		var size = w/6;
		
		if global.vanilla_snake_mode {
			draw_GUI_title("SPACE to restart" , c_white, 1, false);
		} else {
			draw_GUI_title(WEB_BUILD ? "Not quite. Give it another shot!\nPress R to restart (if you want UNDO, get the downloaded version).":
				"Not quite. Give it another shot!\nPress LSHIFT/RSHIFT to undo or R to restart." , c_white, 1, false);
		}
	break;
	
	//---------------------------------------------------------------------------------------------------------------
	//---------------------------------------------------------------------------------------------------------------
	
	case game_state.paused:
	
		if surface_exists(surf) {
			draw_set_alpha(1);
			draw_surface(surf, 0, 0);			
		}
		
		if intro_timer <= 0 {
			draw_set_alpha(0.7);
		} else {
			draw_set_alpha(current_intro_fade_factor); //override with the current fade factor
		}
		
		draw_rectangle_color(0, 0, w, h, c_black, c_black, c_black, c_black, false);
		draw_set_alpha(1);
		
		var is_challenge_level = get_level_progression_from_index(level_index) == 0;
		var outline_col = is_challenge_level ? hurt_col : c_white;
		var challenge_text = is_challenge_level ? "(Optional) " : "";
		draw_GUI_title("Paused\nLevel " + challenge_text + string(level_index+1) + ": \"" + get_level_name_from_index(level_index) + "\"", outline_col, 1, true);
			
		draw_set_font(fnt_large);
		
		var dis = round(h/12.5);
		var curx = w/2;
		var start_h = h * 3/16;
		var border = 3;
		var s_border = 1;
		var text_col;
		
		//Loop through each option and draw it 
		for (var i = 0; i < paused_options.LAST; i++){
				
			var cury = start_h + dis*(i+1);
				
			var text;
			switch(i){
				case paused_options.resume:
					text = "Resume";
				break;

				case paused_options.level_select:
					text = "Level Select";
				break;

				case paused_options.options:
					text = "Settings";
				break;

				case paused_options.exit_game:
					text = "Quit Game";
				break;
					
			}
				
			draw_set_font(fnt_large);
			var len = string_width(text) * 2/3;
			var height = string_height(text) * 2/3;
			if i == option_index {
				draw_set_color(c_white);
				var xoffset = button_jump_timer > 0 ? last_vinput * 3 * button_jump_timer/button_jump_time : 0;
				var yoffset = button_jump_timer > 0 ? last_vinput * 5 * button_jump_timer/button_jump_time : 0;
					
				var delay_xoffset = button_jump_timer > 0 ? 1.075 * 3 * (button_jump_timer)/button_jump_time : 0;
				var delay_yoffset = button_jump_timer > 0 ? 1.075 * 5 * (button_jump_timer)/button_jump_time : 0;
					
				//outline
				draw_roundrect(curx - xoffset - len - border, cury - yoffset - height - border, curx - xoffset + len + border, cury - yoffset + height + border, false);
					
				//inside
				draw_set_color(c_black);
				draw_rectangle(curx - xoffset - len - s_border, cury - yoffset - height - s_border, curx - xoffset + len + s_border, cury - yoffset + height + s_border, false);
					
				//text
				draw_set_color(snake_col);
				draw_rectangle(curx - delay_xoffset - len, cury - delay_yoffset - height, curx - delay_xoffset + len, cury - delay_yoffset + height, false);
				text_col = c_black;
					
			} else {
				len *= 7/8;
				height *= 7/8;
					
				//outline
				draw_set_color(c_white);
				draw_roundrect(curx - len - border, cury - height - border, curx + len + border, cury + height + border, false);
					
				//inside
				draw_set_color(c_black);
				draw_rectangle(curx - len - s_border, cury - height - s_border, curx + len + s_border, cury + height + s_border, false);
				text_col = c_white;
			}
				
			draw_set_color(text_col);
				
			draw_text(curx, cury, text);
		}
	
	break;
	
	//---------------------------------------------------------------------------------------------------------------
	//---------------------------------------------------------------------------------------------------------------
	
	case game_state.level_select:

		draw_set_alpha(0.4);
		draw_set_color(c_black);
		//draw_roundrect(w/2 - len*factor - border, start_h - height*factor - border, w/2 + len*factor + border, start_h + height*factor + border, false);
		draw_rectangle(0, 0, w, h, false);
		draw_set_alpha(1);
		
		draw_GUI_title("Level Select", snake_col, 1, true);
		
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_set_font(fnt_medium_large);
		var col = merge_color(c_white, c_ltgray, 0.1);
		var tip_text = "ESC to return to the Main Menu";//"ESC to return to the Main Menu\nTAB to toggle DEBUG mode";
		draw_text_color(24, 24, tip_text, col, col, col, col, 1);
		
		simple_outline_text(24, 24 + string_height(tip_text)*1, "Challenge Levels are OPTIONAL and in RED", 1, c_black)
		draw_text_color(24, 24 + string_height(tip_text)*1, "Challenge Levels are OPTIONAL and in RED", c_white, hurt_col, hurt_col, c_white, 1);



		//display all of the levels in a grid------------------
		
		var startx = (w/2) - ( (levelw*gridw) + (bufferw*(gridw-1)) )/2;
		var starty = (h/4) + (h/2) - ( (levelh*gridh) + (bufferh*(gridh-1)) )/2;
		var grid_raw_w = (levelw*gridw) + (bufferw*(gridw-1));
		
		draw_set_halign(fa_center);
		draw_set_valign(fa_center);
		
		var delay_xoffset = button_jump_timer > 0 ? last_hinput * 1.5 * 5 * (button_jump_timer)/button_jump_time : 0;
		var delay_yoffset = button_jump_timer > 0 ? last_vinput * 1.5 * 5 * (button_jump_timer)/button_jump_time : 0;
		
		var cur_level_ind = level_select_x + (level_select_y*gridw);
		
		
		// Connections between level cells
		
//		var current_max_level_height = starty + (global.max_unlocked_level * (levelh + bufferh)) + levelh/2;
		var max_level = CAN_DEBUG and global.debug ? level_num : global.max_unlocked_level;
		for (var i = 1; i < max_level; i++){
			var xpos = i % gridw;
			var ypos = floor(i/gridw);
			
			var odd_row = ypos % 2 == 1;
			
			var prev = get_point_to_draw_level_connections(i-1);
			var prev_x = startx + prev[0];
			var prev_y = starty + prev[1];

			var cur = get_point_to_draw_level_connections(i);
			var cur_x = startx + cur[0];
			var cur_y = starty + cur[1];

			//if this is before the currently selected level, hightlight it
			var prev_level_col = global_color(get_level_color_from_index(i-1));
			var cur_level_col = global_color(get_level_color_from_index(i));
			
			var blank_col = merge_color(c_gray, c_black, 0.4);
			var BG_col =		i <= cur_level_ind ? c_white : blank_col;
			var cur_col =		i <= cur_level_ind ? c_black : blank_col;
			var cur_alt_col =	i <= cur_level_ind ? cur_level_col : blank_col;
			
			var prev_BG_col =		i+1 <= cur_level_ind ? c_white : blank_col;
			var prev_cur_col =		i+1 <= cur_level_ind ? c_black : blank_col;
			var prev_cur_alt_col =	i+1 <= cur_level_ind ? prev_level_col : blank_col;
			
			
			if i == 1 { //if you're at the very start, draw from the beginning to you 
				prev_x = 0;
				prev_y = cur_y;
				
			}
			
			var first_x = (startx + ( ((0) % gridw) * (levelw + bufferw))) + levelw/2;
			var first_y = starty + ( (floor((0)/gridw) * (levelh + bufferh))) + levelh/2;
			
			var center_w	= 16;
			var mid_w		= 6 + center_w;
			var border_w	= 6 + mid_w ;

			
			if i == 1 {
				//draw the first one
				draw_line_width_color(0, first_y, first_x, first_y, border_w, c_white, c_white);	
				draw_line_width_color(0, first_y, first_x, first_y, mid_w, c_black, c_black); 
				draw_line_width_color(0, first_y, first_x, first_y, center_w, snake_col, snake_col);	
			}
			
			// if you're at the end of a line, do the little loop
			// (technically, the indices work as though the grid is drawn normally)
			// (therefore, this should check if you're at the start of a line for odd lines)
			
			// Abandonded! this is a bit much for what we get out of it, considering the halfway implentation mystically does 90% of what we want
			
			//if (!odd_row and i % gridw == gridw - 1) or (odd_row and i % gridw == 0) { 
			//	draw_line_width_color(cur_x, cur_y, w, cur_y, border_w, prev_BG_col, prev_BG_col);	
			//	draw_line_width_color(cur_x, cur_y, w, cur_y, mid_w, prev_cur_col, prev_cur_col); 
			//	draw_line_width_color(cur_x, cur_y, w, cur_y, center_w, prev_cur_alt_col, prev_cur_alt_col);	
			//}
			
			draw_line_width_color(prev_x, prev_y, cur_x, cur_y, border_w, BG_col, BG_col); 
			draw_line_width_color(prev_x, prev_y, cur_x, cur_y, mid_w, cur_col, cur_col); 
			draw_line_width_color(prev_x, prev_y, cur_x, cur_y, center_w, cur_alt_col, cur_alt_col);	
		}
		
		//level squares
		for (var l = 0; l < level_num; l++){
			
			var xpos = l % gridw;
			var ypos = floor(l/gridw);
			
			var odd_row = ypos % 2 == 1;
			
			var rawx = startx + (xpos*(levelw+bufferw));
			var rawy = starty + (ypos*(levelh+bufferh));
			if odd_row rawx = startx + grid_raw_w - ((xpos+1) * (levelw+bufferw)) + bufferw;
			
			var is_challenge_level = get_level_progression_from_index(l) == 0;
			var is_unlocked = l < max_level;
			
			var level_border = is_challenge_level ? 6 : 2;
			var cur_level_col = global_color(get_level_color_from_index(l));
			
			var selected_level = xpos == level_select_x and ypos == level_select_y;
			var t;
			
			//draw outline for the current level
			//draw_set_color(merge_color(is_unlocked ? c_white : c_gray, hurt_col, is_challenge_level ? 0.7 : 0));
			draw_set_color(merge_color(is_unlocked ? c_white : c_gray, cur_level_col, 0.8));
			draw_roundrect(rawx - level_border, rawy - level_border, 
						rawx + levelw + level_border, rawy + levelh + level_border, false);
			
			
			if !selected_level {
				draw_set_color(c_black);
				draw_roundrect(rawx, rawy, rawx + levelw, rawy + levelh, false);
				
				
				t = !is_unlocked ? "???" : l+1;
			} else { //if this is the selected level
				
				//draw the black base under the snake head
				draw_set_color(c_black);
				draw_roundrect(rawx, rawy, rawx + levelw, rawy + levelh, false);
				
				var cx = rawx + levelw/2;
				var cy = rawy + levelh/2;
				draw_set_color(snake_col);
				draw_roundrect(rawx + delay_xoffset, rawy - delay_yoffset, 
								rawx + levelw + delay_xoffset, rawy + levelh - delay_yoffset, false);
								
			
				//draw the little snake eyes
				
				var eye_size = 10;
				var dir = point_direction(0, 0, last_hinput, last_vinput);
				var origin_addx = lengthdir_x(levelw*6/16, dir);
				var origin_addy = -lengthdir_y(levelh*6/16, dir);
				
				var eye_offsetx = lengthdir_x(eye_size/2 + levelw*3/16, dir+90);
				var eye_offsety = lengthdir_y(eye_size/2 + levelh*3/16, dir+90);
				
				var radius = 6;
				draw_set_color(c_black);
				
				//draw left eye
				draw_roundrect_ext(cx + origin_addx - eye_size/2- eye_offsetx + delay_xoffset, 
								cy + origin_addy - eye_size/2 - eye_offsety - delay_yoffset, 
								cx + origin_addx + eye_size/2 - eye_offsetx + delay_xoffset, 
								cy + origin_addy + eye_size/2 - eye_offsety - delay_yoffset, radius, radius, false);
				
				eye_offsetx *= -1;
				eye_offsety *= -1; 
				//draw right eye
				draw_roundrect_ext(cx + origin_addx - eye_size/2- eye_offsetx + delay_xoffset, 
								cy + origin_addy - eye_size/2 - eye_offsety - delay_yoffset, 
								cx + origin_addx + eye_size/2 - eye_offsetx + delay_xoffset, 
								cy + origin_addy + eye_size/2 - eye_offsety - delay_yoffset, radius, radius, false);
				
				t = get_level_name_from_index(l);
			}
			
			//Text within the box
			
			draw_set_font(fnt_medium_large);
			draw_set_halign(fa_center);
			draw_set_valign(fa_center);
			draw_set_color(c_black);
			draw_set_alpha(!is_unlocked ? 0.7 : 1);
			
			//text outlines
			if !is_unlocked or selected_level {
				var offset = 2;
				draw_text_ext(offset + rawx + levelw/2, rawy + levelh/2, t, string_height("AAA"), levelw * 15/16);
				draw_text_ext(-offset + rawx + levelw/2, rawy + levelh/2, t, string_height("AAA"), levelw * 15/16);
				draw_text_ext(rawx + levelw/2, offset + rawy + levelh/2, t, string_height("AAA"), levelw * 15/16);
				draw_text_ext(rawx + levelw/2, -offset + rawy + levelh/2, t, string_height("AAA"), levelw * 15/16);
			}
			
			draw_set_color(!is_unlocked ? c_gray : c_white);
			draw_text_ext(rawx + levelw/2, rawy + levelh/2, t, string_height("AAA"), levelw * 15/16);
			draw_set_alpha(1);
		}
		
		draw_set_alpha(1);
		draw_set_valign(fa_center);
	break;
	
	//---------------------------------------------------------------------------------------------------------------
	//---------------------------------------------------------------------------------------------------------------
	
	case game_state.main_menu:	
	
		//draw title
		var tx = w/2;
		var ty = h/4;
		
		draw_set_alpha(0.65);
		draw_set_color(c_black);

		draw_rectangle(0, 0, w, h, false);
		draw_set_alpha(1);
		
		draw_set_halign(fa_center);
		draw_set_valign(fa_center);
		
		var titlew = w/2;
		var titleh = h/2;
		
		if CAN_SCRIBBLE {
			title_scribble.draw(5 + (tx/2), ty + h/4);	
		} else {
			draw_set_color(snake_col);
			var prevFont = draw_get_font();
			draw_set_font(fnt_snecca);
			
			draw_text(tx, ty, "Snecca");
			draw_set_color(c_white);
			draw_set_font(prevFont);
			
			//draw_shaderless_scribble_text(tx, ty, title_scribble_parsed_text_array, );
		}
		
		//Draw options
		
		for (var i = 0; i < main_menu_options.LAST; i++) {
			
			var text = "";
			
			switch (i) {
				case main_menu_options.level_select:
					text = "Level Select";
				break;		
				
				case main_menu_options.options:
					text = "Settings";
				break;		
				
				case main_menu_options.credits:
					text = "Credits";
				break;
				
				case main_menu_options.exit_game:
					text = "Quit Game";
				break;		
			}
			
			draw_set_font(fnt_main_menu);
			var len = string_width(text) * 2/3;
			var height = string_height(text) * 2/3;
			
			var dis = h/11;
			var curx = w/2;
			var start_h = h * 5/16;
			var border = 3;
			var s_border = 1;
			var text_col;
			
			var cury = start_h + dis*(i+1);
			
			if i == option_index {
					
				draw_set_color(c_white);
				var xoffset = button_jump_timer > 0 ? last_vinput * 3 * button_jump_timer/button_jump_time : 0;
				var yoffset = button_jump_timer > 0 ? last_vinput * 5 * button_jump_timer/button_jump_time : 0;
					
				var delay_xoffset = button_jump_timer > 0 ? 1.075 * 3 * (button_jump_timer)/button_jump_time : 0;
				var delay_yoffset = button_jump_timer > 0 ? 1.075 * 5 * (button_jump_timer)/button_jump_time : 0;
					
				draw_roundrect(curx - xoffset - len - border, cury - yoffset - height - border, curx - xoffset + len + border, cury - yoffset + height + border, false);
					
				draw_set_color(c_black);
				draw_rectangle(curx - xoffset - len - s_border, cury - yoffset - height - s_border, curx - xoffset + len + s_border, cury - yoffset + height + s_border, false);
					
				draw_set_color(snake_col);
				draw_rectangle(curx - delay_xoffset - len, cury - delay_yoffset - height, curx - delay_xoffset + len, cury - delay_yoffset + height, false);
				
				text_col = c_black;
			} else {
				len *= 7/8;
				height *= 7/8;
				draw_set_color(c_white);
				draw_roundrect(curx - len - border, cury - height - border, curx + len + border, cury + height + border, false);
					
				draw_set_color(c_black);
				draw_rectangle(curx - len - s_border, cury - height - s_border, curx + len + s_border, cury + height + s_border, false);
				
				text_col = c_white;
			}
				
			draw_set_color(text_col);
				
				
			draw_text(curx, cury, text);
			
		}
	
	break;

	case game_state.options:
		
		draw_set_alpha(min(current_intro_fade_factor, 0.7));
		draw_set_color(c_black);
		draw_rectangle(0, 0, w, h, false);
		draw_set_alpha(1);
		
		switch(return_state){
			
			case game_state.paused:
				if surface_exists(surf) {
					draw_surface(surf, 0, 0);
				}
			break;
			
			case game_state.main_menu:
				
			break;
			
			default:
			
			break;
		}
		
		draw_GUI_title("Settings", snake_col, 1, true);
		
		var dis = h/11;
		var curx = w/2;
		var start_h = h * 3/16;
		var border = 3;
		var s_border = 1;
		var text_col;
		
		for (var i = 0; i < options.LAST; i++) {
			
			var text;
			var add_text = "";
			
			switch (i) {
				case options.back:
					text = "Back";
				break;
				
				
				case options.master_sound:
					text = "Master Volume: " + string(round(audio_get_master_gain(0) * 100)) + "%";
				break;
				
				
				case options.FX_sound:
					text = "Effects Volume: " + string(round(global.audio_FX_level * 100)) + "%";
				break;
				
				
				case options.music_sound:
					text = "Music Volume: " + string(round(global.audio_music_level * 100)) + "%";
				break;
				
				
				case options.buffer_time:
					text = "Buffer time: " + string(global.buffer_amount) + " frames";
					if i == option_index add_text = "Change the time it takes for a step to be made while holding down a button.";
				break;
				
				
				case options.grid_toggle:
					text = "Toggle Grid " + (global.show_grid ? "(On)" : "(Off)");
					if i == option_index add_text = "Shows a grid when playing to make distance estimation easier.";
				break;
				
				
				case options.color_mode:
					text = "Color Palette: " + global.color_palette[0] + "";
					
					
					var color_w = (200) / (colors.LAST - 1);
					var color_h = dis/4;
					var color_start_x = curx - (color_w * (colors.LAST)/2);
					//draw the swatch
					for (var c = 0; c < colors.LAST; c++) {
						draw_set_color(global.color_palette[c+1]);
						draw_rectangle(color_start_x + color_w*c, cury + dis*1.25, color_start_x + color_w*(c+1), cury + dis*1.25 + color_h, false);
					}
					draw_set_color(c_white);
				break;
				
				
				case options.fullscreen:
					text = "Fullscreen Toggle";
				break;		
			}
			
			
			draw_set_font(fnt_large);
			var len = string_width(text);
			var height = (string_height(text) * 2/3);
			draw_set_font(fnt_medium);
			len = max(len, string_width(add_text)) * 2/3;
			height += string_height(add_text) * 1/6;
			
			draw_set_font(fnt_large);
			
			var cury = start_h + dis*(i+1);
			
			if i == option_index {
					
				draw_set_color(c_white);
				var xoffset = button_jump_timer > 0 ? last_vinput * 3 * button_jump_timer/button_jump_time : 0;
				var yoffset = button_jump_timer > 0 ? last_vinput * 5 * button_jump_timer/button_jump_time : 0;
					
				var delay_xoffset = button_jump_timer > 0 ? 1.075 * 3 * (button_jump_timer)/button_jump_time : 0;
				var delay_yoffset = button_jump_timer > 0 ? 1.075 * 5 * (button_jump_timer)/button_jump_time : 0;
					
				draw_roundrect(curx - xoffset - len - border, cury - yoffset - height - border, curx - xoffset + len + border, cury - yoffset + height + border, false);
					
				draw_set_color(c_black);
				draw_rectangle(curx - xoffset - len - s_border, cury - yoffset - height - s_border, curx - xoffset + len + s_border, cury - yoffset + height + s_border, false);
					
				draw_set_color(snake_col);
				draw_rectangle(curx - delay_xoffset - len, cury - delay_yoffset - height, curx - delay_xoffset + len, cury - delay_yoffset + height, false);
				
				text_col = c_black;
				
			} else {
				
				len *= 7/8;
				height *= 7/8;
				draw_set_color(c_white);
				draw_roundrect(curx - len - border, cury - height - border, curx + len + border, cury + height + border, false);
					
				draw_set_color(c_black);
				draw_rectangle(curx - len - s_border, cury - height - s_border, curx + len + s_border, cury + height + s_border, false);
				
				text_col = c_white;
			}
				
				
			draw_set_color(text_col);
				
			draw_text(curx, cury - (add_text == "" ? 0 : height*1/6), text);
			
			if i == option_index {
				draw_set_font(fnt_medium);
				draw_text(curx, cury + height*2/3, add_text);
			}
		}
		
		
	break;
	
	case game_state.credits:
		
		draw_set_alpha(0.7);
		draw_set_color(c_black);
		draw_rectangle(0, 0, w, h, false);
		
		if CAN_SCRIBBLE {
			credits_scribble.draw(w/2, h*1/3);
		} else {
			draw_set_font(fnt_medium);
			draw_set_halign(fa_center);
			draw_set_valign(fa_middle);
			draw_text_ext_color(w/2, h*1/3, credits_text, string_height("AAA"), w * 3/4, c_white, c_white, c_white, c_white, 1);
		}

		draw_set_alpha(1);
		
		draw_set_font(fnt_medium_large);
		draw_set_color(c_white);
		draw_set_halign(fa_left);
		draw_set_valign(fa_center);
		draw_text(24, 24, "Press ESC to return to the Main Menu");
		
	break;

}

if CAN_DEBUG {
	draw_set_font(fnt_large);
	draw_set_halign(fa_right);
	draw_set_valign(fa_top);
	draw_set_color(global.debug ? c_fuchsia : c_white);
	draw_text(w - 24, 24, "**DEVELOPER BUILD** Toggle DEBUG w/ tab: " + (global.debug ? "On" : "Off"));
	draw_text(w - 24, 54, "Undo list size: " + string(ds_list_size(room_state_data)));
	draw_text(w - 24, 84, "M to Mute Master Gain: " + string(audio_get_master_gain(0)));
	draw_text(w - 24, 114, "VANILLA SNAKE MODE: " + string(global.vanilla_snake_mode));
	draw_text(w - 24, 144, "STATE: " + string(state));
	
	draw_set_halign(fa_left);
}