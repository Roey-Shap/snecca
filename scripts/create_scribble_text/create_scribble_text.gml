// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function create_scribble_text(text){
	
	var guiW = display_get_gui_width();
	var guiH = display_get_gui_height();

	var textbox_w = guiW * 1/3;
	var textbox_h = guiH * 3/10;

	var midX = guiW/2;
	var midY = textbox_h * 5/8;

	var margin = textbox_w/24;
	var radius = 13;
	var borderWidth = 4;

	textSectionW = text_wrap_x < 0 ? textbox_w : text_wrap_x;
	
	textSectionH = 2000;


//	textbox_element.flush();
	//Note that we're setting "textbox_element" here after having gotten the correct text
	textbox_element = scribble(text)
	.starting_format("fnt_regular", c_white)
	.wrap(textSectionW, textSectionH)
	.align(fa_center, fa_middle)
	.animation_pulse(0.1, 0.05)
	.animation_wave(0.95, 1.2, 0.3)
	.animation_wheel(0.5, 0.5, 0.25)
	.animation_shake(0.9, 0.6);
	
	textbox_element.build();
	
	//- [`.animation_tick_speed(tickSpeed)`](scribble()-Methods#animation_tick_speedtickspeed)
    //- [`.animation_sync(sourceElement)`](scribble()-Methods#animation_syncsourceelement)
    //- [`.animation_wave(size, frequency, speed)`](scribble()-Methods#animation_wavesize-frequency-speed)
    //- [`.animation_shake(size, speed)`](scribble()-Methods#animation_shakesize-speed)
    //- [`.animation_rainbow(weight, speed)`](scribble()-Methods#animation_rainbowweight-speed)
    //- [`.animation_wobble(angle, frequency)`](scribble()-Methods#animation_wobbleangle-frequency)
    //- [`.animation_pulse(scale, speed)`](scribble()-Methods#animation_pulsescale-speed)
    //- [`.animation_wheel(size, frequency, speed)`](scribble()-Methods#animation_wheelsize-frequency-speed)
    //- [`.animation_cycle(speed, saturation, value)`](scribble()-Methods#animation_cyclespeed-saturation-value)
    //- [`.animation_jitter(minScale, maxScale, speed)`](scribble()-Methods#animation_jitterminscale-maxscale-speed)
    //- [`.animation_blink(onDuration, offDuration, timeOff
	
	return(textbox_element);
}