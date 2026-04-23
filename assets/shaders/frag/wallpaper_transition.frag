#version 450

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(binding = 1) uniform sampler2D source;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;

    float progress;
    float maxRadius;

    float origImgWidth;
    float origImgHeight;

    float screenWidth;
    float screenHeight;
    vec2 aspectRatio;

    float origIsSolid;
    vec4 solid;
};

vec2 scaleUVWithCrop(vec2 uv, float imgW, float imgH) {
    float scale = max(screenWidth / imgW, screenHeight / imgH);
    vec2 scaledSize = vec2(imgW, imgH) * scale;
    vec2 offset = (scaledSize - vec2(screenWidth, screenHeight)) / scaledSize;
    vec2 scaledUV = uv * (vec2(1.) - offset) + offset * .5;

    return scaledUV;
}

float rippleOffset(float adjustment, vec2 direction) {
    float t = progress + adjustment;
    float d = length(direction / aspectRatio) - t * maxRadius; // SDF of circle
    d *= 1. - smoothstep(0., 0.1, abs(d)); // limit the offset to a narrow band around the circle
    d *= smoothstep(0., 0.1, t); // fade in

    return d;
}

void main() {
    vec2 uv = qt_TexCoord0;

    vec2 scaledUV = scaleUVWithCrop(uv, origImgWidth, origImgHeight);

    vec2 center = vec2(0.5);
    vec2 direction = uv - center;

    float rD = rippleOffset(0.02, direction);
    float gD = rippleOffset(0., direction);
    float bD = rippleOffset(-0.02, direction);

    direction = normalize(direction);

    float r = texture(source, scaledUV + direction * rD).r;
    float g = texture(source, scaledUV + direction * gD).g;
    float b = texture(source, scaledUV + direction * bD).b;

    float shading = gD * 3.;

    fragColor = vec4(r, g, b, 1.0);
    fragColor.rgb += shading;
}
