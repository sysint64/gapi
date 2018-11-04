module gapi.shader;

import std.string;
import std.stdio;
import std.container;

import gapi.opengl;

struct ShaderProgram {
    GLuint id;
    Array!Shader shaders;
    GLuint[string] locations;
}

struct Shader {
    GLuint id;
}

GLint checkStatus(string statusInfo)(ref GLuint shader, GLenum param) {
    GLint status, length;
    GLchar[1024] buffer;

    mixin("glGet" ~ statusInfo ~ "iv(shader, param, &status);");

    if (status != GL_TRUE) {
        mixin("glGet" ~ statusInfo ~ "InfoLog(shader, 1024, &length, &buffer[0]);");
        writeln(status, "error(", ")", buffer);
    }

    return status;
}

GLint shaderStatus(ref GLuint shader, GLenum param) {
    return checkStatus!("Shader")(shader, param);
}

GLint programStatus(ref GLuint shader, GLenum param) {
    return checkStatus!("Program")(shader, param);
}

void createShader(ref ShaderProgram program, in string source) {
    const shaderSource = toStringz(source);

    Shader shader;
    shader.id = glCreateShader(GL_VERTEX_SHADER);

    glShaderSource(shader.id, 1, &shaderSource, null);
    glCompileShader(shader.id);
    shaderStatus(shader.id, GL_COMPILE_STATUS);
}

void createProgram(ref ShaderProgram program) {
    program.id = glCreateProgram();

    foreach (const shader; program.shaders) {
        glAttachShader(program.id, shader.id);
    }

    glValidateProgram(program.id);
    glLinkProgram(program.id);
}

void bindShaderProgram(in ShaderProgram program) {
    glUseProgram(program.id);
}

void unbindShaderProgram() {
    glUseProgram(0);
}

void memoizeShaderLocation(ref ShaderProgram program, in string location) {
    if (location !in program.locations) {
        const name = toStringz(location);
        program.locations[location] = glGetUniformLocation(program.id, name);
    }
}
