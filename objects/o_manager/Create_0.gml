/// @description

enum game_state {
	playing,
	win,
	paused,
	lost,
	level_select,
	main_menu,
	options,
	credits
}

enum paused_options {
	resume,
	level_select,
	options,
	exit_game,
	LAST
}

enum main_menu_options {
	level_select,
	options,
	credits,
	exit_game,
	LAST
}

enum options {
	back,
	master_sound,
	FX_sound,
	music_sound,
	buffer_time,
	grid_toggle,
	color_mode,
	fullscreen,
	LAST
}

image_alpha = 0;

credits_text = "Thank you for playing. :)\nAll programming, design, and art by Roey Shapiro. Conceived in approximately 25 hours over the course of a week (March 5th 2021 to March 12th 2021) and improved over the course of the next few weeks here and there. \n\nMusic:\n'Steffen Daum - Goodbye My Dear' is under a Creative Commons license (CC-BY 3.0) Music promoted by BreakingCopyright: https://bit.ly/b-goodbye-dear, Mendelssohn's Symphony No. 4 in A Major (Italian), MOVEMENT II, Op. 90,	Allemande by Wahneta Meixsell Creative Commons — Attribution 3.0 Unported— CC BY 3.0 https://creativecommons.org/licenses/by/3.0/ Music provided by FreeMusic109 https://youtube.com/FreeMusic109";

if CAN_SCRIBBLE {
	
	var w = display_get_gui_width();
	var h = display_get_gui_height();
	
	var titlew = w/2;
	var titleh = h/2;
	
	title_scribble = scribble("[/font][pulse][wave]Snecca")
			.starting_format("fnt_snecca", global_color(SNAKE_COLOR))
			.align(__SCRIBBLE_PIN_CENTRE, fa_middle) // fa_right and fa_center don't work with bezier
			.typewriter_in(0.25, 6)
			.bezier(-titlew/2, titleh/2, -titlew/2, -titleh/2, 
					titlew/2, -titleh/2, titlew/2, titleh/2)
			.animation_pulse(0.1, 0.05)
			.animation_wave(5, 1.1, 0.08);
			
	credits_scribble = scribble("[/c][/font]" + credits_text)
	.starting_format("fnt_medium_large", c_white)
	.align(fa_center, fa_middle)
	.wrap(w * 3/4, h * 3/4)
	
} else {
//	title_scribble_parsed_text_array = parse_scribble_text("Snecca");
}

state = game_state.main_menu;
pause_sprite = noone;
surf = noone;
option_index = 0;
editing_audio = false;
audio_edit_option = 1; //it'll start in the middle
music_level = 1; //the manager's special effects on the music
editing_buffer_time = false;
in_options_menu_paused = false;
return_state = game_state.main_menu;

intro_timer = 0;
intro_time = 60 * 2;
just_transitioned = true;	//act as if you just came into a room upon beginning
cam = noone;
last_hinput = 0;
last_vinput = 0;



music_list = [
	snd_BG_music0,
	snd_BG_music1,
	snd_BG_main_menu
]


button_jump_timer = 0;
button_jump_time = 8;


levels = [
//	[room_id, title, addition to progression, music track, section]
	[rm_level_normal_snake, "Just Snake", 1, 0, colors.sec1],
	
	[rm_level_intro_true, "Just Snake", 1, 0, colors.sec1],			
	[rm_level_intro_apple, "Tradition", 1, 0, colors.sec1],			
	
	[rm_level_intro_pit_0, "Falling", 1, 0, colors.sec1],
	[rm_level_intro_pit_1, "Footsteps in the Sand", 1, 0, colors.sec1],
	
	[rm_level_intro_door_0, "Long Key", 1, 0, colors.sec1],			
	[rm_level_intro_bite_0, "No Convention", 1, 0, colors.sec1],	
	[rm_level_intro_door_1, "Cannibal", 1, 0, colors.sec1],	
//	[rm_level_intro_door_2, "Regrets", 1, 0],
	[rm_level_intro_door_3, "Add and Subtract", 2, 0, colors.sec1],
	[rm_level_intro_door_4, "Greed", 0, 0, colors.sec1],
		
	[rm_level_intro_char, "Snakey-back Ride", 1, 0, colors.sec1],			
	[rm_level_intro_death, "Run-up", 1, 0, colors.sec1],			
	[rm_level_intro_example_1, "Drop-off", 1, 0, colors.sec1],		
	
	//---------------

	[rm_level_mec_push_0, "Pushed", 1, 0, colors.sec2],
	[rm_level_mec_push_1, "Rear-ended", 1, 0, colors.sec2],
	[rm_level_mec_push_2, "Roadtrip", 1, 0, colors.sec2],
	[rm_level_mec_push_apple_0, "Redirection", 1, 0, colors.sec2],
	[rm_level_mec_push_apple_1, "Oscillator", 2, 0, colors.sec2],
	[rm_level_mec_push_apple_2, "Assistance", 0, 0, colors.sec2],
	
	//-----------------------
	
	[rm_level_mec_bomb_0, "Explosive", 1, 1, colors.sec3],
	[rm_level_mec_bomb_1, "Protector", 1, 1, colors.sec3],
	[rm_level_mec_laser_0, "Watch it!", 1, 1, colors.sec3],
	[rm_level_mec_laser_1, "Crossfire", 1, 1, colors.sec3],
	[rm_level_mec_laser_3, "Knocked Off the Pedestal", 1, 1, colors.sec3],		//order switch is deliberate
	[rm_level_mec_laser_2, "Thrown Under the Bus", 8, 1, colors.sec3],			
	[rm_level_mec_laser_4, "Bridge for the Cannons", 0, 1, colors.sec3],				
	[rm_level_mec_laser_5, "Command Center", 0, 1, colors.sec3],		
	
	//-----------------------
	
	[rm_level_too_short_0, "Too Short", 0, 1, colors.sec4],
	[rm_level_inverse_door_0, "Inversion", 0, 1, colors.sec4],
	[rm_level_inverse_door_1, "One-way", 0, 1, colors.sec4],
	[rm_level_destroy_apple_0, "Break", 0, 1, colors.sec4],
	[rm_level_destroy_apple_1, "Stoplight", 0, 1, colors.sec4],
		
	//-----------------------

	[rm_level_intro_finale_1, "Approaching", 1, 0, colors.sec4],
	[rm_level_intro_finale_2, "Revolution", 1, 0, colors.sec4],
	[rm_level_intro_finale_3, "Not Snake", 1, 0, colors.sec4],
]

level_num = array_length(levels);

level_index = 0;
level_select_index = 0;

function get_point_to_draw_level_connections(index) {
	var xpos = index % gridw;
	var ypos = floor(index/gridw);
	var odd_row = ypos % 2 == 1;
	var w_unit = levelw + bufferw;
	var h_unit = levelh + bufferh;
	var grid_total_width = (levelw*gridw) + (bufferw*(gridw-1));
	
	if odd_row {
		return [grid_total_width - ((xpos * w_unit) + levelw/2),
				(ypos * h_unit) + levelh/2];
	} else {
		return [(xpos * w_unit) + levelw/2,
				(ypos * h_unit) + levelh/2];
	}
}

transition_timer = 0;
undo_button = vk_lshift;
restart_key = ord("R");


step_progress_buttons = [
	ord("W"),
	ord("A"),
	ord("S"),
	ord("D"),
	vk_space,	//for waiting without taking a turn as the snake
	vk_left,
	vk_right,
	vk_up,
	vk_down

]

gridw = 10;
gridh = 5;

levelw = 136;
levelh = levelw;
bufferw = levelw * 0.2;
bufferh = levelh * 0.2;

level_select_x = 0;
level_select_y = 0;

room_state_data = -1;

room_goto(rm_level_select);