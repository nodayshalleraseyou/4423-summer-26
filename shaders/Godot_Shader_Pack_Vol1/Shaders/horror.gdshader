shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_nearest;
uniform float pixel_size = 3.0;
uniform float pulse_speed = 1.5;
uniform float desaturation = 0.8;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 screen_size = vec2(1152.0, 648.0);
    
    // Pixelado
    vec2 pixelated_uv = floor(uv * screen_size / pixel_size) * pixel_size / screen_size;
    vec3 color = texture(SCREEN_TEXTURE, pixelated_uv).rgb;
    
    // Desaturación
    float gray = dot(color, vec3(0.299, 0.587, 0.114));
    color = mix(color, vec3(gray), desaturation);
    
    // Tono rojizo sutil
    color.r *= 1.15;
    color.b *= 0.85;
    
    // Viñeta agresiva pulsante
    vec2 vig_uv = uv * (1.0 - uv.yx);
    float vignette = pow(vig_uv.x * vig_uv.y * 15.0, 0.8 + sin(TIME * pulse_speed) * 0.3);
    color *= vignette;
    
    // Grano de miedo
    float grain = fract(sin(dot(pixelated_uv + TIME * 0.05, vec2(127.1, 311.7))) * 43758.5453);
    color += (grain - 0.5) * 0.05;
    
    COLOR = vec4(color, 1.0);
}