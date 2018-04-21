module gapi.geometry;

import std.container;
import std.conv;

import derelict.opengl3.gl;
import gl3n.linalg;

struct Indices {
    GLuint id;
    Array!GLuint data;
}

struct Vertices {
    GLuint id;
    Array!vec3 data;
    bool staticData = true;
}

struct TexCoords {
    GLuint id;
    Array!vec2 data;
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

struct Geometry {
    Indices indices;
    Vertices vertices;
    TexCoords texCoords;
    private VAO vao;
}

void createIndices(ref Indices indices) {
    glGenBuffers(1, &indices.id);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indices.id);

    const int indicesSize = to!int(GLuint.sizeof*indices.data.length);
    glBufferData (GL_ELEMENT_ARRAY_BUFFER, indicesSize, &indices.data[0], GL_STATIC_DRAW);
}

void createVertices(ref Vertices vertices) {
    glGenBuffers(1, &vertices.id);
    glBindBuffer(GL_ARRAY_BUFFER, vertices.id);

    const int dataSize = to!int(GLfloat.sizeof*3*vertices.data.length);

    if (vertices.staticData) {
        glBufferData(GL_ARRAY_BUFFER, dataSize, &vertices.data[0], GL_STATIC_DRAW);
    } else {
        glBufferData(GL_ARRAY_BUFFER, dataSize, null, GL_STREAM_DRAW);
        glBufferSubData(GL_ARRAY_BUFFER, 0, dataSize, &vertices.data[0]);
    }
}

void createTexCoords(ref TexCoords texCoords) {
    glGenBuffers(1, &texCoords.id);
    glBindBuffer(GL_ARRAY_BUFFER, texCoords.id);

    const int dataSize = to!int(GLfloat.sizeof*2*texCoords.data.length);

    if (texCoords.staticData) {
        glBufferData(GL_ARRAY_BUFFER, dataSize, &texCoords.data[0], GL_STATIC_DRAW);
    } else {
        glBufferData(GL_ARRAY_BUFFER, dataSize, null, GL_STREAM_DRAW);
        glBufferSubData(GL_ARRAY_BUFFER, 0, dataSize, &texCoords.data[0]);
    }
}

void createVAO(ref VAO vao) {
    glGenVertexArrays(1, &vao.id);
}

void bindVAO(ref VAO vao) {
    glBindVertexArray(vao.id);
}

void createVerticesVAO(ref Vertices vertices) {
    glBindBuffer(GL_ARRAY_BUFFER, vertices.id);
    glEnableVertexAttribArray(VAO.AttrLocation.in_Position);
    glVertexAttribPointer(VAO.AttrLocation.in_Position, 3, GL_FLOAT, GL_FALSE, 0, null);
}

void createTexCoordsVAO(ref TexCoords texCoords) {
    glBindBuffer(GL_ARRAY_BUFFER, texCoords.id);
    glEnableVertexAttribArray(VAO.AttrLocation.in_TextCoords);
    glVertexAttribPointer(VAO.AttrLocation.in_TextCoords, 2, GL_FLOAT, GL_FALSE, 0, null);
}

void bindVertices(ref Vertices vertices) {
    const dataSize = to!int(GLfloat.sizeof*2*vertices.data.length);
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, dataSize, null);

    glEnableClientState(GL_VERTEX_ARRAY);
    glBindBuffer(GL_ARRAY_BUFFER, vertices.id);
    glVertexPointer(2, GL_FLOAT, 0, null);
}

void bindTexCoords(ref TexCoords texCoords) {
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glBindBuffer(GL_ARRAY_BUFFER, texCoords.id);
    glTexCoordPointer(2, GL_FLOAT, 0, null);
}

void bindIndices(ref Indices indices) {
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indices.id);
}

void deleteIndices(ref Indices indices) {
    glDeleteBuffers(1, &indices.id);
}

void deleteVertices(ref Vertices vertices) {
    glDeleteBuffers(1, &vertices.id);
}

void deleteTexCoords(ref TexCoords texCoords) {
    glDeleteBuffers(1, &texCoords.id);
}

void deleteVAO(ref VAO vao) {
    glDeleteBuffers(1, &vao.id);
}

void createGeometry(ref Geometry geometry) {
    with (geometry) {
        createIndices(indices);
        createVertices(vertices);
        createTexCoords(texCoords);
        createVAO(vao);
        bindVAO(vao);
        createVerticesVAO(vertices);
        createTexCoordsVAO(texCoords);
    }
}

void deleteGeometry(ref Geometry geometry) {
    with (geometry) {
        deleteIndices(indices);
        deleteVertices(vertices);
        deleteTexCoords(texCoords);
        deleteVAO(vao);
    }
}
