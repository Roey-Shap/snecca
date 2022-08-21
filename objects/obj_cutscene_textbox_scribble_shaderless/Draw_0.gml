
var guiW = display_get_gui_width();
var guiH = display_get_gui_height();

var midX = guiW/2;
var midY = textbox_h * 5/8;

var margin = textbox_w/24;
var radius = 13;
var borderWidth = 4;

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
var textSectionW = text_wrap_x == -1 ? textbox_w : text_wrap_x;
var textSectionH = 2000;
//var maxTextWidth = textSectionW - 2*margin;
//var fontSep = string_height("AAA");
//var curTextHeight = string_height_ext(cur_text, fontSep, maxTextWidth);

//var textX = midX + textbox_w/2 - textSectionW/2;
//var textY = midY;

var textX = x;
var textY = y;

//Note that we're setting "textbox_element" here

//THE IMPORTANT THING SHOULD HTML WORK WITH THIS LATER!!!

if have_parsed_text {
	draw_shaderless_scribble_text(textX, textY, parsed_text_array, charCount);
}

if global.debug {
	draw_sprite_ext(sprite_index, 0, x, y, 1, 1, 0, c_white, 1);
	//var rad = 10;
	//draw_set_color(c_white);
	//draw_circle(textX, textY-64, rad, false);
	//draw_circle(textX + text_wrap_x, textY-64, rad, false);
}




//draw_set_halign(fa_center);
//draw_set_valign(fa_center);
//draw_set_color(c_white);
//draw_set_font(fnt_regular);
//var sep = string_height("AAA");
//draw_text_ext(x, y+sep/2, textPart, sep, textSectionW * 1.1);

//draw_set_color(c_white);
//draw_set_font(fnt_regular);











//---------------------------------------------------------------------
//textbox_element = scribble(textbox_conversation[textbox_conversation_index])
//.wrap(textSectionW, textSectionH)
//.align(fa_center, fa_middle)
//.typewriter_in(textbox_skip? 9999 : text_spd, text_fade_factor)
//.draw(textX, textY);
//---------------------------------------------------


//var main_text_bbox = textbox_element.get_bbox(textX, textY, 10, 10, 10, 10);
//var main_text_end_x = textbox_element.get_width();

//Draw a little icon once the text has finished displaying, or if text display is paused
//if ((textbox_element.get_typewriter_state() >= 1) || textbox_element.get_typewriter_paused())
//{
//    draw_sprite(spr_white_coin, 0, midX + textbox_w/2 - margin/2, midY + textbox_h/2 - margin/2);
//}


//Title
//draw_set_font(fnt_title);
//draw_set_color(cur_title_col);
//draw_text_ext(textX, textY-textbox_h/2+margin, cur_title, string_height("AAA"), 500);

//if (textbox_title != undefined) {
//    var _element = scribble(textbox_title).align(fa_center, fa_middle);
//    var _name_box = _element.get_bbox(textX, textY-textbox_h/2+margin, 10, 10, 10, 10);
    
//    draw_set_colour($936969);
//    draw_rectangle(_name_box.left, _name_box.top, _name_box.right, _name_box.bottom, false);
//    draw_set_colour(c_white);
    
//    _element.draw(textX, textY-textbox_h/2+margin);
//}

////Portrait
//var portraitSectionWidth = textbox_w * 5/16;
//var portraitX = midX - textbox_w/2 + portraitSectionWidth/2;
//var portraitY = midY;

//if (sprite_exists(cur_portrait)) {
//	var portraitW = sprite_get_width(cur_portrait);
//	var portraitH = sprite_get_height(cur_portrait);
	
//	draw_set_color(merge_color(c_white, $936969, 0.6));
//	draw_roundrect_ext(portraitX - portraitW/2, portraitY - portraitH/2, portraitX + portraitW/2, portraitY + portraitH/2, radius, radius, false);
	
////	shader_set() non-black outliner here?
//	draw_sprite_ext(cur_portrait, image_index, portraitX, portraitY, 1, 1, 0, c_white, 1);
//}


/*var vw = display_get_gui_width();
var vh = display_get_gui_height();

var _x = vw/2;
var _y = vh/2;

//Draw textbox
draw_set_colour($936969);
draw_rectangle(_x, _y, _x + textbox_width + 20, _y + textbox_height + 20, false);
draw_set_colour(c_white);

//Draw main text body
//Note that we're setting "textbox_element" here
textbox_element = scribble(textbox_conversation[textbox_conversation_index])
.wrap(textbox_width, textbox_height)
.typewriter_in(textbox_skip? 9999 : 1, 0)
.draw(_x + 10, _y + 10);

//Draw portrait
draw_set_colour($936969);
draw_rectangle(_x + textbox_width + 30, _y, _x + textbox_width + textbox_height + 50, _y + textbox_height + 20, false);
draw_set_colour(c_white);

if (sprite_exists(textbox_portrait))
{
    draw_sprite(textbox_portrait, 0, _x + textbox_width + 40, _y + 10);
}

//Draw a little icon once the text has finished displaying, or if text display is paused
if ((textbox_element.get_typewriter_state() >= 1) || textbox_element.get_typewriter_paused())
{
    draw_sprite(spr_white_coin, 0, _x + textbox_width + 20, _y + textbox_height + 20);
}

if (textbox_name != undefined)
{
    //Draw name tag
    var _element = scribble(textbox_name).align(fa_right, fa_bottom);
    var _name_box = _element.get_bbox(_x + textbox_width + 10, _y - 20, 10, 10, 10, 10);
    
    draw_set_colour($936969);
    draw_rectangle(_name_box.left, _name_box.top, _name_box.right, _name_box.bottom, false);
    draw_set_colour(c_white);
    
    _element.draw(_x + textbox_width + 10, _y - 20);
}





//Normal build text box stuff below--------------------------------------------------




/*var guiW = display_get_gui_width();
var guiH = display_get_gui_height();

var textbox_w = guiW * 1/3;
var textbox_h = guiH * 3/10;

var midX = guiW/2;
var midY = textbox_h * 5/8;

var margin = textbox_w/24;
var radius = 13;
var borderWidth = 4;

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
var textSectionW = text_wrap_x == -1 ? textbox_w : text_wrap_x;
var textSectionH = 2000;
//var maxTextWidth = textSectionW - 2*margin;
//var fontSep = string_height("AAA");
//var curTextHeight = string_height_ext(cur_text, fontSep, maxTextWidth);

//var textX = midX + textbox_w/2 - textSectionW/2;
//var textY = midY;

var textX = x;
var textY = y;

//Note that we're setting "textbox_element" here
textbox_element = scribble(textbox_conversation[textbox_conversation_index])
.wrap(textSectionW, textSectionH)
.align(fa_center, fa_middle)
.typewriter_in(textbox_skip? 9999 : text_spd, text_fade_factor)
.draw(textX, textY);

if global.start_paused textbox_element.typewriter_pause();

//var main_text_bbox = textbox_element.get_bbox(textX, textY, 10, 10, 10, 10);
//var main_text_end_x = textbox_element.get_width();

//Draw a little icon once the text has finished displaying, or if text display is paused
//if ((textbox_element.get_typewriter_state() >= 1) || textbox_element.get_typewriter_paused())
//{
//    draw_sprite(spr_white_coin, 0, midX + textbox_w/2 - margin/2, midY + textbox_h/2 - margin/2);
//}


//Title
//draw_set_font(fnt_title);
//draw_set_color(cur_title_col);
//draw_text_ext(textX, textY-textbox_h/2+margin, cur_title, string_height("AAA"), 500);

if (textbox_title != undefined) {
    var _element = scribble(textbox_title).align(fa_center, fa_middle);
    var _name_box = _element.get_bbox(textX, textY-textbox_h/2+margin, 10, 10, 10, 10);
    
    draw_set_colour($936969);
    draw_rectangle(_name_box.left, _name_box.top, _name_box.right, _name_box.bottom, false);
    draw_set_colour(c_white);
    
    _element.draw(textX, textY-textbox_h/2+margin);
}

////Portrait
//var portraitSectionWidth = textbox_w * 5/16;
//var portraitX = midX - textbox_w/2 + portraitSectionWidth/2;
//var portraitY = midY;

//if (sprite_exists(cur_portrait)) {
//	var portraitW = sprite_get_width(cur_portrait);
//	var portraitH = sprite_get_height(cur_portrait);
	
//	draw_set_color(merge_color(c_white, $936969, 0.6));
//	draw_roundrect_ext(portraitX - portraitW/2, portraitY - portraitH/2, portraitX + portraitW/2, portraitY + portraitH/2, radius, radius, false);
	
////	shader_set() non-black outliner here?
//	draw_sprite_ext(cur_portrait, image_index, portraitX, portraitY, 1, 1, 0, c_white, 1);
//}


/*var vw = display_get_gui_width();
var vh = display_get_gui_height();

var _x = vw/2;
var _y = vh/2;

//Draw textbox
draw_set_colour($936969);
draw_rectangle(_x, _y, _x + textbox_width + 20, _y + textbox_height + 20, false);
draw_set_colour(c_white);

//Draw main text body
//Note that we're setting "textbox_element" here
textbox_element = scribble(textbox_conversation[textbox_conversation_index])
.wrap(textbox_width, textbox_height)
.typewriter_in(textbox_skip? 9999 : 1, 0)
.draw(_x + 10, _y + 10);

//Draw portrait
draw_set_colour($936969);
draw_rectangle(_x + textbox_width + 30, _y, _x + textbox_width + textbox_height + 50, _y + textbox_height + 20, false);
draw_set_colour(c_white);

if (sprite_exists(textbox_portrait))
{
    draw_sprite(textbox_portrait, 0, _x + textbox_width + 40, _y + 10);
}

//Draw a little icon once the text has finished displaying, or if text display is paused
if ((textbox_element.get_typewriter_state() >= 1) || textbox_element.get_typewriter_paused())
{
    draw_sprite(spr_white_coin, 0, _x + textbox_width + 20, _y + textbox_height + 20);
}

if (textbox_name != undefined)
{
    //Draw name tag
    var _element = scribble(textbox_name).align(fa_right, fa_bottom);
    var _name_box = _element.get_bbox(_x + textbox_width + 10, _y - 20, 10, 10, 10, 10);
    
    draw_set_colour($936969);
    draw_rectangle(_name_box.left, _name_box.top, _name_box.right, _name_box.bottom, false);
    draw_set_colour(c_white);
    
    _element.draw(_x + textbox_width + 10, _y - 20);
}