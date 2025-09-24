#version 330

in vec3 a_Position;
in float a_Value;
in vec4 a_Color;
in float a_sTime;
in vec3 a_Vel;
in float a_lifeTime;
in float a_Mass;

out vec4 v_Color;

uniform float u_Time;
uniform vec3 u_Force;

const float c_PI = 3.141592;

const vec2 c_G = vec2(0.0, -9.8);

void main()
{
	float lifeTime = a_lifeTime;
	float newAlpha = 1.0;
	float newTime = u_Time - a_sTime;
	vec4 newPosition = vec4(a_Position, 1);

	if(newTime > 0.0)
	{
		float fx = c_G.x * a_Mass + u_Force.x * 2.0;
		float fy = c_G.y * a_Mass + u_Force.y * 2.0;
		float accx = fx / a_Mass;
		float accy = fy / a_Mass;

		float t = fract(newTime / lifeTime) * lifeTime;
		float tt = t * t;
		float x = a_Vel.x * t + 0.5 * accx * tt;
		float y = a_Vel.y * t + 0.5 * accy * tt;
		newPosition.xy += vec2(x, y);
		newAlpha = 1.0 - t / lifeTime;
	}

	else
	{
		newPosition.xy = vec2(-100000.0, -100000.0);
	}

	gl_Position = newPosition;
	v_Color = vec4(a_Color.rgb, newAlpha);
}
