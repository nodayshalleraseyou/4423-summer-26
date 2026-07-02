shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_nearest;
uniform float pixel_size = 3.0;
uniform float fractal_intensity = 0.02;
uniform float fractal_speed = 0.5;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 screen_size = vec2(1152.0, 648.0);
    
    // Pixelado
    vec2 pixelated_uv = floor(uv * screen_size / pixel_size) * pixel_size / screen_size;
    
    // Distorsión fractal
    vec2 p = pixelated_uv * 2.0 - 1.0;
    for (int i = 0; i < 4; i++) {
        p = abs(p) / dot(p, p) - 1.0 + sin(TIME * fractal_speed) * 0.1;
    }
    
    vec2 distorted_uv = pixelated_uv + p * fractal_intensity;
    vec3 color = texture(SCREEN_TEXTURE, distorted_uv).rgb;
    
    float t = length(p) * 0.5 + TIME * 0.2;
vec3 rainbow = vec3(
    sin(t) * 0.5 + 0.5,
    sin(t + 2.094) * 0.5 + 0.5,
    sin(t + 4.188) * 0.5 + 0.5
);

color = mix(color, rainbow, 0.4);

COLOR = vec4(color, 1.0);
}