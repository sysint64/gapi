module gapi.geometry;

import std.container;
import std.conv;

import gapi.opengl;
import gl3n.linalg;

struct Buffer {
    GLuint id;
    bool staticData = true;
}

struct VAO {
    enum AttrLocation {
        in_Position = 0,
        in_TextCoords = 1,
        in_Normals = 2,
    }

    GLuint id;
}

Buffer createIndicesBuffer(in Array!uint indicesData, in bool staticData = true) {
    return createBuffer!GLuint(&indicesData[0], indicesData.length, 1, staticData);
}

Buffer createVector2fBuffer(in Array!vec2 verticesData, in bool staticData = true) {
    return createBuffer!GLfloat(&verticesData[0], verticesData.length, 2, staticData);
}

Buffer createVector3fBuffer(in Array!vec3 verticesData, in bool staticData = true) {
    return createBuffer!GLfloat(&verticesData[0], verticesData.length, 3, staticData);
}

Buffer createBuffer(T)(in void* verticesData, in size_t dataLength, in uint dimension,
                       in bool staticData = true)
{
    Buffer vertices;
    vertices.staticData = staticData;

    glGenBuffers(1, &vertices.id);
    glBindBuffer(GL_ARRAY_BUFFER, vertices.id);

    const int dataSize = to!int(T.sizeof*dimension*dataLength);

    if (vertices.staticData) {
        glBufferData(GL_ARRAY_BUFFER, dataSize, verticesData, GL_STATIC_DRAW);
    } else {
        glBufferData(GL_ARRAY_BUFFER, dataSize, null, GL_STREAM_DRAW);
        glBufferSubData(GL_ARRAY_BUFFER, 0, dataSize, verticesData);
    }

    return vertices;
}

VAO createVAO() {
    VAO vao;
    glGenVertexArrays(1, &vao.id);
    return vao;
}

void bindVAO(in VAO vao) {
    glBindVertexArray(vao.id);
}

void createVertices2fVAO(in Buffer buffer) {
    return createVAOAttributeArray!GL_FLOAT(buffer, VAO.AttrLocation.in_Position, 2);
}

void createVertices3fVAO(in Buffer buffer) {
    return createVAOAttributeArray!GL_FLOAT(buffer, VAO.AttrLocation.in_Position, 3);
}

void createVAOAttributeArray(uint T)(in Buffer buffer, in uint index, in uint dimension) {
    glBindBuffer(GL_ARRAY_BUFFER, buffer.id);
    glEnableVertexAttribArray(index);
    glVertexAttribPointer(index, dimension, T, GL_FALSE, 0, null);
}

void bindIndices(in Buffer indices) {
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indices.id);
}

Buffer deleteBuffer(Buffer buffer) {
    glDeleteBuffers(1, &buffer.id);
    return buffer;
}
