#version 430 core

precision highp float;
out vec4 fragColor;

uniform vec4 color;

void main() {
    fragColor = color;
}
