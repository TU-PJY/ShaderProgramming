#version 330
layout(location=0) out vec4 FragColor;

uniform sampler2D u_RGBTexture;
uniform float u_Time;
in vec2 v_UV;

const float PI = 3.14;

void test() {
	vec2 newPos = v_UV;
	newPos += vec2(0, 0.2 * sin(v_UV.x * PI * 2 + u_Time));
	vec4 newColor = texture(u_RGBTexture, newPos);
	FragColor = vec4(newColor);
}

void circles() {
	vec2 center = vec2(0.5, 0.5);
	float d = distance(v_UV, center);
	vec4 newColor = vec4(0);
	float value = sin(d * 10 * PI + u_Time * 200);
	newColor = vec4(value);
	FragColor = newColor;
}

void flag() {
	vec2 uv = vec2(v_UV.x, (1 - v_UV.y) - 0.5);
	vec2 center = vec2(0.5, 0.5);
	float sinValue = uv.x * 0.2 * sin(uv.x * 2 * PI - u_Time * 25);
	vec4 newColor = vec4(0);
	float width = 0.2 * (1 - sin(uv.x));
	if(sinValue + width > uv.y && sinValue - width < uv.y)
		newColor = vec4(1);
	else
		discard;
	FragColor = newColor;
}

void q1() {
	float newX = v_UV.x;
	float newY = 1 - abs((v_UV.y * 2) - 1);
	FragColor = texture(u_RGBTexture, vec2(newX, newY));
}

void q2() {
	float newX = fract(v_UV.x * 3);
	float newY = ((2 - floor(v_UV.x * 3)) / 3) + (v_UV.y / 3);
	FragColor = texture(u_RGBTexture, vec2(newX, newY));
}

void main()
{
	//test();
	//circles();
	//flag();
	//q1();
	q2();
}
