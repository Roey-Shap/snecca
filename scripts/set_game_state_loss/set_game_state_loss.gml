// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function set_game_state_loss(shake_bool){

	with(o_manager){
		if state != game_state.lost {
			state = game_state.lost;
			transition_timer = 15;
		
			if shake_bool screen_shake(random_range(2, 3.5), random_range(2, 3.5), 20);
			sound_play_random_pitch([snd_loss], 0.925, 1.075);
			set_music_level(1 / 5); //fade out a lot
		}
	}
}