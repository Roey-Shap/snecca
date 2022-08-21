// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function save_chunk(str, cur_chunk, cur_tags, last_text_checkpoint, index, last_width, final_chunk_mode, parsed_text_array) {
	
	var width = textbox_w;
	draw_set_font(global.text_font);
	
	var done_making_line_breaks = false;
	var start_new_line = false;
	var saved_string = string_copy(str, last_text_checkpoint, index-last_text_checkpoint);	
	var new_line_override = false;
	
	while (!done_making_line_breaks) {
		#region double size if needed
		var size = array_length(parsed_text_array); 
		if cur_chunk == size {
			var temp = array_create(size * 2);
			array_copy(temp, 0, parsed_text_array, 0, size);
			parsed_text_array = temp;
		}
		#endregion
	
		var stored_cur_tags = array_create(tags.LAST);
		array_copy(stored_cur_tags, 0, cur_tags, 0, tags.LAST);
														//not i-last__point +1 since we're already on the bracket
		//set up the newline removals
		saved_string = string_replace(saved_string, "\n", "`");
		show_debug_message(saved_string);
		
		if string_length(saved_string) <= 1 {
			parsed_text_array[cur_chunk] = [saved_string, stored_cur_tags, start_new_line, 0];
			totalCharacters += string_length(saved_string);
			done_making_line_breaks = true;
			last_width += string_width(saved_string) + string_width(" ");
			
			break;

		}
		
		//run through the string and check for any new line characters - we'll remove them and set the chunk's height to one font unit further down
		for (var i = 1; i <= index-last_text_checkpoint; i++) {
			if string_char_at(saved_string, i) == "`" {
				saved_string = string_delete(saved_string, i, 1);
				start_new_line = true;
				
				//we're adding a line now from the beginning - we let the next line know where to start
				last_width = string_width(saved_string);
			
				show_debug_message("*found a newline character");
			}
		}
	
		//now run through and check for any lines which run over the bounds of this text-wrapping width
		//if a space is found above the threshold, we return to the previous line and make a new potential chunk from there,
		//saving everything up until that space as a definite chunk		
		
		var len = string_length(saved_string);
		var last_space_index = 1;
		var made_new_line = false;
		for (var i = 1; i <= len; i++) {
			if string_char_at(saved_string, i) == " " last_space_index = i;							//investigate why this causes the loop, add some special case?
			var total_str_width = string_width(saved_string);
			if last_width + string_width(string_copy(saved_string, 1, i-1)) >= width or (final_chunk_mode and last_width + total_str_width < width){
				
				//if the index fed was the end, then just exit, letting the last one know to print on a new line
				if final_chunk_mode and string_pos(" ", saved_string) == 1 and total_str_width < width {
					//look for a lack of a space
					new_line_override = true;
					show_debug_message("Did last chunk with string: " + saved_string);
					break;	//breaks out of the for loop referencing "i"
					
					//if you didn't find an end, treat it like any other chunk and continue
				}
				
				var temp_saved_string = string_copy(saved_string, 1, last_space_index-1);
				
				show_debug_message("*line too long... starting a new line and saving \"" + temp_saved_string + "\"");
				made_new_line = true;
				
				//save the string up until the last space as a separate chunk
				parsed_text_array[cur_chunk] = [temp_saved_string, stored_cur_tags, start_new_line, 0];
				totalCharacters += string_length(temp_saved_string); //accounting for space
				
				saved_string = string_delete(saved_string, 1, last_space_index-1); //update the saved_string for the next iteration
				if string_pos(" ", saved_string) == 1 and !final_chunk_mode saved_string = string_delete(saved_string, 1, 1);	//culling spaces starting the line
				start_new_line = true;	//set the next iteration to add to its line height
				//the next line will start at the beginning of the line, therefore:
				last_width = 0;
				cur_chunk++;
				
				break;
			}
		}
		
		if !made_new_line {
			if new_line_override start_new_line = true;
			
			if string_pos(" ", saved_string) == 1 and final_chunk_mode saved_string = string_delete(saved_string, 1, 1);	//culling spaces starting the line
			parsed_text_array[cur_chunk] = [saved_string, stored_cur_tags, start_new_line, 0];
			totalCharacters += string_length(saved_string);

			done_making_line_breaks = true;
			last_width += string_width(saved_string) + string_width(" ");
		}
	}
	
	return([last_width, cur_chunk, parsed_text_array]);
	//parsed_text_array[cur_chunk] = [saved_string, stored_cur_tags, start_new_line]; 
}