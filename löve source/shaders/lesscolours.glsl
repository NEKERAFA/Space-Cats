vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
	vec4 pixel = Texel(texture, texture_coords);
	
	if(pixel.r < 0.3) pixel.r = 0;
	else if(pixel.r < 0.6) pixel.r = 0.5;
	else pixel.r = 1;
	
	if(pixel.g < 0.3) pixel.g = 0;
	else if(pixel.g < 0.6) pixel.g = 0.5;
	else pixel.g = 1;
	
	if(pixel.b < 0.3) pixel.b = 0;
	else if(pixel.b < 0.6) pixel.b = 0.5;
	else pixel.b = 1;
	
	return pixel;
}