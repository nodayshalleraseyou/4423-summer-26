shader_type canvas_item;

uniform float scroll_speed = 2;
uniform float alpha = 1;
uniform vec3 color : source_color = vec3(1.0, 1.0, 1.0);


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	float stripe = UV.y + UV.x;
	stripe = ceil(sin(stripe*10.0+TIME*scroll_speed));
	COLOR = vec4(color.rgb,stripe*alpha);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
