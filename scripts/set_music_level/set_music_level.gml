
function set_music_level(level) {
	var tracks = array_length(music_list);
	for (var m = 0; m < tracks; m++){
		var cur = music_list[m];
		if audio_is_playing(cur){
			audio_sound_gain(cur, level * global.audio_music_level, 500); //milliseconds to fade in/out
		}
	}
}