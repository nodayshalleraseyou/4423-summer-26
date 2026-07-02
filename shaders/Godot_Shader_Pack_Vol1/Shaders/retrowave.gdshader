shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_nearest;
uniform float pixel_size = 6.0;
uniform float color_levels = 4.0;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 screen_size = vec2(1152.0, 648.0);
    
    // Pixelado fuerte
    vec2 pixelated_uv = floor(uv * screen_size / pixel_size) * pixel_size / screen_size;
    vec3 color = texture(SCREEN_TEXTURE, pixelated_uv).rgb;
    
    // Reducir colores tipo paleta limitada
    color = floor(color * color_levels) / color_levels;
    
    // Paleta años 80 — morado, naranja, azul
    float brightness = dot(color, vec3(0.299, 0.587, 0.114));
    
    vec3 dark = vec3(0.2, 0.0, 0.4);    // morado oscuro
    vec3 mid = vec3(0.0, 0.2, 0.8);     // azul
    vec3 bright = vec3(1.0, 0.4, 0.0);  // naranja
    
    vec3 arcade;
    if (brightness < 0.4) {
        arcade = mix(dark, mid, brightness / 0.4);
    } else {
        arcade = mix(mid, bright, (brightness - 0.4) / 0.6);
    }
    
    COLOR = vec4(arcade, 1.0);
}