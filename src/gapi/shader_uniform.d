module gapi.shader_uniform;

import gapi.shader;
import gapi.opengl;
import gapi.vec;

void setShaderProgramUniformFloat(in ShaderProgram program, in string location, in float val) {
    const loc = getShaderLocation(program, location);
    glUniform1f(loc, val);
}

void setShaderProgramUniformInt(in ShaderProgram program, in string location, in int val) {
    const loc = getShaderLocation(program, location);
    glUniform1i(loc, val);
}

void setShaderProgramUniformUInt(in ShaderProgram program, in string location, in uint val) {
    const loc = getShaderLocation(program, location);
    glUniform1ui(loc, val);
}

// void setShaderProgramUniformTexture(in ShaderProgram program, in string location, Texture texture) {
//     glActiveTexture(GL_TEXTURE0 + nextTextureID);
//     texture.bind();

//     const loc = getShaderLocation(program, location);
//     glUniform1i(loc, nextTextureID);

//     ++nextTextureID;
// }

// Float Vector ------------------------------------------------------------------------------------

void setShaderProgramUniformVec2f(in ShaderProgram program, in string location, in vec2 vector) {
    const loc = getShaderLocation(program, location);
    glUniform2fv(loc, 1, vector.value_ptr);
}

void setShaderProgramUniformVec2f(in ShaderProgram program, in string location, in float x, float y) {
    const loc = getShaderLocation(program, location);
    glUniform2f(loc, x, y);
}

void setShaderProgramUniformVec3f(in ShaderProgram program, in string location, in vec3 vector) {
    const loc = getShaderLocation(program, location);
    glUniform3fv(loc, 1, vector.value_ptr);
}

void setShaderProgramUniformVec3f(in ShaderProgram program, in string location, in float x, in float y, in float z) {
    const loc = getShaderLocation(program, location);
    glUniform3f(loc, x, y, z);
}

void setShaderProgramUniformVec4f(in ShaderProgram program, in string location, in vec4 vector) {
    const loc = getShaderLocation(program, location);
    glUniform4fv(loc, 1, vector.value_ptr);
}

void setShaderProgramUniformVec4f(in ShaderProgram program, in string location, in float x, in float y, in float z, in float w) {
    const loc = getShaderLocation(program, location);
    glUniform4f(loc, x, y, z, w);
}

// Integer Vector ----------------------------------------------------------------------------------

void setShaderProgramUniformVec2i(in ShaderProgram program, in string location, in vec2i vector) {
    const loc = getShaderLocation(program, location);
    glUniform2iv(loc, 1, vector.value_ptr);
}

void setShaderProgramUniformVec2i(in ShaderProgram program, in string location, in int x, in int y) {
    const loc = getShaderLocation(program, location);
    glUniform2i(loc, x, y);
}

void setShaderProgramUniformVec3i(in ShaderProgram program, in string location, in vec3i vector) {
    const loc = getShaderLocation(program, location);
    glUniform3iv(loc, 1, vector.value_ptr);
}

void setShaderProgramUniformVec3i(in ShaderProgram program, in string location, in int x, in int y, in int z) {
    const loc = getShaderLocation(program, location);
    glUniform3i(loc, x, y, z);
}

void setShaderProgramUniformVec4i(in ShaderProgram program, in string location, in vec4i vector) {
    const loc = getShaderLocation(program, location);
    glUniform4iv(loc, 1, vector.value_ptr);
}

void setShaderProgramUniformVec4i(in ShaderProgram program, in string location, in int x,in int y,in int z,in int w) {
    const loc = getShaderLocation(program, location);
    glUniform4i(loc, x, y, z, w);
}

// Unsigned int ------------------------------------------------------------------------------------

void setShaderProgramUniformVec2ui(in ShaderProgram program, in string location, in vec2ui vector) {
    const loc = getShaderLocation(program, location);
    glUniform2uiv(loc, 1, vector.value_ptr);
}

void setShaderProgramUniformVec2ui(in ShaderProgram program, in string location, in int x, in int y) {
    const loc = getShaderLocation(program, location);
    glUniform2ui(loc, x, y);
}

void setShaderProgramUniformVec3ui(in ShaderProgram program, in string location, in vec3ui vector) {
    const loc = getShaderLocation(program, location);
    glUniform3uiv(loc, 1, vector.value_ptr);
}

void setShaderProgramUniformVec3ui(in ShaderProgram program, in string location, in uint x, in uint y, in uint z) {
    const loc = getShaderLocation(program, location);
    glUniform3ui(loc, x, y, z);
}

void setShaderProgramUniformVec4ui(in ShaderProgram program, in string location, in vec4ui vector) {
    const loc = getShaderLocation(program, location);
    glUniform4uiv(loc, 1, vector.value_ptr);
}

void setShaderProgramUniformVec4ui(in ShaderProgram program, in string location, in uint x,in uint y,in uint z,in uint w) {
    const loc = getShaderLocation(program, location);
    glUniform4ui(loc, x, y, z, w);
}

// Matrix ------------------------------------------------------------------------------------------

void setShaderProgramUniformMatrix(in ShaderProgram program, in string location, in mat4 matrix) {
    const loc = getShaderLocation(program, location);
    glUniformMatrix4fv(loc, 1, GL_TRUE, matrix.value_ptr);
}

void setShaderProgramUniformMatrix2(in ShaderProgram program, in string location, in mat2 matrix) {
    const loc = getShaderLocation(program, location);
    glUniformMatrix2fv(loc, 1, GL_TRUE, matrix.value_ptr);
}

void setShaderProgramUniformMatrix3(in ShaderProgram program, in string location, in mat3 matrix) {
    const loc = getShaderLocation(program, location);
    glUniformMatrix3fv(loc, 1, GL_TRUE, matrix.value_ptr);
}

void setShaderProgramUniformMatrix4(in ShaderProgram program, in string location, in mat4 matrix) {
    const loc = getShaderLocation(program, location);
    glUniformMatrix4fv(loc, 1, GL_TRUE, matrix.value_ptr);
}

void setShaderProgramUniformMatrix2x3(in ShaderProgram program, in string location, in mat23 matrix) {
    const loc = getShaderLocation(program, location);
    glUniformMatrix2x3fv(loc, 1, GL_TRUE, matrix.value_ptr);
}

void setShaderProgramUniformMatrix3x2(in ShaderProgram program, in string location, in mat32 matrix) {
    const loc = getShaderLocation(program, location);
    glUniformMatrix3x2fv(loc, 1, GL_TRUE, matrix.value_ptr);
}

void setShaderProgramUniformMatrix2x4(in ShaderProgram program, in string location, in mat24 matrix) {
    const loc = getShaderLocation(program, location);
    glUniformMatrix2x4fv(loc, 1, GL_TRUE, matrix.value_ptr);
}

void setShaderProgramUniformMatrix4x2(in ShaderProgram program, in string location, in mat42 matrix) {
    const loc = getShaderLocation(program, location);
    glUniformMatrix4x2fv(loc, 1, GL_TRUE, matrix.value_ptr);
}

void setShaderProgramUniformMatrix3x4(in ShaderProgram program, in string location, in mat34 matrix) {
    const loc = getShaderLocation(program, location);
    glUniformMatrix3x4fv(loc, 1, GL_TRUE, matrix.value_ptr);
}

void setShaderProgramUniformMatrix4x3(in ShaderProgram program, in string location, in mat43 matrix) {
    const loc = getShaderLocation(program, location);
    glUniformMatrix4x3fv(loc, 1, GL_TRUE, matrix.value_ptr);
}
