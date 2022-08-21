// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function draw_shaderless_scribble_text(textX, textY, parsed_text_array, charCount){
	if charCount == 0 return;
	//show_debug_message(parsed_text_array);
	var prevFont = draw_get_font();
	var prevCol = draw_get_color();
	var prevHAlign = draw_get_halign();
	var prevVAlign = draw_get_valign();
	
	//=============
	
	draw_set_font(global.text_font);
	draw_set_halign(fa_center);
	draw_set_valign(fa_center);

	//draw_text_ext(textX, textY + string_height("AAA"), parsed_text_array, string_height("AAA"), textbox_w/2);

	var stop_drawing = false;
	var char_height = string_height("AAA");

	textX -= textbox_w/4;		//meh. Integration-adherence adjustments

	////==============
	
	var chunks = array_length(parsed_text_array);
	var add_width = 0;
	var cur_height = textY;
	
	var cur_col = c_white;
	
	var character_difference_significance = 30; //higher letter effects more impacted by their position
	
	var wave_significance_x = 3;
	var wave_significance_y = 3;
	var wave_frequency = 1.1;
	
	var jitter_frequency = 11;
	var jitter_severity = 1;
	
	var pulse_significance = 0.1;
	var pulse_frequency = 1.15;
	
	//for each chunk, draw the text with the correct tags
	var charCounter = 0;
	
	for (var i = 0; i < chunks; i++) {
		if stop_drawing break;
		
		var chunk_data = parsed_text_array[i];
		var cur_str = chunk_data[0];
		var cur_tags = chunk_data[1];
		var start_new_line = chunk_data[2];
		var line_align_buffer = chunk_data[3];
		
		//process the tags
		cur_col = cur_tags[tags.color];
		cur_height += start_new_line * char_height;
		add_width = (start_new_line or i == 0) ? line_align_buffer : add_width;
		
		//----------------------
		
		draw_set_color(cur_col);
		
		var str_len = string_length(cur_str);
		for (var c = 1; c <= str_len; c++ ) {
			if charCounter <= charCount {
				var cur_char = string_char_at(cur_str, c);
				var cur_char_w = string_width(cur_char);
				var t = (current_time + (character_difference_significance*c)) / 350;
				var add_x = 0;
				var add_y = 0;
				var scale = 1;
			
				if cur_tags[tags.jitter] or cur_tags[tags.shake] {
					if irandom(jitter_frequency) == 0 {
						add_x += irandom_range(-jitter_severity, jitter_severity);
						add_y += irandom_range(-jitter_severity, jitter_severity);
					}
				}
			
				if cur_tags[tags.wave] {
				//	add_x += wave_significance_x * cos(t);
					add_y += wave_significance_y * sin(t*wave_frequency);
				}
			
				if cur_tags[tags.pulse] {
					scale += pulse_significance * sin(t*pulse_frequency);
				}
			
				draw_text_transformed_color(textX + add_width + add_x, cur_height + add_y, cur_char, 
											scale, scale, 0, cur_col, cur_col, cur_col, cur_col, 1);
				add_width += cur_char_w;
				charCounter++;
			} else {
				stop_drawing = true;
				break;
			}
		}
	}
	
	draw_set_font(prevFont);
	draw_set_color(prevCol);
	draw_set_halign(prevHAlign);
	draw_set_valign(prevVAlign);
}