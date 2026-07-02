shader_type canvas_item;

uniform float time_scale = 2.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	float ring = sin(distance(UV, vec2(0.5,0.5))*20.0+TIME*time_scale); 
	COLOR = vec4(1.0,1.0,1.0,ring);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
