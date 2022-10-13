shader_type canvas_item;

uniform vec2 target = vec2(0.5);
uniform float intensity: hint_range (0, 1);

void fragment(){
	COLOR.rgb = textureLod(SCREEN_TEXTURE, SCREEN_UV, 6.0 * intensity * (distance(target, UV)/sqrt(2))).rgb;
}