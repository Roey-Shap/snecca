/// @description

starting_length = 4;
cur_length = 1;		//tracks the total number body parts
last_direction = image_angle;
last_input_direction = last_direction;
image_angle = 0;

switch_dir = 0;

overlap = 1;
overlapx = -1;
overlapy = -1;

//init_x = x;
//init_y = y;
head_x = x;
head_y = y;

//get out of the way while retaining collision box
x = -100;
y = -100;

last_hinput = 0;
last_vinput = 0;
horizontal = 0;

moved_once = false;

normal_snake_mode_timer = 0;

//--------------------
body_parts_grid = ds_grid_create(5, cur_length);
//Grid has x, y, rotation, type


make_head(head_x, head_y);

//--------------------

right_key	= ord("D"); 
left_key	= ord("A");
up_key		= ord("W");
down_key	= ord("S");

dummy_mode = false;

//---------------
//Sounds

step_sounds = [snd_step_2];

