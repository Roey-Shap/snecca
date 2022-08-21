// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information


function parse_scribble_text(tagged_text){
	draw_set_font(global.text_font);
	
	show_debug_message("Started parsing!\n");
	

	var parsed_text_array = array_create(10); //default to having space for 10 chunks
	
	var str = tagged_text;
	var len = string_length(str);
	
	var last_text_checkpoint = 1;

	var cur_tags = array_create(tags.LAST);	//this is the number of tags there are
	
	show_debug_message("Initializing color tag to white");	
	cur_tags[0] = c_white;
	for (var a = 1; a < tags.LAST; a++) {
		cur_tags[a] = false;				//initialize tags list to all false
		show_debug_message("Initializing non-color tag " + string(a) + " to false");	
	}
	var cur_chunk = 0;
	var cur_line_width = 0;
	
	show_debug_message("");
	
	//note the <='s and +1's here to account for string using 1-and-on index notation
	
	for (var i = 1; i <= len-1; i++) {
		//for a given character (not the last - it can't be one), check for the start of a tag
		
		var begin_tag_updates = string_char_at(str, i);
		if begin_tag_updates  == "[" {
			//tag found, ending the current chunk
			show_debug_message("Found tag updates starting at index " + string(i) + "...");
			//----- we'll store the current chunk along with any active tags -----//
			
			var updated_info = save_chunk(str, cur_chunk, cur_tags, last_text_checkpoint, i, cur_line_width, false, parsed_text_array);	//doubles size of the array if needed, no worries there			
			cur_line_width = updated_info[0];
			cur_chunk = updated_info[1];
			parsed_text_array = updated_info[2];
			
			//----- ...and then prepare the next chunk's beginning by seeing what updates just occured -----//
			
			cur_chunk++;
			var found_end_of_chunk = false;
			
			//continue until you find the end of this bit of tag updates
			for (var j = i+1; j <= len; j++) {
				var end_tag_updates = string_char_at(str, j);
				
				#region //look for a definite end to this tag update
				if end_tag_updates == "]" {
					if j == len {			//if this is the end of the string, it's the end of the updates
						found_end_of_chunk = true;
					} else if string_char_at(str, j+1) != "[" {				
											//if we're mid-string and the next character isn't starting another tag, this set of updates is over as well
						found_end_of_chunk = true;
					}
				}
				#endregion
				
				if found_end_of_chunk {
					//update the tags and set the next last_text_checkpoint to the last "]"
					
					//isolate the text of the unparsed group of tags with the brackets
					var count = j-i + 1;
					var updates_str = string_copy(str, i, count);
					show_debug_message("	->" + updates_str);
					var cur_tag_text_checkpoint = 1;
					
					//loop through it, find specific tags within, and identify what each should do
					for (var c = 1; c <= count; c++) {
						var open_tag = string_char_at(updates_str, c);
						if open_tag == "[" {
							show_debug_message("Found start of an individual tag at index " + string(i + c-1));
							cur_tag_text_checkpoint++;		//bump it up from that "["
							
							//search for the end of this specific tag
							for (var b = 1; b <= count; b++) {
								var close_tag = string_char_at(updates_str, b);
								if close_tag == "]" {
									show_debug_message("Found end of an individual tag at index " + string(i + c-1 + b-1));
									
									//see which tag was found and apply it
									var identified_tag = string_copy(updates_str, cur_tag_text_checkpoint, b-cur_tag_text_checkpoint);
									show_debug_message("processing individual tag " + identified_tag);
									var set_mode = !(string_char_at(identified_tag, 1) == "/");
									if !set_mode identified_tag = string_copy(identified_tag, 2, b-cur_tag_text_checkpoint-1);	//delete the first character if it was the cancellation symbol
									
									switch(identified_tag){
										default:	//we assume that it's a color here
											var found_col = false;
											var colors = array_length(global.colors);
											for (var h = 0; h < colors; h++) {
												var cur_col = global.colors[h];
												if identified_tag == cur_col[0] {
													cur_tags[tags.color] = cur_col[1];
													found_col = true;
													break;
												}
											}
											if !found_col {
												//if it didn't break and find something
												//do nothing
												
												//cur_tags[tags.color] = c_white;
											}
										break;
										
										case "jitter":
											cur_tags[tags.jitter] = set_mode;
										break;
										
										case "wave":
											cur_tags[tags.wave] = set_mode;
										break;
										
										case "pulse":
											cur_tags[tags.pulse] = set_mode;
										break;
										
										case "shake":
											cur_tags[tags.shake] = set_mode;
										break;
									}
									
									//push forward the index to check the next tag in this group of updates
									cur_tag_text_checkpoint = b+2;			//bump up the checkpoint marker to right after this closing bracket
									c = cur_tag_text_checkpoint;
								}
							}
						}
					}
					
					//to finish out this group of tags,	adjust the index that we pick back up from as we scan
					last_text_checkpoint = j+1;
					i = last_text_checkpoint;			//we know that there isn't anything to scan between i and the tags we just processed, so skip that space
					show_debug_message("Finished a group of tag updates with the \"]\" at index " + string(i-1) + "\n");
					break;
				}
			}
		}
	}
	
	show_debug_message("final chunk");
	//upon reaching the end of the string, copy the last chunk
	var updated_info = save_chunk(str, cur_chunk, cur_tags, last_text_checkpoint, len+1, cur_line_width, true, parsed_text_array);	//doubles size of the array if needed, no worries there				

	cur_line_width = updated_info[0];
	cur_chunk = updated_info[1];
	parsed_text_array = updated_info[2];
	
	cur_chunk++;
	
	//trim the empty spaces from the finished chunks array
	var final = array_create(cur_chunk);
	array_copy(final, 0, parsed_text_array, 0, cur_chunk);
	parsed_text_array = final;
	
	//Align the text on each line to the center by moving each sentence's start forward by half of the distance of the total line's width:
	//run through each chunk, looking for when a newline is started;
	//when one is, we run back to the first chunk after the last line was started
	var final_amount_of_chunks = cur_chunk;
	
	var first_chunk_of_line_index = 0;
	var ready_to_find_next_line_first_chunk = false;
	var cur_line_string = "";
	
	for (var c = 0; c < final_amount_of_chunks; c++){
		//Current chunk data
		var chunk_array = parsed_text_array[c];

		//If a new line was found (or the end of everything was reached), return to the last chunk BEGINNING a line and push it forward to center it
		if chunk_array[2] or c+1 >= final_amount_of_chunks {	
			var start_line_chunk = parsed_text_array[first_chunk_of_line_index];
			var str_data = start_line_chunk[0];
			var tags_data = start_line_chunk[1];
			var newline_data = start_line_chunk[2];
			
			//Update that chunk's data
			var total_line_width = string_width(cur_line_string);
			parsed_text_array[first_chunk_of_line_index] = [str_data, tags_data, newline_data, ((textbox_w/2) - total_line_width)/2];
			show_debug_message("Pushed forward to center line: \"" + cur_line_string + "\" by " + string(((textbox_w/2) - total_line_width)/2));
			
			//This is the next first chunk of a given line
			first_chunk_of_line_index = c;
			//if this is also the last chunk of the whole textbox...
			if c+1 >= final_amount_of_chunks {
				var start_line_chunk = parsed_text_array[c];
				var str_data = start_line_chunk[0];
				var tags_data = start_line_chunk[1];
				var newline_data = start_line_chunk[2];
				
				cur_line_string = str_data;
				var total_line_width = string_width(cur_line_string);
				parsed_text_array[c] = [str_data, tags_data, newline_data, ((textbox_w/2) - total_line_width)/2];
				show_debug_message("Pushed forward to center FINAL line: \"" + cur_line_string + "\" by " + string(((textbox_w/2) - total_line_width)/2));
			}
			cur_line_string = "";
		}
		
	cur_line_string += chunk_array[0];
		
		
	//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	
	}
	
	show_debug_message("");

	return(parsed_text_array);
	
	//I need to fix the spacing a bit
	//var final_string = "";
	//for (var c = 0; c < cur_chunk; c++){
	//	var chunk = parsed_text_array[c];
	//	final_string += chunk[0];
	//}
	//return(final_string);


}