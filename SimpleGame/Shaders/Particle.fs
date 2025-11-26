#version 330

layout(location=0) out vec4 FragColor;
layout(location=1) out vec4 FragColor1;

in vec4 v_Color;

void main()
{
	FragColor = v_Color;
	FragColor1 = vec4(1, 1, 1, 1);
}
