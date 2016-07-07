// Blend effect

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
	//This is the current pixel color
	vec4 pixel = Texel(texture, texture_coords);
	pixel.a = (pixel.a+color.a)/2.0;
	return pixel;
}