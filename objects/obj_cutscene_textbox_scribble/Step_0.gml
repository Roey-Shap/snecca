 //										vvvv can be used to prevent skipping vvvv
image_alpha = global.debug;


var advanced_text = false;
if keyboard_check_pressed(global.button_text) {
	var prev = textbox_conversation_index;
	textbox_conversation_index = min(textbox_conversation_index+1, array_length(textbox_conversation)-1);
	advanced_text = textbox_conversation_index > prev;
}

if CAN_SCRIBBLE {
	text_spd = min(text_spd * 1.003, 1.5);
	if advanced_text {
		create_scribble_text(textbox_conversation[textbox_conversation_index]);
	}
} else {

	text_spd = min(text_spd * 1.015, 2.25);
	
	if advanced_text {
		textbox_w = text_wrap_x == -1 ? textbox_w : text_wrap_x; //messy override
		tagged_text = textbox_conversation[textbox_conversation_index];
		
		if !have_parsed_text and tagged_text != "" {
			have_parsed_text = true;
			parsed_text_array = parse_scribble_text(tagged_text);
		}
	}

	//Handle letter counts, and add the next bit of text on a timer of a given delay
	if charCount < totalCharacters and text_timer <= 0 and text_spd != 0 {
		//var found_period = false;
		//var next_char = string_copy(cur_text, charCount+1, 1);
		//if next_char == "." or next_char == "?" {
		//	text_timer = space_countFreq;
		//	found_period = true;
		//} else {
		//	if next_char == "," {
		//		text_timer = commma_countFreq;
		//	} else {
		//		text_timer = countFreq;
		//	}
		//}
		text_timer = countFreq;
		charCount += 1;
	}

	text_timer -= 1*text_spd;
}

// special trigger event because... no cutscenes right now
if room == rm_level_normal_snake and textbox_conversation_index >= array_length(textbox_conversation)-1 and o_manager.state == game_state.playing {
	var accessible_goal = false;
	with (o_snake_goal) {
		if !place_meeting(x, y, o_barrier) and !place_meeting(x, y, o_collision_basic_below) {
			accessible_goal = true;
			break;
		}
	}
	if !accessible_goal {
		var s = sign(x - o_snake.head_x);
		var _x = (round(x/CELL_W)*CELL_W) + ((s == 0? 1 : s) * CELL_W * 4);
		var _y = (round(y/CELL_H)*CELL_H) + CELL_H*3;
		instance_create_layer(_x, _y, "Below", o_snake_goal);
		make_temp_effects_ext(_x, _y, "Below_FX", [spr_dust_poof1, spr_dust_poof2, spr_wiggly_3], [c_white, SNAKE_COLOR], 20, 0, 359, 0.75, 1.5, 1);
	}
}





