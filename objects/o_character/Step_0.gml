/// @description


switch(walk_dir){
	case 0:
		sprite_index = spr_character_moving_right;
		image_xscale = 1;
	break;
	
	case 90:
		sprite_index = spr_character_moving_up;
	break;
	
	case 180:
		sprite_index = spr_character_moving_left;	
	break;
	
	case 270:
		sprite_index = spr_character_moving_down;
	break;
	
}