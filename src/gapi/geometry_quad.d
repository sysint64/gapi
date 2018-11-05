module gapi.geometry_quad;

import gapi.geometry;
import std.container;
import gapi.vec;

immutable centeredQuadVertices = [
    vec2(-0.5f, -0.5f),
    vec2( 0.5f, -0.5f),
    vec2( 0.5f,  0.5f),
    vec2(-0.5f,  0.5f)
];

immutable quadVertices = [
    vec2(0.0f, 0.0f),
    vec2(1.0f, 0.0f),
    vec2(1.0f, 1.0f),
    vec2(0.0f, 1.0f)
];

immutable uint[] quadIndices = [0, 3, 1, 2];

immutable quadTexCoords = [
    vec2(0.0f, 1.0f),
    vec2(1.0f, 1.0f),
    vec2(1.0f, 0.0f),
    vec2(0.0f, 0.0f)
];
