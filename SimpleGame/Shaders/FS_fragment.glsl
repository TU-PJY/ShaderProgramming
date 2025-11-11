//#version 330
//layout(location=0) out vec4 FragColor;
//
//in vec2 v_UV;
//
//const float pi = 3.14;
//
//void main()
//{
//
//	float vx = 2 * pi * v_UV.x * 8; // 0 ~ 2pi
//	float vy = 2 * pi * v_UV.y * 8;
//	float grayScale = 1 - pow(abs(sin(vx)), 0.5);
//	vec4 newColor = vec4(grayScale);
//	FragColor = newColor;
//}
//

#version 330
layout(location=0) out vec4 FragColor;

in vec2 v_UV;

// 반복 횟수 (이 값을 높이면 디테일이 증가하지만, 성능이 저하됩니다)
const int MAX_ITER = 100;

void main()
{
    // 1. UV 좌표를 복소 평면의 'c' 값으로 변환합니다.
    // v_UV (0.0 ~ 1.0) -> 복소 평면의 특정 영역 (예: X: -2.0 ~ 1.0, Y: -1.5 ~ 1.5)
    // 이 값들을 조절해서 프랙탈을 확대/축소/이동(zoom/pan)할 수 있습니다.
    vec2 c = vec2(v_UV.x * 3.0 - 2.0, v_UV.y * 3.0 - 1.5);

    // 2. 만델브로트 반복 계산을 위한 초기값 z = 0
    vec2 z = vec2(0.0, 0.0);
    int i;

    // 3. z = z*z + c 점화식을 반복합니다.
    for(i = 0; i < MAX_ITER; i++)
    {
        // 복소수 곱셈: z*z = (zx*zx - zy*zy) + i(2*zx*zy)
        float zx = z.x * z.x - z.y * z.y;
        float zy = 2.0 * z.x * z.y;

        // z = z*z + c
        z = vec2(zx, zy) + c;

        // 4. 발산 확인: |z| > 2 이면 발산합니다.
        // 성능을 위해 |z|^2 > 4 (dot(z,z) > 4.0) 를 확인합니다. (sqrt 연산 방지)
        if(dot(z, z) > 4.0)
        {
            break; // 발산!
        }
    }

    // 5. 반복 횟수에 따라 색상 결정
    float gray;
    if (i == MAX_ITER)
    {
        // 최대 반복 횟수까지 발산하지 않음 (집합 내부에 속함)
        gray = 0.0; // 검은색
    }
    else
    {
        // 발산함 (집합 외부에 속함)
        // 반복 횟수가 적을수록 빨리 발산한 것이므로 밝은 색을 줍니다.
        gray = float(i) / float(MAX_ITER);
    }

    FragColor = vec4(vec3(gray), 1.0);
}