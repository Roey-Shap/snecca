/// @description

if global.debug {
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(fnt_large);
	draw_set_color(c_white);
	
	draw_text(24, 24, "Chunks: " + string(array_length(parsed_text_array)));
}