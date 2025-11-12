#version 330
layout(location=0) out vec4 FragColor;

uniform sampler2D u_RGBTexture;
uniform float u_Time;
in vec2 v_UV;

const float PI = 3.14;

void main()
{
	vec2 newPos = v_UV;
	newPos += vec2(0, 0.2 * sin(v_UV.x * PI * 2 + u_Time));
	vec4 newColor = texture(u_RGBTexture, newPos);
	FragColor = vec4(newColor);
}
