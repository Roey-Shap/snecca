/// @description
/*
global.debug = false;
draw_set_font(fnt_large);
global.char_w = string_width("A");
global.char_h = string_height("AAA");
draw_set_font(fnt_small);
global.text_font = fnt_large;


enum tags {
	color,			//change to specified color
	jitter,			//jitters the letters around in place
	wave,			//throws letters around to form a wave
	pulse,			//ebbs the size of letters in and out
//	pulse_sync,		//same as pulse but all the letters with this tag ebb and flow in sync
	
	LAST
}

global.colors = [
	["c", c_white],
	["c_aqua", c_aqua],
	["c_black", c_black],
	["c_blue", c_blue],
	["c_dkgray", c_dkgray],
	["c_dkgrey", c_dkgrey],
	["c_fuchsia", c_fuchsia],
	["c_gray", c_gray],
	["c_green", c_green],
	["c_grey", c_grey],
	["c_lime", c_lime],
	["c_ltgray", c_ltgray],
	["c_ltgrey", c_ltgrey],
	["c_maroon", c_maroon],
	["c_navy", c_navy],
	["c_olive", c_olive],
	["c_orange", c_orange],
	["c_purple", c_purple],
	["c_red", c_red],
	["c_silver", c_silver],
	["c_teal", c_teal],
	["c_white", c_white],
	["c_yellow", c_yellow],
	["c_custom", merge_color(c_orange, c_red, 0.5)],
]