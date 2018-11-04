module gapi.shader;

import std.string;
import std.stdio;
import std.container;
import std.format;

import gapi.opengl;

struct ShaderProgram {
    GLuint id;
    Shader[] shaders;
    string name;
}

struct Shader {
    GLuint id;
    string name;
}

class ShaderError : Exception {
    this(in string details) {
        super(details);
    }
}

enum ShaderType {
    vertex = GL_VERTEX_SHADER,
    fragment = GL_FRAGMENT_SHADER
}

Shader createShader(in string name, in ShaderType shaderType, in string source) {
    const shaderSource = toStringz(source);

    Shader shader;
    shader.name = name;
    shader.id = glCreateShader(cast(GLenum)shaderType);

    glShaderSource(shader.id, 1, &shaderSource, null);
    glCompileShader(shader.id);
    checkShaderStatus(shader, GL_COMPILE_STATUS);

    return shader;
}

ShaderProgram createShaderProgram(in string name, Shader[] shaders) {
    ShaderProgram program;

    program.id = glCreateProgram();
    program.name = name;
    program.shaders = shaders;

    foreach (const shader; program.shaders) {
        glAttachShader(program.id, shader.id);
    }

    glLinkProgram(program.id);
    checkProgramStatus(program, GL_LINK_STATUS);

    glValidateProgram(program.id);
    checkProgramStatus(program, GL_VALIDATE_STATUS);

    return program;
}

void bindShaderProgram(in ShaderProgram program) {
    glUseProgram(program.id);
}

void unbindShaderProgram() {
    glUseProgram(0);
}

GLuint getShaderLocation(in ShaderProgram program, in string location) {
    const name = toStringz(location);
    const loc = glGetUniformLocation(program.id, name);

    if (loc == -1) {
        const details = format(
            "Failed to get uniform location. name '%s', location: %s",
            program.name, location
        );

        throw new ShaderError(details);
    }

    return loc;
}

void deleteShaderProgram(in ShaderProgram program) {
    foreach (const shader; program.shaders) {
        glDeleteShader(shader.id);
    }

    glDeleteProgram(program.id);
}

GLint checkShaderStatus(Shader shader, GLenum pname) {
    GLint status, length;
    GLchar[1024] buffer;

    glGetShaderiv(shader.id, pname, &status);

    if (status != GL_TRUE) {
        glGetShaderInfoLog(shader.id, 1024, &length, &buffer[0]);

        const message = (cast(immutable(char)*)buffer)[0..length];
        string reason;

        switch (pname) {
            case GL_COMPILE_STATUS:
                reason = "Failed when compiling shader";
                break;

            default:
                reason = "Failed";
                break;
        }

        const details = format(
            "%s. name '%s', status: %d, message: %s",
            reason, shader.name, status, message
        );

        throw new ShaderError(details);
    }

    return status;
}

GLint checkProgramStatus(ShaderProgram program, GLenum pname) {
    GLint status, length;
    GLchar[1024] buffer;

    glGetProgramiv(program.id, pname, &status);

    if (status != GL_TRUE) {
        glGetProgramInfoLog(program.id, 1024, &length, &buffer[0]);

        const message = (cast(immutable(char)*)buffer)[0..length];
        string reason;

        switch (pname) {
            case GL_VALIDATE_STATUS:
                reason = "Failed when validation shader program";
                break;

            case GL_LINK_STATUS:
                reason = "Failed on linking program";
                break;

            default:
                reason = "Failed";
        }

        const details = format(
            "%s. name: '%s', status: %d, message: %s",
            reason, program.name, status, message
        );

        throw new ShaderError(details);
    }

    return status;
}
