shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform float wave_speed = 1.0;
uniform float wave_amplitude = 0.03;
uniform float wave_frequency = 3.0;
uniform float pixel_size = 4.0;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 screen_size = vec2(1152.0, 648.0);
    
    // Pixelado
    uv = floor(uv * screen_size / pixel_size) * pixel_size / screen_size;
    
    // Olas individuales
    float wave = sin(uv.y * wave_frequency - TIME * wave_speed);
    wave = smoothstep(0.8, 1.0, wave);
    
    uv.x += wave * wave_amplitude;
    uv.y += wave * wave_amplitude * 0.5;
    
    // Aberración cromática
	vec3 color = texture(SCREEN_TEXTURE, uv).rgb;
	color.r = texture(SCREEN_TEXTURE, uv + vec2(0.003 * wave, 0.0)).r;
	color.b = texture(SCREEN_TEXTURE, uv - vec2(0.003 * wave, 0.0)).b;
    
    COLOR = vec4(color, 1.0);
}