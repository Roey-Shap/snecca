
//										vvvv can be used to prevent skipping vvvv
image_alpha = global.debug;

text_spd = min(text_spd * 1.015, 2.25);


//Handle letter counts, and add the next bit of text on a timer of a given delay
if charCount < totalCharacters and text_timer <= 0 {
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

if global.debug {
	//check for mouse touching any of the nodes to drag them around
	if mouse_check_button(mb_left) {
		
	}
}


/*
//										vvvv can be used to prevent skipping vvvv
image_alpha = global.debug;

text_spd = min(text_spd * 1.0025, 1.5);

if (keyboard_check_pressed(vk_space)) and false //and textbox_element.get_typewriter_state() >= 1)
{
    if (textbox_element.get_typewriter_paused())
    {
        //If we're paused, unpause!
        textbox_element.typewriter_unpause(false);
    }
	//if the textbox is currently in the middle of writing something
    else if (textbox_element.get_typewriter_state() >= 1)
    {
        textbox_skip = false;
        
		//this first if seems to check for the textbox not being out of text on the current line
        if (textbox_element.get_page() < textbox_element.get_pages() - 1)
        {
            //move to the next line if at the end
            textbox_element.page(textbox_element.get_page() + 1);
        }
        else //if the textbox is at the end of the line, move to the next one
        {
            //Increment our conversation index for the next piece of text (this mod will restart the textbox if it's at the end!)
            textbox_conversation_index = (textbox_conversation_index + 1);
			if textbox_conversation_index >= array_length(textbox_conversation){
				//end conversation
				instance_destroy(id);
			}
        }
    }
    else
    {
        textbox_skip = true;
    }
}