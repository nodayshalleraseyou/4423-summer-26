shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_nearest;
uniform float pixel_size = 3.0;
uniform float wave_speed = 1.0;
uniform float wave_amount = 0.008;
uniform float depth = 0.6;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 screen_size = vec2(1152.0, 648.0);

    // Pixelado
    vec2 pixelated_uv = floor(uv * screen_size / pixel_size) * pixel_size / screen_size;

    // Distorsión de agua
    pixelated_uv.x += sin(pixelated_uv.y * 10.0 + TIME * wave_speed) * wave_amount;
    pixelated_uv.y += cos(pixelated_uv.x * 8.0 + TIME * wave_speed * 0.8) * wave_amount * 0.5;

    vec3 color = texture(SCREEN_TEXTURE, pixelated_uv).rgb;

    // Tono azul verdoso del agua
    color.r *= 0.3;
    color.g *= 0.7;
    color.b *= 1.2;

    // Oscurecer por profundidad
    float fog = 1.0 - depth * 0.4;
    color *= fog;

    // Caustics — destellos de luz
    float caustic = sin(uv.x * 20.0 + TIME * 2.0) * sin(uv.y * 15.0 + TIME * 1.5);
    caustic = max(0.0, caustic) * 0.15;
    color += vec3(0.0, caustic * 0.5, caustic);

    // Viñeta
    vec2 vig_uv = uv * (1.0 - uv.yx);
    color *= pow(vig_uv.x * vig_uv.y * 15.0, 0.3);

	// Blur simple - mezcla con pixeles vecinos
	vec3 blur = texture(SCREEN_TEXTURE, pixelated_uv + vec2(0.002, 0.0)).rgb * 0.25
	          + texture(SCREEN_TEXTURE, pixelated_uv - vec2(0.002, 0.0)).rgb * 0.25
	          + texture(SCREEN_TEXTURE, pixelated_uv + vec2(0.0, 0.002)).rgb * 0.25
	          + texture(SCREEN_TEXTURE, pixelated_uv - vec2(0.0, 0.002)).rgb * 0.25;

	// Aplicar tono azul al blur también
	blur.r *= 0.3;
	blur.g *= 0.7;
	blur.b *= 1.2;

	color = mix(color, blur, 0.6);

    COLOR = vec4(color, 1.0);
}