varying vec2 vUv0;

uniform sampler2D texture;

uniform float fillAmount;

uniform vec4 uScreenSize; // existing global uniform


const float PI     = 3.1415926;
const float TWO_PI = 6.2831852;

float magnitude(vec2 vec)
{
    return sqrt((vec.x * vec.x) + (vec.y * vec.y));
}

float angleBetween(vec2 v1, vec2 v2)
{
    return atan(v1.x - v2.x, v1.y - v2.y) + PI;
}

float getTargetAngle() 
{
    return clamp(fillAmount, 0.0, TWO_PI);
}

// OpenGL uses upper left as origin by default
bool shouldDrawFragment(vec2 fragCoord)
{
    float targetAngle = getTargetAngle();

    vec2 center = vec2(0.5, 0.5);

    float a = angleBetween(center, fragCoord);

    return a <= targetAngle;
}

void main(void)
{
    vec4 color = texture2D(texture, vUv0);
    
    if(!shouldDrawFragment(vUv0)) color = vec4(0.0, 0, 0, 0.0);
    
    gl_FragColor = color;
}
