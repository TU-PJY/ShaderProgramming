#version 330

layout(location=0) out vec4 FragColor;

in vec4 v_Color;

uniform sampler2D u_Texture;
in vec2 v_UV;


void main()
{
	vec2 newUV = vec2(v_UV.x, v_UV.y);
    FragColor = v_Color * texture(u_Texture, newUV);
}
