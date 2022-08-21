image_alpha = global.debug;

if CAN_SCRIBBLE {
	textbox_conversation = ["[portrait,spr_test_portrait][name,Juju]Hi! Welcome to [wave][rainbow]Scribble " + __SCRIBBLE_VERSION + "![/rainbow][/wave]\n\n\n[slant]Please press space to advance the conversation[/slant]"]
	textbox_element				= SCRIBBLE_NULL_ELEMENT;
	//textbox_conversation = ["[portrait,spr_test_portrait][name,Test]Hi! Welcome to [wave][rainbow]Scribble " + __SCRIBBLE_VERSION + "![/rainbow][/wave]\n\n\n[slant]Please press space to advance the conversation[/slant]"];
}

textbox_width				= 400;
textbox_height				= 100;
cur_portrait				= -1;
textbox_title				= undefined;
textbox_conversation_index	= 0;
textbox_skip				= false;
text_fade_factor			= 3;

text_wrap_x = -1;

textSectionW = 0;
textSectionH = 2000;

image_alpha = global.debug;

//textbox_conversation = ["[portrait,spr_test_portrait][name,Juju]Hi! Welcome to [wave][rainbow]Scribble " + __SCRIBBLE_VERSION + "![/rainbow][/wave]\n\n\n[slant]Please press space to advance the conversation[/slant]"]
//textbox_conversation = ["[portrait,spr_test_portrait][name,Test]Hi! Welcome to [wave][rainbow]Scribble " + __SCRIBBLE_VERSION + "![/rainbow][/wave]\n\n\n[slant]Please press space to advance the conversation[/slant]"];
tagged_text = "";


text_wrap_x = -1;
text_spd = 1;

text_spd_init = text_spd;


var guiW = display_get_gui_width();
var guiH = display_get_gui_height();

textbox_w = guiW * 1/3;
textbox_h = guiH * 3/10;

textbox_w = text_wrap_x == -1 ? textbox_w : text_wrap_x; //messy override

parsed_text_array = -1;

have_parsed_text = false;

charCount = 0;
totalCharacters = 0;
text_timer = 2;

countFreq = 1; //Time between letter prints (plus one)
commma_countFreq = 4;
space_countFreq = 8; //Time between a period and the next character

