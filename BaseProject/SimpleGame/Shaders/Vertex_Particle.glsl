#version 330

in vec3 a_Position;
in float a_Value;
in vec4 a_Color;
in float a_sTime;
in vec3 a_Vel;
in float a_lifeTime;
in float a_Mass;
in float a_Period;

out vec4 v_Color;

uniform float u_Time;
uniform vec3 u_Force;

const float c_PI = 3.141592;

const vec2 c_G = vec2(0.0, -9.8);

void fountain() {
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

void sinParticle() {
	vec4 centerColor = vec4(1, 0, 0, 1);
	vec4 borderColor = vec4(1, 1, 1, 1);
	vec4 newColor = v_Color;
	vec4 newPosition = vec4(a_Position, 1.0);
	float newAlpha = 1.0;
	float newTime = u_Time - a_sTime;
	float lifeTime = a_lifeTime;
	float amp = a_Value * 2 - 1;
	float period = a_Period * 2;

	if(newTime > 0.0) {
		float t = fract(u_Time/lifeTime) * lifeTime;
		float tt = t*t;
		float n_Time = t/lifeTime;
		float x = n_Time * 2 - 1;
		float y = n_Time * sin(n_Time * c_PI) * amp * sin(2 * period * c_PI * n_Time);

		newPosition.xy += vec2(x, y);
		newAlpha = 1.0 - t / lifeTime;

		float d = abs(y);
		newColor = mix(centerColor, borderColor, d * 2);
	}
	else {
		newPosition.xy = vec2(-100000.0, -100000.0);
	}
	gl_Position = newPosition;
	v_Color = vec4(newColor.rgb, newAlpha);
}

void circleParticle() {
	vec4 newPosition = vec4(a_Position, 1.0);
	float newAlpha = 1.0;
	float lifeTime = a_lifeTime;
	float newTime = u_Time - a_sTime;

	if(newTime > 0.0) {
		float value = a_Value * c_PI * 2;
		float x = sin(value);
		float y = cos(value);

		float t = fract(u_Time/lifeTime) * lifeTime;
		float tt = t * t;

		float newX = x + 0.5 * c_G.x * tt;
		float newY = y + 0.5 * c_G.y * tt;

		newPosition.xy += vec2(newX, newY);
		newAlpha = 1-t/lifeTime;
	}
	else {
		newPosition.xy = vec2(-100000.0, -100000.0);
	}

	gl_Position = newPosition;
	v_Color = vec4(a_Color.rgb, newAlpha);
}

void main() {
	circleParticle();
}
