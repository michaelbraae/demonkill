shader_type canvas_item;

uniform sampler2D NOISE_PATTERN;

void fragment() {
	vec4 curr_color = texture(TEXTURE, UV); // Get current color of pixel
	
	vec2 uv = vec2(UV.x, UV.y + TIME * 0.05);
	
	vec4 noise_color = texture(NOISE_PATTERN, uv);
	
	vec3 output_color = mix(noise_color.rgb, curr_color.rgb, 0.3);
	
	float noise_r = 0.0;
	float noise_g = 0.0; 
	float noise_b = output_color.b * 1.7;
	
	vec3 new_color = vec3(noise_r, noise_g, noise_b);
	
	COLOR.rgb = new_color;
	COLOR.a = texture(TEXTURE, UV).a;
}
