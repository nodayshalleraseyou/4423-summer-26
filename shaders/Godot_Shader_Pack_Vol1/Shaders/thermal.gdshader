shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_nearest;
uniform float pixel_size = 3.0;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 screen_size = vec2(1152.0, 648.0);

    // Pixelado
    vec2 pixelated_uv = floor(uv * screen_size / pixel_size) * pixel_size / screen_size;
    vec3 color = texture(SCREEN_TEXTURE, pixelated_uv).rgb;

    // Convertir a calor (luminosidad)
    float heat = dot(color, vec3(0.299, 0.587, 0.114));

    // Paleta térmica: frío azul -> verde -> amarillo -> rojo -> blanco
    vec3 thermal;
    if (heat < 0.25) {
        thermal = mix(vec3(0.0, 0.0, 0.5), vec3(0.0, 0.5, 1.0), heat * 4.0);
    } else if (heat < 0.5) {
        thermal = mix(vec3(0.0, 0.5, 1.0), vec3(0.0, 1.0, 0.0), (heat - 0.25) * 4.0);
    } else if (heat < 0.75) {
        thermal = mix(vec3(0.0, 1.0, 0.0), vec3(1.0, 0.5, 0.0), (heat - 0.5) * 4.0);
    } else {
        thermal = mix(vec3(1.0, 0.5, 0.0), vec3(1.0, 1.0, 1.0), (heat - 0.75) * 4.0);
    }

    COLOR = vec4(thermal, 1.0);
}