// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function sound_play_random_pitch(sounds_array, min_pitch, max_pitch){
	var ran_snd = sounds_array[irandom(array_length(sounds_array)-1)];
	var snd = audio_play_sound(ran_snd, 4, false);
	
	audio_sound_pitch(snd, random_range(min_pitch, max_pitch));
	audio_sound_gain(snd, global.audio_FX_level * (room == rm_level_select ? 0.5 : 1), 0);
	
	return(snd);
}