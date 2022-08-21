/// @description Parse Text


/*
At the beginning of a frame, having received specific text, we parse the text for tags and place each group of tagged text together.

We make an array, each cell responsible for representing a chunk of text.
One "chunk" is simply a certain combinations of tags, which we'll update as we run along.
Each chunk will be comprised of an array containing the string and an array of the tags applied.
Given a certain width, we'll also insert \n after the last space which fits within the horizontal bounds

When drawing text, we then go chunk by chunk, drawing each character individually with the tags in place.
*/

if !have_parsed_text and tagged_text != "" {
	have_parsed_text = true;
	parsed_text_array = parse_scribble_text(tagged_text);
} 