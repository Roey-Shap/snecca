var guiW = display_get_gui_width();
var guiH = display_get_gui_height();

//var textbox_w = guiW * 1/3;
//var textbox_h = guiH * 3/10;

//var midX = guiW/2;
//var midY = textbox_h * 5/8;

//var margin = textbox_w/24;
//var radius = 13;
//var borderWidth = 4;

//draw_set_color(c_white);
//draw_roundrect_ext(midX - textbox_w/2, midY - textbox_h/2, midX + textbox_w/2, midY + textbox_h/2, radius, radius, false);
//draw_set_color(c_black);
//draw_roundrect_ext(midX - textbox_w/2 + borderWidth, midY - textbox_h/2 + borderWidth, midX + textbox_w/2 - borderWidth, midY + textbox_h/2 - borderWidth, radius, radius, false);

draw_set_alpha(1);
//draw_set_color(cur_text_col);
//draw_set_font(fnt_regular);
draw_set_halign(fa_center);
draw_set_valign(fa_center);

//Main text
//var maxTextWidth = textSectionW - 2*margin;
//var fontSep = string_height("AAA");
//var curTextHeight = string_height_ext(cur_text, fontSep, maxTextWidth);

//var textX = midX + textbox_w/2 - textSectionW/2;
//var textY = midY;

var textX = round(x);
var textY = round(y);

if CAN_SCRIBBLE {
	
	textbox_element
	.typewriter_in(textbox_skip? 9999 : text_spd, text_fade_factor)
	.draw(textX, textY);
	
	if global.start_paused textbox_element.typewriter_pause();

} else {
	if global.debug {
		draw_self();
		draw_set_alpha(1);
	//	draw_text(x, y, charCount);
		var rad = 24;
		draw_set_color(c_white);
		draw_circle(textX - textbox_w/2, textY-32, rad, false);
		draw_circle(textX + textbox_w/2, textY-32, rad, false);
	}
	draw_shaderless_scribble_text(textX, textY, parsed_text_array, charCount);
	if global.start_paused text_spd = 0;

}


