shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform float pixel_size = 4.0;
uniform float glitch_intensity = 0.02;
uniform float glitch_speed = 5.0;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 screen_size = vec2(1152.0, 648.0);
    
    // Pixelado
    vec2 pixelated_uv = floor(uv * screen_size / pixel_size) * pixel_size / screen_size;
    
    // Glitch - desplazamiento horizontal aleatorio por líneas
    float line = floor(pixelated_uv.y * screen_size.y / pixel_size);
    float noise = fract(sin(line * 127.1 + TIME * glitch_speed) * 43758.5453);
    float noise2 = fract(sin(line * 311.7 + TIME * glitch_speed * 0.7) * 12345.678);
    
    float offset = 0.0;
    if (noise > 0.85) {
        offset = (noise2 - 0.5) * glitch_intensity;
    }
    
    vec2 glitch_uv = pixelated_uv + vec2(offset, 0.0);
    vec4 color = texture(SCREEN_TEXTURE, glitch_uv);
    
    // Separación RGB en zonas glitcheadas
    if (abs(offset) > 0.0) {
        color.r = texture(SCREEN_TEXTURE, glitch_uv + vec2(0.005, 0.0)).r;
        color.b = texture(SCREEN_TEXTURE, glitch_uv - vec2(0.005, 0.0)).b;
    }
    
    COLOR = color;
}