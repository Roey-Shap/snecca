/// @description

if CAN_SCRIBBLE {
	create_scribble_text(textbox_conversation[textbox_conversation_index]);
} else {
	textbox_w = text_wrap_x == -1 ? textbox_w : text_wrap_x; //messy override
	tagged_text = textbox_conversation[textbox_conversation_index];
	//textbox_w *= 1/2;
	if !have_parsed_text and tagged_text != "" {
		have_parsed_text = true;
		parsed_text_array = parse_scribble_text(tagged_text);
	}

}