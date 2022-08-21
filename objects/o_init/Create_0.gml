/// @description

randomize();
randomize();

var file_data = read_save_data();

global.debug = false;
global.fullscreen = file_data[7];
global.show_grid = file_data[4];
global.step = false;
global.step_input = 0;
global.buffer_amount = file_data[5];
global.undo = false;
audio_set_master_gain(0, file_data[0]);
global.audio_music_level = file_data[2];
global.audio_FX_level = file_data[1];
global.start_paused = false;
global.max_unlocked_level = file_data[3];

global.vanilla_snake_mode = false;
global.snake_mode_step_time = 22;	// make it slow enough for them to comfortably read the text
global.vanilla_snake_rooms = [
	rm_level_normal_snake,
]

//Colors	===================		=================

var temp_snake_col = GM_hex_convert($99CCFF);
var temp_char_col = GM_hex_convert($F37B61);
var temp_hurt_col = GM_hex_convert($CC104B);
global.color_palette_index = file_data[6];
global.color_palettes = [
	//name		white		black		snake		character		cheese						destroy					hurt					floor
	["Default", c_white, c_black, temp_snake_col, temp_char_col, GM_hex_convert($FFC700), GM_hex_convert($8C431C), temp_hurt_col, GM_hex_convert($232323),
	//			// sec 1									sec2									
				c_white,				merge_color(c_white, temp_snake_col, 0.7), 
				// sec 3									// sec4
				merge_color(c_white, temp_char_col, 0.7), merge_color(c_white, temp_hurt_col, 0.7), 
				// sec 5
				GM_hex_convert($ccffcc)],
	//no red light - use blues and yellows
	["High Contrast", c_white, c_black, c_lime, c_yellow, c_fuchsia, c_orange, c_maroon, c_white,     c_white, c_white, c_white, c_white, c_white],
	//no green light - use blues and yellows
	//["Deuteranopia", c_white, c_black, c_lime, c_yellow, c_fuchsia, c_orange, c_maroon],
	////no red light
	//["Tritanopia", c_white, c_black, c_lime, c_yellow, c_fuchsia, c_orange, c_maroon],
	
	//["Test", c_white, c_black, c_lime, c_yellow, c_fuchsia, c_orange, c_maroon],

]

var p = global.color_palettes[0];
var high_contrast = global.color_palettes[1];
for (var c = 0; c < colors.LAST; c++){
	var col = p[c+1];
	var hue = color_get_hue(col);
	var sat = color_get_saturation(col);
	var val = color_get_value(col);
	
	high_contrast[c+1] = make_color_hsv(hue, min(sat*2, 255), val * 1.2);
}
global.color_palettes[1] = high_contrast;

global.color_palette = global.color_palettes[global.color_palette_index];



enum colors {
	white,
	black,
	snake,
	character,
	cheese,
	destroy,
	hurt,
	FLOOR,
	sec1,
	sec2,
	sec3,
	sec4,
	LAST
}



global.button_text = vk_space;

//Macros and Other Setup		============================


#macro SCREEN_W 960
#macro SCREEN_H 540
#macro CX (x + (CELL_W/2))
#macro CY (y + (CELL_H/2))

#macro CELL_W 32
#macro CELL_H 32

#macro NORTH 1
#macro WEST 2
#macro EAST 4
#macro SOUTH 8

#macro LAYER_COLLISION_TILES "Collision_Tiles"

#macro SNAKE_COLOR colors.snake
#macro CHAR_COLOR colors.character
#macro CHEESE_COLOR colors.cheese
#macro DESTRUCTIBLE_COLOR colors.destroy
#macro HURT_COLOR colors.hurt
#macro FLOOR_COLOR colors.FLOOR



//#macro SNAKE_COLOR GM_hex_convert($99CCFF)
//#macro CHAR_COLOR GM_hex_convert($F37B61)
//#macro CHEESE_COLOR GM_hex_convert($FFC700)
//#macro DESTRUCTIBLE_COLOR GM_hex_convert($8C431C)
//#macro HURT_COLOR GM_hex_convert($CC104B)

//Making the sprites for the tilemaps from the images
//temp = surface_create(sprite_get_width(spr_tiles_floor_barrier_1), 
//							sprite_get_height(spr_tiles_floor_barrier_1));

//global.tilemap_centers = ds_map_create();
//var map = global.tilemap_centers;
//ds_map_add(map, spr_tiles_floor_barrier_1, -1);
//ds_map_add(map, spr_tiles_floor_basic, -1);
//ds_map_add(map, spr_tiles_floor_break_basic, -1);
//global.tilemap_centers[? sprite_get_name(spr_tiles_floor_barrier_1)] = 

made_tilemap_centers = false;

#macro WEB_BUILD false
#macro WEB:WEB_BUILD true
#macro DEVELOPER_WEB:WEB_BUILD true

#macro CAN_SCRIBBLE true
#macro WEB:CAN_SCRIBBLE false
#macro DEVELOPER_WEB:CAN_SCRIBBLE false

#macro CAN_DEBUG false
#macro DEVELOPER:CAN_DEBUG true
#macro DEVELOPER_WEB:CAN_DEBUG true


if CAN_SCRIBBLE {

	global.__scribble_colours[? "c_snake" ] = global_color(SNAKE_COLOR);
	global.__scribble_colours[? "c_character" ] = global_color(CHAR_COLOR);
	global.__scribble_colours[? "c_cheese" ] = global_color(CHEESE_COLOR);
	global.__scribble_colours[? "c_hurt" ] = global_color(HURT_COLOR);


	scribble_font_set_default("fnt_regular");
	scribble_font_add("fnt_regular");
	scribble_font_add("fnt_medium_large");
	scribble_font_add("fnt_snecca");
	
	scribble_typewriter_add_character_delay(".", 110);
	scribble_typewriter_add_character_delay(",", 90);
	//scribble_font_add_all
	//scribble_font_set_style_family("fnt_style", "fnt_style_b", "fnt_style_i", "fnt_style_bi");

	//scribble_typewriter_add_event("portrait", example_dialogue_set_portrait);
	//scribble_typewriter_add_event("name", example_dialogue_set_name);

	var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
	//scribble_font_add_from_sprite("spr_sprite_font", _mapstring, 0, 3);
} else {
	
		// Shaderless Scribble		=============================

	global.text_font = fnt_regular;
	draw_set_font(global.text_font);
	global.char_w = string_width("A");
	global.char_h = string_height("AAA");


	enum tags {
		color,			//change to specified color
		jitter,			//jitters the letters around in place
		wave,			//throws letters around to form a wave
		pulse,			//ebbs the size of letters in and out
		shake,
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
		["c_snake", global_color(SNAKE_COLOR)],
		["c_character", global_color(CHAR_COLOR)],
		["c_cheese", global_color(CHEESE_COLOR)],		
		["c_hurt", global_color(HURT_COLOR)],		
	]

}


