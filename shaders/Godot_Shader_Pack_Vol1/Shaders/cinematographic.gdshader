shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_nearest;
uniform float pixel_size = 3.0;
uniform float vignette_intensity = 0.5;
uniform float grain_intensity = 0.04;
uniform float bars_size = 0.1;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 screen_size = vec2(1152.0, 648.0);
    
    // Pixelado
    vec2 pixelated_uv = floor(uv * screen_size / pixel_size) * pixel_size / screen_size;
    vec3 color = texture(SCREEN_TEXTURE, pixelated_uv).rgb;
    
    // Barras negras cinematográficas arriba y abajo
    if (uv.y < bars_size || uv.y > 1.0 - bars_size) {
        color = vec3(0.0);
    }
    
    // Viñeta
    vec2 vig_uv = uv * (1.0 - uv.yx);
    float vignette = vig_uv.x * vig_uv.y * 15.0;
    vignette = pow(vignette, vignette_intensity);
    color *= vignette;
    
    // Grano de película
    float grain = fract(sin(dot(pixelated_uv + TIME * 0.05, vec2(127.1, 311.7))) * 43758.5453);
    color += (grain - 0.5) * grain_intensity;
    
    // Tono ligeramente frío/azulado cinematográfico
    color.r *= 0.95;
    color.g *= 0.98;
    color.b *= 1.05;
    
    COLOR = vec4(color, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
