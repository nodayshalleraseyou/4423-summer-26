shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_nearest;
uniform float pixel_size = 3.0;
uniform float sway_speed = 1.2;
uniform float sway_amount = 0.015;
uniform float aberration = 0.008;
uniform float saturation = 2.5;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 screen_size = vec2(1152.0, 648.0);
    
    // Pixelado
    vec2 pixelated_uv = floor(uv * screen_size / pixel_size) * pixel_size / screen_size;
    
    // Balanceo borracho
    pixelated_uv.x += sin(pixelated_uv.y * 3.0 + TIME * sway_speed) * sway_amount;
    pixelated_uv.y += cos(pixelated_uv.x * 2.0 + TIME * sway_speed * 0.7) * sway_amount * 0.5;
    
    // Aberración cromática
    vec3 color;
    color.r = texture(SCREEN_TEXTURE, pixelated_uv + vec2(aberration, 0.0)).r;
    color.g = texture(SCREEN_TEXTURE, pixelated_uv).g;
    color.b = texture(SCREEN_TEXTURE, pixelated_uv - vec2(aberration, 0.0)).b;
    
    // Saturación exagerada
    float gray = dot(color, vec3(0.299, 0.587, 0.114));
    color = mix(vec3(gray), color, saturation);
    
    // Viñeta pulsante
    vec2 vig_uv = uv * (1.0 - uv.yx);
    float vignette = pow(vig_uv.x * vig_uv.y * 15.0, 0.3 + sin(TIME * 1.5) * 0.1);
    color *= vignette;
    
    COLOR = vec4(color, 1.0);
}