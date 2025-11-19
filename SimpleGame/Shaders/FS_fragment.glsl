#version 330
layout(location=0) out vec4 FragColor;

uniform sampler2D u_RGBTexture;
uniform sampler2D u_NumTexture;
uniform float u_Time;
in vec2 v_UV;

uniform sampler2D u_TotalNumTexture;
uniform int u_Num;
uniform int u_NumDigits; 

const float PI = 3.14;

// 숫자 텍스처 셀 크기
const float CELL_W = 1.0 / 5.0;
const float CELL_H = 1.0 / 2.0;

// 숫자->(col,row) 매핑 (0..9)
ivec2 numberPositions[10] = ivec2[](
    ivec2(4, 1), // 0
    ivec2(0, 0), // 1
    ivec2(1, 0), // 2
    ivec2(2, 0), // 3
    ivec2(3, 0), // 4
    ivec2(4, 0), // 5
    ivec2(0, 1), // 6
    ivec2(1, 1), // 7
    ivec2(2, 1), // 8
    ivec2(3, 1)  // 9
);

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

void q3() {
	float newX = fract(v_UV.x * 3);
	float newY = (v_UV.y / 3) + ((floor(v_UV.x * 3)) / 3);
	FragColor = texture(u_RGBTexture, vec2(newX, newY));
}

void q4() {
	float count = 2;
	float shift = 0.5;
	float newX = fract(fract(v_UV.x * count) + (floor(v_UV.y  * count) + 1) * shift);
	float newY = fract(v_UV.y * count);
	FragColor = texture(u_RGBTexture, vec2(newX, newY));
}

void q5() {
	float count = 2;
	float shift = 0.5;
	float newX = fract(v_UV.x * count);
	float newY = fract(fract(v_UV.y * count) + (floor(v_UV.x  * count) + 1) * shift);
	FragColor = texture(u_RGBTexture, vec2(newX, newY));
}

void number() {
	float width = 1.0 / 5.0;
    float height = 1.0 / 2.0;

    // 숫자에 매칭되는 텍스처상의 (col, row)
    ivec2 numberPositions[10] = ivec2[](
        ivec2(4, 1), // 0의 위치 -> (열 4, 행 1)
        ivec2(0, 0), // 1
        ivec2(1, 0), // 2
        ivec2(2, 0), // 3
        ivec2(3, 0), // 4
        ivec2(4, 0), // 5
        ivec2(0, 1), // 6
        ivec2(1, 1), // 7
        ivec2(2, 1), // 8
        ivec2(3, 1)  // 9
    );

    ivec2 pos = numberPositions[u_Num];

    float uStart = pos.x * width;
    float vStart = 1.0 - pos.y * height;

    vec2 numberUV = vec2(uStart + v_UV.x * width,
                         vStart + v_UV.y * height);

    FragColor = texture(u_TotalNumTexture, numberUV);
}

int getDigit(int N, int digitIndex) {
    // digitIndex 0 = 오른쪽 끝(1의 자리)
    int d = N / int(pow(10.0, float(digitIndex)));
    return d % 10;
}

void numbers() {
 // 1) v_UV.x로 현재 프래그먼트가 속한 자리(slot)를 계산
    float perDigit = 1.0 / float(u_NumDigits);            // 각 자리의 normalized 너비
    int slot = int(floor(v_UV.x / perDigit));             // 0..u_NumDigits-1, 0 = 왼쪽 자리
    // clamp 안전장치
    slot = clamp(slot, 0, u_NumDigits - 1);

    // 2) slot에 대응하는 내부 자리 UV (0..1 within this digit)
    float localU = (v_UV.x - float(slot) * perDigit) / perDigit;
    float localV = v_UV.y; // 세로는 그대로 사용(0..1)

    // 3) 숫자 추출: 왼쪽을 가장 높은 자리로 보고 싶으면 자리 인덱스 변환
    int digitIndexFromRight = (u_NumDigits - 1) - slot; // slot=0(왼쪽) -> highest power
    int digit = getDigit(u_Num, digitIndexFromRight);

    // 4) 텍스처 셀 위치 계산 (V는 아래가 0이라면 pos.y 기준으로 아래에서 위로 계산)
    ivec2 pos = numberPositions[digit];
    float uStart = float(pos.x) * CELL_W;
    // 안전하게 V start 계산: 각 셀의 아래(y) 위치 = pos.y * CELL_H
    // 텍스처 V의 0이 아래라면 실제 셀 영역 = [pos.y*CELL_H, (pos.y+1)*CELL_H]
    float vStart = float(pos.y) * CELL_H;

    // 5) 셀 내부 UV로 변환
    vec2 numberUV = vec2(uStart + localU * CELL_W,
                         vStart + localV * CELL_H);

    // 6) 샘플링
    FragColor = texture(u_TotalNumTexture, numberUV);
}

void main()
{
	//test();
	//circles();
	//flag();
	//q1();
	//q2();
	//q3();
	//q4();
	//q5();
	//number();
	numbers();
}
