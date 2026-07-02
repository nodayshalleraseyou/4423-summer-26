shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_nearest;
uniform float pixel_size = 3.0;
uniform float breath_speed = 0.6;
uniform float breath_intensity = 0.04;
uniform float distortion_strength = 0.08;
uniform float dissociation = 0.3;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 screen_size = vec2(1152.0, 648.0);
    
    // Respiración
    vec2 centered = uv - 0.5;
    centered *= 1.0 + sin(TIME * breath_speed) * breath_intensity;
    uv = centered + 0.5;
    
    // Distorsión gravitacional tipo black hole
    vec2 delta = uv - 0.5;
    float dist = length(delta);
    float gravity = distortion_strength / (dist * dist + 0.1);
    uv = uv - normalize(delta) * gravity * 0.02;
    
    // Disociación — imagen fantasma desplazada
    vec2 ghost_uv = uv + vec2(sin(TIME * 0.3) * 0.02, cos(TIME * 0.2) * 0.02);
    
    // Pixelado
    vec2 pixelated_uv = floor(uv * screen_size / pixel_size) * pixel_size / screen_size;
    vec2 ghost_pixelated = floor(ghost_uv * screen_size / pixel_size) * pixel_size / screen_size;
    
    vec3 color = texture(SCREEN_TEXTURE, pixelated_uv).rgb;
    vec3 ghost = texture(SCREEN_TEXTURE, ghost_pixelated).rgb;
    
    // Mezcla con imagen fantasma
    color = mix(color, ghost, dissociation);
    
    // Visión de perro — azul y amarillo
    float gray = dot(color, vec3(0.299, 0.587, 0.114));
    float warm = dot(color, vec3(0.5, 0.4, 0.1));
    float cool = dot(color, vec3(0.1, 0.2, 0.5));
    
    vec3 dog_color = mix(
        vec3(0.1, 0.1, 0.6),
        vec3(0.7, 0.7, 0.1),
        warm / (warm + cool + 0.001)
    );
    dog_color = mix(vec3(gray), dog_color, 0.7);
    
    COLOR = vec4(dog_color, 1.0);
}