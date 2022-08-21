// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
///@description Returns a GM-compatible BGR-coded color with HEX as input
function GM_hex_convert(HEX_color){
	//https://forum.yoyogames.com/index.php?threads/converting-hex-into-rgb-values.53701/
	var color = ((HEX_color&$FF)<<16)|(HEX_color&$FF00)|(HEX_color>>16);
	return(color);
}