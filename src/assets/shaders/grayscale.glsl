// Set grayscale color

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
	// Get texture color
	vec4 texture_color = Texel(texture, texture_coords);
	
	// LUMA correction
	float gray = 0.299 * texture_color.r + 0.587 * texture_color.g + 0.114 * texture_color.b;
	
	// float gray = (texture_color.r + texture_color.g + texture_color.b) / 3;
	
	vec4 texture_gray = vec4(gray, gray, gray, texture_color.a);
	return texture_gray * color;
}