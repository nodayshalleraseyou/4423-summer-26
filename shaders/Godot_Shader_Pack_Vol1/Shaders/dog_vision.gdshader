shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_nearest;
uniform float pixel_size = 3.0;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 screen_size = vec2(1152.0, 648.0);
    
    // Pixelado
    vec2 pixelated_uv = floor(uv * screen_size / pixel_size) * pixel_size / screen_size;
    vec3 color = texture(SCREEN_TEXTURE, pixelated_uv).rgb;
    
    // Convertir a escala de grises
    float gray = dot(color, vec3(0.299, 0.587, 0.114));
    
    // Los perros ven azul y amarillo principalmente
    // Azul en zonas frias, amarillo en zonas calidas
    float warm = dot(color, vec3(0.5, 0.4, 0.1));
    float cool = dot(color, vec3(0.1, 0.2, 0.5));
    
    vec3 dog_color = mix(
        vec3(0.1, 0.1, 0.6),  // azul
        vec3(0.7, 0.7, 0.1),  // amarillo
        warm / (warm + cool + 0.001)
    );
    
    // Mezclar con gris para que no sea tan saturado
    dog_color = mix(vec3(gray), dog_color, 0.7);
    
    COLOR = vec4(dog_color, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
