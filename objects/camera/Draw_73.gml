if fade_timer > 0 {
	if fade == 0 {
		draw_set_color(c_black);
		draw_set_alpha((2*fade_timer/45));
		draw_rectangle(x-camwidth, y-camheight, x+camwidth, y+camheight, false);
		draw_set_alpha(1);
	} else {
		draw_set_color(c_black);
		draw_set_alpha(1-(fade_timer/45));
		draw_rectangle(x-camwidth, y-camheight, x+camwidth, y+camheight, false);
		draw_set_alpha(1);
	}
}