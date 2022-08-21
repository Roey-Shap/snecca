/// @description

//regenerate any non-existant parts 
starting_length = cur_length;

if cur_length == 0 {
	set_game_state_loss(false);
	make_death_FX(head_x, head_y);
	instance_destroy(id);
}